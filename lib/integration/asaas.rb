module AsaasAPI

  def AsaasAPI.get_client id
    AsaasAPI.get_request("customers/#{id}")
  end

  def AsaasAPI.get_clients limit=100
    AsaasAPI.get_request("customers?limit=#{limit}")
  end

  def AsaasAPI.get_client_payments client_id
    AsaasAPI.get_request("payments?limit=100&customer=#{client_id}&dateCreated[ge]=2019-08-01&dateCreated[le]=2019-08-31")
  end

  def AsaasAPI.get_payment payment_id
    AsaasAPI.get_request("payments/#{payment_id}")
  end

  def AsaasAPI.get_installments installment_id
    response = AsaasAPI.get_request("payments?installment=#{installment_id}")
    JSON.parse(response.body)["data"]
  end

  def AsaasAPI.actual_value payment
    value = payment["originalValue"].nil? ? payment["value"] : payment["originalValue"]
    value = '%.2f' % value
    value = value.gsub(".", "")
    value = Money.new(value, "BRL").format
    value.gsub(".", ",")
  end

  def AsaasAPI.get_request(url)
    Typhoeus.get("https://www.asaas.com/api/v3/#{url}", headers: { access_token: ENV["ASAAS_API_KEY"] })
  end

end