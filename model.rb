class Db
	class User
		include DataMapper::Resource
		property :id, String, :required => true, :key => true, :length => 20
	end
end
