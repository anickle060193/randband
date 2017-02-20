class BandsController < ApplicationController
  before_action :admin_user, only: [ :edit, :update, :destroy ]

  def index
    if !params[ :search ].blank?
      @bands = Band.where( "name LIKE :search", search: "%#{params[ :search ]}%" )
    else
      @bands = Band.all
    end

    @bands = @bands.order( :name ).paginate( page: params[ :page ], per_page: 12 )
  end

  def show
    @band = Band.find( params[ :id ] )
  end

  def new
    @band = Band.new
  end

  def create
    @band = Band.new( band_params )
    if @band.save
      flash[ :info ] = "Band created!"
      redirect_to @band
    else
      render 'new'
    end
  end

  def edit
    @band = Band.find( params[ :id ] )
  end

  def update
    @band = Band.find( params[ :id ] )
    if @band.update_attributes( band_params )
      flash[ :success ] = "Band updated"
      redirect_to @band
    else
      render 'edit'
    end
  end

  def destroy
    Band.find( params[ :id ] ).destroy
    redirect_to bands_url
  end

  private

    def band_params
      params.require( :band ).permit( :name, :link )
    end

    def admin_user
      @band = Band.find( params[ :id ] )
      redirect_to( @band ) unless admin?
    end


end
