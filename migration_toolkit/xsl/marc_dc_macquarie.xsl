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
<!-- removed h tag for title - Bron Dye - 5.3.07 -->
		
		<xsl:for-each select="marc:datafield[@tag=245]">
			<dc:title>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
						<xsl:value-of select="marc:subfield[@code='a']"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="marc:subfield[@code='b'] !=''">
					<xsl:text>: </xsl:text>
					<xsl:call-template name="removeChar">
						<xsl:with-param name="parentString">
							<xsl:value-of select="marc:subfield[@code='b']"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="marc:subfield[@code='n'] !=''">
					<xsl:text>, </xsl:text>
					<xsl:call-template name="removeChar">
						<xsl:with-param name="parentString">
							<xsl:value-of select="marc:subfield[@code='n']"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="marc:subfield[@code='p'] !=''">
					<xsl:text>, </xsl:text>
					<xsl:call-template name="removeChar">
						<xsl:with-param name="parentString">
							<xsl:value-of select="marc:subfield[@code='p']"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</dc:title>

		
			<xsl:if test="marc:subfield[@code='h']">
			<xsl:variable name="string">
				<xsl:value-of select="marc:subfield[@code='h']"/>
			</xsl:variable>
			<xsl:variable name="start">
				<xsl:value-of select="substring-after($string,'[')"/>
			</xsl:variable>
			<dc:format>
				<xsl:value-of select="substring-before($start,']')"/>
			</dc:format>
			</xsl:if>
		
		</xsl:for-each>
			
		
<!-- removed tags 100 and 700 from here "u" needs to be assigned to dc:relation - Bron Dye 22.2.2007
	reverted this 100 and 700 change 12 June 2007 - Bron Dye 
    removed 110 tag from view ref: advice from Neil - 5.3.07 - Bron Dye  -->
		<xsl:for-each select="marc:datafield[@tag=111]">
			<dc:creator>
				<xsl:value-of select="."/>
			</dc:creator>
		</xsl:for-each>
<!-- moved 711 from creator to relation - Bron Dye - 9.3.07 -->
		<xsl:for-each select="marc:datafield[@tag=711]">
			<dc:relation>
				<xsl:if test="marc:subfield[@code='a'] !=''">
					<xsl:value-of select="marc:subfield[@code='a']"/>
				</xsl:if>
				<xsl:if test="marc:subfield[@code='d'] !='' or marc:subfield[@code='c'] !=''  ">
					<xsl:text> (</xsl:text>
					<xsl:if test="marc:subfield[@code='d'] !=''">
						<xsl:value-of select="marc:subfield[@code='d']"/>
						<xsl:if test="marc:subfield[@code='d'] !='' and marc:subfield[@code='c'] !=''  ">
							<xsl:text> : </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="marc:subfield[@code='c'] !=''">
						<xsl:value-of select="marc:subfield[@code='c']"/>
					</xsl:if>
					<xsl:text>)</xsl:text>
				</xsl:if>
				
			</dc:relation>
			
		</xsl:for-each>
<!-- removed q & c from dc:creator  - Bron Dye - 5.3.07 -->
		<xsl:for-each select="marc:datafield[@tag=100]|marc:datafield[@tag=700]">
		<dc:creator>
			<xsl:call-template name="removeChar">
				<xsl:with-param name="parentString">
					<xsl:value-of select="marc:subfield[@code='a']"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="marc:subfield[@code='q'] !=''">
				<xsl:text> </xsl:text>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
						<xsl:value-of select="marc:subfield[@code='q']"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="marc:subfield[@code='c'] !=''">
				<xsl:text>, </xsl:text>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
						<xsl:value-of select="marc:subfield[@code='c']"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="marc:subfield[@code='d'] !=''">
				<xsl:text>, </xsl:text>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
						<xsl:value-of select="marc:subfield[@code='d']"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="marc:subfield[@code='u'] !=''">
				<xsl:text>. </xsl:text>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
						<xsl:value-of select="marc:subfield[@code='u']"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</dc:creator>
		</xsl:for-each>	
		
			
