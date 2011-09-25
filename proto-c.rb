require_relative 'lib/member_resource'

connection = MemberResource::ResourceConnection.configure do
  @host =  "http://localhost:3000"
  @resource_entry = "/members"
  @format = :json
end

MemberResource::Member.create connection do
  member do
    add_prop :name => "Bill"
    add_prop :card_num => "1234"
  end
  member do
    add_prop :name => "Ben", :card_num => "9999"
  end
end