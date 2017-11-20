<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output encoding="utf-8" method="xml"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <marc:collection xmlns:marc="http://www.loc.gov/MARC21/slim" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
     <marc:record>
      <marc:leader>00000nam a22000002a 4500</marc:leader>
       <xsl:variable name="dateTime">
         <xsl:value-of select="Session/Formdata/SubmissionDate"/>
       </xsl:variable>
       <xsl:variable name="date">
         <xsl:value-of select="substring-before($dateTime,' ')"/>
       </xsl:variable>
       <xsl:variable name="longyear">
         <xsl:value-of select="substring-before($date,'-')"/>
       </xsl:variable>
       <xsl:variable name="year">
         <xsl:value-of select="substring($longyear,3)"/>
         </xsl:variable>
       <xsl:variable name="monthDay">
         <xsl:value-of select="substring-after($date,'-')"/>
       </xsl:variable>
       <xsl:variable name="month">
         <xsl:value-of select="substring-before($monthDay,'-')"/>
       </xsl:variable>
       <xsl:variable name="day">
         <xsl:value-of select="substring-after($monthDay,'-')"/>
       </xsl:variable> 
       <marc:controlfield tag="008"><xsl:value-of select="$day"/><xsl:value-of select="$month"/><xsl:value-of select="$year"/>s20uu9999   |||||s|||||00| 0|eng d </marc:controlfield>
       
       <xsl:apply-templates select="Session/Formdata"/>
     </marc:record>
    </marc:collection>
  </xsl:template>
  
  <!--marc 008 >DDMMYYs20uu999-->
  
  <xsl:template match="Session/Formdata">
    <xsl:choose>
      <xsl:when test="session">
        <marc:datafield tag="035" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="session"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <!--DEST Category-->
    <xsl:choose>
      <xsl:when test="dest_category">
        <marc:datafield tag="592" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="dest_category"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <!--DEST Publication Year-->
    <xsl:choose>
      <xsl:when test="dest_publication_year">
        <marc:datafield tag="592" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="dest_publication_year"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <!-- Geographic Area-->
    <marc:datafield tag="043" ind1=" " ind2=" ">
      <marc:subfield code="a">
        <xsl:text>u-at</xsl:text>
      </marc:subfield>
    </marc:datafield>
    <!--Additional Copyright-->
    <xsl:choose>
      <xsl:when test="help_details">
        <marc:datafield tag="599" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="help_details"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>

    <!-- Resource Type -->
    <xsl:choose>
      <xsl:when test="resource_type">
            <marc:datafield tag="655" ind1=" " ind2="7">
		<marc:subfield code="a">
            	 <xsl:apply-templates select="resource_type"/>
		</marc:subfield>
		<marc:subfield code="2">local</marc:subfield>
            </marc:datafield>
	    <xsl:variable name="rtype" select="resource_type"/>
	    <!-- NEED TO ADD CALL TO RESOURCE SPECIFIC TEMPLATES -->
	    <xsl:if test="$rtype = 'working paper'">
  	    	<xsl:call-template name="working_paper"/>
	    </xsl:if>
	    <xsl:if test="$rtype = 'journal article'">
  	    	<xsl:call-template name="journal_article"/>
	    </xsl:if>
	    <xsl:if test="$rtype = 'thesis'">
  	    	<xsl:call-template name="thesis"/>
	    </xsl:if>
	    <xsl:if test="$rtype = 'conference paper'">
  	    	<xsl:call-template name="conference_paper"/>
	    </xsl:if>
	    <xsl:if test="$rtype = 'book chapter'">
  	    	<xsl:call-template name="book_chapter"/>
	    </xsl:if>
	    <xsl:if test="$rtype = 'book'">
  	    	<xsl:call-template name="book"/>
	    </xsl:if>
        <xsl:if test="$rtype = 'review'">
          <xsl:call-template name="review"/>
        </xsl:if>
        <xsl:if test="$rtype = 'report'">
          <xsl:call-template name="report"/>
        </xsl:if>
        <xsl:if test="$rtype = 'patent'">
          <xsl:call-template name="patent"/>
        </xsl:if>
        <xsl:if test="$rtype = 'computer software'">
          <xsl:call-template name="software"/>
        </xsl:if>
        <xsl:if test="$rtype = 'major project'">
          <xsl:call-template name="majorproject"/>
        </xsl:if>
      </xsl:when>
    </xsl:choose>

    <!-- Language -->
    <xsl:choose>
      <xsl:when test="language">
            <marc:datafield tag="041" ind1="0" ind2=" ">
	     <marc:subfield code="a">
           	<xsl:apply-templates select="language"/>
	     </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Date -->
    <xsl:choose>
      <xsl:when test="year">
        <marc:datafield tag="260" ind1=" " ind2=" ">
          <marc:subfield code="c">
            <xsl:apply-templates select="year"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>

    <!-- Generic Title -->
    <xsl:choose>
      <xsl:when test="title">
        <xsl:variable name="titleString" select="title"/>
      
    
    <xsl:variable name="firstCharactersA" select="substring ($titleString, 1, 2)"/>
    <xsl:variable name="firstCharactersThe" select="substring($titleString, 1, 4)"/>
    <xsl:choose>
      <xsl:when test="$firstCharactersA='A ' ">
        <marc:datafield tag="245" ind1="1" ind2="2">
          <marc:subfield code="a">
            <xsl:value-of select="$titleString"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
      <xsl:when test="$firstCharactersThe='The ' ">
        <marc:datafield tag="245" ind1="1" ind2="4">
          <marc:subfield code="a">
            <xsl:value-of select="$titleString"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
      <xsl:otherwise>
        <marc:datafield tag="245" ind1="1" ind2="0">
          <marc:subfield code="a">
            <xsl:value-of select="$titleString"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:otherwise>
    </xsl:choose>
      </xsl:when>
    </xsl:choose>
    

    <!-- Abstract -->
    <xsl:choose>
      <xsl:when test="description_abstract">
            <marc:datafield tag="520" ind1="3" ind2=" ">
	     <marc:subfield code="a">
	        <xsl:apply-templates select="description_abstract"/>
	     </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Subjects -->
    <!-- NEED TO SPLIT 'subject' by \r -->
    <xsl:choose>
      <xsl:when test="subject">
        <xsl:call-template name="splitString">
           <xsl:with-param name="string1" select="subject"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <!-- Keywords -->
    <xsl:apply-templates select="*[starts-with(local-name(),'keyword')]"/>
    <!-- Additional Info -->
    <xsl:choose>
      <xsl:when test="additional_info">
        <marc:datafield tag="500" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="additional_info"/>
          </marc:subfield>
         
        </marc:datafield>
      </xsl:when>
    </xsl:choose>

    <!-- Creators -->
    <xsl:choose>
      <xsl:when test="creator_last_name">
            <marc:datafield tag="100" ind1=" " ind2=" ">
	     <marc:subfield code="a">
	        <xsl:apply-templates select="creator_last_name"/>, <xsl:apply-templates select="creator_first_name"/>
	     </marc:subfield>
              <xsl:if test="creator_affiliation !=''">
	     <marc:subfield code="u">
	        <xsl:apply-templates select="creator_affiliation"/>
	     </marc:subfield>
              </xsl:if>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Other Creators -->
    <xsl:apply-templates select="*[starts-with(local-name(),'creator_last_name_')]"/>

    <!-- Faculty/School (or research_unit) -->
    <xsl:choose>
      <xsl:when test="university_name !=''">
            <marc:datafield tag="710" ind1=" " ind2=" ">
	     <marc:subfield code="a">
	        <xsl:apply-templates select="university_name" />
	     </marc:subfield>
              <xsl:if test="faculty !=''">
	     <marc:subfield code="b">
	        <xsl:apply-templates select="faculty"/>
	     </marc:subfield>
              </xsl:if>
              <xsl:if test="research_unit !=''">
	     <marc:subfield code="c">
	        <xsl:apply-templates select="research_unit"/>
	     </marc:subfield>
              </xsl:if>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Other Faculty/School(s) -->
    <xsl:apply-templates select="*[starts-with(local-name(),'faculty_')]"/>

    <!-- Rights -->
    <xsl:choose>
      <xsl:when test="rights !=''">
            <marc:datafield tag="540" ind1=" " ind2=" ">
	     <marc:subfield code="a">
	       <xsl:text>Copyright </xsl:text> <xsl:apply-templates select="year"/><xsl:text> </xsl:text><xsl:apply-templates select="creator_first_name"/><xsl:text> </xsl:text><xsl:apply-templates select="creator_last_name"/>
	       </marc:subfield>
            </marc:datafield>
        <marc:datafield tag="590" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="rights"/>
          </marc:subfield>
        </marc:datafield>
        
        
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>

  <!-- Working Paper Template -->
  <xsl:template name="working_paper">
    <!-- ISBN -->
    <xsl:choose>
      <xsl:when test="working_paper_isbn">
            <marc:datafield tag="020" ind1=" " ind2=" ">
	      <marc:subfield code="a">
	        <xsl:apply-templates select="working_paper_isbn"/>
	      </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>

    <!-- ISSN -->
    <xsl:choose>
      <xsl:when test="working_paper_issn">
            <marc:datafield tag="022" ind1=" " ind2=" ">
	      <marc:subfield code="a">
	        <xsl:apply-templates select="working_paper_issn"/>
	      </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>

    <!-- Working Paper  -->
    <xsl:choose>
      <xsl:when test="working_paper_title">
            <marc:datafield tag="440" ind1=" " ind2="0">
	      <marc:subfield code="a">
	        <xsl:apply-templates select="working_paper_title"/>
	      </marc:subfield>
	      <marc:subfield code="v">
	        <xsl:apply-templates select="working_paper_number"/>
	      </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Working Paper URL -->
    <xsl:choose>
      <xsl:when test="working_paper_url">
        <marc:datafield tag="856" ind1="4" ind2="0">
          <marc:subfield code="u">
            <xsl:value-of select="working_paper_url"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    

   

  </xsl:template>
  
  <!-- Review Template -->
  <xsl:template name="review">
    <xsl:choose>
      <xsl:when test="review_title">
        <marc:datafield tag="773" ind1="0" ind2=" ">
          <marc:subfield code="t">
            <xsl:apply-templates select="review_title"/>
          </marc:subfield>
          
          <marc:subfield code="n">
            <xsl:choose>
              <xsl:when test="review_peer_reviewed != 'Yes'">
                <xsl:value-of select="0"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="1"/>
              </xsl:otherwise>
            </xsl:choose>
          </marc:subfield>
          <marc:subfield code="g"><xsl:if test="review_volume !=''">Vol. <xsl:value-of select="review_volume"/></xsl:if><xsl:if test="review_issue!=''">, Issue <xsl:value-of select="review_issue"/></xsl:if><xsl:if test="review_number!=''">, no. <xsl:value-of select="review_number"/></xsl:if><xsl:if test="review_page_from!='' and review_page_to!=''">, p. <xsl:value-of select="review_page_from"/>-<xsl:value-of select="review_page_to"/></xsl:if></marc:subfield>
          <xsl:if test="review_issn != ''">
          <marc:subfield code="x">
            <xsl:apply-templates select="review_issn"/>
          </marc:subfield>
          </xsl:if>            
          <marc:subfield code="d">
            <xsl:apply-templates select="review_publisher" /><xsl:text> : </xsl:text> <xsl:apply-templates select="review_place_publication"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Review  URL -->
    <xsl:choose>
      <xsl:when test="review_url">
        <marc:datafield tag="856" ind1="4" ind2="0">
          <marc:subfield code="u">
            <xsl:value-of select="review_url"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    
  </xsl:template>
  
  <!-- Report Template not completed -->
  <xsl:template name="report">
    <xsl:choose>
      <xsl:when test="report_commissioner">
        <marc:datafield tag="720" ind1="1" ind2="2">
          <marc:subfield code="a">
            <xsl:apply-templates select="report_commissioner"/>
          </marc:subfield>
          <marc:subfield code="e">
            <xsl:text>patron</xsl:text>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!--report_series-->    
    <xsl:choose>
      <xsl:when test="report_series">
        <marc:datafield tag="440" ind1=" " ind2="0">
          <marc:subfield code="a">
            <xsl:apply-templates select="report_series"/>
          </marc:subfield>
          <marc:subfield code="v">
            <xsl:apply-templates select="report_series_number"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Report Publisher -->
    <xsl:choose>
      <xsl:when test="report_publisher">
        <marc:datafield tag="260" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="report_place_publication"/>
          </marc:subfield>
          <marc:subfield code="b">
            <xsl:apply-templates select="report_publisher"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <!-- ISBN -->
    <xsl:choose>
      <xsl:when test="report_isbn">
        <marc:datafield tag="020" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="report_isbn"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    
  </xsl:template>
  
  <!--Computer Software Template -->
  <xsl:template name="software">
    <xsl:choose>
      <xsl:when test="software_technical_details">
        <marc:datafield tag="300" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="software_technical_details"/>
          </marc:subfield>
          </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <xsl:choose>
      <xsl:when test="software_edition">
        <marc:datafield tag="250" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="software_edition"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Software Publisher -->
    <xsl:choose>
      <xsl:when test="software_publisher">
        <marc:datafield tag="260" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="software_place_publication"/>
          </marc:subfield>
          <marc:subfield code="b">
            <xsl:apply-templates select="software_publisher"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    
  </xsl:template>

  <!-- Journal Article Template -->
  <xsl:template name="journal_article">
    
    <!-- Journal Title / Refereed / Volume / Issue / Pages / Place of Publication and Publisher -->
    <xsl:choose>
      <xsl:when test="journal_title">
            <marc:datafield tag="773" ind1="0" ind2=" ">
	     <marc:subfield code="t">
	        <xsl:apply-templates select="journal_title"/>
	     </marc:subfield>
              <marc:subfield code="n">
                <xsl:choose>
                  <xsl:when test="journal_peer_reviewed != 'Yes'">
                    <xsl:value-of select="0"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="1"/>
                  </xsl:otherwise>
                </xsl:choose>
              </marc:subfield>
              <marc:subfield code="g"><xsl:if test="journal_volume !=''">Vol. <xsl:value-of select="journal_volume"/></xsl:if><xsl:if test="journal_issue!=''">, Issue <xsl:value-of select="journal_issue"/></xsl:if><xsl:if test="journal_number!=''">, no. <xsl:value-of select="journal_number"/></xsl:if><xsl:if test="journal_page_from!='' and journal_page_to!=''">, p. <xsl:value-of select="journal_page_from"/>-<xsl:value-of select="journal_page_to"/></xsl:if></marc:subfield>
              <xsl:if test="journal_issn !=''">
	    <marc:subfield code="x">
                <xsl:apply-templates select="journal_issn"/>
	    </marc:subfield>
              </xsl:if>
	     <marc:subfield code="d">
	       <xsl:apply-templates select="journal_publisher" /><xsl:if test="journal_place_publication !=''"><xsl:text> : </xsl:text> <xsl:apply-templates select="journal_place_publication"/></xsl:if>
             </marc:subfield>
              </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="journal_page_from!='' and journal_page_to!=''">
        <xsl:variable name="startpage" select="journal_page_from"/>
        <xsl:variable name="endpage" select="journal_page_to"/>
        <marc:datafield tag="300" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:value-of select="$endpage - $startpage + 1"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>

     <!-- Journal URL -->
    <xsl:choose>
      <xsl:when test="journal_url">
            <marc:datafield tag="856" ind1="4" ind2="0">
	     <marc:subfield code="u">
	       <xsl:value-of select="journal_url"/>
	     </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>

  </xsl:template>
  

  <!-- Patent Template -->
  <xsl:template name="patent">
    <!-- Owner -->
    <xsl:choose>
      <xsl:when test="patent_owner">
            <marc:datafield tag="720" ind1="1" ind2="2">
	     <marc:subfield code="a">
	        <xsl:apply-templates select="patent_owner"/>
	     </marc:subfield>
              <marc:subfield code="e">
                <xsl:text>(Owner)</xsl:text>
             </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <!-- Patent Number - place of publication (subfield b) is defaulted to code = at that stands for Australia -->
    <xsl:choose>
      <xsl:when test="patent_number">
        <marc:datafield tag="013" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="patent_number"/>
          </marc:subfield>
          <marc:subfield code="b">
            <xsl:text>at</xsl:text>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <!-- Provisional Number -->
    <xsl:choose>
      <xsl:when test="patent_provisional_number">
        <marc:datafield tag="013" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="patent_provisional_number"/>
          </marc:subfield>
          <marc:subfield code="e">
            <xsl:text>provisional</xsl:text>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- PCT Number -->
    <xsl:choose>
      <xsl:when test="patent_pct_number">
        <marc:datafield tag="653" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:text>PCT/</xsl:text>
            <xsl:apply-templates select="patent_pct_number"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <!-- WIPO Number -->
    <xsl:choose>
      <xsl:when test="patent_wipo_number">
        <marc:datafield tag="653" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:text>WIPO/</xsl:text>
            <xsl:apply-templates select="patent_wipo_number"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>  
  </xsl:template>
  
  <!-- Thesis Template -->
  <xsl:template name="thesis">
    <!-- Supervisors -->
    <xsl:choose>
      <xsl:when test="thesis_supervisor_last_name">
        <marc:datafield tag="720" ind1="1" ind2="2">
          <marc:subfield code="a">
            <xsl:apply-templates select="thesis_supervisor_last_name"/>, <xsl:apply-templates select="thesis_supervisor_first_name"/>
          </marc:subfield>
          <marc:subfield code="e">
            <xsl:text>(Supervisor)</xsl:text>
          </marc:subfield>
          <marc:subfield code="u">
            <xsl:apply-templates select="thesis_supervisor_affiliation"/>
          </marc:subfield>
          
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Other Supervisors -->
    <xsl:apply-templates select="*[starts-with(local-name(),'thesis_supervisor_last_name_')]"/>
    
    
    <!-- Thesis Degree Program -->
    <xsl:choose>
      <xsl:when test="thesis_degree">
        <marc:datafield tag="502" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="thesis_degree"/> <xsl:text> - </xsl:text><xsl:apply-templates select="thesis_degree_program"/>
          </marc:subfield>
        </marc:datafield>
        <xsl:if test="contains(.,'Research Doctorate') or contains(.,'Masters Research') or contains(.,'Higher Doctorate')">
          <marc:datafield tag="830" ind1=" " ind2=" ">
            <marc:subfield code="a">
             <xsl:text>Australasian Digital Thesis</xsl:text>
            </marc:subfield>
          </marc:datafield>
          </xsl:if>
      </xsl:when>
    </xsl:choose>
    <!--Availability : Embargoes / restriction -->
    
    <xsl:choose>
      <xsl:when test="availability">
        <marc:datafield tag="506" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:choose>
              <xsl:when test="availability !='restricted'">
                <xsl:text>Unrestricted worldwide access</xsl:text>
              </xsl:when>
              <xsl:otherwise>     
                <xsl:text>Restricted access. Embargo for </xsl:text><xsl:apply-templates select="num_months"/><xsl:text> months</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!--Authenticity agreement -->
    
    <xsl:choose>
      <xsl:when test="authenticity_assent">
        <marc:datafield tag="591" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="authenticity_assent"/>
            
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- Major Project Template -->
  <xsl:template name="majorproject">
    <!-- Supervisors -->
    <xsl:choose>
      <xsl:when test="supervisor_last_name">
        <marc:datafield tag="720" ind1="1" ind2="2">
          <marc:subfield code="a">
            <xsl:apply-templates select="supervisor_last_name"/>, <xsl:apply-templates select="supervisor_first_name"/>
          </marc:subfield>
          <marc:subfield code="e">
            <xsl:text>(Supervisor)</xsl:text>
          </marc:subfield>
          <marc:subfield code="u">
            <xsl:apply-templates select="supervisor_affiliation"/>
          </marc:subfield>       
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Other Supervisors -->
    <xsl:apply-templates select="*[starts-with(local-name(),'supervisor_last_name_')]"/>
    
    
    <!-- Major Project Program -->
    <xsl:choose>
      <xsl:when test="mp_thesis_degree">
        <marc:datafield tag="502" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="mp_thesis_degree"/> <xsl:text> - </xsl:text><xsl:apply-templates select="mp_thesis_degree_program"/>
          </marc:subfield>
        </marc:datafield>
        <xsl:if test="contains(.,'Research Doctorate') or contains(.,'Masters Research') or contains(.,'Higher Doctorate')">
          <marc:datafield tag="830" ind1=" " ind2=" ">
            <marc:subfield code="a">
              <xsl:text>Australasian Digital Thesis</xsl:text>
            </marc:subfield>
          </marc:datafield>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    
    <!--Availability : Embargoes / restriction -->

   <xsl:choose>
    <xsl:when test="availability">
      <marc:datafield tag="506" ind1=" " ind2=" ">
        <marc:subfield code="a">
          <xsl:choose>
          <xsl:when test="availability !='restricted'">
            <xsl:text>Unrestricted worldwide access</xsl:text>
          </xsl:when>
            <xsl:otherwise>     
              <xsl:text>Restricted access. Embargo for </xsl:text><xsl:apply-templates select="num_months"/><xsl:text> months</xsl:text>
            </xsl:otherwise>
            </xsl:choose>
        </marc:subfield>
      </marc:datafield>
      </xsl:when>
   </xsl:choose>
    <!--Authenticity agreement -->
    
    <xsl:choose>
      <xsl:when test="authenticity_assent">
        <marc:datafield tag="591" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="authenticity_assent"/>
   
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>
  
  

  <!-- Conference Paper Template -->
  <xsl:template name="conference_paper">
    
    <!-- Conference Location / Dates / Proceedings Title / Name / Refereed -->
    <marc:datafield tag="711"  ind1="2" ind2=" ">
      <marc:subfield code="a">
        <xsl:apply-templates select="conference_name"/>
      </marc:subfield>
      <marc:subfield code="c">
        <xsl:apply-templates select="conference_location"/>
      </marc:subfield>
      <marc:subfield code="d">
        <xsl:apply-templates select="conference_date"/>
      </marc:subfield>
     </marc:datafield>
    

    <!-- Conference Location / Dates / Proceedings Title / Name / Refereed -->
    <marc:datafield tag="773"  ind1="0" ind2=" ">
	<marc:subfield code="t">
	        <xsl:apply-templates select="conference_title"/>
	</marc:subfield>
      <marc:subfield code="g">
        <xsl:if test="conference_page_from!='' and conference_page_to!=''"> p. <xsl:apply-templates select="conference_page_from"/>-<xsl:apply-templates select="conference_page_to"/></xsl:if>
      </marc:subfield>
	<marc:subfield code="d">
	  <xsl:apply-templates select="conference_publisher"/><xsl:text> : </xsl:text> <xsl:apply-templates select="conference_place_publication"/>
	</marc:subfield>
        <marc:subfield code="n">
             <xsl:choose>
               <xsl:when test="conference_peer_reviewed != 'Yes'">
                 <xsl:value-of select="0"/>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:value-of select="1"/>
               </xsl:otherwise>
             </xsl:choose>
        </marc:subfield>
      <xsl:if test="conference_issn !=''">
        <marc:subfield code="x">
	        <xsl:apply-templates select="conference_issn"/>
        </marc:subfield>
      </xsl:if>
      <xsl:if test="conference_isbn !=''">
      <marc:subfield code="z">
        <xsl:apply-templates select="conference_isbn"/>
      </marc:subfield>
      </xsl:if>
      
    </marc:datafield>
    <xsl:choose>
      <xsl:when test="conference_page_from!='' and conference_page_to!=''">
        <xsl:variable name="startpage" select="conference_page_from"/>
        <xsl:variable name="endpage" select="conference_page_to"/>
        <marc:datafield tag="300" ind1=" " ind2=" ">
          <marc:subfield code="a">
            <xsl:value-of select="$endpage - $startpage + 1"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <!-- Conference Editor-->
    <xsl:choose>
      <xsl:when test="conference_editor">
        <marc:datafield tag="720" ind1="1" ind2=" ">
          <marc:subfield code="a">
            <xsl:apply-templates select="conference_editor"/>
          </marc:subfield>
          <marc:subfield code="e">
            <xsl:text>(Editor)</xsl:text>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    <!--conferencer url -->
    <xsl:choose>
      <xsl:when test="conference_url">
        <marc:datafield tag="856" ind1="4" ind2="0">
          <marc:subfield code="u">
            <xsl:apply-templates select="conference_url"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    

    
  </xsl:template>

  <!-- Book Chapter Template -->
  <xsl:template name="book_chapter">

    <!-- Book Chapter Publisher, Place of Publication, Date -->
    <xsl:choose>
      <xsl:when test="chapter_place_publication">
            <marc:datafield tag="773" ind1="0" ind2=" ">
	        <marc:subfield code="t">
			<xsl:apply-templates select="chapter_book_title"/>
		</marc:subfield>
		<marc:subfield code="b">
			<xsl:apply-templates select="chapter_edition"/>
		 </marc:subfield>
		<marc:subfield code="g">
		  <xsl:if test="chapter_number!=''">Chapter <xsl:apply-templates select="chapter_number"/></xsl:if><xsl:if test="chapter_page_from!='' and chapter_page_to!=''"> p. <xsl:apply-templates select="chapter_page_from"/>-<xsl:apply-templates select="chapter_page_to"/></xsl:if>
		</marc:subfield>
	       <marc:subfield code="d">
	         <xsl:apply-templates select="chapter_publisher"/><xsl:text> : </xsl:text><xsl:apply-templates select="chapter_place_publication"/>
	        </marc:subfield>
		<marc:subfield code="z">
			<xsl:apply-templates select="chapter_isbn"/>
		</marc:subfield>
           </marc:datafield>
      </xsl:when>
    </xsl:choose>
    
    <!--chapter url -->
    <xsl:choose>
    <xsl:when test="chapter_url">
      <marc:datafield tag="856" ind1="4" ind2="0">
        <marc:subfield code="u">
          <xsl:apply-templates select="chapter_url"/>
        </marc:subfield>
      </marc:datafield>
    </xsl:when>
    </xsl:choose>
    <!--chapter_series-->    
    <xsl:choose>
      <xsl:when test="chapter_series">
        <marc:datafield tag="440" ind1=" " ind2="0">
          <marc:subfield code="a">
            <xsl:apply-templates select="chapter_series"/>
          </marc:subfield>
          <marc:subfield code="v">
            <xsl:apply-templates select="chapter_series_number"/>
          </marc:subfield>
        </marc:datafield>
      </xsl:when>
    </xsl:choose>

     <!-- Chapter Editor -->
    <xsl:choose>
      <xsl:when test="chapter_editor">
     <marc:datafield tag="700" ind1="1" ind2=" ">
	<marc:subfield code="a">
	  <xsl:apply-templates select="chapter_editor"/>
	</marc:subfield>
	<marc:subfield code="e">
	  <xsl:text> (Editor)</xsl:text>
	</marc:subfield>
     </marc:datafield>
     </xsl:when>
     </xsl:choose>

    


    <!-- Chapter Total Pages -->
    <xsl:variable name="first" select="chapter_page_to"/> 
    <xsl:variable name="second" select="chapter_page_from"/> 
     <marc:datafield tag="300" ind1=" " ind2=" ">
	<marc:subfield code="a">
	  <xsl:value-of select="number($first) - number($second)" />
	</marc:subfield>
     </marc:datafield>
  </xsl:template>

  <!-- Book Template -->
  <xsl:template name="book">

    <!-- Book  Publisher, Place of Publication, Date -->
    <xsl:choose>
      <xsl:when test="year">
            <marc:datafield tag="260" ind1=" " ind2=" ">
	     <marc:subfield code="a">
	        <xsl:apply-templates select="book_place_publication"/>
	     </marc:subfield>
	     <marc:subfield code="b">
	        <xsl:apply-templates select="book_publisher"/>
	     </marc:subfield>
	     <marc:subfield code="c">
	        <xsl:apply-templates select="year"/>
	     </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>

     <!-- Book Series -->
    <xsl:choose>
      <xsl:when test="book_series">
            <marc:datafield tag="440" ind1=" " ind2="0">
	     <marc:subfield code="a">
	        <xsl:value-of select="book_series"/>   
	     </marc:subfield>
              <xsl:if test="book_series_number!=''">
              <marc:subfield code="v">
                <xsl:value-of select="book_series_number"/>   
              </marc:subfield>
              </xsl:if>
            </marc:datafield>
      </xsl:when>
      
    </xsl:choose>
    
    <!-- Book ISBN -->
    <xsl:choose>
      <xsl:when test="book_isbn">
            <marc:datafield tag="020" ind1=" " ind2=" ">
	     <marc:subfield code="a">
	        <xsl:apply-templates select="book_isbn"/>
	     </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>

    <!-- Book Edition -->
    <xsl:choose>
      <xsl:when test="book_edition">
            <marc:datafield tag="250" ind1=" " ind2=" ">
	     <marc:subfield code="a">
	        <xsl:apply-templates select="book_edition"/>
	     </marc:subfield>
            </marc:datafield>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!-- Multiple Keywords -->
  <xsl:template match="*[starts-with(local-name(),'keyword')]">
	<marc:datafield tag="653" ind1=" " ind2=" ">
	 <marc:subfield code="a">
	        <xsl:value-of select="."/>
	 </marc:subfield> 
	</marc:datafield>
  </xsl:template>

  <!-- Multiple Creators -->
  <xsl:template match="*[starts-with(local-name(),'creator_last_name_')]">
	<xsl:variable name="num" select="substring-after(name(),'creator_last_name_')"/>
	<xsl:variable name="first_name" select="concat('creator_first_name_',$num)"/>
	<xsl:variable name="affiliation" select="concat('creator_affiliation_',$num)"/>
	<marc:datafield tag="700" ind1="1" ind2=" ">
	 <marc:subfield code="a">
	  <xsl:value-of select="."/>, <xsl:value-of select="//*[local-name()=$first_name]"/>
	 </marc:subfield>
	  <xsl:if test="//*[local-name()=$affiliation] !=''">
	 <marc:subfield code="u">
	  <xsl:value-of select="//*[local-name()=$affiliation]"/>
	 </marc:subfield>
	  </xsl:if>
	</marc:datafield>
	
  </xsl:template>

  <!-- Multiple Faculty/School(s) -->
  <xsl:template match="*[starts-with(local-name(),'faculty_')]">
	<xsl:variable name="num" select="substring-after(name(),'faculty_')"/>
	<xsl:variable name="school" select="concat('research_unit_',$num)"/>
	<marc:datafield tag="710" ind1="1" ind2=" ">
	 <marc:subfield code="a">University of Newcastle</marc:subfield>
	 <marc:subfield code="b">
	  <xsl:value-of select="."/>
	 </marc:subfield>
	 <marc:subfield code="b">
	  <xsl:value-of select="//*[local-name()=$school]"/>
	 </marc:subfield>
	</marc:datafield>
  </xsl:template>
  
  <!-- Multiple Supervisors -->
  <xsl:template match="*[starts-with(local-name(),'thesis_supervisor_last_name_')]">
	<xsl:variable name="num" select="substring-after(name(),'thesis_supervisor_last_name_')"/>
	<xsl:variable name="first_name" select="concat('thesis_supervisor_first_name_',$num)"/>
	<xsl:variable name="affiliation" select="concat('thesis_supervisor_affiliation_',$num)"/>
	<marc:datafield tag="720" ind1="1" ind2="2">
	 <marc:subfield code="a">
	  <xsl:value-of select="."/>, <xsl:value-of select="//*[local-name()=$first_name]"/>
	 </marc:subfield>
	  <marc:subfield code="e">
	    <xsl:text>(Supervisor)</xsl:text>
	  </marc:subfield>
	  <marc:subfield code="u">
	    <xsl:value-of select="//*[local-name()=$affiliation]"/>
	  </marc:subfield>
	</marc:datafield>
  </xsl:template>
  
  <xsl:template name="splitString">
    <xsl:param name="string1"/>
     <xsl:choose>
      <xsl:when test="contains($string1,'&#13;')">
       <xsl:variable name="beforeCR" select="substring-before($string1,'&#13;')"/>
	<marc:datafield tag="650" ind1=" " ind2="7">
	 <marc:subfield code="a"><xsl:value-of select="$beforeCR"/></marc:subfield>
	</marc:datafield>

	<xsl:variable name="afterCR" select="substring-after($string1,'&#13;')"/>
	<xsl:call-template name="splitString">
	   <xsl:with-param name="string1" select="$afterCR" />
	</xsl:call-template>
       </xsl:when>
       <xsl:otherwise>
         <xsl:if test="$string1 !=''">
	<marc:datafield tag="653" ind1=" " ind2=" ">
	 <marc:subfield code="a"><xsl:value-of select="$string1"/></marc:subfield>
	</marc:datafield>
           </xsl:if>
       </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

