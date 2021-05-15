module RackExample
	class Application
		def call(env)
			[200, {'Content-Type' => 'text/plain'}, ["Just some regular text here."]]
		end
	end
end