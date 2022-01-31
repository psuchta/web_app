# frozen_string_literal: true

module Api
  module Soap
    class MoviesController < ApplicationController
      soap_service namespace: 'urn:WashOut'

      soap_action 'movies_fetch',
                  args: nil,
                  return: { movies: [{ id: :integer,
                                       title: :string,
                                       year: :integer,
                                       rating: :double,
                                       link: :string,
                                       genre_id: :integer }] }
      def movies_fetch
        movies = Movie.all
        render soap: { movies: movies.to_a.map(&:attributes) }
      end

      soap_action 'add_movie',
                  args: { title: :string,
                          year: :integer,
                          rating: :double,
                          link: :string,
                          genreId: :integer },
                  return: nil

      def add_movie
        Movie.create!(
          title: params[:title],
          year: params[:year],
          rating: params[:rating],
          link: params[:link],
          genre_id: params[:genreId].to_i
        )
        render soap: nil
      end

      soap_action 'genres_fetch',
                  args: nil,
                  return: { genres: [{ id: :integer,
                                       name: :string }] }
      def genres_fetch
        genres = Genre.all
        render soap: { genres: genres.to_a.map(&:attributes) }
      end

      soap_action 'get_movie',
                  args: { id: :integer },
                  return: { movie: { id: :integer,
                                     title: :string,
                                     year: :integer,
                                     rating: :double,
                                     link: :string,
                                     genre_id: :integer } }

      def get_movie
        movie = Movie.find(params[:id])
        render soap: { movie: movie.attributes }
      end

      soap_action 'delete_movie',
                  args: { id: :integer },
                  return: nil

      def delete_movie
        Movie.find(params[:id]).destroy!
        render soap: nil
      end

      soap_action 'update_movie',
                  args: { id: :integer,
                          title: :string,
                          year: :integer,
                          rating: :double,
                          link: :string,
                          genreId: :integer },
                  return: nil

      def update_movie
        Movie.find(params[:id]).update!(
          title: params[:title],
          year: params[:year],
          rating: params[:rating],
          link: params[:link],
          genre_id: params[:genreId].to_i
        )
        render soap: nil
      end
    end
  end
end
