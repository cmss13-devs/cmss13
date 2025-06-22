//////////////////////////////////////////////////////////////
//Mounted MG, Replacment for the current jury rig code.

// First thing we need is the ammo drum for this thing.
/obj/item/ammo_magazine/m56d
	name = "M56D drum magazine (10x28mm Caseless)"
	desc = "A box of 700, 10x28mm caseless tungsten rounds for the M56D heavy machine gun system. Just click the M56D with this to reload it."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/machineguns.dmi'
	w_class = SIZE_MEDIUM
	icon_state = "m56d_drum"
	flags_magazine = NO_FLAGS //can't be refilled or emptied by hand
	caliber = "10x28mm"
	max_rounds = 700
	default_ammo = /datum/ammo/bullet/machinegun
	gun_type = null



// Now we need a box for this.
/obj/item/storage/box/m56d_hmg
	name = "\improper M56D crate"
	desc = "A large metal case with Japanese writing on the top. However it also comes with English text to the side. This is a M56D heavy machine gun, it clearly has various labeled warnings."
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "M56D_case" // I guess a placeholder? Not actually going to show up ingame for now.
	w_class = SIZE_HUGE
	storage_slots = 6
	can_hold = list()

/obj/item/storage/box/m56d_hmg/fill_preset_inventory()
	new /obj/item/device/m56d_gun(src) //gun itself
	new /obj/item/device/m56d_post(src) //post for the gun
	new /obj/item/ammo_magazine/m56d(src) //ammo for the gun
	new /obj/item/ammo_magazine/m56d(src)
	new /obj/item/tool/wrench(src) //wrench to hold it down into the ground
	new /obj/item/tool/screwdriver(src) //screw the gun onto the post.

// The actual gun itself.
/obj/item/device/m56d_gun
	name = "\improper M56D heavy machine gun"
	desc = "The top half of a M56D heavy machine gun post. However it ain't much use without the tripod."
	unacidable = TRUE
	w_class = SIZE_HUGE
	flags_equip_slot = SLOT_BACK
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/hmg.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/machineguns.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/machineguns_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/machineguns_righthand.dmi'
	)
	icon_state = "M56D_gun_e"
	///How many rounds are in the weapon. This is useful if we break down our guns.
	var/rounds = 0
	///Indicates whether the M56D will come with its folding mount already attached
	var/has_mount = FALSE
	///The distance this has to be away from other m56d_hmg and m56d_post to be placed.
	var/defense_check_range = 5

/obj/item/device/m56d_gun/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/device/m56d_gun/get_examine_text(mob/user) //Let us see how much ammo we got in this thing.
	. = ..()
	if(rounds)
		. += "It has [rounds] out of 700 rounds."
	else
		. += "It seems to be lacking a ammo drum."

/obj/item/device/m56d_gun/update_icon() //Lets generate the icon based on how much ammo it has.
	var/icon_name = "M56D_gun"
	if(has_mount)
		icon_name += "_mount"
	if(!rounds)
		icon_name += "_e"
	icon_state = icon_name
	return

/obj/item/device/m56d_gun/attackby(obj/item/O as obj, mob/user as mob)
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return

	if(QDELETED(O))
		return

	if(istype(O,/obj/item/ammo_magazine/m56d)) //lets equip it with ammo
		if(!rounds)
			rounds = 700
			qdel(O)
			update_icon()
			return
		else
			to_chat(usr, "The M56D already has a ammo drum mounted on it!")
		return

/obj/item/device/m56d_gun/attack_self(mob/user)
	..()
	for(var/obj/structure/machinery/machine in long_range(defense_check_range, loc))
		if(istype(machine, /obj/structure/machinery/m56d_hmg) || istype(machine, /obj/structure/machinery/m56d_post))
			to_chat(user, SPAN_WARNING("This is too close to [machine]!"))
			return
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return
	if(!has_mount)
		return
	if(SSinterior.in_interior(user))
		to_chat(usr, SPAN_WARNING("It's too cramped in here to deploy \a [src]."))
		return
	var/area/area = get_area(user)
	if(!area.allow_construction)
		to_chat(user, SPAN_WARNING("You cannot install \the [src] here, find a more secure surface!"))
		return
	var/turf/T = get_turf(usr)
	if(istype(T, /turf/open))
		var/turf/open/floor = T
		if(!floor.allow_construction)
			to_chat(user, SPAN_WARNING("You cannot install \the [src] here, find a more secure surface!"))
			return FALSE
	var/fail = FALSE
	if(T.density)
		fail = TRUE
	else
		for(var/obj/X in T.contents - src)
			if(X.density && !(X.flags_atom & ON_BORDER))
				fail = TRUE
				break
			if(istype(X, /obj/structure/machinery/defenses))
				fail = TRUE
				break
			else if(istype(X, /obj/structure/window))
				fail = TRUE
				break
			else if(istype(X, /obj/structure/windoor_assembly))
				fail = TRUE
				break
			else if(istype(X, /obj/structure/machinery/door))
				fail = TRUE
				break
	if(fail)
		to_chat(usr, SPAN_WARNING("You can't deploy \the [src] here, something is in the way."))
		return


	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	for(var/obj/structure/machinery/machine in long_range(defense_check_range, loc))
		if(istype(machine, /obj/structure/machinery/m56d_hmg) || istype(machine, /obj/structure/machinery/m56d_post))
			to_chat(user, SPAN_WARNING("This is too close to [machine]!"))
			return

	var/obj/structure/machinery/m56d_post/post = new(user.loc)
	post.setDir(user.dir) // Make sure we face the right direction
	post.gun_rounds = rounds
	post.gun_mounted = TRUE
	post.gun_health = health // retain damage
	post.anchored = TRUE
	post.update_icon()
	transfer_label_component(post)
	to_chat(user, SPAN_NOTICE("You deploy [src]."))
	qdel(src)


