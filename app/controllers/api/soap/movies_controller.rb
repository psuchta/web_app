# frozen_string_literal: true

module Api
  module Soap
    class MoviesController < ApplicationController
      soap_service namespace: 'urn:WashOut'

      soap_action 'movies_fetch',
                  args: nil,
                  return: [{ id: :integer,
                             title: :string,
                             year: :integer,
                             rating: :double,
                             link: :string,
                             genre_id: :integer }]
      def movies_fetch
        movies = Movie.all
        render soap: movies.to_a.map(&:attributes)
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
    end
  end
end
