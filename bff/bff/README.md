# Golang GraphQL 

### Install

`go get github.com/99designs/gqlgen`

### Init

`go run github.com/99designs/gqlgen init`

### Generate

`go run github.com/99designs/gqlgen gen`

# Golang gRPC

### Install

```
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
```

### Generate

`protoc --go_out=. --go-grpc_out=. proto/user.proto`