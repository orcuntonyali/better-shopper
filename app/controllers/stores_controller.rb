class StoresController < ApplicationController
  def index
    @stores = Store.all
    @markers = @stores.geocoded.map do |store|
      {
        lat: store.latitude,
        lng: store.longitude,
        info_window_html: render_to_string(partial: "popup", locals: { store: })
      }
    end
  end
end
