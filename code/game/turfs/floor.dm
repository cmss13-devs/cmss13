
//actual built floors, not natural ground
/turf/open/floor
	//Note to coders, the 'intact_tile' var can no longer be used to determine if the floor is a plating or not.
	//Use the is_plating(), is_plasteel_floor() and is_light_floor() procs instead. --Errorage
	name = "floor"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "floor"
	var/icon_regular_floor = "floor" //Used to remember what icon the tile should have by default
	var/icon_plating = "plating"
	var/broken = 0
	var/burnt = 0
	var/mineral = "metal"
	var/obj/item/stack/tile/floor_tile = new/obj/item/stack/tile/plasteel
	var/breakable_tile = TRUE
	var/burnable_tile = TRUE
	var/hull_floor = FALSE //invincible floor, can't interact with it
	var/image/wet_overlay




////////////////////////////////////////////


var/list/wood_icons = list("wood", "wood-broken")


/turf/open/floor/ex_act(severity, explosion_direction)
	if(hull_floor)
		return 0
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(severity))
				break_tile()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(severity-EXPLOSION_THRESHOLD_LOW))
				break_tile_to_plating()
			else
				break_tile()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			break_tile_to_plating()
	return 0

/turf/open/floor/fire_act(exposed_temperature, exposed_volume)
	if(hull_floor)
		return
	if(!burnt && prob(5))
		burn_tile()
	else if(prob(1) && !is_plating())
		make_plating()
		burn_tile()


/turf/open/floor/ceiling_debris_check(var/size = 1)
	ceiling_debris(size)


/turf/open/floor/update_icon()
	. = ..()
	if(is_light_floor())
		var/obj/item/stack/tile/light/T = floor_tile
		if(T.on)
			switch(T.state)
				if(0)
					icon_state = "light_on"
					SetLuminosity(5)
				if(1)
					var/num = pick("1", "2", "3", "4")
					icon_state = "light_on_flicker[num]"
					SetLuminosity(5)
				if(2)
					icon_state = "light_on_broken"
					SetLuminosity(5)
				if(3)
					icon_state = "light_off"
					SetLuminosity(0)
		else
			SetLuminosity(0)
			icon_state = "light_off"
	else if(is_grass_floor())
		if(!broken && !burnt)
			if(!(icon_state in list("grass1", "grass2", "grass3", "grass4")))
				icon_state = "grass[pick("1", "2", "3", "4")]"
	else if(is_carpet_floor())
		if(!broken && !burnt)
			if(icon_state != "carpetsymbol")
				var/connectdir = 0
				for(var/direction in cardinal)
					if(istype(get_step(src, direction), /turf/open/floor))
						var/turf/open/floor/FF = get_step(src, direction)
						if(FF.is_carpet_floor())
							connectdir |= direction

				//Check the diagonal connections for corners, where you have, for example, connections both north and east
				//In this case it checks for a north-east connection to determine whether to add a corner marker or not.
				var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW

				//Northeast
				if(connectdir & NORTH && connectdir & EAST)
					if(istype(get_step(src,NORTHEAST),/turf/open/floor))
						var/turf/open/floor/FF = get_step(src,NORTHEAST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 1

				//Southeast
				if(connectdir & SOUTH && connectdir & EAST)
					if(istype(get_step(src,SOUTHEAST),/turf/open/floor))
						var/turf/open/floor/FF = get_step(src,SOUTHEAST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 2

				//Northwest
				if(connectdir & NORTH && connectdir & WEST)
					if(istype(get_step(src,NORTHWEST),/turf/open/floor))
						var/turf/open/floor/FF = get_step(src,NORTHWEST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 4

				//Southwest
				if(connectdir & SOUTH && connectdir & WEST)
					if(istype(get_step(src,SOUTHWEST),/turf/open/floor))
						var/turf/open/floor/FF = get_step(src,SOUTHWEST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 8

				icon_state = "carpet[connectdir]-[diagonalconnect]"

	else if(is_wood_floor())
		if(!broken && !burnt)
			if(!(icon_state in wood_icons))
				icon_state = "wood"

/turf/open/floor/return_siding_icon_state()
	..()
	if(is_grass_floor())
		var/dir_sum = 0
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(!(T.is_grass_floor()))
				dir_sum += direction
		if(dir_sum)
			return "wood_siding[dir_sum]"
		else
			return 0

/turf/open/floor/proc/gets_drilled()
	return

/turf/open/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/open/floor/is_plasteel_floor()
	if(istype(floor_tile,/obj/item/stack/tile/plasteel))
		return 1
	else
		return 0

/turf/open/floor/is_light_floor()
	if(istype(floor_tile,/obj/item/stack/tile/light))
		return 1
	else
		return 0

/turf/open/floor/is_grass_floor()
	if(istype(floor_tile,/obj/item/stack/tile/grass))
		return 1
	else
		return 0

/turf/open/floor/is_wood_floor()
	if(istype(floor_tile,/obj/item/stack/tile/wood))
		return 1
	else
		return 0

/turf/open/floor/is_carpet_floor()
	if(istype(floor_tile,/obj/item/stack/tile/carpet))
		return 1
	else
		return 0

/turf/open/floor/is_plating()
	if(!floor_tile)
		return 1
	return 0

/turf/open/floor/proc/break_tile()
	if(!breakable_tile || hull_floor) return
	if(broken) return
	broken = TRUE
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1, 2, 3, 4, 5)]"
		broken = 1
	else if(is_light_floor())
		icon_state = "light_broken"
		broken = 1
	else if(is_plating())
		icon_state = "platingdmg[pick(1, 2, 3)]"
		broken = 1
	else if(is_wood_floor())
		icon_state = "wood-broken"
		broken = 1
	else if(is_carpet_floor())
		icon_state = "carpet-broken"
		broken = 1
	else if(is_grass_floor())
		icon_state = "sand[pick("1", "2", "3")]"
		broken = 1

/turf/open/floor/proc/burn_tile()
	if(!burnable_tile|| hull_floor) return
	if(broken || burnt) return
	burnt = TRUE
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1, 2, 3, 4, 5)]"
		burnt = 1
	else if(is_plasteel_floor())
		icon_state = "floorscorched[pick(1, 2)]"
		burnt = 1
	else if(is_plating())
		icon_state = "panelscorched"
		burnt = 1
	else if(is_wood_floor())
		icon_state = "wood-broken"
		burnt = 1
	else if(is_carpet_floor())
		icon_state = "carpet-broken"
		burnt = 1
	else if(is_grass_floor())
		icon_state = "sand[pick("1", "2", "3")]"
		burnt = 1

