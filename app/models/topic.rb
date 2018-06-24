class Topic < ActiveRecord::Base
  validates :title, presence: true
  validates :content, presence: true
    validates :frontcover, presence: true
  belongs_to :user
  # CommentモデルのAssociationを設定
    has_many :comments, dependent: :destroy
    mount_uploader :frontcover, FrontcoverUploader


end
