class Tag

	include DataMapper::Resource

	has n, :links, :through => Resource
	belongs_to :user

	property :id, Serial
	property :text, String

	validates_presence_of :text, :message => "Text can't be empty"

end