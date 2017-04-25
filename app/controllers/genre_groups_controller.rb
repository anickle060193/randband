class GenreGroupsController < ApplicationController
  before_action :find_genre_group, only: [ :edit, :update, :destroy ]
  before_action :logged_in_user, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :correct_user, only: [ :edit, :update, :destroy ]

  def show
    @genre_group = GenreGroup.includes( :genres ).find( params[ :id ] )
    @genre_names = Genre.for_user( current_user ).order( :name ).pluck( :name ) if logged_in?
  end

  def new
    @genre_group = GenreGroup.new
    get_genres
  end

  def create
    GenreGroup.transaction do
      @genre_group = GenreGroup.new( genre_group_params.except( :genres ) )
      @genre_group.creator = current_user
      @genre_group.save!
      save_genres
      flash[ :success ] = "Genre Group created!"
      redirect_to @genre_group
    end
  rescue ActiveRecord::ActiveRecordError
    get_param_genres
    render :new
  end

  def edit
    get_genres
  end

  def update
    GenreGroup.transaction do
      @genre_group.update!( genre_group_params.except( :genres ) )
      save_genres
      flash[ :success ] = "Genre Group updated!"
      redirect_to @genre_group
    end
  rescue ActiveRecord::ActiveRecordError
    get_param_genres
    render :edit
  end

  def destroy
    flash[ :info ] = "Genre Group deleted"
    @genre_group.destroy!
    redirect_to current_user
  end

  private

    def find_genre_group
      @genre_group = GenreGroup.find( params[ :id ] )
    end

    def get_genres
      @added_genres = @genre_group.genres.order( :name ).pluck( :name )
      @all_genres = Genre.for_user( current_user ).order( :name ).pluck( :name )
    end

    def get_param_genres
      @added_genres = params[ :genres ] || [ ]
      @all_genres = Genre.for_user( current_user ).order( :name ).pluck( :name )
    end

    def correct_user
      redirect_to @genre_group unless current_user?( @genre_group.creator ) || admin?
    end

    def genre_group_params
      params.require( :genre_group ).permit( :name )
    end

    def save_genres
      entered_genres = params[ :genres ] || [ ]

      current_genre_names = @genre_group.genres.pluck( :name )

      @genre_group.genres.destroy( Genre.where( name: current_genre_names - entered_genres ) )

      ( entered_genres - current_genre_names ).each do |genre|
        @genre_group.genres << Genre.find_or_create_by!( name: genre )
      end
    end

end
