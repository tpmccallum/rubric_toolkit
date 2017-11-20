
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

"""
Module to test the dspace_archive.py class and associated object and properties
"""


#TODO - tests for getStreamSize & writeIndexPage

import sys, os.path, shutil
sys.path.append("../utils")
import diff_util, xml_normalize, xml_util
from dspace_archive import *
def test_archive():
    #make sure the code does not try to create the directory twice**
    if os.path.exists("test"):
        shutil.rmtree("test")
    archive = dspaceArchive("test")
    assert archive.name == "test"
    print "Made test"
    
    #Test that it makes a dir
    assert os.path.exists("test")
    
    #make an item**
    item = archive.newItem()
    assert item.name == '0'
    assert os.path.exists("test/0")
    #make item2
    item2 = archive.newItem()
    assert item2.name == '1'
    assert os.path.exists("test/1")
      
    
    #test with path instead of just file name
    item.newFile("testdata/1st.pdf", "bundle:ORIGINAL")
    assert item.contents["1st.pdf"] ==   "bundle:ORIGINAL"
    
    #add a file
    item2.newFile("2nd.pdf", "bundle:ORIGINAL")
    assert item2.contents["2nd.pdf"] ==   "bundle:ORIGINAL"
    assert os.path.exists("test/1/2nd.pdf")
    assert item2.getRelPathToStream("2nd.pdf") == "1/2nd.pdf"
    
    #What happens if you pass a non existent file?
    try:
        item.newFile("dogxxxx.pdf", "bundle:ORIGINAL")
        assert false 
    except:
        assert not(item.contents.has_key("dogxxxx.pdf"))
            
    #test that contents file has been created
    assert os.path.exists("test/0/contents")
    assert os.path.exists("test/1/contents")
    #test that the contents file contains the file names and types
    #first file
    test_contentsFile = open('test/0/contents','r')
    firstLine = test_contentsFile.readline()
    assert firstLine == "1st.pdf\tbundle:ORIGINAL\n"
    test_contentsFile.close()
    #second file
    test_contentsFile = open('test/1/contents','r')
    firstLine = test_contentsFile.readline()
    assert firstLine == "2nd.pdf\tbundle:ORIGINAL\n"
    test_contentsFile.close()
    #test 2 files added to item
    #test with path instead of just file name
    item3 = archive.newItem()
    assert item3.name == '2'
    assert os.path.exists("test/2")
    item3.newFile("testdata/1st.pdf", "bundle:ORIGINAL")
    item3.newFile("testdata/2pdf.pdf", "bundle:ORIGINAL")
    assert item3.contents["1st.pdf"] ==   "bundle:ORIGINAL"
    assert item3.contents["2pdf.pdf"] ==   "bundle:ORIGINAL"
    
    item3.newStream("dc_temp.xml","bundle:ORIGINAL", "some text")
    assert item3.contents["dc_temp.xml"] == "bundle:ORIGINAL"
    
    tempFile = open("test/2/dc_temp.xml", 'r')
    tempFile = tempFile.read()
    assert tempFile == "some text"
    assert item3.readFile("dc_temp.xml")  == "some text"
    

    #test adding a dublin core file
       
    
    item3.setDublinCoreStream("<head/>", "dc_temp.xml", "dublin_core.xml", "True" )
    assert item3.readFile("dublin_core.xml") == "<head/>"

   
   # item3.deleteFile("dc_temp.xml")
    assert not(os.path.exists("test/2/dc_temp.xml"))
    assert not(item3.contents.has_key("dc_temp.xml"))
    
    tempFile = open("test/2/contents", 'r')
    tempFile = tempFile.read()
    assert tempFile.find("dc_temp.xml") == -1
 
    
    #Test that it can destroy itself (delete the dir)
    archive.delete()
    assert not(os.path.exists("test"))
    
        
def test_item():
    
    assert not(os.path.exists("testItem"))
    #make sure the code does not try to create the directory twice
    item = dspaceItem("testItem")
    assert item.name == "testItem"
    
    #Test that it makes a dir
    assert os.path.exists("testItem")
    
    
    
    #Test that it can destroy itself (delete the dir)
    item.delete()
    assert not(os.path.exists("testItem"))
    
def test_existing_archive():
    #test the loading of existing archive
    existingArchive = dspaceArchive("existingArchiveTest")
    assert existingArchive.name == "existingArchiveTest"
    #assert not archive.items == []
    #Test that it makes a dir
    assert os.path.exists("existingArchiveTest")
    #make an item
    item = existingArchive.newItem()
    item.newFile("testdata/1st.pdf", "bundle:ORIGINAL")
    test_contentsFile = open('existingArchiveTest/0/contents','r')
    firstLine = test_contentsFile.readline()
    test_contentsFile.close()
    
   
   
    #test adding a dublin core file
    item.addDublinCore("testdata/dublin_core.xml")
    existingArchive = None
    existingArchive = dspaceArchive("existingArchiveTest")
    assert existingArchive.name == "existingArchiveTest"
    assert not existingArchive.items == []
    assert item.name == '0'
    assert os.path.exists("existingArchiveTest/0")
    #test that hash key and value are correct
    assert item.contents["1st.pdf"] ==   "bundle:ORIGINAL"
    #test that contents file has been created
    assert os.path.exists("existingArchiveTest/0/contents")
    #test that the contents file contains the file names and types
    assert firstLine == "1st.pdf\tbundle:ORIGINAL\n"
    assert os.path.exists("existingArchiveTest/0/dublin_core.xml")
    #Test that it can destroy itself (delete the dir)
    existingArchive.delete()
    assert not(os.path.exists("existingArchiveTest"))
    
    
    
    
