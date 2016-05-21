# -*- coding: utf-8 -*-
#!/usr/bin/env python
from argparse import ArgumentParser
import os

FIELDS_ORDER = ['Eini', 'Erel', 'b', 'tet', 'fi', 'Emolec', 'Eout', 'Evib',
                'Erot', 'v', 'j']

PREFIX_LEN = 2

CSV_DATA_DELIM = ";"
CSV_ITEM_DELIM = "\n"

COMMON_DATA_DELIM = "\n"
COMMON_ITEM_DELIM = "====\n"


def list_input_files(prefix='', cwd='.'):
    for filename in os.listdir(cwd):
        if filename.endswith('txt') and filename.startswith(prefix):
            yield filename


def get_line_as_dict(test_line):
    return {key: value.replace(',', '.')
            for key, value
            in dict(zip(FIELDS_ORDER,
                        test_line.split())).items()}


def extract_filename_traits(filename):
    center_start = filename.find('Center')
    energies_str = filename[PREFIX_LEN:center_start]
    number_str = filename[center_start + 6: filename.rindex('.')]
    return (energies_str, number_str)


def write_header_csv(f):
    f.write(CSV_DATA_DELIM.join(FIELDS_ORDER))
    f.write(CSV_ITEM_DELIM)


def write_delimiters(f, use_csv):
    f.write(CSV_ITEM_DELIM if use_csv else COMMON_ITEM_DELIM)


def write_item(item, f, use_csv):
    if use_csv:
        result = CSV_DATA_DELIM.join([item[key]
                                      for key in FIELDS_ORDER])
    else:
        result = COMMON_DATA_DELIM.join([key + ': ' + item[key]
                                         for key in FIELDS_ORDER]) + \
                                             COMMON_DATA_DELIM
    f.write(result)


class TabularData:
    def __init__(self, args, data):
        self.args = args
        self.items_of_interest = data
        self.content = []
        self.current_item = []
        self.use_csv = args.use_csv
        if args.use_csv:
            self.data_delimiter = CSV_DATA_DELIM
            self.item_delimiters = CSV_ITEM_DELIM
        else:
            self.data_delimiter = self.item_delimiters = None

    def run(self):
        sorted_output = sorted(self.items_of_interest, key=lambda x: float(x['Emolec']))
        min_emolec_item = sorted_output[0]
        is_write_header = self.args.rewrite and self.args.use_csv
        with open('output_' + self.args.prefix.lower() + '.txt', 'w' if self.args.rewrite else 'a') as f:
            if is_write_header:
                write_header_csv(f)
            write_item(min_emolec_item, f, self.args.use_csv)
            write_delimiters(f, self.args.use_csv)
        with open('output_' + self.args.prefix.lower() + '_all.txt', 'w' if self.args.rewrite else 'a') as f:
            if is_write_header:
                write_header_csv(f)
            for item in sorted_output:
                write_item(item, f, self.args.use_csv)
                write_delimiters(f, self.args.use_csv)


class InputData:
    def __init__(self, prefix):
        self.args = args
        self.prefix = prefix
        self.items_of_interest = []

    def get_data(self):
        if not self.items_of_interest:
            for filename in list_input_files(self.prefix):
                self.items_of_interest.append(
                    get_line_as_dict(self.get_last_input_line(filename)))
        return self.items_of_interest

    def get_last_input_line(self, filename):
        input_lines = None
        with open(filename, 'r') as f:
            input_lines = f.read()
        last_line = input_lines.split('\n')[-2]
        return last_line


def get_args():
    parser = ArgumentParser(description='Arguments for computation.')
    parser.add_argument("prefix", type=str,
                        help="specify file prefix, e.g Xe, Kr or Hg")
    parser.add_argument("-r", "--rewrite", dest="rewrite",
                        action="store_true",
                        help="Rewrite output file")
    parser.add_argument("--csv", dest="use_csv",
                        action="store_true",
                        help="Write CSV output")
    return parser.parse_args()


if __name__ == "__main__":
    args = get_args()
    input = InputData(args.prefix)
    output = TabularData(args, input.get_data())
    output.run()
