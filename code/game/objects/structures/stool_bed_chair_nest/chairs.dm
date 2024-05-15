#define DROPSHIP_CHAIR_UNFOLDED 1
#define DROPSHIP_CHAIR_FOLDED 2
#define DROPSHIP_CHAIR_BROKEN 3

/obj/structure/bed/chair //YES, chairs are a type of bed, which are a type of stool. This works, believe me. -Pete
	name = "chair"
	desc = "A rectangular metallic frame sitting on four legs with a back panel. Designed to fit the sitting position, more or less comfortably."
	icon_state = "chair"
	buckle_lying = 0
	var/propelled = FALSE //Check for fire-extinguisher-driven chairs
	var/can_rotate = TRUE
	var/picked_up_item = /obj/item/weapon/twohanded/folded_metal_chair
	var/stacked_size = 0

/obj/structure/bed/chair/Initialize()
	. = ..()
	handle_rotation()
	if(!can_rotate)
		verbs.Remove(/obj/structure/bed/chair/verb/rotate)

/obj/structure/bed/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_AROUND|PASS_UNDER
	flags_can_pass_all_temp = PASS_OVER

/obj/structure/bed/chair/handle_rotation() //Making this into a separate proc so office chairs can call it on Move()
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER
	if(buckled_mob)
		buckled_mob.setDir(dir)

/obj/structure/bed/chair/MouseDrop(atom/over)
	. = ..()
	if(!picked_up_item)
		return
	var/mob/living/carbon/human/H = over
	if(usr != H)
		return
	if(!CAN_PICKUP(H, src))
		return
	if(buckled_mob)
		to_chat(H, SPAN_NOTICE("You cannot fold the chair while [buckled_mob.name] is buckled to it!"))
		return
	if(stacked_size)
		to_chat(H, SPAN_NOTICE("You cannot fold a chair while its stacked!"))
		return
	var/obj/item/weapon/twohanded/folded_metal_chair/FMC = new picked_up_item(loc)
	if(H.put_in_active_hand(FMC))
		qdel(src)
	else if(H.put_in_inactive_hand(FMC))
		qdel(src)
	else
		to_chat(H, SPAN_NOTICE("You need a free hand to fold up the chair."))
		qdel(FMC)

/obj/structure/bed/chair/attack_hand(mob/user)
	. = ..()
	if(stacked_size)
		if(!CAN_PICKUP(user, src))
			return
		var/obj/item/weapon/twohanded/folded_metal_chair/F = locate() in contents
		user.put_in_active_hand(F)
		stacked_size--
		update_overlays()
		if(!stacked_size)
			layer = OBJ_LAYER
			unslashable = FALSE
			can_buckle = TRUE
			density = FALSE
			flags_can_pass_all_temp |= PASS_OVER
			projectile_coverage = PROJECTILE_COVERAGE_MEDIUM

/obj/structure/bed/chair/attack_alien(mob/living/carbon/xenomorph/M)
	. = ..()
	if(stacked_size)
		stack_collapse()

/obj/structure/bed/chair/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_WRENCH) && stacked_size)
		to_chat(user, SPAN_NOTICE("You'll need to unstack the chairs before you can take one apart."))
		return FALSE
	if(istype(I, /obj/item/weapon/twohanded/folded_metal_chair) && picked_up_item)
		if(I.flags_item & WIELDED)
			return ..()
		if(locate(/mob/living) in loc)
			to_chat(user, SPAN_NOTICE("There's someone in the way!"))
			return FALSE
		user.drop_inv_item_to_loc(I, src)
		stacked_size++
		update_overlays()

		if(stacked_size == 1)
			layer = ABOVE_MOB_LAYER
			unslashable = TRUE
			can_buckle = FALSE
			density = TRUE
			flags_can_pass_all_temp -= PASS_OVER
			projectile_coverage = PROJECTILE_COVERAGE_HIGH
			return FALSE

		if(stacked_size > 8)
			to_chat(user, SPAN_WARNING("The stack of chairs looks unstable!"))
			if(prob(sqrt(50 * stacked_size)))
				stack_collapse()
				return FALSE
		return FALSE

	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(!PC.linked_powerloader)
			qdel(PC)
			return TRUE
		if(!stacked_size)
			to_chat(user, SPAN_WARNING("\The [PC] can only grab stacks of chairs."))
			return TRUE
		//skill reduces the chance of collapse
		if(stacked_size > 8 && prob(50 / user.skills.get_skill_level(SKILL_POWERLOADER)))
			stack_collapse()
			return TRUE

		PC.grab_object(user, src, "chairs", 'sound/machines/hydraulics_2.ogg')
		update_icon()
		return TRUE

	return ..()

