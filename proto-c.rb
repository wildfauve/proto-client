require_relative 'lib/member_resource'

connection = MemberResource::ResourceConnection.configure do
  @host =  "http://localhost:3000"
  @resource_entry = "/admin/members"
  @format = :json
end

MemberResource::Member.create connection do
  member do
    add_prop :name => "J3"
    add_prop :card_num => "1234"
    add_prop :email => "email@address.com"
  end
  member do
    add_prop :name => "J4", :card_num => "9999", :email => "email2@address.com"
  end
end