class GenreGroupsController < ApplicationController
  before_action :find_genre_group, only: [ :edit, :update, :destroy ]
  before_action :logged_in_user, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :correct_user, only: [ :edit, :update, :destroy ]

  def show
    @genre_group = GenreGroup.includes( :genres ).find( params[ :id ] )
  end

  def new
    @genre_group = GenreGroup.new
  end

  def create
    GenreGroup.transaction do
      @genre_group = GenreGroup.new( genre_group_params.except( :genres ) )
      @genre_group.creator = current_user
      @genre_group.save!
      flash[ :success ] = "Genre Group created!"
      redirect_to @genre_group
    end
  rescue ActiveRecord::ActiveRecordError
    render :new
  end

  def edit
  end

  def update
    GenreGroup.transaction do
      @genre_group.update!( genre_group_params.except( :genres ) )
      flash[ :success ] = "Genre Group updated!"
      redirect_to @genre_group
    end
  rescue ActiveRecord::ActiveRecordError
    render :edit
  end

  def destroy
    flash[ :info ] = "Genre Group deleted"
    @genre_group.destroy!
    redirect_to root_path
  end

  private

    def find_genre_group
      @genre_group = GenreGroup.find( params[ :id ] )
    end

    def correct_user
      redirect_to @genre_group unless current_user?( @genre_group.creator ) || admin?
    end

    def genre_group_params
      params.require( :genre_group ).permit( :name, :genres )
    end
end