/obj/structure/bed/chair/hitby(atom/movable/AM)
	. = ..()
	if(istype(AM, /mob/living) && stacked_size)
		var/mob/living/M = AM
		stack_collapse()
		M.apply_effect(2, STUN)
		M.apply_effect(2, WEAKEN)
	else if(stacked_size > 8 && prob(50))
		stack_collapse()

/obj/structure/bed/chair/ex_act(power)
	. = ..()
	if(stacked_size)
		stack_collapse()

/obj/structure/bed/chair/proc/stack_collapse()
	visible_message(SPAN_HIGHDANGER("The stack of chairs collapses!!!"))
	var/turf/starting_turf = get_turf(src)
	playsound(starting_turf, 'sound/weapons/metal_chair_crash.ogg', 30, 1, 30)
	for(var/obj/item/weapon/twohanded/folded_metal_chair/falling_chair in src.contents)
		stacked_size--
		update_overlays()

		var/list/candidate_target_turfs = range(floor(stacked_size/2), starting_turf)
		candidate_target_turfs -= starting_turf
		var/turf/target_turf = candidate_target_turfs[rand(1, length(candidate_target_turfs))]

		falling_chair.forceMove(starting_turf)
		falling_chair.pixel_x = rand(-8, 8)
		falling_chair.pixel_y = rand(-8, 8)
		falling_chair.throw_atom(target_turf, rand(2, 5), SPEED_FAST, null, TRUE)
	var/obj/item/weapon/twohanded/folded_metal_chair/I = new picked_up_item(starting_turf)
	I.throw_atom(starting_turf, rand(2, 5), SPEED_FAST, null, TRUE)
	qdel(src)

/obj/structure/bed/chair/proc/update_overlays()
	overlays.Cut()
	if(!stacked_size)
		name = initial(name)
		desc = initial(desc)
		return
	name = "stack of folding chairs"
	desc = "There seems to be [stacked_size + 1] in the stack, wow!"
	for(var/i in 1 to stacked_size)
		var/image/I = new(src.icon)
		I.dir = src.dir
		var/image/previous_chair_overlay
		if(i == 1)
			switch(src.dir)
				if(NORTH)
					I.pixel_y = pixel_y + 2
				if(SOUTH)
					I.pixel_y = pixel_y + 2
				if(EAST)
					I.pixel_x = pixel_x + 1
					I.pixel_y = pixel_y + 3
				if(WEST)
					I.pixel_x = pixel_x - 1
					I.pixel_y = pixel_y + 3
		else
			previous_chair_overlay = overlays[i - 1]
			switch(src.dir)
				if(NORTH)
					I.pixel_y = previous_chair_overlay.pixel_y + 2
				if(SOUTH)
					I.pixel_y = previous_chair_overlay.pixel_y + 2
				if(EAST)
					I.pixel_x = previous_chair_overlay.pixel_x + 1
					I.pixel_y = previous_chair_overlay.pixel_y + 3
				if(WEST)
					I.pixel_x = previous_chair_overlay.pixel_x - 1
					I.pixel_y = previous_chair_overlay.pixel_y + 3
		if(stacked_size > 8)
			I.pixel_x = I.pixel_x + pick(list(-1, 1))
		overlays += I

/obj/structure/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(CONFIG_GET(flag/ghost_interaction))
		src.setDir(turn(src.dir, 90))
		handle_rotation()
		return
	else
		if(!ishuman(usr))
			return
		human_rotate()
		return

/obj/structure/bed/chair/proc/human_rotate()
	if(!usr || !isturf(usr.loc))
		return
	if(usr.is_mob_incapacitated())
		return
	setDir(turn(src.dir, 90))
	handle_rotation()
	return

//Chair types
/obj/structure/bed/chair/bolted
	desc = "A rectangular metallic frame sitting on four legs with a back panel. Designed to fit the sitting position, more or less comfortably. It appears to be bolted to the ground."
	picked_up_item = null

/obj/structure/bed/chair/wood
	buildstacktype = /obj/item/stack/sheet/wood
	debris = list(/obj/item/stack/sheet/wood)
	hit_bed_sound = 'sound/effects/woodhit.ogg'
	picked_up_item = null

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
	picked_up_item = null

