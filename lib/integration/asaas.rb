module AsaasAPI

  def AsaasAPI.get_client id
    AsaasAPI.get_request("customers/#{id}")
  end

  def AsaasAPI.get_clients limit=100
    AsaasAPI.get_request("customers?limit=#{limit}}")
  end

  def AsaasAPI.get_request(url)
    Typhoeus.get("https://www.asaas.com/api/v3/#{url}", headers: { access_token: ENV["ASAAS_API_KEY"] })
  end

end