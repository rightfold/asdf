require 'net/http'

Given('The group name is empty') do
    @group_name = ''
end

When('A group creation attempt is made') do
    Net::HTTP.start('127.0.0.1', 8080) do |http|
        @response = http.request_post(
            '/create-group',
            {:name => @group_name}.to_json,
        )
    end
end

Then('The group creation attempt fails') do
    raise "#{@response.code} #{@response.body}" unless @response.code == '400'
end

Then('The group is not saved') do
    pending
end
