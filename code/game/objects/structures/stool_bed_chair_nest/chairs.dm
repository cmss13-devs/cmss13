#define DROPSHIP_CHAIR_UNFOLDED 1
#define DROPSHIP_CHAIR_FOLDED 2
#define DROPSHIP_CHAIR_BROKEN 3

/obj/structure/bed/chair //YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "A rectangular metallic frame sitting on four legs with a back panel. Designed to fit the sitting position, more or less comfortably."
	icon_state = "chair"
	buckle_lying = FALSE
	var/propelled = 0 //Check for fire-extinguisher-driven chairs

/obj/structure/bed/chair/Initialize()
	. = ..()
	if(anchored)
		verbs -= /atom/movable/verb/pull
	handle_rotation()

/obj/structure/bed/chair/handle_rotation() //Making this into a seperate proc so office chairs can call it on Move()
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER
	if(buckled_mob)
		buckled_mob.dir = dir

/obj/structure/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(CONFIG_GET(flag/ghost_interaction))
		src.dir = turn(src.dir, 90)
		handle_rotation()
		return
	else
		if(istype(usr, /mob/living/simple_animal/mouse))
			return
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.is_mob_restrained())
			return

		dir = turn(src.dir, 90)
		handle_rotation()
		return

//Chair types
/obj/structure/bed/chair/wood
	buildstacktype = /obj/item/stack/sheet/wood
	debris = list(/obj/item/stack/sheet/wood)
	hit_bed_sound = 'sound/effects/woodhit.ogg'

/obj/structure/bed/chair/wood/normal
	icon_state = "wooden_chair"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/bed/chair/comfy
	name = "comfy chair"
	desc = "A chair with leather padding and adjustable headrest. You could probably sit in one of these for ages."
	icon_state = "comfychair"
	color = rgb(255,255,255)
	hit_bed_sound = 'sound/weapons/bladeslice.ogg'
	debris = list()

/obj/structure/bed/chair/comfy/brown
	color = rgb(255,113,0)

/obj/structure/bed/chair/comfy/beige
	color = rgb(255,253,195)

/obj/structure/bed/chair/comfy/teal
	color = rgb(0,255,255)

/obj/structure/bed/chair/comfy/black
	color = rgb(167,164,153)

/obj/structure/bed/chair/comfy/lime
	color = rgb(255,251,0)

/obj/structure/bed/chair/office
	anchored = 0
	drag_delay = 1 //Pulling something on wheels is easy

/obj/structure/bed/chair/office/Collide(atom/A)
	..()
	if(!buckled_mob) return

	if(propelled)
		var/mob/living/occupant = buckled_mob
		unbuckle()

		var/def_zone = ran_zone()
		occupant.throw_atom(A, 3, propelled)
		occupant.apply_effect(6, STUN)
		occupant.apply_effect(6, WEAKEN)
		occupant.apply_effect(6, STUTTER)
		occupant.apply_damage(10, BRUTE, def_zone)
		playsound(src.loc, 'sound/weapons/punch1.ogg', 25, 1)
		if(ishuman(A) && !isYautja(A))
			var/mob/living/victim = A
			def_zone = ran_zone()
			victim.apply_effect(6, STUN)
			victim.apply_effect(6, WEAKEN)
			victim.apply_effect(6, STUTTER)
			victim.apply_damage(10, BRUTE, def_zone)
		occupant.visible_message(SPAN_DANGER("[occupant] crashed into \the [A]!"))

/obj/structure/bed/chair/office/light
	icon_state = "officechair_white"
	anchored = 0

/obj/structure/bed/chair/office/dark
	icon_state = "officechair_dark"
	anchored = 0

/obj/structure/bed/chair/dropship/pilot
	icon_state = "pilot_chair"
	anchored = 1
	name = "pilot's chair"
	desc = "A specially designed chair for pilots to sit in."

/obj/structure/bed/chair/dropship/pilot/rotate()
	return // no

/obj/structure/bed/chair/dropship/passenger
	name = "passenger seat"
	desc = "A sturdy metal chair with a brace that lowers over your body. Holds you in place during high altitude drops."
	icon_state = "hotseat"
	var/image/chairbar = null
	var/chair_state = DROPSHIP_CHAIR_UNFOLDED
	buildstacktype = 0
	unslashable = TRUE
	unacidable = TRUE
	var/is_animating = 0

/obj/structure/bed/chair/dropship/passenger/shuttle_chair
	icon_state = "hotseat"

/obj/structure/bed/chair/dropship/passenger/BlockedPassDirs(atom/movable/mover, target_dir, height = 0, air_group = 0)
	if(chair_state == DROPSHIP_CHAIR_UNFOLDED && istype(mover, /obj/vehicle/multitile) && !is_animating)
		visible_message(SPAN_DANGER("[mover] slams into [src] and breaks it!"))
		spawn(0)
			fold_down(1)
		return BLOCKED_MOVEMENT
	return ..()

/obj/structure/bed/chair/dropship/passenger/ex_act(severity)
	return

/obj/structure/bed/chair/dropship/passenger/Initialize()
	. = ..()
	chairbar = image("icons/obj/objects.dmi", "hotseat_bars")
	chairbar.layer = ABOVE_MOB_LAYER

/obj/structure/bed/chair/dropship/passenger/shuttle_chair/Initialize()
	. = ..()
	chairbar = image("icons/obj/objects.dmi", "hotseat_bars")
	chairbar.layer = ABOVE_MOB_LAYER


/obj/structure/bed/chair/dropship/passenger/afterbuckle()
	if(buckled_mob)
		icon_state = initial(icon_state) + "_buckled"
		overlays += chairbar
	else
		icon_state = initial(icon_state)
		overlays -= chairbar


