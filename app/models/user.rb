class User < ApplicationRecord 

    has_many :projects, dependent: :destroy
    has_many :memberships, dependent: :destroy
    has_many :member_projects, through: :memberships, source: :project
  
    def create_project(name)
      projects.create(name: name)
    end
  
    def join_project(project)
      member_projects << project
    end
  
    def leave_project(project)
      member_projects.delete(project)
    end

  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,          :omniauthable

         def self.from_omniauth(auth)  
           where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
             user.provider = auth.provider
             user.uid = auth.uid
             user.email = auth.info.email
             user.password = Devise.friendly_token[0,20]
           end
         end
end
