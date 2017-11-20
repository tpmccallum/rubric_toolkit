import os
import sys
import re
sys.path.append("../utils")
import xml_util


def resolveMissingDatastreams(directory, datastreamId):
    #Iterate through objects directory
    for root, dirs, files in os.walk(path):
        #for foxml object in foxml objects
        for file in files:
            #get a list of potential missing datastreams for one foxml object
            dsList = getMissingDatastreams(file, datastreamId)
            #iterate through potential missing datastreams while fixing 
            processMissingDatastreams(dsList) 
            
def getMissingDatastreams(file, datastreamId):
    xpath = "//*[local-name()='datastream'][@ID='%s']" % (datastreamId)
    #xpath = "//*[local-name()='datastream'][@ID='FULLTEXT']"
    print xpath
    xml = xml_util.xml(file)
    dsList = xml.getNodes(xpath)
    for d in dsList:
        print d
    return dsList

def processMissingDatastreams(dsList):
    for datastream in dsList:
        #extract the official fedora timestamp from the foxml
        timestamp = getTimestamp(datastream)
        pid = getPid(datastream)
        fileName = pid + "+" + datastreamId + "+" + datastreamId + ".0"
        timestampDir = calculateDate(timestamp)
        dirExists = dirExists(timestampDir)
        if dirExists == False:
            makeTimestampDir(timestampDir)
        fileExists = fileExists(timestampDir, fileName)
        if fileExists == False:
            locateFile(fileName)
            moveFileIntoCorrectDir(timestampDir, fileName)



        
def getTimestamp(node):
    pass

def getPid(node):
    #TODO transform uon:456 to uon_456
    pass

def calculateDate(timestamp):
    pass
     
def dirExists():
    pass
        
def makeTimestampDir():
    pass
    
def fileExists():
    pass
        
def locateFile():
    pass
    
def moveFileIntoCorrectDir(timestampDir, fileName):
    pass
    
arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    length = len(sys.argv)
    if length > 2:
        directory = sys.argv[1]
        datastream = sys.argv[2]   
        findFullTextDirectory(directory, datastreamId) 
    else:
        findFullTextDirectory(directory)