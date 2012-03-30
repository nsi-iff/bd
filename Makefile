all: default_config
	@bundle

default_config:
	@if ! test -f ./config/database.yml; then cp ./config/database.yml.example ./config/database.yml; fi
	@if ! test -f ./config/sam.yml; then cp ./config/sam.yml.example ./config/sam.yml; fi

test:
	@rspec ./spec/
