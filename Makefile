APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := ghcr.io/talweg
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
#linux darwin windows
TARGETARCH=amd64
#amd64 arm64

format:
	gofmt -s -w ./

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/talweg/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

linux:
	$(eval TARGETOS=linux)

macos:
	$(eval TARGETOS=darwin)

windows:
	$(eval TARGETOS=windows)

arm:
	$(eval TARGETARCH=arm64)

amd:
	$(eval TARGETARCH=amd64)