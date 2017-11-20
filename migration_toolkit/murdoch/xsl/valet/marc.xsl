<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output encoding="utf-8" method="xml"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <collection xmlns="http://www.loc.gov/MARC21/slim" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
     <record>
      <leader>00000nam a22000002a 4500</leader>
       <controlfield tag="008">       20uu9999   |||||s|||||00| 0|eng d </controlfield>
       <xsl:apply-templates select="Session/Formdata"/>
     </record>
    </collection>
  </xsl:template>
  
  <xsl:template match="Session/Formdata">
    


    <!-- Resource Type -->
    <xsl:choose>
      <xsl:when test="resource_type">
            <datafield tag="655" ind1=" " ind2="7">
		<subfield code="a">
		      <xsl:choose>
		        <xsl:when test="contains(resource_type,'Conference Publication')">
		          <xsl:text>Conference Paper</xsl:text>
		        </xsl:when>
		        <xsl:otherwise>
		          <xsl:value-of select="resource_type"/>
		        </xsl:otherwise>
		      </xsl:choose>
            	
		</subfield>
		<subfield code="2">local</subfield>
            </datafield>
        <xsl:variable name="rtype" select="resource_type"/>
    
	    <!-- NEED TO ADD CALL TO RESOURCE SPECIFIC TEMPLATES -->
	    <xsl:if test="$rtype = 'Working Paper'">
  	    	<xsl:call-template name="working_paper"/>
	    </xsl:if>
	    <xsl:if test="$rtype = 'Journal Article'">
  	    	<xsl:call-template name="journal_article"/>
	    </xsl:if>
	    <xsl:if test="$rtype = 'Thesis'">
  	    	<xsl:call-template name="thesis"/>
	    </xsl:if>
	    <xsl:if test="$rtype = 'Conference Paper'">
  	    	<xsl:call-template name="conference_paper"/>
	    </xsl:if>
        <xsl:if test="$rtype = 'Conference Publication'">
          <xsl:call-template name="conference_paper"/>
        </xsl:if>
	    <xsl:if test="$rtype = 'Book Chapter'">
  	    	<xsl:call-template name="book_chapter"/>
	    </xsl:if>
	    <xsl:if test="$rtype = 'Book'">
  	    	<xsl:call-template name="book"/>
	    </xsl:if>
        <xsl:if test="$rtype = 'Review'">
          <xsl:call-template name="review"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Report'">
          <xsl:call-template name="report"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Patent'">
          <xsl:call-template name="patent"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Computer Software'">
          <xsl:call-template name="software"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Creative Work'">
          <xsl:call-template name="creative_work"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Reference Work'">
          <xsl:call-template name="reference_work"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Audio Visual'">
          <xsl:call-template name="audio_visual"/>
        </xsl:if>
      </xsl:when>
    </xsl:choose>

    <!-- Language -->
    <xsl:choose>
      <xsl:when test="language">
            <datafield tag="041" ind1="0" ind2=" ">
	     <subfield code="a">
           	<xsl:apply-templates select="language"/>
	     </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Date -->
    <xsl:choose>
      <xsl:when test="year">
        <datafield tag="260" ind1=" " ind2=" ">
          <subfield code="c">
            <xsl:apply-templates select="year"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>

    <!-- Generic Title -->
    <xsl:choose>
      <xsl:when test="title">
            <datafield tag="245" ind1="1" ind2="0">
	     <subfield code="a">
           	<xsl:apply-templates select="title"/>
	     </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>

    <!-- Abstract -->
    <xsl:choose>
      <xsl:when test="description_abstract">
            <datafield tag="520" ind1="3" ind2=" ">
	     <subfield code="a">
	        <xsl:apply-templates select="description_abstract"/>
	     </subfield>
            </datafield>
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

    <!-- Creators -->
    <xsl:choose>
      <xsl:when test="creator_last_name">
            <datafield tag="100" ind1=" " ind2=" ">
	     <subfield code="a">
	        <xsl:apply-templates select="creator_last_name"/>, <xsl:apply-templates select="creator_first_name"/>
	     </subfield>
              <xsl:if test="creator_affiliation !=''">
	         <subfield code="u">
	            <xsl:apply-templates select="creator_affiliation"/>
	         </subfield>
                </xsl:if>
            </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Other Creators -->
    <xsl:apply-templates select="*[starts-with(local-name(),'creator_last_name_')]"/>

    <!-- Faculty/School (or research_unit) -->
    <xsl:choose>
      <xsl:when test="faculty!=''">
            <datafield tag="710" ind1="2" ind2=" ">
	     <subfield code="a">
	        <xsl:apply-templates select="university_name" />
	     </subfield>
	     <subfield code="b">
	        <xsl:apply-templates select="faculty"/>
	     </subfield>
	     <subfield code="c">
	        <xsl:apply-templates select="research_unit"/>
	     </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Other Faculty/School(s) -->
    <xsl:apply-templates select="*[starts-with(local-name(),'faculty_')]"/>

    <!-- Rights -->
    <xsl:choose>
      <xsl:when test="rights !=''">
            <datafield tag="540" ind1=" " ind2="0">
	     <subfield code="a">
	        <xsl:apply-templates select="rights"/>
	     </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>
    
    <xsl:if test="additional_info !=''">
      <datafield tag="500" ind1=" " ind2=" ">
        <subfield code="u">
          <xsl:apply-templates select="additional_info"/>
        </subfield>
      </datafield>      
    </xsl:if>
    
  </xsl:template>

  <!-- Working Paper Template -->
  <xsl:template name="working_paper">
    <!-- ISBN -->
    <xsl:choose>
      <xsl:when test="working_paper_isbn">
            <datafield tag="020" ind1=" " ind2=" ">
	      <subfield code="a">
	        <xsl:apply-templates select="working_paper_isbn"/>
	      </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>

    <!-- ISSN -->
    <xsl:choose>
      <xsl:when test="working_paper_issn">
            <datafield tag="022" ind1=" " ind2=" ">
	      <subfield code="a">
	        <xsl:apply-templates select="working_paper_issn"/>
	      </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>

    <!-- Working Paper  -->
    <xsl:choose>
      <xsl:when test="working_paper_title">
            <datafield tag="440" ind1=" " ind2="0">
	      <subfield code="a">
	        <xsl:apply-templates select="working_paper_title"/>
	      </subfield>
	      <subfield code="v">
	        <xsl:apply-templates select="working_paper_number"/>
	      </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Working Paper URL -->
    <xsl:choose>
      <xsl:when test="working_paper_url">
        <datafield tag="852" ind1="4" ind2="0">
          <subfield code="u">
            <xsl:value-of select="working_paper_url"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    

   

  </xsl:template>
  
  <!-- Review Template -->
  <xsl:template name="review">
    <xsl:choose>
      <xsl:when test="review_title">
        <datafield tag="773" ind1="0" ind2=" ">
          <subfield code="t">
            <xsl:apply-templates select="review_title"/>
          </subfield>
          
          <subfield code="n">
            <xsl:choose>
              <xsl:when test="review_peer_reviewed != 'Yes'">
                <xsl:value-of select="0"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="1"/>
              </xsl:otherwise>
            </xsl:choose>
          </subfield>
          <subfield code="g"><xsl:if test="review_volume !=''">Vol. <xsl:value-of select="review_volume"/></xsl:if><xsl:if test="review_issue!=''">, Issue <xsl:value-of select="review_issue"/></xsl:if><xsl:if test="review_number!=''">, no. <xsl:value-of select="review_number"/></xsl:if><xsl:if test="review_page_from!='' and review_page_to!=''">, p. <xsl:value-of select="review_page_from"/>-<xsl:value-of select="review_page_to"/></xsl:if></subfield>
          <subfield code="x">
            <xsl:apply-templates select="review_issn"/>
          </subfield>
          <subfield code="d">
            <xsl:apply-templates select="review_publisher" /><xsl:text> : </xsl:text> <xsl:apply-templates select="review_place_publication"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Review  URL -->
    <xsl:choose>
      <xsl:when test="review_url">
        <datafield tag="852" ind1="4" ind2="0">
          <subfield code="u">
            <xsl:value-of select="review_url"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    
  </xsl:template>
  
  <!-- Report Template not completed -->
  <xsl:template name="report">
    <xsl:choose>
      <xsl:when test="report_commissioner">
        <datafield tag="720" ind1="1" ind2="2">
          <subfield code="a">
            <xsl:apply-templates select="report_commissioner"/>
          </subfield>
          <subfield code="e">
            <xsl:text>patron</xsl:text>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!--report_series-->    
    <xsl:choose>
      <xsl:when test="report_series">
        <datafield tag="440" ind1=" " ind2="0">
          <subfield code="a">
            <xsl:apply-templates select="report_series"/>
          </subfield>
          <subfield code="v">
            <xsl:apply-templates select="report_series_number"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Report Publisher -->
    <xsl:choose>
      <xsl:when test="report_publisher">
        <datafield tag="260" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:apply-templates select="report_place_publication"/>
          </subfield>
          <subfield code="b">
            <xsl:apply-templates select="report_publisher"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    <!-- ISBN -->
    <xsl:choose>
      <xsl:when test="report_isbn">
        <datafield tag="020" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:apply-templates select="report_isbn"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    
  </xsl:template>
  
  <!--Computer Software Template -->
  <xsl:template name="software">
    <xsl:choose>
      <xsl:when test="software_technical_details">
        <datafield tag="300" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:apply-templates select="software_technical_details"/>
          </subfield>
          </datafield>
      </xsl:when>
    </xsl:choose>
    
    <xsl:choose>
      <xsl:when test="software_edition">
        <datafield tag="250" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:apply-templates select="software_edition"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Software Publisher -->
    <xsl:choose>
      <xsl:when test="software_publisher">
        <datafield tag="260" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:apply-templates select="software_place_publication"/>
          </subfield>
          <subfield code="b">
            <xsl:apply-templates select="software_publisher"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    
  </xsl:template>

  <!-- Journal Article Template -->
  <xsl:template name="journal_article">
    
    <!-- Journal Title / Refereed / Volume / Issue / Pages / Place of Publication and Publisher -->
    <xsl:choose>
      <xsl:when test="journal_title">
            <datafield tag="773" ind1="0" ind2=" ">
	     <subfield code="t">
	        <xsl:apply-templates select="journal_title"/>
	     </subfield>
              <subfield code="n">
                <xsl:choose>
                  <xsl:when test="journal_peer_reviewed != 'Yes'">
                    <xsl:value-of select="0"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="1"/>
                  </xsl:otherwise>
                </xsl:choose>
              </subfield>
              <subfield code="g"><xsl:if test="journal_volume !=''">Vol. <xsl:value-of select="journal_volume"/></xsl:if><xsl:if test="journal_issue!=''">, Issue <xsl:value-of select="journal_issue"/></xsl:if><xsl:if test="journal_number!=''">, no. <xsl:value-of select="journal_number"/></xsl:if><xsl:if test="journal_page_from!='' and journal_page_to!=''">, p. <xsl:value-of select="journal_page_from"/>-<xsl:value-of select="journal_page_to"/></xsl:if></subfield>
	    <subfield code="x">
                <xsl:apply-templates select="journal_issn"/>
             </subfield>
	     <subfield code="d">
	       <xsl:apply-templates select="journal_publisher" /><xsl:text> : </xsl:text> <xsl:apply-templates select="journal_place_publication"/>
             </subfield>
              </datafield>
      </xsl:when>
    </xsl:choose>

     <!-- Journal URL -->
    <xsl:choose>
      <xsl:when test="journal_url">
            <datafield tag="852" ind1="4" ind2="0">
	     <subfield code="u">
	       <xsl:value-of select="journal_url"/>
	     </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>

       
    <!-- Total Pages -->
    <xsl:variable name="first" select="journal_page_to"/> 
    <xsl:variable name="second" select="journal_page_from"/> 
     <datafield tag="300" ind1=" " ind2=" ">
	<subfield code="a">
	  <xsl:value-of select="number($first) - number($second)" />
	</subfield>
     </datafield>
  </xsl:template>

  <!-- Patent Template -->
  <xsl:template name="patent">
    <!-- Owner -->
    <xsl:choose>
      <xsl:when test="patent_owner">
            <datafield tag="720" ind1="1" ind2="2">
	     <subfield code="a">
	        <xsl:apply-templates select="patent_owner"/>
	     </subfield>
              <subfield code="e">
                <xsl:text>(Owner)</xsl:text>
             </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>
    <!-- Patent Number - place of publication (subfield b) is defaulted to code = at that stands for Australia -->
    <xsl:choose>
      <xsl:when test="patent_number">
        <datafield tag="013" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:apply-templates select="patent_number"/>
          </subfield>
          <subfield code="b">
            <xsl:text>at</xsl:text>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    <!-- Provisional Number -->
    <xsl:choose>
      <xsl:when test="patent_provisional_number">
        <datafield tag="013" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:apply-templates select="patent_provisional_number"/>
          </subfield>
          <subfield code="u">
            <xsl:text>provisional</xsl:text>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- PCT Number -->
    <xsl:choose>
      <xsl:when test="patent_pct_number">
        <datafield tag="653" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:text>PCT/</xsl:text>
            <xsl:apply-templates select="patent_pct_number"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    <!-- WIPO Number -->
    <xsl:choose>
      <xsl:when test="patent_wipo_number">
        <datafield tag="653" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:text>WIPO/</xsl:text>
            <xsl:apply-templates select="patent_wipo_number"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    
      
    
  </xsl:template>
  
  <!-- Thesis Template -->
  <xsl:template name="thesis">
    <!-- Supervisors -->
    <xsl:choose>
      <xsl:when test="thesis_supervisor_last_name">
        <datafield tag="720" ind1="1" ind2="2">
          <subfield code="a">
            <xsl:apply-templates select="thesis_supervisor_last_name"/>, <xsl:apply-templates select="thesis_supervisor_first_name"/>
          </subfield>
          <subfield code="e">
            <xsl:text>(Supervisor)</xsl:text>
          </subfield>
          <subfield code="u">
            <xsl:apply-templates select="thesis_supervisor_affiliation"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!-- Other Supervisors -->
    <xsl:apply-templates select="*[starts-with(local-name(),'thesis_supervisor_last_name_')]"/>
    
    
    <!-- Thesis Degree Program -->
    <xsl:choose>
      <xsl:when test="thesis_degree">
        <datafield tag="502" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:apply-templates select="thesis_degree"/> <xsl:text> - </xsl:text><xsl:apply-templates select="thesis_degree_program"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  

  <!-- Conference Paper Template -->
  <xsl:template name="conference_paper">
    
    <!-- Conference Location / Dates / Proceedings Title / Name / Refereed -->
    <datafield tag="711"  ind1="2" ind2=" ">
      <subfield code="a">
        <xsl:apply-templates select="conference_name"/>
      </subfield>
      <subfield code="c">
        <xsl:apply-templates select="conference_location"/>
      </subfield>
      <subfield code="d">
        <xsl:apply-templates select="conference_date"/>
      </subfield>
     </datafield>
    

    <!-- Conference Location / Dates / Proceedings Title / Name / Refereed -->
    <datafield tag="773"  ind1="0" ind2=" ">
	<subfield code="t">
	        <xsl:apply-templates select="conference_title"/>
	</subfield>
      <subfield code="g">
        <xsl:if test="conference_page_from!='' and conference_page_to!=''"> p. <xsl:apply-templates select="conference_page_from"/>-<xsl:apply-templates select="conference_page_to"/></xsl:if>
      </subfield>
	<subfield code="d">
	  <xsl:apply-templates select="conference_publisher"/><xsl:text> : </xsl:text> <xsl:apply-templates select="conference_place_publication"/>
	</subfield>
        <subfield code="n">
             <xsl:choose>
               <xsl:when test="conference_peer_reviewed != 'Yes'">
                 <xsl:value-of select="0"/>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:value-of select="1"/>
               </xsl:otherwise>
             </xsl:choose>
	</subfield>
        <subfield code="x">
	        <xsl:apply-templates select="conference_issn"/>
        </subfield>
      <subfield code="z">
        <xsl:apply-templates select="conference_isbn"/>
      </subfield>
    </datafield>
    <!--conferencer url -->
    <xsl:choose>
      <xsl:when test="conference_url">
        <datafield tag="852" ind1="4" ind2="0">
          <subfield code="u">
            <xsl:apply-templates select="conference_url"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    

    
  </xsl:template>

  <!-- Book Chapter Template -->
  <xsl:template name="book_chapter">

    <!-- Book Chapter Publisher, Place of Publication, Date -->
    <xsl:choose>
      <xsl:when test="chapter_place_publication">
            <datafield tag="773" ind1="0" ind2=" ">
	        <subfield code="t">
			<xsl:apply-templates select="chapter_book_title"/>
		</subfield>
		<subfield code="b">
			<xsl:apply-templates select="chapter_edition"/>
		 </subfield>
		<subfield code="g">
		  <xsl:if test="chapter_number!=''">Chapter <xsl:apply-templates select="chapter_number"/></xsl:if><xsl:if test="chapter_page_from!='' and chapter_page_to!=''"> p. <xsl:apply-templates select="chapter_page_from"/>-<xsl:apply-templates select="chapter_page_to"/></xsl:if>
		</subfield>
	       <subfield code="d">
	         <xsl:apply-templates select="chapter_publisher"/><xsl:text> : </xsl:text><xsl:apply-templates select="chapter_place_publication"/>
	        </subfield>
		<subfield code="z">
			<xsl:apply-templates select="chapter_isbn"/>
		</subfield>
           </datafield>
      </xsl:when>
    </xsl:choose>
    
    <!--chapter url -->
    <xsl:choose>
    <xsl:when test="chapter_url">
      <datafield tag="852" ind1="4" ind2="0">
        <subfield code="u">
          <xsl:apply-templates select="chapter_url"/>
        </subfield>
      </datafield>
    </xsl:when>
    </xsl:choose>
    <!--chapter_series-->    
    <xsl:choose>
      <xsl:when test="chapter_series">
        <datafield tag="440" ind1=" " ind2="0">
          <subfield code="a">
            <xsl:apply-templates select="chapter_series"/>
          </subfield>
          <subfield code="v">
            <xsl:apply-templates select="chapter_series_number"/>
          </subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>

     <!-- Chapter Editor -->
    <xsl:choose>
      <xsl:when test="chapter_editor">
     <datafield tag="700" ind1="1" ind2=" ">
	<subfield code="a">
	  <xsl:apply-templates select="chapter_editor"/>
	</subfield>
	<subfield code="e">
	  <xsl:text> (Editor)</xsl:text>
	</subfield>
     </datafield>
     </xsl:when>
     </xsl:choose>

    


    <!-- Chapter Total Pages -->
    <xsl:variable name="first" select="chapter_page_to"/> 
    <xsl:variable name="second" select="chapter_page_from"/> 
     <datafield tag="300" ind1=" " ind2=" ">
	<subfield code="a">
	  <xsl:value-of select="number($first) - number($second)" />
	</subfield>
     </datafield>
  </xsl:template>

  <!-- Book Template -->
  <xsl:template name="book">

    <!-- Book  Publisher, Place of Publication, Date -->
    <xsl:choose>
      <xsl:when test="year">
            <datafield tag="260" ind1=" " ind2=" ">
	     <subfield code="a">
	        <xsl:apply-templates select="book_place_publication"/>
	     </subfield>
	     <subfield code="b">
	        <xsl:apply-templates select="book_publisher"/>
	     </subfield>
	     <subfield code="c">
	        <xsl:apply-templates select="year"/>
	     </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>

     <!-- Book Series -->
    <xsl:choose>
      <xsl:when test="book_series">
            <datafield tag="440" ind1=" " ind2="0">
	     <subfield code="a">
	        <xsl:value-of select="book_series"/>   
	     </subfield>
              <xsl:if test="book_series_number!=''">
              <subfield code="v">
                <xsl:value-of select="book_series_number"/>   
              </subfield>
              </xsl:if>
            </datafield>
      </xsl:when>
      
    </xsl:choose>
    
    <!-- Book ISBN -->
    <xsl:choose>
      <xsl:when test="book_isbn">
            <datafield tag="020" ind1=" " ind2=" ">
	     <subfield code="a">
	        <xsl:apply-templates select="book_isbn"/>
	     </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>

    <!-- Book Edition -->
    <xsl:choose>
      <xsl:when test="book_edition">
            <datafield tag="250" ind1=" " ind2=" ">
	     <subfield code="a">
	        <xsl:apply-templates select="book_edition"/>
	     </subfield>
            </datafield>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!-- Multiple Keywords -->
  <xsl:template match="*[starts-with(local-name(),'keyword')]">
	<datafield tag="653" ind1=" " ind2=" ">
	 <subfield code="a">
	        <xsl:value-of select="."/>
	 </subfield> 
	</datafield>
  </xsl:template>

  <!-- Multiple Creators -->
  <xsl:template match="*[starts-with(local-name(),'creator_last_name_')]">
	<xsl:variable name="num" select="substring-after(name(),'creator_last_name_')"/>
	<xsl:variable name="first_name" select="concat('creator_first_name_',$num)"/>
	<xsl:variable name="affiliation" select="concat('creator_affiliation_',$num)"/>
	<datafield tag="700" ind1="1" ind2=" ">
	 <subfield code="a">
	  <xsl:value-of select="."/>, <xsl:value-of select="//*[local-name()=$first_name]"/>
	 </subfield>
	  <xsl:if test="//*[local-name()=$affiliation] !=''">
	   <subfield code="u">
	      <xsl:value-of select="//*[local-name()=$affiliation]"/>
	     </subfield>
	  </xsl:if>
	</datafield>
  </xsl:template>

  <!-- Multiple Faculty/School(s) -->
  <xsl:template match="*[starts-with(local-name(),'faculty_')]">
	<xsl:variable name="num" select="substring-after(name(),'faculty_')"/>
	<xsl:variable name="school" select="concat('research_unit_',$num)"/>
	<datafield tag="710" ind1="1" ind2=" ">
	 <subfield code="a">Monash University</subfield>
	 <subfield code="b">
	  <xsl:value-of select="."/>
	 </subfield>
	 <subfield code="b">
	  <xsl:value-of select="//*[local-name()=$school]"/>
	 </subfield>
	</datafield>
  </xsl:template>
  
  <!-- Multiple Supervisors -->
  <xsl:template match="*[starts-with(local-name(),'thesis_supervisor_last_name_')]">
	<xsl:variable name="num" select="substring-after(name(),'thesis_supervisor_last_name_')"/>
	<xsl:variable name="first_name" select="concat('thesis_supervisor_first_name_',$num)"/>
	<xsl:variable name="affiliation" select="concat('thesis_supervisor_affiliation_',$num)"/>
	<datafield tag="720" ind1=" " ind2=" ">
	 <subfield code="a">
	  <xsl:value-of select="."/>, <xsl:value-of select="//*[local-name()=$first_name]"/>, <xsl:value-of select="//*[local-name()=$affiliation]"/>
	 </subfield>
	</datafield>
  </xsl:template>
  
  <xsl:template name="splitString">
    <xsl:param name="string1"/>
     <xsl:choose>
      <xsl:when test="contains($string1,'&#13;')">
       <xsl:variable name="beforeCR" select="substring-before($string1,'&#13;')"/>
	<datafield tag="650" ind1=" " ind2="7">
	 <subfield code="a"><xsl:value-of select="$beforeCR"/></subfield>
	</datafield>

	<xsl:variable name="afterCR" select="substring-after($string1,'&#13;')"/>
	<xsl:call-template name="splitString">
	   <xsl:with-param name="string1" select="$afterCR" />
	</xsl:call-template>
       </xsl:when>
       <xsl:otherwise>
         <xsl:if test="$string1 !=''">
	<datafield tag="653" ind1=" " ind2=" ">
	 <subfield code="a"><xsl:value-of select="$string1"/></subfield>
	</datafield>
           </xsl:if>
       </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
  
  
  <!-- Creative Work Template-->
  
  <xsl:template name="creative_work">
    
  <xsl:choose>
    <xsl:when test="creative_type">
      <datafield tag="655" ind1=" " ind2="7">
        <subfield code="a">
          <xsl:apply-templates select="creative_type"/>
        </subfield>
      </datafield>
    </xsl:when>
  </xsl:choose>
  
    <xsl:choose>
    <xsl:when test="creative_edition">
      <datafield tag="250" ind1=" " ind2=" ">
        <subfield code="a"><xsl:value-of select="creative_edition"/></subfield>
      </datafield>
    </xsl:when>
    </xsl:choose>
 
     <xsl:choose>
        <xsl:when test="creative_place_publication!=''">
          <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a"><xsl:value-of select="creative_place_publication"/></subfield>
            <xsl:if test="creative_publisher !=''">
              <subfield code="b"><xsl:value-of select="creative_publisher"/></subfield>
            </xsl:if>
            <xsl:if test="creative_record_dist !=''">
              <subfield code="b"><xsl:value-of select="creative_record_dist"/><xsl:text> (Distributor)</xsl:text></subfield>
            </xsl:if>
            <xsl:if test="creative_publish_year !=''">
              <subfield code="c"><xsl:value-of select="creative_publish_year"/></subfield>
            </xsl:if>
          </datafield>
        </xsl:when>
       <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="creative_publisher!=''">
          <datafield tag="260" ind1=" " ind2=" ">
          <subfield code="b"><xsl:value-of select="creative_publisher"/></subfield> 
          <xsl:if test="creative_publish_year !=''">
            <subfield code="c"><xsl:value-of select="creative_publish_year"/></subfield>
          </xsl:if>
            <xsl:if test="creative_record_dist !=''">
              <subfield code="b"><xsl:value-of select="creative_record_dist"/><xsl:text> (Distributor)</xsl:text></subfield>
            </xsl:if>
          </datafield>
        </xsl:when>
        <xsl:otherwise>
          <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="c"><xsl:value-of select="creative_publish_year"/></subfield>
          </datafield>
        </xsl:otherwise>
        </xsl:choose>
        </xsl:otherwise>
     </xsl:choose>
    
    
    
    <xsl:choose>
      <xsl:when test="creative_url !=''">
        <datafield tag="852" ind1="4" ind2="0">
          <subfield code="u"><xsl:value-of select="creative_url"/></subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    <xsl:choose>
      <xsl:when test="creative_number_pages !=''">
        <datafield tag="300" ind1=" " ind2=" ">
          <subfield code="a"><xsl:value-of select="creative_number_pages"/></subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
    
    <xsl:if test="creative_exhibition_location !=''">
        <datafield tag="585" ind1=" " ind2=" ">
          <subfield code="a">
            <xsl:text>EXHIBITION NOTE: </xsl:text>
            <xsl:value-of select="creative_exhibition_location"/>
            <xsl:if test="creative_start_date !=''"><xsl:text>, </xsl:text> <xsl:value-of select="creative_start_date"/>
            </xsl:if>
          </subfield>
        </datafield>
    </xsl:if>
    
    <xsl:if test="creative_advert_place !=''">
      <datafield tag="585" ind1=" " ind2=" ">
      <subfield code="a">
        <xsl:text>ADVERT FOR EXHIBITION: </xsl:text>      
        <xsl:apply-templates select="creative_advert_place"/>     
        <xsl:if test="creative_advert_date !=''">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="creative_advert_date"/>    
        </xsl:if>
      </subfield>
      </datafield>
    </xsl:if>
   
    
    <xsl:if test="creative_record_create_date!=''">
      <datafield tag="518" ind1=" " ind2=" ">
        <subfield code="a"><xsl:text>Date of Recording: </xsl:text><xsl:value-of select="creative_record_create_date"/></subfield>
      </datafield>
    </xsl:if>
    <xsl:if test="creative_record_first_perform_date!=''">
      <datafield tag="518" ind1=" " ind2=" ">
        <subfield code="a"><xsl:text>First performed: </xsl:text><xsl:value-of select="creative_record_first_perform_date"/></subfield>
      </datafield>
    </xsl:if>
    
    <xsl:if test="creative_record_dist_medium!=''">
      <datafield tag="340" ind1=" " ind2=" ">
        <subfield code="a"><xsl:value-of select="creative_record_dist_medium"/></subfield>
      </datafield>
    </xsl:if>
    <xsl:if test="creative_isbn!=''">
      <datafield tag="020" ind1=" " ind2=" ">
        <subfield code="a"><xsl:value-of select="creative_isbn"/></subfield>
      </datafield>
    </xsl:if>
    <xsl:if test="creative_title!=''">
      <datafield tag="246" ind1="0" ind2="3">
        <subfield code="a"><xsl:value-of select="creative_title"/></subfield>
      </datafield>
    </xsl:if>
    
    
  </xsl:template>
  
    <xsl:template name="reference_work">
      <xsl:if test="ref_work_title!=''">
        <datafield ind1=" " ind2="0" tag="440">
          <subfield code="a"><xsl:value-of select="ref_work_title"/></subfield>
          </datafield>
      </xsl:if>
      <xsl:if test="ref_work_edition!=''">
    <datafield ind1=" " ind2=" " tag="250">
      <subfield code="a"><xsl:value-of select="ref_work_edition"/></subfield>
      </datafield>
   </xsl:if>
      <xsl:if test="ref_work_volume!=''">
        <datafield ind1="1" ind2="0" tag="245">
          <subfield code="n"><xsl:value-of select="ref_work_volume"/></subfield>
        </datafield>
        </xsl:if>
      <xsl:if test="ref_work_editor!=''">
        <datafield ind1=" " ind2=" " tag="720">
          <subfield code="a"><xsl:value-of select="ref_work_editor"/></subfield>
          <subfield code="e"><xsl:text>Editor</xsl:text></subfield>
          </datafield>
      </xsl:if>
      
      
      <xsl:choose>
        <xsl:when test="ref_work_publisher!=''">
          <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a"><xsl:value-of select="ref_work_place_publication"/></subfield>
            <xsl:if test="ref_work_publisher !=''">
              <subfield code="b"><xsl:value-of select="ref_work_publisher"/></subfield>
            </xsl:if>
            <xsl:if test="ref_work_publication_year !=''">
              <subfield code="c"><xsl:value-of select="ref_work_publication_year"/></subfield>
            </xsl:if>
          </datafield>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="creative_publisher!=''">
              <datafield tag="260" ind1=" " ind2=" ">
                <subfield code="b"><xsl:value-of select="ref_work_publisher"/></subfield>
                <xsl:if test="ref_work_publication_year !=''">
                  <subfield code="c"><xsl:value-of select="ref_work_publication_year"/></subfield>
                </xsl:if>
              </datafield>
            </xsl:when>
            <xsl:otherwise>
              <datafield tag="260" ind1=" " ind2=" ">
                <subfield code="c"><xsl:value-of select="ref_work_publication_year"/></subfield>
              </datafield>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      
     <xsl:if test="ref_work_url!=''">
        <datafield ind1="4" ind2="0" tag="852">
          <subfield code="u"><xsl:value-of select="ref_work_url"/></subfield>
          </datafield>
      </xsl:if>
      <xsl:if test="ref_work_appear_year!=''">
        <datafield ind1=" " ind2=" " tag="518">
          <subfield code="a"><xsl:text>Appearance Year: </xsl:text><xsl:value-of select="ref_work_appear_year"/>
          </subfield>
          </datafield>
       </xsl:if>
      <xsl:if test="ref_work_isbn!=''">
        <datafield ind1=" " ind2=" " tag="020">
          <subfield code="a"><xsl:value-of select="ref_work_isbn"/></subfield>
          </datafield>
      </xsl:if>
    </xsl:template>
  
  <xsl:template name="audio_visual">
    <xsl:if test="av_editor!=''">
      <datafield tag="508" ind1="1" ind2=" ">
        <subfield code="a"><xsl:text>editor, </xsl:text><xsl:value-of select="av_editor"/></subfield>
      </datafield>
      </xsl:if>
    <xsl:choose>
      <xsl:when test="av_place_publication!=''">
        <datafield tag="260" ind1=" " ind2=" ">
          <subfield code="a"><xsl:value-of select="av_place_publication"/></subfield>
          <xsl:if test="av_publisher !=''">
            <subfield code="b"><xsl:value-of select="av_publisher"/></subfield>
          </xsl:if>
          <xsl:if test="av_publish_year !=''">
            <subfield code="c"><xsl:value-of select="av_publish_year"/></subfield>
          </xsl:if>
        </datafield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="av_publisher!=''">
            <datafield tag="260" ind1=" " ind2=" ">
              <subfield code="b"><xsl:value-of select="av_publisher"/></subfield>
              <xsl:if test="av_publish_year !=''">
                <subfield code="c"><xsl:value-of select="av_publish_year"/></subfield>
              </xsl:if>
            </datafield>
          </xsl:when>
          <xsl:otherwise>
            <datafield tag="260" ind1=" " ind2=" ">
              <subfield code="c"><xsl:value-of select="av_publish_year"/></subfield>
            </datafield>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="av_url!=''">
      <datafield tag="852" ind1="4" ind2="0">
        <subfield code="u"><xsl:value-of select="av_url"/></subfield>
        </datafield>
    </xsl:if>
    <xsl:if test="av_recording_length!=''">
      <datafield tag="306" ind1=" " ind2=" ">
        <subfield code="a"><xsl:value-of select="av_recording_length"/></subfield>
      </datafield>
    </xsl:if>
    <xsl:if test="av_type!=''">
      <datafield tag="340" ind1=" " ind2=" ">
        <subfield code="a"><xsl:value-of select="av_type"/></subfield>
      </datafield>
    </xsl:if>
  </xsl:template>
  
  
</xsl:stylesheet>

