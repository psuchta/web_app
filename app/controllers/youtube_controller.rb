require 'will_paginate'

class YoutubeController < ApplicationController
  def most_popular
    yt = YoutubeVideoClient.new
    yt_response = yt.videos_list('id, snippet, statistics', chart: 'mostpopular', page_token: pagination_params)
    @videos_list = yt_response.items

    @prev_page = yt_response.prev_page_token
    @next_page = yt_response.next_page_token
  end

  def video_comments
    yt = YoutubeVideoClient.new
    yt_response = yt.comment_list('id, snippet', video_id: params[:video_id])

    @comment_list = yt_response.items.map { |thread| thread.snippet.top_level_comment.snippet }

    respond_to do |format|
      format.json { render json: @comment_list, status: :ok }
    end
  end

  private

  def pagination_params
    params[:current_page]
  end
end
