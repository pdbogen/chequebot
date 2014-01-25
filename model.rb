class User
	include DataMapper::Resource
	property :username, String, :required => true, :key => true, :length => 20
end
