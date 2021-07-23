require "base64"

class ArtistsController < ApplicationController
  before_action :artist_params, only: [:create]
  before_action :get_artist, only: [:destroy]

  def index
    @artists = Artist.all
    my_response = []
    @artists.each do |artist|
      my_response << {id: artist.id, 
                      name: artist.name,
                      age: artist.age,
                      albums: "https://iic3103-music.herokuapp.com/artists/#{artist.id}/albums",
                      tracks: "https://iic3103-music.herokuapp.com/artists/#{artist.id}/tracks",
                      self: "https://iic3103-music.herokuapp.com/artists/#{artist.id}"
      }
    end
    render json: my_response.to_json, :status => 200
  end

  def show
    @artist = Artist.find(params[:id])
    render :json => {
      id: @artist.id, 
      name: @artist.name, 
      age: @artist.age,
      albums: "https://iic3103-music.herokuapp.com/artists/#{@artist.id}/albums",
      tracks: "https://iic3103-music.herokuapp.com/artists/#{@artist.id}/tracks",
      self: "https://iic3103-music.herokuapp.com/artists/#{@artist.id}",
    }, :status => 200
  end

  def create
    if artist_params[:name] && artist_params[:age]
      if Artist.exists?(name: artist_params[:name])
        @artist = Artist.find_by(name: artist_params[:name])
        render :json => {
            id: @artist.id, 
            name: @artist.name, 
            age: @artist.age,
            albums: "https://iic3103-music.herokuapp.com/artists/#{@artist.id}/albums",
            tracks: "https://iic3103-music.herokuapp.com/artists/#{@artist.id}/tracks",
            self: "https://iic3103-music.herokuapp.com/artists/#{@artist.id}",
          }, :status => 409
      else
        @artist = Artist.new(artist_params)
        @artist.id = Base64.strict_encode64(artist_params[:name])[0,22]
        if @artist.save
          render :json => {
            id: @artist.id, 
            name: @artist.name, 
            age: @artist.age,
            albums: "https://iic3103-music.herokuapp.com/artists/#{@artist.id}/albums",
            tracks: "https://iic3103-music.herokuapp.com/artists/#{@artist.id}/tracks",
            self: "https://iic3103-music.herokuapp.com/artists/#{@artist.id}",
          }, :status => 201
        end
      end
    else
      render :json => {}.to_json, :status => 400
    end
  end

  def destroy
    if @artist && !@album && !@track 
      @artist.destroy
      render :json => {}, :status => 204
    else
      render :json => {}, :status => 404
    end
  end

  private

  def get_artist
    if params[:id]
      if Artist.exists?(id: params[:id])
        @artist = Artist.find(params[:id]) if params[:id]
      else
        @artist = nil
      end
    else
      @artist = nil
    end
  end

  def artist_params
    params.permit(:name, :age)
  end
end
