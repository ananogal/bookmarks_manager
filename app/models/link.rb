class Link

	include DataMapper::Resource

	property :id, Serial
	property :title, String
	property :url, String
	has n, :tags, :through => Resource

	validates_presence_of :title, :message => "Title can't be empty"
	validates_presence_of :url, :message => "Url can't be empty"
end