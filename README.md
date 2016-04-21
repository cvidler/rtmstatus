# rtmstatus
Provides a simple web view into the current state of AMD processing

Consists of three parts
- bash script `rpt_app.sh`
  - runs queries against the `rcmd` command, and processes the returned data into a XML file.
- vash script `rtmstatus.sh`
  - runs `rpt_app.sh` and processes the resulting XML with the XSLT templates to produce a HTML file.
- web code `xslt.xsl`, `charts.xsl`, `piechart.xsl`, `barchart.xsl`, `linechart.xsl`, `common.xsl`, `colours.xml` , `style.css` and `table.js`
  - XML Stylesheets, allows `xslrproc` to convert the XML produced by the script to user friendly HTML.
  - XML, provides a list of contrasting colours to build the charts.
  - CSS stylesheet, provides style formatting to converted XML.
  - Javascript code to add client side interactivity to the data tables.
- AMD web service `rtmgate`
  - Uses existing web server on each AMD to server the content to users.


## Installation
Copy `*.xsl`, `colours.xml`, `style.css`, and `table.js` to /usr/adlex/webapps/ROOT/
Copy `rpt_app.sh` and `rtmstatus.sh` to /usr/adlex/bin/

Create a home directory for the compuware user.

`mkdir -p /home/compuware`

`chown compuware:compuware /home/compuware`

Schedule the script to run regularly with cron for the `compuware` user . e.g.
`* * * * * /bin/bash /usr/adlex/bin/rpt_app.sh > /usr/adlex/webapps/ROOT/amdlive.xml`

Check `rcon` produces output for the following commands.
`lapp`
`lsrv`
`lcli`
`lsess`	
	
## Usage
Users access the live data via any XML capable browser.

http://amdaddress:9091/amdlive.htm
or
https://amdaddress/amdlive.htm


## Compatablity

DC RUM
- AMD 12.4.1, 12.4.2

Browsers
- IE 9/10/11/Edge
- Firefox 38+

**Note:** Currently not working with AMD NG. As it does not provide the utilised rcon commands.


## Requirements
- bash
- gawk
- xsltproc

## Includes
- Utilising Mark Kruse's javascript toolkit (MIT and GPL license) for table pagination, sorting, filtering.
http://www.javascripttoolbox.com/lib/table/index.php
- Utilsing Frankline Francis's XSLT charting toolkit.
http://franklinefrancis.github.com/SvgCharts4Xsl
