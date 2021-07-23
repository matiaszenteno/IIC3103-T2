class TracksController < ApplicationController
    before_action :get_artist, :get_album, :get_track, only: [:index, :show, :create, :update, :destroy]

    def index
      if params[:artist_id]
        if @artist
          @tracks = @artist.tracks
          my_response = []
          @tracks.each do |track|
            my_response << {name: track.name, 
                            duration: track.duration,
                            times_played: track.times_played,
                            artist: "https://iic3103-music.herokuapp.com/artists/#{track.album.artist.id}",
                            album: "https://iic3103-music.herokuapp.com/albums/#{track.album.id}",
                            self: "https://iic3103-music.herokuapp.com/tracks/#{track.id}",
            }
          end
          render json: my_response.to_json, :status => 200
        else
          render :json => {}, :status => 404
        end
      elsif params[:album_id]
        if @album
          @tracks = @album.tracks
          my_response = []
          @tracks.each do |track|
            my_response << {name: track.name, 
                            duration: track.duration,
                            times_played: track.times_played,
                            artist: "https://iic3103-music.herokuapp.com/artists/#{track.album.artist.id}",
                            album: "https://iic3103-music.herokuapp.com/albums/#{track.album.id}",
                            self: "https://iic3103-music.herokuapp.com/tracks/#{track.id}",
            }
          end
          render json: my_response.to_json, :status => 200
        else
          render :json => {}, :status => 404
        end
      else
        @tracks = Track.all
        my_response = []
        @tracks.each do |track|
          puts 'JIDID'
          puts track.album
          puts 'JADAD'
          my_response << {name: track.name, 
                          duration: track.duration,
                          times_played: track.times_played,
                          artist: "https://iic3103-music.herokuapp.com/artists/#{track.album.artist.id}",
                          album: "https://iic3103-music.herokuapp.com/albums/#{track.album.id}",
                          self: "https://iic3103-music.herokuapp.com/tracks/#{track.id}",
          }
        end
        render json: my_response.to_json, :status => 200
      end
    end

    def show
      if !@artist && !@album && @track
        render :json => {
          name: @track.name, 
          duration: @track.duration,
          times_played: @track.times_played,
          artist: "https://iic3103-music.herokuapp.com/artists/#{@track.album.artist.id}",
          album: "https://iic3103-music.herokuapp.com/albums/#{@track.album.id}",
          self: "https://iic3103-music.herokuapp.com/tracks/#{@track.id}",
        }, :status => 200
      else
        render :json => {}, :status => 404
      end
    end

    def create
      if @album
        if track_params[:name] && track_params[:duration]
          if Track.exists?(id: Base64.strict_encode64("#{track_params[:name]}:#{@album.id}")[0,22])
            @track = Track.find_by(id: Base64.strict_encode64("#{track_params[:name]}:#{@album.id}")[0,22])
            render :json => {
                name: @track.name, 
                duration: @track.duration,
                times_played: @track.times_played,
                artist: "https://iic3103-music.herokuapp.com/artists/#{@track.album.artist.id}",
                album: "https://iic3103-music.herokuapp.com/albums/#{@track.album.id}",
                self: "https://iic3103-music.herokuapp.com/tracks/#{@track.id}",
              }, :status => 409
          else
            @track = @album.tracks.create!(track_params.merge(:id => Base64.strict_encode64("#{track_params[:name]}:#{@album.id}")[0,22]))
            if @track.save
              render :json => {
                name: @track.name, 
                duration: @track.duration,
                times_played: @track.times_played,
                artist: "https://iic3103-music.herokuapp.com/artists/#{@track.album.artist.id}",
                album: "https://iic3103-music.herokuapp.com/albums/#{@track.album.id}",
                self: "https://iic3103-music.herokuapp.com/tracks/#{@track.id}",
              }, :status => 201
            end
          end
        else
          render :json => {}.to_json, :status => 400
        end
      else
        if !@album
          render :json => {}, :status => 422
        end
      end
    end

    def destroy
      if !@artist && !@album && @track 
        @track.destroy
        render :json => {}, :status => 204
      else
        render :json => {}, :status => 404
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
      if params[:album_id]
        if Album.exists?(id: params[:album_id])
          @album = Album.find(params[:album_id]) if params[:album_id]
        else
          @album = nil
        end
      else
        @album = nil
      end
    end

    def get_track
      @track = Track.find(params[:id]) if params[:id]
    end
end