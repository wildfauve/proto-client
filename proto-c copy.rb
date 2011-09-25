require_relative 'lib/member_resource'

connection = MemberResource::ResourceConnection.configure do
  @host =  "http://localhost:3000"
  @resource_entry = "/members"
end

MemberResource::Member.create connection do
  member do
    @name = "Bill"
    @card_num = "1234"
  end
  member do
    @name = "John"
    @card_num = "54321"
  end
end