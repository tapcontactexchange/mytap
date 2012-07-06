class ZapCardsController < ApplicationController
  
  def index
    @zap_cards = ZapCard.where(:cardOwner => current_user.to_pointer)
    @more_info = {}
    if current_user.proPackagePurchased
      @zap_cards.each do |zcard|
        more_infos = MoreInfo.where(:zapCard => zcard.to_pointer)
        @more_info[zcard.cardName] = more_infos
      end
    end
  end

  def show
  end
end
