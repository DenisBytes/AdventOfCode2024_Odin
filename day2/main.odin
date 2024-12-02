package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

is_safe_report :: proc(report: []int) -> bool {
	for i in 0 ..< len(report) {
		temp_report := make([]int, len(report) - 1)
		copy(temp_report[:i], report[:i])
		copy(temp_report[i:], report[i + 1:])

		if check_rules(temp_report) {
			return true
		}
	}

	return check_rules(report)
}

check_rules :: proc(report: []int) -> bool {
	if len(report) <= 1 {
		return true
	}

	mode := 0
	for i := 0; i < len(report) - 1; i += 1 {
		result := report[i + 1] - report[i]

		if abs(result) < 1 || abs(result) > 3 {
			return false
		}

		if mode == 0 {
			if result > 0 {
				mode = 1
			} else if result < 0 {
				mode = -1
			}
		}

		if (mode > 0 && result < 0) || (mode < 0 && result > 0) {
			return false
		}
	}

	return true
}

main :: proc() {
	path := "input.txt"
	data, ok := os.read_entire_file_from_filename(path)
	if !ok {
		fmt.print("could not read file")
		return
	}
	defer delete(data, context.allocator)

	safe_reports_count := 0
	data_string := string(data)

	for report_line in strings.split_lines_iterator(&data_string) {
		if len(report_line) == 0 do continue

		report_levels_str := strings.split(report_line, " ")
		report_levels := make([]int, len(report_levels_str))
		defer delete(report_levels)

		for level_str, i in report_levels_str {
			report_levels[i] = strconv.atoi(level_str)
		}

		if is_safe_report(report_levels) {
			safe_reports_count += 1
		}
	}

	fmt.printf("Safe reports: %d\n", safe_reports_count)
}
