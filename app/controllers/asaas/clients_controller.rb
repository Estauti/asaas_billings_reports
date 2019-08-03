class Asaas::ClientsController < ApplicationController

  def index
    @clients = Asaas::Client.all

    respond_to do |format|
      format.json { render json: @clients, status: :ok}
      format.html { render "asaas/clients/index"}
    end
  end

end
