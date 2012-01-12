class Micropost < ActiveRecord::Base

  attr_accessible :content

  validates :content, :presence => true,
                      :length => {:maximum => 140}

  belongs_to :user

  default_scope :order => 'microposts.created_at DESC'

end
