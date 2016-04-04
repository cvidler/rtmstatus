#!/bin/bash
bash /usr/adlex/bin/rpt_app.sh > /usr/adlex/webapps/ROOT/amdlive.xml
xsltproc /usr/adlex/webapps/ROOT/amdlive.xml > /usr/adlex/webapps/ROOT/amdlive.htm

