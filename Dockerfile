# Build Stage: Build bot using the alpine image, also install doppler in it
FROM golang:1.20-alpine AS builder
RUN apk add --no-cache curl wget gnupg git upx
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=`go env GOHOSTOS` GOARCH=`go env GOHOSTARCH` go build -o out/AlitaGoRobot -ldflags="-w -s" .
RUN upx --brute out/AlitaGoRobot

# Run Stage: Run bot using the bot binary copied from build stage
FROM alpine
COPY --from=builder /app/out/AlitaGoRobot /app/AlitaGoRobot
ENTRYPOINT ["/app/AlitaGoRobot"]

LABEL org.opencontainers.image.authors="Divanshu Chauhan <divkix@divkix.me>"
LABEL org.opencontainers.image.url="https://divkix.me"
LABEL org.opencontainers.image.source="https://github.com/Divkix/Alita_Robot"
LABEL org.opencontainers.image.title="Alita Go Robot"
LABEL org.opencontainers.image.description="Official Alita Go Robot Docker Image"
LABEL org.opencontainers.image.vendor="Divkix"
