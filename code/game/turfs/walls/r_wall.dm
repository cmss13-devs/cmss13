/turf/closed/wall/r_wall
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon_state = "r_wall_mapicon"
	opacity = TRUE
	density = TRUE

	damage_cap = HEALTH_WALL_REINFORCED

	walltype = WALL_REINFORCED

	claws_minimum = CLAW_TYPE_VERY_SHARP

/turf/closed/wall/r_wall/attackby(obj/item/W, mob/user)
	if(turf_flags & TURF_HULL)
		return

	//get the user's location
	if( !istype(user.loc, /turf) )
		return //can't do this stuff whilst inside objects and such

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting walls and the relevant effects
	if(thermite)
		if(W.heat_source >= 1000)
			if(turf_flags & TURF_HULL)
				to_chat(user, SPAN_WARNING("[src] is much too tough for you to do anything to it with [W]."))
			else
				if(iswelder(W))
					var/obj/item/tool/weldingtool/WT = W
					WT.remove_fuel(0,user)
				thermitemelt(user)
			return

	if(try_weldingtool_usage(W, user) || try_nailgun_usage(W, user))
		return

	if(istype(W, /obj/item/weapon/twohanded/breacher))
		var/obj/item/weapon/twohanded/breacher/current_hammer = W
		if(user.action_busy)
			return
		if(!(HAS_TRAIT(user, TRAIT_SUPER_STRONG) || !current_hammer.really_heavy))
			to_chat(user, SPAN_WARNING("You can't use \the [current_hammer] properly!"))
			return

		to_chat(user, SPAN_NOTICE("You start taking down \the [src]."))
		if(!do_after(user, 10 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("You stop taking down \the [src]."))
			return
		to_chat(user, SPAN_NOTICE("You tear down \the [src]."))

		playsound(src, 'sound/effects/meteorimpact.ogg', 40, 1)
		playsound(src, 'sound/effects/ceramic_shatter.ogg', 40, 1)

		take_damage(damage_cap)
		return

	//DECONSTRUCTION
	switch(d_state)
		if(WALL_STATE_WELD)
			if(iswelder(W))
				if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
					return
				var/obj/item/tool/weldingtool/WT = W
				try_weldingtool_deconstruction(WT, user)

		if(WALL_STATE_SCREW)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				user.visible_message(SPAN_NOTICE("[user] begins removing the support lines."),
				SPAN_NOTICE("You begin removing the support lines."))
				playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WIRECUTTER
				user.visible_message(SPAN_NOTICE("[user] removes the support lines."), SPAN_NOTICE("You remove the support lines."))
				return

		if(WALL_STATE_WIRECUTTER)
			if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
				user.visible_message(SPAN_NOTICE("[user] begins uncrimping the hydraulic lines."),
				SPAN_NOTICE("You begin uncrimping the hydraulic lines."))
				playsound(src, 'sound/items/Wirecutter.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WRENCH
				user.visible_message(SPAN_NOTICE("[user] finishes uncrimping the hydraulic lines."), SPAN_NOTICE("You finish uncrimping the hydraulic lines."))
				return

		if(WALL_STATE_WRENCH)
			if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
				user.visible_message(SPAN_NOTICE("[user] starts loosening the anchoring bolts securing the support rods."),
				SPAN_NOTICE("You start loosening the anchoring bolts securing the support rods."))
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_CROWBAR
				user.visible_message(SPAN_NOTICE("[user] removes the bolts anchoring the support rods."), SPAN_NOTICE("You remove the bolts anchoring the support rods."))
				return

		if(WALL_STATE_CROWBAR)
			if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
				user.visible_message(SPAN_NOTICE("[user] struggles to pry apart the connecting rods."),
				SPAN_NOTICE("You struggle to pry apart the connecting rods."))
				playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				user.visible_message(SPAN_NOTICE("[user] pries apart the connecting rods."), SPAN_NOTICE("You pry apart the connecting rods."))
				new /obj/item/stack/rods(src)
				dismantle_wall()
				return

//vv OK, we weren't performing a valid deconstruction step or igniting thermite,let's check the other possibilities vv

	//DRILLING
	if (istype(W, /obj/item/tool/pickaxe/diamonddrill))

		to_chat(user, SPAN_NOTICE("You begin to drill though the wall."))

		if(do_after(user, 200 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!istype(src, /turf/closed/wall/r_wall))
				return
			to_chat(user, SPAN_NOTICE("Your drill tears though the last of the reinforced plating."))
			dismantle_wall()

	//REPAIRING
	else if(damage && istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/MS = W
		user.visible_message(SPAN_NOTICE("[user] starts repairing the damage to [src]."),
		SPAN_NOTICE("You start repairing the damage to [src]."))
		playsound(src, 'sound/items/Welder.ogg', 25, 1)
		if(do_after(user, max(5, floor(damage / 5) * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && istype(src, /turf/closed/wall/r_wall))
			user.visible_message(SPAN_NOTICE("[user] finishes repairing the damage to [src]."),
			SPAN_NOTICE("You finish repairing the damage to [src]."))
			take_damage(-damage)
			MS.use(1)

		return



	//APC
	else if( istype(W,/obj/item/frame/apc) )
		var/obj/item/frame/apc/AH = W
		AH.try_build(src)

	else if( istype(W,/obj/item/frame/air_alarm) )
		var/obj/item/frame/air_alarm/AH = W
		AH.try_build(src)

	else if(istype(W,/obj/item/frame/fire_alarm))
		var/obj/item/frame/fire_alarm/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/frame/light_fixture))
		var/obj/item/frame/light_fixture/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/frame/light_fixture/small))
		var/obj/item/frame/light_fixture/small/AH = W
		AH.try_build(src)
		return

	//Poster stuff
	else if(istype(W,/obj/item/poster))
		place_poster(W,user)
		return

	return



/turf/closed/wall/r_wall/can_be_dissolved()
	if(turf_flags & TURF_HULL)
		return 0
	else
		return 2


//Just different looking wall
/turf/closed/wall/r_wall/research
	icon_state = "research"
	walltype = WALL_REINFORCED_RESEARCH

/turf/closed/wall/r_wall/dense
	icon_state = "iron0"
	walltype = WALL_REINFORCED_IRON
	turf_flags = TURF_HULL

/turf/closed/wall/r_wall/unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon_state = "heavy_r_wall_mapicon"
	walltype = WALL_REINFORCED
	turf_flags = TURF_HULL

/turf/closed/wall/r_wall/unmeltable/attackby() //This should fix everything else. No cables, etc
	return

//Chigusa

/turf/closed/wall/r_wall/chigusa
	name = "facility wall"
	icon = 'icons/turf/walls/chigusa.dmi'
	icon_state = "chigusa"
	walltype = WALL_REINFORCED_CHIGUSA

/turf/closed/wall/r_wall/chigusa/update_icon()
	..()
	if(special_icon)
		return
	if(neighbors_list in list(EAST|WEST))
		var/r1 = rand(0,10) //Make a random chance for this to happen
		var/r2 = rand(0,3) // Which wall if we do choose it
		if(r1 >= 9)
			overlays += image(icon, icon_state = "deco_wall[r2]")

//Bunker Walls

/turf/closed/wall/r_wall/bunker
	name = "bunker wall"
	icon = 'icons/turf/walls/bunker.dmi'
	icon_state = "bunker"
	walltype = WALL_REINFORCED_BUNKER

//Prison

/turf/closed/wall/r_wall/prison
	name = "reinforced metal wall"
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "rwall"
	walltype = WALL_REINFORCED

/turf/closed/wall/r_wall/prison_unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "hwall"
	walltype = WALL_REINFORCED
	turf_flags = TURF_HULL

/turf/closed/wall/r_wall/prison_unmeltable/ex_act(severity) //Should make it indestructible
		return

/turf/closed/wall/r_wall/prison_unmeltable/fire_act(exposed_temperature, exposed_volume)
		return

/turf/closed/wall/r_wall/prison_unmeltable/attackby() //This should fix everything else. No cables, etc
		return

//Biodome

/turf/closed/wall/r_wall/biodome
	name = "reinforced metal wall"
	icon = 'icons/turf/walls/corsat.dmi'
	icon_state = "r_dome"
	walltype = WALL_DOMER

/turf/closed/wall/r_wall/biodome/biodome_unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon_state = "h_dome"
	turf_flags = TURF_HULL

/turf/closed/wall/r_wall/biodome/biodome_unmeltable/ex_act(severity) //Should make it indestructible
		return

/turf/closed/wall/r_wall/biodome/biodome_unmeltable/fire_act(exposed_temperature, exposed_volume)
		return

/turf/closed/wall/r_wall/biodome/biodome_unmeltable/attackby() //This should fix everything else. No cables, etc
		return


/// Destructible elevator walls, for when you want the elevator to act as a prop rather than an actual elevator
/turf/closed/wall/r_wall/elevator
	icon = 'icons/turf/elevator.dmi'
	icon_state = "wall"
	special_icon = TRUE

// Wall with gears that animate when elevator is moving
/turf/closed/wall/r_wall/elevator/gears
	icon_state = "wall_gear"

// Special wall icons
/turf/closed/wall/r_wall/elevator/research
	icon_state = "wall_research"

/turf/closed/wall/r_wall/elevator/dorm
	icon_state = "wall_dorm"

/turf/closed/wall/r_wall/elevator/freight
	icon_state = "wall_freight"

/turf/closed/wall/r_wall/elevator/arrivals
	icon_state = "wall_arrivals"

// Elevator Buttons
/turf/closed/wall/r_wall/elevator/button
	name = "elevator buttons"

/turf/closed/wall/r_wall/elevator/button/research
	icon_state = "wall_button_research"

/turf/closed/wall/r_wall/elevator/button/dorm
	icon_state = "wall_button_dorm"

/turf/closed/wall/r_wall/elevator/button/freight
	icon_state = "wall_button_freight"

/turf/closed/wall/r_wall/elevator/button/arrivals
	icon_state = "wall_button_arrivals"

