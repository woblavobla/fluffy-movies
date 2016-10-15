class Movie < ActiveRecord::Base
  self.per_page = 15
  has_and_belongs_to_many :users
  has_many :movie_ratings, :dependent => :destroy
  has_many :watched_movies, :dependent => :destroy
  has_many :pictures, :dependent => :destroy
  has_many :movie_update_requests, :dependent => :destroy

  before_save :set_add_date

  validates_uniqueness_of :name, :scope => [:year, :country]
  validates :name, :length => {:minimum => 2}

  attr_accessor :kinopoisk_url

  def self.search(search)
    if search
      where("(name LIKE ?) or (name_ru LIKE ?)", "%#{search}%", "%#{search}%")
    else
      find(:all)
    end
  end

  def set_add_date
    self.add_date = DateTime.now
  end

  def average_score
    if movie_ratings.count > 0
      movie_ratings.average(:rating).ceil(2)
    else
      0.0
    end
  end

  def count_of_watched
    watched_movies.select { |m| m.watched }.count
  end

  def watched_by_user?(user)
    if user == nil
      return false
    end
    watched_movie = watched_movies.where(:user => user).first
    if watched_movie != nil
      watched_movie.watched
    else
      false
    end
  end

  def in_user_watch_list?(user)
    if user == nil
      return false
    end
    movie_to_watch = MovieToWatch.where(:user => user, :movie => self).where('date_of_added is not null').first
    if movie_to_watch != nil
      true
    else
      false
    end
  end

  def have_update_request?
    request = MovieUpdateRequest.where(:movie => self).where.not(:request_time => nil).first
    if request != nil
      true
    else
      false
    end
  end

  def rus_name
    name_ru.blank? ? name : name_ru
  end

  def short_description
    if description != nil
      slice_len = description.length < 140 ? description.length : 140
      "#{description[0..slice_len]}..."
    else
      ""
    end
  end

  def kinopoisk_link
    "https://www.kinopoisk.ru/film/#{kinopoisk_id.to_s}"
  end

  def self.parse_movie(link)
    base_api_url = "http://api.kinopoisk.cf/getFilm?filmID="
    base_image_url = "https://st.kp.yandex.net/images/"
    poster_image_url = "https://st.kp.yandex.net/images/film_big/"
    film_id = link.to_s.scan(/\/([0-9]{1,})/).last.first
    kinopoisk_link = "#{base_api_url}#{film_id}"
    url = URI.parse(kinopoisk_link)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    if res.code != '200'
      nil
    else
      response = JSON.parse res.body
      movie = Movie.new
      movie.kinopoisk_id = response['filmID']
      movie.name = response['nameEN']
      movie.name_ru = response['nameRU']
      if movie.name.blank?
        movie.name = movie.name_ru
      end
      movie.year = response['year']
      movie.country = response['country']
      movie.description = response['description']
      exist_movie = Movie.where(:name => movie.name, :year => movie.year, :country => movie.country).first
      if exist_movie != nil
        return exist_movie
      end
      poster = movie.pictures.new
      poster.set_photo_by_url "#{poster_image_url}#{movie.kinopoisk_id}.jpg"
      for i in (0...5)
        if response['gallery'] != nil
          if response['gallery'][i] != nil
            part_link = response['gallery'][i]['preview'].gsub('sm_', '')
            pic = movie.pictures.new
            pic.set_photo_by_url "#{base_image_url}#{part_link}"
          end
        end
      end
      return movie
    end
  end
end