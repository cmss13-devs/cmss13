/obj/structure/machinery/constructable_frame/porta_comms
	name = "portable telecommunications unit"
	desc = "A portable compact TC-4T telecommunications construction kit. Used to set up subspace communications lines between planetary and extra-planetary locations. Needs cabling."
	icon = 'icons/obj/structures/machinery/comm_tower2.dmi'
	icon_state = "construct_0_0"
	required_skill = SKILL_ENGINEER_ENGI
	required_dismantle_skill = 5
	density = TRUE
	anchored = FALSE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/constructable_frame/porta_comms/update_icon()
	..()
	var/is_wired = 0
	for(var/obj/item/current_item in contents)
		if(iswire(current_item))
			is_wired = 1
			break
	if(components)
		switch(components.len)
			if(0 to 8)
				icon_state = "construct_[contents.len]_[is_wired]"
			else
				icon_state = "construct_8_1"
	else if(state)
		icon_state = "construct_1_0"
	else
		icon_state = "construct_0_0"

/obj/structure/machinery/constructable_frame/porta_comms/ex_act(severity)
	return

/obj/structure/machinery/constructable_frame/porta_comms/attackby(obj/item/current_item, mob/user)
	var/area/current_area = get_area(src)
	if (!current_area.can_build_special)
		to_chat(usr, SPAN_DANGER("You don't want to deploy this here!"))
		return
	if(istype(current_item, /obj/item/circuitboard/machine) && !istype(current_item, /obj/item/circuitboard/machine/telecomms/relay/tower))
		return
	..()

