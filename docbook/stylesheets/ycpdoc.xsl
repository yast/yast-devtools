<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/> 

    <xsl:template match="/">
        <xsl:apply-templates/> 
    </xsl:template>

    <xsl:template match="intro_html">
    </xsl:template>

    <xsl:template match="files">
        <xsl:apply-templates select="file_item"/>
    </xsl:template>

    <xsl:template match="file_item">
        <xsl:apply-templates select="provides"/>
    </xsl:template>

    <xsl:template match="provides">
            <xsl:if test="count(provides_item) > 0">
                <reference>
                    <xsl:apply-templates select="provides_item"/>
                </reference>
            </xsl:if>
    </xsl:template>

    <xsl:template match="requires">
    </xsl:template>

    <xsl:template match="provides_item">
        <xsl:if test="kind = 'function'">
            <refentry>
                <xsl:attribute name="id">
                    <xsl:text>Module_</xsl:text>
                    <xsl:value-of select="../../requires/name"/>
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="name"/>
                </xsl:attribute>

                <refmeta>
                    <refentrytitle>
                        <xsl:value-of select="../../requires/name"/>
                        <xsl:text>::</xsl:text>
                        <xsl:value-of select="name"/>
                    </refentrytitle>
                    <manvolnum>3</manvolnum>
                </refmeta>
                <refnamediv>
                    <refname>
                        <xsl:value-of select="../../requires/name"/>
                        <xsl:text>::</xsl:text>
                        <xsl:value-of select="name"/>
                        
                    </refname>
                    <refpurpose><xsl:value-of select="body"/></refpurpose>
                </refnamediv>
                <refsynopsisdiv>

                    <funcsynopsis>
                        <funcsynopsisinfo>Import <xsl:value-of select="../../requires/name"/><xsl:text>;</xsl:text></funcsynopsisinfo>
                        <funcprototype>
                            <funcdef>
                                <type>
                                    <xsl:value-of select="type"/>
                                </type>
                                <function>
                                    <xsl:value-of select="../../requires/name"/>
                                    <xsl:text>::</xsl:text>
                                    <xsl:value-of select="name"/>
                                </function>
                            </funcdef>
                                <xsl:apply-templates select="parameters"/>
                        </funcprototype>
                    </funcsynopsis>
                </refsynopsisdiv>
                <refsect1>
                    <title>Parameters</title>
                    <xsl:call-template name="varlist_parameters"/>
                </refsect1>
                <refsect1>
                    <title>Return Value</title>
                    <variablelist>
                        <varlistentry>
                            <term>
                                <type>
                                    <xsl:value-of select="type"/>
                                </type>
                            </term>
                            <listitem>
                                <para>
                                    <xsl:value-of select="return"/>
                                </para>
                            </listitem>
                        </varlistentry>
                    </variablelist>
                </refsect1>
            </refentry>
        </xsl:if>
    </xsl:template>

    <xsl:template name="varlist_parameters">
        <variablelist>
            <xsl:for-each select="parameters/parameters_item">
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
    </xsl:template>

    <xsl:template match="parameters">
      <xsl:for-each select="parameters_item">
       <paramdef>
            <type>
                <xsl:value-of select="type"/>
            </type>
            <parameter>
                <xsl:value-of select="name"/>
            </parameter>
       </paramdef>
      </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
