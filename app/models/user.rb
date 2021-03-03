# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile , dependent: :destroy
  # 1対1はhas_one
  has_many :articles , dependent: :destroy
  # has_many 1対N
  delegate :age, :gender, to: :profile, allow_nil: true
  # delegate - to ~ ~に-を委任する。 birthdayとかをprofileで設定したやつそのまま使うという宣言
  # allow_nil: true delegateで持ってくるときにぼっち演算子を自動でやってくれる
  has_many :likes , dependent: :destroy
  has_many :favorite_articles, through: :likes ,source: :article


  def has_written?(article)
    articles.exists?(id: article.id)
    # exists?は存在するのかどうかtrue falseで帰ってくる
  end

  def has_liked?(article)
    likes.exists?(article_id: article.id)
  end





  def display_name
    self.email.split('@').first
    # splitは分割してハッシュにするやつ
  end

  def prepare_profile
    profile || build_profile #「または」でさくっっと表現できる
  end


  def avatar_image
    if profile&.avatar&.attached?
      profile.avatar
    else
      'default-avatar.png'
    end
  end

end
