module ChequebotDataModel
	class User
		include DataMapper::Resource
		property :id, String, :required => true, :key => true, :length => 20
		property :followed, Boolean, :default => false
		has n, :mentions
	end
	class Mention
		include DataMapper::Resource
		property :tweetId, Integer, :required => true, :key => true, :min => 0, :max => 2**63
		property :parseable, Boolean
		belongs_to :user, :required => true
		has n, :target, 'User'
	end
end
