
#
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
#

import os
import shutil
class dspaceArchive:
    def __init__(self, name):
        self.name = name
        self.items = []
        if os.path.exists(self.name):
            for d in os.listdir(self.name):
                if os.path.isdir(os.path.join(self.name, d)) and d != '.svn':
                    self.newItem()
                    
        if not(os.path.exists(self.name)):
            os.mkdir(self.name)
            
    def newItem(self):
        itemNo = len(self.items)
        item = dspaceItem(repr(itemNo), dir = self.name)
        self.items.append(item)
        return item
    
    def writeIndexPage(self, html):
        filename = os.path.join(self.name, "index.html")
        output = open(filename, 'wb')
        if html == None:
            html = ""
        output.write(html)
        output.close()
     
    def delete(self):
        shutil.rmtree(self.name)
        
class dspaceItem:
    def __init__(self, name, dir = "."):
            self.name = name
            self.dir = os.path.join(dir, name)
            self.contents = dict()
            if os.path.exists(self.dir):
                contentsPath = os.path.join(self.dir,'contents')
                for line in open(contentsPath,'r'):
                    if line.find("\t")> 0:
                        fileName, dSpaceType = line.split('\t')
                        self.contents [fileName] = dSpaceType
            else:
                os.mkdir(self.dir)
    
    def getItemPath(self):
        return self.dir
                
    def getRelPathToStream(self, datastreamLabel):
        import os.path
        return os.path.join(self.name, datastreamLabel)  
    
    def getAbsPathToStream(self, datastreamLabel):
        import os.path
        return os.path.join(self.dir, datastreamLabel)      
    
    def getStreamSize(self, datastreamLabel):
        import os
        path = self.getAbsPathToStream(datastreamLabel) 
        size = os.stat(path)[6]
        return size                
                
    def delete(self):
            os.removedirs(self.dir)
            
    def addDublinCore(self, sourcePath):
        try:
            fileName = os.path.split(sourcePath)[1]
        except Exception, errorInfo:
            print errorInfo
            print "Incorrect file path/name" + sourcePath
            sys.exit(1)
        
        #copy DC file from given path to directory of item in dSpace archive
        outputPath = os.path.join (self.dir, fileName)
        shutil.copyfile(sourcePath, outputPath)
        
            
    
    def newFile(self, sourcePath, dSpaceType):
        try:
            fileName = os.path.split(sourcePath)[1]
        except Exception, errorInfo:
            print errorInfo
            print "Incorrect file path/name" + sourcePath
            sys.exit(1)
        
        #copy file from given path to directory of item in dSpace archive
        outputPath = os.path.join (self.dir, fileName)
        shutil.copyfile(sourcePath, outputPath)
        #split filename from path
        self.contents [fileName] = dSpaceType
        self.__writeContents__()
        
    def newStream(self, outputFileName, dSpaceType, data):
        #dSpaceType is required for the contents file
        self.__writeFile__(outputFileName, data)
        self.contents [outputFileName] = dSpaceType
        self.__writeContents__()
        
    def newXMLStream(self, outputFileName, dSpaceType, data):
        #dSpaceType is required for the contents file
        outputPath = os.path.join (self.dir, outputFileName)
        data.saveFile(outputPath)
        self.contents [outputFileName] = dSpaceType
        self.__writeContents__()
        
        
    def setDublinCoreStream(self, data, inputFileName, outputFileName, removeInputFileAfterTransform):
        #TODO rename this! It's not setting the DC stream
        #And you pass an input file that doesn't even get read!!!!
        self.__writeFile__(outputFileName, data)
        if removeInputFileAfterTransform == "True":
                self.deleteFile(inputFileName)
        self.__writeContents__()
                
    def __writeFile__(self, outputFileName, data):
        outputPath = os.path.join (self.dir, outputFileName)
        output = open(outputPath, 'wb')
        if data == None:
            data = ""
        output.write(data)
        output.close()
        
    def __writeContents__(self):
        #loop through hash and print to contents file
        outputPath = os.path.join (self.dir, 'contents')
        contentsFile = open(outputPath,'w')
        for fileItem in self.contents:
            contentsFile.write(fileItem + "\t" + self.contents[fileItem] + "\n")
        contentsFile.close()
        
    def readFile(self, fileName):
        filePath = os.path.join(self.dir, fileName)
        file = open(filePath, 'r')
        output = file.read()
        file.close()
        return output

        
    def deleteFile(self, fileName):
        filePath = os.path.join(self.dir, fileName)
        os.remove(filePath)
        #remove key from hash dict or whatever
        del self.contents[fileName]
        
    
