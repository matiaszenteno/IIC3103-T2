class TracksController < ApplicationController
    before_action :get_artist, :get_album, :get_track, only: [:index, :show, :create, :update, :destroy]

    def index
      if @artist && !@album
        @tracks = @artist.tracks
        my_response = []
        @tracks.each do |track|
          my_response << {id: track.id, 
                          name: track.name, 
                          duration: track.duration,
                          artist: "https://iic3103-music.herokuapp.com/artists/#{track.album.artist.id}",
                          album: "https://iic3103-music.herokuapp.com/albums/#{track.album.id}",
                          self: "https://iic3103-music.herokuapp.com/tracks/#{track.id}",
          }
        end

        render json: my_response.to_json, :status => 200
      elsif !@artist && @album
        @tracks = @album.tracks
        my_response = []
        @tracks.each do |track|
          my_response << {id: track.id, 
                          name: track.name, 
                          duration: track.duration,
                          artist: "https://iic3103-music.herokuapp.com/artists/#{track.album.artist.id}",
                          album: "https://iic3103-music.herokuapp.com/albums/#{track.album.id}",
                          self: "https://iic3103-music.herokuapp.com/tracks/#{track.id}",
          }
        end

        render json: my_response.to_json, :status => 200
      elsif !@artist && !@album
        @tracks = Track.all
        my_response = []
        @tracks.each do |track|
          my_response << {id: track.id, 
                          name: track.name, 
                          duration: track.duration,
                          artist: "https://iic3103-music.herokuapp.com/artists/#{track.album.artist.id}",
                          album: "https://iic3103-music.herokuapp.com/albums/#{track.album.id}",
                          self: "https://iic3103-music.herokuapp.com/tracks/#{track.id}",
          }
        end

        render json: my_response.to_json, :status => 200
      else
        head 405
      end
    end

    def show
      if !@artist && !@album && @track
        render :json => {
          id: @track.id, 
          name: @track.name, 
          duration: @track.duration,
          artist: "https://iic3103-music.herokuapp.com/artists/#{@track.album.artist.id}",
          album: "https://iic3103-music.herokuapp.com/albums/#{@track.album.id}",
          self: "https://iic3103-music.herokuapp.com/tracks/#{@track.id}",
        }, :status => 200
      else
        head 405
      end
    end

    def create
      if !@artist && @album && !@track 
        @track = @album.tracks.create!(track_params.merge(:id => Base64.strict_encode64("#{track_params[:name]}:#{@album.id}")[0,22]))
        if @track.save
          render :json => {
            id: @track.id, 
            name: @track.name, 
            duration: @track.duration,
            artist: "https://iic3103-music.herokuapp.com/artists/#{@track.album.artist.id}",
            album: "https://iic3103-music.herokuapp.com/albums/#{@track.album.id}",
            self: "https://iic3103-music.herokuapp.com/tracks/#{@track.id}",
          }, :status => 201
        end
      else
        head 405
      end
    end

    def update
      if @artist && !@album && !@track 
        @track.update(track_params)
      elsif !@artist && @album && !@track
        # TODO
      elsif !@artist && !@album && @track  
        # TODO
      else
        head 405
      end
    end

    def destroy
      if !@artist && !@album && @track 
        @track.destroy
        render :nothing => true, :status => 204
      else
        head 405
      end
    end

    private

    def track_params
      params.permit(:name, :duration)
    end

    def get_artist
      @artist = Artist.find(params[:artist_id]) if params[:artist_id]
    end

    def get_album
      @album = Album.find(params[:album_id]) if params[:album_id]
    end

    def get_track
      @track = Track.find(params[:id]) if params[:id]
    end
end