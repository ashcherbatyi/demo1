.PHONY: all clean linux arm macos windows

BINARY_NAME=demo
DOCKER_REGISTRY=demouser
IMAGE_TAG=$(DOCKER_REGISTRY)/$(BINARY_NAME)

all: linux arm macos windows

linux:
	GOOS=linux GOARCH=amd64 go build -o $(BINARY_NAME)-linux-amd64
	docker build -t $(IMAGE_TAG):linux-amd64 -f Dockerfile --build-arg BINARY=$(BINARY_NAME)-linux-amd64 .

arm:
	GOOS=linux GOARCH=arm64 go build -o $(BINARY_NAME)-linux-arm64
	docker build -t $(IMAGE_TAG):linux-arm64 -f Dockerfile --build-arg BINARY=$(BINARY_NAME)-linux-arm64 .

macos:
	GOOS=darwin GOARCH=amd64 go build -o $(BINARY_NAME)-darwin-amd64
	docker build -t $(IMAGE_TAG):darwin-amd64 -f Dockerfile --build-arg BINARY=$(BINARY_NAME)-darwin-amd64 .

windows:
	GOOS=windows GOARCH=amd64 go build -o $(BINARY_NAME)-windows-amd64.exe
	docker build -t $(IMAGE_TAG):windows-amd64 -f Dockerfile --build-arg BINARY=$(BINARY_NAME)-windows-amd64.exe .

clean:
	@if [ -f $(BINARY_NAME)-linux-amd64 ]; then rm $(BINARY_NAME)-linux-amd64; fi
	@if [ -f $(BINARY_NAME)-linux-arm64 ]; then rm $(BINARY_NAME)-linux-arm64; fi
	@if [ -f $(BINARY_NAME)-darwin-amd64 ]; then rm $(BINARY_NAME)-darwin-amd64; fi
	@if [ -f $(BINARY_NAME)-windows-amd64.exe ]; then rm $(BINARY_NAME)-windows-amd64.exe; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):linux-amd64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):linux-amd64; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):linux-arm64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):linux-arm64; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):darwin-amd64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):darwin-amd64; fi
	@if [ ! -z "$(shell docker images -q $(IMAGE_TAG):windows-amd64 2> /dev/null)" ]; then docker rmi -f $(IMAGE_TAG):windows-amd64; fi