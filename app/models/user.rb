class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    'Anonymus'
  end

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def self.search(param)
    search_result = (first_name_search(param) + last_name_search(param) + email_search(param)).uniq
    return nill unless search_result
    search_result 
  end

  def self.first_name_search(param)
    matches("first_name",param)
  end

  def self.last_name_search(param)
    matches("last_name",param)
  end

  def self.email_search(param)
    matches("email",param)
  end

  def self.matches(field_name, field_value)
    where("#{field_name} like ?", "%#{field_value}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id==self.id }
  end

  def already_friend?(friend)
    self.friends.where(id: friend.id).exists?
  end

end
