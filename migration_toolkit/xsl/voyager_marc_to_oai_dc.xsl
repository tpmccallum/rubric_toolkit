<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" version="1.0" exclude-result-prefixes="marc">
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
    <!-- Start processing at the root node -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="marc:collection">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Start processing at each record node -->
    <xsl:template match="marc:record">
        <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/">
            <xsl:apply-templates/>
        </oai_dc:dc>
    </xsl:template>
    <!-- Title Node -->
    <xsl:template match="marc:datafield[@tag='245']">
        <dc:title>

            <xsl:call-template name="removeChar">
                <xsl:with-param name="parentString">
                    <xsl:value-of select="child::marc:subfield[@code='a']"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="removeChar">
                <xsl:with-param name="parentString">
                    <xsl:value-of select="child::marc:subfield[@code='b']"/>
                </xsl:with-param>
            </xsl:call-template>

        </dc:title>

        <xsl:variable name="string">
            <xsl:value-of select="child::marc:subfield[@code='h']"/>
        </xsl:variable>
        <xsl:variable name="start">
            <xsl:value-of select="substring-after($string,'[')"/>
        </xsl:variable>
        <dc:format>
            <xsl:value-of select="substring-before($start,']')"/>
        </dc:format>
    </xsl:template>
    <!-- Creators [1] -->
    <xsl:template match="marc:datafield[@tag='100']">
        <xsl:choose>
            <xsl:when test="child::marc:subfield[@code='u'] != ''">
                <dc:creator>
                    <xsl:value-of select="child::marc:subfield[@code='a']"/>
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="child::marc:subfield[@code='u']"/>
                </dc:creator>
            </xsl:when>
            <xsl:otherwise>
                <dc:creator>
                    <xsl:call-template name="removeChar">
                        <xsl:with-param name="parentString">
                            <xsl:value-of select="child::marc:subfield[@code='a']"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </dc:creator>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <!-- Creators [2] -->
    <xsl:template match="marc:datafield[@tag='700']">
        <xsl:choose>
            <xsl:when test="child::marc:subfield[@code='u'] != ''">
                <dc:creator>
                    <xsl:value-of select="child::marc:subfield[@code='a']"/>
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="child::marc:subfield[@code='u']"/>
                </dc:creator>
            </xsl:when>
            <xsl:when test="child::marc:subfield[@code='d'] != ''">
                <dc:creator>
                    <xsl:value-of select="child::marc:subfield[@code='a']"/>
                </dc:creator>
            </xsl:when>
            <xsl:otherwise>
                <dc:creator>
                    <xsl:value-of select="child::marc:subfield[@code='a']"/>
                </dc:creator>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Creators [3] -->
    <xsl:template match="marc:datafield[@tag='710']">
