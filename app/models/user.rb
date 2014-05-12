class User < ActiveRecord::Base

  include Authority::UserAbilities

  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:twitter]

  has_many :page_states
  has_many :comments
  has_many :resources

  # -----------------------------------------------------------

  def self.process_omniauth(auth)

    User.where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      #TODO clean up - easy
      user.skip_confirmation!
      user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"

      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
      user.name = auth.info.nickname
      # user.image = auth.info.image # assuming the user model has an image
    end
  end


  # -----------------------------------------------------------

  def editor?

  end

end
