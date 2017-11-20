<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.loc.gov/MARC21/slim"
    xmlns:str="http://exslt.org/strings" version="1.0" extension-element-prefixes="str"
    exclude-result-prefixes="str">

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
    
    <!--start processing at collection node-->
    <xsl:template match="collection">  
        <collection>
            <xsl:apply-templates/>
        </collection>
    </xsl:template>
    

    <!-- Start processing at each record node -->
    <xsl:template match="record">
        <record>
    <leader>00000nam a22000002a 4500</leader>
    <controlfield tag="008"> 20uu9999 |||||s|||||00| 0|eng d </controlfield>
            <xsl:apply-templates select="Aq_Nr"/>
            <xsl:apply-templates select="Family_Name"/>
            <xsl:apply-templates select="Status"/>
            <xsl:apply-templates select="Bc_Nr"/>
            <xsl:apply-templates select="Collect_Name"/>
            <xsl:apply-templates select="Additional_Collectors"/>
            <xsl:apply-templates select="Collect_Date"/>
            <xsl:apply-templates select="Deter_Name"/>
            <xsl:apply-templates select="destCode"/>
            <xsl:apply-templates select="Floristic"/>
            <xsl:apply-templates select="Habitat"/>
            <xsl:apply-templates select="Additional"/>
            
            
            
            <xsl:if test="Region_Name != '' or District_Name != '' or Locality != '' ">
                  <datafield tag="662" ind1=" " ind2=" ">
                      <xsl:if test="Region_Name != ''">
                      <subfield code="b"><xsl:value-of select="//Region_Name"/></subfield>
                          </xsl:if>
                      <xsl:if test="District_Name != ''">
                        <subfield code="c"><xsl:value-of select="//District_Name"/></subfield>
                              </xsl:if>
                      <xsl:if test="Locality != ''">
                        <subfield code="g"><xsl:value-of select="//Locality"/></subfield>
                                  </xsl:if>
                    </datafield>
               </xsl:if>
        <datafield tag="041" ind1="0" ind2=" ">
            <subfield code="a">
                <xsl:text>eng</xsl:text>
            </subfield>
        </datafield>
        <datafield tag="546" ind1="0" ind2=" ">
            <subfield code="a">
                <xsl:text>eng</xsl:text>
            </subfield>      
        </datafield>
    </record>   
</xsl:template>
    
   
    <!--aquisition_number -->
    <!--<xsl:template match="Aq_Nr">
        <datafield tag="024" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>-->
        
        <!--Family_Name & Botanical name-->
    <xsl:template match="Family_Name">
        <datafield tag="243" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
           <subfield code="g">
                <xsl:value-of select="../Botanical_Name"/>
            </subfield>
        </datafield>
    </xsl:template>

    
    <!--status -->
    <xsl:template match="Status">
        <datafield tag="513" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>

    <!--status -->
   <!-- <xsl:template match="Bc_Nr">
        <datafield tag="088" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>-->
    
    <!--Collector Name -->
    <xsl:template match="Collect_Name">
        <datafield tag="100" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    
    <!--Additional Collector Name -->
    <!--<xsl:template match="Additional_Collectors">
        <datafield tag="700" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>-->
    
    <!-- Collection_Date-->
    <xsl:template match="Collect_Date">
        <xsl:variable name="det_date" select="../Deter_Date"/>
        <datafield tag="046" ind1=" " ind2=" ">
            <subfield code="a">m</subfield>
            <subfield code="k"> <xsl:value-of select="."/></subfield>
            <xsl:if test="$det_date !=''">
            <subfield code="l"> <xsl:value-of select="$det_date"/></subfield>
            </xsl:if>
        </datafield>
    </xsl:template>
    
    
    
    <!-- Deter_Name-->
    <!--<xsl:template match="Deter_Name">
        <datafield tag="508" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>-->
    
    <!-- Floristic-->
    <!--<xsl:template match="Floristic">
        <datafield tag="655" ind1=" " ind2=" ">
            <subfield code="b">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    -->
    <!-- Habitat-->
    <!--<xsl:template match="Habitat">
        <datafield tag="522" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>-->
    
    <!-- Additional-->
    <xsl:template match="Additional">
        <datafield tag="500" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    
      
    
        
        
        <!-- Total Number Of Pages-->
        <xsl:template match="pageEnd">
            <xsl:variable name="max" select="."/>
            <xsl:variable name="min" select="../pageStart"/>
            
            <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">
                    <xsl:if test="$max != '' or $min != ''">                  
                        <xsl:value-of select="($max - $min) + 1">
                        </xsl:value-of>
                    </xsl:if>
                </subfield>
            </datafield>
        </xsl:template>


    <!--Journal Information-->
    <xsl:template match="publication">
        <datafield tag="773" ind1="0" ind2="8">
            <subfield code="t">
                <xsl:value-of select="."/>
            </subfield>
            <xsl:variable name="volume" select="../volume[. !='']"/>
            <xsl:variable name="number" select="../number[. !='']"/>
            <xsl:variable name="pages" select="../pages[. !='']"/>
            
              
                <subfield code="g">
                    <xsl:if test="$volume or $number or $pages">
                        <xsl:if test="$volume">Vol. <xsl:value-of select="$volume"/></xsl:if>
                    <xsl:if test="$number or $pages">, </xsl:if>
                    <xsl:if test="$number">no. <xsl:value-of select="$number"/></xsl:if> 
                    <xsl:if test="$pages">, </xsl:if>
                    <xsl:if test="$pages"><xsl:value-of select="$pages"/></xsl:if>
                    </xsl:if> 
             </subfield>
           
            <subfield code="n">
                <xsl:call-template name="extractbetweenbrackets">
                    <xsl:with-param name="string" select="../itemType"/>
                </xsl:call-template>
            </subfield>
            </datafield>
        
    </xsl:template>
    
  
    
    <!--template to extract Refereed, Research from Journal Information-->
    <xsl:template name="extractbeforebrackets">
        <xsl:param name="string"/>
        <xsl:variable name="beforebrackets">
            <xsl:value-of select="substring-before($string,'(')"/>
        </xsl:variable>
        <xsl:value-of select="$beforebrackets"/>
    </xsl:template>
    
    <!--template to extract Refereed, Research from Journal Information-->
    <xsl:template name="extractbetweenbrackets">
        <xsl:param name="string"/>
        <xsl:variable name="afterbrackets">
            <xsl:value-of select="substring-after($string,'(')"/>
        </xsl:variable>
        <xsl:value-of select="substring-before($afterbrackets,')')"/>
    </xsl:template>


    <!-- do not ouptut nodes we don't match -->

    <xsl:template match="*"/>

    <!-- match against the utf-x-wrapper class for testing purposes-->

    <xsl:template match="utfx-wrapper">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
