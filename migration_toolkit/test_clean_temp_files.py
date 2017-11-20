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



import os, os.path, sys, string

from clean_temp_files import *


def test_cleanString():
    pickleFile = open('binary', 'rb')
    unpickledString = pickle.load(pickleFile)
    dictionary = eval(unpickledString)
    oldCharacters = "&aacute; &Acirc;"
    newCharacters = cleanString(oldCharacters, dictionary)
    pickleFile.close()
    assert newCharacters == "&#x00E1; &#x00C2;"
    
    

def test_cleanString2():
    pickleFile2 = open('binary', 'rb')
    unpickledString2 = pickle.load(pickleFile2)
    dictionary2 = eval(unpickledString2)
    brokenChars = "building &amp; workplace &aacute; almost everywhere  than it should be. In &amp; &lt; &gt;"
    fixedChars = cleanString(brokenChars, dictionary2)
    pickleFile2.close()
    assert fixedChars == "building &#x0026; workplace &#x00E1; almost everywhere  than it should be. In &#x0026; &#x003C; &#x003E;"

    
   


    
    