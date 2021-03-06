
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

#arguments
# 1)url of webservice
# 2)output file name .xml

import sys, urllib2, zlib, time, re, xml.dom.pulldom,  operator, codecs, libxml2, string
nDataBytes, nRawBytes, nRecoveries, maxRecoveries = 0, 0, 0, 3

def getFile(serverString, command, verbose=1, sleepTime=0):
    global nRecoveries, nDataBytes, nRawBytes
    if sleepTime: time.sleep(sleepTime)
    remoteAddr = serverString+'?verb=%s'%command
    if verbose: print "\r", "getFile ...'%s'"%remoteAddr[-90:],
    headers = {'User-Agent': 'OAIHarvester/2.0', 'Accept': 'text/html',
               'Accept-Encoding': 'compress, deflate'}
            
    try:remoteData=urllib2.urlopen(urllib2.Request(remoteAddr, None, headers)).read()
    except urllib2.HTTPError, exValue:
        if exValue.code==503:
            retryWait = int(exValue.hdrs.get("Retry-After", "-1"))
            if retryWait<0: return None
            print 'Waiting %d seconds'%retryWait
            return getFile(serverString, command, 0, retryWait)
        print exValue
        if nRecoveries<maxRecoveries:
            nRecoveries += 1
            return getFile(serverString, command, 1, 60)
        return
    nRawBytes += len(remoteData)
    try:    
        remoteData = zlib.decompressobj().decompress(remoteData)
    except: 
        pass
    nDataBytes += len(remoteData)
    mo = re.search('<error *code=\"([^"]*)">(.*)</error>', remoteData)
    if mo: 
        print "OAIERROR: code=%s '%s'"%(mo.group(1), mo.group(2))
    else:  
        return remoteData
    
    
try:   
    serverString, outFileName=sys.argv[1:]
except:
    serverString, outFileName='alcme.oclc.org/ndltd/servlet/OAIHandler', 'repository.xml'
if serverString.find('http://')!=0: 
    serverString = 'http://'+serverString
print "Writing records to %s from archive %s"%(outFileName, serverString)
ofile=open(outFileName, 'w')
ofile.write('<repository>\n')  # wrap list of records with this
data = getFile(serverString, 'ListRecords&metadataPrefix=%s'%'oai_dc')
recordCount = 0
while data:
    #makes an xml parser
  #  data_serialized = data.serialize()

    data_decoded = data.decode('iso-8859-1')
    data_utf8 = data_decoded.encode('utf-8')
    events = libxml2.parseDoc(data_utf8)
        
    ofile.write(data_utf8)
    recordCount += 1
     
    mo = re.search('<resumptionToken[^>]*>(.*)</resumptionToken>', data)
    if not mo: break
    data = getFile(serverString, "ListRecords&resumptionToken=%s"%mo.group(1))
ofile.write('\n</repository>\n'), ofile.close()
print "\nRead %d bytes (%.2f compression)"%(nDataBytes, float(nDataBytes)/nRawBytes)
print "Wrote out %d records"%recordCount
## Copyright (c) 2000-2003 OCLC Online Computer Library Center, Inc. and other contributors.
## All rights reserved.  The contents of this file, as updated from time to time by the OCLC
## Office of Research are subject to OCLC Research Public License Version 2.0 (the
## "License"); you may not use this file except in compliance with the License.  You may
## obtain a current copy of the License at http://purl.oclc.org/oclc/research/ORPL/.
## Software distributed under the License is distributed on an "AS IS" basis, WITHOUT
## WARRANTY OF ANY KIND, either express or implied.  See the License for the specific
## language governing rights and limitations under the License.  This software consists of
## voluntary contributions made by many individuals on behalf of OCLC Research.  For more
## information on OCLC Research, please see http://www.oclc.org/research/.  This is the
## Original Code.  The Initial Developer of the Original Code is Thomas Hickey
## (mailto:hickey@oclc.org). Portions created by OCLC are Copyright (C) 2003.  All Rights
## Reserved. 2003 July 31a
