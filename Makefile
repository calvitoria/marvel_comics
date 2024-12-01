
.PHONY: setup config check_env

setup: check_env
	@echo ""
	@echo "============================"
	@echo " Starting Setup Process... "
	@echo "============================"
	@echo ""

	@echo "Checking for .env file..."
	@if [ -f .env ]; then \
		read -p "The .env file already exists. Do you want to update the Marvel API credentials? (Y/N): " choice; \
		if [ "$$choice" = "Y" ] || [ "$$choice" = "y" ]; then \
			make config; \
		else \
			echo "Skipping credential update."; \
		fi \
	fi

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
	@echo " Setting up the Database... "
	@echo "============================"
	@echo ""
	rails db:create db:migrate
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

config:
	@echo ""
	@echo "============================"
	@echo " Running Marvel API Credentials Configuration... "
	@echo "============================"
	@echo ""
	ruby bin/credentials
	@echo ""
	@echo "============================"
	@echo " Marvel API Credentials Updated! "
	@echo "============================"
	@echo ""
