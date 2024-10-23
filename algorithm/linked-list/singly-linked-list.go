package linkedlist

import "fmt"

type Node struct {
	next  *Node
	value int
}

type SinglyLinkedList struct {
	head *Node
}

func (l *SinglyLinkedList) Init() {
	l.head = nil
}

func (l *SinglyLinkedList) InsertAtHead(value int) {
	newNode := &Node{
		value: value,
	}
	newNode.next = l.head
	l.head = newNode
}

func (l *SinglyLinkedList) InsertAtTail(value int) {
	newNode := &Node{
		value: value,
	}
	if l.head == nil {
		newNode.next = nil
		l.head = newNode
		return
	}
	current := l.head
	for current.next != nil {
		current = current.next
	}
	current.next = newNode
}

func (l *SinglyLinkedList) PrintAll() {
	if l.head == nil {
		fmt.Println("List is empty")
		return
	}

	current := l.head
	for current != nil {
		fmt.Println("Node value:", current.value)
		current = current.next
	}
}

func (l *SinglyLinkedList) FloydCycleDetection() bool {
	slow := l.head
	fast := l.head

	for fast != nil && fast.next != nil {
		slow = slow.next
		fast = fast.next.next

		if slow == fast {
			return true
		}
	}

	return false
}
