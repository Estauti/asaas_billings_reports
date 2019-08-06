require_relative '../../../lib/integration/asaas'
class Asaas::PaymentsController < ApplicationController
  include AsaasAPI
  def show
    response = AsaasAPI.get_payment(params[:id])
    @payment = JSON.parse(response.body)

    value = @payment["originalValue"].nil? ? @payment["value"] : @payment["originalValue"]
    value = '%.2f' % value
    value = value.gsub(".", "")
    value = Money.new(value, "BRL").format
    @payment["reportValue"] = value.gsub(".", ",")

    dateCreated = Date.strptime(@payment["dateCreated"], '%Y-%m-%d')
    @payment["dateCreated"] = dateCreated.strftime("%d/%m/%Y")

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

    value = @payment["originalValue"].nil? ? @payment["value"] : @payment["originalValue"]
    value = '%.2f' % value
    value = value.gsub(".", "")
    value = Money.new(value, "BRL").format
    @payment["reportValue"] = value.gsub(".", ",")

    dateCreated = Date.strptime(@payment["dateCreated"], '%Y-%m-%d')
    @payment["dateCreated"] = dateCreated.strftime("%d/%m/%Y")

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
      disposition: 'attachment'
    })
  end
end
