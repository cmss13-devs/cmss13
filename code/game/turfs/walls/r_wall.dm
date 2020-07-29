/turf/closed/wall/r_wall
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to seperate rooms."
	icon_state = "r_wall"
	opacity = 1
	density = 1

	damage_cap = HEALTH_WALL_REINFORCED
	max_temperature = 6000

	walltype = WALL_REINFORCED

	claws_minimum = CLAW_TYPE_VERY_SHARP

/turf/closed/wall/r_wall/attackby(obj/item/W, mob/user)
	if(hull)
		return

	if (!(istype(user, /mob/living/carbon/human) || isrobot(user) || ticker) && ticker.mode.name != "monkey")
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	//get the user's location
	if( !istype(user.loc, /turf) )	return	//can't do this stuff whilst inside objects and such

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting walls and the relevant effects
	if(thermite)
		if(W.heat_source >= 1000)
			if(hull)
				to_chat(user, SPAN_WARNING("[src] is much too tough for you to do anything to it with [W]."))
			else
				if(istype(W, /obj/item/tool/weldingtool))
					var/obj/item/tool/weldingtool/WT = W
					WT.remove_fuel(0,user)
				thermitemelt(user)
			return

	if(damage && istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(0,user))
			to_chat(user, SPAN_NOTICE("You start repairing the damage to [src]."))
			playsound(src, 'sound/items/Welder.ogg', 25, 1)
			if(do_after(user, max(5, damage / 5 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && WT && WT.isOn())
				to_chat(user, SPAN_NOTICE("You finish repairing the damage to [src]."))
				take_damage(-damage)
			return
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return


	//DECONSTRUCTION
	switch(d_state)
		if(WALL_STATE_WELD)
			if(iswelder(W))
				var/obj/item/tool/weldingtool/WT = W
				playsound(src, 'sound/items/Welder.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] begins slicing through the outer plating."),
				SPAN_NOTICE("You begin slicing through the outer plating."))
				if(!WT || !WT.isOn())	
					return
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_SCREW
				user.visible_message(SPAN_NOTICE("[user] slices through the outer plating."), SPAN_NOTICE("You slice through the outer plating."))
				return

		if(WALL_STATE_SCREW)
			if(isscrewdriver(W))
				user.visible_message(SPAN_NOTICE("[user] begins removing the support lines."),
				SPAN_NOTICE("You begin removing the support lines."))
				playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WIRECUTTER
				user.visible_message(SPAN_NOTICE("[user] removes the support lines."), SPAN_NOTICE("You remove the support lines."))
				return

		if(WALL_STATE_WIRECUTTER)
			if(iswirecutter(W))
				user.visible_message(SPAN_NOTICE("[user] begins uncrimping the hydraulic lines."),
				SPAN_NOTICE("You begin uncrimping the hydraulic lines."))
				playsound(src, 'sound/items/Wirecutter.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WRENCH
				user.visible_message(SPAN_NOTICE("[user] finishes uncrimping the hydraulic lines."), SPAN_NOTICE("You finish uncrimping the hydraulic lines."))
				return

		if(WALL_STATE_WRENCH)
			if(iswrench(W))
				user.visible_message(SPAN_NOTICE("[user] starts loosening the anchoring bolts securing the support rods."),
				SPAN_NOTICE("You start loosening the anchoring bolts securing the support rods."))
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_CROWBAR
				user.visible_message(SPAN_NOTICE("[user] removes the bolts anchoring the support rods."), SPAN_NOTICE("You remove the bolts anchoring the support rods."))
				return

		if(WALL_STATE_CROWBAR)
			if(iscrowbar(W))
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
		if(do_after(user, max(5, round(damage / 5) * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && istype(src, /turf/closed/wall/r_wall))
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
	if(hull)
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
	hull = 1

/turf/closed/wall/r_wall/unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to seperate rooms. Looks virtually indestructible."
	icon_state = "r_wall"
	walltype = WALL_REINFORCED
	hull = 1

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
	desc = "A huge chunk of ultra-reinforced metal used to seperate rooms. Looks virtually indestructible."
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "rwall"
	walltype = WALL_REINFORCED
	hull = 1

/turf/closed/wall/r_wall/prison_unmeltable/ex_act(severity) //Should make it indestructable
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
	desc = "A huge chunk of ultra-reinforced metal used to seperate rooms. Looks virtually indestructible."
	hull = 1

/turf/closed/wall/r_wall/biodome/biodome_unmeltable/ex_act(severity) //Should make it indestructable
		return

/turf/closed/wall/r_wall/biodome/biodome_unmeltable/fire_act(exposed_temperature, exposed_volume)
		return

/turf/closed/wall/r_wall/biodome/biodome_unmeltable/attackby() //This should fix everything else. No cables, etc
		return
