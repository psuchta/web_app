class Movie < MoviesRecord
  validates :title, presence: true
  validates :link, presence: true
  validates :rating, presence: true
  validates :year, presence: true
  validates :link, url: true
  validates_associated :genre

  belongs_to :genre
end
