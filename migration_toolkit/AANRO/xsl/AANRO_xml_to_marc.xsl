<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.loc.gov/MARC21/slim" xmlns:str="http://exslt.org/strings" version="1.0"
    extension-element-prefixes="str" exclude-result-prefixes="str">



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
        <collection>
        <record>
            <leader>00000nam a22000002a 4500</leader>
            <controlfield tag="008"/>
            <xsl:apply-templates select="id"/>
            <xsl:apply-templates select="doctype"/>
            <xsl:apply-templates select="pubyear"/>
            <xsl:apply-templates select="title"/>
            <xsl:apply-templates select="author"/>
            <xsl:apply-templates select="contactauthor"/>
            <xsl:apply-templates select="contactemail"/>
            <xsl:apply-templates select="startdate"/>
            <xsl:apply-templates select="researcher"/>
            <xsl:apply-templates select="sponsor"/>
            <xsl:apply-templates select="collaboration"/>
            <xsl:apply-templates select="source"/>
            <xsl:apply-templates select="isbn"/>
            <xsl:apply-templates select="issn"/>
            <xsl:apply-templates select="series"/>
            <xsl:apply-templates select="notes"/>
            <xsl:apply-templates select="abstract"/>
            <datafield tag="653" ind1=" " ind2=" ">
                <xsl:apply-templates select="keywords"/>
            </datafield>
            <xsl:apply-templates select="locality"/>
            <xsl:apply-templates select="program"/>
            <xsl:apply-templates select="subprogram"/>
            <xsl:apply-templates select="objective"/>
            <xsl:apply-templates select="background"/>
            <xsl:apply-templates select="methodology"/>
            <xsl:apply-templates select="progress"/>
            <xsl:apply-templates select="implication"/>
            <xsl:apply-templates select="weblink"/>
            <xsl:apply-templates select="fulltextlink"/>
            <xsl:apply-templates select="availability"/>
            <xsl:apply-templates select="availemail"/>
            <xsl:apply-templates select="deliverylink"/>
            <xsl:apply-templates select="deliveryemail"/>
            <xsl:apply-templates select="deliverynote"/>

        </record>
            </collection>
    </xsl:template>

    <!-- id -->
    <xsl:template match="id">
        <datafield tag="091" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- doctype -->
    <xsl:template match="doctype">
        <datafield tag="655" ind1=" " ind2="7">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
            <subfield code="2">
                <xsl:text>AANRO</xsl:text>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- pubyear -->
    <xsl:template match="pubyear">
        <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="c">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- title -->
    <xsl:template match="title">
        <datafield tag="245" ind1="1" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- author -->
    <xsl:template match="author">
        <!-- output first author-->
        <xsl:call-template name="author-marc">
            <xsl:with-param name="authors" select="."/>
            <xsl:with-param name="marc-code" select="100"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="author-marc">
        <xsl:param name="authors"/>
        <xsl:param name="marc-code"/>
        <xsl:variable name="name-with-affiliation">
            <xsl:choose>
                <xsl:when test="contains($authors, '|')">
                    <xsl:value-of select="substring-before($authors,'|')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$authors"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="contains($name-with-affiliation, ' (')">
                    <xsl:value-of select="substring-before($name-with-affiliation, ' (')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$name-with-affiliation"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
 



        <datafield tag="{$marc-code}" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="$name"/>
            </subfield>
            <xsl:call-template name="affiliation">
                <xsl:with-param name="name-with-affiliation" select="$name-with-affiliation"/>
            </xsl:call-template>
        </datafield>

        <xsl:if test="contains($authors, '|')">
            <xsl:call-template name="author-marc">
                <xsl:with-param name="authors" select="substring-after($authors,'|')"/>
                <xsl:with-param name="marc-code" select="700"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="affiliation">
        <xsl:param name="name-with-affiliation"/>
        
        <xsl:if test="contains($name-with-affiliation, ' (')">
            <subfield code="u">
                <xsl:value-of
                    select="substring-before(substring-after($name-with-affiliation, ' ('), ')')"/>
            </subfield>
        </xsl:if>
    </xsl:template>

    <!-- contactauthor -->
    <xsl:template match="contactauthor">
        <datafield tag="700" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!-- contactemail -->
    <xsl:template match="contactemail">
        <datafield tag="700" ind1=" " ind2=" ">
            <subfield code="u">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--sponsor-->
    <xsl:template match="sponsor">
        <xsl:call-template name="split">
            <xsl:with-param name="sponsors" select="."/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="split">
        <xsl:param name="sponsors"/>
        <xsl:variable name="firstSponsor" select="substring-before($sponsors,'|' )"/>
        <xsl:variable name="remainder" select="substring-after($sponsors,'|')"/>
        <xsl:choose>
            <xsl:when test="contains($sponsors, '|' )">
                <datafield tag="536" ind1=" " ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="$firstSponsor"/>
                    </subfield>
                </datafield>
                <xsl:call-template name="split">
                    <xsl:with-param name="sponsors" select="$remainder"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$sponsors != ''">
                    <datafield tag="536" ind1=" " ind2=" ">
                        <subfield code="a">
                            <xsl:value-of select="$sponsors"/>
                        </subfield>
                    </datafield>
                </xsl:if>

            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <!--source-->
    <!--TODO needs coding for multiple values 773 t d and h-->
    <xsl:template match="source">
        <datafield tag="773" ind1="0" ind2=" ">
            <subfield code="t">
                <xsl:value-of select="."/>
            </subfield>
            <!--  <subfield code="d">
                <xsl:value-of select="."/>
            </subfield>
            <subfield code="h">
                <xsl:value-of select="."/>
            </subfield>-->
        </datafield>
    </xsl:template>
    <!--isbn-->
    <xsl:template match="isbn">
        <datafield tag="020" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--series-->
    <!--TODO needs coding for multiple values 440 a and v -->
    <xsl:template match="series">
        <datafield tag="440" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
            <!--   <subfield code="v">
                <xsl:value-of select="."/>
            </subfield>-->
        </datafield>
    </xsl:template>
    <!--notes-->
    <xsl:template match="notes">
        <datafield tag="500" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--abstract-->
    <xsl:template match="abstract">
        <datafield tag="520" ind1="3" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--keywords-->
    <xsl:template match="keywords">

        <xsl:call-template name="splitter">
            <xsl:with-param name="word" select="."/>
        </xsl:call-template>

    </xsl:template>
    <xsl:template name="splitter">
        <xsl:param name="word"/>
        <xsl:variable name="first" select="substring-before($word,'|' )"/>
        <xsl:variable name="remainder" select="substring-after($word,'|')"/>

        <xsl:choose>
            <xsl:when test="contains($word, '|' )">

                <subfield code="a">
                    <xsl:value-of select="$first"/>
                </subfield>

                <xsl:call-template name="splitter">
                    <xsl:with-param name="word" select="$remainder"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$word != ''">

                    <subfield code="a">
                        <xsl:value-of select="$word"/>
                    </subfield>

                </xsl:if>

            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <!--locality-->
    <xsl:template match="locality">
        <datafield tag="522" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--weblink-->
    <xsl:template match="weblink">
        <datafield tag="856" ind1="4" ind2=" ">
            <subfield code="u">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--fulltextlink-->
    <xsl:template match="fulltextlink">
        <datafield tag="856" ind1=" " ind2=" ">
            <subfield code="u">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--availability-->
    <xsl:template match="availability">
        <datafield tag="506" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--availemail-->
    <xsl:template match="availemail">
        <datafield tag="595" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--deliverylink-->
    <xsl:template match="deliverylink">
        <datafield tag="596" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--deliveryemail-->
    <xsl:template match="deliveryemail">
        <datafield tag="597" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--deliverynote-->
    <xsl:template match="deliverynote">
        <datafield tag="598" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--collaboration-->
    <xsl:template match="collaboration">
        <datafield tag="591" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--date-->
    <!--TODO check date ranges -->
    <xsl:template match="startdate">
        <datafield tag="045" ind1="2" ind2=" ">
            <subfield code="b">
                <xsl:text>d</xsl:text>
                <xsl:value-of select="."/>
            </subfield>
            <subfield code="b">
                <xsl:text>d</xsl:text>
                <xsl:value-of select="../finishdate"/>
            </subfield>
        </datafield>
    </xsl:template>


    <!--researcher-->
    <!--TODO split on salutation -->
    <xsl:template match="researcher">

        <!-- output first author-->
        <xsl:call-template name="research">
            <xsl:with-param name="list" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="research">
        <xsl:param name="list"/>
        <xsl:variable name="singleResearcher" select="substring-before($list,'|' )"/>

        <xsl:variable name="remainder" select="substring-after($list,'|')"/>

        <!--<xsl:variable name="nameResearcher" select="substring-before($singleResearcher,$salutation)"/>
              <xsl:variable name="relator" select="substring-after($singleResearcher,$salutation)"/>-->
        <xsl:choose>
            <xsl:when test="contains($list, '|' )">
                <datafield tag="720" ind1="1" ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="$singleResearcher"/>
                    </subfield>
                    <!--<subfield code="e"><xsl:value-of select="relator"/></subfield>-->
                </datafield>
                <xsl:call-template name="research">
                    <xsl:with-param name="list" select="$remainder"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <datafield tag="720" ind1="1" ind2=" ">
                    <subfield code="a">
                        <xsl:value-of select="$list"/>
                    </subfield>
                </datafield>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--objective-->
    <xsl:template match="objective">
        <datafield tag="520" ind1="2" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--background-->
    <xsl:template match="background">
        <datafield tag="592" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--methodology-->
    <xsl:template match="methodology">
        <datafield tag="567" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--progress-->
    <xsl:template match="progress">
        <datafield tag="593" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--implication-->
    <xsl:template match="implication">
        <datafield tag="594" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--program-->
    <xsl:template match="program">
        <datafield tag="095" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--subprogram-->
    <xsl:template match="subprogram">
        <datafield tag="096" ind1=" " ind2=" ">
            <subfield code="a">
                <xsl:value-of select="."/>
            </subfield>
        </datafield>
    </xsl:template>
    <!--issn-->
    <xsl:template match="issn">
        <datafield tag="022" ind1=" " ind2=" ">
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
