require_relative '../../../lib/integration/asaas'
class Asaas::PaymentsController < ApplicationController
  include AsaasAPI
  def show
    response = AsaasAPI.get_payment(params[:id])
    @payment = JSON.parse(response.body)

    value = '%.2f' % @payment["value"]
    value = value.gsub(".", "")
    value = Money.new(value, "BRL").format
    @payment["value"] = value.gsub(".", ",")

    dueDate = Date.strptime(@payment["dueDate"], '%Y-%m-%d')
    @payment["dueDate"] = dueDate.strftime("%d/%m/%Y")

    response = AsaasAPI.get_client(@payment["customer"])
    @client = JSON.parse(response.body)

    cnpj = CNPJ.new(@client["cpfCnpj"])
    @client["cpfCnpj"] = cnpj.formatted

    response = Typhoeus.get("https://viacep.com.br/ws/#{@client["postalCode"]}/json/")
    @city = response.response_code == 400 ? "N/A" : JSON.parse(response.body)["localidade"]

    respond_to do |format|
      format.html { render 'asaas/payments/show' }
    end
  end

  def pdf
    response = AsaasAPI.get_payment(params[:id])
    @payment = JSON.parse(response.body)

    value = '%.2f' % @payment["value"]
    value = value.gsub(".", "")
    value = Money.new(value, "BRL").format
    @payment["value"] = value.gsub(".", ",")

    dueDate = Date.strptime(@payment["dueDate"], '%Y-%m-%d')
    @payment["dueDate"] = dueDate.strftime("%d/%m/%Y")
    
    response = AsaasAPI.get_client(@payment["customer"])
    @client = JSON.parse(response.body)

    cnpj = CNPJ.new(@client["cpfCnpj"])
    @client["cpfCnpj"] = cnpj.formatted

    response = Typhoeus.get("https://viacep.com.br/ws/#{@client["postalCode"]}/json/")
    @city = response.response_code == 400 ? "N/A" : JSON.parse(response.body)["localidade"]

    render({
      pdf: @client["name"], 
      template: 'asaas/payments/pdf', 
      save_to_file: Rails.root.join('pdfs', "#{params[:client_name]}.pdf"),
      disposition: 'attachment'
    })
  end
end
