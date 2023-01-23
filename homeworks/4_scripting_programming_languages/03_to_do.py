#!/usr/bin/env python3

import os
import sys
import json
import yaml


def main(file):
    filename, file_extension = os.path.splitext(file)
    if file_extension == '.json':
        try:
            with open(file, 'r') as json_in:
                json_object = json.load(json_in)
                with open(f'{filename}.yml', 'w') as yml_out:
                    yaml.dump(json_object, yml_out)
        except json.decoder.JSONDecodeError:
            print(f'{file} - the file in not JSON')

    elif file_extension in ('.yml', '.yaml'):
        with open(file, 'r') as yml_in:
            lines = yml_in.readlines()
            if lines[0] != '{\n' and lines[-1] != '}':
                yml_in.seek(0)
                yml_object = yaml.safe_load(yml_in)
                with open(f'{filename}.json', 'w') as json_out:
                    json.dump(yml_object, json_out)
            else:
                print(f'{file} - the file is not YAML')
    else:
        print('The file is not JSON or YAML')


if __name__ == "__main__":
    try:
        main(os.path.join(sys.argv[1]))
    except IndexError:
        print('Specify the path to the file')