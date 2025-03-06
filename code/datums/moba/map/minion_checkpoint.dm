GLOBAL_LIST_EMPTY(uninitialized_moba_checkpoints)

// walk_to() has a max range of 2x the world.view, so checkpoints must be within 14 tiles of each other

/obj/effect/moba_minion_checkpoint
	invisibility = INVISIBILITY_MAXIMUM
	/// Minions who pass an alt_next_x/y_coord checkpoint gain bonus max/current HP so that eventually waves get pushed to one base
	/// The goal isn't an immediate push to base, but a gradual shove instead
	var/alt_health_mult = 1.1
	// Both of these are relative to the bottom left corner of the map
	var/next_x_coord
	var/next_y_coord
	/// List of coords of the bottom left turf of the moba map
	var/list/bottom_left_turf_coords
	/// Which side this belongs to
	var/primary_hive = XENO_HIVE_MOBA_LEFT
	// If the target hive != primary hive, use these coords instead
	var/alt_next_x_coord
	var/alt_next_y_coord

/obj/effect/moba_minion_checkpoint/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(get_turf(src), COMSIG_TURF_ENTERED, PROC_REF(on_turf_enter))
	GLOB.uninitialized_moba_checkpoints += src

/obj/effect/moba_minion_checkpoint/proc/set_up_checkpoint(turf/bottom_left_turf)
	bottom_left_turf_coords = list(bottom_left_turf.x, bottom_left_turf.y, bottom_left_turf.z)
	GLOB.uninitialized_moba_checkpoints -= src

/obj/effect/moba_minion_checkpoint/proc/on_turf_enter(datum/source, atom/movable/entering)
	SIGNAL_HANDLER

	if(!HAS_TRAIT(entering, TRAIT_MOBA_MINION))
		return

	var/mob/living/carbon/xenomorph/minion_xeno = entering
	var/datum/component/moba_minion/minion = minion_xeno.GetComponent(/datum/component/moba_minion) // Zonenote: unshittify this later
	if(minion.parent_xeno.hive.hivenumber == primary_hive)
		minion.next_turf_target = locate(bottom_left_turf_coords[1] + next_x_coord - 1, bottom_left_turf_coords[2] + next_y_coord - 1, bottom_left_turf_coords[3])
	else
		var/turf/old_target = minion.next_turf_target
		minion.next_turf_target = locate(bottom_left_turf_coords[1] + alt_next_x_coord - 1, bottom_left_turf_coords[2] + alt_next_y_coord - 1, bottom_left_turf_coords[3])
		if(old_target != minion.next_turf_target)
			var/health_to_add = (minion_xeno.maxHealth * alt_health_mult) - minion_xeno.maxHealth
			minion_xeno.maxHealth *= alt_health_mult
			var/brute = minion_xeno.getBruteLoss()
			var/burn = minion_xeno.getFireLoss()
			if(brute || burn)
				var/percentage_brute = brute / (brute + burn)
				var/percentage_burn = burn / (brute + burn)
				minion_xeno.apply_damage(-(health_to_add * percentage_brute), BRUTE)
				minion_xeno.apply_damage(-(health_to_add * percentage_burn), BURN)
				minion_xeno.updatehealth()

	minion.is_moving_to_next_point = FALSE
	INVOKE_ASYNC(minion, TYPE_PROC_REF(/datum, process))

/obj/effect/moba_minion_checkpoint/left
	primary_hive = XENO_HIVE_MOBA_LEFT

/obj/effect/moba_minion_checkpoint/left/top_diag1 // From base to halfway through the diagonal
	next_x_coord = 27
	next_y_coord = 45
	alt_next_x_coord = 12
	alt_next_y_coord = 28

/obj/effect/moba_minion_checkpoint/left/top_diag2 // From halfway through the diagonal to the start of top straight
	next_x_coord = 35
	next_y_coord = 49
	alt_next_x_coord = 16
	alt_next_y_coord = 34

/obj/effect/moba_minion_checkpoint/left/top_straight1
	next_x_coord = 49
	next_y_coord = 49
	alt_next_x_coord = 27
	alt_next_y_coord = 45

