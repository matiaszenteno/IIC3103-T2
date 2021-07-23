class AlbumsController < ApplicationController
    before_action :get_artist, :get_album, :get_track, only: [:index, :show, :create, :update, :destroy]
    
    def index
      if params[:artist_id]
        if @artist
          @albums = @artist.albums
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
        else
          render :json => {}, :status => 404
        end
      else
        @albums = Album.all
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
      if @artist
        if album_params[:name] && album_params[:genre]
          if Album.exists?(id: Base64.strict_encode64("#{album_params[:name]}:#{@artist.id}")[0,22])
            @album = Album.find_by(id: Base64.strict_encode64("#{album_params[:name]}:#{@artist.id}")[0,22])
            render :json => {
                id: @album.id, 
                name: @album.name, 
                genre: @album.genre,
                artist: "https://iic3103-music.herokuapp.com/artists/#{@album.artist.id}",
                tracks: "https://iic3103-music.herokuapp.com/albums/#{@album.id}/tracks",
                self: "https://iic3103-music.herokuapp.com/albums/#{@album.id}",
              }, :status => 409
          else
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
          end
        else
          render :json => {}.to_json, :status => 400
        end
      else
        if !@artist
          render :json => {}, :status => 422
        end
      end
    end

    def destroy
      if !@artist && @album && !@track 
        @album.destroy
        render :json => {}, :status => 204
      else
        render :json => {}, :status => 404
      end
    end

    private

    def album_params
      params.permit(:name, :genre)
    end

    def get_artist
      if params[:artist_id]
        if Artist.exists?(id: params[:artist_id])
          @artist = Artist.find(params[:artist_id]) if params[:artist_id]
        else
          @artist = nil
        end
      else
        @artist = nil
      end
    end

    def get_album
      @album = Album.find(params[:id]) if params[:id]
    end

    def get_track
      @track = Track.find(params[:track_id]) if params[:track_id]
    end
end