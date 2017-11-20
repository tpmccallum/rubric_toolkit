
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

import sys
from tsv_file_to_archive import *


def test_createRecord():
    template = """<record><one>%s</one><two>%s</two><three>%s</three></record>"""
    currentRow = ["first", "second", "third"]
    newRecord = createRecord(template, currentRow)
    assert newRecord == """<record><one>first</one><two>second</two><three>third</three></record>"""
    
def test_createRecord():
    template = """<record><one>%s</one><two>%s</two><three>%s</three></record>"""
    currentRow = ["first", "second"]
    try:
        newRecord = createRecord(template, currentRow)
    except Exception, errorInfo: 
        failed = True 
    assert failed == True

def test_escaping():
    template = """<record><one>%s</one><two>%s</two><three>%s</three></record>"""
    currentRow = ["first<", "second&", "third"]
    newRecord = createRecord(template, currentRow)
    assert newRecord == """<record><one>first&lt;</one><two>second&amp;</two><three>third</three></record>"""