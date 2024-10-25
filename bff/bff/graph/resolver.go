package graph

import (
	"bff/graph/model"
	"sync"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Resolver struct {
	todos       []*model.Todo
	subscribers []chan *model.Todo
	mu          sync.Mutex
}
