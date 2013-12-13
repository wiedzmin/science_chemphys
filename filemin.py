# -*- coding: utf-8 -*-
#!/usr/bin/env python
from optparse import OptionParser
import os
import sys

FIELDS_ORDER = ['Eini', 'Erel', 'b', 'tet', 'fi', 'Emolec', 'Eout', 'Evib',
                'Erot', 'v', 'j']


def list_input_files(prefix='', cwd='.'):
    return [file for file in os.listdir(cwd)
            if file.endswith('txt') and file.startswith(prefix)]


def get_input_file_number(filename):
    return int(filename[filename.rindex('r') + 1: filename.rindex('.')])


def get_line_as_dict(test_line):
    result = {}
    items = test_line.split()
    result['Eini'] = items[0]
    result['Erel'] = items[1]
    result['b'] = items[2]
    result['tet'] = items[3]
    result['fi'] = items[4]
    result['Emolec'] = items[5]
    result['Eout'] = items[6]
    result['Evib'] = items[9]
    result['Erot'] = items[10]
    result['v'] = items[11]
    result['j'] = items[12]
    result = {key: value.replace(',', '.')
              for key, value in result.items()}
    return result


def get_last_input_line(filename):
    input_lines = None
    with open(filename, 'r') as f:
        input_lines = f.read()
    last_line = input_lines.split('\n')[-2]
    return last_line


def write_header_csv(f):
    for key in FIELDS_ORDER:
        f.write(key)
        if key != FIELDS_ORDER[-1]:
            f.write(';')
    f.write('\n')


def write_item(item, f, use_csv):
    for key in FIELDS_ORDER:
        if use_csv:
            f.write(item[key])
            if key != FIELDS_ORDER[-1]:
                f.write(';')
        else:
            f.write(key + ': ' + item[key] + '\n')


def write_delimiters(f, use_csv):
    if use_csv:
        f.write('\n')
    else:
        f.write('====\n')


parser = OptionParser(description='Arguments for computation.')
parser.add_option("--prefix", dest="prefix",
                  type="string",
                  help="specify file prefix, e.g Xe, Kr or Hg")
parser.add_option("-r", "--rewrite", dest="rewrite",
                  action="store_true",
                  help="Rewrite output file")
parser.add_option("--csv", dest="use_csv",
                  action="store_true",
                  help="Write CSV output")

(options, args) = parser.parse_args()

if not options.prefix:
    print >>sys.stderr, "filemin: no prefix provided"
    sys.exit(1)
items_of_interest = []
for file in list_input_files(options.prefix):
    items_of_interest.append(get_line_as_dict(get_last_input_line(file)))
sorted_output = sorted(items_of_interest, key=lambda x: float(x['Emolec']))
min_emolec_item = sorted_output[0]
with open('output_' + options.prefix.lower() + '.txt', 'w' if options.rewrite else 'a') as f:
    if options.rewrite and options.use_csv:
        write_header_csv(f)
    write_item(min_emolec_item, f, options.use_csv)
    write_delimiters(f, options.use_csv)
with open('output_' + options.prefix.lower() + '_all.txt', 'w' if options.rewrite else 'a') as f:
    if options.rewrite and options.use_csv:
        write_header_csv(f)
    for item in sorted_output:
        write_item(item, f, options.use_csv)
        write_delimiters(f, options.use_csv)
