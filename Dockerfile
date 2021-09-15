FROM golang:latest

WORKDIR /go/src/gribigo
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