<dc:relation><xsl:value-of select="child::marc:subfield[@code='a']"/></dc:relation>
            <dc:relation><xsl:value-of select="child::marc:subfield[@code='b']"/></dc:relation>
            <dc:relation><xsl:value-of select="child::marc:subfield[@code='c']"/></dc:relation>
    </xsl:template>
    <!-- Description -->
    <xsl:template match="marc:datafield[@tag='520']">
        <dc:description>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <!-- Publisher Information & publication date -->
    <xsl:template match="marc:datafield[@tag='260']">
        <dc:publisher>
            <xsl:call-template name="removeChar">
                <xsl:with-param name="parentString">
                    <xsl:value-of select="child::marc:subfield[@code='b']"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text>. </xsl:text>
            <xsl:call-template name="removeChar">
                <xsl:with-param name="parentString">
                    <xsl:value-of select="child::marc:subfield[@code='a']"/>
                </xsl:with-param>
            </xsl:call-template>
        </dc:publisher>
        <dc:date>
            <xsl:call-template name="removeChar">
                <xsl:with-param name="parentString">
                    <xsl:value-of select="child::marc:subfield[@code='c']"/>
                </xsl:with-param>
            </xsl:call-template>
        </dc:date>
    </xsl:template>

    <xsl:template name="removeChar">
        <xsl:param name="parentString"/>
        <xsl:variable name="lengthParentString" select="string-length($parentString)"/>
        <xsl:variable name="lastChar" select="substring($parentString,$lengthParentString)"/>
        <xsl:choose>
            <xsl:when test="$lastChar= ',' or $lastChar= ':'  or $lastChar= '/' or $lastChar= '.' ">
                <xsl:variable name="modifiedString" select="substring($parentString, 1, $lengthParentString - 1)"/>
                <xsl:value-of select="$modifiedString"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$parentString"/>
            </xsl:otherwise>
        </xsl:choose>



    </xsl:template>

    <!-- Relation -->
    <xsl:template match="marc:datafield[@tag='787']">
        <dc:relation>
            <xsl:value-of select="child::marc:subfield[@code='t']"/>
        </dc:relation>
    </xsl:template>
    <!-- Copyright statement -->
    <xsl:template match="marc:datafield[@tag='540']">
        <dc:rights>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>
    <!-- Publisher URL -->
    <xsl:template match="marc:datafield[@tag='856']">
        <dc:relation>
            <xsl:value-of select="child::marc:subfield[@code='u']"/>
        </dc:relation>
    </xsl:template>
    <!-- Keywords -->
    <xsl:template match="marc:datafield[@tag='653']">
        <xsl:for-each select="child::marc:subfield[@code='a']">
            <dc:subject>
                <xsl:value-of select="."/>
            </dc:subject>
        </xsl:for-each>
    </xsl:template>
    <!-- Item Type -->
    <xsl:template match="marc:datafield[@tag='655']">
        <dc:type>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:type>
    </xsl:template>
    <!-- Repository title -->
    <xsl:template match="marc:datafield[@tag='773']">
        <dc:relation>
            <xsl:value-of select="child::marc:subfield[@code='t']"/>
        </dc:relation>
    </xsl:template>
    <!-- DEST Collection Year -->
    <xsl:template match="marc:datafield[@tag='591']">
        <dc:description>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <!-- DEST Category -->
    <xsl:template match="marc:datafield[@tag='592']">
        <dc:description>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <!-- Conference Title -->
    <xsl:template match="marc:datafield[@tag='711']">
        <dc:relation>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:relation>
    </xsl:template>
    <!-- Patent Number -->
    <xsl:template match="marc:datafield[@tag='013']">
        <dc:subject>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:subject>
    </xsl:template>
    <!-- Coverage -->
    <xsl:template match="marc:datafield[@tag='043']">
        <dc:coverage>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:coverage>
    </xsl:template>
    <!-- Coverage -->
    <xsl:template match="marc:datafield[@tag='502']">
        <dc:description>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag='504']">
        <dc:description>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag='505']">
        <dc:description.tableOfContents>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:description.tableOfContents>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag='520']">
        <dc:description>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag='530']">
        <dc:relation.IsFormatOf>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:relation.IsFormatOf>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag='533']">
        <dc:date.created>
            <xsl:value-of select="child::marc:subfield[@code='d']"/>
        </dc:date.created>
    </xsl:template>
    <!-- relation1 -->
    <xsl:template match="marc:datafield[@tag='534']">
        <dc:relation>
            <xsl:value-of select="child::marc:subfield[@code='a']"/>
        </dc:relation>
    </xsl:template>
    <!-- Subject -->
    <xsl:template match="marc:datafield[@tag='650']">
        <xsl:for-each select="child::marc:subfield[@code='a']">
            <dc:subject>
                <xsl:value-of select="."/>
            </dc:subject>
        </xsl:for-each>
        <xsl:for-each select="child::marc:subfield[@code='x']">
            <dc:subject>
                <xsl:value-of select="."/>
            </dc:subject>
        </xsl:for-each>
        <xsl:for-each select="child::marc:subfield[@code='z']">
            <dc:subject>
                <xsl:value-of select="."/>
            </dc:subject>
        </xsl:for-each>
    </xsl:template>










    <!-- do not ouptut nodes we don't match -->
    <xsl:template match="*"/>
    <!-- match against the utf-x-wrapper class for testing purposes-->
    <xsl:template match="utfx-wrapper">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
