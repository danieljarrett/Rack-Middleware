require './config/application'
require './lib/quote_retriever.rb'
require './lib/quick_formatter.rb'

use QuickFormatter, true
use QuoteRetriever
run RackExample::Application.new