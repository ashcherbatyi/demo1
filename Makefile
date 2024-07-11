APP = demo
VERSION = latest
REGISTRY = ashcherbatyi
GO_VERSION = 1.20.5

.PHONY: all clean get linux arm macos windows build image push format login

all: linux arm macos windows

check-go-version:
	@if [ `go version | awk '{print $$3}' | sed 's/go//' | cut -d. -f1-2` \< ${GO_VERSION} ]; then \
		echo "Installing Go ${GO_VERSION}..."; \
		wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz; \
		sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz; \
		export PATH=$PATH:/usr/local/go/bin; \
		echo "Go ${GO_VERSION} installed."; \
	else \
		echo "Go version is up to date."; \
	fi

install-go: check-go-version
	@command -v go >/dev/null 2>&1 || { \
		echo "Go is not installed. Aborting."; \
		exit 1; \
	}

get-deps: install-go
	go get ./...

linux: TARGETOS = linux
linux: TARGETARCH = amd64
linux: login build image push

arm: TARGETOS = linux
arm: TARGETARCH = arm64
arm: login build image push

macos: TARGETOS = darwin
macos: TARGETARCH = amd64
macos: login build image push

windows: TARGETOS = windows
windows: TARGETARCH = amd64
windows: login build image push

build: format get-deps
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o ${APP}-${TARGETOS}-${TARGETARCH}

format: install-go
	go fmt ./...

image: build
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg BINARY=${APP}-${TARGETOS}-${TARGETARCH}

clean:
	@if [ -f ${APP}-linux-amd64 ]; then rm -f ${APP}-linux-amd64; fi
	@if [ -f ${APP}-linux-arm64 ]; then rm -f ${APP}-linux-arm64; fi
	@if [ -f ${APP}-darwin-amd64 ]; then rm -f ${APP}-darwin-amd64; fi
	@if [ -f ${APP}-windows-amd64.exe ]; then rm -f ${APP}-windows-amd64.exe; fi
	@if docker images -q ${REGISTRY}/${APP}:${VERSION}-linux-amd64; then docker rmi -f ${REGISTRY}/${APP}:${VERSION}-linux-amd64; fi
	@if docker images -q ${REGISTRY}/${APP}:${VERSION}-linux-arm64; then docker rmi -f ${REGISTRY}/${APP}:${VERSION}-linux-arm64; fi
	@if docker images -q ${REGISTRY}/${APP}:${VERSION}-darwin-amd64; then docker rmi -f ${REGISTRY}/${APP}:${VERSION}-darwin-amd64; fi
	@if docker images -q ${REGISTRY}/${APP}:${VERSION}-windows-amd64; then docker rmi -f ${REGISTRY}/${APP}:${VERSION}-windows-amd64; fi
