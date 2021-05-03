class AlbumsController < ApplicationController
    before_action :get_artist, :get_album, :get_track, only: [:index, :show, :create, :update, :destroy]
    
    def index
      if @artist
        @albums = @artist.albums
      else
        @albums = Album.all
      end
      my_response = []
      @albums.each do |album|
        my_response << {id: album.id, 
                        name: album.name, 
                        genre: album.genre,
                        artist: "https://iic3103-music.herokuapp.com/artists/#{album.artist.id}",
                        tracks: "https://iic3103-music.herokuapp.com/albums/#{album.id}/tracks",
                        self: "https://iic3103-music.herokuapp.com/albums/#{album.id}",
        }
      end
  
      render json: my_response.to_json, :status => 200
    end

    def show
      @album = Album.find(params[:id])
      render :json => {
        id: @album.id, 
        name: @album.name, 
        genre: @album.genre,
        artist: "https://iic3103-music.herokuapp.com/artists/#{@album.artist.id}",
        tracks: "https://iic3103-music.herokuapp.com/albums/#{@album.id}/tracks",
        self: "https://iic3103-music.herokuapp.com/albums/#{@album.id}",
      }, :status => 200
    end

    def create
      if @artist && !@album && !@track 
        @album = @artist.albums.create!(album_params.merge(:id => Base64.strict_encode64("#{album_params[:name]}:#{@artist.id}")[0,22]))
        @album.artist_id = @album.artist.id
        if @album.save
          render :json => {
            id: @album.id, 
            name: @album.name, 
            genre: @album.genre,
            artist: "https://iic3103-music.herokuapp.com/artists/#{@album.artist.id}",
            tracks: "https://iic3103-music.herokuapp.com/albums/#{@album.id}/tracks",
            self: "https://iic3103-music.herokuapp.com/albums/#{@album.id}",
          }, :status => 201
        end
      else
        head 405
      end
    end

    def destroy
      if !@artist && @album && !@track 
        @album.destroy
        render :nothing => true, :status => 204
      else
        head 405
      end
    end

    private

    def album_params
      params.permit(:name, :genre)
    end

    def get_artist
      @artist = Artist.find(params[:artist_id]) if params[:artist_id]
    end

    def get_album
      @album = Album.find(params[:id]) if params[:id]
    end

    def get_track
      @track = Track.find(params[:track_id]) if params[:track_id]
    end
end