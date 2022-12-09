package main

// go run ./day09.go input.txt 1
// go run ./day09.go input.txt 9

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func abs(value int) int {
	if value < 0 {
		return value * -1
	}
	return value
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func createMarkingEntry(x int, y int) string {
	var sb strings.Builder

	sb.WriteString(strconv.Itoa(x))
	sb.WriteString("|")
	sb.WriteString(strconv.Itoa(y))

	return sb.String()
}

func containsMark(markings *[]string, target string) bool {
	for _, marking := range *markings {
		if marking == target {
			return true
		}
	}
	return false
}

type RopeNode struct {
	parentNode *RopeNode
	x, y       int
}

func (r *RopeNode) move(direction string) {
	switch direction {
	case "D":
		r.y--
		break
	case "U":
		r.y++
		break
	case "L":
		r.x--
		break
	case "R":
		r.x++
		break
	default:
		panic("Tried to move RopeNode into unknown direction")
	}
	return
}

func (r *RopeNode) chase() {
	if r.parentNode == nil {
		return
	}

	pY := r.parentNode.y
	pX := r.parentNode.x

	// Both Nodes on the same spot
	if r.x == pX && r.y == pY {
		return
	}

	// Both Nodes are adjacent
	if abs(r.x-pX) <= 1 && abs(r.y-pY) <= 1 {
		return
	}

	// Nodes are aligned on the x-axis
	if abs(r.x-pX) == 0 && abs(r.y-pY) == 2 {
		if (r.y - pY) < 0 {
			r.y++
		} else {
			r.y--
		}

		return
	}

	// Nodes are aligned on the y-axis
	if abs(r.x-pX) == 2 && abs(r.y-pY) == 0 {
		if (r.x - pX) < 0 {
			r.x++
		} else {
			r.x--
		}

		return
	}

	// Move up-right
	if r.x < pX && r.y < pY {
		r.x++
		r.y++

		return
	}

	// Move down-left
	if r.x > pX && r.y > pY {
		r.x--
		r.y--

		return
	}

	// Move up-left
	if r.x > pX && r.y < pY {
		r.x--
		r.y++

		return
	}

	// Move down-right
	if r.x < pX && r.y > pY {
		r.x++
		r.y--

		return
	}

	r.println()
	r.parentNode.println()
	panic("No suitable move found.")
}

func (r *RopeNode) evalMarking(markings *[]string) {
	marking := createMarkingEntry(r.x, r.y)
	if !containsMark(markings, marking) {
		*markings = append(*markings, marking)
	}
}

func (r *RopeNode) println() {
	fmt.Println("X: ", r.x, "| Y: ", r.y)
}

func main() {
	filename := os.Args[1]
	tailLength, err := strconv.Atoi(os.Args[2])
	check(err)
	data, err := os.ReadFile(filename)
	check(err)

	commands := strings.Split(string(data), "\n")
	head := RopeNode{nil, 0, 0}
	// tail := RopeNode{&head, 0, 0}

	tails := make([]RopeNode, tailLength)
	// init tails
	prev := &head
	for i := range tails {
		tails[i].x = 0
		tails[i].y = 0
		tails[i].parentNode = prev
		prev = &(tails[i])
	}

	argv := make([]string, 2)
	markings := make([]string, 0, 1000)

	for _, command := range commands {
		argv = strings.Split(command, " ")
		steps, err := strconv.Atoi(argv[1])

		if err != nil {
			fmt.Println(err)
			break
		}

		//fmt.Printf("Moving %d to %s\n", steps, argv[0])

		for i := 0; i < steps; i++ {
			head.move(argv[0])

			for i := range tails {
				tails[i].chase()

				if i == (len(tails) - 1) {
					tails[i].evalMarking(&markings)
				}
			}
		}
	}

	fmt.Printf("Tail visited %d unique locations\n", len(markings))
	head.println()
}
