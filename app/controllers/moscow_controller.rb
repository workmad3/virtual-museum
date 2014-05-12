class MoscowController < ApplicationController
  expose(:pages) { Page.where(moscow: params[:id])}

end

