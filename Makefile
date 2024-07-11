.PHONY: all clean linux arm macos windows image

BINARY_NAME=demo
DOCKER_REGISTRY=demouser
IMAGE_TAG=$(DOCKER_REGISTRY)/$(BINARY_NAME)
GO_DOCKER_IMAGE=quay.io/projectquay/golang:1.20
PROJECT_DIR=$(shell pwd)

all: linux arm macos windows

linux:
	@echo "Building for linux"
	docker run --rm -v $(PROJECT_DIR):/go/src/app -w /go/src/app $(GO_DOCKER_IMAGE) \
		env GOOS=linux GOARCH=amd64 go build -buildvcs=false -o $(BINARY_NAME)-linux-amd64
	docker build -t $(IMAGE_TAG):linux-amd64 --build-arg BINARY=$(BINARY_NAME)-linux-amd64 .

arm:
	@echo "Building for linux arm"
	docker run --rm -v $(PROJECT_DIR):/go/src/app -w /go/src/app $(GO_DOCKER_IMAGE) \
		env GOOS=linux GOARCH=arm64 go build -buildvcs=false -o $(BINARY_NAME)-linux-arm64
	docker build -t $(IMAGE_TAG):linux-arm64 --build-arg BINARY=$(BINARY_NAME)-linux-arm64 .

macos:
	@echo "Building for macos"
	docker run --rm -v $(PROJECT_DIR):/go/src/app -w /go/src/app $(GO_DOCKER_IMAGE) \
		env GOOS=darwin GOARCH=arm64 go build -buildvcs=false -o $(BINARY_NAME)-darwin-arm64
	docker build -t $(IMAGE_TAG):darwin-arm64 --build-arg BINARY=$(BINARY_NAME)-darwin-arm64 .

windows:
	@echo "Building for windows"
	docker run --rm -v $(PROJECT_DIR):/go/src/app -w /go/src/app $(GO_DOCKER_IMAGE) \
		env GOOS=windows GOARCH=amd64 go build -buildvcs=false -o $(BINARY_NAME)-windows-amd64.exe
	docker build -t $(IMAGE_TAG):windows-amd64 --build-arg BINARY=$(BINARY_NAME)-windows-amd64.exe .

image: linux arm macos windows

clean:
	@if [ -f $(BINARY_NAME)-linux-amd64 ]; then rm $(BINARY_NAME)-linux-amd64; fi
	@if [ -f $(BINARY_NAME)-linux-arm64 ]; then rm $(BINARY_NAME)-linux-arm64; fi
	@if [ -f $(BINARY_NAME)-darwin-arm64 ]; then rm $(BINARY_NAME)-darwin-arm64; fi
	@if [ -f $(BINARY_NAME)-windows-amd64.exe ]; then rm $(BINARY_NAME)-windows-amd64.exe; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):linux-amd64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):linux-amd64; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):linux-arm64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):linux-arm64; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):darwin-arm64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):darwin-arm64; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):windows-amd64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):windows-amd64; fi
