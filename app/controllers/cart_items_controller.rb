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
    render json: { status: "success", processed_order: }
  end

  def show
  end
end
