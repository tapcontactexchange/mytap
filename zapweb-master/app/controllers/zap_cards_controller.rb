class ZapCardsController < ApplicationController
  
  def index
    @zap_cards = ZapCard.where(:active => "1", :cardOwner => current_user.to_pointer).all
    @current_card = params[:current_card] || 0
  end

  def show
  end
  
  def add_more_info
    zap_card = ZapCard.find(params[:id])
    more_info = MoreInfo.new(:zapCard => zap_card.to_pointer)
    more_info.image = params[:zap_card][:more_info_file]
    more_info.fileName = more_info.image.original_filename
    more_info.fileTitle = params[:zap_card][:file_title]
    
    more_info.fileType = more_info.image.file_ext
    if more_info.valid?
      more_info.save
      redirect_to zap_cards_path(:current_card => params[:current_card])
    else
      flash[:error] = "Ooops! Please select a file and supply a title to upload a new More Info!"
      redirect_to zap_cards_path(:current_card => params[:current_card])
    end
  end
  
  def remove_more_info
    more_info = MoreInfo.find(params[:more_info])
    # HACK!  Need to force MoreInfo to initialize the image
    # as a ParseFile object -- really should do this in the ParseFile code
    more_info.image
    more_info.destroy
    
    redirect_to zap_cards_path(:current_card => params[:current_card])
  end
end
