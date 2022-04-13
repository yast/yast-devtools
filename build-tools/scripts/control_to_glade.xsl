<!--
  Extract translatable strings from a Yast XML control file, output them in the
  format accepted by xgettext (Glade compatible XML)
-->

<xsl:stylesheet version="1.0"
  xmlns:n="http://www.suse.com/1.0/yast2ns"
  xmlns:config="http://www.suse.com/1.0/configns"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<!-- attribute definition for <interface> element -->
<xsl:attribute-set name="translatable_label">
  <xsl:attribute name="name">label</xsl:attribute>
  <xsl:attribute name="translatable">yes</xsl:attribute>
</xsl:attribute-set>

<!--
  Template for trimming leading and trailing white space (spaces and new lines)
  from a string.

  Notes:
    - The XSL already contains built-in function "normalize-space()", unfortunately
      this also trims extra white space *inside* the string which we do not want
      in this case. :-(
    - Inspired by https://stackoverflow.com/a/30463195
    - In XSL "substring()" function the index starts from 1!!
-->
<xsl:template name="trim">
  <xsl:param name="str"/>

  <xsl:choose>
    <!-- starts with a new line or space? -->
    <xsl:when test="string-length($str) &gt; 0 and (substring($str, 1, 1) = '&#x0a;' or substring($str, 1, 1) = ' ')">
      <!-- recursively call self with the string without the first character -->
      <xsl:call-template name="trim">
        <xsl:with-param name="str">
          <xsl:value-of select="substring($str, 2)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- ends with a new line or space? -->
    <xsl:when test="string-length($str) &gt; 0 and (substring($str, string-length($str)) = '&#x0a;' or substring($str, string-length($str)) = ' ')">
      <!-- recursively call self with the string without the last character -->
      <xsl:call-template name="trim">
        <xsl:with-param name="str">
          <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- otherwise just return the original string -->
    <xsl:otherwise>
      <xsl:value-of select="$str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- replace <label> by <property>, trim the leading and trailing white space from the value -->
<xsl:template match="n:label">
  <xsl:element name="property" use-attribute-sets="translatable_label">
    <xsl:call-template name="trim">
      <xsl:with-param name="str" select="text()"/>
    </xsl:call-template>
  </xsl:element>
</xsl:template>

<!-- comments for translators -->
<!-- match a comment immediately preceding a <label>,
     see http://stackoverflow.com/questions/2613159/xslt-and-xpath-match-preceding-comments -->
<xsl:template match="comment()[following-sibling::*[1]/self::n:label]">
  <xsl:copy>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!--
  replace the root <productDefines> element by <interface>
  due to namespace it cannot be used literally
-->
<xsl:template match="/n:productDefines">
    <xsl:element name="interface">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
</xsl:template>

<!--
  Allow processing also the XSL files which contain translations.
  Handle it like an XML file, just replace the root <xsl:stylesheet> tag
  by <interface> as expected by xgettext in *.glade files.
-->
<xsl:template match="/xsl:stylesheet">
    <interface>
        <xsl:apply-templates select="node()|@*"/>
    </interface>
</xsl:template>

<!-- remove the remaining non-matched text -->
<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>

