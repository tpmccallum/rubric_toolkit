<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
   
   

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
    <xsl:variable name="resource_type" select="document('uon_categories_resource_type.xml')"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- strip out any whitespace around elements -->

    <xsl:strip-space elements="*"/>

    
    <!-- Start processing at the root node -->

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!--start processing at collection node-->
    <xsl:template match="collection">

      
            <xsl:apply-templates/>
        
    </xsl:template>

    <!-- Start processing at each record node -->
    <xsl:template match="record">
        <Session>
            <Step>4</Step>
            <Attachments/>
            <Formdata>
              
                
                
          <xsl:apply-templates select="CPE_UID"/>
                <!--   <xsl:apply-templates select="UID_FLD"/>-->
       
            <xsl:apply-templates select="ORGCAT_FLD"/>
             <xsl:apply-templates select="PUBYEAR_FLD"/>
           <!-- <xsl:apply-templates select="COLYEAR_FLD"/>-->
            <xsl:apply-templates select="CITATION"/>
                <faculty></faculty>
                <function>save_formdata</function>
                <language>eng</language>
                <rights></rights>
            <xsl:apply-templates select="TITLE1_FLD"/>
             
            <xsl:apply-templates select="PUBLISHER"/>
          
            </Formdata>
            </Session>
    </xsl:template>
    
   <xsl:template match="CITATION">
       <xsl:call-template name="author-marc">
           <xsl:with-param name="authors" select="."/>
           <xsl:with-param name="count" select="0"/>
       </xsl:call-template>
   </xsl:template>
   <xsl:template name="split-and-display">
        <xsl:param name="counter" select="0"></xsl:param>
        <xsl:param name="author-string"/>
        <xsl:variable name="first-author" select="substring-before($author-string,',' )"/>
        <xsl:variable name="remainder" select="substring-after($author-string,', ' )"/>
        <xsl:if test="$first-author">
        <xsl:choose>
        <xsl:when test="$counter = 0">
            <creator_last_name><xsl:value-of select="substring-before($first-author, ' ')"/></creator_last_name>
            <creator_first_name><xsl:value-of select="substring-after($first-author, ' ')"/></creator_first_name>
            <xsl:if test="substring-after($remainder, ',') = '*flag*'" >
                <xsl:element name="_count_creator-multiple_creators"><xsl:value-of select="1"/></xsl:element>
                </xsl:if>
        </xsl:when>
         <xsl:otherwise>
             <xsl:element name="creator_last_name_{$counter}"><xsl:value-of select="substring-before($first-author, ' ')"/></xsl:element>
             <xsl:element name="creator_first_name_{$counter}"><xsl:value-of select="substring-after($first-author, ' ')"/></xsl:element>
            
            <xsl:if test="substring-after($remainder, ',') = '*flag*'" >
                 <xsl:element name="_count_creator-multiple_creators"><xsl:value-of select="$counter + 1"/></xsl:element>
                 </xsl:if>
             
           </xsl:otherwise>   
        </xsl:choose>
            <xsl:call-template name="split-and-display">
             <xsl:with-param name="author-string" select="$remainder"/>
                    <xsl:with-param name="counter" select="$counter + 1"/>
            </xsl:call-template>
        </xsl:if>
     
        </xsl:template>

        <xsl:template name="author-marc">
        <xsl:param name="authors"/>
        <xsl:param name="count"/>
      <xsl:call-template name="split-and-display">
                <xsl:with-param name="author-string" select="concat($authors,',*flag*')"/>
          
          </xsl:call-template>
        </xsl:template>
    
    
    
    
    <xsl:template match="CPE_UID">
    <xsl:element name="session"><xsl:text>uon-P</xsl:text><xsl:value-of select="../UID_FLD"/><xsl:text>-CPE</xsl:text><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    
    <xsl:template match="ORGCAT_FLD"> 
       
        <xsl:variable name="orgcat" select="."/>
        <xsl:choose>
            <xsl:when test="$orgcat = 'C1'">
                <dest_category><xsl:value-of select="."/></dest_category>
                <journal_peer_reviewed>Yes</journal_peer_reviewed>
            </xsl:when>
            <xsl:when test="$orgcat = 'E1'">
                <dest_category><xsl:value-of select="."/></dest_category>
                <conference_peer_reviewed>Yes</conference_peer_reviewed>
            </xsl:when>
            <xsl:otherwise>
                <dest_category><xsl:value-of select="."/></dest_category>
            </xsl:otherwise>
        </xsl:choose>
      <xsl:element name="resource_type">
            <xsl:apply-templates select="$resource_type//resource[starts-with(@label,current())]">
            <xsl:with-param name="seperator"/>
            </xsl:apply-templates>     
        </xsl:element>
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
    
    <xsl:template match= "PUBYEAR_FLD">
        <year><xsl:value-of select="."/></year>
     </xsl:template>
    
    <xsl:template match= "TITLE1_FLD">
        <title><xsl:value-of select="."/></title>
    </xsl:template>
    
   
    
    
    <xsl:template match= "PUBLISHER">
        <xsl:if test="contains(../ORGCAT_FLD, 'A' )">
            <book_isbn><xsl:value-of select="../ISBN_OR_ISSN"/></book_isbn>
            <book_publisher><xsl:value-of select="../PUBLISHER"/></book_publisher>
            <book_place_publication><xsl:value-of select="../PLACE_PUBLISHED"/></book_place_publication>
            
        </xsl:if>
        <xsl:if test="contains(../ORGCAT_FLD, 'B' )">
            <chapter_isbn><xsl:value-of select="../ISBN_OR_ISSN"/></chapter_isbn>
            <chapter_publisher><xsl:value-of select="../PUBLISHER"/></chapter_publisher>
            <chapter_page_from><xsl:value-of select="substring-before(../PAGE_NUMBERS, '-')"/></chapter_page_from>
            <chapter_page_to><xsl:value-of select="substring-after(../PAGE_NUMBERS, '-')"/></chapter_page_to>
            <chapter_editor><xsl:value-of select="../EDITOR_OF_BOOK"/></chapter_editor>
            <chapter_book_title><xsl:value-of select="../TITLE_OF_BOOK"/></chapter_book_title>
            <chapter_place_publication><xsl:value-of select="../PLACE_PUBLISHED"/></chapter_place_publication>
            <chapter_edition><xsl:value-of select="../EDITION"/></chapter_edition>
        </xsl:if>
        <xsl:if test="contains(../ORGCAT_FLD, 'C' )">
        <journal_publisher><xsl:value-of select="../PUBLISHER"/></journal_publisher>
            <journal_place_publication><xsl:value-of select="../PLACE_PUBLISHED"/></journal_place_publication>
                <journal_issn><xsl:value-of select="../ISBN_OR_ISSN"/></journal_issn>
                <journal_title><xsl:value-of select="../JOURNAL"/></journal_title>
                <journal_volume><xsl:value-of select="../VOLUME"/></journal_volume>
                <journal_issue><xsl:value-of select="../ISSUE"/></journal_issue>
                <journal_page_from><xsl:value-of select="substring-before(../PAGE_NUMBERS, '-')"/></journal_page_from>
            <journal_page_to><xsl:value-of select="substring-after(../PAGE_NUMBERS, '-')"/></journal_page_to>
        </xsl:if>
        
        <xsl:if test="contains(../ORGCAT_FLD, 'D' )">
            <review_publisher><xsl:value-of select="../PUBLISHER"/></review_publisher>
            <review_place_publication><xsl:value-of select="../PLACE_PUBLISHED"/></review_place_publication>
            <review_issn><xsl:value-of select="../ISBN_OR_ISSN"/></review_issn>
            <review_title><xsl:value-of select="../JOURNAL"/></review_title>
            <review_volume><xsl:value-of select="../VOLUME"/></review_volume>
            <review_issue><xsl:value-of select="../ISSUE"/></review_issue>
            <review_page_from><xsl:value-of select="substring-before(../PAGE_NUMBERS, '-')"/></review_page_from>
            <review_page_to><xsl:value-of select="substring-after(../PAGE_NUMBERS, '-')"/></review_page_to>
        </xsl:if>
        <xsl:if test="contains(../ORGCAT_FLD, 'E' )">
            <conference_place_publication><xsl:value-of select="../PLACE_PUBLISHED"/></conference_place_publication>
            <conference_publisher><xsl:value-of select="../PUBLISHER"/></conference_publisher>
           <conference_location><xsl:value-of select="../CONFERENCE_LOCATION"/></conference_location>
         <conference_title><xsl:value-of select="../CONFERENCE_PUBLICATION"/></conference_title>
         </xsl:if>
       
    </xsl:template>
    
    

    
</xsl:stylesheet>
