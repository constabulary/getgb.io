all: rsync

build:
	rm -rf public/*
	hugo -t default

rsync: build
	rsync -avz --delete public/* dave.cheney.net:/export/sites/getgb.io/default/htdocs/
