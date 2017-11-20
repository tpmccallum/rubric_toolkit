<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.loc.gov/MARC21/slim" xmlns:str="http://exslt.org/strings" version="1.0"
    extension-element-prefixes="str" exclude-result-prefixes="str">
    <!-- Specify output options -->
    <!-- Output XML and indent, make it pretty -->
    <!--
#
#    Copyright (C) 2005-2006  Distance and e-Learning Centre, 
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
    <xsl:template match="xml">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="records">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Start processing at each record node -->
    <xsl:template match="record">
        <collection>
            <record>
                <leader>00000nam a22000002a 4500</leader>
                <controlfield tag="008"> 20uu9999 |||||s|||||00| 0|eng d </controlfield>
                <xsl:apply-templates/>
                <datafield tag="540" ind1=" " ind2=" ">
                    <subfield code="a">*</subfield>
                </datafield>
                <datafield tag="041" ind1="0" ind2=" ">
                    <subfield code="a">eng</subfield>
                </datafield>
                <datafield tag="546" ind1="0" ind2=" ">
                    <subfield code="a">eng</subfield>
                </datafield>
            </record>
        </collection>
    </xsl:template>
    <!-- Item Title -->
    <xsl:template match="titles">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="title">
        <datafield tag="245" ind1="0" ind2="0">
            <subfield code="a">
                <xsl:value-of select="child::style"/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- Authors &amp; Institution Details-->
    <xsl:template match="contributors">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="authors">
        <xsl:for-each select="child::author">
            <xsl:choose>
                <xsl:when test="position() = 1">
                    <datafield tag="100" ind1="1" ind2=" ">
                        <subfield code="a">
                            <xsl:value-of select="child::style"/>
                        </subfield>
                        <xsl:if test="child::style[@face='bold']">
                            <subfield code="u">
                                <xsl:text>University of Newcastle</xsl:text>
                            </subfield>
                        </xsl:if>
                    </datafield>
                </xsl:when>
                <xsl:otherwise>
                    <datafield tag="700" ind1="1" ind2=" ">
                        <subfield code="a">
                            <xsl:value-of select="child::style"/>
                        </subfield>
                        <xsl:if test="child::style[@face='bold']">
                            <subfield code="u">
                                <xsl:text>University of Newcastle</xsl:text>
                            </subfield>
                        </xsl:if>
                    </datafield>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
        <!-- Item Level affiliation -->
        <!--<datafield tag="710" ind1="2" ind2=" ">
            <subfield code="a">
                <xsl:text>University of Newcastle</xsl:text>
            </subfield>
        </datafield>
    -->
    <!-- Abstract -->
    <xsl:template match="abstract">
        <datafield tag="520" ind1="3" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::style"/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- Total Pages -->
    <xsl:template match="pages">
        <datafield tag="300" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::style"/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- Publication Details -->
    <xsl:template match="pub-location">
        <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::style"/>
            </subfield>
            <subfield code="b">
                <xsl:value-of select="../publisher/style"/>
            </subfield>
            <subfield code="c">
                <xsl:value-of select="../dates/year/style"/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- URL and Copyright -->
  <!--  <xsl:template match="urls">
       
        <datafield tag="856" ind1="4" ind2="0">
            <subfield code="u">
                <xsl:for-each select="str:split(child::related-urls/url/style,' ')">
                    <xsl:if test="substring(node(), 1, string-length('http://')) = 'http://'">
                        <xsl:value-of select="node()"/>
                    </xsl:if>
                </xsl:for-each>
            </subfield>
        </datafield>
    </xsl:template>-->
    <!-- Keywords -->
    <xsl:template match="keywords">
        <datafield tag="653" ind1=" " ind2=" ">
            <xsl:for-each select="child::keyword">
                <subfield code="a">
                    <xsl:value-of select="child::style"/>
                </subfield>
            </xsl:for-each>
        </datafield>
    </xsl:template>
    <!-- Item Type -->
    <!-- convert the type to lower case as well -->
    <xsl:template match="ref-type">
        <datafield tag="655" ind1=" " ind2="7">
            <subfield code="a">
                <xsl:value-of
                    select="translate(@name, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"
                />
            </subfield>
        </datafield>
        
        <xsl:call-template name="additional-information">
            <xsl:with-param name="type-code" select="."/>
        </xsl:call-template>
    </xsl:template>
    <!-- DEST Information -->
    <xsl:template match="custom1">
        <datafield tag="591" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:text>2005</xsl:text>
            </subfield>
        </datafield>
        <datafield tag="592" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::style"/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- Determine item specific information -->
    <xsl:template name="additional-information">
        <xsl:param name="type-code"/>
        <xsl:choose>
            <xsl:when test="$type-code = '17'">
               <datafield tag="773" ind1="0" ind2=" ">
                    <subfield code="t">
                        <xsl:value-of select="../titles/secondary-title"/>
                    </subfield>
                    <xsl:choose>
                        <!-- Peer reviewed tag, 1 = true, 0 = false -->
                        <xsl:when test="../custom1/style = 'C1'">
                            <subfield code="n">1</subfield>
                        </xsl:when>
                        <xsl:otherwise>
                            <subfield code="n">0</subfield>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="../volume/style !='NONE'">
                            <xsl:variable name="pageDetails" select="../pages/style"></xsl:variable>
                            <xsl:if test="../number/style !='' and ../pages/style !=''">
                    <subfield code="g"> Vol. <xsl:value-of select="../volume/style"/>, no. <xsl:value-of select="../number/style"/><xsl:text>, </xsl:text>
                        <xsl:call-template name="pagePrefix">
                            <xsl:with-param name="pagenation" select="$pageDetails"/>
                        </xsl:call-template>
                    </subfield>
                            </xsl:if>
                             <xsl:if test="not(../number/style !='') and ../pages/style !=''">
                                 <subfield code="g"> Vol. <xsl:value-of select="../volume/style"/><xsl:text>, </xsl:text>
                                     <xsl:call-template name="pagePrefix">
                                     <xsl:with-param name="pagenation" select="$pageDetails"/>
                                 </xsl:call-template>
                            </subfield>
                             </xsl:if>
                             <xsl:if test="../number/style !='' and not(../pages/style !='')">
                                 <subfield code="g"> Vol. <xsl:value-of select="../volume/style"/> no. <xsl:value-of select="../number/style"/>
                                 </subfield>
                             </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <subfield code="g"> Vol. <xsl:value-of select="../volume/style"/>
                                </subfield>
                                </xsl:otherwise>
                        </xsl:choose>
                </datafield>
                <datafield tag="022" ind1=" " ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="../isbn/style"/>
                    </subfield>
                </datafield>
            </xsl:when>
            <xsl:when test="$type-code='10'">
                <!-- This is a Conference -->
                <datafield tag="773" ind1="0" ind2=" ">
                    <subfield code="t">
                        <xsl:value-of select="../titles/secondary-title"/>
                    </subfield>
                    <xsl:choose>
                        <!-- Peer reviewed tag, 1 = true, 0 = false -->
                        <xsl:when test="../custom1/style = 'C1'">
                            <subfield code="n">1</subfield>
                        </xsl:when>
                        <xsl:otherwise>
                            <subfield code="n">0</subfield>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="../volume/style !='NONE'">
                            <xsl:variable name="pageDetails" select="../pages/style"></xsl:variable>
                            <xsl:if test="../dates/year/style !='' and ../pages/style !=''">
                                <subfield code="g"><xsl:value-of select="../volume/style"/><xsl:text> (</xsl:text><xsl:value-of select="../dates/year/style"/><xsl:text>), </xsl:text>
                                    <xsl:call-template name="pagePrefix">
                                        <xsl:with-param name="pagenation" select="$pageDetails"/>
                                    </xsl:call-template>
                                </subfield>
                            </xsl:if>
                            <xsl:if test="not(../dates/year/style !='') and ../pages/style !=''">
                                <subfield code="g"><xsl:value-of select="../volume/style"/><xsl:text>, </xsl:text>
                                    <xsl:call-template name="pagePrefix">
                                        <xsl:with-param name="pagenation" select="$pageDetails"/>
                                    </xsl:call-template>
                                </subfield>
                            </xsl:if>
                            <xsl:if test="../dates/year/style !='' and not(../pages/style !='')">
                                <subfield code="g"><xsl:value-of select="../volume/style"/><xsl:text> (</xsl:text><xsl:value-of select="../dates/year/style"/><xsl:text>)</xsl:text>
                                </subfield>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <subfield code="g"><xsl:value-of select="../volume/style"/>
                            </subfield>
                        </xsl:otherwise>
                    </xsl:choose>
                </datafield>
              
                <datafield tag="711" ind1="0" ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="../titles/tertiary-title/style"/>
                    </subfield>
                    <subfield code="c">
                        <xsl:value-of select="../custom2/style"/>
                    </subfield>
                    <subfield code="d">
                        <xsl:value-of select="../custom3/style"/>
                    </subfield>
                </datafield>
                <datafield tag="020" ind1=" " ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="../isbn/style"/>
                    </subfield>
                </datafield>
            </xsl:when>
            <xsl:when test="$type-code = '25'">
                <!-- This is a patent -->
                
                <datafield tag="013" ind1="0" ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="../number/style"/>
                    </subfield>
                </datafield>
                <datafield tag="653" ind1=" " ind2=" ">
                    <xsl:for-each select="str:split(../isbn/style,';')">
                        <subfield code="a">
                            <xsl:value-of select="."/>
                        </subfield>
                    </xsl:for-each>
                </datafield>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- decide which pagenation prefix to use-->
    <xsl:template name="pagePrefix">
   
        <xsl:param name="pagenation"/>
        <xsl:choose>
            <xsl:when test="contains($pagenation,'pages')">
                <xsl:value-of select="$pagenation"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>p. </xsl:text><xsl:value-of select="$pagenation"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Callista -->
    <xsl:template match="electronic-resource-num">
        <datafield tag="024" ind1="8" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::style"/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- do not ouptut nodes we don't match -->
    <xsl:template match="*"/>
    <!-- match against the utf-x-wrapper class for testing purposes-->
    <xsl:template match="utfx-wrapper">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
