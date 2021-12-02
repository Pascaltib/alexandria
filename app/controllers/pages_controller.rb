class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if current_user.admin == false
      redirect_to batches_path
    end
  end
end
