<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

  <!-- identity transformation, see
       http://www.w3.org/TR/xslt#copying -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ignore stringval -->
  <xsl:template match="STRINGVALUE"/>
  <!-- ignore ignore -->
  <xsl:template match="IGNORE"/>

</xsl:stylesheet>