//This proc will delete the floor_tile and the update_iocn() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/open/floor/proc/make_plating()

	if(is_grass_floor())
		for(var/direction in cardinal)
			if(istype(get_step(src,direction),/turf/open/floor))
				var/turf/open/floor/FF = get_step(src,direction)
				FF.update_icon() //So siding get updated properly
	else if(is_carpet_floor())
		spawn(5)
			if(src)
				for(var/direction in list(1, 2, 4, 8, 5, 6, 9, 10))
					if(istype(get_step(src,direction), /turf/open/floor))
						var/turf/open/floor/FF = get_step(src,direction)
						FF.update_icon() //So siding get updated properly

	if(!floor_tile) return
	QDEL_NULL(floor_tile)
	icon_plating = "plating"
	SetLuminosity(0)
	intact_tile = 0
	broken = 0
	burnt = 0

	update_icon()
	levelupdate()

//This proc will make the turf a plasteel floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/open/floor/proc/make_plasteel_floor(obj/item/stack/tile/plasteel/newtile)
	broken = 0
	burnt = 0
	intact_tile = 1
	SetLuminosity(0)

	if(!istype(newtile))
		newtile = new

	floor_tile = newtile
	if (icon_regular_floor)
		icon_state = icon_regular_floor
	else
		icon_state = "floor"
		icon_regular_floor = icon_state
	update_icon()
	levelupdate()


//This proc will make the turf a light floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/open/floor/proc/make_light_floor(obj/item/stack/tile/light/newtile)
	broken = 0
	burnt = 0
	intact_tile = 1
	if(!istype(newtile))
		newtile = new

	floor_tile = newtile
	update_icon()
	levelupdate()


//This proc will make a turf into a grass patch. Fun eh? Insert the grass tile to be used as the argument
//If no argument is given a new one will be made.
/turf/open/floor/proc/make_grass_floor(var/obj/item/stack/tile/grass/T = null)
	broken = 0
	burnt = 0
	intact_tile = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/grass))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//If you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/grass

	update_icon()
	levelupdate()

//This proc will make a turf into a wood floor. Fun eh? Insert the wood tile to be used as the argument
//If no argument is given a new one will be made.
/turf/open/floor/proc/make_wood_floor(var/obj/item/stack/tile/wood/T = null)
	broken = 0
	burnt = 0
	intact_tile = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/wood))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//If you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/wood

	update_icon()
	levelupdate()

//This proc will make a turf into a carpet floor. Fun eh? Insert the carpet tile to be used as the argument
//If no argument is given a new one will be made.
/turf/open/floor/proc/make_carpet_floor(var/obj/item/stack/tile/carpet/T = null)
	broken = 0
	burnt = 0
	intact_tile = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/carpet))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//If you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/carpet

	update_icon()
	levelupdate()

