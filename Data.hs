{-# LANGUAGE OverloadedStrings #-}

module Data where

--import Text.JSON
--import Text.JSON.Generic
import Data.Time
import Control.Monad (mzero)
import Data.Aeson --((.:), (.:?), (.=), decode, FromJSON(..), ToJSON(..), Value(..))
--import Control.Applicative ((<$>), (<*>))
import Numeric

data InputRow = InputRow {
  name :: String,
  unit :: String,
  amount :: Rational,
  netPricePerUnit :: Rational,
  vatRate :: Rational
} deriving (Eq, Show)

instance FromJSON InputRow where
  parseJSON (Object v) = do
    name <- (v .: "name")
    unit <- (v .: "unit")
    amount <-  (v .: "amount")
    netPricePerUnit <- (v .: "netPricePerUnit")
    vatRate <- (v .: "vatRate")
    return $ (InputRow name unit amount netPricePerUnit vatRate)
  parseJSON _ = mzero
---------------------------------------------------

data InputInvoiceData = InputInvoiceData {
 issueDate :: Day,
 paymentTime :: Integer,
 inputRows :: [InputRow]
} deriving (Eq, Show)

instance FromJSON InputInvoiceData where
  parseJSON (Object v) = do
    rows <- parseJSON =<< (v .: "rows")
    issueDate <- (v .: "issueDate")
    paymentTime <- (v .: "paymentTime")
    return $ InputInvoiceData (read issueDate) paymentTime rows
  parseJSON _ = mzero
-------------------------------------------------

data OutputRow = OutputRow {
  input :: InputRow,
  netTotalValue :: Rational,
  vat :: Rational,
  grosTotalValue :: Rational
}

instance ToJSON OutputRow where
  toJSON (OutputRow input netTotalValue vat grosTotalValue) = object [
    "name" .= name input,
    "unit" .= unit input,
    "amount" .= amount input,
    "netPricePerUnit" .= netPricePerUnit input,
    "vatRate" .= vatRate input,
    "netTotalValue" .= netTotalValue,
    "vat" .= vat,
    "grosTotalValue" .= grosTotalValue
    ]  
----------------------------------------------

data SummarizeRow = SummarizeRow {
  net  :: Rational,
  svat  :: Rational,
  gross :: Rational
} deriving (Show)

instance ToJSON SummarizeRow where
  toJSON (SummarizeRow net vat gross) = object ["net" .= net, "vat" .= vat, "gross" .= gross]
--------------------------------------------
   
data OutputInvoice = OutputInvoice {
  inputInv  :: InputInvoiceData, --TODO now it must be different than accessor of any other data structure. that's bad
  rows      :: [OutputRow],
  summary   :: SummarizeRow,
  inWords   :: String
}

instance ToJSON OutputInvoice where
  toJSON (OutputInvoice input rows summary inWords) = object [
    "issueDate" .= show (issueDate input),
    "dueDate" .= (show $ addDays (paymentTime input) $ issueDate input),
    "rows" .= rows, "summary" .= summary, "inWords" .= inWords]
