<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:gl-plt="http://www.xbrl.org/int/gl/plt/2010-04-16"
                xmlns:gl-cor="http://www.xbrl.org/int/gl/cor/2006-10-25"
                xmlns:gl-bus="http://www.xbrl.org/int/gl/bus/2006-10-25"
                xmlns:gl-muc="http://www.xbrl.org/int/gl/muc/2006-10-25"
                xmlns:xbrli="http://www.xbrl.org/2003/instance"
                xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
                xmlns:xades="http://uri.etsi.org/01903/v1.3.2#"
                xmlns:edefter="http://www.edefter.gov.tr"
                xmlns:defterek="http://www.edefter.gov.tr/ek"
                version="2.0"
                exclude-result-prefixes="#all"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. The name or details of 
    this mode may change during 1Q 2007.-->


<!--PHASES-->


<!--PROLOG-->
   <xsl:output method="xml"/>

   <!--KEYS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:variable name="sameUri">
         <xsl:value-of select="saxon:system-id() = parent::node()/saxon:system-id()"
                       use-when="function-available('saxon:system-id')"/>
         <xsl:value-of select="true()" use-when="not(function-available('saxon:system-id'))"/>
      </xsl:variable>
      <xsl:if test="$sameUri = 'true'">
         <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      </xsl:if>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$sameUri = 'true'">
         <xsl:variable name="preceding"
                       select="count(preceding-sibling::*[local-name()=local-name(current())                                    and namespace-uri() = namespace-uri(current())])"/>
         <xsl:text>[</xsl:text>
         <xsl:value-of select="1+ $preceding"/>
         <xsl:text>]</xsl:text>
      </xsl:if>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="text()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>text()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::text())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="comment()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>comment()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::comment())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>processing-instruction()</xsl:text>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::processing-instruction())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:choose>
         <xsl:when test="count(. | ../namespace::*) = count(../namespace::*)">
            <xsl:value-of select="concat('.namespace::-',1+count(namespace::*),'-')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA METADATA-->
   <xsl:template match="/">
      <Errors>
         <xsl:apply-templates select="/" mode="M18"/>
         <xsl:apply-templates select="/" mode="M19"/>
         <xsl:apply-templates select="/" mode="M20"/>
         <xsl:apply-templates select="/" mode="M21"/>
         <xsl:apply-templates select="/" mode="M22"/>
         <xsl:apply-templates select="/" mode="M23"/>
         <xsl:apply-templates select="/" mode="M24"/>
         <xsl:apply-templates select="/" mode="M25"/>
         <xsl:apply-templates select="/" mode="M26"/>
         <xsl:apply-templates select="/" mode="M27"/>
         <xsl:apply-templates select="/" mode="M28"/>
         <xsl:apply-templates select="/" mode="M29"/>
         <xsl:apply-templates select="/" mode="M30"/>
      </Errors>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <xsl:variable name="vknTckn"
                 select="/edefter:berat/xbrli:xbrl/xbrli:context/xbrli:entity/xbrli:identifier"/>
   <xsl:variable name="beratTipi"
                 select="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:documentInfo/gl-cor:entriesType"/>
   <xsl:variable name="periodCoveredStart"
                 select="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:documentInfo/gl-cor:periodCoveredStart"/>
   <xsl:variable name="donemYil" select="substring($periodCoveredStart,1,4)"/>
   <xsl:variable name="donemAy" select="substring($periodCoveredStart,6,2)"/>
   <xsl:variable name="donem" select="number(concat($donemYil,$donemAy))"/>
   <xsl:variable name="vergiDetaysizMi"
                 select="/edefter:berat/xbrli:xbrl/xbrli:context/xbrli:entity/xbrli:segment/gl-cor:identifierAuthorityCode"/>

   <!--PATTERN kok-->


	  <!--RULE -->
   <xsl:template match="*" priority="102" mode="M18">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@decimals) or  @decimals = 'INF'"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>Belge i??erisindeki 'decimals' nitelikleri 'INF' de??erini almal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/" priority="101" mode="M18">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="edefter:berat"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>Berat dok??man?? edefter:berat ana eleman?? ile ba??lamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M18"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M18"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN entity-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/xbrli:context/xbrli:entity"
                 priority="101"
                 mode="M19">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$beratTipi='journal' or not(xbrli:segment/gl-bus:numberOfEntries)"/>
         <xsl:otherwise>
            <Error>
               <xsl:text> xbrli:segment/gl-bus:numberOfEntries eleman?? sadece yevmiye berat??nda bulunabilir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($beratTipi='journal') or xbrli:segment/gl-bus:numberOfEntries"/>
         <xsl:otherwise>
            <Error>
               <xsl:text> Yevmiye berat??nda xbrli:segment/gl-bus:numberOfEntries zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xbrli:segment/gl-cor:uniqueID"/>
         <xsl:otherwise>
            <Error>
               <xsl:text> xbrli:segment/gl-cor:uniqueID zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(xbrli:segment/gl-cor:uniqueID) or matches(xbrli:segment/gl-cor:uniqueID,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>xbrli:segment/gl-cor:uniqueID eleman?? UUID format??nda olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M19"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M19"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN berat-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat" priority="101" mode="M20">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(extensions/extension/defterek:binaryObject) = 0 "/>
         <xsl:otherwise>
            <Error>
               <xsl:text>defterek:binaryObject eleman?? sadece yevmiye defterinde bulunabilir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M20"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M20"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN xbrl-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl" priority="102" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(xbrli:context) = 1 "/>
         <xsl:otherwise>
            <Error>
               <xsl:text>xbrli:context zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(xbrli:unit) &gt;= 1 "/>
         <xsl:otherwise>
            <Error>
               <xsl:text>xbrli:unit zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(gl-cor:accountingEntries) = 1 "/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:accountingEntries zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(xbrli:unit/xbrli:measure) &gt;= 1 "/>
         <xsl:otherwise>
            <Error>
               <xsl:text>xbrli:measure zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/xbrli:context/xbrli:entity/xbrli:identifier"
                 priority="101"
                 mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.) , '^[0-9]{10,11}$')"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>xbrli:identifier eleman??na 10 haneli vergi kimlik numaras?? ve ya 11 haneli TC kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M21"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M21"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN measure-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/xbrli:unit/xbrli:measure"
                 priority="101"
                 mode="M22">
      <xsl:variable name="currency" select="substring(.,9)"/>
      <xsl:variable name="currencyCodeList"
                    select="',AED,AFN,ALL,AMD,ANG,AOA,ARS,AUD,AWG,AZN,BAM,BBD,BDT,BGN,BHD,BIF,BMD,BND,BOB,BOV,BRL,BSD,BTN,BWP,BYN,BYR,BZD,CAD,CDF,CHE,CHF,CHW,CLF,CLP,CNY,COP,COU,CRC,CUC,CUP,CVE,CZK,DJF,DKK,DOP,DZD,EEK,EGP,ERN,ETB,EUR,FJD,FKP,GBP,GEL,GHS,GIP,GMD,GNF,GTQ,GWP,GYD,HKD,HNL,HRK,HTG,HUF,IDR,ILS,INR,IQD,IRR,ISK,JMD,JOD,JPY,KES,KGS,KHR,KMF,KPW,KRW,KWD,KYD,KZT,LAK,LBP,LKR,LRD,LSL,LTL,LVL,LYD,MAD,MAD,MDL,MGA,MKD,MMK,MNT,MOP,MRO,MUR,MVR,MWK,MXN,MXV,MYR,MZN,NAD,NGN,NIO,NOK,NPR,NZD,OMR,PAB,PEN,PGK,PHP,PKR,PLN,PYG,QAR,RON,RSD,RUB,RWF,SAR,SBD,SCR,SDG,SEK,SGD,SHP,SLL,SOS,SSP,SRD,STD,SVC,SYP,SZL,THB,TJS,TMT,TND,TOP,TRY,TTD,TWD,TZS,UAH,UGX,USD,USN,USS,UYI,UYU,UZS,VEF,VND,VUV,WST,XAF,XAG,XAU,XBA,XBB,XBC,XBD,XCD,XDR,XFU,XOF,XPD,XPF,XPT,XSU,XTS,XUA,XXX,YER,ZAR,ZMK,ZMW,ZWL,'"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not (starts-with(normalize-space(.),'iso4217:')) or contains($currencyCodeList, concat(',',$currency,','))"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>Gecersiz currency degeri: '</xsl:text>
               <xsl:value-of select="$currency"/>
               <xsl:text>'.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(parent::node()[contains($currencyCodeList, @id)]) &lt;=1 "/>
         <xsl:otherwise>
            <Error>
               <xsl:text>id'si iso4217 multicurrency kodlar??ndan birisi olan en fazla 1 xbrli:unit eleman?? olabilir. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(parent::node()[contains($currencyCodeList,@id)]) or  .= concat('iso4217:',parent::node()/@id) "/>
         <xsl:otherwise>
            <Error>
               <xsl:text>xbrli:measure de??eri (</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>) hatal??d??r. xbrli:unit id'nin de??eri </xsl:text>
               <xsl:value-of select="parent::node()/@id"/>
               <xsl:text> oldu??u i??in xbrli:measure de??eri </xsl:text>
               <xsl:value-of select="concat('iso4217:',parent::node()/@id)"/>
               <xsl:text> olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(parent::node()[contains($currencyCodeList, @id)]) or  not(/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:documentInfo/gl-muc:defaultCurrency) or not(.= concat('iso4217:',parent::node()/@id)) or /edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:documentInfo/gl-muc:defaultCurrency=."/>
         <xsl:otherwise>
            <Error>
               <xsl:text> gl-muc:defaultCurrency de??eri (</xsl:text>
               <xsl:value-of select="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:documentInfo/gl-muc:defaultCurrency"/>
               <xsl:text>) hatal??d??r. gl-muc:defaultCurrency eleman?? varsa de??eri xbrli:measure(</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>) ile ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M22"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M22"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN accountingentries-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries"
                 priority="101"
                 mode="M23">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:documentInfo"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:documentInfo zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:entityInformation"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:entityInformation zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="($vergiDetaysizMi='VERGI_DETAYSIZ') or count(gl-cor:entryHeader)=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text> Vergi detay??n?? temsil edecek gl-cor:entryHeader eleman?? say??s?? 1 olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vergiDetaysizMi='VERGI_DETAYSIZ') or count(gl-cor:entryHeader)=0"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>Vergi detays??z beratlarda gl-cor:entryHeader eleman?? bulunmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M23"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M23"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN entryHeader-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entryHeader"
                 priority="101"
                 mode="M24">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:qualifierEntry"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:qualifierEntry zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M24"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M24"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN entryDetail-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entryHeader/gl-cor:entryDetail[1]"
                 priority="101"
                 mode="M25">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:lineNumber =1 "/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:entryHeader eleman??n??n ilk gl-cor:entryDetail eleman??n??n gl-cor:lineNumber de??eri 1 olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M25"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M25"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN entryHeader-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entryHeader"
                 priority="101"
                 mode="M26">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:qualifierEntry='standard'"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>D??nem i??i de??i??iklikleri temsil eden gl-cor:entryHeader eleman??n??n gl-cor:qualifierEntry de??eri standard olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(gl-cor:entryDetail)=10"/>
         <xsl:otherwise>
            <Error>
               <xsl:text> D??nem i??i de??i??iklikleri temsil eden gl-cor:entryDetail eleman?? say??s?? 10 olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=391 and gl-cor:debitCreditCode='D'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=391, gl-cor:debitCreditCode=D olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=391 and gl-cor:debitCreditCode='C'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=391, gl-cor:debitCreditCode=C olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=191 and gl-cor:debitCreditCode='D'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=191, gl-cor:debitCreditCode=D olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=191 and gl-cor:debitCreditCode='C'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=191, gl-cor:debitCreditCode=C olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=600 and gl-cor:debitCreditCode='D'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=600, gl-cor:debitCreditCode=D olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=600 and gl-cor:debitCreditCode='C'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=600, gl-cor:debitCreditCode=C olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=601 and gl-cor:debitCreditCode='D'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=601, gl-cor:debitCreditCode=D olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=601 and gl-cor:debitCreditCode='C'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=601, gl-cor:debitCreditCode=C olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=602 and gl-cor:debitCreditCode='D'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=602, gl-cor:debitCreditCode=D olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count( gl-cor:entryDetail[gl-cor:account/gl-cor:accountMainID=602 and gl-cor:debitCreditCode='C'])=1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account/gl-cor:accountMainID=602, gl-cor:debitCreditCode=C olan 1 gl-cor:entryDetail eleman?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M26"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M26"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN entryDetail-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entryHeader[gl-cor:qualifierEntry='standard']/gl-cor:entryDetail"
                 priority="101"
                 mode="M27">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:xbrlInfo/gl-cor:xbrlInclude='period_change' "/>
         <xsl:otherwise>
            <Error>
               <xsl:text>D??nem i??i de??i??iklikleri temsil eden gl-cor:entryDetail elemanlar??n??n gl-cor:xbrlInfo/gl-cor:xbrlInclude de??eri period_change olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M27"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M27"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN entryDetail-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entryHeader/gl-cor:entryDetail"
                 priority="101"
                 mode="M28">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:lineNumber"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:lineNumber zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(following-sibling::node()) or not(following-sibling::node()/gl-cor:lineNumber) or not(gl-cor:lineNumber) or following-sibling::node()/number(gl-cor:lineNumber) = number(gl-cor:lineNumber) + 1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:lineNumber m??teselsil bir de??ere sahip olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:account"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-cor:account) or not(gl-cor:account/gl-cor:accountMainID) or string-length(gl-cor:account/normalize-space(gl-cor:accountMainID)) = 3 or string-length(gl-cor:account/normalize-space(gl-cor:accountMainID)) = 4"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account eleman?? i??erisinde gl-cor:accountMainID zorunlu bir elemand??r ve en az 3 karakter olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-cor:account) or gl-cor:account/gl-cor:accountMainDescription"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:account eleman?? i??erisinde gl-cor:accountMainDescription zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:amount"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:amount zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:debitCreditCode"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:debitCreditCode zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:xbrlInfo/gl-cor:xbrlInclude"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:xbrlInfo/gl-cor:xbrlInclude eleman?? zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:amount &gt;= 0"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>Vergi detay??nda hi??bir tutar 0'dan k??????k olamaz.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(gl-cor:amount) , '^[0-9]+(\.[0-9]{1,2})?$')"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:amount (</xsl:text>
               <xsl:value-of select="gl-cor:amount"/>
               <xsl:text>) virg??lden sonra 2 haneden fazla olamaz.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M28"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M28"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN documentinfo-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:documentInfo"
                 priority="101"
                 mode="M29">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:entriesType"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:entriesType zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not ($beratTipi='journal') or ( normalize-space(gl-cor:entriesType) = 'journal')"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:entriesType eleman?? yevmiye defteri berat?? i??in 'journal' de??erini almal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not ($beratTipi='ledger') or ( normalize-space(gl-cor:entriesType) = 'ledger')"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:entriesType eleman?? kebir defteri berat?? i??in 'ledger' de??erini almal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:uniqueID"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:uniqueID zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-cor:uniqueID) or not ($beratTipi='journal') or( starts-with(normalize-space(gl-cor:uniqueID),'YEV'))"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:uniqueID eleman?? yevmiye defteri i??in 'YEV' de??eri ile ba??lamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-cor:uniqueID) or not ($beratTipi='ledger') or( starts-with(normalize-space(gl-cor:uniqueID),'KEB'))"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:uniqueID eleman?? yevmiye defteri i??in 'KEB' de??eri ile ba??lamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-cor:uniqueID) or string-length(normalize-space(gl-cor:uniqueID)) = 15"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:uniqueID eleman?? 15 karakterden olu??mal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:creationDate"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:creationDate zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:periodCoveredStart"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:periodCoveredStart zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:periodCoveredEnd"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:periodCoveredEnd zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:periodCoveredEnd &gt;= gl-cor:periodCoveredStart"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:periodCoveredEnd eleman?? gl-cor:periodCoveredStart eleman??ndan b??y??k veya e??it olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-cor:creationDate &gt;= gl-cor:periodCoveredEnd"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:creationDate eleman?? gl-cor:periodCoveredEnd eleman??ndan b??y??k ve ya e??it olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(gl-bus:sourceApplication)) &gt; 0"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:sourceApplication zorunlu bir elemand??r ve de??eri bo??luk olmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="donemYilPrdEnd" select="substring(gl-cor:periodCoveredEnd,1,4)"/>
      <xsl:variable name="donemAyPrdEnd" select="substring(gl-cor:periodCoveredEnd,6,2)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$donemYil=$donemYilPrdEnd"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:periodCoveredStart eleman??ndaki y??l bilgisi ile periodCoveredEnd eleman??ndaki y??l bilgisi ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$donemAy=$donemAyPrdEnd"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:periodCoveredStart eleman??ndaki ay bilgisi ile periodCoveredEnd eleman??ndaki ay bilgisi ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains(gl-cor:uniqueID,concat($donemYil,$donemAy))"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-cor:uniqueID eleman??ndaki d??nem bilgisi ile gl-cor:periodCoveredStart eleman??ndaki d??nem bilgisi ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M29"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M29"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN entityinformation-->


	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entityInformation"
                 priority="105"
                 mode="M30">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-bus:entityPhoneNumber"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:entityPhoneNumber zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-bus:entityEmailAddressStructure"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:entityEmailAddressStructure zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(gl-bus:organizationIdentifiers) &gt;= 1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationIdentifiers zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(string-length($vknTckn) = 10) or count(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = 'Kurum Unvan??']) = 1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationDescription de??eri 'Kurum Unvan??' olan bir tane gl-bus:organizationIdentifiers eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(string-length($vknTckn) = 11) or count(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = 'Ad?? Soyad??']) = 1"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationDescription de??eri 'Ad?? Soyad??' olan bir tane gl-bus:organizationIdentifiers eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="countKurumUnvani"
                    select="count(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = 'Kurum Unvan??'])"/>
      <xsl:variable name="countAdiSoyadi"
                    select="count(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = 'Ad?? Soyad??'])"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="($countKurumUnvani=1 and not($countAdiSoyadi=1)) or ($countAdiSoyadi=1 and not($countKurumUnvani=1))"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationDescription de??eri 'Kurum Unvan??' veya 'Ad?? Soyad??' olan yaln??zca bir tane gl-bus:organizationIdentifiers eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = 'Kurum Unvan??']) = 1) or      string-length(normalize-space(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = 'Kurum Unvan??']/gl-bus:organizationIdentifier)) &gt;=2"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationDescription de??eri 'Kurum Unvan??' olan gl-bus:organizationIdentifiers eleman??n??n gl-bus:organizationIdentifier eleman de??eri en az iki karakter olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = 'Ad?? Soyad??']) = 1) or      string-length(normalize-space(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = 'Ad?? Soyad??']/gl-bus:organizationIdentifier)) &gt;=2"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationDescription de??eri 'Ad?? Soyad??' olan gl-bus:organizationIdentifiers eleman??n??n gl-bus:organizationIdentifier eleman de??eri en az iki karakter olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="countSubeNo"
                    select="count(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = '??ube No'])"/>
      <xsl:variable name="countSubeAdi"
                    select="count(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = '??ube Ad??'])"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(not($countSubeNo = 1) or $countSubeAdi = 1) and (not($countSubeAdi = 1) or $countSubeNo = 1)"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>??ube no ve ??ube ad?? birlikte bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="($countSubeNo &lt; 2) and ($countSubeAdi &lt; 2)"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>??ube no veya ??ube ad?? birden fazla olamaz.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($countSubeNo = 1) or matches(normalize-space(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = '??ube No']/gl-bus:organizationIdentifier) , '^[0-9]{4}$')"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>??ube no 4 haneli say??sal bir de??er olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($countSubeAdi = 1) or string-length(normalize-space(gl-bus:organizationIdentifiers[gl-bus:organizationDescription = '??ube Ad??']/gl-bus:organizationIdentifier)) &gt;= 2"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>??ube ad?? de??eri en az iki karakter olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-bus:organizationAddress"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationAddress zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-bus:organizationAddress) or gl-bus:organizationAddress/gl-bus:organizationBuildingNumber"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationAddress eleman?? i??erisindeki gl-bus:organizationBuildingNumber zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-bus:organizationAddress) or gl-bus:organizationAddress/gl-bus:organizationAddressStreet"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationAddress eleman?? i??erisindeki gl-bus:organizationAddressStreet zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-bus:organizationAddress) or gl-bus:organizationAddress/gl-bus:organizationAddressCity"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationAddress eleman?? i??erisindeki gl-bus:organizationAddressCity zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-bus:organizationAddress) or gl-bus:organizationAddress/gl-bus:organizationAddressZipOrPostalCode"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationAddress' eleman?? i??erisindeki 'gl-bus:organizationAddressZipOrPostalCode zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(gl-bus:organizationAddress) or gl-bus:organizationAddress/gl-bus:organizationAddressCountry"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:organizationAddress eleman?? i??erisindeki gl-bus:organizationAddressCountry zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-bus:entityWebSite"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:entityWebSite zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(gl-bus:businessDescription)) &gt; 0"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:businessDescription zorunlu bir elemand??r ve de??eri bo??luk olmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-bus:fiscalYearStart"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:fiscalYearStart zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-bus:fiscalYearEnd"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:fiscalYearEnd zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-bus:fiscalYearEnd &gt; gl-bus:fiscalYearStart"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:fiscalYearEnd eleman?? gl-bus:fiscalYearStart eleman??ndan b??y??k olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-bus:accountantInformation"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:accountantInformation zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entityInformation/gl-bus:accountantInformation"
                 priority="104"
                 mode="M30">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(gl-bus:accountantName)) &gt; 0"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:accountantInformation eleman?? i??erisindeki gl-bus:accountantName zorunlu bir elemand??r ve de??eri bo??luk olmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(gl-bus:accountantEngagementTypeDescription)) &gt; 0"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:accountantInformation eleman?? i??erisindeki gl-bus:accountantEngagementTypeDescription zorunlu bir elemand??r ve de??eri bo??luk olmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entityInformation/gl-bus:entityPhoneNumber"
                 priority="103"
                 mode="M30">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(gl-bus:phoneNumber)) &gt; 0"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:phoneNumber zorunlu bir elemand??r ve de??eri bo??luk olmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entityInformation/gl-bus:entityEmailAddressStructure"
                 priority="102"
                 mode="M30">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(gl-bus:entityEmailAddress)) &gt; 0"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:entityEmailAddressStructure eleman?? i??erisinde gl-bus:entityEmailAddress zorunlu bir elemand??r ve ve de??eri bo??luk olmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/edefter:berat/xbrli:xbrl/gl-cor:accountingEntries/gl-cor:entityInformation/gl-bus:entityWebSite"
                 priority="101"
                 mode="M30">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="gl-bus:webSiteURL"/>
         <xsl:otherwise>
            <Error>
               <xsl:text>gl-bus:entityWebSite eleman?? i??erisindeki gl-bus:webSiteURL zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M30"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M30"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