/obj/structure/bed/chair/comfy/orange
	icon_state = "comfychair_orange"

/obj/structure/bed/chair/comfy/beige
	icon_state = "comfychair_beige"

/obj/structure/bed/chair/comfy/teal
	icon_state = "comfychair_teal"

/obj/structure/bed/chair/comfy/black
	icon_state = "comfychair_black"

/obj/structure/bed/chair/comfy/lime
	icon_state = "comfychair_lime"

/obj/structure/bed/chair/comfy/blue
	icon_state = "comfychair_blue"

/obj/structure/bed/chair/comfy/alpha
	icon_state = "comfychair_alpha"
	name = "Alpha squad chair"
	desc = "A simple chair permanently attached to the floor. Covered with a squeaky and way too hard faux-leather, unevenly painted in Alpha squad red. Only for the bravest and freshest USCM recruits."

/obj/structure/bed/chair/comfy/bravo
	icon_state = "comfychair_bravo"
	name = "Bravo squad chair"
	desc = "A simple chair permanently attached to the floor. Covered with a squeaky and way too hard faux-leather, unevenly painted in Bravo squad brown. Certified fortified on all sides from enemy incursion."

/obj/structure/bed/chair/comfy/charlie
	icon_state = "comfychair_charlie"
	name = "Charlie squad chair"
	desc = "A simple chair permanently attached to the floor. Covered with a squeaky and way too hard faux-leather, unevenly painted in Charlie squad purple. Feels out of place without a full breakfast to accompany it."

/obj/structure/bed/chair/comfy/delta
	icon_state = "comfychair_delta"
	name = "Delta squad chair"
	desc = "A simple chair permanently attached to the floor. Covered with a squeaky and way too hard faux-leather, unevenly painted in Delta squad blue. This chair is most likely to be the first to fight and first to die."

/obj/structure/bed/chair/comfy/ares
	icon_state = "comfychair_ares"
	name = "AI core chair"
	desc = "A functional chair designed for comfortably sitting a single person with intent to facilitate interactions with the ship AI."

/obj/structure/bed/chair/office
	anchored = FALSE
	drag_delay = 1 //Pulling something on wheels is easy
	picked_up_item = null

/obj/structure/bed/chair/office/Collide(atom/A)
	..()
	if(!buckled_mob) return

	if(propelled)
		var/mob/living/occupant = buckled_mob
		unbuckle()

		var/def_zone = rand_zone()
		occupant.throw_atom(A, 3, propelled)
		occupant.apply_effect(6, STUN)
		occupant.apply_effect(6, WEAKEN)
		occupant.apply_effect(6, STUTTER)
		occupant.apply_damage(10, BRUTE, def_zone)
		playsound(src.loc, 'sound/weapons/punch1.ogg', 25, 1)
		if(ishuman(A) && !isyautja(A))
			var/mob/living/victim = A
			def_zone = rand_zone()
			victim.apply_effect(6, STUN)
			victim.apply_effect(6, WEAKEN)
			victim.apply_effect(6, STUTTER)
			victim.apply_damage(10, BRUTE, def_zone)
		occupant.visible_message(SPAN_DANGER("[occupant] crashed into \the [A]!"))

/obj/structure/bed/chair/office/light
	icon_state = "officechair_white"
	anchored = FALSE

/obj/structure/bed/chair/office/dark
	icon_state = "officechair_dark"
	anchored = FALSE

/obj/structure/bed/chair/dropship
	can_rotate = FALSE
	picked_up_item = null

/obj/structure/bed/chair/dropship/pilot
	icon_state = "pilot_chair"
	anchored = TRUE
	name = "pilot's chair"
	desc = "A specially designed chair for pilots to sit in."

/obj/structure/bed/chair/dropship/pilot/unbuckle()
	if(buckled_mob && buckled_mob.buckled == src)
		buckled_mob.reset_view()
	return ..()

/obj/structure/bed/chair/dropship/passenger
	name = "passenger seat"
	desc = "A sturdy metal chair with a brace that lowers over your body. Holds you in place during high altitude drops."
	icon_state = "hotseat"
	var/image/chairbar = null
	var/chair_state = DROPSHIP_CHAIR_UNFOLDED
	buildstacktype = 0
	unslashable = TRUE
	unacidable = TRUE
	buckling_sound = 'sound/effects/metal_close.ogg'
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