/obj/item/device/m56d_gun/mounted
	has_mount = TRUE
	rounds = 700

/obj/item/device/m56d_post_frame
	name = "\improper M56D folded mount frame"
	desc = "A flimsy frame of plasteel and metal. Still needs to be <b>welded</b> together."
	unacidable = TRUE
	w_class = SIZE_MEDIUM
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/hmg.dmi'
	icon_state = "folded_mount_frame"

/obj/item/device/m56d_post_frame/attackby(obj/item/W as obj, mob/user as mob)
	if (iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/WT = W

		if(WT.remove_fuel(1, user))
			var/obj/item/device/m56d_post/P = new(user.loc)
			to_chat(user, SPAN_NOTICE("You shape [src] into \a [P]."))
			qdel(src)
		return
	return ..()


/obj/item/device/m56d_post //Adding this because I was fucken stupid and put a obj/structure/machinery in a box. Realized I couldn't take it out
	name = "\improper M56D folded mount"
	desc = "The folded, foldable tripod mount for the M56D.  (Place on ground and drag to you to unfold)."
	unacidable = TRUE
	w_class = SIZE_MEDIUM
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/hmg.dmi'
	icon_state = "folded_mount"

/// Causes the tripod to unfold
/obj/item/device/m56d_post/attack_self(mob/user)
	..()

	if(!ishuman(usr) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return
	if(SSinterior.in_interior(user))
		to_chat(usr, SPAN_WARNING("It's too cramped in here to deploy \a [src]."))
		return
	var/area/area = get_area(user)
	if(!area.allow_construction)
		to_chat(user, SPAN_WARNING("You cannot install \the [src] here, find a more secure surface!"))
		return
	var/turf/T = get_turf(user)
	if(istype(T, /turf/open))
		var/turf/open/floor = T
		if(!floor.allow_construction)
			to_chat(user, SPAN_WARNING("You cannot install \the [src] here, find a more secure surface!"))
			return FALSE
	var/fail = FALSE
	if(T.density)
		fail = TRUE
	else
		for(var/obj/X in T.contents)
			if(X.density && !(X.flags_atom & ON_BORDER))
				fail = TRUE
				break
			if(istype(X, /obj/structure/machinery/defenses))
				fail = TRUE
				break
			else if(istype(X, /obj/structure/window))
				fail = TRUE
				break
			else if(istype(X, /obj/structure/windoor_assembly))
				fail = TRUE
				break
			else if(istype(X, /obj/structure/machinery/door))
				fail = TRUE
				break
	if(fail)
		to_chat(user, SPAN_WARNING("You can't install \the [src] here, something is in the way."))
		return

	to_chat(user, SPAN_NOTICE("You deploy \the [src]."))
	var/obj/structure/machinery/m56d_post/post = new(user.loc)
	transfer_label_component(post)
	qdel(src)


//The mount for the weapon.
/obj/structure/machinery/m56d_post
	name = "\improper M56D mount"
	desc = "A foldable tripod mount for the M56D, provides stability to the M56D."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/hmg.dmi'
	icon_state = "M56D_mount"
	anchored = FALSE
	density = TRUE
	layer = ABOVE_MOB_LAYER
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	///Whether a gun is mounted
	var/gun_mounted = FALSE
	///Ammo amount of the mounted gun
	var/gun_rounds = 0
	///Health of the mounted gun
	var/gun_health = 0
	health = 50

/obj/structure/machinery/m56d_post/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

//Making so rockets don't hit M56D
/obj/structure/machinery/m56d_post/calculate_cover_hit_boolean(obj/projectile/P, distance = 0, cade_direction_correct = FALSE)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & AMMO_ROCKET)
		return 0
	..()

/obj/structure/machinery/m56d_post/update_health(damage)
	health -= damage
	if(health <= 0)
		playsound(src, 'sound/effects/metal_crash.ogg', 25, 1)
		qdel(src)

/obj/structure/machinery/m56d_post/update_icon()
	var/icon_name = "M56D"
	if(gun_mounted)
		if(!gun_rounds)
			icon_name += "_e"
	else
		icon_name += "_mount"
	icon_state = icon_name

/obj/structure/machinery/m56d_post/get_examine_text(mob/user)
	. = ..()
	if(!anchored)
		. += "It must be <B>screwed</b> to the floor."
	else if(!gun_mounted)
		. += "The <b>M56D heavy machine gun</b> is not yet mounted."
	else
		. += "The M56D isn't screwed into the mount. Use a <b>screwdriver</b> to finish the job."

/obj/structure/machinery/m56d_post/attack_alien(mob/living/carbon/xenomorph/M)
	if(islarva(M))
		return //Larvae can't do shit

	M.visible_message(SPAN_DANGER("[M] has slashed [src]!"),
	SPAN_DANGER("You slash [src]!"))
	M.animation_attack_on(src)
	M.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	update_health(rand(M.melee_damage_lower,M.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/machinery/m56d_post/MouseDrop(over_object, src_location, over_location) //Drag the tripod onto you to fold it.
	var/mob/living/carbon/user = usr //this is us
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return
	if(over_object == user && in_range(src, user))
		if(anchored && gun_mounted)
			to_chat(user, SPAN_WARNING("\The [src] can't be folded while there's an unsecured gun mounted on it. Either complete the assembly or take the gun off with a crowbar."))
			return
		else if(anchored)
			to_chat(user, SPAN_WARNING("\The [src] can't be folded while screwed to the floor. Unscrew it first."))
			return
		to_chat(user, SPAN_NOTICE("You fold [src]."))
		var/obj/item/device/m56d_post/post = new(loc)
		transfer_label_component(post)
		user.put_in_hands(post)
		qdel(src)

/obj/structure/machinery/m56d_post/attackby(obj/item/O, mob/user)
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS)) //first make sure theres no funkiness
		return

	if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH)) //rotate the mount
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] rotates [src]."),SPAN_NOTICE("You rotate [src]."))
		setDir(turn(dir, -90))
		return

	if(istype(O,/obj/item/device/m56d_gun)) //lets mount the MG onto the mount.
		var/obj/item/device/m56d_gun/MG = O
		for(var/obj/structure/machinery/machine in long_orange(MG.defense_check_range, loc))
			if(istype(machine, /obj/structure/machinery/m56d_hmg) || istype(machine, /obj/structure/machinery/m56d_post))
				to_chat(user, SPAN_WARNING("This is too close to [machine]!"))
				return
		if(!anchored)
			to_chat(user, SPAN_WARNING("[src] must be anchored! Use a screwdriver!"))
			return
		to_chat(user, "You begin mounting [MG]...")
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && !gun_mounted && anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] installs [MG] into place."),SPAN_NOTICE("You install [MG] into place."))
			gun_mounted = 1
			gun_rounds = MG.rounds
			gun_health = MG.health
			MG.transfer_label_component(src)
			update_icon()
			user.temp_drop_inv_item(MG)
			qdel(MG)
		return

	if(istype(O,/obj/item/tool/crowbar))
		if(!gun_mounted)
			to_chat(user, SPAN_WARNING("There is no gun mounted."))
			return
		to_chat(user, "You begin dismounting [src]'s gun...")
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && gun_mounted)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] removes [src]'s gun."), SPAN_NOTICE("You remove [src]'s gun."))
			var/obj/item/device/m56d_gun/HMG = new(loc)
			HMG.rounds = gun_rounds
			if(gun_health)
				HMG.health = gun_health
			HMG.update_icon()
			transfer_label_component(HMG)
			var/datum/component/label/label = GetComponent(/datum/component/label)
			if(label)
				label.clear_label()
			gun_mounted = FALSE
			gun_rounds = 0
			gun_health = 0
			update_icon()
		return

	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		var/turf/T = get_turf(src)
		var/fail = FALSE
		if(T.density)
			fail = TRUE
		else
			for(var/obj/X in T.contents - src)
				if(X.density && !(X.flags_atom & ON_BORDER))
					fail = TRUE
					break
				if(istype(X, /obj/structure/machinery/defenses))
					fail = TRUE
					break
				else if(istype(X, /obj/structure/window))
					fail = TRUE
					break
				else if(istype(X, /obj/structure/windoor_assembly))
					fail = TRUE
					break
				else if(istype(X, /obj/structure/machinery/door))
					fail = TRUE
					break
		if(fail)
			to_chat(user, SPAN_WARNING("You can't install \the [src] here, something is in the way."))
			return
		var/area/area = get_area(src)
		if(!area.allow_construction)
			to_chat(user, SPAN_WARNING("You cannot install \the [src] here, find a more secure surface!"))
			return
		if(istype(T, /turf/open))
			var/turf/open/floor = T
			if(!floor.allow_construction)
				to_chat(user, SPAN_WARNING("You cannot install \the [src] here, find a more secure surface!"))
				return FALSE

		if(gun_mounted)
			to_chat(user, "You're securing the M56D into place...")

			var/disassemble_time = 30
			if(do_after(user, disassemble_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] screws the M56D into the mount."), SPAN_NOTICE("You finalize the M56D heavy machine gun."))
				var/obj/structure/machinery/m56d_hmg/HMG = new(loc)
				transfer_label_component(HMG)
				HMG.visible_message("[icon2html(HMG, viewers(src))] <B>\The [HMG] is now complete!</B>")
				HMG.setDir(dir)
				HMG.rounds = gun_rounds
				if(gun_health)
					HMG.health = gun_health
					HMG.update_damage_state()
				HMG.update_icon()
				qdel(src)
		else
			if(anchored)
				to_chat(user, "You begin unscrewing [src] from the ground...")
			else
				to_chat(user, "You begin screwing [src] into place...")

			var/old_anchored = anchored
			if(do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && anchored == old_anchored)
				anchored = !anchored
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(anchored)
					user.visible_message(SPAN_NOTICE("[user] anchors [src] into place."),SPAN_NOTICE("You anchor [src] into place."))
				else
					user.visible_message(SPAN_NOTICE("[user] unanchors [src]."),SPAN_NOTICE("You unanchor [src]."))
		return

	return ..()



// The actual Machinegun itself, going to borrow some stuff from current sentry code to make sure it functions. Also because they're similiar.
/obj/structure/machinery/m56d_hmg
	name = "\improper M56D heavy machine gun"
	desc = "A deployable, heavy machine gun. While it is capable of taking the same rounds as the M56, it fires specialized tungsten rounds for increased armor penetration.<br>Drag its sprite onto yourself to man it. Ctrl-click it to cycle through firemodes."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/hmg.dmi'
	icon_state = "M56D"
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE //stop the xeno me(l)ta.
	density = TRUE
	layer = ABOVE_MOB_LAYER //no hiding the hmg beind corpse
	use_power = USE_POWER_NONE
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	var/rounds = 0 //Have it be empty upon spawn.
	var/rounds_max = 700
	var/burst_scatter_mult = 4
	var/safety = FALSE
	health = 200
	var/health_max = 200 //Why not just give it sentry-tier health for now.
	var/atom/target = null // required for shooting at things.
	var/datum/ammo/bullet/machinegun/ammo = /datum/ammo/bullet/machinegun
	var/obj/projectile/in_chamber = null
	var/locked = 0 //1 means its locked inplace (this will be for sandbag MGs)
	var/muzzle_flash_lum = 4
	var/icon_full = "M56D" // Put this system in for other MGs or just other mounted weapons in general, future proofing.
	var/icon_empty = "M56D_e" //Empty
	var/zoom = 0 // 0 is it doesn't zoom, 1 is that it zooms.
	var/damage_state = M56D_DMG_NONE

	var/gun_noise = 'sound/weapons/gun_rifle.ogg' // Variations for gun noises for M56D, M2C, the auto one, uses a different set of sounds. emergency_cooling
	var/empty_alarm = 'sound/weapons/smg_empty_alarm.ogg'

	// Muzzle Flash Offsets
	var/north_x_offset = 0
	var/north_y_offset = 12
	var/east_x_offset = -4
	var/east_y_offset = 12
	var/south_x_offset = 0
	var/south_y_offset = 8
	var/west_x_offset = 4
	var/west_y_offset = 12

	// USED FOR ANIMATIONS AND ROTATIONS
	var/user_old_x = 0
	var/user_old_y = 0

	/// How much time should pass in between full auto shots, slightly higher than burst due to click delay and similar things that slow firing down
	var/fire_delay = 0.3 SECONDS
	/// How much time should pass in between burst fire shots
	var/burst_fire_delay = 0.2 SECONDS
	/// How many rounds are fired per burst
	var/burst_amount = 3
	/// How many rounds have been fired in the current burst/auto
	var/shots_fired = 0
	/// What firemode the gun is currently in
	var/gun_firemode = GUN_FIREMODE_AUTOMATIC
	/// What firemodes this gun has
	var/static/list/gun_firemodes = list(
		GUN_FIREMODE_SEMIAUTO,
		GUN_FIREMODE_AUTOMATIC,
	)
	/// A multiplier for how slow this gun should fire in automatic as opposed to burst. 1 is normal, 1.2 is 20% slower, 0.8 is 20% faster, etc.
	var/autofire_slow_mult = 1
	/// If the gun is currently burst firing
	VAR_PROTECTED/burst_firing = FALSE
	/// If the gun should display its ammo count
	var/display_ammo = TRUE
	/// How many degrees in each direction the gun should be able to fire
	var/shoot_degree = 80
	/// Semi auto cooldown
	COOLDOWN_DECLARE(semiauto_fire_cooldown)
	/// How long between semi-auto shots this should wait, to reduce possible spam
	var/semiauto_cooldown_time = 0.2 SECONDS

/obj/structure/machinery/m56d_hmg/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_AROUND|PASS_OVER_THROW_ITEM|PASS_OVER_THROW_MOB

///Turns the mouse cursor into a crosshair if new_cursor is set to TRUE. If set to FALSE, returns the cursor to its initial icon.
/obj/structure/machinery/m56d_hmg/proc/update_mouse_pointer(mob/user, new_cursor)
	if(!user.client?.prefs.custom_cursors)
		return

	user.client?.mouse_pointer_icon = new_cursor ? get_mouse_pointer() : initial(user.client?.mouse_pointer_icon)

///Getter proc. Returns the weapon's crosshair icon.
/obj/structure/machinery/m56d_hmg/proc/get_mouse_pointer()
	return 'icons/effects/mouse_pointer/lmg_mouse.dmi'

//Making so rockets don't hit M56D
/obj/structure/machinery/m56d_hmg/calculate_cover_hit_boolean(obj/projectile/P, distance = 0, cade_direction_correct = FALSE)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & AMMO_ROCKET)
		return 0
	..()

