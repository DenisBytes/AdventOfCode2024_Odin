package main

import "core:fmt"
import "core:os"
import "core:sort"
import "core:strconv"
import "core:strings"

main :: proc() {

	path := "input.txt"
	data, ok := os.read_entire_file_from_filename(path)
	if !ok {
		fmt.print("could not read file")
	}

	defer delete(data, context.allocator)

	first_list := make([dynamic]int, context.allocator)
	second_list := make([dynamic]int, context.allocator)

	defer delete(first_list)
	defer delete(second_list)

	data_string := string(data)
	for line in strings.split_lines_iterator(&data_string) {
		line_locations_number, err := strings.split(line, " ")
		if err != nil {
			fmt.println("coult not split line")
			os.exit(1)
		}

		// output ["<int>", " ", " ", "<int>"], for some reason
		first_list_number := strconv.atoi(line_locations_number[0])
		append(&first_list, first_list_number)
		second_list_number := strconv.atoi(line_locations_number[3])
		append(&second_list, second_list_number)
	}

	total_distance: int
	similarity_score: int
	similarity_list := make([dynamic]int, context.allocator)
	defer delete(similarity_list)
	// problem 1
	order_list(first_list)
	order_list(second_list)

	for i := 0; i < len(first_list); i = i + 1 {
		// problem 1
		total_distance += abs(first_list[i] - second_list[i])
		// problem 2
		appeared := 0
		for j := 0; j < len(second_list); j = j + 1 {
			if first_list[i] == second_list[j] {
				appeared += 1
			}
		}
		appearence_result := first_list[i] * appeared
		if appeared != 0 {	
			fmt.printf(
				"appeared: %#v\n\nappearence_result: %#v\n\n",
				appeared,
				appearence_result,
			)
		}
		append(&similarity_list, appearence_result)
	}

	for i := 0; i < len(similarity_list); i += 1 {
		similarity_score += similarity_list[i]
	}

	fmt.println("PROBLEM 1 FINSIHED. Total distance: ", total_distance)
	fmt.println("PROBLEM 2 FINSIHED. Total similarity: ", similarity_score)
}

order_list :: proc(list: [dynamic]int) {
	for i := 0; i < len(list); i += 1 {
		for j := i + 1; j < len(list); j += 1 {
			if list[i] > list[j] {
				temp := list[i]
				list[i] = list[j]
				list[j] = temp
			}
		}
	}
}