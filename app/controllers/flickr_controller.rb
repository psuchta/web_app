class FlickrController < ApplicationController
  def search
    return unless params[:search].present?

    @photos = flick_api.photos.search(text: params[:search],
                                      extras: 'owner_name, tags, url_m, url_o, views',
                                      page: params_page,
                                      per_page: 10)

    @paginate = Pagination.new(@photos.page, @photos.perpage, @photos.total)
  end

  def show_photo
    @orginal_photo = params[:url_o] ||  params[:url_m]
  end

  private

  def flick_api
    @flick_api ||= Flickr.new(Rails.application.credentials[:flickr][:api_key],
                              Rails.application.credentials[:flickr][:api_secret])
  end

  def params_page
    params[:page] || 1
  end
end