/obj/effect/moba_minion_checkpoint/left/top_straight2
	next_x_coord = 63
	next_y_coord = 49
	alt_next_x_coord = 35
	alt_next_y_coord = 49

/obj/effect/moba_minion_checkpoint/left/top_straight3
	next_x_coord = 76
	next_y_coord = 49
	alt_next_x_coord = 49
	alt_next_y_coord = 49

/obj/effect/moba_minion_checkpoint/left/top_straight4
	next_x_coord = 84
	next_y_coord = 49
	alt_next_x_coord = 63
	alt_next_y_coord = 49

/obj/effect/moba_minion_checkpoint/left/bot_diag1
	next_x_coord = 27
	next_y_coord = 1
	alt_next_x_coord = 12
	alt_next_y_coord = 28

/obj/effect/moba_minion_checkpoint/left/bot_diag2
	next_x_coord = 35
	next_y_coord = 7
	alt_next_x_coord = 16
	alt_next_y_coord = 22

/obj/effect/moba_minion_checkpoint/left/bot_straight1
	next_x_coord = 49
	next_y_coord = 7
	alt_next_x_coord = 27
	alt_next_y_coord = 11

/obj/effect/moba_minion_checkpoint/left/bot_straight2
	next_x_coord = 63
	next_y_coord = 7
	alt_next_x_coord = 35
	alt_next_y_coord = 7

/obj/effect/moba_minion_checkpoint/left/bot_straight3
	next_x_coord = 76
	next_y_coord = 7
	alt_next_x_coord = 49
	alt_next_y_coord = 7

/obj/effect/moba_minion_checkpoint/left/bot_straight4
	next_x_coord = 84
	next_y_coord = 7
	alt_next_x_coord = 63
	alt_next_y_coord = 7


/obj/effect/moba_minion_checkpoint/right
	primary_hive = XENO_HIVE_MOBA_RIGHT

/obj/effect/moba_minion_checkpoint/right/top_diag1
	next_x_coord = 133
	next_y_coord = 45
	alt_next_x_coord = 147
	alt_next_y_coord = 28

/obj/effect/moba_minion_checkpoint/right/top_diag2
	next_x_coord = 124
	next_y_coord = 49
	alt_next_x_coord = 144
	alt_next_y_coord = 34

/obj/effect/moba_minion_checkpoint/right/top_straight1
	next_x_coord = 110
	next_y_coord = 49
	alt_next_x_coord = 133
	alt_next_y_coord = 45

/obj/effect/moba_minion_checkpoint/right/top_straight2
	next_x_coord = 96
	next_y_coord = 49
	alt_next_x_coord = 124
	alt_next_y_coord = 49

/obj/effect/moba_minion_checkpoint/right/top_straight3
	next_x_coord = 83
	next_y_coord = 49
	alt_next_x_coord = 110
	alt_next_y_coord = 49

/obj/effect/moba_minion_checkpoint/right/top_straight4
	next_x_coord = 76
	next_y_coord = 49
	alt_next_x_coord = 96
	alt_next_y_coord = 49

/obj/effect/moba_minion_checkpoint/right/bot_diag1
	next_x_coord = 132
	next_y_coord = 11
	alt_next_x_coord = 147
	alt_next_y_coord = 28

/obj/effect/moba_minion_checkpoint/right/bot_diag2
	next_x_coord = 124
	next_y_coord = 7
	alt_next_x_coord = 144
	alt_next_y_coord = 22

/obj/effect/moba_minion_checkpoint/right/bot_straight1
	next_x_coord = 111
	next_y_coord = 7
	alt_next_x_coord = 133
	alt_next_y_coord = 11

/obj/effect/moba_minion_checkpoint/right/bot_straight2
	next_x_coord = 97
	next_y_coord = 7
	alt_next_x_coord = 125
	alt_next_y_coord = 7

/obj/effect/moba_minion_checkpoint/right/bot_straight3
	next_x_coord = 84
	next_y_coord = 7
	alt_next_x_coord = 111
	alt_next_y_coord = 7

/obj/effect/moba_minion_checkpoint/right/bot_straight4
	next_x_coord = 76
	next_y_coord = 7
	alt_next_x_coord = 97
	alt_next_y_coord = 7