/turf/open/floor/attackby(obj/item/C, mob/user)

	if(hull_floor) //no interaction for hulls
		return

	if(istype(C,/obj/item/light_bulb/bulb)) //Only for light tiles
		if(is_light_floor())
			var/obj/item/stack/tile/light/T = floor_tile
			if(T.state)
				user.drop_held_item(C)
				qdel(C)
				T.state = C //Fixing it by bashing it with a light bulb, fun eh?
				update_icon()
				to_chat(user, SPAN_NOTICE("You replace the light bulb."))
			else
				to_chat(user, SPAN_NOTICE("The lightbulb seems fine, no need to replace it."))

	if(istype(C, /obj/item/tool/crowbar) && (!(is_plating())))
		if(broken || burnt)
			to_chat(user, SPAN_WARNING("You remove the broken plating."))
		else
			if(is_wood_floor())
				to_chat(user, SPAN_WARNING("You forcefully pry off the planks, destroying them in the process."))
			else
				to_chat(user, SPAN_WARNING("You remove the [floor_tile.name]."))
				new floor_tile.type(src)

		make_plating()
		playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
		return

	if(istype(C, /obj/item/tool/screwdriver) && is_wood_floor())
		if(broken || burnt)
			return
		else
			if(is_wood_floor())
				to_chat(user, SPAN_WARNING("You unscrew the planks."))
				new floor_tile.type(src)

		make_plating()
		playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)
		return

	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(is_plating())
			if(R.get_amount() < 2)
				to_chat(user, SPAN_WARNING("You need more rods."))
				return
			to_chat(user, SPAN_NOTICE("Reinforcing the floor."))
			if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && is_plating())
				if(!R) return
				if(R.use(2))
					ChangeTurf(/turf/open/floor/engine)
					playsound(src, 'sound/items/Deconstruct.ogg', 25, 1)
				return
			else
		else
			to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return

	if(istype(C, /obj/item/stack/tile))
		if(is_plating())
			if(!broken && !burnt)
				var/obj/item/stack/tile/T = C
				if(T.get_amount() < 1)
					return
				floor_tile = new T.type
				intact_tile = 1
				if(istype(T, /obj/item/stack/tile/light))
					var/obj/item/stack/tile/light/L = T
					var/obj/item/stack/tile/light/F = floor_tile
					F.state = L.state
					F.on = L.on
				if(istype(T, /obj/item/stack/tile/grass))
					for(var/direction in cardinal)
						if(istype(get_step(src, direction), /turf/open/floor))
							var/turf/open/floor/FF = get_step(src,direction)
							FF.update_icon() //so siding gets updated properly
				else if(istype(T, /obj/item/stack/tile/carpet))
					for(var/direction in list(1, 2, 4, 8, 5, 6, 9, 10))
						if(istype(get_step(src, direction), /turf/open/floor))
							var/turf/open/floor/FF = get_step(src,direction)
							FF.update_icon() //so siding gets updated properly
				T.use(1)
				update_icon()
				levelupdate()
				playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			else
				to_chat(user, SPAN_NOTICE("This section is too damaged to support a tile. Use a welder to fix the damage."))


	if(istype(C, /obj/item/stack/cable_coil))
		if(is_plating())
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
		else
			to_chat(user, SPAN_WARNING("You must remove the plating first."))

	if(istype(C, /obj/item/tool/shovel))
		if(is_grass_floor())
			new /obj/item/ore/glass(src)
			new /obj/item/ore/glass(src) //Make some sand if you shovel grass
			to_chat(user, SPAN_NOTICE("You shovel the grass."))
			make_plating()
		else
			to_chat(user, SPAN_WARNING("You cannot shovel this."))

	if(istype(C, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/welder = C
		if(welder.isOn() && (is_plating()))
			if(broken || burnt)
				if(welder.remove_fuel(0, user))
					to_chat(user, SPAN_WARNING("You fix some dents on the broken plating."))
					playsound(src, 'sound/items/Welder.ogg', 25, 1)
					icon_state = "plating"
					burnt = 0
					broken = 0
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))




/turf/open/floor/wet_floor(wet_level = FLOOR_WET_WATER)
	if(wet >= wet_level) return
	wet = wet_level
	if(wet_overlay)
		overlays -= wet_overlay
		wet_overlay = null
	wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
	overlays += wet_overlay

	var/oldtype = type
	spawn(800)
		if(type != oldtype)
			return
		if(wet == wet_level)
			wet = 0
			if(wet_overlay)
				overlays -= wet_overlay
				wet_overlay = null



/turf/open/floor/attack_alien(mob/living/carbon/Xenomorph/M)
	if(is_light_floor())
		M.animation_attack_on(src)
		playsound(src, 'sound/effects/glasshit.ogg', 25, 1)
		M.visible_message(SPAN_DANGER("\The [M] smashes \the [src]!"), \
		SPAN_DANGER("You smash \the [src]!"), \
		SPAN_DANGER("You hear broken glass!"), 5)
		icon_state = "light_off"
		SetLuminosity(0)

/turf/open/floor/sandstone
	name = "sandstone floor"
	icon_state = "whiteyellowfull"
