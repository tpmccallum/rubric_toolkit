<?xml version="1.0" encoding="UTF-8"?>

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
   
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/">
    <xsl:output method="xml" indent="yes"/>

    <!-- strip out any whitespace around elements -->

    <xsl:strip-space elements="*"/>


    <!-- Start processing at the root node -->

    <xsl:template match="/">

        <xsl:apply-templates/>

    </xsl:template>

    <xsl:template match="collection">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="//record">
        <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
            xmlns:dc="http://purl.org/dc/elements/1.1/">
            <xsl:apply-templates select="datafield[@tag='245']/subfield[@code='h']"/>
            <xsl:apply-templates select="datafield[@tag='856']/subfield[@code='u']"/>
            <xsl:apply-templates select="datafield[@tag='245']"/>
            <xsl:apply-templates select="datafield[@tag='100']"/>
            <xsl:apply-templates select="datafield[@tag='700']"/>
            <xsl:apply-templates select="controlfield[@tag='546']"/>
            <xsl:apply-templates select="datafield[@tag='710']"/>
            <xsl:apply-templates select="leader"/>
            <xsl:apply-templates select="datafield[@tag='655']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='260']"/>
            <xsl:apply-templates select="controlfield[@tag='008']"/>
            <xsl:apply-templates select="datafield[@tag='504']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='533']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='520']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='500']"/>
            <xsl:apply-templates select="datafield[@tag='600']"/>
            <xsl:apply-templates select="datafield[@tag='650']"/>
            <xsl:apply-templates select="datafield[@tag='651']"/>
            <xsl:apply-templates select="datafield[@tag='653']"/>
            
            
          
          <!-- not used-->
           
            <xsl:apply-templates select="datafield[@tag='773']"/>
            <xsl:apply-templates select="datafield[@tag='787']"/>
            <xsl:apply-templates select="datafield[@tag='591']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='592']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='711']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='013']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='502']/subfield[@code='a']"/>
            <!--/not used-->
            <!--<xsl:apply-templates select="datafield[@tag='043']/subfield[@code='a']"/>-->
            
            <!-- not used-->
            <xsl:apply-templates select="datafield[@tag='505']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='530']/subfield[@code='a']"/>
            <!-- /not used-->
             
             <!-- not used-->
            <xsl:apply-templates select="datafield[@tag='534']/subfield[@code='a']"/>
            <xsl:apply-templates select="datafield[@tag='250']"/>
            <!-- /not used-->
           </oai_dc:dc>
    </xsl:template>
    
    
    <xsl:template match="datafield[@tag='245']/subfield[@code='h']">
    <xsl:variable name="string">
        <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:variable name="start">
        <xsl:value-of select="substring-after($string,'[')"/>
    </xsl:variable>
    <dc:format>
        <xsl:value-of select="substring-before($start,']')"/>
    </dc:format>
    </xsl:template>
    
