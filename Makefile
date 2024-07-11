APP_NAME=demo

QUAY_REPO=quay.io/your_username
LINUX_IMAGE_TAG=$(QUAY_REPO)/$(APP_NAME):linux
ARM_IMAGE_TAG=$(QUAY_REPO)/$(APP_NAME):arm
MACOS_IMAGE_TAG=$(QUAY_REPO)/$(APP_NAME):macos
WINDOWS_IMAGE_TAG=$(QUAY_REPO)/$(APP_NAME):windows

BUILD_DIR=build

.PHONY: all clean linux arm macos windows docker-build-linux docker-build-arm docker-build-macos docker-build-windows

all: linux arm macos windows

clean:
	rm -rf $(BUILD_DIR)
	- docker rmi -f $(LINUX_IMAGE_TAG) || true
	- docker rmi -f $(ARM_IMAGE_TAG) || true
	- docker rmi -f $(MACOS_IMAGE_TAG) || true
	- docker rmi -f $(WINDOWS_IMAGE_TAG) || true

linux:
	mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=amd64 go build -o $(BUILD_DIR)/$(APP_NAME)-linux

arm:
	mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=arm64 go build -o $(BUILD_DIR)/$(APP_NAME)-arm

macos:
	mkdir -p $(BUILD_DIR)
	GOOS=darwin GOARCH=amd64 go build -o $(BUILD_DIR)/$(APP_NAME)-macos

windows:
	mkdir -p $(BUILD_DIR)
	GOOS=windows GOARCH=amd64 go build -o $(BUILD_DIR)/$(APP_NAME)-windows.exe

docker-build-linux: linux
	docker build -t $(LINUX_IMAGE_TAG) --build-arg BINARY=$(BUILD_DIR)/$(APP_NAME)-linux .

docker-build-arm: arm
	docker build -t $(ARM_IMAGE_TAG) --build-arg BINARY=$(BUILD_DIR)/$(APP_NAME)-arm .

docker-build-macos: macos
	docker build -t $(MACOS_IMAGE_TAG) --build-arg BINARY=$(BUILD_DIR)/$(APP_NAME)-macos .

docker-build-windows: windows
	docker build -t $(WINDOWS_IMAGE_TAG) --build-arg BINARY=$(BUILD_DIR)/$(APP_NAME)-windows.exe .
