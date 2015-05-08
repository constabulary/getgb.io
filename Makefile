all: rsync

build:
	rm -rf public/*
	hugo -t default

rsync: build
	rsync -avz --delete public/* getgb.io:/export/sites/getgb.io/default/htdocs/
