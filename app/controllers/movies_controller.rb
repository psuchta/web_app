# frozen_string_literal: true

class MoviesController < ApplicationController
  before_action :fetch_genres, only: [:new, :edit]

  def index
    soap_block do
      result = soap_client.call(:movies_fetch).body
      @movies = result.dig(:movies_fetch_response, :movies)
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    soap_block do
      soap_client.call(:add_movie, message: { title: movie_params[:title],
                                         year: movie_params['year(1i)'],
                                         rating: movie_params[:rating],
                                         link: movie_params[:link],
                                         genre_id: movie_params[:genre_id] })
    end
    redirect_to movies_path
  end

  def destroy
    soap_block do
      soap_client.call(:delete_movie, message: { id: params[:id] })
    end

    redirect_to movies_path
  end

  def edit
    soap_block do
      result = soap_client.call(:get_movie, message: { id: params[:id] })
      m = result.body.dig(:get_movie_response, :movie)
      m = m.slice(:id, :title, :year, :rating, :link, :genre_id)
      @movie = Movie.new(m)
    end
  end

  def update
    soap_block do
      soap_client.call(:update_movie, message: { id: params[:id],
                                                 title: movie_params[:title],
                                                 year: movie_params['year(1i)'],
                                                 rating: movie_params[:rating],
                                                 link: movie_params[:link],
                                                 genre_id: movie_params[:genre_id] })
    end

    redirect_to movies_path
  end

  private

  def soap_block(&block)
    begin
      block.call
    rescue Savon::HTTPError
      raise SoapError
    end
  end

  def fetch_genres
    result = soap_client.call(:genres_fetch).body
    @genres = result.dig(:genres_fetch_response, :genres)
  end

  def soap_client
    @soap_client ||= Savon::Client.new(wsdl: 'http://localhost:3000/api/soap/movies/wsdl')
  end

  def movie_params
    params.require(:movie).permit(:title, :year, :rating, :link, :genre_id)
  end
end
