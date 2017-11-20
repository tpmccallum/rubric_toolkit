<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="utf-8" method="xml"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/">
      <xsl:apply-templates select="Session/Formdata"/>
    </oai_dc:dc>
  </xsl:template>
  
  <xsl:template match="Session/Formdata">
    <!-- Language -->
    <xsl:choose>
      <xsl:when test="language">
        <dc:language>
          <xsl:apply-templates select="language"/>
        </dc:language>
      </xsl:when>
    </xsl:choose>
    
    <!-- Generic Title -->
    <xsl:choose>
      <xsl:when test="title">
        <dc:title>
          <xsl:apply-templates select="title"/>
        </dc:title>
      </xsl:when>
    </xsl:choose>
    <!-- Additional Info -->
    <xsl:choose>
      <xsl:when test="additional_info !=''">
        <dc:description>
          <xsl:apply-templates select="additional_info"/>
        </dc:description>
      </xsl:when>
    </xsl:choose>
    
    <!-- Abstract -->
    <xsl:choose>
      <xsl:when test="description_abstract">
        <dc:description>
          <xsl:apply-templates select="description_abstract"/>
        </dc:description>
      </xsl:when>
    </xsl:choose>

    <!-- Resource Type -->
    <xsl:choose>
      <xsl:when test="resource_type">
            <dc:type>
              <xsl:choose>
                <xsl:when test="contains(resource_type,'Conference Publication')">
                  <xsl:text>Conference Paper</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="resource_type"/>
                </xsl:otherwise>
              </xsl:choose>
            </dc:type>
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
        <xsl:if test="$rtype = 'Review'">
          <xsl:call-template name="review"/>
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
        <xsl:if test="$rtype = 'Computer Software'">
          <xsl:call-template name="software"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Report'">
          <xsl:call-template name="report"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Patent'">
          <xsl:call-template name="patent"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Audio Visual'">
          <xsl:call-template name="av"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Reference Work'">
          <xsl:call-template name="referencework"/>
        </xsl:if>
        <xsl:if test="$rtype = 'Creative Work'">
          <xsl:call-template name="creativework"/>
        </xsl:if>
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

    <!-- Date -->
    <xsl:choose>
      <xsl:when test="year">
            <dc:date>
	        <xsl:apply-templates select="year"/>
            </dc:date>
      </xsl:when>
    </xsl:choose>
    <!-- Faculty -->
    <xsl:choose>
      <xsl:when test="faculty != ''">
        <dc:relation>
          <xsl:if test="university_name !=''">
            <xsl:apply-templates select="university_name"/><xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="faculty"/>
          <xsl:if test="research_unit !=''">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="research_unit"/>
          </xsl:if>
        </dc:relation>
      </xsl:when>
    </xsl:choose>
    
    <!-- Creators -->
    <xsl:choose>
      <xsl:when test="creator_last_name">
            <dc:creator>
	        <xsl:apply-templates select="creator_last_name"/>, <xsl:apply-templates select="creator_first_name"/>
            </dc:creator>
        
      </xsl:when>
    </xsl:choose>
    
    <!-- Other Creators -->
    <xsl:apply-templates select="*[starts-with(local-name(),'creator_last_name_')]"/>

    <!-- Rights -->
    <xsl:choose>
      <xsl:when test="rights !=''">
            <dc:rights>
	        <xsl:apply-templates select="rights"/>
            </dc:rights>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>

  <!-- Working Paper Template -->
  <xsl:template name="working_paper">
    <!--Working Paper Publisher -->
    
    <xsl:choose>
      <xsl:when test="working_paper_publisher !=''">
        <dc:publisher>
          <xsl:apply-templates select="working_paper_publisher"/> 
          <xsl:if test="working_paper_place_publication !=''">
            <xsl:text> : </xsl:text>
            <xsl:apply-templates select="working_paper_place_publication"/> 
          </xsl:if>
        </dc:publisher>
      </xsl:when>
    </xsl:choose>
     
    <!-- Working Paper  Details -->
    <xsl:choose>
      <xsl:when test="working_paper_title">
        <dc:relation>
          <xsl:apply-templates select="working_paper_title"/>
          <xsl:if test="working_paper_place_publication !=''">
            <xsl:text>, No.</xsl:text>
            <xsl:apply-templates select="working_paper_number"/> 
          </xsl:if>
        </dc:relation>
      </xsl:when>
    </xsl:choose>
    
    
    
    <!-- Working Paper  URL -->
    <xsl:choose>
      <xsl:when test="working_paper_url">
        <dc:relation>
          <xsl:apply-templates select="working_paper_url"/>
        </dc:relation>
      </xsl:when>
    </xsl:choose>
    
    <!-- Working ISBN-->
    <xsl:choose>
      <xsl:when test="working_paper_isbn !=''">
        <dc:identifier>
          <xsl:text>ISBN </xsl:text>          
          <xsl:apply-templates select="working_paper_isbn"/>   
        </dc:identifier>
      </xsl:when>
    </xsl:choose>
    
    <!-- Working ISSN-->
    <xsl:choose>
      <xsl:when test="working_paper_issn !=''">
        <dc:identifier>
          <xsl:text>ISSN </xsl:text>          
          <xsl:apply-templates select="working_paper_issn"/>   
        </dc:identifier>
      </xsl:when>
    </xsl:choose>
    
    

  </xsl:template>

  <!-- Journal Article Template -->
  <xsl:template name="journal_article">
  

    <!-- Journal Title -->
    <xsl:choose>
      <xsl:when test="journal_title">
            <dc:relation>
                <xsl:apply-templates select="journal_title"/><xsl:if test="journal_title">, Vol. <xsl:value-of select="journal_volume"/></xsl:if>           
              <xsl:if test="journal_issue !=''">, Issue <xsl:value-of select="journal_issue"/></xsl:if><xsl:if test="journal_number!=''">, no. <xsl:value-of select="journal_number"/>           </xsl:if>
              <xsl:if test="journal_page_from !=''">, p. <xsl:value-of select="journal_page_from"/>-<xsl:value-of select="journal_page_to"/>
                </xsl:if>
             </dc:relation>
      </xsl:when>
    </xsl:choose>
     <!-- Journal URL -->
    <xsl:choose>
      <xsl:when test="journal_url">
            <dc:relation>
                <xsl:value-of select="journal_url"/>
            </dc:relation>
      </xsl:when>
    </xsl:choose>

  </xsl:template>


  <!--Review Template -->
  <xsl:template name="review">
  

    <!-- Review Title -->
    <xsl:choose>
      <xsl:when test="review_title">
            <dc:relation>
                <xsl:apply-templates select="review_title"/><xsl:if test="review_title">, Vol. <xsl:value-of select="review_volume"/></xsl:if>           
              <xsl:if test="review_issue">, Issue <xsl:value-of select="review_issue"/></xsl:if><xsl:if test="review_number">, No. <xsl:value-of select="review_number"/>           </xsl:if>
              <xsl:if test="review_page_from">, p. <xsl:value-of select="review_page_from"/>-<xsl:value-of select="review_page_to"/>
                </xsl:if>
             </dc:relation>
      </xsl:when>
    </xsl:choose>
     <!-- Review URL -->
    <xsl:choose>
      <xsl:when test="review_url">
            <dc:relation>
                <xsl:value-of select="review_url"/>
            </dc:relation>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!-- Thesis Template -->
  <xsl:template name="thesis">
    <!-- Supervisors -->
    <xsl:choose>
      <xsl:when test="thesis_supervisor_last_name">
            <dc:contributor>
	        <xsl:apply-templates select="thesis_supervisor_last_name"/>, <xsl:apply-templates select="thesis_supervisor_first_name"/><xsl:text> (Supervisor) </xsl:text><xsl:apply-templates select="thesis_supervisor_affiliation"/>
            </dc:contributor>
      </xsl:when>
    </xsl:choose>
    
    <!-- Other Supervisors -->
    <xsl:apply-templates select="*[starts-with(local-name(),'thesis_supervisor_last_name_')]"/>

    <!-- Thesis Degree Program -->
    <xsl:choose>
      <xsl:when test="thesis_degree">
            <dc:description>
              <xsl:apply-templates select="thesis_degree"/> <xsl:text> - </xsl:text><xsl:apply-templates select="thesis_degree_program"/>
            </dc:description>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Conference Paper Template -->
  <xsl:template name="conference_paper">


    <!-- Conference Name Location and Date-->
    <xsl:choose>
      <xsl:when test="conference_name">
            <dc:relation>
	        <xsl:apply-templates select="conference_name"/><xsl:if test="conference_location != ''">, <xsl:apply-templates select="conference_location"/></xsl:if><xsl:if test="conference_date != ''">, <xsl:apply-templates select="conference_date"/></xsl:if>
            </dc:relation>
      </xsl:when>
    </xsl:choose>

    <!-- Conference Proceeding Title -->
    <xsl:choose>
      <xsl:when test="conference_title">
            <dc:relation>
	        <xsl:apply-templates select="conference_title"/><xsl:if test="conference_page_from!=''">, p. <xsl:apply-templates select="conference_page_from"/>-<xsl:apply-templates select="conference_page_to"/></xsl:if>
            </dc:relation>
      </xsl:when>
    </xsl:choose>
     <!-- Conference Editor-->
    <xsl:choose>
      <xsl:when test="conference_editor">
            <dc:contributor>
	        <xsl:apply-templates select="conference_editor"/> <xsl:text> (Editor)</xsl:text>
            </dc:contributor>
      </xsl:when>
    </xsl:choose>
    <!-- Conference URL-->
    <xsl:choose>
      <xsl:when test="conference_url">
            <dc:relation>
	        <xsl:apply-templates select="conference_url"/> 
            </dc:relation>
      </xsl:when>
    </xsl:choose>

  </xsl:template>
  
  <!-- Software Template -->
  <xsl:template name="software">
    
    
    <!-- Software Description-->
    <xsl:choose>
      <xsl:when test="software_technical_details !=''">
        <dc:description>
          <xsl:apply-templates select="software_technical_details"/> 
          <xsl:if test="software_edition !=''">
            <xsl:text>, Edition </xsl:text>
            <xsl:apply-templates select="software_edition"/> 
            </xsl:if>
        </dc:description>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="software_publisher !=''">
        <dc:publisher>
          <xsl:apply-templates select="software_publisher"/> 
          <xsl:if test="software_place_publication !=''">
            <xsl:text> : </xsl:text>
            <xsl:apply-templates select="software_place_publication"/> 
          </xsl:if>
        </dc:publisher>
      </xsl:when>
    </xsl:choose>
    
    
    
  </xsl:template>
  
  <!-- Patent Template -->
  <xsl:template name="patent">
    
    
    <!-- Patent Owner-->
    <xsl:choose>
      <xsl:when test="patent_owner !=''">
        <dc:contributor>
          <xsl:apply-templates select="patent_owner"/> 
                 <xsl:text> (Owner) </xsl:text>
        </dc:contributor>
      </xsl:when>
    </xsl:choose>
    <!-- Patent Number-->
    <xsl:choose>
      <xsl:when test="patent_number !=''">
        <dc:identifier>
          <xsl:apply-templates select="patent_number"/> 
          <xsl:choose>
            <xsl:when test="patent_place_publication !='at'">
              <xsl:text>, </xsl:text>
              <xsl:apply-templates select="patent_place_publication"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>, Australia</xsl:text>
            </xsl:otherwise>
          </xsl:choose>        
        </dc:identifier>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- Report Template -->
  <xsl:template name="report">
    
    
    <!-- Report Commissioner-->
    <xsl:choose>
      <xsl:when test="report_commissioner !=''">
        <dc:contributor>
                  <xsl:apply-templates select="report_commissioner"/> 
        </dc:contributor>
      </xsl:when>
    </xsl:choose>
    
    
    <!--Report Publisher -->
          
    <xsl:choose>
      <xsl:when test="report_publisher !=''">
        <dc:publisher>
          <xsl:apply-templates select="report_publisher"/> 
          <xsl:if test="report_place_publication !=''">
            <xsl:text> : </xsl:text>
            <xsl:apply-templates select="report_place_publication"/> 
          </xsl:if>
        </dc:publisher>
      </xsl:when>
    </xsl:choose>
    
    <!-- Report Series-->
    <xsl:choose>
      <xsl:when test="report_series !=''">
        <dc:relation>
          <xsl:apply-templates select="report_series"/> 
        </dc:relation>
      </xsl:when>
    </xsl:choose>
    
     <!-- Report ISBN-->
    <xsl:choose>
      <xsl:when test="report_isbn !=''">
        <dc:identifier>
          <xsl:text>ISBN </xsl:text>          
          <xsl:apply-templates select="report_isbn"/>   
        </dc:identifier>
      </xsl:when>
    </xsl:choose>    
  </xsl:template>

  <!-- Book Chapter Template -->
  <xsl:template name="book_chapter">

    <!-- Book Chapter (Book Title) -->
    <xsl:choose>
      <xsl:when test="chapter_book_title">
            <dc:relation>
              <xsl:apply-templates select="chapter_book_title"/><xsl:if test="chapter_edition !=''">, Edition <xsl:apply-templates select="chapter_edition"/></xsl:if><xsl:if test="chapter_number!=''">, Chapter <xsl:apply-templates select="chapter_number"/></xsl:if><xsl:if test="chapter_page_from!=''">, p. <xsl:apply-templates select="chapter_page_from"/>-<xsl:apply-templates select="chapter_page_to"/></xsl:if>
            </dc:relation>
      </xsl:when>
    </xsl:choose>


    <!-- Book Chapter Publisher -->
    <xsl:choose>
      <xsl:when test="chapter_publisher">
            <dc:publisher>
	        <xsl:apply-templates select="chapter_publisher"/>
	         <xsl:choose>
         		<xsl:when test="chapter_place_publication">
			        <xsl:text> : </xsl:text>
                 	        <xsl:apply-templates select="chapter_place_publication"/>
                      </xsl:when>
		  </xsl:choose>
            </dc:publisher>
      </xsl:when>
    </xsl:choose>

    <!-- Book Chapter ISBN -->
    <xsl:choose>
      <xsl:when test="chapter_isbn">
            <dc:identifier>
              <xsl:text>ISBN </xsl:text>
	        <xsl:apply-templates select="chapter_isbn"/>
            </dc:identifier>
      </xsl:when>
    </xsl:choose>
    <!-- Book Chapter URL -->
    <xsl:choose>
      <xsl:when test="chapter_url">
            <dc:relation>
	        <xsl:apply-templates select="chapter_url"/>
            </dc:relation>
      </xsl:when>
    </xsl:choose>

     <!-- Book Chapter Series -->
    <xsl:choose>
      <xsl:when test="chapter_series">
            <dc:relation>
	        <xsl:apply-templates select="chapter_series"/><xsl:text> - No. </xsl:text><xsl:apply-templates select="chapter_series_number"/>
            </dc:relation>
      </xsl:when>
    </xsl:choose>
    <!-- Book Chapter Editor -->
    <xsl:choose>
      <xsl:when test="chapter_editor">
            <dc:contributor>
	        <xsl:apply-templates select="chapter_editor"/><xsl:text> (Editor)</xsl:text>
              </dc:contributor>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!-- Book Template -->
  <xsl:template name="book">
    <!-- Book Publisher  & Place of Publication-->
    <xsl:choose>
      <xsl:when test="book_publisher">
            <dc:publisher>
	        <xsl:apply-templates select="book_publisher"/>
              <xsl:if test="book_place_publication !=''">
                <xsl:text> : </xsl:text>
                <xsl:apply-templates select="book_place_publication"/>
              </xsl:if>
            </dc:publisher>
      </xsl:when>
    </xsl:choose>


    <!-- Book ISBN -->
    <xsl:choose>
      <xsl:when test="book_isbn">
            <dc:identifier>
              <xsl:text>ISBN </xsl:text>
	        <xsl:apply-templates select="book_isbn"/>
            </dc:identifier>
      </xsl:when>
    </xsl:choose>
     <!-- Book Series -->
    <xsl:choose>
      <xsl:when test="book_series">
            <dc:relation>
	        <xsl:apply-templates select="book_series"/>
		<xsl:choose>
			 <xsl:when test="book_series_number">
				<xsl:text> - No.</xsl:text>
          			 <xsl:value-of select="book_series_number"/>
			</xsl:when>
		</xsl:choose>
            </dc:relation>
      </xsl:when>
    </xsl:choose>
     

  </xsl:template>
  
  <!-- Audio Visual Template -->
  <xsl:template name="av">
    
    
    <!-- Audio Visual Description-->
    <xsl:if test="av_editor !=''">
      <dc:description>
        <xsl:text>editor, </xsl:text>
        <xsl:apply-templates select="av_editor"/> 
      </dc:description>
    </xsl:if>
    
       <xsl:if test="av_recording_length !=''">
        <dc:description>
          <xsl:apply-templates select="av_recording_length"/> 
         </dc:description>
       </xsl:if>
    
    <xsl:choose>
      <xsl:when test="av_publisher !=''">
        <dc:publisher>
          <xsl:apply-templates select="av_publisher"/> 
          <xsl:if test="av_place_publication !=''">
            <xsl:text> : </xsl:text>
            <xsl:apply-templates select="av_place_publication"/> 
          </xsl:if>
        </dc:publisher>
      </xsl:when>
    </xsl:choose>
    
    <xsl:if test="av_url !=''">
      <dc:relation>
        <xsl:apply-templates select="av_url"/> 
      </dc:relation>
    </xsl:if>
    <xsl:if test="av_type !=''">
      <dc:format>
        <xsl:apply-templates select="av_type"/> 
      </dc:format>
    </xsl:if>
    <xsl:if test="av_title !=''">
      <dc:title>
        <xsl:apply-templates select="av_title"/> 
      </dc:title>
    </xsl:if>    
  </xsl:template>
  
  
  <!-- Reference Work Template -->
  <xsl:template name="referencework">
    
    
    <!-- Reference Work Description-->
      <xsl:if test="ref_work_edition !=''">
        <dc:description>
          <xsl:text>Edition or Version: </xsl:text>
          <xsl:apply-templates select="ref_work_edition"/> 
         </dc:description>
      </xsl:if>
    <xsl:if test="ref_work_volume !=''">
      <dc:description>
        <xsl:text>Vol. </xsl:text>
        <xsl:apply-templates select="ref_work_volume"/> 
      </dc:description>
    </xsl:if>
    <xsl:if test="ref_work_editor !=''">
      <dc:contributor>
             <xsl:apply-templates select="ref_work_editor"/> 
        <xsl:text>, Editor </xsl:text>
      </dc:contributor>
    </xsl:if>
      <xsl:choose>
      <xsl:when test="ref_work_publisher !=''">
        <dc:publisher>
          <xsl:apply-templates select="ref_work_publisher"/> 
          <xsl:if test="ref_work_place_publication !=''">
            <xsl:text> : </xsl:text>
            <xsl:apply-templates select="ref_work_place_publication"/> 
          </xsl:if>
        </dc:publisher>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="ref_work_url !=''">
      <dc:relation>
        <xsl:apply-templates select="ref_work_url"/> 
      </dc:relation>
    </xsl:if>
    <xsl:if test="ref_work_appear_year !=''">
  
      <dc:description>
        <xsl:text>Appearance Year: </xsl:text>
        <xsl:apply-templates select="ref_work_appear_year"/> 
        </dc:description>
    </xsl:if>
    <xsl:if test="ref_work_isbn !=''">
      <dc:identifier>
        <xsl:text>ISBN </xsl:text>
        <xsl:apply-templates select="ref_work_isbn"/> 
      </dc:identifier>
    </xsl:if>
    <xsl:if test="ref_work_title !=''">
      <dc:title>
        <xsl:apply-templates select="ref_work_title"/> 
      </dc:title>
    </xsl:if>
    
    
  </xsl:template>
  
  
  <!-- Creative Work Template -->
  <xsl:template name="creativework">
    
    
    <!-- Creative Work Description-->
    
    <xsl:if test="creative_type !=''">
      <dc:type>
        <xsl:apply-templates select="creative_type"/> 
      </dc:type>
    </xsl:if>
    <xsl:if test="creative_edition !=''">
      <dc:description>
        <xsl:text>Edition or Version: </xsl:text>
        <xsl:apply-templates select="creative_edition"/> 
      </dc:description>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="creative_publisher !=''">
        <dc:publisher>
          <xsl:apply-templates select="creative_publisher"/> 
          <xsl:if test="creative_place_publication !=''">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="creative_place_publication"/> 
          </xsl:if>
          <xsl:if test="creative_record_dist !=''">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="creative_record_dist"/> 
            <xsl:text> (Distributor) </xsl:text>
          </xsl:if>
        </dc:publisher>
      </xsl:when>
    </xsl:choose>
    
    

    <xsl:if test="creative_url !=''">
      <dc:relation>
        <xsl:apply-templates select="creative_url"/> 
      </dc:relation>
    </xsl:if>
    
    
    <xsl:if test="creative_number_pages !=''">
      <dc:description>
             <xsl:apply-templates select="creative_number_pages"/>
        <xsl:text> p.</xsl:text>
      </dc:description>
    </xsl:if>
    

    <xsl:if test="creative_exhibition_location !=''">
      <dc:description>
        <xsl:text>EXHIBITION NOTE: </xsl:text>
        <xsl:apply-templates select="creative_exhibition_location"/> 
        <xsl:if test="creative_start_date !=''">
          <xsl:text>, </xsl:text>
            <xsl:apply-templates select="creative_start_date"/>          
        </xsl:if>
      </dc:description>
    </xsl:if>
    <xsl:if test="creative_advert_place !=''">
      <dc:description>
        <xsl:text>ADVERT FOR EXHIBITION: </xsl:text>
         <xsl:if test="creative_advert_place !=''">
           <xsl:apply-templates select="creative_advert_place"/>          
        </xsl:if>
        <xsl:if test="creative_advert_date !=''">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="creative_advert_date"/>          
        </xsl:if>
      </dc:description>
    </xsl:if>
    <xsl:if test="creative_isbn !=''">
      <dc:identifier>
        <xsl:text>ISBN </xsl:text>
        <xsl:apply-templates select="creative_isbn"/> 
      </dc:identifier>
    </xsl:if>
    <xsl:if test="creative_record_dist_medium !=''">
      <dc:format>
        <xsl:apply-templates select="creative_record_dist_medium"/> 
      </dc:format>
    </xsl:if>
    <xsl:if test="creative_record_create_date !=''">
      <dc:description>
        <xsl:text>Date of Recording: </xsl:text>
        <xsl:apply-templates select="creative_record_create_date"/> 
      </dc:description>
    </xsl:if>
    <xsl:if test="creative_record_first_perform_date !=''">
      <dc:description>
        <xsl:text>First Performed: </xsl:text>
        <xsl:apply-templates select="creative_record_first_perform_date"/> 
      </dc:description>
    </xsl:if>
    <xsl:if test="creative_title !=''">
      <dc:title>
        <xsl:apply-templates select="creative_title"/> 
      </dc:title>
    </xsl:if>    
  </xsl:template>
  

  <!-- Multiple Keywords -->
  <xsl:template match="*[starts-with(local-name(),'keyword')]">
	<dc:subject>
	        <xsl:value-of select="."/>
	</dc:subject>
  </xsl:template>

  <!-- Multiple Creators -->
  <xsl:template match="*[starts-with(local-name(),'creator_last_name_')]">
	<xsl:variable name="num" select="substring-after(name(),'creator_last_name_')"/>
	<xsl:variable name="first_name" select="concat('creator_first_name_',$num)"/>
	<xsl:variable name="affiliation" select="concat('creator_affiliation_',$num)"/>
	<dc:creator>
	  <xsl:value-of select="."/>, <xsl:value-of select="//*[local-name()=$first_name]"/>
	</dc:creator>

  </xsl:template>
  
  <!-- Multiple Supervisors -->
  <xsl:template match="*[starts-with(local-name(),'thesis_supervisor_last_name_')]">
	<xsl:variable name="num" select="substring-after(name(),'thesis_supervisor_last_name_')"/>
	<xsl:variable name="first_name" select="concat('thesis_supervisor_first_name_',$num)"/>
	<xsl:variable name="affiliation" select="concat('thesis_supervisor_affiliation_',$num)"/>
	<dc:contributor>
	  <xsl:value-of select="."/>, <xsl:value-of select="//*[local-name()=$first_name]"/>
	</dc:contributor>
	<dc:contributor>
	  <xsl:value-of select="//*[local-name()=$affiliation]"/>
	</dc:contributor>
  </xsl:template>
  
  <xsl:template name="splitString">
    <xsl:param name="string1"/>
     <xsl:choose>
      <xsl:when test="contains($string1,'&#13;')">
       <xsl:variable name="beforeCR" select="substring-before($string1,'&#13;')"/>
	<xsl:element name="dc:subject"><xsl:value-of select="$beforeCR"/></xsl:element>
	<xsl:variable name="afterCR" select="substring-after($string1,'&#13;')"/>
	<xsl:call-template name="splitString">
	   <xsl:with-param name="string1" select="$afterCR" />
	</xsl:call-template>
       </xsl:when>
       <xsl:otherwise>
         <xsl:if test="$string1 !=''">
		<xsl:element name="dc:subject">
			<xsl:value-of select="$string1"/>
		</xsl:element>
           </xsl:if>
       </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
