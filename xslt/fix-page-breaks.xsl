<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    <!-- idendity transform -->
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- every even page break needs to be transformed into a column break  -->
    <xsl:template match="tei:pb[@ed='print'][@n!='']">
        <xsl:variable name="v_page-number">
            <xsl:analyze-string select="@n" regex="._(\d+)$">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:choose>
            <!-- find odd page numbers -->
            <xsl:when test="$v_page-number mod 2">
                <!--<xsl:message terminate="no">
                    <xsl:value-of select="$v_page-number"/><xsl:text> is an odd number</xsl:text>
                </xsl:message>-->
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="n" select="$v_page-number"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <!--<xsl:message terminate="no">
                    <xsl:value-of select="$v_page-number"/><xsl:text> is an even number</xsl:text>
                </xsl:message>-->
                <xsl:element name="cb">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="n" select="$v_page-number"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
