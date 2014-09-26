/**
 * Send a signed request to Twitter using php curl
 *
 * Examples
 * ========
 *
 * Basic Search:
 * 
 *   $tr = new TwitterRequest('GET', '/search/tweets.json');
 *   
 *   $tr->consumer_key = $app['consumer_key'];
 *   $tr->consumer_secret = $app['consumer_secret'];
 *   $tr->access_token = $user['access_token'];
 *   $tr->access_token_secret = $user['access_token_secret'];
 *
 *   $tr->parameters['q'] = 'from:@stephenfry';
 *   $tr->parameters['count'] = 10;
 *   $tr->parameters['result_type'] = 'recent';
 *   $tr->parameters['include_entities'] = '1';
 *
 *   $tr->raise_exception_on_curl_error = true;
 *
 *   // Get data from twitter
 *   $tr->get_response();
 *
 *   // Have a look
 *   var_dump($tr->response->body);
 * 
 * 
 * Status Post:
 *
 *   $tr = new TwitterRequest('POST', '/status/update.json');
 *   
 *   $tr->consumer_key = $app['consumer_key'];
 *   $tr->consumer_secret = $app['consumer_secret'];
 *   $tr->access_token = $user['access_token'];
 *   $tr->access_token_secret = $user['access_token_secret'];
 *   $tr->data = array('status' => 'hello there');
 *   $tr->get_response();
 *
 */
class TwitterRequest
{
  public static $api_url = 'https://api.twitter.com/1.1';

  public $consumer_key = '';
  public $consumer_secret = '';
  public $access_token = '';
  public $access_token_secret = '';

  public $verb;
  public $base_url;
  public $headers = array();
  public $parameters = array();
  public $data = array();

  public $response;

  public $timeout = 0; // No timeout
  public $raise_exception_on_curl_error = false;

  /**
   * Constructor
   *
   * @param string $verb Method verb -- GET or POST
   * @param string $path Twitter API endpoint base path
   *                     -- should begin with '/'
   *                     -- not include any query params
   * @return mixed
   */
  function __construct($verb, $path) {
    if (strpos($path, '?') !== false) {
      throw new TwitterRequestException('Path must not include query parameters');
    }

    $this->verb = $verb;
    $this->base_url = TwitterRequest::$api_url . $path;

    // Set the headers we always want
    $this->headers['Expect'] = ''; // Hack to get past '100 continue' issue

    $this->response = new STDClass;
    $this->response->error = false;
  }


  /**
   * Get the Twitter response
   *
   * @return object | false
   */
  public function get_response() {
    // Ensure we have authentication details
    if (
      !$this->consumer_key
      || !$this->consumer_secret
      || !$this->access_token
      || !$this->access_token_secret
    ) {
      throw new TwitterRequestException('Twitter authentication details must be set');
    }

    $url = $this->base_url;

    // Query Params
    $query = '';
    if (sizeof($this->parameters) > 0)
      {
        $query = substr($url, -1) !== '?' ? '?' : '&';
        foreach ($this->parameters as $var => $value)
          if ($value === null || $value === '') $query .= $var.'&';
          else $query .= $var.'='.rawurlencode($value).'&';
        $query = substr($query, 0, -1);
        $url .= $query;
      }

    // Basic setup
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_USERAGENT, 'mkkTwitterRequest/php');
    curl_setopt($curl, CURLOPT_URL, $url);

    // Headers
    foreach ($this->headers as $header => $value)
      $headers[] = $header.': '.$value;

    // Oauth Header
    $headers []= 'Authorization: '.$this->generate_oauth_header();

    curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($curl, CURLOPT_HEADER, false);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, false);
    curl_setopt($curl, CURLOPT_WRITEFUNCTION, array(&$this, '__responseWriteCallback'));
    curl_setopt($curl, CURLOPT_HEADERFUNCTION, array(&$this, '__responseHeaderCallback'));
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($curl, CURLOPT_TIMEOUT, $this->timeout);

    // Request types
    switch (strtoupper($this->verb))
      {
        case 'GET': break;
        case 'POST':
          curl_setopt($curl, CURLOPT_POST, true);
          if ($this->data !== false)
            curl_setopt($curl, CURLOPT_POSTFIELDS, self::encode_post_data($this->data));
          break;
        default: break;
      }

    // Execute, grab errors
    if (curl_exec($curl))
      $this->response->code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    else
      $this->response->error = array(
        'code' => curl_errno($curl),
        'message' => curl_error($curl),
      );

    @curl_close($curl);

    // Raise exception if asked to
    if ($this->response->error !== false && $this->raise_exception_on_curl_error)
      throw new TwitterRequestException(
        $this->response->error['message'],
        $this->response->error['code']
      );

    // Parse the JSON response
    if ($this->response->error === false && isset($this->response->raw_body))
      {
        $this->response->body = json_decode($this->response->raw_body);
      }

    return $this->response;
  }


  /**
   * CURL write callback
   *
   * @param resource &$curl CURL resource
   * @param string &$data Data
   * @return integer
   */
  private function __responseWriteCallback(&$curl, &$data) {
    $this->response->raw_body = $data;
    return strlen($data);
  }


  /**
   * CURL header callback
   *
   * @param resource &$curl CURL resource
   * @param string &$data Data
   * @return integer
   */
  private function __responseHeaderCallback(&$curl, &$data) {
    if (($strlen = strlen($data)) <= 2) return $strlen;
    if (substr($data, 0, 4) == 'HTTP')
      $this->response->code = (int)substr($data, 9, 3);
    else
      {
        $data = trim($data);
        if (strpos($data, ': ') === false) return $strlen;
        list($header, $value) = explode(': ', $data, 2);
        $this->response->headers[$header] = trim($value);
      }
    return $strlen;
  }


  // See https://dev.twitter.com/docs/auth/authorizing-request
  private function generate_oauth_header() {
    $oauth_params = array(
      'oauth_consumer_key' => $this->consumer_key,
      'oauth_nonce' => TwitterRequest::generate_nonce(),
      'oauth_signature_method' => 'HMAC-SHA1',
      'oauth_timestamp' => time(),
      'oauth_token' => $this->access_token,
      'oauth_version' => '1.0'
    );
    $oauth_params['oauth_signature'] = $this->generate_oauth_signature($oauth_params);

    $header_string = 'Oauth ';
    foreach($oauth_params as $key => $value) {
      $header_string .= rawurlencode($key).'="'.rawurlencode($value).'", ';
    }
    // Get rid of the extra ', '
    $header_string = substr($header_string, 0, -2);

    return $header_string;
  }


  // See https://dev.twitter.com/docs/auth/creating-signature
  private function generate_oauth_signature($oauth_params) {
    // all oauth params, query params, and post data need to be signed
    $all_key_vals = $oauth_params + $this->parameters + $this->data;

    $all_key_vals_encoded = array();
    foreach ($all_key_vals as $key => $val)
      $all_key_vals_encoded[rawurlencode($key)] = rawurlencode($val);

    ksort($all_key_vals_encoded);
    $parameter_string = '';
    foreach ($all_key_vals_encoded as $key => $val)
      $parameter_string .= $key.'='.$val.'&';
    // Get rid of the extra '&'
    $parameter_string = substr($parameter_string, 0, -1);

    $signature_base_string = strtoupper($this->verb)
      .'&'
      .rawurlencode($this->base_url)
      .'&'
      .rawurlencode($parameter_string);

    $signing_key = rawurlencode($this->consumer_secret)
      .'&'
      .rawurlencode($this->access_token_secret);

    $oauth_signature = base64_encode(hash_hmac('sha1', $signature_base_string, $signing_key, true));

    return $oauth_signature;
  }


  // Nabbed from http://stackoverflow.com/questions/4356289/php-random-string-generator#answer-14802553
  private static function generate_nonce($len = 32) {
    $rnd='';
    for($i=0;$i<$len;$i++) {
      do {
        $byte = openssl_random_pseudo_bytes(1);
        $asc = chr(base_convert(substr(bin2hex($byte),0,2),16,10));
      } while(!ctype_alnum($asc));
      $rnd .= $asc;
    }
    return $rnd;
  }

  private static function encode_post_data($data) {
    $encoded='';
    foreach ($data as $k => $v){
      if (strlen($encoded) > 0)
        $encoded .= '&';
      $encoded .= urlencode($k).'='.urlencode($v);
    }
    return $encoded;
  }

}


class TwitterRequestException extends Exception {
  function __construct($message, $code = 0, Exception $previous = null) {
    parent::__construct($message, $code, $previous);
  }
}
