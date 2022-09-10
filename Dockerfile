FROM golang:1.19 as builder

WORKDIR /go/src/github.com/Templum/govulncheck-action/
ENV GO111MODULE=on

COPY go.mod go.sum  ./
RUN go mod download

COPY . .

# Statically compile our app for use in a distroless container
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -v -o action .

FROM gcr.io/distroless/static
COPY --from=builder /go/src/github.com/Templum/govulncheck-action/action /action

ENTRYPOINT ["/action"]