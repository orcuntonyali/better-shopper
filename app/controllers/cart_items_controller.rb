class CartItemsController < ApplicationController
  def new
    @cart_items = []
  end

  def process_audio
    audio_file = params[:audio_file]
    audio_file_path = audio_file.tempfile.path
    transcribed_text = OpenaiService.transcribe(audio_file_path)

    render json: { status: "success", transcribed_text: }
  end

  def process_order
    order_input = params[:order_input]
    processed_order = OpenaiService.process_order(order_input)
    Rails.logger.debug "Debugging processed_order: #{processed_order.inspect}"
    session[:processed_order] = processed_order
    render json: { status: "success", processed_order: }
  end

  def display_cart_items
    processed_order = session[:processed_order]
    service_result = CartService.process_order(processed_order)
    @processed_items = service_result['cheapest_items']
    @not_found_message = service_result['not_found_message']
    Rails.logger.debug "Debugging @processed_items: #{@processed_items.inspect}"
  end

  def show
  end
end
