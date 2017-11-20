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
            <xsl:apply-templates select="title"/>
            <xsl:apply-templates select="author"/>
            <xsl:apply-templates select="abstract"/>
            <xsl:apply-templates select="yearPublished"/>
            <xsl:apply-templates select="keyword"/>
            <xsl:apply-templates select="pageEnd"/>
            <xsl:apply-templates select="publication"/>
            <xsl:apply-templates select="resourceType"/>
            <xsl:apply-templates select="conferenceName"/>
            <xsl:apply-templates select="issn_isbn"/>
            <xsl:apply-templates select="destCode"/>
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
    
    <!-- Item Title -->
    
    <xsl:template match="title">
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
    <xsl:template match="author">
     <xsl:choose>
         <!--if there are more than one author-->
         <xsl:when test= "contains(.,' &amp; ')">
             <!-- Clean up the string -->
             <xsl:variable name="authors">
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
             <xsl:variable name="l" select="string-length($authors)"/>
             <xsl:variable name="authors-trimmed" select="substring($authors,1,$l - 5)"/>
             
             <!-- output first author-->
             <xsl:call-template name="author-marc">
                 <xsl:with-param name="authors" select="$authors-trimmed"/>
                 <xsl:with-param name="marc-code" select="100"/>
             </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
             <!-- only one author -->
             <datafield tag="100" ind1="1" ind2=" ">
                 <subfield code="a">
                     <xsl:value-of select="."/>
                 </subfield>
                 <subfield code="u">
                     <xsl:value-of select="../author_affiliation"/>
                 </subfield>
             </datafield>
             
             
         </xsl:otherwise>
     </xsl:choose>  

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
                <subfield code="a"><xsl:value-of select="$first-surname"/>,<xsl:value-of select="$initials"/></subfield>
            </datafield>
            <xsl:call-template name="author-marc">
                <xsl:with-param name="authors" select="$remaining-authors"/>
                <xsl:with-param name="marc-code" select="700"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!--abstract -->
    <xsl:template match="abstract">
        <datafield tag="520" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
        
      
              
              
      
      

    <!-- Place, Publisher And Year Of Publication-->
    <xsl:template match="yearPublished">
        <datafield tag="260" ind1=" " ind2=" ">
               <subfield code="c">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    
    <!-- Keywords-->
    <xsl:template match="keyword">
        <datafield tag="653" ind1=" " ind2=" ">
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
<!--journal article information-->
    
    <!--Resource Type NR (NLA Mandatory) -->
    <xsl:template match="resourceType">
    <datafield tag="655" ind1=" " ind2="7">
        <subfield code="a">
            <xsl:value-of select="."/>
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
    
    <!--conference information-->
     
           <xsl:template match="conferenceName">
                <datafield tag="711" ind1="2" ind2=" ">
                    <subfield code="a"><xsl:value-of select="."/></subfield>
                    <xsl:variable name="date" select="../conferenceYear"/>
                    <subfield code="d"><xsl:variable name="l" select="string-length($date)"/>
                        <xsl:variable name="date-trimmed" select="substring($date,$l - 3,4)"/>
                        <xsl:value-of select="$date-trimmed"/></subfield>
                    <subfield code="c"><xsl:value-of select="../conferenceLocation"/> </subfield>
                </datafield> 
               </xsl:template>
    

    <!--issn-->
    <xsl:template match="issn_isbn">
       <xsl:choose>
           <xsl:when test="string-length(.)=9">
                <datafield tag="022" ind1=" " ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="."/>
                    </subfield>
                </datafield>
            </xsl:when>
            <xsl:otherwise>
                <datafield tag="020" ind1=" " ind2=" ">
                    <subfield code="a"><xsl:value-of select="."/>
                    </subfield>
                </datafield>
           </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
               

    <!--destCode-->
    <xsl:template match="destCode">
        <datafield tag="596" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
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
