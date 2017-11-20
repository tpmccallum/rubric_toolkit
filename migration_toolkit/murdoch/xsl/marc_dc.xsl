<?xml version="1.0" encoding="UTF-8"?>
<!-- Source: http://www.loc.gov/standards/marcxml/xslt/MARC21slim2OAIDC.xsl -->
<xsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
	<xsl:output method="xml" indent="yes"/>
	<!--Added ISBN and deleted attributes 6/04 jer-->
	<xsl:template match="/">
		<xsl:if test="marc:collection">
			<!-- Was: <oai_dc:dcCollection>-->
			<xsl:for-each select="marc:collection">
				<xsl:for-each select="marc:record">
					<oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/">
						<xsl:apply-templates select="."/>
					</oai_dc:dc>
				</xsl:for-each>
			</xsl:for-each>
			<!--Was: </oai_dc:dcCollection>-->
		</xsl:if>
		<xsl:if test="marc:record">
			<oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/">
				<xsl:apply-templates/>
			</oai_dc:dc>
		</xsl:if>
	</xsl:template>
	<xsl:template match="marc:record">
		<xsl:variable name="leader" select="marc:leader"/>
		<xsl:variable name="leader6" select="substring($leader,7,1)"/>
		<xsl:variable name="leader7" select="substring($leader,8,1)"/>
		<xsl:variable name="controlField008" select="marc:controlfield[@tag=008]"/>
		<xsl:for-each select="marc:datafield[@tag=245]">
			<dc:title>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abfghk</xsl:with-param>
				</xsl:call-template>
			</dc:title>
		</xsl:for-each>
		<!-- 11Apr07 - altered so only subfield 'a' is mapped across, instead of all subfields CLD -->
		<xsl:for-each select="marc:datafield[@tag=100]|marc:datafield[@tag=110]|marc:datafield[@tag=111]|marc:datafield[@tag=700]">
			<dc:creator>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:creator>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=655]/marc:subfield[@code='a']">
			<dc:type>
				<xsl:value-of select="."/>
			</dc:type>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=250]">
			<dc:description>
				<xsl:text>Edition or Version: </xsl:text>
				<xsl:apply-templates select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=260]">
			<dc:publisher>
				<xsl:call-template name="subfieldSelectComma">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</dc:publisher>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=260]/marc:subfield[@code='c']">
			<dc:date>
				<xsl:value-of select="."/>
			</dc:date>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=306]">
			<dc:description>
				<xsl:value-of select="."/>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=340]">
			<dc:format>
				<xsl:value-of select="."/>
			</dc:format>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=440]">
			<dc:relation>
				<xsl:apply-templates select="marc:subfield[@code='a']"/>
				<xsl:if test="marc:subfield[@code='v'] !=''">
					<xsl:text> - No. </xsl:text>
					<xsl:apply-templates select="marc:subfield[@code='v']"/>
				</xsl:if>
			</dc:relation>
		</xsl:for-each>
		<dc:language>
			<xsl:value-of select="substring($controlField008,36,3)"/>
		</dc:language>
		<xsl:for-each select="marc:datafield[@tag=856]/marc:subfield[@code='q']">
			<dc:format>
				<xsl:value-of select="."/>
			</dc:format>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=520]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=720]">
			<dc:contributor>
				<xsl:value-of select="marc:subfield[@code='a']"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="marc:subfield[@code='e']"/>
				<xsl:text>) </xsl:text>
				<xsl:value-of select="marc:subfield[@code='u']"/>
			</dc:contributor>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=521]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[500&lt;@tag][@tag&lt;=599][not(@tag=506 or @tag=520 or @tag=522 or @tag=530 or @tag=540 or @tag=546)]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=600]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=610]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=611]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=630]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=650]">
			<dc:subject>
				<xsl:call-template name="subfieldSelecthyphen">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=651]">
			<dc:subject>
				<xsl:call-template name="subfieldSelecthyphen">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=653]/marc:subfield[@code='a']">
			<dc:subject>
				<xsl:value-of select="."/>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=752]">
			<dc:coverage>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcd</xsl:with-param>
				</xsl:call-template>
			</dc:coverage>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=530]">
			<dc:relation type="original">
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdu</xsl:with-param>
				</xsl:call-template>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=760]|marc:datafield[@tag=762]|marc:datafield[@tag=765]|marc:datafield[@tag=767]|marc:datafield[@tag=770]|marc:datafield[@tag=772]|marc:datafield[@tag=774]|marc:datafield[@tag=775]|marc:datafield[@tag=776]|marc:datafield[@tag=777]|marc:datafield[@tag=780]|marc:datafield[@tag=785]|marc:datafield[@tag=786]|marc:datafield[@tag=787]">
			<dc:relation>
				<xsl:call-template name="subfieldSelectComma">
					<xsl:with-param name="codes">otg</xsl:with-param>
				</xsl:call-template>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=773]">
			<dc:relation>
				<xsl:call-template name="subfieldSelectComma">
					<xsl:with-param name="codes">otg</xsl:with-param>
				</xsl:call-template>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=852]">
			<dc:relation>
				<xsl:value-of select="marc:subfield[@code='u']"/>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=856]">
			<dc:identifier>
				<xsl:value-of select="marc:subfield[@code='u']"/>
			</dc:identifier>
		</xsl:for-each>
		<!-- Multiple Faculty/School(s) -->
		<xsl:for-each select="marc:datafield[@tag=710]">
			<dc:relation>
				<xsl:if test="marc:subfield[@code='a'] !=''">
					<xsl:apply-templates select="marc:subfield[@code='a']"/>
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:if test="marc:subfield[@code='b'] !=''">
					<xsl:apply-templates select="marc:subfield[@code='b']"/>
				</xsl:if>
				<xsl:if test="marc:subfield[@code='c'] !=''">
					<xsl:text>, </xsl:text>
					<xsl:apply-templates select="marc:subfield[@code='c']"/>
				</xsl:if>
			</dc:relation>
		</xsl:for-each>
		<!--patent number -->
		<xsl:for-each select="marc:datafield[@tag=013]">
			<dc:identifier>
				<xsl:value-of select="marc:subfield[@code='a']"/>
				<xsl:choose>
					<xsl:when test="marc:subfield[@code='b'] !='at'">
						<xsl:text>, </xsl:text>
						<xsl:apply-templates select="marc:subfield[@code='b']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>, Australia</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</dc:identifier>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=020]">
			<dc:identifier>
				<xsl:text>ISBN </xsl:text>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:identifier>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=022]">
			<dc:identifier>
				<xsl:text>ISSN </xsl:text>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:identifier>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=711]">
			<dc:relation>
				<xsl:if test="marc:subfield[@code='a'] !=''">
					<xsl:value-of select="marc:subfield[@code='a']"/>
				</xsl:if>
				<xsl:if test="marc:subfield[@code='c'] !=''">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="marc:subfield[@code='c']"/>
				</xsl:if>
				<xsl:if test="marc:subfield[@code='d'] !=''">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="marc:subfield[@code='d']"/>
				</xsl:if>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=506]">
			<dc:rights>
				<xsl:call-template name="subfieldSelectcolon">
					<xsl:with-param name="codes">abcdeu</xsl:with-param>
				</xsl:call-template>
			</dc:rights>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=540]">
			<dc:rights>
				<xsl:call-template name="subfieldSelectcolon">
					<xsl:with-param name="codes">abcdu</xsl:with-param>
				</xsl:call-template>
			</dc:rights>
		</xsl:for-each>
		<!--</oai_dc:dc>-->
	</xsl:template>
	<!-- 8/19/04: ntra added "marc:" prefix to datafield element -->
	<xsl:template name="datafield">
		<xsl:param name="tag"/>
		<xsl:param name="ind1">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:param name="ind2">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:param name="subfields"/>
		<xsl:element name="marc:datafield">
			<xsl:attribute name="tag"><xsl:value-of select="$tag"/></xsl:attribute>
			<xsl:attribute name="ind1"><xsl:value-of select="$ind1"/></xsl:attribute>
			<xsl:attribute name="ind2"><xsl:value-of select="$ind2"/></xsl:attribute>
			<xsl:copy-of select="$subfields"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="subfieldSelect">
		<xsl:param name="codes">abcdefghijklmnopqrstuvwxyz</xsl:param>
		<xsl:param name="delimeter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()"/>
					<xsl:value-of select="$delimeter"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-string-length($delimeter))"/>
	</xsl:template>
	<xsl:template name="subfieldSelecthyphen">
		<xsl:param name="codes">abcdefghijklmnopqrstuvwxyz</xsl:param>
		<xsl:param name="delimeter">
			<xsl:text> - </xsl:text>
		</xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()"/>
					<xsl:value-of select="$delimeter"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-string-length($delimeter))"/>
	</xsl:template>
	<xsl:template name="subfieldSelectcolon">
		<xsl:param name="codes">abcdefghijklmnopqrstuvwxyz</xsl:param>
		<xsl:param name="delimeter">
			<xsl:text> : </xsl:text>
		</xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()"/>
					<xsl:value-of select="$delimeter"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-string-length($delimeter))"/>
	</xsl:template>
	<xsl:template name="subfieldSelectComma">
		<xsl:param name="codes">abcdefghijklmnopqrstuvwxyz</xsl:param>
		<xsl:param name="delimeter">
			<xsl:text>, </xsl:text>
		</xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()"/>
					<xsl:value-of select="$delimeter"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-string-length($delimeter))"/>
	</xsl:template>
	<xsl:template name="subfieldSelectfullstop">
		<xsl:param name="codes">abcdefghijklmnopqrstuvwxyz</xsl:param>
		<xsl:param name="delimeter">
			<xsl:text>. </xsl:text>
		</xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()"/>
					<xsl:value-of select="$delimeter"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-string-length($delimeter))"/>
	</xsl:template>
	<xsl:template name="buildSpaces">
		<xsl:param name="spaces"/>
		<xsl:param name="char">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:if test="$spaces>0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="buildSpaces">
				<xsl:with-param name="spaces" select="$spaces - 1"/>
				<xsl:with-param name="char" select="$char"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="chopPunctuation">
		<xsl:param name="chopString"/>
		<xsl:param name="punctuation">
			<xsl:text>.:,;/ </xsl:text>
		</xsl:param>
		<xsl:variable name="length" select="string-length($chopString)"/>
		<xsl:choose>
			<xsl:when test="$length=0"/>
			<xsl:when test="contains($punctuation, substring($chopString,$length,1))">
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString" select="substring($chopString,1,$length - 1)"/>
					<xsl:with-param name="punctuation" select="$punctuation"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($chopString)"/>
			<xsl:otherwise>
				<xsl:value-of select="$chopString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="chopPunctuationFront">
		<xsl:param name="chopString"/>
		<xsl:variable name="length" select="string-length($chopString)"/>
		<xsl:choose>
			<xsl:when test="$length=0"/>
			<xsl:when test="contains('.:,;/[ ', substring($chopString,1,1))">
				<xsl:call-template name="chopPunctuationFront">
					<xsl:with-param name="chopString" select="substring($chopString,2,$length - 1)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($chopString)"/>
			<xsl:otherwise>
				<xsl:value-of select="$chopString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios/><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->
