class QuickFormatter
	def initialize(app, on = false)
		@app = app
		@on = on
	end

	def result(response)
		[IO.read('public/index.html').gsub('placeholder', response[0])]
	end

	def call(env)
		status, headers, response = @app.call(env)
		if @on && headers['Content-Type'].include?('text/plain')
			headers = {'Content-Type' => 'text/html'}
			response = result(response)
		end
		[status, headers, response]
	end
end