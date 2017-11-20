
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

from harvest_digital_commons import *

def test_getIdentifier():
    dcString = """<?xml version="1.0"?>
    <record><header><identifier>oai:digitalcommons.massey.ac.nz:richard_haverkamp-1020</identifier>
    <datestamp>2007-07-17</datestamp><setSpec>publication:richard_5Fhaverkamp</setSpec>
    </header>
    <metadata><oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"><dc:title>Stretching single polysaccharide molecules using AFM: A potential method for the investigation of the intermolecular uronate distribution of alginate?</dc:title>
    <dc:creator>Williams, Martin A.K</dc:creator>
    <dc:creator>Marshall, Aaron T</dc:creator>
    <dc:creator>Haverkamp, Richard G</dc:creator>
    <dc:creator>Draget, Kurt I</dc:creator>
    <dc:description>Illustrative examples of the way in which the molecular force-extension behaviour of polysaccharides is governed by the nature of the linkage between their constituent pyranose rings are presented for a series of standard homopolymers. These results agree with previously proposed general hypotheses regarding the possibility of generating force-induced conformational transitions, and with the predictions of a model in which the inter-conversion of pyranose conformers is assumed to be an equilibrium process on the timescale of the molecular stretching. Subsequently, we investigate the potential of the technique in the characterisation of co-polymeric polysaccharides in which the nature of the glycan linkages is different between the two distinct residue types. Specifically, we explore the possibility that the ratio of mannuronic acid (M) to guluronic acid (G) in alginate chains will be reflected in their single molecule stretching behaviour, owing to their contrasting equatorial and axial linkages. Furthermore, as the technique described interrogates the sample one polymer at a time we outline the promise of, and the obstacles to, obtaining a new level of characterisation using this methodology where differences observed in the single molecule stretching curves obtained from single alginate samples reflectsomething of the real intermolecular distribution of the M / G ratio. </dc:description>
    <dc:date>2008-01-01</dc:date>
    <dc:type>text</dc:type>
    <dc:format>application/pdf</dc:format>
    <dc:identifier>http://digitalcommons.massey.ac.nz/richard_haverkamp/21</dc:identifier>
    <dc:publisher>Massey University.</dc:publisher>
    <dc:rights/></oai_dc:dc></metadata></record>"""
    pageUrl = getIdentifier(dcString)
    assert pageUrl == "http://digitalcommons.massey.ac.nz/richard_haverkamp/21"
        
def test_getContentLinks():
    pageUrl= "test_files/Blood brothers southern men.html"
    htmlFile = open(pageUrl, 'r')
    html = htmlFile.read()
    htmlFile.close()
    urlList = dict()
    urlList = getContentLinks(pageUrl,html)
    assert urlList["01front.pdf"] == "http://digitalcommons.massey.ac.nz/context/dissertations/article/1022/index/0/type/native/viewcontent"
    assert urlList["02whole.pdf"] == "http://digitalcommons.massey.ac.nz/context/dissertations/article/1022/index/1/type/native/viewcontent"
def test_getContentLinks_for_papers():
    pageUrl=  "test_files/Structural basis for rodlet assembly in fungal hydrophobins.html"
    htmlFile = open(pageUrl, 'r')
    html = htmlFile.read()
    htmlFile.close()
    urlList = dict()
    urlList = getContentLinks(pageUrl,html)
    assert urlList["content.pdf"] == "http://digitalcommons.massey.ac.nz/cgi/viewcontent.cgi?article=1000&context=richard_haverkamp"