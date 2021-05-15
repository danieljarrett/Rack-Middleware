require 'rack'
require './lib/quote_retriever.rb'

class DummyApp
  attr_reader :params

  def call(env)
    @env = env
    @params = Rack::Request.new(env).params
    [200, {'Content-Type' => 'text/html'}, ['OK']]
  end
end

describe QuoteRetriever do
  let(:dummyapp) { DummyApp.new }
  let(:app) { QuoteRetriever.new(dummyapp) }
  let(:quotes) { app.quotes }

  context 'when called with a GET request' do
    let(:request) { Rack::MockRequest.new(app) }
    let(:response) { request.get(get_path, params: get_data) }

    context 'at an arbitrary route' do
      let(:get_path) { '/an/arbitrary/path' }

      context 'with no parameters' do
        let(:get_data) { nil }

        it 'passes the original response' do
          expect(response.body).to eq('OK')
        end

        it 'keeps the original format' do
          expect(response.content_type).to eq('text/html')
        end
      end

      context 'with some parameters' do
        let(:get_data) { {'term' => 'Word'} }

        it 'ignores params in response' do
          expect(response.body).to eq('OK')
          expect(response.content_type).to eq('text/html')
        end

        it 'passes the params unchanged' do
          request.get(get_path, params: get_data)
          expect(dummyapp.params).to eq(get_data)
        end
      end
    end

    context 'at the /quote route' do
      let(:get_path) { '/quote' }

      context 'with no parameters' do
        let(:get_data) { nil }

        it 'responds with a valid quote' do
          expect(quotes.include? response.body).to eq(true)
        end

        it 'responds in text/plain format' do
          expect(response.content_type).to eq('text/plain')
        end
      end

      context 'with valid search term' do
        let(:get_data) { {'term' => 'Kar'} }
        let(:subsample) { quotes.select { |quote| quote.include?('Kar') } }

        it 'returns a valid matched quote' do
          expect(subsample.include? response.body).to eq(true)
          expect(response.content_type).to eq('text/plain')
        end

        it 'stops the request from going' do
          request.get(get_path, params: get_data)
          expect(dummyapp.params).to eq(nil)
        end
      end

      context 'with invalid search term' do
        let(:get_data) { {'term' => 'Jumbo'} }

        it 'returns a try-again message' do
          expect(response.body).to eq('No quotes found. Try again!')
          expect(response.content_type).to eq('text/plain')
        end

        it 'stops the request from going' do
          request.get(get_path, params: get_data)
          expect(dummyapp.params).to eq(nil)
        end
      end

      context 'with invalid parameters' do
        let(:get_data) { nil }

        it 'ignores the invalid parameters' do
          expect(quotes.include? response.body).to eq(true)
          expect(response.content_type).to eq('text/plain')
        end

        it 'passes the params unchanged' do
          request.get(get_path, params: get_data)
          expect(dummyapp.params).to eq(get_data)
        end
      end
    end
  end

  context 'when called with a POST request' do
    let(:request) { Rack::MockRequest.new(app) }
    let(:response) { request.post(post_path, params: post_data) }

    context 'at an arbitrary route' do
      let(:post_path) { '/an/arbitrary/path' }

      context 'with no parameters' do
        let(:post_data) { nil }

        it 'passes the original response' do
          expect(response.body).to eq('OK')
        end

        it 'keeps the original format' do
          expect(response.content_type).to eq('text/html')
        end
      end

      context 'with some parameters' do
        let(:post_data) { {'term' => 'Word'} }

        it 'ignores params in response' do
          expect(response.body).to eq('OK')
          expect(response.content_type).to eq('text/html')
        end

        it 'passes the params unchanged' do
          request.post(post_path, params: post_data)
          expect(dummyapp.params).to eq(post_data)
        end
      end
    end

    context 'at the /quote route' do
      let(:post_path) { '/quote' }

      context 'with no parameters' do
        let(:post_data) { nil }

        it 'responds with a valid quote' do
          expect(quotes.include? response.body).to eq(true)
        end

        it 'responds in text/plain format' do
          expect(response.content_type).to eq('text/plain')
        end
      end

      context 'with valid search term' do
        let(:post_data) { {'term' => 'Kar'} }
        let(:subsample) { quotes.select { |quote| quote.include?('Kar') } }

        it 'returns a valid matched quote' do
          expect(subsample.include? response.body).to eq(true)
          expect(response.content_type).to eq('text/plain')
        end

        it 'stops the request from going' do
          request.post(post_path, params: post_data)
          expect(dummyapp.params).to eq(nil)
        end
      end

      context 'with invalid search term' do
        let(:post_data) { {'term' => 'Jumbo'} }

        it 'returns a try-again message' do
          expect(response.body).to eq('No quotes found. Try again!')
          expect(response.content_type).to eq('text/plain')
        end

        it 'stops the request from going' do
          request.post(post_path, params: post_data)
          expect(dummyapp.params).to eq(nil)
        end
      end

      context 'with invalid parameters' do
        let(:post_data) { nil }

        it 'ignores the invalid parameters' do
          expect(quotes.include? response.body).to eq(true)
          expect(response.content_type).to eq('text/plain')
        end

        it 'passes the params unchanged' do
          request.post(post_path, params: post_data)
          expect(dummyapp.params).to eq(post_data)
        end
      end
    end
  end
end