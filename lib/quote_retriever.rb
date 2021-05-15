class QuoteRetriever
	attr_reader :quotes

	def initialize(app)
		@app = app
		@quotes = IO.readlines('db/rickygervais.txt').map { |line| line.chomp }
	end

	def sample
		quotes.sample
	end

	def search(term)
		subsample = quotes.select { |quote| quote.include?(term) }
		subsample.empty? ? 'No quotes found. Try again!' : subsample.sample
	end

	def call(env)
		req = Rack::Request.new(env)
		term = req.params['term']

		if req.path_info == '/quote'
			quote = term ? search(term) : sample
			[200, {'Content-Type' => 'text/plain'}, [quote]]
		else
			@app.call(env)
		end
	end
end