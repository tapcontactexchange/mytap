class ZapCardsController < ApplicationController
  
  def index
    @zap_cards = current_user.zap_cards
  end

  def show
  end
  
  def add_more_info
    zap_card = ZapCard.find(params[:id])
    more_info = MoreInfo.new(:zapCard => zap_card.to_pointer)
    more_info.image = params[:zap_card][:more_info_file]
    
    more_info.fileType = more_info.image.content_type
    more_info.fileName = more_info.image.original_filename
    more_info.save
    
    redirect_to zap_cards_path
  end
  
  def remove_more_info
    more_info = MoreInfo.find(params[:more_info])
    more_info.destroy
    
    redirect_to zap_cards_path
  end
end
