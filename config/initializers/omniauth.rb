Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter, '4aoAvVdwkNNSA9QsjiWw', 'epZ6d87qsFskmstjpueeWBxyKZLG1UFF20vefmAplQ'
	provider :facebook, '436165429817452', '5fda8ab241c136f75b79fe99fd62e4b2'
end