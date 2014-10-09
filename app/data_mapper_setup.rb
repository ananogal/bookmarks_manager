if  ENV["RACK_ENV"] == 'production'
	DataMapper.setup(:default, "postgres://ggklzykmdeqrlp:6RYY_Y3lrixtQFxeAL22lgeUil@ec2-54-83-33-14.compute-1.amazonaws.com:5432/d8vpnv06bnjei1")
else	
	env = ENV["RACK_ENV"] || "development"
	DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
end

DataMapper.auto_upgrade!
DataMapper.finalize