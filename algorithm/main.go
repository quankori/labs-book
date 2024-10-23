package main

import (
	linkedlist "go-algorithm/linked-list"
)

func main() {
	sll := linkedlist.SinglyLinkedList{}
	sll.Init()
	sll.InsertAtHead(1)
	sll.InsertAtTail(2)
	sll.InsertAtHead(3)
	sll.PrintAll()
}
