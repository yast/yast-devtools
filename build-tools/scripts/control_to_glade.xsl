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

<!--
  replace the root <productDefines> element by <interface>
  due to namespace it cannot be used literally
-->
<xsl:template match="/n:productDefines">
    <xsl:element name="interface">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
</xsl:template>

<!-- remove the remaining non-matched text -->
<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>

