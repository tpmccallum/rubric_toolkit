
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
import aanro_dump_to_foxml


def test_parseResearcher():
    data = 'Lastname JE Dr Australian Association of Animal Breeding and Genetics Inc. (PO Box XXXX, Rockhampton Mail Centre Qld 4702)|Lastname GP Dr Australian Association of Animal Breeding and Genetics Inc. (PO Box XXXX, Rockhampton Mail Centre Qld 4702)'
    researcherList = aanro_dump_to_foxml._parseResearcher(data)
    
    assert researcherList[0]['familyname'] == 'Lastname'
    assert researcherList[0]['initials'] == 'JE'
    assert researcherList[0]['title'] == 'Dr'
    assert researcherList[0]['affiliation'] == 'Australian Association of Animal Breeding and Genetics Inc.'
    assert researcherList[0]['address'] == 'PO Box XXXX, Rockhampton Mail Centre Qld 4702'
    assert researcherList[0]['name'] == 'Lastname JE'
    
    assert researcherList[1]['familyname'] == 'Lastname'
    assert researcherList[1]['initials'] == 'GP'
    assert researcherList[1]['title'] == 'Dr'
    assert researcherList[1]['affiliation'] == 'Australian Association of Animal Breeding and Genetics Inc.'
    assert researcherList[1]['address'] == 'PO Box XXXX, Rockhampton Mail Centre Qld 4702'
    assert researcherList[1]['name'] == 'Lastname GP'
    


def test_parseAuthor():
    data = 'Lastname JA (Victoria University of Technology, Centre for Bioprocessing and Food Technology, Melbourne)|Lastname AJ (Tasmanian Department of Primary Industry and Fisheries, Marine Research Laboratories, Taroona)|Lastname G (University of Sydney, Department of Animal Science)'
    authorList = aanro_dump_to_foxml._parseAuthor(data)
    
    assert authorList[0]["familyname"] == 'Lastname'
    assert authorList[0]["initials"] == 'JA'
    assert authorList[0]["affiliation"] == 'Victoria University of Technology, Centre for Bioprocessing and Food Technology, Melbourne'
    
    assert authorList[1]["familyname"] == 'Lastname'
    assert authorList[1]["initials"] == 'AJ'
    assert authorList[1]["affiliation"] == 'Tasmanian Department of Primary Industry and Fisheries, Marine Research Laboratories, Taroona'


    assert authorList[2]["familyname"] == 'Lastname'
    assert authorList[2]["initials"] == 'G'
    assert authorList[2]["affiliation"] == 'University of Sydney, Department of Animal Science'
    
def test_parseKeyword():
    data = 'Sheep |Animal parasitic |nematodes Nematode |larvae |Anthelmintics '
    subjectList = aanro_dump_to_foxml._parseKeyword(data)
    
    assert subjectList == ['Sheep ', 'Animal parasitic ', 'nematodes Nematode ', 'larvae ', 'Anthelmintics ']

def test_parseSponsor():
    data = 'United States Department of XXXX'
    sponsorList = aanro_dump_to_foxml._parseSponsor(data)
    
    assert sponsorList == ['United States Department of XXXX']



    
    