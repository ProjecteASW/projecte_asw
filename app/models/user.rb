class User < ApplicationRecord 

    has_many :projects, dependent: :destroy
    has_many :memberships, dependent: :destroy
    has_many :member_projects, through: :memberships, source: :project
    has_many :issues, dependent: :destroy
    has_many :watched_issues, dependent: :destroy
    has_many :timeline_events, dependent: :destroy
    has_many :comments, dependent: :destroy
    validates :bio, length: {in: 0..210}
  
    def create_project(name)
      projects.create(name: name)
    end
  
    def join_project(project)
      member_projects << project
    end
  
    def leave_project(project)
      member_projects.delete(project)
    end

    def leave_project(project)
      member_projects.delete(project)
    end

    def watch_issue(issue)
      issues << issue
    end

  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: [:github]

      def self.from_omniauth(access_token)
        data = access_token.info
        user = User.where(email: data['email']).first
      
        # Uncomment the section below if you want users to be created if they don't exist
        unless user
          user = User.create(
                            email: data['email'],
                            password: Devise.friendly_token[0,20],
                            username: data['email'],
                            bio: ''
                            )
        end

        user

    end
end