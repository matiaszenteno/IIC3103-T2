require "base64"

class ArtistsController < ApplicationController
  before_action :artist_params, only: [:create]

  def index
    @artists = Artist.all
    my_response = []
    @artists.each do |artist|
      my_response << {id: artist.id, 
                      name: artist.name,
                      age: artist.age,
                      albums: "http://127.0.0.1:3000/artists/#{artist.id}/albums",
                      tracks: "http://127.0.0.1:3000/artists/#{artist.id}/tracks",
                      self: "http://127.0.0.1:3000/artists/#{artist.id}"
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
      albums: "http://127.0.0.1:3000/artists/#{@artist.id}/albums",
      tracks: "http://127.0.0.1:3000/artists/#{@artist.id}/tracks",
      self: "http://127.0.0.1:3000/artists/#{@artist.id}",
    }, :status => 200
  end

  def create
    @artist = Artist.new(artist_params)
    @artist.id = Base64.strict_encode64(artist_params[:name])[0,22]
    if @artist.save
      render :json => {
        id: @artist.id, 
        name: @artist.name, 
        age: @artist.age,
        albums: "http://127.0.0.1:3000/artists/#{@artist.id}/albums",
        tracks: "http://127.0.0.1:3000/artists/#{@artist.id}/tracks",
        self: "http://127.0.0.1:3000/artists/#{@artist.id}",
      }, :status => 201
    end
  end

  def update
    @artist = Artist.find(params[:id])
    @artist.update(artist_params)
  end

  def destroy
    if params[:id]
      Artist.find(params[:id]).destroy
      render :nothing => true, :status => 204
    else
      head 405
    end
  end

  private

  def artist_params
    params.permit(:name, :age)
  end

  def as_json(options={})
    puts 'JAASDASD'
    {
      :id => id,
      :name => 'AJAJJA',
    }
  end
end
