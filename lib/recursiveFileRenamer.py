#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import re


def snake_case(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()


def main():
    path = os.getcwd()
    filenames = os.listdir(path)

    for (dir, subdir, listfilename) in os.walk(path):
        for filename in listfilename:
            src = os.path.join(dir, filename)  # NOTE CHANGE HERE
            dst = os.path.join(dir,snake_case(filename))  # AND HERE
            os.rename(src, dst)


if __name__ == '__main__':
    main()
