/*
	The big deal with test environments are environment strings. Here's how they work:

		The string as a whole represents a map. Each character determines what will be spawned in that position.
		The dimension of the test environment is determined by the largest row/column size. Spaces won't be populated.

		Certain key characters are reserved for common atoms, such as walls and floors. They are:
			H - hull wall (indestructible)
			W - regular wall (destructible)
			F - floor
			S - nothing/default turf

		Any other character will be relayed to the populate() proc, where you can spawn stuff you need based on
		the character.
*/

var/list/test_env_prefab_types = list(
	"H" = /turf/closed/wall/almayer/outer,
	"W" = /turf/closed/wall/almayer,
	"F" = /turf/open/floor/almayer,
	"S" = null
)

/datum/test_environment
	// Name of the test environment
	var/name = ""

	// Min position of the test environment
	var/x = 1
	var/y = 1
	var/z = 0

	// Environment string for constructing the test environment
	var/environment_string = ""

	// If a custom populate proc isn't made, you can use this list for character => type assignments
	var/list/environment_assignments = null

// Initializes the test environment, making it ready for use
/datum/test_environment/proc/initialize()
	set waitfor = FALSE

	// Give the environment its own z level if no z is specified
	if(!z)
		z = ++world.maxz

	if(environment_string)
		parse_env_string()
	else
		// If there is no environment string, manually populate the environment
		manual_populate()

	// Wait for the game to start before inserting people
	while(SSticker.current_state != GAME_STATE_PLAYING)
		sleep(10)

	insert_actors()

// Constructs a test environment from the datum's environment string
/datum/test_environment/proc/parse_env_string()
	var/list/rows = splittext(environment_string, "\n")
	var/row_amount = 0
	// Count rows and clean up the list
	for(var/i = 1 to length(rows))
		var/row = trim(rows[i])

		// Empty rows are ignored
		if(!length(row) || !row)
			rows[i] = null
			continue

		rows[i] = row
		row_amount++
	// Get rid of the nulled rows
	rows -= null

	if(!row_amount)
		return

	var/atoms_to_setup = 0
	var/col_amount = 0
	for(var/row in rows)
		col_amount = max(col_amount, length(row))
		atoms_to_setup += length(row)

	if(!col_amount)
		return

	// Construct the test environment top->bottom
	var/cur_x = x
	var/cur_y = y + row_amount
	for(var/row in rows)
		cur_x = x

		// Construct the row left->right
		for(var/char in splittext(row, regex("."), 1, 0, TRUE))
			if(!char)
				continue

			var/cur_turf = locate(cur_x, cur_y, z)
			// Set the area
			new /area/test(cur_turf)

			// Construct prefab atoms
			if(char in test_env_prefab_types)
				var/type = test_env_prefab_types[char]
				// Do nothing here
				if(!type)
					cur_x++
					continue

				new type(cur_turf)
			else
				// If it's not a prefab, pass the construction job on to the populate() proc
				populate(char, cur_turf)
			cur_x++
		cur_y--

// Populates a given position with the given character
/datum/test_environment/proc/populate(character, char_turf)
	if(character in environment_assignments)
		var/list/types = environment_assignments[character]
		for(var/type in types)
			var/atom/A = new type(char_turf)
			if(types[type])
				A.setDir(types[type])

// Insert yourself into the environment here, for example by keying into a mob
/datum/test_environment/proc/insert_actors()
	return

// You can manually populate the environment in here if you'd rather do that
/datum/test_environment/proc/manual_populate()
	return

// Utility function for constructing empty hulls
/datum/test_environment/proc/construct_room(width, height)
	// Construct the outer hull
	for(var/turf/T in blockhollow(locate(x, y, z), locate(x + width, y + height, z)))
		new /turf/closed/wall/almayer/outer(T)

	// Construct floors
	for(var/turf/T in block(locate(x+1, y+1, z), locate(x + width - 1, y + height - 1, z)))
		new /turf/open/floor/almayer(T)
