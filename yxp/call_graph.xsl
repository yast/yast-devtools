<?xml version='1.0'?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

  <xsl:output method="text"/>

  <!-- disable copying of text and attrs in normal mode-->
  <xsl:template match="text()|@*"/>

  <!-- we are looking for function calls (term...)
       in functions (definition) -->
  <!-- definition//term/identifier: gets also variables
       we want the one that is followed by a paren -->
  <xsl:template match="definition//term/identifier[
                       contains (following-sibling::CHAR, '(')
                       and not (
                         normalize-space () = '`id' or
                         normalize-space () = '`opt' or
                         normalize-space () = 'lookup' or
                         normalize-space () = 'select' or
                         normalize-space () = 'add' or
                         normalize-space () = 'size' or
                         false ()
                       )
                       ]">
    <xsl:text>"</xsl:text>    
    <xsl:apply-templates select="ancestor::definition//definition_symbol/SYMBOL" mode="output"/>
    <xsl:text>"</xsl:text>    
    <xsl:text>-&gt;</xsl:text>
    <xsl:text>"</xsl:text>    
    <xsl:apply-templates select="." mode="output"/>
    <xsl:text>"</xsl:text>    
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- also, mark function definitions so that they stand out -->
  <xsl:template match="definition//definition_symbol/SYMBOL">
    <xsl:text>"</xsl:text>    
    <xsl:apply-templates select="." mode="output"/>
    <xsl:text>"</xsl:text>    
    <xsl:text>[style=bold]&#10;</xsl:text>
  </xsl:template>

  <!-- in output mode, there is the implicit text-copying rule -->

  <!-- copy _direct_ text children -->
  <!--
  <xsl:template match="SYMBOL/text()" mode="output">
    <xsl:copy/>
  </xsl:template>
  -->

  <!-- ignore -->
  <xsl:template match="IGNORE" mode="output"/>

</xsl:stylesheet>
