/obj/item/folded_tent
	name = "Folded Abstract Tent"
	icon = 'icons/obj/structures/tents_folded.dmi'
	/// Required cleared area along X axis
	var/dim_x = 1
	/// Required cleared area along Y axis
	var/dim_y = 1
	/// X Offset from which actually to deploy the tent area
	var/off_x = 0
	/// Y Offset from which actually to deploy the tent area
	var/off_y = 0
	/// Map Template to use for the tent
	var/template

/// Check an area is clear for deployment of the tent
/obj/item/folded_tent/proc/check_area(turf/ref_turf, mob/message_receiver)
	SHOULD_NOT_SLEEP(TRUE)
	. = TRUE
	var/turf/starting_turf = locate(ref_turf.x - off_x, ref_turf.y - off_y, ref_turf.z)
	var/turf/block_end_turf = locate(starting_turf.x + dim_x - 1, starting_turf.y + dim_y - 1, starting_turf.z)
	var/list/turf_block = block(starting_turf, block_end_turf)
	for(var/turf/turf as anything in turf_block)
		for(var/atom/movable/atom as anything in turf)
			if(ismob(atom) || (atom.density && atom.can_block_movement))
				if(message_receiver)
					to_chat(message_receiver, SPAN_WARNING("You cannot deploy the [src] here, something ([atom.name]) is in the way."))
				return FALSE
	return TRUE

/obj/item/folded_tent/proc/unfold(turf/ref_turf)
	var/turf/starting_turf = locate(ref_turf.x - off_x, ref_turf.y - off_y, ref_turf.z)
	var/datum/map_template/template_instance = new template()
	template_instance.load(starting_turf, FALSE, FALSE)

/obj/item/folded_tent/cmd
	name = "Folded USCM Command Tent"
	icon_state = "cmd"
	dim_x = 2
	dim_y = 4
	off_x = 1
	template = /datum/map_template/tent/cmd
