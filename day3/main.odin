package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	path := "input.txt"
	data, ok := os.read_entire_file_from_filename(path)
	if !ok {
		fmt.print("could not read file")
		return
	}
	defer delete(data, context.allocator)

	list := make([dynamic]int, context.allocator)
	defer delete(list)

	data_string := string(data)
	for i in 0 ..< len(data_string) - 4 {
		if strings.has_prefix(data_string[i:], "mul(") {
			close_index := strings.index(data_string[i:], ")")
			if close_index == -1 {
				continue
			}

			full_operation := data_string[i + 4:i + close_index]

			numbers_string, err := strings.split(full_operation, ",")
			if err != nil || len(numbers_string) != 2 {
				fmt.println("error")
				continue
			}

			numbers := make([dynamic]int, context.allocator)
			defer delete(numbers)
			is_invalid := false
			for n in numbers_string {
				if strings.contains(n, " ") {
					fmt.println("string contains spaces")
					continue
				}

				number, ok := strconv.parse_int(n)
				if !ok {
					fmt.println("not ok")
					is_invalid = true
					break
				}
				append(&numbers, number)
			}

			if is_invalid {continue}

			mul_result := numbers[0] * numbers[1]
			append(&list, mul_result)
		}
	}

	total := 0
	for n in list {
		total += n
	}
	fmt.printfln("%d", total)
}
