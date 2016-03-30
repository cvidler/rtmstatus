<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">

  <html>
  <head>
	<title>AMD Live Data Statistics</title>
	<script src="table.js"></script>
	<style>
	th { width: 150px; }
	th.table-sortable { cursor: pointer; }
	th.table-sorted-asc:after { content: " ˅"; }
	th.table-sorted-desc:after { content: " ˄"; }
	td { text-align: right; }
	td.left { text-align: left; }
	tfoot { background-color: lightgray; }
	thead { background-color: lightgray; }
	table { border-collapse: collapse; }
	</style>
  </head>
  <body>

  <h1>AMD Live Data Statistics</h1>
  

  <h2>Software Services</h2>
  <table id="ss" class="table-autosort:4 table-autopage:10 table-page-number:sspage table-page-count:sspages">
	<thead>
    <tr>
	<th class="table-sortable:ignorecase table-sortable">Software Service</th>
	<th class="table-sortable:numeric table-sortable">Sessions</th>
	<th class="table-sortable:numeric table-sortable">Server MB</th>
	<th class="table-sortable:numeric table-sortable">Client MB</th>
	<th class="table-sortable:numeric table-sortable">Total Bytes</th>
    </tr>
	</thead>
	<tbody>
    <xsl:for-each select="amdlive/sslist/ss">
    <tr>
      <td class="left"><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="format-number(sessions, '###,###')"/></td>
      <td><xsl:value-of select="format-number(srvbytes div 1048576, '###,###.00')"/></td>
      <td><xsl:value-of select="format-number(clibytes div 1048576, '###,###.00')"/></td>
      <td><xsl:value-of select="format-number((clibytes + srvbytes) div 1048576, '###,###.00')"/></td>
    </tr>
    </xsl:for-each>
	</tbody>
	<tfoot>
	<tr>
	  <td class="left">Total</td>
	  <td><xsl:value-of select="format-number(sum( amdlive/sslist/ss/sessions ), '###,###')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/sslist/ss/srvbytes ) div 1048576, '###,###.00')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/sslist/ss/clibytes ) div 1048576, '###,###.00')"/></td>
	  <td><xsl:value-of select="format-number((sum( amdlive/sslist/ss/clibytes) + sum( amdlive/sslist/ss/srvbytes )) div 1048576, '###,###.00')"/></td>
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


  
  <h2>Servers</h2>
  <table id="srv" class="table-autosort:3 table-autopage:10 table-page-number:srvpage table-page-count:srvpages">
	<thead>
	<tr>
		<th class="table-sortable:ignorecase">Server</th>
		<th class="table-sortable:numeric">Sessions</th>
		<th class="table-sortable:numeric">Server Bytes</th>
		<th class="table-sortable:numeric">Client Bytes</th>
		<th class="table-sortable:numeric">Total Bytes</th>
	</tr>
	</thead>
	<tbody>
    <xsl:for-each select="amdlive/srvlist/srv">
    <tr>
      <td class="left"><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="format-number(sessions, '###,###')"/></td>
      <td><xsl:value-of select="format-number(srvbytes div 1048576, '###,###.00')"/></td>
      <td><xsl:value-of select="format-number(clibytes div 1048576, '###,###.00')"/></td>
      <td><xsl:value-of select="format-number((clibytes + srvbytes) div 1048576, '###,###.00')"/></td>
    </tr>
    </xsl:for-each>
	</tbody>
	<tfoot>
	<tr>
	  <td class="left">Total</td>
	  <td><xsl:value-of select="format-number(sum( amdlive/srvlist/srv/sessions ), '###,###')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/srvlist/srv/srvbytes ) div 1048576, '###,###.00')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/srvlist/srv/clibytes ) div 1048576, '###,###.00')"/></td>
	  <td><xsl:value-of select="format-number((sum( amdlive/srvlist/srv/clibytes) + sum( amdlive/srvlist/srv/srvbytes )) div 1048576, '###,###.00')"/></td>
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
  

  <h2>Clients</h2>
  <table id="cli" class="table-autosort:2 table-autopage:10 table-page-number:clipage table-page-count:clipages">
	<thead>
	<tr>
		<th class="table-sortable:ignorecase">Client</th>
		<th class="table-sortable:numeric">Sessions</th>
		<th class="table-sortable:numeric">Server Bytes</th>
		<th class="table-sortable:numeric">Client Bytes</th>
		<th class="table-sortable:numeric">Total Bytes</th>
	</tr>
	</thead>
	<tbody>
    <xsl:for-each select="amdlive/clilist/cli">
    <tr>
      <td class="left"><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="format-number(sessions, '###,###')"/></td>
      <td><xsl:value-of select="format-number(srvbytes div 1048576, '###,###.00')"/></td>
      <td><xsl:value-of select="format-number(clibytes div 1048576, '###,###.00')"/></td>
      <td><xsl:value-of select="format-number((clibytes + srvbytes) div 1048576, '###,###.00')"/></td>
    </tr>
    </xsl:for-each>
	</tbody>
	<tfoot>
	<tr>
	  <td class="left">Total</td>
	  <td><xsl:value-of select="format-number(sum( amdlive/clilist/cli/sessions ), '###,###')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/clilist/cli/srvbytes ) div 1048576, '###,###.00')"/></td>
	  <td><xsl:value-of select="format-number(sum( amdlive/clilist/cli/clibytes ) div 1048576, '###,###.00')"/></td>
	  <td><xsl:value-of select="format-number((sum( amdlive/clilist/cli/clibytes) + sum( amdlive/clilist/cli/srvbytes )) div 1048576, '###,###.00')"/></td>
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

  
  <p><xsl:value-of select="amdlive/info/timestamp"/></p>
  
  </body>
  </html>

</xsl:template>

</xsl:stylesheet> 