require_relative '../../../lib/integration/asaas'
class Asaas::PaymentsController < ApplicationController
  include AsaasAPI
  def show
    response = AsaasAPI.get_payment(params[:id])
    @payment = JSON.parse(response.body)

    respond_to do |format|
      format.html { render 'asaas/payments/show' }
    end
  end
end
