
//turfs with density = FALSE
/turf/open
	var/is_groundmap_turf = FALSE //whether this a turf used as main turf type for the 'outside' of a map.
	var/allow_construction = TRUE //whether you can build things like barricades on this turf.
	var/bleed_layer = 0 //snow layer
	var/wet = 0 //whether the turf is wet (only used by floors).

/turf/open/Initialize(mapload, ...)
	. = ..()
	
	update_icon()

/turf/open/update_icon()
	overlays.Cut()

	for(var/direction in alldirs)
		var/turf/open/auto_turf/T = get_step(src, direction)
		if(!istype(T))
			continue

		if(bleed_layer > T.bleed_layer || bleed_layer == T.bleed_layer)
			continue

		var/special_icon_state = "[T.icon_prefix]_[(direction & (direction-1)) ? "outercorner" : pick("innercorner", "outercorner")]"
		var/image/I = image(T.icon, special_icon_state, dir = REVERSE_DIR(direction), layer = layer + 0.001 + T.bleed_layer * 0.0001)
		I.appearance_flags = RESET_TRANSFORM|RESET_ALPHA|RESET_COLOR

		overlays += I

/turf/open/examine(mob/user)
	..()
	ceiling_desc(user)

// Black & invisible to the mouse. used by vehicle interiors
/turf/open/void
	name = "void"
	icon = 'icons/turf/floors/space.dmi'
	icon_state = "black"
	mouse_opacity = FALSE
	can_bloody = FALSE

/turf/open/river
	can_bloody = FALSE

// Prison grass
/turf/open/organic/grass
	name = "grass"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "grass1"

// Mars grounds

/turf/open/mars
	name = "sand"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_sand_1"
	is_groundmap_turf = TRUE


/turf/open/mars_cave
	name = "cave"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_cave_1"


/turf/open/mars_cave/New()
	..()

	spawn(10)
		var/r = rand(0, 2)

		if (r == 0 && icon_state == "mars_cave_2")
			icon_state = "mars_cave_3"

/turf/open/mars_dirt
	name = "dirt"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_dirt_1"


/turf/open/mars_dirt/New()
	..()
	spawn(10)
		var/r = rand(0, 32)

		if (r == 0 && icon_state == "mars_dirt_4")
			icon_state = "mars_dirt_1"
			return

		r = rand(0, 32)

		if (r == 0 && icon_state == "mars_dirt_4")
			icon_state = "mars_dirt_2"
			return

		r = rand(0, 6)

		if (r == 0 && icon_state == "mars_dirt_4")
			icon_state = "mars_dirt_7"





// Beach


/turf/open/beach
	name = "Beach"
	icon = 'icons/turf/floors/beach.dmi'


/turf/open/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/open/beach/coastline
	name = "Coastline"
	icon = 'icons/turf/beach2.dmi'
	icon_state = "sandwater"

/turf/open/beach/water
	name = "Water"
	icon_state = "water"
	can_bloody = FALSE

