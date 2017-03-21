#!/bin/bash

COMPUTED_INVOICE_DATA=`cat invoice-data.json | ./dist/build/invoice/invoice`
TMP_HTML=filled-invoice.html

echo -n 's/scope.data = {}/scope.data = '$COMPUTED_INVOICE_DATA'/'  | sed -f - invoice-template.html > $TMP_HTML
node_modules/phantomjs/lib/phantom/bin/phantomjs render-pdf.js $TMP_HTML > invoice.pdf
rm $TMP_HTML
