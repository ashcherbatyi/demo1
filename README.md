# Cross-Platform Build and Test Automation

This repository contains a `Makefile` and `Dockerfile` to automate the process of building and testing your code on different platforms and architectures, including Linux, ARM, macOS, and Windows.

## Prerequisites

- Docker installed on your system
- Go programming language installed on your system
- Access to Quay.io account for container registry

## Makefile

The `Makefile` allows you to build your code for different platforms and architectures. It also includes targets for creating Docker images for each platform.

### Build Commands

- `make linux` - Build the code for Linux.
- `make arm` - Build the code for ARM architecture.
- `make macos` - Build the code for macOS.
- `make windows` - Build the code for Windows.

### Docker Build Commands

- `make docker-build-linux` - Build a Docker image for Linux.
- `make docker-build-arm` - Build a Docker image for ARM.
- `make docker-build-macos` - Build a Docker image for macOS.
- `make docker-build-windows` - Build a Docker image for Windows.

### Clean Command

- `make clean` - Remove the build directory and Docker images created during the build process.

## Dockerfile

The `Dockerfile` is used to run the test suite on different platforms and architectures using the base image `quay.io/projectquay/golang:1.20`.

### Example Dockerfile

```Dockerfile
FROM quay.io/projectquay/golang:1.20

ARG BINARY
COPY ${BINARY} /usr/local/bin/myapp
COPY . /app
WORKDIR /app

# Run tests
CMD ["go", "test", "./..."]
```

## Usage

1. **Build for different platforms:**

   ```sh
   make linux
   make arm
   make macos
   make windows
   ```

2. **Build Docker images for different platforms:**

   ```sh
   make docker-build-linux
   make docker-build-arm
   make docker-build-macos
   make docker-build-windows
   ```

3. **Clean the build environment:**

   ```sh
   make clean
   ```

4. **Push Docker images to Quay.io:**

   ```sh
   docker login quay.io

   # Push images
   docker push quay.io/your_username/myapp:linux
   docker push quay.io/your_username/myapp:arm
   docker push quay.io/your_username/myapp:macos
   docker push quay.io/your_username/myapp:windows
   ```


   ```
## Notes

- Ensure you replace `quay.io/your_username` with your actual Quay.io username.
- Customize the `Dockerfile` and `Makefile` as needed to fit your specific build and test requirements.
