# frozen_string_literal: true

require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'google/apis'
require 'google/apis/youtube_v3'

class EmptyYoutubeCredentails < StandardError; end

class YoutubeAuthorizer
  REDIRECT_URI = 'http://localhost:3000'
  APPLICATION_NAME = 'WebApp'
  CLIENT_SECRETS_PATH = 'google_credentails.json'
  CREDENTIALS_PATH = File.join(Dir.home, '.google', 'credentials.yaml')

  def call(scopes: nil)
    return @credentails if @credentials

    scopes = YOUTUBE_SCOPES if scopes.blank?

    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)

    authorizer = Google::Auth::UserAuthorizer.new(
      client_id, scopes, token_store)
    user_id = 'default'
    @credentails ||= authorizer.get_credentials(user_id)
  end
end
