#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from md5 import md5

num = 0
dirs = map(str, xrange(10))

for i in dirs:
    filepaths = map(lambda x: os.path.join(i, x), os.listdir(i))
    filepaths = filter(lambda x: x.endswith('.bmp'), filepaths)
    num += len(filepaths)

    j = 0
    for filepath in filepaths:
        id = j
        with open(filepath, 'rb') as fp:
            id = md5(fp.read()).hexdigest()

        os.rename(filepath, '%s_%s.bmp' % (i, id))
        j += 1

print 'Total: %s' % num