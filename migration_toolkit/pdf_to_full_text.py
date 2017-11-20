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
"""
PDF to full text
Name of the script
pdf_to_full_text.py
Location of script
migration_toolkit/pdf_to_full_text.py
Purpose of script
The pdf_to_full_text.py script is the Python script that iterates through a dspaceArchive and converts the harvested pdf files to fulltext. 

Parameters/Arguments
ArchiveName  
Name of the dspaceArchive that contains the pdf files 
Syntax
python pdf_to_full_text.py ArchiveName
Example
python pdf_to_full_text.py dspaceArchive
"""

import sys, subprocess
sys.path.append("dspace_archive")
from dspace_archive import *

def extractText(pdfPath, fileName):
    """
    Extract the text from a PDF document
    - configOptions, dictionary of configuration options
    - pdfPath, path to the PDF file to evaluate
    If it works return a string containing the text
    If it fails return False
    """
    try:
        pdfToText = subprocess.Popen(("pdftotext", "-q", pdfPath, "-"),\
        stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE, close_fds = True)
        pdfText = pdfToText.communicate()
        
        if pdfText[0] != "":
            return pdfText[0]
        else:
            print "Unable to extract text from PDF file. Details are:"
            print pdfText[1]
            print "PDF File: " + fileName
            return ""
    except OSError, errorInfo:
        print "Unable to extract the text from PDF file"
        return ""
    except Exception, errorInfo:
        print "Unable to extract the text from the PDF file"
        return ""

def main():
    archiveName = sys.argv[1]
    arc = dspaceArchive(archiveName)
    for item in arc.items:
        print "Processing item: " + item.name
        text = ""
        for fileName in item.contents.keys():
            if fileName.endswith(".pdf"):
                pdf = item.readFile(fileName)
                pdfFile = open("temp_pdf.pdf", "w")
                pdfFile.write(pdf)
                pdfFile.close()
                text += extractText("temp_pdf.pdf",fileName)
##                text += extractText(fileName)
        item.newStream("fulltext", "temp", text)
    print "Processing complete"
    
if not (sys.argv[0].endswith("py.test")):
    main()
