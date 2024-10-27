package model

type User struct {
	ID       string `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
	Age      int32  `json:"age"`
	IsActive bool   `json:"is_active"`
}

type UserTodo struct {
	User User
	Todo []*Todo
}
