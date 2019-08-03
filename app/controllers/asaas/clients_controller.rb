class Asaas::ClientsController < ApplicationController

  def index
    @clients = Asaas::Client.all
    
    respond_to do |format|
      format.json { render json: @clients, status: :ok}
    end
  end

end
