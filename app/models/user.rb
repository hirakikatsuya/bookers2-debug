class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many:books,dependent: :destroy
  has_many:favorites,dependent: :destroy
  has_many:book_comments,dependent: :destroy

  #自分で決めたテーブル:relationships 参照するモデル:Relatiionship follower_idを1にする
  has_many:relationships,class_name:"Relationship",foreign_key:"follower_id",dependent: :destroy
  # followingsした人を表示するためrelationshipsでfollower_id（1）からfollowed（多）された人を抽出する
  has_many:followings,through: :relationships,source: :followed

  # 自分で決めたテーブル:reverse_ of_relationships 参照するモデル：Relationship followed_idを1にする
  has_many:reverse_of_relationships,class_name:"Relationship",foreign_key:"followed_id",dependent: :destroy
  # followersされた人を表示するためreverse_of_relationshipsでfollowed_id(1)からfollower（多）を抽出する
  has_many:followers,through: :reverse_of_relationships,source: :follower

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction,length:{ maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user_id)
    relationships.create(followed_id:user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id:user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def self.looks(search,word)
    if search == "perfect_match"
      @user = User.where("name LIKE?","#{word}")

    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")

    elsif search == "backward_match"
      @user = User.where("name LIKE","%#{word}")

    elsif search == "partial_match"
      @user = User.where("name LIKE","%#{word}%")

    else
      @user = User.all
    end
  end

end
