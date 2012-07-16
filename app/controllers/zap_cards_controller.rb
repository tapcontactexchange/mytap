class ZapCardsController < ApplicationController
  
  def index
    @zap_cards = current_user.zap_cards
    @more_info = {}
    if current_user.proPackagePurchased
      @zap_cards.each do |zcard|
        more_infos = zcard.more_infos
        @more_info[zcard.cardName] = more_infos
      end
    end
  end

  def show
  end
end