/obj/structure/machinery/m56d_hmg/BlockedPassDirs(atom/movable/mover, target_turf)
	if(istype(mover, /obj/item) && mover.throwing)
		return FALSE
	else
		return ..()

/obj/structure/machinery/m56d_hmg/Initialize(mapload, ...)
	. = ..()

	ammo = GLOB.ammo_list[ammo] //dunno how this works but just sliding this in from sentry-code.
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	update_icon()
	AddComponent(/datum/component/automatedfire/autofire, fire_delay, burst_fire_delay, burst_amount, gun_firemode, autofire_slow_mult, CALLBACK(src, PROC_REF(set_burst_firing)), CALLBACK(src, PROC_REF(reset_fire)), CALLBACK(src, PROC_REF(try_fire)), CALLBACK(src, PROC_REF(display_ammo)))

/obj/structure/machinery/m56d_hmg/Destroy(force) //Make sure we pick up our trash.
	operator?.unset_interaction()
	operator = null
	QDEL_NULL(in_chamber)
	STOP_PROCESSING(SSobj, src)
	ammo = null
	return ..()

/obj/structure/machinery/m56d_hmg/get_examine_text(mob/user) //Let us see how much ammo we got in this thing.
	. = ..()
	if(ishuman(user) || HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		. += "It is currently set to <b>[gun_firemode]</b>."
		if(rounds)
			. += SPAN_NOTICE("It has [rounds] round\s out of [rounds_max].")
		else
			. += SPAN_WARNING("It seems to be lacking ammo.")
		switch(damage_state)
			if(M56D_DMG_NONE) . += SPAN_INFO("It looks like it's in good shape.")
			if(M56D_DMG_SLIGHT) . += SPAN_WARNING("It has sustained some damage, but still fires very steadily.")
			if(M56D_DMG_MODERATE) . += SPAN_WARNING("It's damaged, but holding, rattling with each shot fired.")
			if(M56D_DMG_HEAVY) . += SPAN_WARNING("It's falling apart, barely able to handle the force of its own shots.")

/obj/structure/machinery/m56d_hmg/update_icon() //Lets generate the icon based on how much ammo it has.
	if(!rounds)
		icon_state = "[icon_empty]"
	else
		icon_state = "[icon_full]"
	return

/obj/structure/machinery/m56d_hmg/attackby(obj/item/O as obj, mob/user as mob) //This will be how we take it apart.
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return ..()

	if(QDELETED(O))
		return

	if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH)) // Let us rotate this stuff.
		if(locked)
			to_chat(user, "This one is anchored in place and cannot be rotated.")
			return
		else
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message("[user] rotates [src].", "You rotate [src].")
			setDir(turn(dir, -90))
			if(operator)
				update_pixels(operator)
		return

	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER)) // Lets take it apart.
		if(locked)
			to_chat(user, "This one cannot be disassembled.")
		else
			to_chat(user, "You begin disassembling [src]...")

			var/disassemble_time = 30
			if(do_after(user, disassemble_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(SPAN_NOTICE("[user] disassembles [src]!"), SPAN_NOTICE("You disassemble [src]!"))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				var/obj/item/device/m56d_gun/HMG = new(loc)
				transfer_label_component(HMG)
				HMG.rounds = rounds
				HMG.has_mount = TRUE
				HMG.health = health
				HMG.update_icon()
				qdel(src)
				return

	if(istype(O, /obj/item/ammo_magazine/m56d)) // RELOADING DOCTOR FREEMAN.
		var/obj/item/ammo_magazine/m56d/M = O
		if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
			if(rounds)
				to_chat(user, SPAN_WARNING("You only know how to swap the ammo drum when it's empty."))
				return
			if(user.action_busy)
				return
			if(!do_after(user, 25 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				return
		user.visible_message(SPAN_NOTICE("[user] loads [src]!"), SPAN_NOTICE("You load [src]!"))
		playsound(loc, 'sound/weapons/gun_minigun_cocked.ogg', 25, 1)
		if(rounds)
			var/obj/item/ammo_magazine/m56d/D = new(user.loc)
			D.current_rounds = rounds
		rounds = M.current_rounds
		update_icon()
		user.temp_drop_inv_item(O)
		qdel(O)
		return

	if(iswelder(O))
		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		if(user.action_busy)
			return

		var/obj/item/tool/weldingtool/WT = O

		if(health == health_max)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
				SPAN_NOTICE("You begin repairing the damage to [src]."))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			if(do_after(user, 5 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
					SPAN_NOTICE("You repair [src]."))
				update_health(-floor(health_max*0.2))
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("You need more fuel in [WT] to repair damage to [src]."))
		return
	return ..()

/obj/structure/machinery/m56d_hmg/update_health(amount) //Negative values restores health.
	health -= amount
	if(health <= 0)
		var/destroyed = rand(0,1) //Ammo cooks off or something. Who knows.
		playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		if(!destroyed)
			var/obj/item/device/m56d_gun/HMG = new(loc)
			transfer_label_component(HMG)
			HMG.rounds = rounds
		qdel(src)
		return

	if(health > health_max)
		health = health_max
	update_damage_state()
	update_icon()

/obj/structure/machinery/m56d_hmg/ex_act(severity)
	update_health(severity)
	return

/obj/structure/machinery/m56d_hmg/proc/exit_interaction()
	SIGNAL_HANDLER

	update_mouse_pointer(operator, FALSE)
	operator.unset_interaction()

/obj/structure/machinery/m56d_hmg/proc/update_damage_state()
	var/health_percent = floor(health/health_max * 100)
	switch(health_percent)
		if(0 to 25)
			damage_state = M56D_DMG_HEAVY
		if(25 to 50)
			damage_state = M56D_DMG_MODERATE
		if(50 to 75)
			damage_state = M56D_DMG_SLIGHT
		if(75 to INFINITY)
			damage_state = M56D_DMG_NONE

/obj/structure/machinery/m56d_hmg/bullet_act(obj/projectile/P) //Nope.
	bullet_ping(P)
	visible_message(SPAN_WARNING("[src] is hit by the [P.name]!"))
	update_health(floor(P.damage / 10)) //Universal low damage to what amounts to a post with a gun.
	return 1

/obj/structure/machinery/m56d_hmg/attack_alien(mob/living/carbon/xenomorph/xeno) // Those Ayy lmaos.
	if(islarva(xeno))
		return //Larvae can't do shit
	if(xeno.IsAdvancedToolUser() && xeno.a_intent == INTENT_HELP)
		try_mount_gun(xeno)
		return XENO_NO_DELAY_ACTION
	xeno.visible_message(SPAN_DANGER("[xeno] has slashed [src]!"),
	SPAN_DANGER("You slash [src]!"))
	xeno.animation_attack_on(src)
	xeno.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	update_health(rand(xeno.melee_damage_lower,xeno.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/machinery/m56d_hmg/proc/load_into_chamber()
	if(in_chamber)
		return 1 //Already set!
	if(rounds == 0)
		update_icon() //make sure the user can see the lack of ammo.
		return 0 //Out of ammo.

	var/datum/cause_data/cause_data = create_cause_data(initial(name))
	in_chamber = new /obj/projectile(loc, cause_data) //New bullet!
	in_chamber.generate_bullet(ammo)
	return 1

/obj/structure/machinery/m56d_hmg/proc/fire_shot() //Bang Bang
	if(!ammo || safety)
		return

	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)

	if (!istype(T) || !istype(U))
		return

	if(!load_into_chamber())
		return

	if(!istype(in_chamber, /obj/projectile))
		return

	var/angle = Get_Angle(T, U)

	if((dir == NORTH) && (angle > 180) && (abs(360 - angle) > shoot_degree)) // If north and shooting to the left, we do some extra math
		return

	if((dir == NORTH) && (angle < 180) && (angle > shoot_degree))
		return

	else if((dir != NORTH) && (abs(angle - dir2angle(dir)) > shoot_degree))
		return

	in_chamber.original = target

	var/initial_angle = Get_Angle(T, U)
	var/final_angle = initial_angle

	var/total_scatter_angle = get_scatter()

	if(total_scatter_angle > 0)
		final_angle += rand(-total_scatter_angle, total_scatter_angle)
		target = get_angle_target_turf(T, final_angle, 30)

	in_chamber.weapon_cause_data = create_cause_data(initial(name), operator)
	in_chamber.setDir(dir)
	in_chamber.def_zone = pick("chest","chest","chest","head")
	SEND_SIGNAL(in_chamber, COMSIG_BULLET_USER_EFFECTS, operator)
	playsound(loc, gun_noise, 50, 1)
	in_chamber.fire_at(target, operator, src, ammo.max_range, ammo.shell_speed)
	if(target)
		muzzle_flash(final_angle)
	in_chamber = null
	rounds--
	if(!rounds)
		handle_ammo_out()
	return AUTOFIRE_CONTINUE

/obj/structure/machinery/m56d_hmg/proc/get_scatter()
	var/total_scatter_angle = in_chamber.ammo.scatter

	if (shots_fired > 1)
		total_scatter_angle += burst_scatter_mult * (shots_fired -1)
	return total_scatter_angle

/obj/structure/machinery/m56d_hmg/proc/handle_ammo_out(mob/user)
	visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] [src] beeps steadily and its ammo light blinks red."))
	playsound(loc, empty_alarm, 25, 1)
	update_icon() //final safeguard.

/obj/structure/machinery/m56d_hmg/proc/try_fire()
	if(!operator)
		return
	if(!rounds)
		to_chat(operator, SPAN_WARNING("<b>*click*</b>"))
		playsound(src, 'sound/weapons/gun_empty.ogg', 25, 1, 5)
		return

	if(operator.l_hand || operator.r_hand)
		to_chat(operator, SPAN_WARNING("Your hands need to be free to fire [src]!"))
		return

	return fire_shot()

/obj/structure/machinery/m56d_hmg/proc/handle_outside_cone(mob/living/carbon/human/user)
	return FALSE

/obj/structure/machinery/m56d_hmg/proc/muzzle_flash(angle) // Might as well keep this too.
	if(isnull(angle))
		return

	set_light(muzzle_flash_lum)
	spawn(10)
		set_light(-muzzle_flash_lum)

	var/image_layer = layer + 0.1

	var/x_offset = 0
	var/y_offset = 8
	switch(dir)
		if(NORTH)
			x_offset = north_x_offset
			y_offset = north_y_offset
		if(EAST)
			x_offset = east_x_offset
			y_offset = east_y_offset
		if(SOUTH)
			x_offset = south_x_offset
			y_offset = south_y_offset
		if(WEST)
			x_offset = west_x_offset
			y_offset = west_y_offset

	var/image/I = image('icons/obj/items/weapons/projectiles.dmi', src, "muzzle_flash",image_layer)
	var/matrix/rotate = matrix() //Change the flash angle.
	rotate.Translate(x_offset, y_offset)
	rotate.Turn(angle)
	I.transform = rotate
	I.flick_overlay(src, 3)

/obj/structure/machinery/m56d_hmg/MouseDrop(over_object, src_location, over_location) //Drag the MG to us to man it.
	// If the gun sprite wasn't dragged onto the user, or the user isn't adjacent.
	if(over_object != usr || !in_range(src, usr))
		return
	// If the user is already manning the gun.
	if(operator == usr)
		// Exit the gun.
		usr.unset_interaction()
	else
		// Try to man the gun
		try_mount_gun(usr)

/obj/structure/machinery/m56d_hmg/proc/try_mount_gun(mob/living/carbon/user)
	// If the user isn't a human.
	if(!istype(user))
		return
	// If the user is unconscious or dead.
	if(user.stat)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		if(!human.allow_gun_usage)
			to_chat(user, SPAN_WARNING("You aren't allowed to use firearms!"))
			return
		if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/ceasefire))
			to_chat(human, SPAN_WARNING("You will not break the ceasefire by doing that!"))
			return FALSE
	// If the user isn't actually allowed to use guns.
	else if (!HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		to_chat(user, SPAN_WARNING("You don't know what to do with [src]!"))
		return

	// If the user is invisible.
	if(user.alpha <= 60)
		to_chat(user, SPAN_WARNING("You can't use [src] while cloaked!"))
		return

	// Make sure we're not manning two guns at once, tentacle arms.
	if(user.interactee)
		to_chat(user, SPAN_WARNING("You're already manning something!"))
		return

	// Check the directions opposite of where the gun is facing.
	var/found_user = FALSE
	var/turf/user_turf = get_turf(user)
	for(var/opposite_dir in reverse_nearby_direction(src.dir))
		if(get_step(src, opposite_dir) == user_turf)
			found_user = TRUE
			break
	// If the user isn't standing behind or on top of the gun.
	if(!found_user && user_turf != get_turf(src))
		to_chat(user, SPAN_WARNING("You are too far from the handles to man [src]!"))
		return

	// If there's already someone manning it.
	if(operator)
		// This shouldn't happen, but just in case.
		if(operator.interactee == null)
			operator = null
		else
			to_chat(user, SPAN_WARNING("Someone's already controlling [src]!"))
			return

	// If both hands aren't empty.
	if(user.get_active_hand() || user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need both hands free to grab the handles!"))
		return

	// Man the gun!
	user.set_interaction(src)

/obj/structure/machinery/m56d_hmg/on_set_interaction(mob/user)
	ADD_TRAIT(user, TRAIT_IMMOBILIZED, INTERACTION_TRAIT)
	give_action(user, /datum/action/human_action/mg_exit)
	user.forceMove(src.loc)
	user.setDir(dir)
	user.reset_view(src)
	user.status_flags |= IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] mans [src]."), SPAN_NOTICE("You man [src], locked and loaded!"))
	user_old_x = user.pixel_x
	user_old_y = user.pixel_y
	update_pixels(user)

	RegisterSignal(user, list(COMSIG_MOB_MG_EXIT, COMSIG_MOB_RESISTED, COMSIG_MOB_DEATH, COMSIG_LIVING_SET_BODY_POSITION), PROC_REF(exit_interaction))
	RegisterSignal(user, COMSIG_MOB_MOUSEDOWN, PROC_REF(start_fire))
	RegisterSignal(user, COMSIG_MOB_MOUSEDRAG, PROC_REF(change_target))
	RegisterSignal(user, COMSIG_MOB_MOUSEUP, PROC_REF(stop_fire))

	operator = user
	update_mouse_pointer(operator, TRUE)
	flags_atom |= RELAY_CLICK

/obj/structure/machinery/m56d_hmg/on_unset_interaction(mob/user)
	REMOVE_TRAIT(user, TRAIT_IMMOBILIZED, INTERACTION_TRAIT)
	remove_action(user, /datum/action/human_action/mg_exit)
	user.Move(get_step(src, reverse_direction(src.dir)))
	user.setDir(dir) //set the direction of the player to the direction the gun is facing
	user.reset_view(null)
	user.status_flags &= ~IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] lets go of [src]."), SPAN_NOTICE("You let go of [src], letting the gun rest."))
	user_old_x = 0 //reset our x
	user_old_y = 0 //reset our y
	update_pixels(user, FALSE)
	user.remove_temp_pass_flags(PASS_MOB_THRU) // this is necessary because being knocked over while using the gun makes you incorporeal

	SEND_SIGNAL(src, COMSIG_GUN_INTERRUPT_FIRE)
	UnregisterSignal(user, list(
		COMSIG_MOB_MG_EXIT,
		COMSIG_MOB_RESISTED,
		COMSIG_MOB_DEATH,
		COMSIG_LIVING_SET_BODY_POSITION,
		COMSIG_MOB_MOUSEUP,
		COMSIG_MOB_MOUSEDOWN,
		COMSIG_MOB_MOUSEDRAG,
	))

	if(operator == user) //We have no operator now
		operator = null
	flags_atom &= ~RELAY_CLICK


/obj/structure/machinery/m56d_hmg/proc/update_pixels(mob/user, mounting = TRUE)
	if(mounting)
		var/diff_x = 0
		var/diff_y = 0
		var/tilesize = 32
		var/viewoffset = zoom ? (tilesize * 5) : (tilesize * 2)
		switch(dir)
			if(NORTH)
				diff_y = -16 + user_old_y
				if(user.client)
					user.client.pixel_x = 0
					user.client.pixel_y = viewoffset
			if(SOUTH)
				diff_y = 16 + user_old_y
				if(user.client)
					user.client.pixel_x = 0
					user.client.pixel_y = -viewoffset
			if(EAST)
				diff_x = -16 + user_old_x
				if(user.client)
					user.client.pixel_x = viewoffset
					user.client.pixel_y = 0
			if(WEST)
				diff_x = 16 + user_old_x
				if(user.client)
					user.client.pixel_x = -viewoffset
					user.client.pixel_y = 0

		animate(user, pixel_x=diff_x, pixel_y=diff_y, 0.4 SECONDS)
	else
		if(user.client)
			user.client.change_view(GLOB.world_view_size)
			user.client.pixel_x = 0
			user.client.pixel_y = 0
		animate(user, pixel_x=user_old_x, pixel_y=user_old_y, 4, 1)

/obj/structure/machinery/m56d_hmg/check_eye(mob/living/user)
	if(user.body_position != STANDING_UP || get_dist(user,src) > 0 || user.is_mob_incapacitated() || !user.client)
		user.unset_interaction()

/obj/structure/machinery/m56d_hmg/clicked(mob/user, list/mods)
	if (mods[CTRL_CLICK])
		if(operator != user)
			return ..()//only the operatore can toggle fire mode
		if(!CAN_PICKUP(user, src))
			return ..()

		do_toggle_firemode(user)
		playsound(src, 'sound/items/Deconstruct.ogg', 25, 1)
		return TRUE
	return ..()

/obj/structure/machinery/m56d_hmg/proc/CrusherImpact()
	update_health(health_max * 0.2)
	if(operator)
		to_chat(operator, SPAN_HIGHDANGER("You are knocked off the gun by the sheer force of the ram!"))
		operator.unset_interaction()
		operator.apply_effect(3, WEAKEN)
		operator.emote("pain")

/// Getter for burst_firing
/obj/structure/machinery/m56d_hmg/proc/get_burst_firing()
	return burst_firing

/// Setter for burst_firing
/obj/structure/machinery/m56d_hmg/proc/set_burst_firing(bursting = FALSE)
	burst_firing = bursting

/// Clean up the target, shots fired, and other things related to when you stop firing
/obj/structure/machinery/m56d_hmg/proc/reset_fire()
	set_target(null)
	shots_fired = 0

///Set the target and take care of hard delete
/obj/structure/machinery/m56d_hmg/proc/set_target(atom/object)
	if(object == target || object == loc)
		return
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = object
	if(target)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clean_target), override = TRUE)

