# -*- coding: utf-8 -*-
#!/usr/bin/env python
from argparse import ArgumentParser
import os

FIELDS_ORDER = ['Eini', 'Erel', 'b', 'tet', 'fi', 'Emolec', 'Eout', 'Evib',
                'Erot', 'v', 'j']

CSV_DATA_DELIM = ";"
COMMON_DATA_DELIM = "\n"
CSV_ITEM_DELIM = "\n"
COMMON_ITEM_DELIM = "====\n"


def get_input_file_number(filename):
    return int(filename[filename.rindex('r') + 1: filename.rindex('.')])


class TabularData:
    def __init__(self, args, data):
        self.args = args
        self.items_of_interest = data
        self.content = []
        self.current_item = []
        self.use_csv = args.use_csv
        self.use_xls = args.use_xls
        self.reset = False
        if args.use_csv:
            self.data_delimiter = CSV_DATA_DELIM
            self.item_delimiters = CSV_ITEM_DELIM
        elif not args.use_xls:
            self.data_delimiter = COMMON_DATA_DELIM
            self.item_delimiters = COMMON_ITEM_DELIM
        else:
            self.data_delimiter = self.item_delimiters = None

    def new_line(self):
        self.reset = True
        pass

    def append(self):
        self.reset = False

    def write_header_csv(self, f):
        for key in FIELDS_ORDER:
            f.write(key)
            if key != FIELDS_ORDER[-1]:
                f.write(CSV_DATA_DELIM)
        f.write(CSV_ITEM_DELIM)

    def write_item(self, item, f, use_csv):
        for key in FIELDS_ORDER:
            if use_csv:
                f.write(item[key])
                if key != FIELDS_ORDER[-1]:
                    f.write(CSV_DATA_DELIM)
            else:
                f.write(key + ': ' + item[key] + COMMON_DATA_DELIM)

    def write_delimiters(self, f, use_csv):
        if use_csv:
            f.write(CSV_ITEM_DELIM)
        else:
            f.write(COMMON_ITEM_DELIM)

    def run(self):
        sorted_output = sorted(self.items_of_interest, key=lambda x: float(x['Emolec']))
        min_emolec_item = sorted_output[0]
        is_write_header = self.args.rewrite and self.args.use_csv
        with open('output_' + self.args.prefix.lower() + '.txt', 'w' if self.args.rewrite else 'a') as f:
            if is_write_header:
                self.write_header_csv(f)
            self.write_item(min_emolec_item, f, self.args.use_csv)
            self.write_delimiters(f, self.args.use_csv)
        with open('output_' + self.args.prefix.lower() + '_all.txt', 'w' if self.args.rewrite else 'a') as f:
            if is_write_header:
                self.write_header_csv(f)
            for item in sorted_output:
                self.write_item(item, f, self.args.use_csv)
                self.write_delimiters(f, self.args.use_csv)


class InputData:
    def __init__(self, args):
        self.args = args
        self.prefix = args.prefix
        self.items_of_interest = []

    def get_data(self):
        if not self.items_of_interest:
            for file in self.list_input_files(self.args.prefix):
                self.items_of_interest.append(
                    self.get_line_as_dict(self.get_last_input_line(file)))
        return self.items_of_interest

    def get_line_as_dict(self, test_line):
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

    def list_input_files(self, prefix='', cwd='.'):
        for file in os.listdir(cwd):
            if file.endswith('txt') and file.startswith(prefix):
                yield file

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
    input = InputData(args)
    output = TabularData(args, input.get_data())
    output.run()
