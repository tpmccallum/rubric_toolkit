<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/" version="1.0">
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
    <xsl:template match="repository">
        <add>
            <xsl:apply-templates/>
        </add>
    </xsl:template>
    <xsl:template match="record">
        <doc>
            <xsl:apply-templates/>
        </doc>
    </xsl:template>
    <xsl:template match="metadata">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Start processing at each record node -->
    <xsl:template match="dc:title">
        <field name="title">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
    <xsl:template match="dc:creator">
        <field name="author">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
    <xsl:template match="dc:subject">
        <field name="subject">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
    <xsl:template match="dc:description">
        <field name="summary">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
    <xsl:template match="dc:relation">
        <field name="url">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
    <xsl:template match="dc:publisher">
        <field name="publisher">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
    <xsl:template match="identifier">
        <field name="bib_num">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
    <xsl:template match="dc:date">
        <field name="pubdate">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
    <xsl:template match="dc:type">
        <field name="format">
            <xsl:apply-templates/>
        </field>
    </xsl:template>
    <!-- stuff we can't use -->
    <xsl:template match="dc:identifier | dc:format | setSpec | datestamp"> </xsl:template>
</xsl:stylesheet>
