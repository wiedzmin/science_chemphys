# -*- coding: utf-8 -*-
#!/usr/bin/env python
from argparse import ArgumentParser
from collections import defaultdict
import os

FIELDS_ORDER = ['Eini', 'Erel', 'b', 'tet', 'fi', 'Emolec', 'Eout', 'Evib',
                'Erot', 'v', 'j']

PREFIX_LEN = 2

CSV_DATA_DELIM = ";"
CSV_ITEM_DELIM = "\n"

COMMON_DATA_DELIM = "\n"
COMMON_ITEM_DELIM = "====\n"


def list_input_files(prefix='', cwd='.'):
    real_cwd = os.path.abspath(cwd)
    for filename in os.listdir(real_cwd):
        if filename.endswith('txt') and filename.startswith(prefix):
            yield real_cwd + '/' + filename


def get_line_as_dict(test_line):
    return {key: value.replace(',', '.')
            for key, value
            in dict(zip(FIELDS_ORDER,
                        test_line.split())).items()}


def get_last_input_line(filename):
    input_lines = None
    with open(filename, 'r') as f:
        input_lines = f.read()
    last_line = input_lines.split('\n')[-2]
    return last_line


def extract_filename_traits(filename):
    filename = os.path.basename(filename)
    center_start = filename.find('Center')
    initpoint_start = filename.find('InitPoint')
    if center_start > 0:
        energies_str = filename[PREFIX_LEN:center_start]
        number_str = filename[center_start + 6: filename.rindex('.')]
        return (energies_str, number_str)
    elif initpoint_start > 0:
        traits_str = filename[initpoint_start+9: filename.rindex('.')]
        if len(traits_str) > 4 and traits_str.startswith('1010'):
            energies_str = traits_str[:4]
            number_str = traits_str[4:]
        elif len(traits_str) <= 4 and (traits_str.startswith('10') or traits_str[1:].startswith('10')):
            energies_str = traits_str[:3]
            number_str = traits_str[3:]
        else:
            energies_str = traits_str[:2]
            number_str = traits_str[2:]
        return (energies_str, number_str)
    else:
        raise ValueError("Invalid filename")


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


def collect_data(prefix, path):
    sets = defaultdict(list)
    sets_order = []
    for filename in list_input_files(prefix, path):
        try:
            set_trait = extract_filename_traits(filename)[0]
        except ValueError:
            continue
        if set_trait not in sets:
            sets_order.append(set_trait)
        sets[set_trait].append(
            get_line_as_dict(get_last_input_line(filename)))
    return (sets_order, sets)


def get_optimum(set_, reverse=False):
    sorted_output = sorted(set_, key=lambda x: float(x['Emolec']))
    if reverse:
        sorted_output = reversed(sorted_output)
    return sorted_output[0]


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
    parser.add_argument("--path", dest="path",
                        type=str,
                        help="Path to search for input files")
    return parser.parse_args()


if __name__ == "__main__":
    args = get_args()
    sets_order, sets = collect_data(args.prefix, args.path or ".")
    with open('output_' + args.prefix.lower() + '.txt',
              'w' if args.rewrite else 'a') as f:
        for set_ in sets_order:
            write_item(get_optimum(sets[set_]), f, args.use_csv)
            write_delimiters(f, args.use_csv)
    for set_ in sets_order:
        with open('output_' + args.prefix.lower() + '_all.txt',
                  'w' if args.rewrite else 'a') as f:
            f.write("============= using energies '{0}' =============\n".format(set_))
            for item in sets[set_]:
                write_item(item, f, args.use_csv)
                write_delimiters(f, args.use_csv)
