require_relative '../../../lib/integration/asaas'
class Asaas::PaymentsController < ApplicationController
  include AsaasAPI
  def show
    response = AsaasAPI.get_payment(params[:id])
    @payment = JSON.parse(response.body)

    @payment["reportValue"] = AsaasAPI.actual_value(@payment)

    dateCreated = Date.strptime(@payment["dateCreated"], '%Y-%m-%d')
    @payment["dateCreated"] = dateCreated.strftime("%d/%m/%Y")

    dueDate = Date.strptime(@payment["dueDate"], '%Y-%m-%d')
    @payment["dueDate"] = dueDate.strftime("%d/%m/%Y")

    response = AsaasAPI.get_client(@payment["customer"])
    @client = JSON.parse(response.body)

    cnpj = CNPJ.new(@client["cpfCnpj"])
    @client["cpfCnpj"] = cnpj.formatted

    response = Typhoeus.get("https://viacep.com.br/ws/#{@client["postalCode"]}/json/", ssl_verifypeer: false)
    @city = response.response_code != 200 ? "N/A" : JSON.parse(response.body)["localidade"]

    @installments_summary = {}
    if @payment["installment"].present?
      @installments_summary["totalValue"] = 0.0

      @installments = AsaasAPI.get_installments(@payment["installment"]).sort_by { |installment| installment["invoiceNumber"] }
      @installments.each do |installment|
        installment["reportValue"] = AsaasAPI.actual_value(installment)

        value = installment["originalValue"].nil? ? installment["value"] : installment["originalValue"]
        @installments_summary["totalValue"] += value.to_f

        dueDate = Date.strptime(installment["dueDate"], '%Y-%m-%d')
        installment["dueDate"] = dueDate.strftime("%d/%m/%Y")
      end

      @installments_summary["totalValue"] = '%.2f' % @installments_summary["totalValue"]
      @installments_summary["totalValue"] = @installments_summary["totalValue"].gsub(".", "")
      @installments_summary["totalValue"] = Money.new(@installments_summary["totalValue"], "BRL").format(
        decimal_mark: ',',
        thousands_separator: '.'
      )

      description_index = @payment["description"].index("ABRAS")
      @installments_summary["description"] = description_index.nil? ? @payment["description"] : @payment["description"][description_index..-1]
    end

    respond_to do |format|
      format.html { render 'asaas/payments/show' }
    end
  end

  def pdf
    response = AsaasAPI.get_payment(params[:id])
    @payment = JSON.parse(response.body)

    @payment["reportValue"] = AsaasAPI.actual_value(@payment)

    dateCreated = Date.strptime(@payment["dateCreated"], '%Y-%m-%d')
    @payment["dateCreated"] = dateCreated.strftime("%d/%m/%Y")

    dueDate = Date.strptime(@payment["dueDate"], '%Y-%m-%d')
    @payment["dueDate"] = dueDate.strftime("%d/%m/%Y")
    
    response = AsaasAPI.get_client(@payment["customer"])
    @client = JSON.parse(response.body)

    cnpj = CNPJ.new(@client["cpfCnpj"])
    @client["cpfCnpj"] = cnpj.formatted

    response = Typhoeus.get("https://viacep.com.br/ws/#{@client["postalCode"]}/json/", ssl_verifypeer: false)
    @city = response.response_code == 400 ? "N/A" : JSON.parse(response.body)["localidade"]

    @installments_summary = {}
    if @payment["installment"].present?
      @installments_summary["totalValue"] = 0.0

      @installments = AsaasAPI.get_installments(@payment["installment"]).sort_by { |installment| installment["invoiceNumber"] }
      @installments.each do |installment|
        installment["reportValue"] = AsaasAPI.actual_value(installment)

        value = installment["originalValue"].nil? ? installment["value"] : installment["originalValue"]
        @installments_summary["totalValue"] += value.to_f

        dueDate = Date.strptime(installment["dueDate"], '%Y-%m-%d')
        installment["dueDate"] = dueDate.strftime("%d/%m/%Y")
      end

      @installments_summary["totalValue"] = '%.2f' % @installments_summary["totalValue"]
      @installments_summary["totalValue"] = @installments_summary["totalValue"].gsub(".", "")
      @installments_summary["totalValue"] = Money.new(@installments_summary["totalValue"], "BRL").format(
        decimal_mark: ',',
        thousands_separator: '.'
      )

      description_index = @payment["description"].index("ABRAS")
      @installments_summary["description"] = description_index.nil? ? @payment["description"] : @payment["description"][description_index..-1]
    end

    render({
      pdf: @client["name"], 
      template: 'asaas/payments/pdf', 
      disposition: 'attachment'
    })
  end
end