/obj/structure/bed/chair/dropship/passenger/proc/fold_down(break_it = 0)
	if(chair_state == DROPSHIP_CHAIR_UNFOLDED)
		is_animating = 1
		flick("hotseat_new_folding", src)
		is_animating = 0
		unbuckle()
		if(break_it)
			chair_state = DROPSHIP_CHAIR_BROKEN
		else
			chair_state = DROPSHIP_CHAIR_FOLDED
		addtimer(VARSET_CALLBACK(src, icon_state, "hotseat_new_folded"), 5) // animation length

/obj/structure/bed/chair/dropship/passenger/shuttle_chair/fold_down(break_it = 1)
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
	addtimer(VARSET_CALLBACK(src, icon_state, "hotseat"), 5) // animation length

/obj/structure/bed/chair/dropship/passenger/shuttle_chair/unfold_up()
	if(chair_state == DROPSHIP_CHAIR_BROKEN)
		chair_state = DROPSHIP_CHAIR_UNFOLDED
		icon_state = "hotseat"

/obj/structure/bed/chair/dropship/passenger/buckle_mob(mob/living/M, mob/living/user)
	if(chair_state != DROPSHIP_CHAIR_UNFOLDED)
		return
	..()

/obj/structure/bed/chair/dropship/passenger/attack_alien(mob/living/user)
	if(chair_state != DROPSHIP_CHAIR_BROKEN)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		user.animation_attack_on(src)
		user.visible_message(SPAN_WARNING("[user] smashes \the [src], shearing the bolts!"),
		SPAN_WARNING("You smash \the [src], shearing the bolts!"))
		fold_down(1)
		return XENO_ATTACK_ACTION

/obj/structure/bed/chair/dropship/passenger/shuttle_chair/attackby(obj/item/W, mob/living/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && chair_state == DROPSHIP_CHAIR_BROKEN)
		to_chat(user, SPAN_WARNING("\The [src] appears to be broken and needs welding."))
		return
	else if((iswelder(W) && chair_state == DROPSHIP_CHAIR_BROKEN))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
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
	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
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
	else if((iswelder(W) && chair_state == DROPSHIP_CHAIR_BROKEN))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
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
	picked_up_item = null

/obj/structure/bed/chair/hunter
	name = "hunter chair"
	desc = "An exquisitely crafted chair for a large humanoid hunter."
	icon = 'icons/turf/walls/hunter.dmi'
	icon_state = "chair"
	color = rgb(255,255,255)
	hit_bed_sound = 'sound/weapons/bladeslice.ogg'
	debris = list()
	picked_up_item = null

/obj/item/weapon/twohanded/folded_metal_chair //used for when someone picks up the chair
	name = "metal folding chair"
	desc = "A metal folding chair, probably could be turned into a seat by anyone with half a braincell working."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "folding_chair"
	item_state = "folding_chair"
	attack_verb = list("bashed", "battered", "chaired")
	force = 1
	throwforce = 3
	sharp = null
	edge = 0
	w_class = SIZE_LARGE
	force_wielded = 10
	flags_item = TWOHANDED
	var/placed_object = /obj/structure/bed/chair

/obj/item/weapon/twohanded/folded_metal_chair/attack(mob/living/M as mob, mob/living/user as mob)
	. = ..()
	if(!.)
		return
	if(flags_item & WIELDED)
		M.apply_stamina_damage(17, check_zone(user.zone_selected))
	playsound(get_turf(user), 'sound/weapons/metal_chair_clang.ogg', 20, 1)

/obj/item/weapon/twohanded/folded_metal_chair/afterattack(atom/target, mob/user, proximity)
	if(flags_item & WIELDED)
		return
	if(isturf(target))
		var/turf/open/T = target
		if(!(istype(T)) || !proximity || T.density)
			return
		if(!T.allow_construction)
			to_chat(user, SPAN_WARNING("[src] must be assembled on a proper surface!"))
			return
		for(var/atom/movable/AM in T.contents)
			if(AM.density || istype(AM, /obj/structure/bed))
				to_chat(user, SPAN_WARNING("You can't unfold the chair here, [AM] blocks the way."))
				return
		var/obj/O = new placed_object(T)
		O.dir = user.dir
		qdel(src)

/obj/item/weapon/twohanded/folded_metal_chair/mob_launch_collision(mob/living/L)
	playsound(get_turf(src), 'sound/weapons/metal_chair_slam.ogg', 50, 1)
	..()
