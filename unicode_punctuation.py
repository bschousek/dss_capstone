# -*- coding: utf-8 -*-
"""
Created on Thu Jul 16 12:04:59 2015

@author: schoub1
"""

import unicodedata
import sys
tbl=dict.fromkeys(i for i in xrange(sys.maxunicode)
                      if unicodedata.category(unichr(i)).startswith('P'))
def remove_punctuation(text):
    return text.translate(tbl)