<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" encoding="ISO-8859-1"/> 

    <xsl:template match="/">
        <xsl:apply-templates/> 
    </xsl:template>
    <xsl:template match="entries">
        <reference>
           <xsl:attribute name="id">
               <xsl:value-of select="entries_item/filename"/>
           </xsl:attribute>
            <title>
                <xsl:value-of select="entries_item/file_summary"/>
            </title>
            <xsl:apply-templates select="entries_item"/> 
        </reference>
    </xsl:template>


    <xsl:template match="entries_item">
        <refentry>
                <xsl:attribute name="id">
                    <xsl:value-of select="filename"/>
                    <xsl:text>_</xsl:text>
                    <xsl:choose>
                        <xsl:when test="id != ''">
                            <xsl:value-of select="id"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="names/names_item"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <refmeta>
                    <refentrytitle>
                        <xsl:value-of select="names/names_item"/>
                    </refentrytitle>
                    <manvolnum>3</manvolnum>
                </refmeta>
                <refnamediv>
                    <xsl:for-each select="names/names_item">
                        <refname>
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
                                            <para>
                                                <xsl:value-of select="."/>
                                            </para>
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
