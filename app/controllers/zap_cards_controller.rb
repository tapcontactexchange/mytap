class ZapCardsController < ApplicationController
  
  def index
    @zap_cards = current_user.zap_cards.find(:include => :more_infos)
  end

  def show
  end
  
  def add_more_info
    zap_card = ZapCard.find(params[:id])
    more_info = zap_card.more_infos.build
    more_info.uploaded_file = params[:zap_card][:more_info_file])
    result = more_info.create_file(more_info_file)
    raise result.inspect
  end
end
