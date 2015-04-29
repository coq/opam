#! /usr/bin/python
# coding=utf8

import sys
import os
import glob
import re
import string
import subprocess
import shutil
import tarfile
import pickle
import simplejson as json


# 
# Parsing description files
# 

# The keys occurring in description files
NAMEKEY='Name'
URLKEY = 'Url'
AUTHORKEY = 'Author'
EMAILKEY = 'Email'
HOMEPAGEKEY = 'Homepage'
ADDRESSKEY = 'Address'
INSTKEY = 'Institution'
LICKEY = 'License'
DESCKEY = 'Description'
KWKEY = 'Keywords'
TITLEKEY = 'Title'
CATKEY = 'Category'
REFKEY = 'References'
REQUIREKEY = 'Require'
AVAILABILITYKEY = 'Availability'

# Name of usual encodings:
UTF8 = 'utf-8'
LATIN = 'iso-8859-15'

# 'Normalization' of strings
def recode(s):
  try:
    us = s.decode(UTF8)
  except:
    us = s.decode(LATIN)
  return(us)

def parse_description(dir):
  """ Parses a description file and returns a dictionary associating a
      field name to a string """

  desc_file = os.path.join(dir, 'description')
  fdesc = open(desc_file)

  res={}
  res[AUTHORKEY] = {}

  exp = '^([a-zA-Z]+)[ \t]*:[ \t]*(.*)$'

  last_key=""
  last_authors=[]
  for line in fdesc.readlines():
    lg = recode(line)

    m  = re.match(exp, lg)
    if m != None:
      key = m.group(1)
      rem = m.group(2)

      if key in [KWKEY, CATKEY, REQUIREKEY]:
        # rem may be a list of strings
        l = []
        for e in rem.split(','):
          f = string.strip(e)
          if f != '':
            if key == KWKEY:
              # we perform some 'normalization'
              f = f.lower()
              f = f.replace('-', ' ')
              f = f.replace('_', ' ')
            l.append(f)

        # CATKEY, KWKEY and REQUIREKEY may appear several times
        if res.has_key(key):
          res[key].extend(l)
        else:
          res[key] = l

      elif key == AUTHORKEY:
        # TODO: parse author lines of the form 'Firstname Lastname <email@home.com>'
        last_authors.append(rem)
        res[AUTHORKEY][rem] = {}
      elif key in [INSTKEY, EMAILKEY, HOMEPAGEKEY, ADDRESSKEY]:
        # One INSTKEY may reports to many authors
        for a in last_authors:
          if not res[AUTHORKEY][a].has_key(key): 
            res[AUTHORKEY][a][key] = rem
            if key != INSTKEY: 
              break
      elif key == URLKEY:
        # Check if rem if a valid url
        if re.match('http://', rem) != None:
          res[key] = rem
      else:
        if key == DESCKEY:
          res[key] = rem + '\n'
        else:
          res[key] = rem

      last_key = key
    else:
      # This is a continuation line, appends it to the last key 
      if last_key != "":
        if last_key in [KWKEY, CATKEY, REQUIREKEY]:
          # rem may be a list of strings
          for e in lg.split(','):
            f = string.strip(e)
            if f != '':
              if key == KWKEY:
                # we perform some 'normalization'
                f = f.lower()
                f = f.replace('-', ' ')
                f = f.replace('_', ' ')
              res[last_key].append(f)
        elif (last_key in  [INSTKEY, ADDRESSKEY]):
          auttab = res[AUTHORKEY][last_authors[len(last_authors)-1]]
          if auttab.has_key(last_key):
            auttab[last_key] = auttab[last_key] + ' ' + lg
        elif not (last_key in [AUTHORKEY, EMAILKEY, HOMEPAGEKEY]):
          res[last_key] = res[last_key] + ' ' + lg

  fdesc.close()
  return res
  
def descr_to_json(d):
    x = parse_description(d)
    print(json.dumps(x))

if __name__ == '__main__':
    sys.exit(descr_to_json(sys.argv[1]))

#if __name__ == '__main__':
#  sys.exit(main())
