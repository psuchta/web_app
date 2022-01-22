# frozen_string_literal: true

require 'google/apis'
require 'google/apis/youtube_v3'

class EmptyYoutubeCredentails < StandardError; end

class YoutubeVideoClient
  APPLICATION_NAME = 'WebApp'.freeze

  def initialize
    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  # for_username: 'GoogleDevelopers'
  def channels_list_by_username(part = 'snippet,contentDetails,statistics', **params)
    @service.list_channels(part, **params)
  end

  # yt.videos_list('id, snippet, statistics', chart:'mostpopular')
  def videos_list(part, **params)
    @service.list_videos(part, **params)
  end

  def comment_list(part, **params)
    @service.list_comment_threads(part, **params)
  end

  private

  def authorize
    credentials = YoutubeAuthorizer.new.call
    raise EmptyYoutubeCredentails if credentials.blank?

    credentials
  end
end
