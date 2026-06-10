# Goal:
Create a docker file that builds an image where inkcut is pre-installed

# Starting point:
The following is six years old, but the framework should still be relevant.

https://github.com/d7xdev/docker-pipx/tree/main

Most of the following came from a conversation with Leo (Brave's AI agent)  
I understand 99% of the dockerfile, and 3% of the ci.yml  
```sh
FROM alpine:3 AS builder

# Install build-time dependencies (compilers, headers, dev tools)
RUN apk add --no-cache \
    python3 \
    py3-pip \
    qt5-qtbase-dev \
    qt5-qtsvg-dev \
    py3-pyqt5-dev \
    cups-dev \
    libxml2-dev \
    libxslt-dev \
    build-base

# Install Inkcut into a specific directory (e.g., /opt/inkcut) or global
# Using a virtual environment is recommended for easier copying
RUN python3 -m venv /opt/inkcut-env
ENV PATH="/opt/inkcut-env/bin:$PATH"
RUN pip install --no-cache-dir inkcut   

# Start a fresh stage for the final image
FROM alpine:latest

# Install ONLY runtime dependencies (no compilers or -dev packages)
RUN apk add --no-cache \
    python3 \
    qt5-qtbase \
    qt5-qtsvg \
    py3-pyqt5 \
    cups-libs \
    libxml2 \
    libxslt

# Copy the virtual environment from the builder stage
COPY --from=builder /opt/inkcut-env /opt/inkcut-env

# Set the path to use the copied environment
ENV PATH="/opt/inkcut-env/bin:$PATH"

# Set the entrypoint
ENTRYPOINT ["inkcut"]   
```
.github/workflows/build.yml  
```yml
name: Build and Push Inkcut to GHCR

on:
  push:
    branches: [ "main" ]
    tags: [ "v*.*.*" ]
  pull_request:
    branches: [ "main" ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to the Container registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata (tags, labels)
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha
            type=raw,value=latest,enable=${{ github.ref == format('refs/heads/{0}', 'main') }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max   
```

[brave ask conversation](https://search.brave.com/ask?q=how+to+use+python3+-m+pip+install+to+install+inkcut&conversation=0930117f72aab719f00548526ff5c2fba768#eiNwcSkAlo2BJwrlMJLPYF_O3maXcLXOmiSMAySUZps)  
valid through 2026/06/17  

# Brave ask
how to use python3 -m pip install to install inkcut to alpine:latest

## Installing Inkcut on Alpine Linux

To install Inkcut on `alpine:latest` using `python3 -m pip`, you must first install system-level dependencies that `pip` cannot provide. Alpine uses `musl` libc and `apk` packages, which differ from the `glibc`-based instructions found in standard documentation.

### 1. Install System Dependencies
Inkcut requires Qt bindings (for the GUI), CUPS (for printing), and compilation tools. Run the following `apk` command inside your Alpine container:

```bash
apk add --no-cache python3 py3-pip qt5-qtbase qt5-qtsvg py3-pyqt5 cups-dev libxml2-dev libxslt-dev build-base
```

*   **qt5-qtbase** & **py3-pyqt5**: Provide the necessary Qt5 and PyQt5 bindings.
*   **cups-dev**: Provides the CUPS printing system headers required for compilation.
*   **build-base**: Includes `gcc` and `musl-dev` needed to build Python wheels.

### 2. Install Inkcut via Pip
Once the system libraries are present, use `python3 -m pip` to install the application:

```bash
python3 -m pip install --break-system-packages inkcut
```

*   The `--break-system-packages` flag is often required on modern Alpine/Python versions to allow pip to install packages globally outside of a virtual environment.
*   If you encounter errors regarding `enaml` or `enamlx` (common with newer Python versions), you may need to install specific compatible versions or use a virtual environment:
    ```bash
    python3 -m venv /opt/inkcut
    source /opt/inkcut/bin/activate
    pip install inkcut
    ```

### 3. Running Inkcut
Execute the application directly:
```bash
inkcut
```
*Note: If running in a Docker container, you will need to forward the X11 display (`-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix`) to see the GUI.*

# Question:
what is the advantage of installing pip & pyqt5 with the system package manager instead of 'python3 -m pip install PyQt5'

## Advantages of Using `apk` (System Package Manager) on Alpine

Installing PyQt5 and `pip` via `apk add` (e.g., `py3-pyqt5`, `py3-pip`) instead of `python3 -m pip install` offers critical advantages on Alpine Linux due to its unique architecture:

### 1. Compatibility with `musl` libc
Alpine uses musl libc instead of the standard `glibc` found in most Linux distributions.
*   **Pre-compiled Compatibility**: `apk` packages are compiled specifically against `musl`.
*   **Wheel Incompatibility**: `pip` typically downloads `manylinux` wheels from PyPI, which are built for `glibc`. These wheels **cannot run** on Alpine.
*   **Avoiding Compilation**: If you use `pip`, it will fail to find a compatible wheel and attempt to compile the package from source. This often fails for complex packages like PyQt5 unless you manually install a heavy set of development headers (e.g., `qt5-dev`, `sip-dev`, `build-base`).

### 2. Build Speed and Image Size
*   **Instant Installation**: `apk` installs pre-built binaries instantly.
*   **Compilation Overhead**: Using `pip` forces the container to compile C/C++ extensions locally. For large libraries like Qt, this can increase build time from seconds to **over 20 minutes**.
*   **Dependency Bloat**: To support `pip` compilation, you must install compilers (`gcc`, `g++`) and development headers in your final image or manage complex multi-stage builds. `apk` requires only the runtime libraries.

### 3. System Integration
*   **Dependency Resolution**: `apk` handles system-level dependencies (like specific Qt shared libraries) automatically. `pip` only manages Python dependencies and cannot install the underlying C libraries required by PyQt5.
*   **Stability**: System packages are tested together by the Alpine maintainers, ensuring version compatibility between Python, Qt, and the OS.

# Question:
What line to add to the dockerfile to create a multistage setup, and end with only inkcut and whatever is needed for runtime

## Multistage Dockerfile for Inkcut on Alpine

To create a multistage setup that ends with only the runtime essentials, you must separate the **build dependencies** (compilers, headers) from the **runtime dependencies** (shared libraries).

Add the following lines to your Dockerfile to define the build stage, install Inkcut, and then copy only the necessary artifacts to a clean runtime stage:

### 1. The Build Stage (`AS builder`)
This stage installs heavy tools like `build-base` and `qt5-dev` to compile/install Inkcut.

```dockerfile
FROM alpine:latest AS builder

# Install build-time dependencies (compilers, headers, dev tools)
RUN apk add --no-cache \
    python3 \
    py3-pip \
    qt5-qtbase-dev \
    qt5-qtsvg-dev \
    py3-pyqt5-dev \
    cups-dev \
    libxml2-dev \
    libxslt-dev \
    build-base

# Install Inkcut into a specific directory (e.g., /opt/inkcut) or global
# Using a virtual environment is recommended for easier copying
RUN python3 -m venv /opt/inkcut-env
ENV PATH="/opt/inkcut-env/bin:$PATH"
RUN pip install --no-cache-dir inkcut
```

### 2. The Runtime Stage (Final Image)
This is the critical part: start fresh from `alpine:latest`, install **only** runtime libraries (no `build-base` or `-dev` packages), and copy the installed environment from the builder.

```dockerfile
# Start a fresh stage for the final image
FROM alpine:latest

# Install ONLY runtime dependencies (no compilers or -dev packages)
RUN apk add --no-cache \
    python3 \
    qt5-qtbase \
    qt5-qtsvg \
    py3-pyqt5 \
    cups-libs \
    libxml2 \
    libxslt

# Copy the virtual environment from the builder stage
COPY --from=builder /opt/inkcut-env /opt/inkcut-env

# Set the path to use the copied environment
ENV PATH="/opt/inkcut-env/bin:$PATH"

# Set the entrypoint
ENTRYPOINT ["inkcut"]
```

### Key Advantages of This Approach
*   **Size Reduction**: The final image excludes `gcc`, `g++`, `make`, and header files (`-dev`), which can reduce the image size by **hundreds of megabytes**.
*   **Security**: Removing build tools reduces the attack surface of the final container.
*   **Correct Linking**: By installing the runtime `qt5` and `cups` packages in the final stage, you ensure the shared libraries match the ones Inkcut expects, avoiding `musl` compatibility issues that arise if you simply copy system files from the builder.

# Question
I don't see where the venv is activated, is that not needed here?
---------
You are correct to question the "activation" step, but in the context of a Dockerfile, **you do not need to run the `activate` script**.

The line `ENV PATH="/opt/inkcut-env/bin:$PATH"` in the previous Dockerfile **is** the activation mechanism.

### Why `source .../activate` is not needed (and doesn't work)

1.  **Ephemeral Shells**: In a Dockerfile, every `RUN` instruction executes in a new, temporary shell. If you run `RUN source /opt/inkcut-env/bin/activate`, the environment variables are set only for that specific command line and are **lost** immediately after the command finishes. They do not carry over to the next `RUN` line or the final `CMD`.
2.  **What `activate` Actually Does**: The `activate` script primarily modifies two environment variables:
    *   It prepends the virtual environment's `bin/` directory to the `$PATH`.
    *   It sets the `$VIRTUAL_ENV` variable.
3.  **The Docker Solution**: By explicitly setting `ENV PATH="/opt/inkcut-env/bin:$PATH"`, you permanently modify the environment for **all subsequent layers** in the Docker image (including the final runtime). This achieves the exact same result as `activate` but persists correctly.

### Verification
When the container starts, the `inkcut` command (located in `/opt/inkcut-env/bin/`) will be found first in the `$PATH`, ensuring the correct Python interpreter and libraries are used without needing an interactive activation step.

# Question:
What would the yml github file look like to build & push the image to ghcr
-----------
Here is the complete GitHub Actions workflow file (`.github/workflows/build.yml`) to build your multistage Inkcut image and push it to the GitHub Container Registry (GHCR).

### `.github/workflows/build.yml`

```yaml
name: Build and Push Inkcut to GHCR

on:
  push:
    branches: [ "main" ]
    tags: [ "v*.*.*" ]
  pull_request:
    branches: [ "main" ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to the Container registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata (tags, labels)
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha
            type=raw,value=latest,enable=${{ github.ref == format('refs/heads/{0}', 'main') }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

### Key Configuration Details

*   **Permissions**: The `packages: write` permission is strictly required to push images to GHCR. Without it, the login step will succeed, but the push will fail with a 403 error.
*   **Authentication**: It uses the built-in `${{ secrets.GITHUB_TOKEN }}`, so you do not need to manually create or store a Personal Access Token (PAT) for basic pushing to your own repository.
*   **Tagging Strategy**: The `docker/metadata-action` automatically generates tags based on your git state:
    *   Pushing to `main` creates the `latest` tag.
    *   Creating a tag (e.g., `v1.0.0`) creates a specific versioned image.
    *   Every commit gets a unique `sha` tag for traceability.
*   **Caching**: `cache-from: type=gha` and `cache-to: type=gha` utilize the GitHub Actions cache to speed up subsequent builds by preserving the layers from your multistage Dockerfile.