/turf/open/beach/water/New()
	..()
	overlays += image("icon"='icons/turf/floors/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

/turf/open/beach/water2
	name = "Water"
	icon_state = "water"
	can_bloody = FALSE

/turf/open/beach/water2/New()
	..()
	overlays += image("icon"='icons/turf/floors/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1)





//LV ground


/turf/open/gm //Basic groundmap turf parent
	name = "ground dirt"
	icon = 'icons/turf/ground_map.dmi'
	icon_state = "desert"

/turf/open/gm/attackby(var/obj/item/I, var/mob/user)

	//Light Stick
	if(istype(I, /obj/item/lightstick))
		var/obj/item/lightstick/L = I
		if(locate(/obj/item/lightstick) in get_turf(src))
			to_chat(user, "There's already a [L]  at this position!")
			return

		to_chat(user, "Now planting \the [L].")
		if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		user.visible_message("\blue[user.name] planted \the [L] into [src].")
		L.anchored = 1
		L.icon_state = "lightstick_[L.s_color][L.anchored]"
		user.drop_held_item()
		L.x = x
		L.y = y
		L.pixel_x += rand(-5,5)
		L.pixel_y += rand(-5,5)
		L.SetLuminosity(2)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)
	return

/turf/open/gm/ex_act(severity) //Should make it indestructable
	return

/turf/open/gm/fire_act(exposed_temperature, exposed_volume)
	return

/turf/open/gm/dirt
	name = "dirt"
	icon_state = "desert"

/turf/open/gm/dirt/New()
	..()
	if(rand(0,15) == 0)
		icon_state = "desert[pick("0","1","2","3")]"

/turf/open/gm/grass
	name = "grass"
	icon_state = "grass1"

/turf/open/gm/dirt2
	name = "dirt"
	icon_state = "dirt"


/turf/open/gm/dirtgrassborder
	name = "grass"
	icon_state = "grassdirt_edge"

/turf/open/gm/dirtgrassborder2
	name = "grass"
	icon_state = "grassdirt2_edge"


/turf/open/gm/river
	name = "river"
	icon_state = "seashallow"
	can_bloody = FALSE
	var/icon_overlay = "riverwater"
	var/covered = 0
	var/covered_name = "grate"
	var/cover_icon = 'icons/turf/floors/filtration.dmi'
	var/cover_icon_state = "grate"
	var/default_name = "river"

/turf/open/gm/river/New()
	..()
	update_icon()

/turf/open/gm/river/update_icon()
	..()
	update_overlays()

/turf/open/gm/river/proc/update_overlays()
	overlays.Cut()
	if(covered)
		name = covered_name
		overlays += image("icon"=src.cover_icon,"icon_state"=cover_icon_state,"layer"=CATWALK_LAYER,"dir" = dir)
	else
		name = default_name
		overlays += image("icon"=src.icon,"icon_state"=icon_overlay,"layer"=ABOVE_MOB_LAYER,"dir" = dir)

/turf/open/gm/river/ex_act(severity)
	if(covered & severity >= EXPLOSION_THRESHOLD_LOW)
		covered = 0
		update_icon()
		spawn(10)
			for(var/atom/movable/AM in src)
				src.Entered(AM)
				for(var/atom/movable/AM1 in src)
					if(AM == AM1)
						continue
					AM1.Crossed(AM)


/turf/open/gm/river/Entered(atom/movable/AM)
	..()
	if(!covered && iscarbon(AM) && !AM.throwing)
		var/mob/living/carbon/C = AM
		var/river_slowdown = 1.75

		if(ishuman(C))
			var/mob/living/carbon/human/H = AM
			cleanup(H)
			if(H.gloves && rand(0,100) < 60)
				if(istype(H.gloves,/obj/item/clothing/gloves/yautja))
					var/obj/item/clothing/gloves/yautja/Y = H.gloves
					if(Y && istype(Y) && Y.cloaked)
						to_chat(H, SPAN_WARNING(" Your bracers hiss and spark as they short out!"))
						Y.decloak(H)

		else if(isXeno(C))
			river_slowdown = 1.3
			if(isXenoBoiler(C))
				river_slowdown = -0.5

		var/new_slowdown = C.next_move_slowdown + river_slowdown
		C.next_move_slowdown = new_slowdown

/turf/open/gm/river/proc/cleanup(var/mob/living/carbon/human/M)
	if(!M || !istype(M)) return

	if(M.back)
		if(M.back.clean_blood())
			M.update_inv_back(0)
	if(M.wear_suit)
		if(M.wear_suit.clean_blood())
			M.update_inv_wear_suit(0)
	if(M.w_uniform)
		if(M.w_uniform.clean_blood())
			M.update_inv_w_uniform(0)
	if(M.gloves)
		if(M.gloves.clean_blood())
			M.update_inv_gloves(0)
	if(M.shoes)
		if(M.shoes.clean_blood())
			M.update_inv_shoes(0)
	M.clean_blood()


/turf/open/gm/river/stop_crusher_charge()
	return !covered


/turf/open/gm/river/poison/New()
	..()
	overlays += image("icon"='icons/effects/effects.dmi',"icon_state"="greenglow","layer"=MOB_LAYER+0.1)

/turf/open/gm/river/poison/Entered(mob/living/M)
	..()
	if(istype(M)) M.apply_damage(55,TOX)



/turf/open/gm/coast
	name = "coastline"
	icon_state = "beach"

/turf/open/gm/riverdeep
	name = "river"
	icon_state = "seadeep"
	can_bloody = FALSE

/turf/open/gm/riverdeep/New()
	..()
	overlays += image("icon"='icons/turf/ground_map.dmi',"icon_state"="water","layer"=MOB_LAYER+0.1)




//ELEVATOR SHAFT-----------------------------------//
/turf/open/gm/empty
	name = "empty space"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "black"
	density = 1

/turf/open/gm/empty/is_weedable()
	return FALSE



//Nostromo turfs

/turf/open/nostromowater
	name = "ocean"
	desc = "Its a long way down to the ocean from here."
	icon = 'icons/turf/ground_map.dmi'
	icon_state = "seadeep"
	can_bloody = FALSE

//Ice Colony grounds

//Ice Floor
/turf/open/ice
	name = "ice floor"
	icon = 'icons/turf/ice.dmi'
	icon_state = "ice_floor"


//Randomize ice floor sprite
/turf/open/ice/New()
	..()
	dir = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)





// Colony tiles
/turf/open/asphalt
	name = "asphalt"
	icon = 'icons/turf/floors/asphalt.dmi'
	icon_state = "sunbleached_asphalt"

/turf/open/asphalt/cement
	name = "concrete"
	icon_state = "cement5"
/turf/open/asphalt/cement_sunbleached
	name = "concrete"
	icon_state = "cement_sunbleached5"


// Jungle turfs (Whiksey Outpost)


/turf/open/jungle
	allow_construction = FALSE
	var/bushes_spawn = 1
	var/plants_spawn = 1
	name = "wet grass"
	desc = "Thick, long wet grass"
	icon = 'icons/turf/floors/jungle.dmi'
	icon_state = "grass1"
	var/icon_spawn_state = "grass1"

