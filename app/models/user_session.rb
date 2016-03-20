class UserSession
  # In Rails 3
  # include ActiveModel::Validations
  # include ActiveModel::Conversion
  #
  # extend ActiveModel::Naming
  # extend ActiveModel::Translation

  # In Rails 4
  include ActiveModel::Model

  attr_accessor :email, :password

  validates_presence_of :email, :password

  def initialize(session, attributes={})
    @session = session
    @email = attributes[:email]
    @password = attributes[:password]
  end

  def authenticate
    puts @email
    puts @password

    user = User.authenticate(@email, @password)

    puts user
    if user.present?
      store(user)
    else
      errors.add(:base, :invalid_login)
      false
    end
  end

  def store(user)
    @session[:user_id] = user.id
  end

  def persisted?
    false
  end
end