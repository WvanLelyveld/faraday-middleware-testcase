require "rails_helper"
require 'faraday_middleware'

describe 'Json' do
  let(:credit_list) { load_fixture('balances') }

  it 'gets the list of credits' do
    WebMock.stub_request(:get, "http://example.com/test_endpoint").to_return(status: 200, body: credit_list)

    debugger

    response = make_request.body

    expect( response.dig('resultCode') ).to eq 12000
    expect( response.dig('balances').size ).to eq 13
  end

  def load_fixture(filename)
    Rails.root.join("spec/hash_test.json")
  end

  def make_request
    connection.get 'test_endpoint'
  end

  def connection
    Faraday.new('http://example.com') do |f|
      # f.adapter Faraday.default_adapter
      f.request :json
      f.response :json
      # if Rails.env.development?
      #   f.use Faraday::Response::Logger, ::Logger.new($stdout), headers: { request: true, response: true },
      #                                                           bodies:  { request: true, response: true }
      # end
    end
  end
end
