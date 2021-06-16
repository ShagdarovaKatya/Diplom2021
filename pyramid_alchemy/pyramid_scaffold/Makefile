#Make sure you're working on a virtual environmant


# venv:
# 	python3 -m venv ./env

# Initializes virtual environment with basic requirements.
prod:
	../bin/activate; \
	pip install -r requirements.txt; \
	cd vue-echodata && yarn build; \
	cd .. ;\
	cp -rf ./vue-echodata/dist/* ./pyramid_scaffold/static ;\
	mv -f ./pyramid_scaffold/static/index.html ./pyramid_scaffold/templates/index.jinja2 ;\
	../bin/pserve production.ini

# Installs development dependencies.
dev:
	../bin/activate; \
	pip3 install -r requirements.txt; \
	pip3 install --upgrade pip setuptools; \
	cd ./vue-echodata && yarn serve & \
	../bin/pserve development.ini --reload; \

# runs tests for your project
# test:
# 	./env/bin/activate; \
# 	pytest; \

# Runs development server.
# This step depends on `make dev`, however dependency is excluded to speed up dev server startup.
# run:
# 	./env/bin/activate; \

# 	webpack-dev-server --inline --hot & gunicorn --paste development.ini --reload

# Builds files for distribution which will be placed in /static/dist
# build:
# 	yarn run build

# Cleans up folder by removing virtual environment, node modules and generated files.
# clean:
# 	yarn clean; \
# 	rm -rf node_modules; \
# 	rm -rf pyramidVue/static/dist; \

