.DEFAULT_GOAL := serve_local

build:
	docker build -t slowdev-docs .

serve_local: build
	docker run --rm -it -p 8080:80 slowdev-docs
