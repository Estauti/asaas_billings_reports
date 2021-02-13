require_relative '../../../lib/integration/asaas'
class Asaas::ClientsController < ApplicationController
 include AsaasAPI

  before_action :authenticate_user!
  before_action :update_date_range_filter

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

    response = AsaasAPI.get_client_payments(params[:id], current_user.date_range_filter)
    @payments = JSON.parse(response.body)["data"]

    @date_range_filter = current_user.date_range_filter

    respond_to do |format|
      format.html { render 'asaas/clients/show' }
    end
  end
end
