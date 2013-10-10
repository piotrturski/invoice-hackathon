import Data.Time
import Data.Aeson --((.:), (.:?), (.=), decode, FromJSON(..), ToJSON(..), Value(..))
import qualified Data.ByteString.Lazy.UTF8 as BS
import Data.List
import Words
import Data

-- converts json to function's input parameter and then convert result to json
decodeEncode :: (InputInvoiceData -> OutputInvoice) -> String -> String
decodeEncode function json = 
  let Just decodedData = Data.Aeson.decode $ BS.fromString json
    in BS.toString . encode $ function decodedData
    
convertRow :: InputRow -> OutputRow
convertRow inputRow@(InputRow name unit amount netPricePerUnit vatRate) =
  let netTotalValue = netPricePerUnit * amount
      vat = netTotalValue * vatRate / 100
    in
      OutputRow inputRow netTotalValue vat (netTotalValue + vat)

convertInvoice :: InputInvoiceData -> OutputInvoice
convertInvoice inputInvoiceData = 
  let enabledRows = filter ((0 <).amount) $ inputRows inputInvoiceData
      converted = map convertRow enabledRows
      summary = foldl1' sumSummaryRows $ map toSumarizeRow converted
      inWords = toWords . floor $ gross summary
  in OutputInvoice inputInvoiceData converted summary inWords

toSumarizeRow (OutputRow _ net vat gros) = SummarizeRow net vat gros
    
sumSummaryRows (SummarizeRow net1 vat1 gros1) (SummarizeRow net2 vat2 gros2) = SummarizeRow (net1 + net2) (vat1 + vat2) (gros1 + gros2)
  
main = interact $ decodeEncode convertInvoice