<!-- Language -->
    <xsl:template match="controlfield[@tag='008']">
        
       <xsl:variable name="controlField008">
           <xsl:value-of select="."/>
       </xsl:variable>
        
        <xsl:variable name="languageDescription">
            <xsl:if test="//datafield[@tag='546' != '']">
                <xsl:value-of select="//datafield[@tag='546']"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$languageDescription !=''">
        <dc:language>
            <xsl:value-of select="substring($controlField008, 36, 3 )"/><xsl:text> (</xsl:text>
            <xsl:value-of select="$languageDescription"/><xsl:text>)</xsl:text>
        </dc:language>
              </xsl:when>
      <xsl:otherwise>
          <dc:language>
              <xsl:value-of select="substring($controlField008, 36, 3 )"/>
          </dc:language>
    </xsl:otherwise>
           </xsl:choose>
          </xsl:template>


    <!-- type -->
    <xsl:template match="leader">
        <xsl:variable name="leadertag" select="."/>
        <xsl:variable name="leader6" select="substring($leadertag, 7, 1)"/>
        <xsl:variable name="leader7" select="substring($leadertag, 8, 1)"/>
        <dc:type>
        <xsl:if test="$leader7='c'">
            <xsl:text>collection </xsl:text>
        </xsl:if>
          <xsl:if test="$leader6 = 'a' or $leader6 = 't'">text </xsl:if>
            </dc:type>
      
    </xsl:template>
    <!--Title Node -->
    <xsl:template match="datafield[@tag='245']">
        <xsl:if test="child::subfield[@code='a']!=''">
        <xsl:choose>
            <xsl:when test="child::subfield[@code='a'] !='' and child::subfield[@code='b'] !=''">
        <dc:title>
            <xsl:call-template name="removeChar">
                <xsl:with-param name="parentString">
                    <xsl:value-of select="child::subfield[@code='a']"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="removeChar">
                <xsl:with-param name="parentString">
                    <xsl:value-of select="child::subfield[@code='b']"/>
                </xsl:with-param>
            </xsl:call-template>
        </dc:title>
        </xsl:when>
      <xsl:otherwise>
          <dc:title>
              <xsl:call-template name="removeChar">
                  <xsl:with-param name="parentString">
                      <xsl:value-of select="child::subfield[@code='a']"/>
                  </xsl:with-param>
              </xsl:call-template>
          </dc:title>
      </xsl:otherwise>
        </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- Creators [1] -->
    <xsl:template match="datafield[@tag='100']">
        <xsl:choose>
            <xsl:when test="child::subfield[@code='u'] != ''">
                <xsl:choose>
                    <xsl:when test="child::subfield[@code='d'] != ''">
                        <dc:creator>
                            <xsl:value-of select="child::subfield[@code='a']"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="child::subfield[@code='d']"/>
                        </dc:creator>
                        <dc:relation>
                            <xsl:value-of select="child::subfield[@code='u']"/>
                        </dc:relation>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:creator>
                            <xsl:value-of select="child::subfield[@code='a']"/>
                        </dc:creator>
                        <dc:relation>
                            <xsl:value-of select="child::subfield[@code='u']"/>
                        </dc:relation>

                    </xsl:otherwise>
                </xsl:choose>

            </xsl:when>

            <xsl:when test="child::subfield[@code='d'] != ''">
                <dc:creator>
                    <xsl:value-of select="child::subfield[@code='a']"/>
                    <xsl:value-of select="child::subfield[@code='d']"/>
                </dc:creator>
            </xsl:when>
            <xsl:otherwise>
                <dc:creator>
                    <xsl:value-of select="child::subfield[@code='a']"/>
                </dc:creator>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Creators [2] -->

    <xsl:template match="datafield[@tag='700']">
        <xsl:choose>
            <xsl:when test="child::subfield[@code='u'] != ''">
                <xsl:choose>
                    <xsl:when test="child::subfield[@code='d'] != ''">
                        <dc:creator>
                            <xsl:value-of select="child::subfield[@code='a']"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="child::subfield[@code='d']"/>
                        </dc:creator>
                        <dc:relation>
                            <xsl:value-of select="child::subfield[@code='u']"/>
                        </dc:relation>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:creator>
                            <xsl:value-of select="child::subfield[@code='a']"/>
                        </dc:creator>
                        <dc:relation>
                            <xsl:value-of select="child::subfield[@code='u']"/>
                        </dc:relation>

                    </xsl:otherwise>
                </xsl:choose>

            </xsl:when>

            <xsl:when test="child::subfield[@code='d'] != ''">
                <dc:creator>
                    <xsl:value-of select="child::subfield[@code='a']"/>
                    <xsl:value-of select="child::subfield[@code='d']"/>
                </dc:creator>
            </xsl:when>
            <xsl:otherwise>
                <dc:creator>
                    <xsl:value-of select="child::subfield[@code='a']"/>
                </dc:creator>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Creators [3] -->
    
    <xsl:template match="datafield[@tag='710']">
        <xsl:if test="subfield[@code != '']">
            <dc:relation>
   <xsl:for-each select="subfield[@code]">
   <xsl:value-of select="."/> 
       <xsl:text> </xsl:text>
   </xsl:for-each>
            </dc:relation>
        </xsl:if>
    </xsl:template>
    <!-- Description -->
    <xsl:template match="datafield[@tag='520']/subfield[@code='a']">
        <dc:description>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>

    <!-- Publisher Information & publication date -->
    <xsl:template match="datafield[@tag='260']">
        
        <xsl:choose>
            <xsl:when test="child::subfield[@code='a'] != ''">
                <xsl:choose>
                    <xsl:when test="child::subfield[@code='b'] != ''">
                        <dc:publisher>
                            <xsl:call-template name="removeChar">
                                <xsl:with-param name="parentString">
                                    <xsl:value-of select="child::subfield[@code='a']"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>. </xsl:text>
                            <xsl:call-template name="removeChar">
                                <xsl:with-param name="parentString">
                                    <xsl:value-of select="child::subfield[@code='b']"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </dc:publisher>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:publisher>
                            <xsl:value-of select="child::subfield[@code='a']"/>
                        </dc:publisher>
                        </xsl:otherwise>
                    </xsl:choose>    
                 </xsl:when>   
              <xsl:otherwise>
                  <xsl:choose>
                      
             <xsl:when test="child::subfield[@code='b'] != ''">
                <dc:publisher>
                <xsl:call-template name="removeChar">
                    <xsl:with-param name="parentString">
                        <xsl:value-of select="child::subfield[@code='b']"/>
                    </xsl:with-param>
                </xsl:call-template>
                </dc:publisher>
             </xsl:when>
                  </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
        
        
        <xsl:if test="child::subfield[@code='c'] != ''">
      
        <dc:date>
            <xsl:call-template name="removeChar">
                <xsl:with-param name="parentString">
                    <xsl:value-of select="child::subfield[@code='c']"/>
                </xsl:with-param>
            </xsl:call-template>
        </dc:date>
            </xsl:if>
    </xsl:template>

    <xsl:template name="removeChar">
        <xsl:param name="parentString"/>
        <xsl:variable name="lengthParentString" select="string-length($parentString)"/>
        <xsl:variable name="lastChar" select="substring($parentString,$lengthParentString)"/>
        <xsl:choose>
            <xsl:when test="$lastChar= ',' or $lastChar= ':'  or $lastChar= '/' or $lastChar= '.' ">
                <xsl:variable name="modifiedString"
                    select="substring($parentString, 1, $lengthParentString - 1)"/>
                <xsl:value-of select="$modifiedString"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$parentString"/>
            </xsl:otherwise>
        </xsl:choose>



    </xsl:template>


    <!-- Relation -->
    <xsl:template match="datafield[@tag='787']">
        <xsl:if test="subfield[@code='t']!=''">
            <dc:relation><xsl:value-of select="subfield[@code='t']"/></dc:relation>
        </xsl:if>
        <xsl:if test="subfield[@code='g']!=''">
            <dc:relation><xsl:value-of select="subfield[@code='g']"/></dc:relation>
        </xsl:if>
        </xsl:template>
    <!-- Copyright statement -->
    <xsl:template match="datafield[@tag='540']/subfield[@code='a']">
        <dc:rights>
            <xsl:value-of select="."/>
        </dc:rights>
    </xsl:template>
    <!-- Publisher URL -->
    <xsl:template match="datafield[@tag='856']/subfield[@code='u']">
        <dc:identifier>
            <xsl:value-of select="."/>
        </dc:identifier>
    </xsl:template>
    
    <!-- Keywords -->
    <xsl:template match="datafield[@tag='600']">
        <xsl:if  test="child::subfield[@code != '']">
            <dc:subject>
                <xsl:for-each select="child::subfield[@code]">
                    <xsl:value-of select="."/><xsl:text> </xsl:text>
                 </xsl:for-each>
            </dc:subject>
        </xsl:if>
    </xsl:template>
    <!-- Subject 650-->
    <xsl:template match="datafield[@tag='650']">
        <xsl:if  test="child::subfield[@code != '']">
            <dc:subject>
            <xsl:for-each select="child::subfield[@code]">
                <xsl:value-of select="."/><xsl:text> </xsl:text>
            </xsl:for-each>
            </dc:subject>
        </xsl:if>
    </xsl:template>
    
    <!-- Subject -651-->
    <xsl:template match="datafield[@tag='651']">
        <xsl:if  test="child::subfield[@code != '']">
            <dc:subject>
                <xsl:for-each select="child::subfield[@code]">
                    <xsl:value-of select="."/><xsl:text> </xsl:text>
                </xsl:for-each>
            </dc:subject>
        </xsl:if>
    </xsl:template>
    <!-- Subject -653-->
    <xsl:template match="datafield[@tag='653']">
        <xsl:if test="child::subfield[@code != '']">
            <xsl:for-each select="child::subfield[@code != '']">
                <dc:subject>
                    <xsl:value-of select="."/>
                </dc:subject>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- Item Type -->
    <xsl:template match="datafield[@tag='655']/subfield[@code='a']">
        <dc:type>
            <xsl:value-of select="."/>
        </dc:type>
    </xsl:template>
    <!-- Repository title -->
    <xsl:template match="datafield[@tag='773']">
        <xsl:if test="subfield[@code='t']!=''">
            <dc:relation><xsl:value-of select="subfield[@code='t']"/></dc:relation>
        </xsl:if>
        <xsl:if test="subfield[@code='g']!=''">
            <dc:relation><xsl:value-of select="subfield[@code='g']"/></dc:relation>
        </xsl:if>
    </xsl:template>
    <!-- DEST Collection Year -->
    <xsl:template match="datafield[@tag='591']/subfield[@code='a']">
        <dc:description>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>
    <!-- DEST Category -->
    <xsl:template match="datafield[@tag='592']/subfield[@code='a']">
        <dc:description>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>
    <!-- Conference Title -->
    <xsl:template match="datafield[@tag='711']/subfield[@code='a']">
        <dc:relation>
            <xsl:value-of select="."/>
        </dc:relation>
    </xsl:template>
    <!-- Patent Number -->
    <xsl:template match="datafield[@tag='013']/subfield[@code='a']">
        <dc:subject>
            <xsl:value-of select="."/>
        </dc:subject>
    </xsl:template>
    <!-- Coverage -->
    <xsl:template match="datafield[@tag='043']/subfield[@code='a']">
        <dc:coverage>
            <xsl:value-of select="."/>
        </dc:coverage>
    </xsl:template>
    <!-- note -->
    <xsl:template match="datafield[@tag='500']">
        <xsl:if test="child::subfield[@code != '']">
        <dc:description>
            <xsl:value-of select="."/>
        </dc:description>
        </xsl:if>
    </xsl:template>
    <!-- Coverage -->
    <xsl:template match="datafield[@tag='502']/subfield[@code='a']">
        <dc:description>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>
    <xsl:template match="datafield[@tag='504']/subfield[@code='a']">
        <dc:description>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>
    <xsl:template match="datafield[@tag='505']/subfield[@code='a']">
        <dc:description>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>
    <xsl:template match="datafield[@tag='530']/subfield[@code='a']">
        <dc:relation>
            <xsl:value-of select="."/>
        </dc:relation>
    </xsl:template>
    <xsl:template match="datafield[@tag='533']/subfield[@code='a']">
       <dc:description>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>
   

    <!-- relation1 -->
    <xsl:template match="datafield[@tag='534']/subfield[@code='a']">
        <dc:description>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>
   
    
    <!--Book Edition-->
    <xsl:template match="datafield[@tag='250']">
        <dc:description>
            <xsl:value-of select="."/>
     </dc:description>
    </xsl:template>
    
    

    











    <!-- do not ouptut nodes we don't match -->
    <xsl:template match="*"/>
    <!-- match against the utf-x-wrapper class for testing purposes-->
    <xsl:template match="utfx-wrapper">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
