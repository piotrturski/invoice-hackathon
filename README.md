# Invoice hackathon

Quick and dirty, simple pdf invoice generator in haskell, phantomjs, angular, bash.

#### Build instructions:

```
cabal configure
cabal build
```
#### Usage:

In main directory place `invoice-data.json` with structure:
```json
{
"issueDate" : "2014-01-31",
"paymentTime" : 22,
"rows":[
  {"amount": 9, "name": "cooking", "unit": "hour", "netPricePerUnit": 8, "vatRate": 23},
  {"amount": 1, "name": "apples", "unit": "kg", "netPricePerUnit": 90, "vatRate": 23}
       ]
}
```
and run `./generate-invoice.sh`

A pdf file will be created in current directory. Rows with <em>"amount": 0</em> will be ignored.

#### Design:

```
---------------------------------
| input: per invoice json file; |
|       in .gitignore           |
---------------------------------    
                 |
                 V
         ----------------------    
         | haskell calculator |
         ----------------------
                    |   
                    | json with computed invoice data
                    |
                    V                
                   -------  one-page angular's app    -------------
                   | sed | -------------------------> | phantomjs | -> output pdf
                   -------                            -------------
                    ^
                    |
              -------------------------------------------
              | html template created with LibreOffice; |
              | with manually added angular bindings;   |
              |               stored in repo            |
              -------------------------------------------                       
```

#### Tested with:

* ghc 7.4.1
* phantomJS 1.9.2

