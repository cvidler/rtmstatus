<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="exsl">
<xsl:import href="charts.xsl" />
<xsl:output method="html" indent="yes"/>
<xsl:template match="/">
<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

<xsl:variable name="pagelen" select="'20'" />

  <html>
  <head>
	<title>AMD Live Data Statistics</title>
	<script src="table.js"></script>
	<link rel="stylesheet" type="text/css" href="style.css"/>
  </head>
  <body>
	<div id="heading">
		<h1>AMD Live Data Statistics</h1>
	</div>

	<div class="tabs">
  
	<!-- loop through each data set in the source XML -->
	<xsl:for-each select="amddata/dataset">
	<!-- generate/process data set -->
	<xsl:variable name="id" select="@id" />
	<xsl:variable name="name" select="@name" />
	<xsl:variable name="processeddata">
		<data>
		<xsl:for-each select="//dataset[@id=$id]/*">
			<entry>
				<name><xsl:value-of select="@srvIP" />:<xsl:value-of select="@srvPort" /></name>
				<client><xsl:value-of select="@cliIP" /></client>
				<ss><xsl:value-of select="@appName" /></ss>
				<sessions>1</sessions>
				<srvbytes><xsl:value-of select="format-number((@srvBytes) div 1048576, '###,##0.00')"/></srvbytes>
				<clibytes><xsl:value-of select="format-number((@cliBytes) div 1048576, '###,##0.00')"/></clibytes>
				<totbytes><xsl:value-of select="format-number((@srvBytes + @cliBytes) div 1048576, '###,##0.00')"/></totbytes>
			</entry>
		</xsl:for-each>
		</data>
		<totals>
			<sessions></sessions>
			<srvbytes><xsl:value-of select="format-number(sum(//dataset[@id=$id]/*/@srvBytes) div 1048576, '###,##0.00')"/></srvbytes>
			<clibytes><xsl:value-of select="format-number(sum(//dataset[@id=$id]/*/@cliBytes) div 1048576, '###,##0.00')"/></clibytes>
			<totbytes><xsl:value-of select="format-number((sum(//dataset[@id=$id]/*/@srvBytes) + sum(//dataset[@id=$id]/*/@cliBytes)) div 1048576, '###,##0.00')"/></totbytes>
		</totals>
	</xsl:variable>

	<!-- create table of data set -->
	<div id="{$id}tab"><a href="#{$id}tab"><xsl:value-of select="$name" /></a>
	  <div>
	  <h2><xsl:value-of select="$name" /></h2>
	  <table><tr><td>
		<xsl:variable name="sortcol"><xsl:choose><xsl:when test="$id='vol'">6</xsl:when>
					<xsl:otherwise>4</xsl:otherwise></xsl:choose></xsl:variable>
	  <table id="{$id}" class="table-autosort:{$sortcol} table-autopage:{$pagelen} table-page-number:{$id}page table-page-count:{$id}pages table-autofilter table-rowcount:{$id}rowscount table-filtered-rowcount:{$id}filteredrows">
		<thead>
			<tr>
				<th class="left big table-sortable:ignorecase table-sortable filterable"><xsl:value-of select="$name" /></th>
				<xsl:if test="$id='vol'"><th class="left big table-sortable:ignorecase table-sortable filterable">Client</th><th class="left big table-sortable:ignorecase table-sortable filterable">Software Service</th></xsl:if>
				<th class="table-sortable:numeric table-sortable">Sessions</th>
				<th class="table-sortable:numeric table-sortable">Server MB</th>
				<th class="table-sortable:numeric table-sortable">Client MB</th>
				<th id="{$id}tb" class="table-sortable:numeric table-sortable">Total MB</th>
			</tr>
			<tr>
				<th class="left"><input name="{$id}namefilter" size="20" title="RegEx filter" onkeyup="Table.filter(this,this)"/></th>
				<xsl:if test="$id='vol'"><th class="left"><input name="{$id}clifilter" size="20" title="RegEx filter" onkeyup="Table.filter(this,this)"/></th><th class="left"><input name="{$id}ssfilter" size="20" title="RegEx filter" onkeyup="Table.filter(this,this)"/></th></xsl:if>
				<th></th><th></th><th></th><th></th>
			</tr>
		</thead>
		<tbody>
		<xsl:for-each select="exsl:node-set($processeddata)/data/entry">
			<tr>
				<td class="left"><xsl:value-of select="name"/></td>
				<xsl:if test="$id='vol'"><td class="left"><xsl:value-of select="client"/></td><td class="left"><xsl:value-of select="ss"/></td></xsl:if>
				<td><xsl:value-of select="sessions"/></td>
				<td><xsl:value-of select="srvbytes"/></td>
				<td><xsl:value-of select="clibytes"/></td>
				<td><xsl:value-of select="totbytes"/></td>
			</tr>
		</xsl:for-each>
		</tbody>
		<tfoot>
			<tr class="total">
				<td class="left">Total</td>
				<xsl:if test="$id='vol'"><td class="left"></td><td class="left"></td></xsl:if>
				<td><xsl:value-of select="( exsl:node-set($processeddata)/totals/sessions )"/></td>
				<td><xsl:value-of select="( exsl:node-set($processeddata)/totals/srvbytes )"/></td>
				<td><xsl:value-of select="( exsl:node-set($processeddata)/totals/clibytes )"/></td>
				<td><xsl:value-of select="( exsl:node-set($processeddata)/totals/totbytes )"/></td>
			</tr>
			<tr>
				<xsl:variable name="numcolspan"><xsl:choose><xsl:when test="$id='vol'">5</xsl:when>
					<xsl:otherwise>3</xsl:otherwise></xsl:choose></xsl:variable>
				<td class="left table-page:previous" style="cursor:pointer;">◄ Previous</td><td colspan="{$numcolspan}" style="text-align:center;">Page <span id="{$id}page"></span> of <span id="{$id}pages"></span> - Rows <span id="{$id}filteredrows"></span> of <span id="{$id}rowscount"></span></td><td class="table-page:next" style="cursor:pointer;">Next ►</td>
			</tr>
		</tfoot>
	  </table>
	  </td><td class="left">
		<!-- create a pie chart of total bytes -->
		<!--
		<xsl:variable name="chart">
		<p>
			<xsl:call-template name="pieChart">
				<xsl:with-param name="xData" select="exsl:node-set($processeddata)/data/entry/name" />
				<xsl:with-param name="yData" select="exsl:node-set($processeddata)/data/entry/totbytes" />
				<xsl:with-param name="width" select="'640px'" />
				<xsl:with-param name="height" select="'250px'" />
				<xsl:with-param name="viewBoxWidth" select="320" />
				<xsl:with-param name="viewBoxHeight" select="125" />
			</xsl:call-template>
		</p>
		<p><xsl:value-of select="@name" /> Total Bytes</p>

		</xsl:variable>
		<xsl:call-template name="removePrefix">
			<xsl:with-param name="data" select="exsl:node-set($chart)/*" />
		</xsl:call-template>
		-->
	  </td></tr></table>
	  </div>
	  </div>
	</xsl:for-each>

	</div>


	<!-- create script to sort each table -->
	<script>
	<xsl:for-each select="amddata/dataset">Table.sort(<xsl:value-of select="@id" />tb);
	</xsl:for-each>
	</script>
	
	<div id="footer">
 		<p><xsl:value-of select="amddata/info/timestamp"/></p>
	</div>

	<script>window.location.hash = "voltab";</script>
	</body>
  </html>

</xsl:template>



<!-- Removes namespace prefix -->
<xsl:template name="removePrefix">
	<xsl:param name="data" />
	<xsl:for-each select="$data">
		<xsl:element name="{local-name()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{local-name()}">
                    <xsl:value-of select="." />
                </xsl:attribute>
			</xsl:for-each>
			<xsl:value-of select="text()" />
			<xsl:call-template name="removePrefix">
				<xsl:with-param name="data" select="exsl:node-set(.)/*" />
			</xsl:call-template>
		</xsl:element>
	</xsl:for-each>
</xsl:template>


</xsl:stylesheet> 
