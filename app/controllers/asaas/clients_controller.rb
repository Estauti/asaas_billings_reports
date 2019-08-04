require_relative '../../../lib/integration/asaas'
class Asaas::ClientsController < ApplicationController
 include AsaasAPI

  def index
    response = AsaasAPI.get_clients()
    @clients = JSON.parse(response.body)["data"]

    respond_to do |format|
      format.json { render json: @clients, status: :ok }
      format.html { render 'asaas/clients/index' }
    end
  end

  def show
    client_id = Asaas::Client.find(params[:id]).client_id
    @client = AsaasAPI.get_client(client_id)

    respond_to do |format|
      format.html { render 'asaas/clients/show' }
    end
  end
end
