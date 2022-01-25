class FlickrController < ApplicationController
  def search
    return unless params[:search].present?

    @photos = flick_api.photos.search text: params[:search], extras: 'owner_name, tags, url_m'
  end

  private

  def flick_api
    @flick_api ||= Flickr.new(Rails.application.credentials[:flickr][:api_key],
                              Rails.application.credentials[:flickr][:api_secret])
  end
end