<!-- changed this so that 710 is displayed as relation rather than creator 21.2.2007 Bron Dye ref: Neil
	changing this to dc:creator as per Fionas request 25 May 2007 - Bron Dye
	changing this to cd:contributor - agreed upon by Fiona, Neil and Vicki 12 June 2007  -->
		<xsl:for-each select="marc:datafield[@tag=710]">
			<dc:contributor>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
				<xsl:value-of select="marc:subfield[@code='a']"/>
					</xsl:with-param>	
				</xsl:call-template>
				<xsl:if test="marc:subfield[@code='b'] !=''">
					<xsl:if test="marc:subfield[@code='a'] !=''">
						<xsl:text>. </xsl:text>
					</xsl:if>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
				<xsl:value-of select="marc:subfield[@code='b']"/>
				</xsl:with-param>	
				</xsl:call-template>
				</xsl:if>
				<xsl:if test="marc:subfield[@code='c'] !=''">
				<xsl:text>. </xsl:text>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
				<xsl:value-of select="marc:subfield[@code='c']"/>
				</xsl:with-param>	
				</xsl:call-template>
					</xsl:if>
			</dc:contributor>
		</xsl:for-each>
			<xsl:if test="$leader7='c'">
				<!--Remove attribute 6/04 jer-->
				<!--<xsl:attribute name="collection">yes</xsl:attribute>-->
				<dc:type>
					<xsl:text>collection</xsl:text>
				</dc:type>
			</xsl:if>
 <!-- removed "manuscript" from view ref: Neil 6.3.07 - Bron Dye 			<xsl:if test="$leader6='d' or $leader6='f' or $leader6='p' or $leader6='t'">
				Remove attribute 6/04 jer
				<xsl:attribute name="manuscript">yes</xsl:attribute>
				<xsl:text>manuscript</xsl:text>
			</xsl:if>   -->

		<!--	<xsl:choose>
				<xsl:when test="$leader6='a' or $leader6='t'">text</xsl:when>
				<xsl:when test="$leader6='e' or $leader6='f'">cartographic</xsl:when>
				<xsl:when test="$leader6='c' or $leader6='d'">notated music</xsl:when>
				<xsl:when test="$leader6='i' or $leader6='j'">sound recording</xsl:when>
				<xsl:when test="$leader6='k'">still image</xsl:when>
				<xsl:when test="$leader6='g'">moving image</xsl:when>
				<xsl:when test="$leader6='r'">three dimensional object</xsl:when>
				<xsl:when test="$leader6='m'">software, multimedia</xsl:when>
				<xsl:when test="$leader6='p'">mixed material</xsl:when>
			</xsl:choose>-->
	
		
		
		<xsl:for-each select="marc:datafield[@tag=655]/marc:subfield[@code='a']">
			<dc:type>
				<xsl:value-of select="."/>
			</dc:type>
		</xsl:for-each>
		
		<xsl:for-each select="marc:datafield[@tag=260]">
			<xsl:if test="marc:subfield[@code='b']!=''or marc:subfield[@code='a']!=''">
			<dc:publisher>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
						<xsl:value-of select="marc:subfield[@code='a']"/>
					</xsl:with-param>	
				</xsl:call-template>
				<xsl:if test="marc:subfield[@code='b']!=''">
					<xsl:if test="marc:subfield[@code='b']!='' and marc:subfield[@code='a']!=''">
				<xsl:text> : </xsl:text>
					</xsl:if>
				<xsl:call-template name="removeChar">
					<xsl:with-param name="parentString">
						<xsl:value-of select="marc:subfield[@code='b']"/>
					</xsl:with-param>	
				</xsl:call-template>
				</xsl:if>
			</dc:publisher>
			</xsl:if>
		</xsl:for-each>
		
		<xsl:for-each select="marc:datafield[@tag=260]/marc:subfield[@code='c']">
			<dc:date>
				<xsl:value-of select="."/>
			</dc:date>
		</xsl:for-each>

			
  		<xsl:for-each select="marc:controlfield[@tag=008]">
    			 <dc:language>
    		 <xsl:value-of select="substring($controlField008, 36, 3 )"/>
    			</dc:language>
		</xsl:for-each>
		
		
		<xsl:for-each select="marc:datafield[@tag=013]">
			<dc:subject>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:subject>
		</xsl:for-each>
		
		
		<xsl:for-each select="marc:datafield[@tag=856]/marc:subfield[@code='q']">
			<dc:format>
				<xsl:value-of select="."/>
			</dc:format>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=521]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag&gt;=500][@tag&lt;=599][not(@tag=506 or @tag=530 or @tag=540 or @tag=546 or @tag=561 or @tag=590 or @tag=591 or @tag=592 or @tag=593 or @tag=596)]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=600]">
			<dc:subject>
				
				<xsl:call-template name="subfieldSelectWithDashes">
					<xsl:with-param name="codes">abvxyz</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=610]">
			<dc:subject>
				<xsl:call-template name="subfieldSelectWithDashes">
					<xsl:with-param name="codes">abcdqx</xsl:with-param>
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
				<xsl:call-template name="subfieldSelectWithDashes">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=650]">
			<dc:subject>
				
				<xsl:call-template name="subfieldSelectWithDashes">
					<xsl:with-param name="codes">abcdxz</xsl:with-param>
					</xsl:call-template>
				</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=651]">
			<dc:subject>
				<xsl:call-template name="subfieldSelectWithDashes">
					<xsl:with-param name="codes">a</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=653]/marc:subfield[@code='a']">
		<dc:subject>
		<xsl:call-template name="removeChar">
		  		<xsl:with-param name="parentString">	<xsl:value-of select="."/></xsl:with-param>
				</xsl:call-template>
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
			<dc:description>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdu</xsl:with-param>
				</xsl:call-template>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=760]|marc:datafield[@tag=762]|marc:datafield[@tag=765]|marc:datafield[@tag=767]|marc:datafield[@tag=770]|marc:datafield[@tag=772]|marc:datafield[@tag=774]|marc:datafield[@tag=775]|marc:datafield[@tag=776]|marc:datafield[@tag=777]|marc:datafield[@tag=780]|marc:datafield[@tag=785]|marc:datafield[@tag=786]">
			<dc:relation>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">otg</xsl:with-param>
				</xsl:call-template>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=773]">
			<dc:relation>
			<xsl:if test="marc:subfield[@code='t']!=''">
				<xsl:value-of select="marc:subfield[@code='t']"/>
				<xsl:if test="marc:subfield[@code='g']!=''">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="marc:subfield[@code='g']"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="marc:subfield[@code='a']!=''">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</xsl:if>
			</dc:relation>
		</xsl:for-each>
		
		<xsl:for-each select="marc:datafield[@tag=561]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=856]/marc:subfield[@code='u']">
			<dc:identifier>
				<xsl:value-of select='.'/>
			</dc:identifier>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=852]">
			<dc:relation>
				<xsl:value-of select="marc:subfield[@code='u']"/>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=020]">
			<dc:identifier>
				<xsl:text>ISBN:</xsl:text>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:identifier>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=022]">
			<dc:identifier>
				<xsl:text>ISSN:</xsl:text>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:identifier>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=506]">
			<dc:rights>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:rights>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=540]">
			<dc:rights>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:rights>
		</xsl:for-each>
		
		<xsl:for-each select="marc:datafield[@tag=440]">
			<dc:relation>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">av</xsl:with-param>
				</xsl:call-template>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=300]">
			<dc:description>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abc</xsl:with-param>
				</xsl:call-template>
			</dc:description>
		</xsl:for-each>
		
		<xsl:for-each select="marc:datafield[@tag=246]">
			<dc:title>
			<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abnp</xsl:with-param>
				</xsl:call-template>
			</dc:title>
		</xsl:for-each>
		
		<xsl:for-each select="marc:datafield[@tag=250]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=810]">
			<dc:relation>
			<xsl:call-template name="subfieldSelect">
				<xsl:with-param name="codes">abv</xsl:with-param>
			</xsl:call-template>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=830]">
			<dc:relation>
			<xsl:call-template name="subfieldSelect">
				<xsl:with-param name="codes">av</xsl:with-param>
			</xsl:call-template>
			</dc:relation>
		</xsl:for-each>
		<!--</oai_dc:dc>-->
	</xsl:template>


