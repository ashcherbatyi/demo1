.PHONY: all clean linux arm macos windows

BINARY_NAME=demo
DOCKER_REGISTRY=demouser
IMAGE_TAG=$(DOCKER_REGISTRY)/$(BINARY_NAME)
GO_DOCKER_IMAGE=quay.io/projectquay/golang:1.20

all: linux arm macos windows

linux:
	docker run --rm -v $(PWD):/go/src/app -w /go/src/app $(GO_DOCKER_IMAGE) \
		go build -buildvcs=false -o $(BINARY_NAME)-linux-amd64

arm:
	docker run --rm -v $(PWD):/go/src/app -w /go/src/app $(GO_DOCKER_IMAGE) \
		env GOOS=linux GOARCH=arm64 go build -buildvcs=false -o $(BINARY_NAME)-linux-arm64

macos:
	docker run --rm -v $(PWD):/go/src/app -w /go/src/app $(GO_DOCKER_IMAGE) \
		env GOOS=darwin GOARCH=amd64 go build -buildvcs=false -o $(BINARY_NAME)-darwin-amd64

windows:
	docker run --rm -v $(PWD):/go/src/app -w /go/src/app $(GO_DOCKER_IMAGE) \
		env GOOS=windows GOARCH=amd64 go build -buildvcs=false -o $(BINARY_NAME)-windows-amd64.exe

image: linux arm macos windows
	docker build -t $(IMAGE_TAG):linux-amd64 --build-arg BINARY=$(BINARY_NAME)-linux-amd64 .
	docker build -t $(IMAGE_TAG):linux-arm64 --build-arg BINARY=$(BINARY_NAME)-linux-arm64 .
	docker build -t $(IMAGE_TAG):darwin-amd64 --build-arg BINARY=$(BINARY_NAME)-darwin-amd64 .
	docker build -t $(IMAGE_TAG):windows-amd64 --build-arg BINARY=$(BINARY_NAME)-windows-amd64.exe .

clean:
	@if [ -f $(BINARY_NAME)-linux-amd64 ]; then rm $(BINARY_NAME)-linux-amd64; fi
	@if [ -f $(BINARY_NAME)-linux-arm64 ]; then rm $(BINARY_NAME)-linux-arm64; fi
	@if [ -f $(BINARY_NAME)-darwin-amd64 ]; then rm $(BINARY_NAME)-darwin-amd64; fi
	@if [ -f $(BINARY_NAME)-windows-amd64.exe ]; then rm $(BINARY_NAME)-windows-amd64.exe; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):linux-amd64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):linux-amd64; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):linux-arm64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):linux-arm64; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):darwin-amd64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):darwin-amd64; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):windows-amd64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):windows-amd64; fi