/// Print how much ammo is left to chat
/obj/structure/machinery/m56d_hmg/proc/display_ammo()
	if(!operator)
		return

	if(display_ammo)
		var/chambered = in_chamber ? TRUE : FALSE
		to_chat(operator, SPAN_DANGER("[rounds][chambered ? "+1" : ""] / [rounds_max] ROUNDS REMAINING"))

/// Toggles the gun's firemode one down the list
/obj/structure/machinery/m56d_hmg/proc/do_toggle_firemode(mob/user, new_firemode)
	if(get_burst_firing())//can't toggle mid burst
		return

	if(!length(gun_firemodes))
		CRASH("[src] called do_toggle_firemode() with an empty gun_firemodes")

	if(length(gun_firemodes) == 1)
		to_chat(user, SPAN_NOTICE("[icon2html(src, user)] This gun only has one firemode."))
		return

	if(new_firemode)
		if(!(new_firemode in gun_firemodes))
			CRASH("[src] called do_toggle_firemode() with [new_firemode] new_firemode, not on gun_firemodes")
		gun_firemode = new_firemode
	else
		var/mode_index = gun_firemodes.Find(gun_firemode)
		if(++mode_index <= length(gun_firemodes))
			gun_firemode = gun_firemodes[mode_index]
		else
			gun_firemode = gun_firemodes[1]

	playsound(user, 'sound/weapons/handling/gun_burst_toggle.ogg', 15, 1)

	to_chat(user, SPAN_NOTICE("[icon2html(src, user)] You switch to <b>[gun_firemode]</b>."))
	SEND_SIGNAL(src, COMSIG_GUN_FIRE_MODE_TOGGLE, gun_firemode)

