<?xml version="1.0" encoding="UTF-8"?>


   
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" version="1.0"
    exclude-result-prefixes="marc">
    
 
       
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

-->
    <xsl:output method="xml" indent="yes"/>
    <!-- strip out any whitespace around elements -->
    <xsl:strip-space elements="*"/>
    <!-- Start processing at the root node -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="marc:collection">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Start processing at each record node -->
    <xsl:template match="marc:record">
        <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
            xmlns:dc="http://purl.org/dc/elements/1.1/">
            <xsl:apply-templates/>
        </oai_dc:dc>
    </xsl:template>

<!-- The following code was commented out for USC data, request to not show this in VITAL portal -->
  <!--  DEST Code
    <xsl:template match="marc:datafield[@tag='596']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
      </xsl:template>-->

    <!--Dissertation Note-->
    <xsl:template match="marc:datafield[@tag='655']">
        <dc:type>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:type>
    </xsl:template>

    <!--Note-->
    <xsl:template match="marc:datafield[@tag='502']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
       </dc:description>
    </xsl:template>

    <!--Peer Reviewed-->
    <xsl:template match="marc:datafield[@tag='595']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>

    <!--ISBN-->
    <xsl:template match="marc:datafield[@tag='020']">
        <dc:identifier>
            <xsl:text>ISBN:</xsl:text><xsl:value-of select="."/>
        </dc:identifier>
    </xsl:template>
    <!--ISSN-->
    <xsl:template match="marc:datafield[@tag='022']">
        <dc:identifier>
            <xsl:text>ISSN:</xsl:text><xsl:value-of select="."/>
        </dc:identifier>
    </xsl:template>

    <!-- Title Node -->
    <xsl:template match="marc:datafield[@tag='245']">
        <dc:title>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:title>
    </xsl:template>
    
    <xsl:template name="removeChar">
        <xsl:param name="parentString"/>
        <xsl:variable name="lengthParentString" select="string-length($parentString)"/>
        <xsl:variable name="lastChar" select="substring($parentString,$lengthParentString)"/>
        <xsl:choose>
            <xsl:when test="$lastChar= ',' or $lastChar= ':'  or $lastChar= '/' or $lastChar= '.' ">
                <xsl:variable name="modifiedString"
                    select="substring($parentString, 1, $lengthParentString - 1)"/>
                <xsl:value-of select="$modifiedString"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$parentString"/>
            </xsl:otherwise>
        </xsl:choose>
        
        
        
    </xsl:template>
    
    <!-- Creators [1] -->
    <xsl:template match="marc:datafield[@tag='100']">

        
   
        <xsl:choose>
            <xsl:when test="marc:subfield[@code='u'] != ''">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code='d'] != ''">
                        <dc:creator>
                            <xsl:call-template name="removeChar">
                                <xsl:with-param name="parentString">
                                    <xsl:value-of select="marc:subfield[@code='a']"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="marc:subfield[@code='d']"/>  <xsl:text>. </xsl:text>   <xsl:value-of select="marc:subfield[@code='u']"/>
                        </dc:creator>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:creator>
                            <xsl:call-template name="removeChar">
                                <xsl:with-param name="parentString">
                                    <xsl:value-of select="marc:subfield[@code='a']"/>
                                </xsl:with-param>
                            </xsl:call-template><xsl:text>. </xsl:text> <xsl:value-of select="marc:subfield[@code='u']"/>
                        </dc:creator>
                       
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:when>

            <xsl:when test="marc:subfield[@code='d'] != ''">
                <dc:creator>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                    <xsl:value-of select="marc:subfield[@code='d']"/>
                </dc:creator>
            </xsl:when>
            <xsl:otherwise>
                <dc:creator>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </dc:creator>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Creators [2] -->

    <xsl:template match="marc:datafield[@tag='700']">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code='u'] != ''">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code='d'] != ''">
                        <dc:creator>
                            <xsl:call-template name="removeChar">
                                <xsl:with-param name="parentString">
                                    <xsl:value-of select="marc:subfield[@code='a']"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="marc:subfield[@code='d']"/>  <xsl:text> </xsl:text>   <xsl:value-of select="marc:subfield[@code='u']"/>
                        </dc:creator>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:creator>
                            <xsl:call-template name="removeChar">
                                <xsl:with-param name="parentString">
                                    <xsl:value-of select="marc:subfield[@code='a']"/>
                                </xsl:with-param>
                            </xsl:call-template><xsl:text>. </xsl:text> <xsl:value-of select="marc:subfield[@code='u']"/>
                        </dc:creator>
                        
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
            
            <xsl:when test="marc:subfield[@code='d'] != ''">
                <dc:creator>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                    <xsl:value-of select="marc:subfield[@code='d']"/>
                </dc:creator>
            </xsl:when>
            <xsl:otherwise>
                <dc:creator>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </dc:creator>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--Contributor-->
    <xsl:template match="marc:datafield[@tag='710']">
        <dc:contributor>
            <xsl:value-of select="marc:subfield[@code='a']"/>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="marc:subfield[@code='b']"/>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="marc:subfield[@code='c']"/>
     </dc:contributor>
    </xsl:template>


    <!-- Description -->
    <xsl:template match="marc:datafield[@tag='520']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <!-- Publisher Information  -->
    <xsl:template match="marc:datafield[@tag='260']">
        <!--<xsl:choose>
            <xsl:when test="marc:subfield[@code='a'] != ''">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code='b'] != ''">
                        <dc:publisher>
                            <xsl:value-of select="marc:subfield[@code='a']"/>
                            <xsl:text>. </xsl:text>
                            <xsl:value-of select="marc:subfield[@code='b']"/>
                        </dc:publisher>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:publisher>
                            <xsl:value-of select="marc:subfield[@code='a']"/>
                        </dc:publisher>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>-->
                <xsl:choose>
                        <xsl:when test="marc:subfield[@code='b'] != ''">
                        <dc:publisher>
                            <xsl:value-of select="marc:subfield[@code='b']"/>
                        </dc:publisher>
                    </xsl:when>
                </xsl:choose>
          <!--  </xsl:otherwise>-->
       <!-- </xsl:choose>-->
        <xsl:if test="marc:subfield[@code='c'] != ''">
            <dc:date>
                <xsl:value-of select="marc:subfield[@code='c']"/>
            </dc:date>
        </xsl:if>
    </xsl:template>

  
    <!-- Copyright statement -->
    <xsl:template match="marc:datafield[@tag='540']">
        <dc:rights>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>
   <!--  Publisher URL 
    <xsl:template match="marc:datafield[@tag='856']">
        <dc:identifier>
            <xsl:value-of select="marc:subfield[@code='u']"/>
        </dc:identifier>
    </xsl:template>-->
    <!-- Keywords -->
    <xsl:template match="marc:datafield[@tag='653']">
        <xsl:for-each select="marc:subfield">
            <dc:subject>
                <xsl:value-of select="."/>
            </dc:subject>
        </xsl:for-each>
    </xsl:template>
    <!-- Subjects -->
    <xsl:template match="marc:datafield[@tag='650']">
        <xsl:for-each select="marc:subfield">
            <dc:subject>
                <xsl:value-of select="."/>
            </dc:subject>
        </xsl:for-each>
    </xsl:template>
    <!-- Item Type -->
    <xsl:template match="marc:datafield[@tag='655']">
        <dc:type>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:type>
    </xsl:template>
    <!-- Repository title -->
    <xsl:template match="marc:datafield[@tag='773']">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code='t']!=''">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code='g']!=''">
                        <dc:relation>
                            <xsl:value-of select="marc:subfield[@code='t']"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="marc:subfield[@code='g']"/>
                        </dc:relation>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:relation>
                            <xsl:value-of select="marc:subfield[@code='t']"/>
                        </dc:relation>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- DEST Collection Year 
    <xsl:template match="marc:datafield[@tag='591']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
     DEST Category 
    <xsl:template match="marc:datafield[@tag='592']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>-->
    <!-- Conference Title -->
    <xsl:template match="marc:datafield[@tag='711']">
        <xsl:variable name="pages" select="//*[local-name()='datafield'][@tag='300']/*[local-name()='subfield'][@code='a']"/> 
        <xsl:choose>
            <xsl:when test="contains($pages, 'pages')">
                <dc:relation>
                    <xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> (</xsl:text><xsl:value-of select="marc:subfield[@code='c']"/><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/><xsl:text>) </xsl:text><xsl:value-of select="$pages"/>
                </dc:relation>
            </xsl:when>
            <xsl:otherwise>
                <dc:relation>
                    <xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> (</xsl:text><xsl:value-of select="marc:subfield[@code='c']"/><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/><xsl:text>) </xsl:text><xsl:text>p. </xsl:text><xsl:value-of select="$pages"/>
                </dc:relation>
            </xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    <!-- Patent Number -->
    <xsl:template match="marc:datafield[@tag='013']">
        <dc:subject>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:subject>
    </xsl:template>
    <!-- Language Test -->
    <xsl:template match="marc:datafield[@tag='041']">
        <dc:language>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:language>
    </xsl:template>



    <!-- do not ouptut nodes we don't match -->
    <xsl:template match="*"/>
    <!-- match against the utf-x-wrapper class for testing purposes-->
    <xsl:template match="utfx-wrapper">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
