<xsl:stylesheet version="1.0"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:sparql="http://www.w3.org/2001/sw/DataAccess/rf1/result"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/gsearch_solr/islandora_transforms/traverse-graph.xslt"/>


  <xsl:template name="traverse-graph-wrapper">
    <xsl:param name="PID" />
    <xsl:variable name="FULL_PID">info:fedora/<xsl:value-of select="@PID"/></xsl:variable>
    <xsl:variable name="graph">
      <xsl:call-template name="_traverse_graph">
        <xsl:with-param name="to_traverse_in">
          <sparql:result>
            <sparql:obj>
              <!--<xsl:attribute name="uri">info:fedora/<xsl:value-of select="@PID"/></xsl:attribute>-->
              <xsl:attribute name="uri"><xsl:value-of select="$FULL_PID"/></xsl:attribute>
            </sparql:obj>
          </sparql:result>
        </xsl:with-param>
        <xsl:with-param name="query">
          PREFIX fre: &lt;info:fedora/fedora-system:def/relations-external#&gt;
          PREFIX fm: &lt;info:fedora/fedora-system:def/model#&gt;
          SELECT ?obj
          FROM &lt;#ri&gt;
          WHERE {
            {
              ?sub fre:isMemberOfCollection ?obj
            }
            UNION{
              ?sub fre:isMemberOf ?obj
            }
            ?obj fm:state fm:Active .
            ?sub fm:state fm:Active
            FILTER(sameTerm(?sub, &lt;%PID_URI%&gt;))
          }
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <!--<DERP><xsl:copy-of select="$graph"/></DERP>-->
    <xsl:for-each select="xalan:nodeset($graph)//sparql:obj">
      <xsl:if test="@uri != $FULL_PID">
        <field name="ancestor_ms"><xsl:value-of select="@uri"/></field>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
