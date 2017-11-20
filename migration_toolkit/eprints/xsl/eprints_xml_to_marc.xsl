<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:str="http://exslt.org/strings" version="1.0" extension-element-prefixes="str"
    exclude-result-prefixes="str" >

    <xsl:variable name="placeOfPublication" select="//field[@name='place_of_pub']"/>
    <xsl:variable name="nameOfPublisher" select="//field[@name='publisher']"/>
    <xsl:variable name="dateOfPublication" select="//field[@name='date_effective']"/>
    <xsl:variable name="nameOfPublication" select="//field[@name='publication']"/>
    <xsl:variable name="refereed" select="//field[@name='refereed']"/>
    <xsl:variable name="volume" select="//field[@name='volume']"/>
    <xsl:variable name="pageRange" select="//field[@name='pagerange']"/>
    <!-- import the ASRC subject codes -->
    <xsl:variable name="asrc" select="document('asrc.xml')"/>


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
    
    
        
      
    <!-- Start processing at each record node -->
    <xsl:template match="record">
        <collection xmlns:marc="http://www.loc.gov/MARC21/slim"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <record>
            <leader>00000nam a22000002a 4500</leader>
            <controlfield tag="008"/>
       <xsl:apply-templates/>
            <datafield tag="041" ind1="0" ind2=" ">
                <subfield code="a">
                    <xsl:text>eng </xsl:text>
                </subfield>
            </datafield>
            <datafield tag="546" ind1=" " ind2=" ">
                <subfield code="a">
                    <xsl:text>en-aus </xsl:text>
                </subfield>
            </datafield>
        </record>
            </collection>
     </xsl:template>


    <!--journal article information-->

    <!--Resource Type NR (NLA Mandatory) -->
    <xsl:template match="//field[@name='type']">
        <datafield tag="655" ind1=" " ind2="7">
            <subfield code="a">
                <xsl:choose>
                    <xsl:when test="contains(.,'Full')">
                        <xsl:value-of select="substring(.,5)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </subfield>
        </datafield>
    </xsl:template>


    <!-- Item Title -->

    <xsl:template match="field[@name='title']">
        <xsl:variable name="firstCharactersA" select="substring (., 1, 2)"/>
        <xsl:variable name="firstCharactersThe" select="substring(., 1, 4)"/>
        <xsl:choose>
            <xsl:when test="$firstCharactersA='A ' ">
                <datafield tag="245" ind1="1" ind2="2">
                    <subfield code="a">
                        <xsl:value-of select="."/>
                    </subfield>
                </datafield>
            </xsl:when>
            <xsl:when test="$firstCharactersThe='The ' ">
                <datafield tag="245" ind1="1" ind2="4">
                    <subfield code="a">
                        <xsl:value-of select="."/>
                    </subfield>
                </datafield>
            </xsl:when>
            <xsl:otherwise>
                <datafield tag="245" ind1="1" ind2="0">
                    <subfield code="a">
                        <xsl:value-of select="."/>
                    </subfield>
                </datafield>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Author-->
 
    <xsl:template match="field[@name='creators' and position() = 1]">
       <datafield tag="100" ind1="1" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::part[@name='family']"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="child::part[@name='given']"/>
            </subfield>
        </datafield>       
    </xsl:template>
    <xsl:template match="field[@name='creators' and position() > 1]">
        <datafield tag="700" ind1="1" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::part[@name='family']"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="child::part[@name='given']"/>
            </subfield>
        </datafield>
    </xsl:template>
    


    <!-- Total Number Of Pages-->

    <xsl:template match="//field[@name='pages']">
        <datafield tag="300" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>





    <!--Journal Information-->
    <xsl:template match="//field[@name='publication']">
        <datafield tag="773" ind1="0" ind2="8">
            <subfield code="t">
                <xsl:value-of select="$nameOfPublication"/>
            </subfield>
            <xsl:if test="$refereed != ''">
                <subfield code="n">
                <xsl:if test="$refereed = 'FALSE'">
                   <xsl:text>0</xsl:text>
                </xsl:if>
                <xsl:if test="$refereed = 'TRUE'">
                    <xsl:text>1</xsl:text>
                </xsl:if>
                    </subfield>
            </xsl:if>
            <xsl:if test="$volume and $pageRange != ''">
                <subfield code="g">
                    <xsl:text>Vol </xsl:text>
                    <xsl:value-of select="//field[@name='volume']"/>
                    <xsl:text>, </xsl:text>
                    <xsl:text>pp</xsl:text>
                    <xsl:value-of select="//field[@name='pagerange']"/>
                </subfield>
                </xsl:if>
        </datafield>
        
        <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="$placeOfPublication"/>
            </subfield>
            <subfield code="b">
                <xsl:value-of select="$nameOfPublisher"/>
            </subfield>
            <subfield code="c">
                
                <xsl:value-of select= "substring($dateOfPublication, 1, 4)"/>
            </subfield>
        </datafield>
    </xsl:template>



    <!--issn -->
    <xsl:template match="//field[@name='issn']">

        <datafield tag="022" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>

    <!--isbn-->
    <xsl:template match="//field[@name='isbn']">
        <datafield tag="020" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>

    <!--653 keywords-->
    <xsl:template match="//field[@name='keywords']">
        <xsl:call-template name="split">
            <xsl:with-param name="string" select="."/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="split">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="contains($string,', ')">
                <datafield tag="653" ind1=" " ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="substring-before($string, ', ')"/>
                    </subfield>
                </datafield>
                <xsl:variable name="remainder" select="substring-after($string, ', ')"/>
                <xsl:call-template name="split">
                    <xsl:with-param name="string" select="$remainder"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <datafield tag="653" ind1=" " ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="$string"/>
                    </subfield>
                </datafield>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--abstract-->
    <xsl:template match="//field[@name='abstract']">
        <datafield tag="520" ind1="3" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>

    <!--856 URL-->
    <xsl:template match="//field[@name='official_url']">
        <datafield tag="856" ind1="4" ind2=" ">
            <subfield code="u">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
        </xsl:template>
    

   <!--  Subject ASRC -->
    <xsl:template match="//field[@name='subjects']">
        
       <datafield tag="650" ind1="2" ind2="4">
            <subfield code="a">
             <xsl:apply-templates select="$asrc//node[starts-with(@label,current())]">
                  <xsl:with-param name="seperator"/>
             </xsl:apply-templates>     
            </subfield>
      </datafield>
    </xsl:template>
        
        <xsl:template match="node">
            <xsl:param name="seperator"/>
            <xsl:apply-templates select="node[1]">
                <xsl:with-param name="seperator" select="'::'"/>              
            </xsl:apply-templates>
            <xsl:value-of select="concat(@label,$seperator)"/>
        </xsl:template>


    <!-- do not ouptut nodes we don't match -->

    <xsl:template match="*"/>

    <!-- match against the utf-x-wrapper class for testing purposes-->

    <xsl:template match="utfx-wrapper">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
