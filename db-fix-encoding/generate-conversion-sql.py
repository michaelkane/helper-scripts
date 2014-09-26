import logging

log_level = logging.INFO
log_formatter = logging.Formatter()
#log_formatter = logging.Formatter('[%(asctime)s][%(name)s][%(levelname)s] - %(message)s')

logger = logging.getLogger('generate-conversion-sql')

def setup_logger(logger, level, formatter=None):
    logger.setLevel(level)

    if logger.handlers:
        handler = logger.handlers[0]
    else:
        handler = logging.StreamHandler()
        logger.addHandler(handler)

    if formatter:
        handler.setFormatter(formatter)
    handler.setLevel(level)

setup_logger(logger, log_level, log_formatter)


input_file = 'columns.sql'
output_file = 'fix-encoding.sql'

table_data = {}

# output format
table_to_latin = 'alter table `{table}` CONVERT TO CHARACTER SET latin1;\n'
column_to_binary = 'alter table `{table}` modify `{column}` {data_defn} character set binary {null_string};\n'
column_to_utf8 = 'alter table `{table}` modify `{column}` {data_defn} character set utf8 {null_string};\n'
table_to_utf8 = 'alter table `{table}` CONVERT TO CHARACTER SET utf8;\n'

with open(input_file, 'r') as f:
    logger.info('Opening file: %s' % input_file)
    for line in f:
        logger.debug('Reading line: %s' % line)

        # Lines starting with + are ignored
        if line.strip()[0] == '+':
            logger.debug('Ignoring... (Begins with \'+\')')
            continue

        logger.debug('Processing...')

        _, table, column, data_type, data_length, nullable, _ = [c.strip() for c in line.split('|')]
        
        logger.debug(table)


        if data_type.lower() == 'varchar':
            data_defn = data_type + '(' + data_length + ')'
        elif data_type.lower() == 'text':
            data_defn = data_type
        else:
            raise Exception('Unknown data type: %s' % data_type)
        null_string = ''
        if nullable.lower() == 'no':
            null_string = 'not null'


        if table not in table_data:
            table_data[table] = []

        table_data[table].append({
                'table': table,
                'column': column,
                'data_type': data_type,
                'data_length': data_length, 
                'nullable': nullable,
                'data_defn': data_defn,
                'null_string': null_string
                })

    logger.info('Closing file: %s' % input_file)
    f.close()
         
with open(output_file, 'w') as f:
    logger.info('Opening file: %s' % output_file)

    for table in table_data:
        f.write(table_to_latin.format(table=table))

        for column_info in table_data[table]:
            logger.debug(column_info)

            f.write(column_to_binary.format(**column_info))
            f.write(column_to_utf8.format(**column_info))

        f.write(table_to_utf8.format(table=table))

    logger.info('Closing file: %s' % output_file)
    f.close()
