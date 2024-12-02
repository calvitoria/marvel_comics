.PHONY: setup config

setup:
	@echo ""
	@echo "============================"
	@echo " Starting Setup Process... "
	@echo "============================"
	@echo ""
	ruby bin/credentials_config
	@echo ""
	@echo "============================"
	@echo " Installing Ruby Gems... "
	@echo "============================"
	@echo ""
	bundle install
	@echo ""

	@echo "============================"
	@echo " Installing npm Packages... "
	@echo "============================"
	@echo ""
	npm install
	@echo ""

	@echo "============================"
	@echo " Precompiling Assets... "
	@echo "============================"
	@echo ""
	rails assets:precompile
	@echo ""

	@echo "============================"
	@echo " Starting Rails Server...."
	@echo "============================="
	@echo ""

	rails server
