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

  def pdf
    response = AsaasAPI.get_payment(params[:id])
    @payment = JSON.parse(response.body)

    render({
      pdf: params[:client_name], 
      template: 'asaas/payments/pdf', 
      save_to_file: Rails.root.join('pdfs', "#{params[:client_name]}.pdf"),
      disposition: 'attachment'
    })
  end
end
