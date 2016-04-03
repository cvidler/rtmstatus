<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="exsl">
<xsl:import href="charts.xsl" />
<xsl:output method="html"/>
<xsl:template match="/">
<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

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
  

  <div id="ssdiv">
  <h2>Software Services</h2>
  <table><tr><td>
  <table id="ss" class="table-autosort:4 table-autopage:10 table-page-number:sspage table-page-count:sspages">
	<thead>
    <tr>
			<th class="big table-sortable:ignorecase table-sortable filterable">Software Service</th>
			<th class="table-sortable:numeric table-sortable">Sessions</th>
			<th class="table-sortable:numeric table-sortable">Server MB</th>
			<th class="table-sortable:numeric table-sortable">Client MB</th>
			<th id="sstb" class="table-sortable:numeric table-sortable">Total MB</th>
    </tr>
	<tr>
		<th><input name="ssfilter" size="20" title="RegEx filter" onkeyup="Table.filter(this,this)"/></th>
		<th></th>
		<th></th>
		<th></th>
		<th></th>
	</tr>
	</thead>
	<tbody>
    <xsl:for-each select="amdlive/sslist/ss">
    <tr>
      <td class="left"><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="format-number(sessions, '###,##0')"/></td>
      <td><xsl:value-of select="format-number(srvbytes div 1048576, '###,##0.00')"/></td>
      <td><xsl:value-of select="format-number(clibytes div 1048576, '###,##0.00')"/></td>
      <td><xsl:value-of select="format-number((clibytes + srvbytes) div 1048576, '###,##0.00')"/></td>
    </tr>
    </xsl:for-each>
	</tbody>
	<tfoot>
	<tr class="total">
	  <td class="left">Total</td>
	  <td><xsl:value-of select="format-number(sum( amdlive/sslist/ss/sessions ), '###,##0')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/sslist/ss/srvbytes ) div 1048576, '###,##0.00')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/sslist/ss/clibytes ) div 1048576, '###,##0.00')"/></td>
	  <td><xsl:value-of select="format-number((sum( amdlive/sslist/ss/clibytes) + sum( amdlive/sslist/ss/srvbytes )) div 1048576, '###,##0.00')"/></td>
	</tr>
	<tr>
		<td class="left table-page:previous" style="cursor:pointer;">&lt; &lt; Previous</td>
		<td colspan="3" style="text-align:center;">Page <span id="sspage">1</span> of <span id="sspages">1</span></td>
		<td class="table-page:next" style="cursor:pointer;">Next &gt; &gt;</td>
	</tr>
	</tfoot>
  </table>
  <script type="text/javascript">
	function sspager(page) {
		var t = document.getElementById('ss');
		var res;
		if (page=="previous") {
			res=Table.pagePrevious(t);
		}
		else if (page=="next") {
			res=Table.pageNext(t);
		}
		else {
			res=Table.page(t,page);
		}
		var currentPage = res.page+1;
		$('.pagelink').removeClass('currentpage');
		$('#page'+currentPage).addClass('currentpage');
	}
  </script>	
  </td><td>
	<xsl:variable name="data">
	<p>
		<xsl:call-template name="pieChart">
			<xsl:with-param name="xData" select="/amdlive/sslist/ss/name" />
			<xsl:with-param name="yData" select="/amdlive/sslist/ss/sessions" />
			<xsl:with-param name="width" select="'640px'" />
			<xsl:with-param name="height" select="'250px'" />
			<xsl:with-param name="viewBoxWidth" select="320" />
			<xsl:with-param name="viewBoxHeight" select="125" />
		</xsl:call-template>
	</p>
	</xsl:variable>
	<xsl:call-template name="removePrefix">
		<xsl:with-param name="data" select="exsl:node-set($data)/*" />
	</xsl:call-template>
  </td></tr></table>
  </div>

  <div id="srvdiv">
  <h2>Servers</h2>
  <table><tr><td>
  <table id="srv" class="table-autosort:4 table-autopage:10 table-page-number:srvpage table-page-count:srvpages">
	<thead>
	<tr>
		<th class="big table-sortable:ignorecase filterable">Server</th>
		<th class="table-sortable:numeric">Sessions</th>
		<th class="table-sortable:numeric">Server MB</th>
		<th class="table-sortable:numeric">Client MB</th>
		<th id="srvtb" class="table-sortable:numeric">Total MB</th>
	</tr>
		<tr>
			<th><input name="srvfilter" size="20" title="RegEx filter" onkeyup="Table.filter(this,this)"/></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
		</tr>
	</thead>
	<tbody>
    <xsl:for-each select="amdlive/srvlist/srv">
    <tr>
      <td class="left"><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="format-number(sessions, '###,##0')"/></td>
      <td><xsl:value-of select="format-number(srvbytes div 1048576, '###,##0.00')"/></td>
      <td><xsl:value-of select="format-number(clibytes div 1048576, '###,##0.00')"/></td>
      <td><xsl:value-of select="format-number((clibytes + srvbytes) div 1048576, '###,##0.00')"/></td>
    </tr>
    </xsl:for-each>
	</tbody>
	<tfoot>
	<tr class="total">
	  <td class="left">Total</td>
	  <td><xsl:value-of select="format-number(sum( amdlive/srvlist/srv/sessions ), '###,##0')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/srvlist/srv/srvbytes ) div 1048576, '###,##0.00')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/srvlist/srv/clibytes ) div 1048576, '###,##0.00')"/></td>
	  <td><xsl:value-of select="format-number((sum( amdlive/srvlist/srv/clibytes) + sum( amdlive/srvlist/srv/srvbytes )) div 1048576, '###,##0.00')"/></td>
	</tr>
	<tr>
		<td class="left table-page:previous" style="cursor:pointer;">&lt; &lt; Previous</td>
		<td colspan="3" style="text-align:center;">Page <span id="srvpage">1</span> of <span id="srvpages">1</span></td>
		<td class="table-page:next" style="cursor:pointer;">Next &gt; &gt;</td>
	</tr>
	</tfoot>
  </table>
	<script type="text/javascript">
	function srvpager(page) {
		var t = document.getElementById('srv');
		var res;
		if (page=="previous") {
			res=Table.pagePrevious(t);
		}
		else if (page=="next") {
			res=Table.pageNext(t);
		}
		else {
			res=Table.page(t,page);
		}
		var currentPage = res.page+1;
		$('.pagelink').removeClass('currentpage');
		$('#page'+currentPage).addClass('currentpage');
	}
	</script>	
  </td><td>
	<xsl:variable name="data">
	<p>
		<xsl:call-template name="pieChart">
			<xsl:with-param name="xData" select="/amdlive/srvlist/srv/name" />
			<xsl:with-param name="yData" select="/amdlive/srvlist/srv/sessions" />
			<xsl:with-param name="width" select="'640px'" />
			<xsl:with-param name="height" select="'250px'" />
			<xsl:with-param name="viewBoxWidth" select="320" />
			<xsl:with-param name="viewBoxHeight" select="125" />
		</xsl:call-template>
	</p>
	</xsl:variable>
	<xsl:call-template name="removePrefix">
		<xsl:with-param name="data" select="exsl:node-set($data)/*" />
	</xsl:call-template>
  </td></tr></table>
  </div>
	
	<div id="clidiv">
  <h2>Clients</h2>
  <table><tr><td>
  <table id="cli" class="table-autosort:4 table-autopage:10 table-page-number:clipage table-page-count:clipages">
	<thead>
	<tr>
		<th class="big table-sortable:ignorecase filterable">Client</th>
		<th class="table-sortable:numeric">Sessions</th>
		<th class="table-sortable:numeric">Server MB</th>
		<th class="table-sortable:numeric">Client MB</th>
		<th id="clitb" class="table-sortable:numeric">Total MB</th>
	</tr>
		<tr>
			<th><input name="clifilter" size="20" title="RegEx filter" onkeyup="Table.filter(this,this)"/></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
		</tr>
	</thead>
	<tbody>
    <xsl:for-each select="amdlive/clilist/cli">
    <tr>
      <td class="left"><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="format-number(sessions, '###,##0')"/></td>
      <td><xsl:value-of select="format-number(srvbytes div 1048576, '###,##0.00')"/></td>
      <td><xsl:value-of select="format-number(clibytes div 1048576, '###,##0.00')"/></td>
      <td><xsl:value-of select="format-number((clibytes + srvbytes) div 1048576, '###,##0.00')"/></td>
    </tr>
    </xsl:for-each>
	</tbody>
	<tfoot>
	<tr class="total">
	  <td class="left">Total</td>
	  <td><xsl:value-of select="format-number(sum( amdlive/clilist/cli/sessions ), '###,##0')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/clilist/cli/srvbytes ) div 1048576, '###,##0.00')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/clilist/cli/clibytes ) div 1048576, '###,##0.00')"/></td>
	  <td><xsl:value-of select="format-number((sum( amdlive/clilist/cli/clibytes) + sum( amdlive/clilist/cli/srvbytes )) div 1048576, '###,##0.00')"/></td>
	</tr>
	<tr>
		<td class="left table-page:previous" style="cursor:pointer;">&lt; &lt; Previous</td>
		<td colspan="3" style="text-align:center;">Page <span id="clipage">1</span> of <span id="clipages">1</span></td>
		<td class="table-page:next" style="cursor:pointer;">Next &gt; &gt;</td>
	</tr>
	</tfoot>
  </table>
  <script type="text/javascript">
	function clipager(page) {
		var t = document.getElementById('cli');
		var res;
		if (page=="previous") {
			res=Table.pagePrevious(t);
		}
		else if (page=="next") {
			res=Table.pageNext(t);
		}
		else {
			res=Table.page(t,page);
		}
		var currentPage = res.page+1;
		$('.pagelink').removeClass('currentpage');
		$('#page'+currentPage).addClass('currentpage');
	}
	</script>	
  </td><td>
	<xsl:variable name="data">
	<p>
		<xsl:call-template name="pieChart">
			<xsl:with-param name="xData" select="/amdlive/clilist/cli/name" />
			<xsl:with-param name="yData" select="/amdlive/clilist/cli/sessions" />
			<xsl:with-param name="width" select="'640px'" />
			<xsl:with-param name="height" select="'250px'" />
			<xsl:with-param name="viewBoxWidth" select="320" />
			<xsl:with-param name="viewBoxHeight" select="125" />
		</xsl:call-template>
	</p>
	</xsl:variable>
	<xsl:call-template name="removePrefix">
		<xsl:with-param name="data" select="exsl:node-set($data)/*" />
	</xsl:call-template>
  </td></tr></table>
	</div>

	<script>
	Table.sort(sstb);
	Table.sort(srvtb);
	Table.sort(clitb);
	</script>
	
	<div id="footer">
  <p><xsl:value-of select="amdlive/info/timestamp"/></p>
	</div>

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
