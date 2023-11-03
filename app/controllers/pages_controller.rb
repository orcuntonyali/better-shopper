class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home]
  before_action :initialize_markers, only: [:setup]
  before_action :redirect_unauthenticated_user, only: [:home]

  def home
  end

  def setup
    if params && params[:new_address]
      current_user.address = params[:new_address][:title]
      current_user.save
      @markers << {
        lat: current_user.latitude,
        lng: current_user.longitude,
        marker_color: 'blue'
      }
    else
      add_user_marker
    end
    add_nearby_stores_markers
  end

  private

  def initialize_markers
    @markers = []
  end

  def redirect_unauthenticated_user
    redirect_to new_user_session_path unless current_user
  end

  def add_nearby_stores_markers
    return unless current_user

    nearby_stores = Store.near([current_user.latitude, current_user.longitude], current_user.max_distance)
    nearby_stores.each do |store|
      @markers << {
        lat: store.latitude,
        lng: store.longitude,
        info_window_html: render_to_string(partial: "store_popup", locals: { store: }),
        marker_color: 'gray'
      }
    end
  end

  def add_user_marker
    return unless current_user

    @markers << {
      lat: current_user.latitude,
      lng: current_user.longitude,
      info_window_html: render_to_string(partial: "user_popup", locals: { user: current_user }),
      marker_color: 'blue'
    }
  end
end
