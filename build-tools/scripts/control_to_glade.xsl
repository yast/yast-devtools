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

<!-- replace <label> by <property>, keep the original value -->
<xsl:template match="n:label">
  <xsl:element name="property" use-attribute-sets="translatable_label">
    <xsl:copy-of select="text()"/>
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

