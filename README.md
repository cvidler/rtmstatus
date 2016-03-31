# rtmstatus
Provides a simple web view into the current state of AMD processing

Consists of three parts
- bash script `rpt_app.sh`
  - runs queries against the `rcmd` command, and processes the returned data into a XML file.
- web code `xslt.xsl`, `style.css` and `table.js`
  - XML Stylesheet, allows the users browser to convert the XML produced by the script to something user friendly.
	- CSS stylesheet, provides style formatting to converted XML.
	- Javascript code to add client side interactivity to the data tables.
- AMD web service `rtmgate`
  - Uses existing web server on each AMD to server the content to users.


## Installation
Copy `xslt.xsl`, `style.css`, and `table.js` to /usr/adlex/webapps/ROOT/
Copy `rpt_app.sh` to /usr/adlex/bin/

Schedule the script to run regularly with cron for the `compuware` user . e.g.
`* * * * * /usr/adlex/bin/rpt_app.sh > /usr/adlex/webapps/ROOT/amdlive.xml`
	
	
## Usage
Users access the live data via any XML capable browser.

http://amdaddress:9091/amdlive.xml
or
https://amdaddress/amdlive.xml


## Compatablity

DC RUM
- AMD 12.4.1

Browsers
- IE 9/10/11/Edge
- Firefox 38+

**Note:** Currently not working with AMD NG.


## Requirements
- bash
- gawk

## Includes
- Utilising Mark Kruse's javascript toolkit (MIT and GPL license) for table pagination, sorting, filtering.
http://www.javascripttoolbox.com/lib/table/index.php
