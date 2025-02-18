// You might be wondering why this isn't client level. If focus is null, we don't want you to move.
// Only way to do that is to tie the behavior into the focus's keyLoop().
/atom/movable/keyLoop(client/user)
	var/movement_dir = NONE
	// SS220 EDIT start - diagonal movement config
	if(CONFIG_GET(flag/diagonal_move))
		movement_dir = diagonal_move(user)
	else
		movement_dir = cardinal_move(user)
	// SS220 EDIT end - diagonal movement config

	if(!movement_dir)
		return
	// Sanity checks in case you hold left and right and up to make sure you only go up
	if((movement_dir & NORTH) && (movement_dir & SOUTH))
		movement_dir &= ~(NORTH|SOUTH)
	if((movement_dir & EAST) && (movement_dir & WEST))
		movement_dir &= ~(EAST|WEST)

	if(user.dir != NORTH && movement_dir) //If we're not moving, don't compensate, as byond will auto-fill dir otherwise
		movement_dir = turn(movement_dir, -dir2angle(user.dir)) //By doing this we ensure that our input direction is offset by the client (camera) direction

	// This is called from Subsystem, and as such usr is unset.
	// You hopefully don't it but it might go against legacy code expectations.
	usr = user.mob
	if(user.movement_locked)
		keybind_face_direction(movement_dir)
	else
		user.Move(get_step(src, movement_dir), movement_dir)

// SS220 ADD start - diagonal movement config
/datum/config_entry/flag/diagonal_move

/atom/movable/proc/diagonal_move(client/user, movement_dir)
	for(var/_key in user.keys_held)
		movement_dir = movement_dir | user.movement_keys[_key]
	if(user.next_move_dir_add)
		movement_dir |= user.next_move_dir_add
	if(user.next_move_dir_sub)
		movement_dir &= ~user.next_move_dir_sub

	return movement_dir

/atom/movable/proc/cardinal_move(client/user, movement_dir)
	for(var/_key in user.keys_held)
		movement_dir = user.movement_keys[_key]
	if(user.next_move_dir_add)
		movement_dir = user.next_move_dir_add
	// if(user.next_move_dir_sub)
	// 	movement_dir &= ~user.next_move_dir_sub

	return movement_dir
// SS220 ADD end - diagonal movement config
