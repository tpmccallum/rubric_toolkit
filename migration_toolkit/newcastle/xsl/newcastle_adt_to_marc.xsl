<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:str="http://exslt.org/strings" version="1.0" extension-element-prefixes="str" exclude-result-prefixes="str">
    
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



    <!--start processing at collection node-->
    <xsl:template match="head">
        <collection xmlns:marc="http://www.loc.gov/MARC21/slim">
          <record>
                <leader>00000nam a22000002a 4500</leader>
                <controlfield tag="008"></controlfield>
              <datafield tag="655" ind1=" " ind2=" ">
                  <subfield code="a">Australasian Digital Thesis</subfield>
              </datafield>
              <datafield tag="653" ind1=" " ind2=" ">
              <xsl:for-each select="meta[@name='dc.subject']">
                  <subfield code="a">
                          <xsl:value-of select="@content"/>
                  </subfield>
                     </xsl:for-each> 
                  </datafield>
             
        <xsl:apply-templates/>
          </record>
        </collection>
        </xsl:template>

        <xsl:template match="meta[@name='dc.title']">
            <xsl:variable name="firstCharactersA" select="substring (@content, 1, 2)"/>
            <xsl:variable name="firstCharactersThe" select="substring(@content, 1, 4)"/>
            <xsl:choose>
                <xsl:when test="$firstCharactersA='A ' ">
                    <datafield tag="245" ind1="1" ind2="2">
                        <subfield code="a">
                    <xsl:value-of select="@content"/>
                            </subfield>
                    </datafield>
                </xsl:when>
                <xsl:when test="$firstCharactersThe='The ' ">
                    <datafield tag="245" ind1="1" ind2="4">
                        <subfield code="a">
                            <xsl:value-of select="@content"/>
                        </subfield>
                    </datafield>
                </xsl:when>
                <xsl:otherwise>
                    <datafield tag="245" ind1="1" ind2="0">
                        <subfield code="a">
                            <xsl:value-of select="@content"/>
                        </subfield>
                    </datafield>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:template>

    <xsl:template match="meta[@name='dc.publisher']">
        <xsl:variable name="university" select="substring-before(@content,'.' )"/>
        <xsl:variable name="school" select="substring-after(@content,'.')"/>
      <datafield tag="710" ind1="2" ind2=" ">
          <subfield code="a"><xsl:value-of select="$university"/></subfield>
           <subfield code="b"><xsl:value-of select="$school"/></subfield>  
      </datafield>
        <datafield tag="720" ind1=" " ind2=" ">
            <subfield code="a"><xsl:value-of select="$school"/></subfield>
           
        </datafield>
        
        </xsl:template>

        <xsl:template match="meta[@name='dc.creator.personalname']">
           <datafield tag="100" ind1="1" ind2=" ">
                <subfield code="a">
                    <xsl:value-of select="@content"/>
                </subfield>
                
              </datafield>
        </xsl:template>



    
      

  <xsl:template match="meta[@name='dc.description.abstract']">
      <datafield tag="520" ind1=" " ind2=" ">
          <subfield code="a">
              <xsl:value-of select="@content"/>
          </subfield>
      </datafield>
        </xsl:template>

<xsl:template match="meta[@name='dc.date.valid']">
    <datafield tag="260" ind1=" " ind2=" ">
        <subfield code="c">
            <xsl:value-of select="@content"/>
        </subfield>
    </datafield>
        </xsl:template>

  <xsl:template match="meta[@name='dc.language']">

          <datafield tag="041" ind1="0" ind2=" ">
              <subfield code="a">
                  <xsl:choose>
                      <xsl:when test="@content = 'en'"> <xsl:value-of select="@content"/>g</xsl:when>
                      <xsl:otherwise><xsl:value-of select="@content"/></xsl:otherwise>
                  </xsl:choose>
              </subfield>

          </datafield>
      <datafield tag="546" ind1=" " ind2=" ">
          <subfield code="a">
              <xsl:choose>
                  <xsl:when test="@content = 'en'"> <xsl:value-of select="@content"/>g</xsl:when>
                  <xsl:otherwise><xsl:value-of select="@content"/></xsl:otherwise>
              </xsl:choose>
          </subfield>
      </datafield>
      </xsl:template>
        
    
  <xsl:template match="meta[@name='dc.rights']">
  <xsl:choose>
  <!-- if its the wrong copyright-->
  <xsl:when test="@content = 'http://www.unsw.edu.au/help/disclaimer.html)'">
      <datafield tag="540" ind1=" " ind2=" ">
          <subfield code="a">
              <xsl:text>http://www.newcastle.edu.au/copyright.html</xsl:text>
          </subfield>
      </datafield>
      </xsl:when>
      <xsl:when test="contains(@content, 'Copyright')">
          <xsl:variable name="l" select="string-length(@content)"></xsl:variable>
          <xsl:variable name="copyString" select="substring(@content, 0, 10)"></xsl:variable>
          <xsl:variable name="nameString" select="substring(@content, 11, $l)"></xsl:variable>
          <xsl:variable name="date" select=" //meta[@name='dc.date.valid']/@content"></xsl:variable>
          
      <datafield tag="540" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:value-of select="$copyString"/><xsl:text> </xsl:text><xsl:value-of select="$date"/><xsl:text> </xsl:text><xsl:value-of select="$nameString"/>
          </subfield>
      </datafield>
      </xsl:when>
      <xsl:otherwise>
          <datafield tag="540" ind1=" " ind2=" ">
              <subfield code="a">
                  <xsl:value-of select="@content"/>
              </subfield>
          </datafield>
      </xsl:otherwise>
   </xsl:choose>
        </xsl:template>


<xsl:template match="meta[@name='dc.description']">
   <datafield tag="502" ind1=" " ind2=" ">
        <subfield code="a">
            <xsl:value-of select="@content"/>
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
