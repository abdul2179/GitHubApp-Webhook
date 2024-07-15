require 'sinatra'
require 'octokit'
require 'json'
require 'dotenv/load'
require 'openssl'
require 'jwt'
require 'faraday'
require 'faraday/middleware'
require 'byebug'

class MyApp < Sinatra::Base
  post '/payload' do
    request.body.rewind
    payload = JSON.parse(request.body.read)

    if payload['action'] == 'opened'
      issue = payload['issue']
      repo = payload['repository']['full_name']
      issue_number = issue['number']
      issue_body = issue['body']

      unless issue_body.match(/Estimate: \d+ days/)
        client = Octokit::Client.new(bearer_token: get_installation_access_token)
        comment = "Please provide an estimate in the format 'Estimate: X days'."
        client.add_comment(repo, issue_number, comment)
      end
    end

    status 200
  end

  helpers do
    def get_installation_access_token
      private_pem = OpenSSL::PKey::RSA.new(ENV['GITHUB_PRIVATE_KEY'])
      payload = {
        iat: Time.now.to_i,
        exp: Time.now.to_i + (10 * 60),
        iss: ENV['GITHUB_APP_IDENTIFIER']
      }

      jwt = JWT.encode(payload, private_pem, 'RS256')
      client = Octokit::Client.new(bearer_token: jwt)

      installation = client.find_app_installations.first

      if installation.nil?
        puts "No GitHub App installations found."
        return nil
      end

      client.create_app_installation_access_token(installation.id)[:token]
    end
  end
end

if __FILE__ == $0
  MyApp.run! port: 4567, bind: '0.0.0.0'
end