///Set the target to its turf, so we keep shooting even when it was qdeled
/obj/structure/machinery/m56d_hmg/proc/clean_target()
	SIGNAL_HANDLER
	target = get_turf(target)

/obj/structure/machinery/m56d_hmg/proc/stop_fire()
	SIGNAL_HANDLER
	if(!target)
		return

	if(gun_firemode == GUN_FIREMODE_AUTOMATIC)
		reset_fire()
		display_ammo()
	SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)

///Update the target if you draged your mouse
/obj/structure/machinery/m56d_hmg/proc/change_target(datum/source, atom/src_object, atom/over_object, turf/src_location, turf/over_location, src_control, over_control, params)
	SIGNAL_HANDLER
	set_target(get_turf_on_clickcatcher(over_object, operator, params))
	operator?.face_atom(target)

///Check if the gun can fire and add it to bucket auto_fire system if needed, or just fire the gun if not
/obj/structure/machinery/m56d_hmg/proc/start_fire(datum/source, atom/object, turf/location, control, params, bypass_checks = FALSE)
	SIGNAL_HANDLER

	if (burst_firing)
		return

	var/list/modifiers = params2list(params)
	if(modifiers[SHIFT_CLICK] || modifiers[MIDDLE_CLICK] || modifiers[RIGHT_CLICK] || modifiers[BUTTON4] || modifiers[BUTTON5])
		return

	// Don't allow doing anything else if inside a container of some sort, like a locker.
	if(!isturf(operator.loc))
		return

	if(istype(object, /atom/movable/screen))
		return

	if(!bypass_checks)
		if(operator.throw_mode)
			return

		if(operator.Adjacent(object)) //Dealt with by attack code
			return

	if(QDELETED(object))
		return

	set_target(get_turf_on_clickcatcher(object, operator, params))
	if((gun_firemode == GUN_FIREMODE_SEMIAUTO) && COOLDOWN_FINISHED(src, semiauto_fire_cooldown))
		COOLDOWN_START(src, semiauto_fire_cooldown, semiauto_cooldown_time)
		fire_shot()
		reset_fire()
		display_ammo()
		return
	else if(gun_firemode != GUN_FIREMODE_SEMIAUTO)
		SEND_SIGNAL(src, COMSIG_GUN_FIRE)

