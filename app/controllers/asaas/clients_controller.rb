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
    response = AsaasAPI.get_client(params[:id])
    @client = JSON.parse(response.body)

    respond_to do |format|
      format.html { render 'asaas/clients/show' }
    end
  end
end
