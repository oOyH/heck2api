FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY . .
RUN go mod download
ARG TARGETOS TARGETARCH
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o main ./api

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
RUN chmod +x /root/main
EXPOSE 8801

CMD ["./main"] 
