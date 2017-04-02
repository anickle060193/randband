class AdminController < ApplicationController
  before_action :admin_user
  before_action :store_location

  def home
  end

  def users
    @users = User.page( params[ :page ] ).per( 20 )
    @users.where!( id: params[ :id ] ) if params[ :id ].present?
    @users.where!( "username ILIKE :username", username: "%#{params[ :username ]}%" ) if params[ :username ].present?
    @users.where!( "email ILIKE :email", email: "%#{params[ :email ]}%" ) if params[ :email ].present?
    @users.where!( admin: true ) if params[ :admin ].present?
  end

  def bands
    @bands = Band.page( params[ :page ] ).per( 10 )
    @bands.where!( id: params[ :id ] ) if params[ :id ].present?
    @bands.where!( "name ILIKE :name", name: "%#{params[ :name ]}%" ) if params[ :name ].present?
    @bands.where!( provider: params[ :provider ] ) if params[ :provider ].present?
    @bands.where!( provider_id: params[ :provider_id ] ) if params[ :provider_id ].present?
    @bands.where!( "thumbnail ILIKE :thumbnail", thumbnail: "%#{params[ :thumbnail ]}%" ) if params[ :thumbnail ].present?
    @bands.where!( "external_url ILIKE :external_url", external_url: "%#{params[ :external_url ]}%" ) if params[ :external_url ].present?
    @bands.where!( user: User.where( "username ILIKE :username", username: "%#{params[ :user ]}%" ) ) if params[ :user ].present?
  end

  private

    def admin_user
      redirect_to( root_url ) unless admin?
    end

end
