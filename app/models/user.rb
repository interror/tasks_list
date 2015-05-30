class User < ActiveRecord::Base
  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :name, :password, presence: true
  validates_uniqueness_of :name
  validates_format_of :name, with: /\A[a-zA-Z]+\z/
  validates :password, length: { in: 4..16 }


  def self.create_records
    user1 = User.new( name: "Edd", password: '1234' )
    user2 = User.new( name: "Ren", password: '1234' )
    user1.save
    user2.save
  end

end
