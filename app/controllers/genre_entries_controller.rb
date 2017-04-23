class GenreEntriesController < ApplicationController
  before_action :find_genre_group
  before_action :logged_in_user
  before_action :correct_user

  def create
    GenreEntry.transaction do
      @genre_group = GenreGroup.find( params[ :genre_group_id ] )
      @genre_group.genres << Genre.find_or_create_by!( name: params[ :genre_name ] )
    end
  rescue ActiveRecord::ActiveRecordError
    flash[ :danger ] = "Failed to add genre"
    redirect_to @genre_group
  else
    respond_to do |format|
      format.html { redirect_to @genre_group }
      format.js
    end
  end

  def destroy
    @genre_group.genre_entries.destroy( params[ :id ] ) if @genre_group.genre_entries.exists?( params[ :id ] )
    respond_to do |format|
      format.html { redirect_to @genre_group }
      format.js
    end
  end

  private

    def find_genre_group
      @genre_group = GenreGroup.find( params[ :genre_group_id ] )
    end

    def correct_user
      redirect_to @genre_group unless current_user?( @genre_group.creator ) || admin?
    end

end
