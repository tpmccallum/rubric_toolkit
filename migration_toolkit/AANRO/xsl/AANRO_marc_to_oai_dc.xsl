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


  <!--deliverylink-->
    <xsl:template match="marc:datafield[@tag='596']">
        <dc:relation>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:relation>
    </xsl:template>
    <!--deliveryemail-->
    <xsl:template match="marc:datafield[@tag='597']">
        <dc:relation>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:relation>
    </xsl:template>
    <!--deliverynote-->
    <xsl:template match="marc:datafield[@tag='598']">
        <dc:relation>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:relation>
    </xsl:template>
    
    
    <!--id-->
    <xsl:template match="marc:datafield[@tag='091']">
        <dc:identifier>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:identifier>
    </xsl:template>
    
    <!--doctype-->
    <xsl:template match="marc:datafield[@tag='655']">
        <dc:type>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:type>
        <dc:type>
        <xsl:value-of select="marc:subfield[@code='2']"/>
        </dc:type>
    </xsl:template>
    
    
    <!--Dissertation Note-->
    <xsl:template match="marc:datafield[@tag='599']">
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
    
    <!--sponsor-->
    <xsl:template match="marc:datafield[@tag='536']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    
    <!--methodology-->
    <xsl:template match="marc:datafield[@tag='567']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <!--progress-->
    <xsl:template match="marc:datafield[@tag='593']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <!--implication-->
    <xsl:template match="marc:datafield[@tag='594']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    
    <!--startdate-->
    <xsl:template match="marc:datafield[@tag='045']">
        <dc:date>
            <xsl:value-of select="marc:subfield[@code='b']"/>
                <xsl:text>-</xsl:text>
            <xsl:value-of select="marc:subfield[@code='b']"/>
        </dc:date>
    </xsl:template>
    
    <!--researcher-->
    <xsl:template match="marc:datafield[@tag='720']">
        <dc:creator>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:creator>
    </xsl:template>
    
    <!--availability-->
    <xsl:template match="marc:datafield[@tag='506']">
        <dc:rights>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>
    
    <!--series-->
    <xsl:template match="marc:datafield[@tag='440']">
        <dc:relation>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:relation>
    </xsl:template>
   
    <!--notes-->
    <xsl:template match="marc:datafield[@tag='500']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
       </dc:description>
    </xsl:template>

    <!--ISBN-->
    <xsl:template match="marc:datafield[@tag='020']">
        <dc:identifier>
            <xsl:value-of select="."/>
        </dc:identifier>
    </xsl:template>
    <!--ISSN-->
    <xsl:template match="marc:datafield[@tag='022']">
        <dc:identifier>
            <xsl:value-of select="."/>
        </dc:identifier>
    </xsl:template>

    <!-- Title Node -->
    <xsl:template match="marc:datafield[@tag='245']">
        <dc:title>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:title>
    </xsl:template>
    <!-- Creators [1] -->
    <xsl:template match="marc:datafield[@tag='100']">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code='u'] != ''">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code='d'] != ''">
                        <dc:creator>
                            <xsl:value-of select="marc:subfield[@code='a']"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="marc:subfield[@code='d']"/>
                        </dc:creator>
                        <dc:relation>
                            <xsl:value-of select="marc:subfield[@code='u']"/>
                        </dc:relation>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:creator>
                            <xsl:value-of select="marc:subfield[@code='a']"/>
                        </dc:creator>
                        <dc:relation>
                            <xsl:value-of select="marc:subfield[@code='u']"/>
                        </dc:relation>

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
                            <xsl:value-of select="marc:subfield[@code='a']"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="marc:subfield[@code='d']"/>
                        </dc:creator>
                        <dc:relation>
                            <xsl:value-of select="marc:subfield[@code='u']"/>
                        </dc:relation>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:creator>
                            <xsl:value-of select="marc:subfield[@code='a']"/>
                        </dc:creator>
                        <dc:relation>
                            <xsl:value-of select="marc:subfield[@code='u']"/>
                        </dc:relation>

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
    <!-- Creators [3] -->
    <xsl:template match="marc:datafield[@tag='710']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag='710']/subfield[@code='a']">
        <dc:relation>
            <xsl:value-of select="."/>
        </dc:relation>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag='710']/subfield[@code='b']">
        <dc:relation>
            <xsl:value-of select="."/>
        </dc:relation>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag='710']/subfield[@code='c']">
        <dc:relation>
            <xsl:value-of select="."/>
        </dc:relation>
    </xsl:template>

    <!-- Description -->
    <xsl:template match="marc:datafield[@tag='520']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <!-- Publisher Information  -->
    <xsl:template match="marc:datafield[@tag='260']">
        <xsl:choose>
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
            <xsl:otherwise>
                <xsl:choose>


                    <xsl:when test="marc:subfield[@code='b'] != ''">
                        <dc:publisher>
                            <xsl:value-of select="marc:subfield[@code='b']"/>
                        </dc:publisher>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="marc:subfield[@code='c'] != ''">
            <dc:date>
                <xsl:value-of select="marc:subfield[@code='c']"/>
            </dc:date>
        </xsl:if>
    </xsl:template>

    <!-- Relation -->
    <xsl:template match="marc:datafield[@tag='787']">

        <xsl:if test="marc:subfield[@code='t']!=''">
            <dc:relation>
                <xsl:value-of select="marc:subfield[@code='t']"/>
            </dc:relation>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='g']!=''">
            <dc:relation>
                <xsl:value-of select="marc:subfield[@code='g']"/>
            </dc:relation>
        </xsl:if>
    </xsl:template>
    <!-- Copyright statement -->
    <xsl:template match="marc:datafield[@tag='540']">
        <dc:rights>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>
    <!-- Publisher URL -->
    <xsl:template match="marc:datafield[@tag='856']">
        <dc:identifier>
            <xsl:value-of select="marc:subfield[@code='u']"/>
        </dc:identifier>
    </xsl:template>
    <!-- Keywords -->
    <xsl:template match="marc:datafield[@tag='653']">
        <xsl:for-each select="marc:subfield">
            <dc:subject>
                <xsl:value-of select="."/>
            </dc:subject>
        </xsl:for-each>
    </xsl:template>
    <!-- locality -->
    <xsl:template match="marc:datafield[@tag='522']">
        <xsl:for-each select="marc:subfield">
            <dc:coverage>
                <xsl:value-of select="."/>
         </dc:coverage>
        </xsl:for-each>
    </xsl:template>
    <!-- program -->
    <xsl:template match="marc:datafield[@tag='095']">
        <xsl:for-each select="marc:subfield">
            <dc:description>
                <xsl:value-of select="."/>
           </dc:description>
        </xsl:for-each>
    </xsl:template>
    <!-- subprogram -->
    <xsl:template match="marc:datafield[@tag='096']">
        <xsl:for-each select="marc:subfield">
            <dc:description>
                <xsl:value-of select="."/>
            </dc:description>
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
    
  
    <!-- Repository title -->
    <xsl:template match="marc:datafield[@tag='773']">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code='t']!=''">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code='g']!=''">
                        <dc:relation>
                            <xsl:value-of select="marc:subfield[@code='t']"/>
                            <xsl:text> </xsl:text>
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
    <!-- DEST Collection Year -->
    <xsl:template match="marc:datafield[@tag='591']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <!-- DEST Category -->
    <xsl:template match="marc:datafield[@tag='592']">
        <dc:description>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <!-- Conference Title -->
    <xsl:template match="marc:datafield[@tag='711']">
        <dc:relation>
            <xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='c']"/><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='d']"/>
        </dc:relation>
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
