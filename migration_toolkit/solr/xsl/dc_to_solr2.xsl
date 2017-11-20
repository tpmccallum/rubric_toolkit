<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"  version="1.0">
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
    <xsl:param name="repository-root"/>
    <xsl:param name="fedora-id" select="'fake-id'"/>
    <xsl:param name="repos" select="'repos'"/>
    <xsl:variable name="fedora-id-string" select="concat($fedora-id, ':')"/>
    <xsl:output method="xml" indent="yes"/>
    <!-- strip out any whitespace around elements -->
    <xsl:strip-space elements="*"/>

    <!-- Start processing at the root node -->
    <xsl:template match="/">
       <add> <xsl:apply-templates/> </add>
    </xsl:template>
    
    <xsl:template match="repository">
        
            <xsl:apply-templates/>
       
    </xsl:template>
    <xsl:template match="record">
        <doc>
            <xsl:apply-templates select="header/*"/>
            <xsl:apply-templates select="metadata/oai_dc:dc/*"/>
        </doc>
    </xsl:template>
    <xsl:template match="oai_dc:dc">
        <doc>
            <xsl:apply-templates/>
        </doc>
    </xsl:template>
    <xsl:template match="metadata">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- For Eprints Export from USQ -->
    <xsl:template match="identifier">
        <field name="id"><xsl:value-of select="$repos"/><xsl:value-of select="substring-after(.,$fedora-id-string)"/></field>
    </xsl:template>
    <!--For Fedora - -->
    
    <xsl:template match = "dc:identifier[starts-with(.,$fedora-id-string)]" priority="5">
        <xsl:if test="not(//identifier)">
        <field name="id"><xsl:value-of select="concat($fedora-id, '_', substring-after(.,$fedora-id-string))"/></field>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*[starts-with(name(),'dc')]">
        <field name="dc_{local-name()}">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
   
    <!-- stuff we can't use -->
    <xsl:template match="setSpec | datestamp"> </xsl:template>
</xsl:stylesheet>