/// setter for fire_delay
/obj/structure/machinery/m56d_hmg/proc/set_fire_delay(value)
	fire_delay = value
	SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay)

/// getter for fire_delay
/obj/structure/machinery/m56d_hmg/proc/get_fire_delay(value)
	return fire_delay

/// setter for burst_amount
/obj/structure/machinery/m56d_hmg/proc/set_burst_amount(value, mob/user)
	burst_amount = value
	SEND_SIGNAL(src, COMSIG_GUN_BURST_SHOTS_TO_FIRE_MODIFIED, burst_amount)

/// Setter for burst_delay
/obj/structure/machinery/m56d_hmg/proc/set_burst_fire_delay(value, mob/user)
	burst_fire_delay = value
	SEND_SIGNAL(src, COMSIG_GUN_BURST_SHOT_DELAY_MODIFIED, burst_fire_delay)

/obj/structure/machinery/m56d_hmg/mg_turret //Our mapbound version with stupid amounts of ammo.
	name = "\improper scoped M56D heavy machine gun nest"
	desc = "A scoped M56D heavy machine gun mounted upon a small reinforced post with sandbags to provide a small machine gun nest for all your defensive needs. Drag its sprite onto yourself to man it. Ctrl-click it to toggle burst fire."
	fire_delay = 2
	rounds = 1500
	rounds_max = 1500
	locked = 1
	projectile_coverage = PROJECTILE_COVERAGE_HIGH
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/hmg.dmi'
	zoom = 1
	ammo = /datum/ammo/bullet/machinegun/doorgun

/obj/structure/machinery/m56d_hmg/mg_turret/update_health(amount) //Negative values restores health.
	health -= amount
	if(health <= 0)
		playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		qdel(src)
		return

	if(health > health_max)
		health = health_max
	update_damage_state()
	update_icon()

/obj/structure/machinery/m56d_hmg/mg_turret/dropship
	name = "\improper scoped M56D heavy machine gun"
	desc = "A scoped M56D heavy machine gun mounted behind a metal shield. Drag its sprite onto yourself to man it. Ctrl-click it to toggle burst fire."
	icon_full = "towergun_folding"
	icon_empty = "towergun_folding"
	var/obj/structure/dropship_equipment/mg_holder/deployment_system

/obj/structure/machinery/m56d_hmg/mg_turret/dropship/Destroy()
	if(deployment_system)
		deployment_system.deployed_mg = null
		deployment_system = null
	return ..()
