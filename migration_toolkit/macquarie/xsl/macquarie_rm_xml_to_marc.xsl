<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:str="http://exslt.org/strings" version="1.0" extension-element-prefixes="str"
    exclude-result-prefixes="str">

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
    <!--import Resource Type Mapping Codes-->
    <xsl:variable name="resource_type" select="document('iris_categories_resource_type.xml')"/>
    
    <xsl:output method="xml" indent="yes"/>

    <!-- strip out any whitespace around elements -->

    <xsl:strip-space elements="*"/>

    <!-- Start processing at the root node -->

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

 <!--start processing at collection node-->
    <xsl:template match="collection">
        
        <collection xmlns:marc="http://www.loc.gov/MARC21/slim"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <xsl:apply-templates/>
        </collection>
    </xsl:template>
    
    <!-- Start processing at each record node -->
    <xsl:template match="rm4export">
        <record>
            <leader>00000nam a22000002a 4500</leader>
            <controlfield tag="008"/>
            <xsl:apply-templates select="spubtitle"/>
            <xsl:apply-templates select="sauthors"/>
            <xsl:apply-templates select="npages"/>
            <xsl:apply-templates select="sparentdoc"/>
            <xsl:apply-templates select="scust6"/>
            <xsl:apply-templates select="sisbnissn"/>
            <xsl:apply-templates select="scatname"/>
            <xsl:apply-templates select="epubcat"/>
            <xsl:apply-templates select="cref"/>
            <xsl:apply-templates select="mdesc"/>
            <xsl:apply-templates select="saou"/>
            <xsl:apply-templates select="selecloc"/>
            <xsl:apply-templates select="syear"/>
            <xsl:apply-templates select="seditor"/>
            <!-- Place, Publisher And Year Of Publication-->
            
            <datafield tag="260" ind1=" " ind2=" ">
                <subfield code="a">
                    <xsl:value-of select="splacepub"/>
                </subfield>
                <subfield code="b">
                    <xsl:value-of select="spublisher"/>
                </subfield>
                <xsl:choose>
                      <xsl:when test="syrcreate !=''">
                            <subfield code="c">
                            <xsl:value-of select="syrcreate"/>
                            </subfield>
                        </xsl:when>
                        <xsl:otherwise>
                            <subfield code="c">
                                <xsl:value-of select="syear"/>
                            </subfield>
                        </xsl:otherwise>
                    </xsl:choose>
                    

            </datafield>
            <datafield tag="041" ind1="0" ind2=" ">
                <subfield code="a">eng</subfield>
            </datafield>
            <datafield tag="546" ind1="0" ind2=" ">
                <subfield code="a">eng</subfield>
            </datafield>
        </record>
    </xsl:template>
    <!-- Item Title -->

    <xsl:template match="spubtitle">
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


    <!-- First Author -->
    <xsl:template match="sauthors">


        <!-- Clean up the string -->
        <xsl:variable name="authorsIn">
            <xsl:choose>
                <xsl:when test="contains(.,' &amp; ')">
                    <xsl:value-of select="substring-before(., ' &amp; ')"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="substring-after(., ' &amp; ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <!-- Loose the last 6 chars '2005,-->
        <xsl:variable name="authors-trimmed">
            <xsl:choose>
                <xsl:when test="contains($authorsIn,'20')">
                    <xsl:variable name="l" select="string-length($authorsIn)"/>
                    <xsl:value-of select="substring($authorsIn,1,$l - 5)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$authorsIn"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- output first author-->
          

        <xsl:call-template name="author-marc">
            <xsl:with-param name="authors" select="$authors-trimmed"/>
            <xsl:with-param name="marc-code" select="100"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="author-marc">
        <xsl:param name="authors"/>
        <xsl:param name="marc-code"/>
        <xsl:variable name="first-surname" select="substring-before($authors,',' )"/>
        <xsl:variable name="remainder" select="substring-after($authors,',')"/>
        <xsl:variable name="initials" select="substring-before($remainder,',')"/>
        <xsl:variable name="remaining-authors" select="substring-after($remainder, ',')"/>
        <xsl:if test="contains($authors, ',' )">
            <datafield tag="{$marc-code}" ind1="1" ind2=" ">
                <subfield code="a"><xsl:value-of select="$first-surname"/>,<xsl:value-of
                        select="$initials"/></subfield>
            </datafield>
            <xsl:call-template name="author-marc">
                <xsl:with-param name="authors" select="$remaining-authors"/>
                <xsl:with-param name="marc-code" select="700"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    

    
    

    <!-- Total Number Of Pages-->
    
        <xsl:template match="npages">
            <xsl:if test=". != ''">
            <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">
                    <xsl:value-of select="."/>
            <xsl:choose>
                <xsl:when test=". != 1">
            <xsl:text> pages</xsl:text>
               </xsl:when>
                <xsl:otherwise>
                    <xsl:text> page</xsl:text>
                </xsl:otherwise>
                </xsl:choose>
                </subfield>
            </datafield>
            </xsl:if>
      </xsl:template>
    <!-- record ID-->
    
    <xsl:template match="cref">  
        <xsl:if test=". != ''">
        <datafield tag="035" ind1=" " ind2=" ">
            <subfield code="a"><xsl:text>RM </xsl:text>
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
            </xsl:if>
    </xsl:template>
    

