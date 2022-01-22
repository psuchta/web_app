require 'rubygems'
gem 'google-api-client', '>0.7'
require 'google/apis'
require 'google/apis/youtube_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'
require 'json'

YOUTUBE_SCOPES = [Google::Apis::YoutubeV3::AUTH_YOUTUBE_READONLY, Google::Apis::YoutubeV3::AUTH_YOUTUBE_FORCE_SSL]

task :create_youtube_credentails do
  redirect_uri = 'http://localhost:3000'
  client_secrets_path = 'google_credentails.json'
  credentails_path = File.join(Dir.home, '.google', 'credentials.yaml')

  FileUtils.mkdir_p(File.dirname(credentails_path))
  # TODO Change to from_hash and use credentials
  client_id = Google::Auth::ClientId.from_file(client_secrets_path)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: credentails_path)

  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, YOUTUBE_SCOPES, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: redirect_uri)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = STDIN.gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: redirect_uri)
  end
  puts credentials.inspect
end