/turf/open/jungle/New()
	..()
	
	icon_state = icon_spawn_state

	if(plants_spawn && prob(40))
		if(prob(90))
			var/image/I
			if(prob(35))
				I = image('icons/obj/structures/props/jungleplants.dmi',"plant[rand(1,7)]")
			else
				if(prob(30))
					I = image('icons/obj/structures/props/ausflora.dmi',"reedbush_[rand(1,4)]")
				else if(prob(33))
					I = image('icons/obj/structures/props/ausflora.dmi',"leafybush_[rand(1,3)]")
				else if(prob(50))
					I = image('icons/obj/structures/props/ausflora.dmi',"fernybush_[rand(1,3)]")
				else
					I = image('icons/obj/structures/props/ausflora.dmi',"stalkybush_[rand(1,3)]")
			I.pixel_x = rand(-6,6)
			I.pixel_y = rand(-6,6)
			overlays += I
		else
			var/obj/structure/flora/jungle/thickbush/jungle_plant/J = new(src)
			J.pixel_x = rand(-6,6)
			J.pixel_y = rand(-6,6)
	if(bushes_spawn && prob(90))
		new /obj/structure/flora/jungle/thickbush(src)



/turf/open/jungle/proc/Spread(var/probability, var/prob_loss = 50)
	if(probability <= 0)
		return
	for(var/turf/open/jungle/J in orange(1, src))
		if(!J.bushes_spawn)
			continue

		var/turf/open/jungle/P = null
		if(J.type == src.type)
			P = J
		else
			P = new src.type(J)

		if(P && prob(probability))
			P.Spread(probability - prob_loss)

/turf/open/jungle/attackby(var/obj/item/I, var/mob/user)
	//Light Stick
	if(istype(I, /obj/item/lightstick))
		var/obj/item/lightstick/L = I
		if(locate(/obj/item/lightstick) in get_turf(src))
			to_chat(user, "There's already a [L]  at this position!")
			return

		to_chat(user, "Now planting \the [L].")
		if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		user.visible_message("\blue[user.name] planted \the [L] into [src].")
		L.anchored = 1
		L.icon_state = "lightstick_[L.s_color][L.anchored]"
		user.drop_held_item()
		L.x = x
		L.y = y
		L.pixel_x += rand(-5,5)
		L.pixel_y += rand(-5,5)
		L.SetLuminosity(2)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)
	return

/turf/open/jungle/clear
	bushes_spawn = 0
	plants_spawn = 0
	icon_state = "grass_clear"
	icon_spawn_state = "grass1"

/turf/open/jungle/path
	bushes_spawn = 0
	name = "dirt"
	desc = "it is very dirty."
	icon = 'icons/turf/floors/jungle.dmi'
	icon_state = "grass_path"
	icon_spawn_state = "dirt"

/turf/open/jungle/path/New()
	..()
	for(var/obj/structure/flora/jungle/thickbush/B in src)
		qdel(B)

/turf/open/jungle/impenetrable
	bushes_spawn = 0
	icon_state = "grass_impenetrable"
	icon_spawn_state = "grass1"
	New()
		..()
		var/obj/structure/flora/jungle/thickbush/B = new(src)
		B.indestructable = 1


/turf/open/jungle/water
	bushes_spawn = 0
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/turf/floors//beach.dmi'
	icon_state = "water"
	icon_spawn_state = "water"
	can_bloody = FALSE


/turf/open/jungle/water/New()
	..()
	for(var/obj/structure/flora/jungle/thickbush/B in src)
		qdel(B)

/turf/open/jungle/water/Entered(atom/movable/O)
	..()
	if(istype(O, /mob/living/))
		var/mob/living/M = O
		//slip in the murky water if we try to run through it
		if(prob(50))
			to_chat(M, pick(SPAN_NOTICE("You slip on something slimy."),SPAN_NOTICE("You fall over into the murk.")))
			M.Stun(2)
			M.KnockDown(1)

		//piranhas - 25% chance to be an omnipresent risk, although they do practically no damage
		if(prob(25))
			to_chat(M, SPAN_NOTICE(" You feel something slithering around your legs."))
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0,1), BRUTE, sharp=1)
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0,1), BRUTE, sharp=1)
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0,1), BRUTE, sharp=1)
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0,1), BRUTE, sharp=1)

/turf/open/jungle/water/deep
	plants_spawn = 0
	density = 1
	icon_state = "water2"
	icon_spawn_state = "water2"





//SHUTTLE 'FLOORS'
//not a child of turf/open/floor because shuttle floors are magic and don't behave like real floors.

/turf/open/shuttle
	name = "floor"
	icon_state = "floor"
	icon = 'icons/turf/shuttle.dmi'
	allow_construction = FALSE

/turf/open/shuttle/dropship
	name = "floor"
	icon_state = "rasputin1"


//not really plating, just the look
/turf/open/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "plating"

/turf/open/shuttle/brig // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/open/shuttle/escapepod
	icon = 'icons/turf/escapepods.dmi'
	icon_state = "floor3"


// Elevator floors
/turf/open/shuttle/elevator
	icon = 'icons/turf/elevator.dmi'
	icon_state = "floor"

/turf/open/shuttle/elevator/grating
	icon_state = "floor_grating"


