Given('The email address {string} and the password {string}') do |email_address, password|
    @email_address = email_address
    @password = password
end

When('A login attempt is made') do
    Net::HTTP.start('127.0.0.1', 8080) do |http|
        @response = http.request_post(
            '/log-in',
            {:email_address => @email_address,
             :password => @password}.to_json,
        )
    end
end

Then('The login attempt fails') do
    raise "#{@response.code} #{@response.body}" unless @response.code == '401'
end

Then('The login attempt succeeds') do
    raise "#{@response.code} #{@response.body}" unless @response.code == '200'
end