<!-- 8/19/04: ntra added "marc:" prefix to datafield element -->
	<xsl:template name="datafield">
		<xsl:param name="tag"/>
		<xsl:param name="ind1"><xsl:text> </xsl:text></xsl:param>
		<xsl:param name="ind2"><xsl:text> </xsl:text></xsl:param>
		<xsl:param name="subfields"/>
		<xsl:element name="marc:datafield">
			<xsl:attribute name="tag">
				<xsl:value-of select="$tag"/>
			</xsl:attribute>
			<xsl:attribute name="ind1">
				<xsl:value-of select="$ind1"/>
			</xsl:attribute>
			<xsl:attribute name="ind2">
				<xsl:value-of select="$ind2"/>
			</xsl:attribute>
			<xsl:copy-of select="$subfields"/>
		</xsl:element>
	</xsl:template>

	<xsl:template name="subfieldSelect">
		<xsl:param name="codes">abcdefghijklmnopqrstuvwxyz</xsl:param>
		<xsl:param name="delimeter"><xsl:text> </xsl:text></xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:call-template name="removeChar">
						<xsl:with-param name="parentString">
							<xsl:value-of select="text()"/></xsl:with-param>
					</xsl:call-template><xsl:value-of select="$delimeter"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-string-length($delimeter))"/>
	</xsl:template>

	<xsl:template name="buildSpaces">
		<xsl:param name="spaces"/>
		<xsl:param name="char"><xsl:text> </xsl:text></xsl:param>
		<xsl:if test="$spaces>0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="buildSpaces">
				<xsl:with-param name="spaces" select="$spaces - 1"/>
				<xsl:with-param name="char" select="$char"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="subfieldSelectWithDashes">
		<xsl:param name="codes">abcdefghijklmnopqrstuvwxyz</xsl:param>
		<xsl:param name="delimeter"><xsl:text> -- </xsl:text></xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:call-template name="removeChar">
						<xsl:with-param name="parentString">
							<xsl:value-of select="text()"/></xsl:with-param>
					</xsl:call-template><xsl:value-of select="$delimeter"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-string-length($delimeter))"/>
	</xsl:template>

	<xsl:template name="chopPunctuation">
		<xsl:param name="chopString"/>
		<xsl:param name="punctuation"><xsl:text>.:,;/ </xsl:text></xsl:param>
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
			<xsl:otherwise><xsl:value-of select="$chopString"/></xsl:otherwise>
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
			<xsl:otherwise><xsl:value-of select="$chopString"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="removeChar">
		<xsl:param name="parentString"/>
		<xsl:variable name="lengthParentString" select="string-length($parentString)"/>
		<xsl:variable name="lastChar" select="substring($parentString,$lengthParentString)"/>
		<xsl:variable name="secondLastChar" select="substring($parentString,$lengthParentString - 1)"/>
		<xsl:choose>
			<!--<xsl:when test="secondLastChar= ' :'">
				<xsl:variable name="modifiedString"
					select="substring($parentString, 1, $lengthParentString - 5)"/>
				<xsl:value-of select="$modifiedString"/>
			</xsl:when>-->
			<xsl:when test="$lastChar= ',' or $lastChar= ':'  or $lastChar= '/' or $lastChar= '.' or $lastChar=';' or $lastChar='-'">
				<xsl:variable name="modifiedString"
					select="substring($parentString, 1, $lengthParentString - 1)"/>
				<xsl:variable name="lengthModString" select="string-length($modifiedString)"/>
				<xsl:variable name="lastChar2" select="substring($modifiedString,$lengthModString)"/>
				<xsl:choose>
				<xsl:when test="$lastChar2= ',' or $lastChar2= ':'  or $lastChar2= '/' or $lastChar2= '.' or $lastChar2= ' ' or $lastChar2= ';' or $lastChar2='-'">
					<xsl:variable name="newModifiedString"
						select="substring($modifiedString, 1, $lengthModString - 1)"/>
					<xsl:value-of select="$newModifiedString"/>
				</xsl:when>
			<xsl:otherwise><xsl:value-of select="$modifiedString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="$parentString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
</xsl:stylesheet>

<!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios/><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->
