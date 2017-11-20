#    Copyright (C) 2005  Distance and e-Learning Centre, 
#    University of Southern Queensland
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

"""
Name of the script
aanro_dump_to_foxml.py
Purpose of script
The aanro_dump_to_foxml.py script is designed to transform raw AANRO data in the form of a .dmp file into Fedora XML (FOXML). 

Parameters/Arguments
Input (-i)
Full path to the AANRO data file to be transformed (.dmp) file
Output (-o)
Name of directory that transformed files will be sent to (This directory will be created if it does not exist)
Template (-t)
Name of template file to be used in transformation

Syntax
Python aanro_dump_to_foxml.py -i Input -o Output -t Template
Example Research Data
Python aanro_dump_to_foxml.py -i research.dmp -o output_directory -t aanroFoxmlTemplate_research

Example Publication Data
Python aanro_dump_to_foxml.py -i publication.dmp -o output_directory -t aanroFoxmlTemplate
"""

import sys
import re, os, os.path, shutil,urlparse
import xml.sax.saxutils as sax
from Cheetah.Template import Template

class publication:
    def __init__(self):
        self.data = dict()
        for key in keys.split("\n"):
            self.data[key] = ''
keys = """doctype
pubyear
title
author
contactauthor
contactemail
sponsor
source
isbn
issn
series
notes
abstract
keywords
locality
fulltextlink
weblink
availability
availemail
deliverylink
deliveryemail
deliverynote
objectives
program
subprogram
collaboration
implication
background
progress
"""
record = publication().data 

def _getOptions(args, shortOptionNames={"h":"help"}):
  options = {}
  args = list(args)
  args.append(" ")
  numArgs = zip(range(len(args)), args)
  for x, option in [(x, i.lstrip("-").lower()) for x, i in numArgs if i.startswith("-")]:
    value = None
    equalIndex = option.find("=")
    colonIndex = option.find(":")
    if equalIndex>0 and ((colonIndex==-1) or (equalIndex<colonIndex)):
        option, value = numArgs[x][1].split("=", 1)
        option = option.lstrip("-").lower()
    elif colonIndex>0:
        option, value = numArgs[x][1].split(":", 1)
        option = option.lstrip("-").lower()
    option = shortOptionNames.get(option, option)
    if value is None:
        value = numArgs[x+1][1]
        if value.startswith("-"):
            value = " "
    if value.lower()=="false" or value=="0":
        value = False
    options[option] = value
  return options
    

def _parseResearcher(rawData):
    researchers = []
    researchersPlusAffiliations = rawData.split("|") 
    for researcherPlusAffiliation in researchersPlusAffiliations:
        researcher = {'all': researcherPlusAffiliation, 'familyname' : '', 'initials' : '', 'title' : '', 'affilliation' : '', 'address' : ''}
        nameParts = re.match("(.*?) (.*?) (.*?) (.*?) \((.*)\)", researcherPlusAffiliation)
        if nameParts <> None:
            researcher['familyname'] = nameParts.group(1)
            researcher['initials'] = nameParts.group(2)
            researcher['title'] = nameParts.group(3)    
            researcher['affiliation'] = nameParts.group(4)
            researcher['address'] = nameParts.group(5)
            researcher['name'] = nameParts.group(1) + " " + nameParts.group(2)
        researchers.append(researcher)
    return researchers

def _parseAuthor(rawData):
    authors = []
    authorsPlusAffiliations = rawData.split("|") 
    for authorPlusAffiliation in authorsPlusAffiliations:
        author = dict()
        authorAfil = authorPlusAffiliation.split("(")
        name = authorAfil[0].rstrip()
        nameParts = re.match("(.+?)\s+(.*)", name)
        author['name'] = name
        
        if nameParts == None:
            author['familyname'] = name
            author['initials'] = ""
        else:
            author['familyname'] = nameParts.group(1)
            author['initials'] = nameParts.group(2)
            
        if len(authorAfil) > 1:
            author['affiliation'] = authorAfil[1][:-1] 
        else:
            author['affiliation'] = ""
        authors.append(author)
    return authors

def _parseKeyword(rawData):
    return _parseX(rawData)
    

def _parseSponsor(rawData):
    return _parseX(rawData)

def _parseX(rawData):    
    return rawData.split("|")
    
def _makeOutputDir(outputDir, innerDir):
    path = os.path.join(outputDir,repr(innerDir))
    if not os.path.exists(path):
        os.makedirs(path)
    print "Processing - output directory = " + path
    return path

def _aanroToFoxml(inputFile, outputDir):
    rec = 0
    innerDir = 0
    path = _makeOutputDir(outputDir, innerDir)
    f = open(inputFile, 'r')
    currentElement = None
    print "Starting"
    gotRecord = _recordToFoxml(f, rec, path)
    while gotRecord:
        if (rec % 1000) == 0:
            print rec
            if (rec % 10000) == 0:
                    path = _makeOutputDir(outputDir, innerDir)
                    innerDir = innerDir + 1
        gotRecord = _recordToFoxml(f, rec, path)
        rec = rec + 1
       
    
def _recordToHash(file):
    #Read line by line until $ which is the end of a record
    line = file.readline()
    currentKey = None
    while not line.startswith("$"):
        line = line.decode('CP1252').encode('utf-8')
        line = sax.escape(line.rstrip())
        if line.startswith(" "):
            record[currentKey] += line
        elif line.startswith(";"):
            record[currentKey] +=  "|" + line[2:]
        else:
            import re
            content = re.sub("^[^ ]+ ","", line)
            currentKey = re.sub(" .*","", line)  
            record[currentKey] = content   
        line = file.readline()
        if line == "":
            print "done"
            return False
    if record.has_key('researcher'):
        record['researchers'] = _parseResearcher(record['researcher'])
   
    if record.has_key('author'):
        record['authors'] = _parseAuthor(record['author'])
        
    if record.has_key('keywords'):
        record['subjects'] = _parseKeyword(record['keywords'])
    else:
        record['subjects'] = []
        
    if record.has_key('sponsor'):
        record['sponsors'] = _parseSponsor(record['sponsor'])
    else:
        record['sponsors'] = []
    return record

def _recordToFoxml(file, count, outputDir):
    record = _recordToHash(file)
    if not record:
        return False
    title = record['title']
    pidPrefix = "AANRO"
    record['pid'] = pidPrefix + ":" + repr(count)    
    record['objectState'] = "A"
    record['label'] = "Added item" + title
    record['contentModel'] = "Fez"
    foxml = template(searchList=[record])
    fileName = pidPrefix + str(count) + ".xml"
    path = os.path.join(outputDir, fileName)
    open(path, 'w').write(str(foxml))
    return True


	
if __name__ == "__main__":
    args = list(sys.argv)
    args.pop(0)
    options = _getOptions(args, {"i":"input", "o":"output", "t":"template", "h":"help"})
    if "help" in options or not ("input" in options and "output" in options and "template" in options):
       print "Usage %s <input> <output_dir> <template(compiled cheetah)>" % sys.argv[0]
       sys.exit(0)
    inputFile = options["input"]
    outputDir = options["output"]
    templateName = options["template"]
    exec "from %s import %s as template" % (templateName, templateName)
    _aanroToFoxml(inputFile, outputDir)