/obj/structure/bed/chair/dropship/passenger/buckle_mob(mob/M, mob/user)
	if(chair_state != DROPSHIP_CHAIR_UNFOLDED)
		return
	..()

/obj/structure/bed/chair/dropship/passenger/proc/fold_down(var/break_it = 0)
	if(chair_state == DROPSHIP_CHAIR_UNFOLDED)
		is_animating = 1
		flick("hotseat_new_folding", src)
		is_animating = 0
		unbuckle()
		if(break_it)
			chair_state = DROPSHIP_CHAIR_BROKEN
		else
			chair_state = DROPSHIP_CHAIR_FOLDED
		sleep(5) // animation length
		icon_state = "hotseat_new_folded"

/obj/structure/bed/chair/dropship/passenger/shuttle_chair/fold_down(var/break_it = 1)
	if(chair_state == DROPSHIP_CHAIR_UNFOLDED)
		unbuckle()
		chair_state = DROPSHIP_CHAIR_BROKEN
		icon_state = "hotseat_destroyed"

/obj/structure/bed/chair/dropship/passenger/proc/unfold_up()
	if(chair_state == DROPSHIP_CHAIR_BROKEN)
		return
	is_animating = 1
	flick("hotseat_new_unfolding", src)
	is_animating = 0
	chair_state = DROPSHIP_CHAIR_UNFOLDED
	sleep(5)
	icon_state = "hotseat"

/obj/structure/bed/chair/dropship/passenger/shuttle_chair/unfold_up()
	if(chair_state == DROPSHIP_CHAIR_BROKEN)
		chair_state = DROPSHIP_CHAIR_UNFOLDED
		icon_state = "hotseat"

/obj/structure/bed/chair/dropship/passenger/rotate()
	return // no

/obj/structure/bed/chair/dropship/passenger/buckle_mob(mob/living/M, mob/living/user)
	if(chair_state != DROPSHIP_CHAIR_UNFOLDED)
		return
	..()

/obj/structure/bed/chair/dropship/passenger/attack_alien(mob/living/user)
	if(chair_state != DROPSHIP_CHAIR_BROKEN)
		user.visible_message(SPAN_WARNING("[user] smashes \the [src], shearing the bolts!"),
		SPAN_WARNING("You smash \the [src], shearing the bolts!"))
		fold_down(1)

/obj/structure/bed/chair/dropship/passenger/shuttle_chair/attackby(obj/item/W, mob/living/user)
	if(istype(W,/obj/item/tool/wrench) && chair_state == DROPSHIP_CHAIR_BROKEN)
		to_chat(user, SPAN_WARNING("\The [src] appears to be broken and needs welding."))
		return
	else if((istype(W, /obj/item/tool/weldingtool) && chair_state == DROPSHIP_CHAIR_BROKEN))
		var/obj/item/tool/weldingtool/C = W
		if(C.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/weldingtool_weld.ogg', 25)
			user.visible_message(SPAN_WARNING("[user] begins repairing \the [src]."),
			SPAN_WARNING("You begin repairing \the [src]."))
			if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(SPAN_WARNING("[user] repairs \the [src]."),
				SPAN_WARNING("You repair \the [src]."))
				unfold_up()
				return
	else
		return

/obj/structure/bed/chair/dropship/passenger/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/tool/wrench))
		switch(chair_state)
			if(DROPSHIP_CHAIR_UNFOLDED)
				user.visible_message(SPAN_WARNING("[user] begins loosening the bolts on \the [src]."),
				SPAN_WARNING("You begin loosening the bolts on \the [src]."))
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					user.visible_message(SPAN_WARNING("[user] loosens the bolts on \the [src], folding it into the decking."),
					SPAN_WARNING("You loosen the bolts on \the [src], folding it into the decking."))
					fold_down()
					return
			if(DROPSHIP_CHAIR_FOLDED)
				user.visible_message(SPAN_WARNING("[user] begins unfolding \the [src]."),
				SPAN_WARNING("You begin unfolding \the [src]."))
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					user.visible_message(SPAN_WARNING("[user] unfolds \the [src] from the floor and tightens the bolts."),
					SPAN_WARNING("You unfold \the [src] from the floor and tighten the bolts."))
					unfold_up()
					return
			if(DROPSHIP_CHAIR_BROKEN)
				to_chat(user, SPAN_WARNING("\The [src] appears to be broken and needs welding."))
				return
	else if((istype(W, /obj/item/tool/weldingtool) && chair_state == DROPSHIP_CHAIR_BROKEN))
		var/obj/item/tool/weldingtool/C = W
		if(C.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/weldingtool_weld.ogg', 25)
			user.visible_message(SPAN_WARNING("[user] begins repairing \the [src]."),
			SPAN_WARNING("You begin repairing \the [src]."))
			if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(SPAN_WARNING("[user] repairs \the [src]."),
				SPAN_WARNING("You repair \the [src]."))
				chair_state = DROPSHIP_CHAIR_FOLDED
				return
	else
		..()



/obj/structure/bed/chair/ob_chair
	name = "seat"
	desc = "A comfortable seat."
	icon_state = "ob_chair"
	buildstacktype = null
	unslashable = TRUE
	unacidable = TRUE
	dir = WEST

/obj/structure/bed/chair/hunter
	name = "hunter chair"
	desc = "An exquisitely crafted chair for a large humanoid hunter."
	icon = 'icons/turf/walls/hunter.dmi'
	icon_state = "chair"
	color = rgb(255,255,255)
	hit_bed_sound = 'sound/weapons/bladeslice.ogg'
	debris = list()
