<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY undocumented "">
<!ENTITY undocumented2 "[DOCS MISSING]">
]>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" /> 

    <xsl:template match="/">
        <xsl:apply-templates/> 
        <xsl:call-template name="disambiguate" />
    </xsl:template>

    <!-- googled "xslt grouping":
         http://www.jenitennison.com/xslt/grouping/muenchian.html -->
    <xsl:key name="entries-by-file" match="entries_item" use="filename" />
    <xsl:key name="entries-by-name" match="entries_item" use="names/names_item" />

    <xsl:template match="yast2doc/entries">
      <xsl:for-each select="entries_item [
                            count(. | key('entries-by-file', filename)[1]) = 1
                            ]">
        <xsl:sort select="filename" />

        <reference id="{filename}">
          <title>
            <xsl:value-of select="file_summary"/>
          </title>
          <xsl:for-each select="key('entries-by-file', filename)">
            <xsl:sort select="names/names_item"/>
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </reference>

      </xsl:for-each>
    </xsl:template>

    <xsl:template name="refentry-id-chunk-meta">
      <xsl:param name="use-id" select="/.." />

      <!-- dirsep must be allowed in IDs -->
      <xsl:variable name="dirsep">.</xsl:variable>
      <xsl:variable name="id">
                <xsl:choose>
                    <xsl:when test="$use-id != ''">
                        <xsl:value-of select="$use-id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="replace-substring">
                            <xsl:with-param name="from" select="'::'" />
                            <xsl:with-param name="to" select="$dirsep" />
                            <xsl:with-param name="value" select="names/names_item"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>       
      </xsl:variable>
      <xsl:variable name="dir">
        <xsl:if test="contains($id, $dirsep)">
            <xsl:value-of select="substring-before($id, $dirsep)" />          
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="filename">
        <xsl:choose>
          <xsl:when test="contains($id, $dirsep)">
            <xsl:value-of select="substring-after($id, $dirsep)" />          
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$id" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:attribute name="id">
        <xsl:value-of select="$id" />
      </xsl:attribute>

      <!-- produce file names according to yastdoc rules -->
      <xsl:if test="$dir != ''">
        <xsl:processing-instruction name="dbhtml">
          <xsl:text>dir="</xsl:text>
          <xsl:value-of select="$dir" />
          <xsl:text>"</xsl:text>
        </xsl:processing-instruction>
      </xsl:if>
      <xsl:processing-instruction name="dbhtml">
        <xsl:text>filename="</xsl:text>
        <xsl:value-of select="$filename" />
        <xsl:text>.html"</xsl:text>
      </xsl:processing-instruction>
            <refmeta>
                    <refentrytitle>
                        <xsl:if test="namespace != ''">
                            <xsl:value-of select="namespace"/>
                            <xsl:text>::</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="names/names_item"/>
                    </refentrytitle>
                    <manvolnum>
                      <xsl:value-of select="file_summary"/>
                      <xsl:text>, </xsl:text>
                      <xsl:value-of select="$filename" />
                    </manvolnum>
                </refmeta>
    </xsl:template>

    <xsl:template match="entries_item">

        <refentry>
		<xsl:call-template name="refentry-id-chunk-meta">
                  <xsl:with-param name="use-id" select="id" />
                </xsl:call-template>

                <refnamediv>
                    <xsl:for-each select="names/names_item">
                        <refname>
                            <xsl:if test="../../namespace != ''">
                                <xsl:value-of select="../../namespace"/>
                                <xsl:text>::</xsl:text>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </refname>
                    </xsl:for-each>
                    <refpurpose><xsl:value-of select="short"/></refpurpose>
                </refnamediv>
                <refsynopsisdiv>
                    <funcsynopsis>
                    <xsl:for-each select="names/names_item">
                        <funcprototype>
                            <funcdef>
                                    <type>
                                        <xsl:value-of select="../../return/type"/> 
                                    </type>
                                    <function>
                                        <xsl:value-of select="."/>
                                    </function>
                            </funcdef>
                            <xsl:choose>
                                <xsl:when
                                    test="count(../../parameters/parameters_item) > 0">
                                    <xsl:for-each
                                        select="../../parameters/parameters_item">
                                        <paramdef>
                                            <type>
                                                <xsl:value-of select="type"/> 
                                            </type>
                                            <parameter>
                                                <xsl:value-of select="name"/> 
                                            </parameter>
                                        </paramdef>
                                    </xsl:for-each>
                                    <xsl:for-each
                                        select="../../optargs/optargs_item">
                                        <paramdef>
                                            <xsl:attribute name="choice">
                                                <xsl:text>opt</xsl:text>
                                            </xsl:attribute>
                                            <type>
                                                <xsl:value-of select="type"/> 
                                            </type>
                                            <parameter>
                                                <xsl:value-of select="name"/> 
                                            </parameter>
                                        </paramdef>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <void/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </funcprototype>
                    </xsl:for-each>
                    </funcsynopsis>

                </refsynopsisdiv>

                <xsl:apply-templates select="parameters"/>
                <xsl:apply-templates select="options"/>
                <xsl:apply-templates select="optargs"/>
                <xsl:apply-templates select="properties"/>
                <xsl:apply-templates select="return"/>
                <xsl:apply-templates select="description"/>
                <xsl:apply-templates select="usage"/>
                <xsl:apply-templates select="examples"/>
        </refentry>
      </xsl:template>

    <xsl:template match="properties">
        <xsl:if test="count(properties_item) > 0 ">
            <refsect1>
                <title>Properties</title>
                <variablelist>
                    <xsl:for-each select="properties_item">
                        <varlistentry>
                            <term>
                                <type>
                                    <xsl:value-of select="type"/>
                                </type> 
                                <parameter>
                                    <xsl:value-of select="name"/>
                                </parameter>
                            </term>
                            <listitem>
                                <para>
                                    <xsl:value-of select="description"/>
                                </para>
                            </listitem>
                        </varlistentry>
                    </xsl:for-each>
                </variablelist>
            </refsect1>
        </xsl:if>

    </xsl:template>

    <xsl:template match="optargs">
        <xsl:if test="count(optargs_item) > 0 ">
            <refsect1>
                <title>Optional Arguments</title>
                <variablelist>
                    <xsl:for-each select="optargs_item">
                        <varlistentry>
                            <term>
                                <type>
                                    <xsl:value-of select="type"/>
                                </type> 
                                <parameter>
                                    <xsl:value-of select="name"/>
                                </parameter>
                            </term>
                            <listitem>
                                <xsl:for-each select="description/ITEM">
                                    <xsl:choose>
                                        <xsl:when test="contains(., '&lt;code&gt;')">
                                            <programlisting>
                                                <xsl:value-of select="."/>
                                            </programlisting>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <para>
                                                <xsl:value-of select="."/>
                                            </para>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </listitem>
                        </varlistentry>
                    </xsl:for-each>
                </variablelist>
            </refsect1>
        </xsl:if>

    </xsl:template>

    

    <xsl:template match="options">
        <xsl:if test="count(options_item) > 0 ">
            <refsect1>
                <title>Options</title>
                <variablelist>
                    <xsl:for-each select="options_item">
                        <varlistentry>
                            <term>
                                <parameter>
                                    <xsl:value-of select="name"/>
                                </parameter>
                            </term>
                            <listitem>
                                <xsl:for-each select="description/ITEM">
                                    <para>
                                    <xsl:choose>
                                        <xsl:when test="contains(., '&lt;code&gt;')">
                                            <programlisting>
                                                <xsl:value-of select="."/>
                                            </programlisting>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <para>
                                                <xsl:value-of select="."/>
                                            </para>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    </para>
                                </xsl:for-each>
                            </listitem>
                        </varlistentry>
                    </xsl:for-each>
                </variablelist>
            </refsect1>
        </xsl:if>
    </xsl:template>

    <xsl:template match="examples">
        <xsl:if test="count(examples_item) > 0 ">
            <refsect1>
                <title>Examples</title>
                <xsl:for-each select="examples_item">
                    <informalexample>
                    <programlisting><xi:include 
                            xmlns:xi="http://www.w3.org/2001/XInclude">
                            <xsl:attribute name="href">
                                <xsl:text>examples/</xsl:text>
                                <xsl:value-of select="example"/>
                            </xsl:attribute>
                            <xsl:attribute name="parse">
                                <xsl:text>text</xsl:text>
                            </xsl:attribute>
                        </xi:include>
                        <xsl:if test="screenshot != ''">
                            <screenshot>
                                <screeninfo>
                                    <xsl:value-of select="example"/>
                                </screeninfo>
                                <graphic>
                                    <xsl:attribute name="fileref">
                                        <xsl:text>examples/screenshots/</xsl:text>
                                        <xsl:value-of select="screenshot"/>
                                    </xsl:attribute>
                                </graphic>
                            </screenshot>
                        </xsl:if>
                    </programlisting>

                    </informalexample>
                </xsl:for-each>
            </refsect1>
        </xsl:if>

    </xsl:template>

    
    <xsl:template match="parameters">
        <xsl:if test="count(parameters_item) > 0 ">
            <refsect1>
                <title>Parameters</title>
                <variablelist>
                    <xsl:for-each select="parameters_item">
                        <varlistentry>
                            <term>
                                <type>
                                    <xsl:value-of select="type"/>
                                </type> 
                                <parameter>
                                    <xsl:value-of select="name"/>
                                </parameter>
                            </term>
                            <listitem>
                                <xsl:for-each select="description/ITEM">
                                    <para>
                                        <xsl:value-of select="."/>
                                    </para>
                                </xsl:for-each>
                            </listitem>
                        </varlistentry>
                    </xsl:for-each>
                </variablelist>
            </refsect1>
        </xsl:if>

    </xsl:template>

    <xsl:template match="description">
        <xsl:if test="count(description_item) > 0 ">
            <refsect1>
                <title>Description</title>
                <xsl:for-each select="description_item">
                    <para>
                                    <xsl:choose>
                                        <xsl:when test="contains(., '&lt;code&gt;')">
                                            <programlisting>
                                                <xsl:value-of select="."/>
                                            </programlisting>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                    </para>
                </xsl:for-each>
                <xsl:if test="../note != ''">
                    <note>
                        <xsl:for-each select="../note/note_item">
                            <para>
                                <xsl:value-of select="."/>
                            </para>
                        </xsl:for-each>
                    </note>
                </xsl:if> 
            </refsect1>
        </xsl:if>
    </xsl:template>



    <xsl:template match="usage">
            <refsect1>
                <title>Usage</title>
                    <programlisting>
                        <xsl:value-of select="."/>
                    </programlisting>
            </refsect1>
    </xsl:template>

    

    <xsl:template match="return|return_type">
        <xsl:if test="type != ''">
            <refsect1>
                <title>Return</title>
                <variablelist>
                        <varlistentry>
                            <term>
                                <type>
                                    <xsl:value-of select="type"/>
                                </type>
                            </term>
                            <listitem>
 			        <xsl:if test="not(description)">
                                  <para>&undocumented;</para>
				</xsl:if>
                                <xsl:for-each select="description">
                                    <para>
                                        <xsl:value-of select="."/>
                                    </para>
                                </xsl:for-each>
                            </listitem>
                        </varlistentry>
                </variablelist>
            </refsect1>
        </xsl:if>
    </xsl:template>

    <!-- create add.html for add-list.html and add-map.html -->
    <xsl:template name="disambiguate">
      <reference id="Disambiguation">
        <title>Disambiguation</title>

        <!--  id!='' assumes all duplicates have id defined. -->
        <xsl:for-each select="yast2doc/entries/entries_item [
                              id != '' and
                 count(. | key('entries-by-name', names/names_item)[1]) = 1]">
          <xsl:sort select="names/names_item" />

          <refentry>
            <xsl:call-template name="refentry-id-chunk-meta" />

            <refnamediv>
              <refname>
                <xsl:value-of select="names/names_item"/>
              </refname>
              <refpurpose>disambiguation</refpurpose>
            </refnamediv>

            <refsect1>
              <title>Variants</title>
              <simplelist>
                <xsl:for-each select="key('entries-by-name', names/names_item)">
                  <xsl:sort select="id" />
                  <member>
                    <xref linkend="{id}" />
                  </member>
                </xsl:for-each>
              </simplelist>
            </refsect1>

          </refentry>

        </xsl:for-each>
      </reference>
    </xsl:template>

   <xsl:template name="html-replace-entities">
      <xsl:param name="text" />
      <xsl:param name="attrs" />
      <xsl:variable name="tmp">
         <xsl:call-template name="replace-substring">
            <xsl:with-param name="from" select="'&gt;'" />
            <xsl:with-param name="to" select="dd" />
            <xsl:with-param name="value">
               <xsl:call-template name="replace-substring">
                  <xsl:with-param name="from" select="'&lt;'" />
                  <xsl:with-param name="to" select="dd" />
                  <xsl:with-param name="value">
                     <xsl:call-template name="replace-substring">
                        <xsl:with-param name="from" 
                                        select="'&amp;'" />
                        <xsl:with-param name="to" 
                                        select="'&amp;amp;'" />
                        <xsl:with-param name="value" 
                                        select="$text" />
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
         <!-- $text is an attribute value -->
         <xsl:when test="$attrs">
            <xsl:call-template name="replace-substring">
               <xsl:with-param name="from" select="'&#xA;'" />
               <xsl:with-param name="to" select="'&amp;#xA;'" />
               <xsl:with-param name="value">
                  <xsl:call-template name="replace-substring">
                     <xsl:with-param name="from" 
                                     select="'&quot;'" />
                     <xsl:with-param name="to" 
                                     select="'&amp;quot;'" />
                     <xsl:with-param name="value" select="$tmp" />
                  </xsl:call-template>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$tmp" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- replace in $value substring $from with $to -->
   <xsl:template name="replace-substring">
      <xsl:param name="value" />
      <xsl:param name="from" />
      <xsl:param name="to" />
      <xsl:choose>
         <xsl:when test="contains($value,$from)">
            <xsl:value-of select="substring-before($value,$from)" />
            <xsl:value-of select="$to" />
            <xsl:call-template name="replace-substring">
               <xsl:with-param name="value" 
                               select="substring-after($value,$from)" />
               <xsl:with-param name="from" select="$from" />
               <xsl:with-param name="to" select="$to" />
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$value" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template> 
    <xsl:template name="replace">
        <xsl:param name="string" select="''"/>
        <xsl:param name="pattern" select="''"/>
        <xsl:param name="replacement" select="''"/>
        <xsl:choose>
            <xsl:when test="$pattern != '' and $string != '' and contains($string, $pattern)">
                <xsl:value-of select="substring-before($string, $pattern)"/>
                <!--
                Use "xsl:copy-of" instead of "xsl:value-of" so that users
                may substitute nodes as well as strings for $replacement.
                -->
                <xsl:copy-of select="$replacement"/>
                <xsl:call-template name="replace">
                    <xsl:with-param name="string" select="substring-after($string, $pattern)"/>
                    <xsl:with-param name="pattern" select="$pattern"/>
                    <xsl:with-param name="replacement" select="$replacement"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string"/> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
