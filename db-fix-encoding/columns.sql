+  select 
+    TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
+  from
+    information_schema.columns 
+  where
+    table_schema = '4music' 
+    and (DATA_TYPE = 'varchar' or data_type = 'text');
+
+------------------------+-----------------------+-----------+--------------------------+-------------+
+ TABLE_NAME             | COLUMN_NAME           | DATA_TYPE | CHARACTER_MAXIMUM_LENGTH | IS_NULLABLE |
+------------------------+-----------------------+-----------+--------------------------+-------------+
| awkward_photo          | reference             | varchar   |                       30 | NO          |
| awkward_photo          | image_src             | varchar   |                      200 | NO          |
| awkward_photo          | down_src              | varchar   |                      200 | NO          |
| awkward_photo          | status                | varchar   |                       20 | NO          |
| awkward_photo_template | reference             | varchar   |                       40 | NO          |
| awkward_photo_template | thumbnail             | varchar   |                      250 | NO          |
| awkward_photo_template | png_original          | varchar   |                      200 | NO          |
| awkward_photo_template | status                | varchar   |                       20 | NO          |
| background             | reference             | varchar   |                      100 | NO          |
| capri_sun_competition  | title                 | varchar   |                      255 | NO          |
| capri_sun_competition  | title_media_path      | varchar   |                      300 | YES         |
| capri_sun_competition  | content               | varchar   |                     2000 | NO          |
| capri_sun_competition  | facebook_url          | varchar   |                      500 | NO          |
| capri_sun_competition  | status                | varchar   |                       20 | NO          |
| chart_entry            | title                 | varchar   |                      255 | NO          |
| chart_entry            | subtitle              | varchar   |                      255 | NO          |
| chart_entry            | link_title            | varchar   |                      255 | NO          |
| chart_entry            | link_subtitle         | varchar   |                      255 | NO          |
| chart_entry            | summary               | varchar   |                      200 | YES         |
| chart_instance         | voting_content        | text      |                    65535 | YES         |
| chart_instance         | voting_end_content    | text      |                    65535 | YES         |
| chart_instance         | voting_thanks_content | text      |                    65535 | YES         |
| chart_vote             | uuid                  | varchar   |                       30 | NO          |
| competition            | question              | varchar   |                      255 | YES         |
| competition            | option_0              | varchar   |                      255 | YES         |
| competition            | option_1              | varchar   |                      255 | YES         |
| competition            | option_2              | varchar   |                      255 | YES         |
| competition            | option_3              | varchar   |                      255 | YES         |
| competition            | option_4              | varchar   |                      255 | YES         |
| competition            | option_5              | varchar   |                      255 | YES         |
| competition            | option_6              | varchar   |                      255 | YES         |
| competition            | option_7              | varchar   |                      255 | YES         |
| competition            | option_8              | varchar   |                      255 | YES         |
| competition            | option_9              | varchar   |                      255 | YES         |
| competition            | freetext_question     | varchar   |                      255 | YES         |
| competition            | t_and_c               | text      |                    65535 | YES         |
| competition            | thanks                | text      |                    65535 | YES         |
| competition            | csv_filename          | varchar   |                       70 | NO          |
| competition            | checkbox_copy         | varchar   |                     1000 | YES         |
| content                | uuid                  | varchar   |                       15 | NO          |
| content                | related_type          | varchar   |                      100 | NO          |
| content                | title                 | varchar   |                      255 | NO          |
| content                | clean_title           | varchar   |                      255 | NO          |
| content                | summary               | varchar   |                      100 | YES         |
| content                | content               | text      |                    65535 | NO          |
| content                | featured_blurb        | text      |                    65535 | YES         |
| content                | meta_title            | varchar   |                      100 | YES         |
| content                | meta_description      | varchar   |                      165 | YES         |
| content                | twitter_names         | varchar   |                      500 | YES         |
| content                | old_url               | varchar   |                      500 | YES         |
| content                | status                | varchar   |                       20 | NO          |
| cover_media            | remote_id             | varchar   |                      100 | NO          |
| cover_media            | revision              | varchar   |                       10 | NO          |
| cover_media_category   | name                  | varchar   |                      100 | NO          |
| crush_news             | author                | varchar   |                      255 | YES         |
| crush_photoframe       | reference             | varchar   |                      100 | NO          |
| crush_photoframe       | link_href             | varchar   |                      300 | YES         |
| crush_photoframe       | link_label            | varchar   |                      150 | YES         |
| error_log              | server                | varchar   |                      200 | YES         |
| error_log              | message               | varchar   |                     1000 | YES         |
| gallery                | site                  | varchar   |                      100 | YES         |
| hijack_artist          | slug                  | varchar   |                      100 | NO          |
| hijack_category        | title                 | varchar   |                      100 | NO          |
| hijack_submission      | reference             | varchar   |                      100 | NO          |
| hijack_submission      | youtube_url           | varchar   |                      200 | NO          |
| hijack_submission      | youtube_id            | varchar   |                       20 | NO          |
| hijack_submission      | title                 | varchar   |                      200 | NO          |
| hijack_submission      | thumbnail_url         | varchar   |                      500 | NO          |
| hijack_submission      | status                | varchar   |                       50 | NO          |
| hit_miss_summary       | uuid                  | varchar   |                       20 | NO          |
| hit_miss_vote          | uuid                  | varchar   |                       20 | NO          |
| hit_miss_vote          | user_id               | varchar   |                       20 | NO          |
| homepage_pick          | title                 | varchar   |                       50 | YES         |
| homepage_pick          | description           | varchar   |                      100 | YES         |
| homepage_pick          | link_href             | varchar   |                      300 | YES         |
| homepage_pick          | link_label            | varchar   |                      300 | YES         |
| homepage_pick          | status                | varchar   |                       10 | NO          |
| homepage_video         | title                 | varchar   |                      100 | NO          |
| homepage_video         | status                | varchar   |                       10 | NO          |
| media                  | uuid                  | varchar   |                       15 | NO          |
| media                  | media_type            | varchar   |                       20 | NO          |
| media                  | reference             | varchar   |                      200 | NO          |
| media                  | credits               | varchar   |                      500 | YES         |
| media                  | caption               | varchar   |                      500 | YES         |
| media                  | description           | text      |                    65535 | YES         |
| media                  | client_name           | varchar   |                      200 | YES         |
| media                  | image_type            | varchar   |                       10 | YES         |
| media                  | source_url            | varchar   |                      500 | YES         |
| media                  | remote_id             | varchar   |                      100 | YES         |
| media                  | status                | varchar   |                       20 | NO          |
| news                   | author                | varchar   |                      255 | YES         |
| news                   | remote_source         | varchar   |                       30 | YES         |
| news_category          | title                 | varchar   |                      200 | NO          |
| news_category          | slug                  | varchar   |                      200 | NO          |
| news_category          | landing_position      | varchar   |                       20 | YES         |
| promo                  | title                 | varchar   |                      255 | NO          |
| promo                  | title_vertical        | varchar   |                       25 | YES         |
| promo                  | content               | text      |                    65535 | YES         |
| promo                  | link_href             | varchar   |                      300 | YES         |
| promo                  | link_label            | varchar   |                      150 | YES         |
| redirect               | short                 | varchar   |                      100 | NO          |
| redirect               | url                   | varchar   |                     2000 | NO          |
| show                   | brand_title           | varchar   |                      150 | YES         |
| show_slot              | remote_id             | varchar   |                      100 | YES         |
| show_slot              | brand_title           | varchar   |                      150 | YES         |
| show_slot              | title                 | varchar   |                      250 | NO          |
| show_slot              | summary               | varchar   |                     1500 | YES         |
| show_slot              | status                | varchar   |                       20 | NO          |
| show_slot_map          | map_type              | varchar   |                       20 | YES         |
| show_slot_map          | remote_id             | varchar   |                      100 | YES         |
| site_global            | c4_header             | text      |                    65535 | YES         |
| site_global            | c4_footer             | text      |                    65535 | YES         |
| site_global            | c4_css                | text      |                    65535 | YES         |
| site_global            | c4_script             | text      |                    65535 | YES         |
| site_global            | cache_buster          | varchar   |                       20 | YES         |
| tag                    | title                 | varchar   |                      150 | NO          |
| tag                    | type                  | varchar   |                       20 | NO          |
| tweet                  | tw_id_str             | varchar   |                      100 | YES         |
| tweet                  | tw_text               | varchar   |                      255 | YES         |
| tweet                  | tweet_json            | text      |                    65535 | NO          |
| twit                   | screen_name           | varchar   |                       20 | NO          |
| twit                   | max_id                | varchar   |                       50 | NO          |
| twit                   | tw_profile_image_url  | varchar   |                      255 | YES         |
| user                   | username              | varchar   |                      255 | NO          |
| user                   | password              | varchar   |                      255 | NO          |
| user                   | forgot_uuid           | varchar   |                       13 | YES         |
| user                   | email                 | varchar   |                      255 | NO          |
| video_honour           | title                 | varchar   |                      100 | NO          |
| video_honour           | leading_copy          | text      |                    65535 | YES         |
| video_honour           | finished_copy         | text      |                    65535 | YES         |
| video_honour           | thanks_copy           | text      |                    65535 | YES         |
| video_honour           | voting_page_tracking  | varchar   |                     2000 | YES         |
| video_honour           | thanks_page_tracking  | varchar   |                     2000 | YES         |
| video_honour_category  | answer_type           | varchar   |                       30 | NO          |
| video_honour_category  | title                 | varchar   |                      100 | NO          |
| video_honour_category  | question              | varchar   |                      500 | NO          |
| video_honour_option    | title                 | varchar   |                      100 | NO          |
| video_honour_vote      | uuid                  | varchar   |                       30 | NO          |
| xmas_image             | status                | varchar   |                       20 | NO          |
| xmas_image             | reference             | varchar   |                      100 | NO          |
+------------------------+-----------------------+-----------+--------------------------+-------------+