<!--Description-->
    <xsl:template match="mdesc">          
        <datafield tag="520" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
        </xsl:template>
 
    
 <!-- Department -->
    <xsl:template match="saou">   
        <datafield tag="710" ind1="2" ind2=" ">
            <subfield code="a">
                <xsl:text>Macquarie University</xsl:text>
            </subfield>   
            <subfield code="b">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
        </xsl:template>
        
 

    <!-- File Location -->
    <xsl:template match="selecloc">          
        <datafield tag="852" ind1="4" ind2="0">
            <subfield code="u">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--Journal Information-->
    <xsl:template match="sparentdoc">
        <datafield tag="773" ind1="0" ind2="8">
            <subfield code="t">
                <xsl:value-of select="."/>
            </subfield>
            <xsl:variable name="volume" select="../svolume[. !='']"/>
            <xsl:variable name="number" select="../snumber[. !='']"/>
              <xsl:variable name="pubtype" select="../epubcat[.!='']"/>
            <xsl:variable name="max" select="../sendpag[.!='']"/>
            <xsl:variable name="min" select="../sstartpag[.!='']"/>
            <xsl:variable name="pages" select="$max - $min +1"/>
            
            <subfield code="g">
                <xsl:if test="$volume or $number or $pages">
                    <xsl:if test="$volume !=''">Vol. <xsl:value-of select="$volume"/>, </xsl:if>
                    
                    <xsl:if test="$number !=''">no. <xsl:value-of select="$number"/>, </xsl:if>
                    
                    <xsl:if test="$pages">
                         <xsl:text>p. </xsl:text>
                        <xsl:value-of select="$min"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="$max"/>    
                    </xsl:if>
                </xsl:if>
            </subfield>
            <xsl:if test="../seditor!=''">
                <subfield code="a">
                    <xsl:call-template name="removeChar">
                        <xsl:with-param name="parentString">
                            <xsl:value-of select="../seditor"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:text> (ed).</xsl:text>
                  </subfield>    
            </xsl:if>

  
            <subfield code="n">
                <xsl:choose>
                    <xsl:when test="contains($pubtype,'C1') or contains($pubtype,'E1')">
                       <xsl:value-of select="1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
             </subfield>
        </datafield>

    </xsl:template>
     <!--conference information-->


    <xsl:template match="scust6">
        <xsl:if test=". !=''">
        <datafield tag="711" ind1="2" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
            <xsl:variable name="date" select="../scust5"/>
            <subfield code="d">
                <xsl:variable name="l" select="string-length($date)"/>
                <xsl:variable name="date-trimmed" select="substring($date,$l - 3,4)"/>
                <xsl:value-of select="$date-trimmed"/>
            </subfield>
            <subfield code="c">
                <xsl:value-of select="../splaceact"/>
            </subfield>
        </datafield>
            </xsl:if>
    </xsl:template>


    <!--issn-->
    <xsl:template match="sisbnissn">
        <xsl:if test=". !=''">
            <xsl:call-template name="splitter">
                <xsl:with-param name="number" select="."/>
            </xsl:call-template>
        </xsl:if>
     </xsl:template>
    <xsl:template name="splitter">
        <xsl:param name="number"/>
        <xsl:variable name="first" select="substring-before($number,';' )"/>
        <xsl:variable name="remainder" select="substring-after($number,';')"/>
        
        <xsl:choose>
            <xsl:when test="contains($number, ';' )">
                
                <xsl:choose>
                    <xsl:when test="string-length($first) &lt; 10">
                        <datafield tag="022" ind1=" " ind2=" ">
                            <subfield code="a">
                                <xsl:value-of select="$first"/>
                            </subfield>
                        </datafield>
                    </xsl:when>
                    <xsl:otherwise>
                        <datafield tag="020" ind1=" " ind2=" ">
                            <subfield code="a">
                                <xsl:value-of select="$first"/>
                            </subfield>
                        </datafield>
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:call-template name="splitter">
                    <xsl:with-param name="number" select="$remainder"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$number != ''">
                    
                    <xsl:choose>
                        <xsl:when test="string-length($first) &lt; 10">
                            <datafield tag="022" ind1=" " ind2=" ">
                                <subfield code="a">
                                    <xsl:value-of select="$number"/>
                                </subfield>
                            </datafield>
                        </xsl:when>
                        <xsl:otherwise>
                            <datafield tag="020" ind1=" " ind2=" ">
                                <subfield code="a">
                                    <xsl:value-of select="$number"/>
                                </subfield>
                            </datafield>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
            </xsl:choose>
       </xsl:template>



    <!--destCode and resource type-->
        <xsl:template match="epubcat">
        <datafield tag="596" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
        <datafield tag="655" ind1=" " ind2="7">
              <subfield code="a">
                  <xsl:apply-templates select="$resource_type//resource[starts-with(@label,current())]">
                            <xsl:with-param name="seperator"/>
                        </xsl:apply-templates>     
                    </subfield>
                </datafield>      
     </xsl:template>
    <xsl:template match="resource">
        <xsl:param name="seperator"/>
        <xsl:apply-templates select="resource[1]">
            <xsl:with-param name="seperator" select="'::'"/>              
        </xsl:apply-templates>
        <xsl:variable name="full_resource" select="concat(@label,$seperator)"/>
        <xsl:variable name="l" select="string-length($full_resource)"/>
        <xsl:variable name="type-trimmed" select="substring($full_resource,5,$l)"/>
        
        <xsl:value-of select="$type-trimmed"/>
    </xsl:template>
    <!-- remove last character-->
    <xsl:template name="removeChar">
        <xsl:param name="parentString"/>
        <xsl:variable name="lengthParentString" select="string-length($parentString)"/>
        <xsl:variable name="lastChar" select="substring($parentString,$lengthParentString)"/>
        <xsl:choose>
            <xsl:when test="$lastChar= ',' or $lastChar= ':'  or $lastChar= '/' or $lastChar= ';' or $lastChar= '.' ">
                <xsl:variable name="modifiedString"
                    select="substring($parentString, 1, $lengthParentString - 1)"/>
                <xsl:value-of select="$modifiedString"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$parentString"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>	


    <!-- do not ouptut nodes we don't match -->

    <xsl:template match="*"/>

    <!-- match against the utf-x-wrapper class for testing purposes-->

    <xsl:template match="utfx-wrapper">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
