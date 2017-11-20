<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://exslt.org/strings" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" version="1.0" extension-element-prefixes="str" exclude-result-prefixes="str">
    <!-- Specify output options -->
    <!-- Output XML and indent, make it pretty -->
    <!--
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

--><xsl:output method="xml" indent="yes"/>
    <!-- strip out any whitespace around elements -->
    <xsl:strip-space elements="*"/>
    
  
    
          <xsl:template match="dc:title">
            <dcvalue element="title" qualifier="none">
                <xsl:value-of select="."/>
            </dcvalue>
        </xsl:template>
    
    <xsl:template match="dc:subject">
        <dcvalue element="subject" qualifier="classification">
            <xsl:value-of select="."/>
        </dcvalue>
    </xsl:template>
        
        <xsl:template match="dc:creator">
            <dcvalue element="contributor" qualifier="author">
                <xsl:value-of select="."/>
            </dcvalue>
        </xsl:template>
        
        
        
        <xsl:template match="dc:description">
            <dcvalue element="description" qualifier="abstract">
                <xsl:value-of select="."/>
            </dcvalue>
        </xsl:template>
        
    <xsl:template match="dc:date">
            <dcvalue element="date" qualifier="issued">
                <xsl:value-of select="."/>
            </dcvalue>
    </xsl:template>
    
    <xsl:template match="datestamp">
        <dcvalue element="date" qualifier="available">
            <xsl:value-of select="."/>
        </dcvalue>
    </xsl:template>
    
    <xsl:template match="dc:type">
        <dcvalue element="type" qualifier="none">
            <xsl:value-of select="."/>
        </dcvalue>
    </xsl:template>
        
    
    <xsl:template match="dc:format">
        <dcvalue element="format" qualifier="medium">
            <xsl:value-of select="."/>
        </dcvalue>
    </xsl:template>
    <!--  <xsl:template match="meta[@name='dc.language']">
            <dcvalue element = "language" qualifier = "iso">
                <xsl:value-of select="@content"/>
            </dcvalue>
        </xsl:template>-->
        
        <xsl:template match="dc:publisher">
            <dcvalue element="publisher" qualifier="none">
                <xsl:value-of select="."/>
            </dcvalue>
        </xsl:template>
        
 <xsl:template match="dc:rights">
            <dcvalue element="rights" qualifier="none">
                <xsl:value-of select="."/>
            </dcvalue>
        </xsl:template>
        
   <xsl:template match="dc:identifier">
            <dcvalue element="identifier" qualifier="uri">
                <xsl:value-of select="."/>
            </dcvalue>
        </xsl:template>
        
    <!-- <xsl:template match="meta[@name='dc.description']">
            <dcvalue element = "type" qualifier = "none">
                <xsl:value-of select="@content"/>
            </dcvalue>
        </xsl:template>-->
        
                
        <!-- do not ouptut nodes we don't match -->
        <xsl:template match="*"/>
        <!-- match against the utf-x-wrapper class for testing purposes-->
        <xsl:template match="utfx-wrapper">
            <xsl:apply-templates/>
        </xsl:template>
</xsl:stylesheet>
