FROM golang:alpine as build
ARG CLOUDFLARED_VERSION=2022.5.1 \
    TARGETOS \
    TARGETARCH \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH}
RUN apk add --no-cache git build-base && \
    go install golang.org/x/tools/gopls@latest && \
    git clone https://github.com/cloudflare/cloudflared --branch ${CLOUDFLARED_VERSION} /cloudflared && \
    cd /cloudflared && \
    make -j2 cloudflared

FROM alpine
COPY --from=build /cloudflared/cloudflared /usr/local/bin/cloudflared

ENTRYPOINT cloudflared --no-autoupdate tunnel run --token ${token}
