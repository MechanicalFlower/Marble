const MIN_LENGTH = 3
const MAX_LENGTH = 7
const LETTERS = {
	&"VOYELLE":
	[
		"a",
		"e",
		"a",
		"e",
		"i",
		"o",
		"o",
		"a",
		"e",
		"a",
		"e",
		"i",
		"a",
		"e",
		"a",
		"e",
		"i",
		"o",
		"o",
		"a",
		"e",
		"a",
		"e",
		"i",
		"y"
	],
	&"DOUBLE_VOYELLE": ["oi", "ai", "ou", "ei", "ae", "eu", "ie", "ea"],
	&"CONSONNE":
	[
		"b",
		"c",
		"c",
		"d",
		"f",
		"g",
		"h",
		"j",
		"l",
		"m",
		"n",
		"n",
		"p",
		"r",
		"r",
		"s",
		"t",
		"s",
		"t",
		"b",
		"c",
		"c",
		"d",
		"f",
		"g",
		"h",
		"j",
		"k",
		"l",
		"m",
		"n",
		"n",
		"p",
		"r",
		"r",
		"s",
		"t",
		"s",
		"t",
		"v",
		"w",
		"x",
		"z"
	],
	&"DOUBLE_CONSONNE": ["mm", "nn", "st", "ch", "ll", "tt", "ss"],
	&"COMPOSE": ["qu", "gu", "cc", "sc", "tr", "fr", "pr", "br", "cr", "ch", "ll", "tt", "ss", "gn"]
}

const TRANSITION = {
	&"INITIAL": [&"VOYELLE", &"CONSONNE", &"COMPOSE"],
	&"VOYELLE": [&"CONSONNE", &"DOUBLE_CONSONNE", &"COMPOSE"],
	&"DOUBLE_VOYELLE": [&"CONSONNE", &"DOUBLE_CONSONNE", &"COMPOSE"],
	&"CONSONNE": [&"VOYELLE", &"DOUBLE_VOYELLE"],
	&"DOUBLE_CONSONNE": [&"VOYELLE", &"DOUBLE_VOYELLE"],
	&"COMPOSE": [&"VOYELLE"]
}


static func pick_random_number(max_value: int, min_value: int = 0):
	randomize()

	return round(randi() % (max_value - min_value) + min_value)


static func clone_array(original):
	var result = []

	for item in original:
		result.append(item)

	return result


static func get_letter(state, _last_letter, max_length):
	var transitions = clone_array(TRANSITION[state])

	if max_length < 3:
		transitions.erase(&"COMPOSE")
		transitions.erase(&"DOUBLE_CONSONNE")
		transitions.erase(&"DOUBLE_VOYELLE")

	var state_index = pick_random_number(transitions.size())

	state = transitions[state_index]

	var letters_list = LETTERS[state]
	var letter_index = pick_random_number(letters_list.size())

	return [state, letters_list[letter_index]]


static func generate(min_length: int = MIN_LENGTH, max_length: int = MAX_LENGTH):
	var length = pick_random_number(max_length, min_length)
	var name = ""
	var last_letter = ""
	var index = 0
	var state = &"INITIAL"

	while index < length:
		var obj = get_letter(state, last_letter, length - index)

		state = obj[0]
		last_letter = obj[1]

		name += last_letter
		index += last_letter.length()

	return name.capitalize()
