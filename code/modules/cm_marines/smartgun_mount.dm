//////////////////////////////////////////////////////////////
//Mounted MG, Replacment for the current jury rig code.

//Adds a coin for engi vendors
/obj/item/coin/marine/engineer
	name = "marine engineer support token"
	desc = "Insert this into a engineer vendor in order to access a support weapon."
	icon_state = "coin_adamantine"

// First thing we need is the ammo drum for this thing.
/obj/item/ammo_magazine/m56d
	name = "M56D drum magazine (10x28mm Caseless)"
	desc = "A box of 700, 10x28mm caseless tungsten rounds for the M56D heavy machine gun system. Just click the M56D with this to reload it."
	w_class = SIZE_MEDIUM
	icon_state = "ammo_drum"
	flags_magazine = NO_FLAGS //can't be refilled or emptied by hand
	caliber = "10x28mm"
	max_rounds = 700
	default_ammo = /datum/ammo/bullet/smartgun
	gun_type = null



// Now we need a box for this.
/obj/item/storage/box/m56d_hmg
	name = "\improper M56D crate"
	desc = "A large metal case with Japanese writing on the top. However it also comes with English text to the side. This is a M56D heavy machine gun, it clearly has various labeled warnings. The most major one is that this does not have IFF features due to specialized ammo."
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56D_case" // I guess a placeholder? Not actually going to show up ingame for now.
	w_class = SIZE_HUGE
	storage_slots = 6
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/device/m56d_gun(src) //gun itself
			new /obj/item/ammo_magazine/m56d(src) //ammo for the gun
			new /obj/item/device/m56d_post(src) //post for the gun
			new /obj/item/tool/wrench(src) //wrench to hold it down into the ground
			new /obj/item/tool/screwdriver(src) //screw the gun onto the post.
			new /obj/item/ammo_magazine/m56d(src)



// The actual gun itself.
/obj/item/device/m56d_gun
	name = "\improper M56D heavy machine gun"
	desc = "The top half of a M56D heavy machine gun post. However it ain't much use without the tripod."
	unacidable = TRUE
	w_class = SIZE_HUGE
	flags_equip_slot = SLOT_BACK
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56D_gun_e"
	var/rounds = 0 // How many rounds are in the weapon. This is useful if we break down our guns.
	var/has_mount = FALSE // Indicates whether the M56D will come with its folding mount already attached

/obj/item/device/m56d_gun/New()
	update_icon()

/obj/item/device/m56d_gun/examine(mob/user as mob) //Let us see how much ammo we got in this thing.
	..()
	if(rounds)
		to_chat(usr, "It has [rounds] out of 700 rounds.")
	else
		to_chat(usr, "It seems to be lacking a ammo drum.")

/obj/item/device/m56d_gun/update_icon() //Lets generate the icon based on how much ammo it has.
	var/icon_name = "M56D_gun"
	if(has_mount)
		icon_name += "_mount"
	if(!rounds)
		icon_name += "_e"
	icon_state = icon_name
	return

/obj/item/device/m56d_gun/attackby(var/obj/item/O as obj, mob/user as mob)
	if(!ishuman(user))
		return

	if(isnull(O))
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
	if(!ishuman(user))
		return FALSE
	if(!has_mount)
		return FALSE
	if(do_after(user, 1 SECOND, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		var/obj/structure/machinery/m56d_post/M = new /obj/structure/machinery/m56d_post(user.loc)
		M.dir = user.dir // Make sure we face the right direction
		M.gun_rounds = src.rounds //Inherit the amount of ammo we had.
		M.gun_mounted = TRUE
		M.anchored = TRUE
		M.update_icon()
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
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "folded_mount_frame"

/obj/item/device/m56d_post_frame/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/tool/weldingtool))
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
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "folded_mount"

/obj/item/device/m56d_post/attack_self(mob/user) //click the tripod to unfold it.
	if(!ishuman(usr)) return
	to_chat(user, SPAN_NOTICE("You deploy [src]."))
	new /obj/structure/machinery/m56d_post(user.loc)
	qdel(src)


//The mount for the weapon.
/obj/structure/machinery/m56d_post
	name = "\improper M56D mount"
	desc = "A foldable tripod mount for the M56D, provides stability to the M56D."
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56D_mount"
	anchored = 0
	density = 1
	layer = ABOVE_MOB_LAYER
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	var/gun_mounted = FALSE //Has the gun been mounted?
	var/gun_rounds = 0 //Did the gun come with any ammo?
	health = 50

/obj/structure/machinery/m56d_post/BlockedPassDirs(atom/movable/mover, target_turf)
	if(istype(mover, /obj/item) && mover.throwing)
		return FALSE
	else
		return ..()

//Making so rockets don't hit M56D
/obj/structure/machinery/m56d_post/calculate_cover_hit_boolean(obj/item/projectile/P, var/distance = 0, var/cade_direction_correct = FALSE)
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

/obj/structure/machinery/m56d_post/examine(mob/user)
	..()
	if(!anchored)
		to_chat(user, "It must be <B>screwed</b> to the floor.")
	else if(!gun_mounted)
		to_chat(user, "The <b>M56D heavy machine gun</b> is not yet mounted.")
	else
		to_chat(user, "The M56D isn't screwed into the mount. Use a <b>screwdriver</b> to finish the job.")

/obj/structure/machinery/m56d_post/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) return //Larvae can't do shit
	M.visible_message(SPAN_DANGER("[M] has slashed [src]!"),
	SPAN_DANGER("You slash [src]!"))
	M.animation_attack_on(src)
	M.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	update_health(rand(M.melee_damage_lower,M.melee_damage_upper))

/obj/structure/machinery/m56d_post/MouseDrop(over_object, src_location, over_location) //Drag the tripod onto you to fold it.
	if(!ishuman(usr)) 
		return
	var/mob/living/carbon/human/user = usr //this is us
	if(over_object == user && in_range(src, user))
		if(anchored)
			to_chat(user, SPAN_WARNING("[src] can't be folded while screwed to the floor. Unscrew it first."))
			return
		to_chat(user, SPAN_NOTICE("You fold [src]."))
		var/obj/item/device/m56d_post/P = new(loc)
		user.put_in_hands(P)
		qdel(src)

/obj/structure/machinery/m56d_post/attackby(obj/item/O, mob/user)
	if(!ishuman(user)) //first make sure theres no funkiness
		return

	if(istype(O,/obj/item/tool/wrench)) //rotate the mount
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] rotates [src]."),SPAN_NOTICE("You rotate [src]."))
		switch(dir)
			if(NORTH)
				dir = EAST
			if(EAST)
				dir = SOUTH
			if(SOUTH)
				dir = WEST
			if(WEST)
				dir = NORTH
		return

	if(istype(O,/obj/item/device/m56d_gun)) //lets mount the MG onto the mount.
		var/obj/item/device/m56d_gun/MG = O
		if(!anchored)
			to_chat(user, SPAN_WARNING("[src] must be anchored! Use a screwdriver!"))
			return
		to_chat(user, "You begin mounting [MG]...")
		if(do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && !gun_mounted && anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] installs [MG] into place."),SPAN_NOTICE("You install [MG] into place."))
			gun_mounted = 1
			gun_rounds = MG.rounds
			update_icon()
			user.temp_drop_inv_item(MG)
			qdel(MG)
		return

	if(istype(O,/obj/item/tool/crowbar))
		if(!gun_mounted)
			to_chat(user, SPAN_WARNING("There is no gun mounted."))
			return
		to_chat(user, "You begin dismounting [src]'s gun...")
		if(do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && gun_mounted)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] removes [src]'s gun."),SPAN_NOTICE("You remove [src]'s gun."))
			var/obj/item/device/m56d_gun/G = new(loc)
			G.rounds = gun_rounds
			G.update_icon()
			gun_mounted = FALSE
			gun_rounds = 0
			update_icon()
		return

	if(istype(O,/obj/item/tool/screwdriver))
		if(gun_mounted)
			to_chat(user, "You're securing the M56D into place...")
			
			var/disassemble_time = 30
			if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_METAL))
				disassemble_time = 5

			if(do_after(user, disassemble_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] screws the M56D into the mount."),SPAN_NOTICE("You finalize the M56D heavy machine gun."))
				var/obj/structure/machinery/m56d_hmg/G = new(src.loc) //Here comes our new turret.
				G.visible_message("[htmlicon(G)] <B>[G] is now complete!</B>") //finished it for everyone to
				G.dir = src.dir //make sure we face the right direction
				G.rounds = src.gun_rounds //Inherent the amount of ammo we had.
				G.update_icon()
				qdel(src)
		else
			if(!anchored)
				var/turf/T = get_turf(src)
				var/fail = 0
				if(T.density)
					fail = 1
				else
					for(var/obj/X in T)
						if(X.density  && X != src && !(X.flags_atom & ON_BORDER))
							fail = 1
							break
				if(fail)
					to_chat(user, SPAN_WARNING("Can't install [src] here, something is in the way."))
					return
			if(anchored)
				to_chat(user, "You begin unscrewing [src] from the ground...")
			else
				to_chat(user, "You begin screwing [src] into place...")

			var/old_anchored = anchored
			if(do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && anchored == old_anchored)
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
	desc = "A deployable, heavy machine gun. While it is capable of taking the same rounds as the M56, it fires specialized tungsten rounds for increased armor penetration.<br>Drag its sprite onto yourself to man it. Ctrl-click it to toggle burst fire.<br> <span class='notice'>!!DANGER: M56D DOES NOT HAVE IFF FEATURES!!</span>"
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56D"
	anchored = 1
	unslashable = TRUE
	unacidable = TRUE //stop the xeno me(l)ta.
	density = 1
	layer = ABOVE_MOB_LAYER //no hiding the hmg beind corpse
	use_power = 0
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	var/rounds = 0 //Have it be empty upon spawn.
	var/rounds_max = 700
	var/fire_delay = 4 //Gotta have rounds down quick.
	var/last_fired = 0
	var/burst_fire = 0 //0 is non-burst mode, 1 is burst.
	var/burst_scatter_mult = 4
	var/safety = 0 //Weapon safety, 0 is weapons hot, 1 is safe.
	health = 200
	var/health_max = 200 //Why not just give it sentry-tier health for now.
	var/atom/target = null // required for shooting at things.
	var/datum/ammo/bullet/machinegun/ammo = /datum/ammo/bullet/machinegun
	var/obj/item/projectile/in_chamber = null
	var/locked = 0 //1 means its locked inplace (this will be for sandbag MGs)
	var/is_bursting = 0
	var/muzzle_flash_lum = 4
	var/icon_full = "M56D" // Put this system in for other MGs or just other mounted weapons in general, future proofing.
	var/icon_empty = "M56D_e" //Empty
	var/zoom = 0 // 0 is it doesn't zoom, 1 is that it zooms.
	var/damage_state = M56D_DMG_NONE

//Making so rockets don't hit M56D
/obj/structure/machinery/m56d_hmg/calculate_cover_hit_boolean(obj/item/projectile/P, var/distance = 0, var/cade_direction_correct = FALSE)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & AMMO_ROCKET)
		return 0
	..()

/obj/structure/machinery/m56d_hmg/BlockedPassDirs(atom/movable/mover, target_turf)
	if(istype(mover, /obj/item) && mover.throwing)
		return FALSE
	else
		return ..()

/obj/structure/machinery/m56d_hmg/New()
	ammo = ammo_list[ammo] //dunno how this works but just sliding this in from sentry-code.
	burst_scatter_mult = config.lmed_scatter_value
	update_icon()

/obj/structure/machinery/m56d_hmg/Dispose() //Make sure we pick up our trash.
	if(operator)
		operator.unset_interaction()
	SetLuminosity(0)
	processing_objects.Remove(src)
	. = ..()

/obj/structure/machinery/m56d_hmg/examine(mob/user) //Let us see how much ammo we got in this thing.
	..()
	if(ishuman(user))
		if(rounds)
			to_chat(user, SPAN_NOTICE("It has [rounds] round\s out of [rounds_max]."))
		else
			to_chat(user, SPAN_WARNING("It seems to be lacking ammo."))
		switch(damage_state)
			if(M56D_DMG_NONE) to_chat(user, SPAN_INFO("It looks goods like its in good shape."))
			if(M56D_DMG_SLIGHT) to_chat(user, SPAN_WARNING("It has sustained some damage, but still fires very steadily."))
			if(M56D_DMG_MODERATE) to_chat(user, SPAN_WARNING("It's damaged, but holding, rattling with each shot fired."))
			if(M56D_DMG_HEAVY) to_chat(user, SPAN_WARNING("It's falling apart, barely able to handle the force of its own shots."))

/obj/structure/machinery/m56d_hmg/update_icon() //Lets generate the icon based on how much ammo it has.
	if(!rounds)
		icon_state = "[icon_empty]"
	else
		icon_state = "[icon_full]"
	return

/obj/structure/machinery/m56d_hmg/attackby(var/obj/item/O as obj, mob/user as mob) //This will be how we take it apart.
	if(!ishuman(user))
		return ..()

	if(isnull(O))
		return

	if(istype(O,/obj/item/tool/wrench)) // Let us rotate this stuff.
		if(locked)
			to_chat(user, "This one is anchored in place and cannot be rotated.")
			return
		else
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message("[user] rotates the [src].","You rotate the [src].")
			switch(dir)
				if(NORTH)
					dir = EAST
				if(EAST)
					dir = SOUTH
				if(SOUTH)
					dir = WEST
				if(WEST)
					dir = NORTH
		return

	if(isscrewdriver(O)) // Lets take it apart.
		if(locked)
			to_chat(user, "This one cannot be disassembled.")
		else
			to_chat(user, "You begin disassembling [src]...")

			var/disassemble_time = 30
			if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_METAL))
				disassemble_time = 5

			if(do_after(user, disassemble_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(SPAN_NOTICE(" [user] disassembles [src]! "),SPAN_NOTICE(" You disassemble [src]!"))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				var/obj/item/device/m56d_gun/HMG = new(src.loc) //Here we generate our disassembled mg.
				HMG.rounds = src.rounds //Inherent the amount of ammo we had.
				HMG.has_mount = TRUE
				HMG.update_icon()
				qdel(src) //Now we clean up the constructed gun.
				return

	if(istype(O, /obj/item/ammo_magazine/m56d)) // RELOADING DOCTOR FREEMAN.
		var/obj/item/ammo_magazine/m56d/M = O
		if(!skillcheck(user, SKILL_HEAVY_WEAPONS, SKILL_HEAVY_WEAPONS_TRAINED))
			if(rounds)
				to_chat(user, SPAN_WARNING("You only know how to swap the ammo drum when it's empty."))
				return
			if(user.action_busy) return
			if(!do_after(user, 25, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				return
		user.visible_message(SPAN_NOTICE(" [user] loads [src]! "),SPAN_NOTICE(" You load [src]!"))
		playsound(loc, 'sound/weapons/gun_minigun_cocked.ogg', 25, 1)
		if(rounds)
			var/obj/item/ammo_magazine/m56d/D = new(user.loc)
			D.current_rounds = rounds
		rounds = min(rounds + M.current_rounds, rounds_max)
		update_icon()
		user.temp_drop_inv_item(O)
		qdel(O)
		return

	if(iswelder(O))
		if(user.action_busy)
			return
		
		var/obj/item/tool/weldingtool/WT = O

		if(health == health_max)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."), \
				SPAN_NOTICE("You begin repairing the damage to [src]."))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			if(do_after(user, SECONDS_5, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."), \
					SPAN_NOTICE("You repair [src]."))
				update_health(-round(health_max*0.2))
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
		if(!destroyed) new /obj/structure/machinery/m56d_post(loc)
		else
			var/obj/item/device/m56d_gun/HMG = new(loc)
			HMG.rounds = src.rounds //Inherent the amount of ammo we had.
		qdel(src)
		return

	if(health > health_max)
		health = health_max
	update_damage_state()
	update_icon()

/obj/structure/machinery/m56d_hmg/ex_act(severity)
	update_health(severity)
	return

/obj/structure/machinery/m56d_hmg/proc/update_damage_state()
	var/health_percent = round(health/health_max * 100)
	switch(health_percent)
		if(0 to 25) damage_state = M56D_DMG_HEAVY
		if(25 to 50) damage_state = M56D_DMG_MODERATE
		if(50 to 75) damage_state = M56D_DMG_SLIGHT
		if(75 to INFINITY) damage_state = M56D_DMG_NONE

/obj/structure/machinery/m56d_hmg/bullet_act(var/obj/item/projectile/P) //Nope.
	bullet_ping(P)
	visible_message(SPAN_WARNING("[src] is hit by the [P.name]!"))
	update_health(round(P.damage / 10)) //Universal low damage to what amounts to a post with a gun.
	return 1

/obj/structure/machinery/m56d_hmg/attack_alien(mob/living/carbon/Xenomorph/M) // Those Ayy lmaos.
	if(isXenoLarva(M)) return //Larvae can't do shit
	M.visible_message(SPAN_DANGER("[M] has slashed [src]!"),
	SPAN_DANGER("You slash [src]!"))
	M.animation_attack_on(src)
	M.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	update_health(rand(M.melee_damage_lower,M.melee_damage_upper))

/obj/structure/machinery/m56d_hmg/proc/load_into_chamber()
	if(in_chamber) return 1 //Already set!
	if(rounds == 0)
		update_icon() //make sure the user can see the lack of ammo.
		return 0 //Out of ammo.

	in_chamber = new /obj/item/projectile(initial(name), null, loc) //New bullet!
	in_chamber.generate_bullet(ammo)
	return 1

/obj/structure/machinery/m56d_hmg/proc/process_shot(var/mob/user)
	set waitfor = 0

	if(isnull(target)) return //Acqure our victim.

	if(!ammo)
		update_icon() //safeguard.
		return

	if(burst_fire && target && !last_fired)
		if(rounds > 3)
			for(var/i = 1 to 3)
				is_bursting = 1
				fire_shot(i, user)
				sleep(2)
			spawn(0)
				last_fired = 1
			spawn(fire_delay)
				last_fired = 0
		else burst_fire = 0
		is_bursting = 0

	if(!burst_fire && target && !last_fired)
		fire_shot(1, user)

	target = null

/obj/structure/machinery/m56d_hmg/proc/fire_shot(shots_fired = 1, var/mob/user) //Bang Bang
	if(!ammo) return //No ammo.
	if(last_fired) return //still shooting.

	if(!is_bursting)
		last_fired = 1
		spawn(fire_delay)
			last_fired = 0

	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)

	if (!istype(T) || !istype(U))
		return

	if(load_into_chamber() == 1)
		if(istype(in_chamber,/obj/item/projectile))
			in_chamber.original = target

			var/initial_angle = Get_Angle(T, U)
			var/final_angle = initial_angle


			var/total_scatter_angle = in_chamber.ammo.scatter

			if (shots_fired > 1)
				total_scatter_angle += burst_scatter_mult * (shots_fired -1)

			if(total_scatter_angle > 0)
				final_angle += rand(-total_scatter_angle, total_scatter_angle)
				target = get_angle_target_turf(T, final_angle, 30)

			in_chamber.weapon_source_mob = user
			in_chamber.dir = src.dir
			in_chamber.def_zone = pick("chest","chest","chest","head")
			playsound(src.loc, 'sound/weapons/gun_rifle.ogg', 75, 1)
			in_chamber.fire_at(target,src,null,ammo.max_range,ammo.shell_speed)
			if(target)
				muzzle_flash(final_angle)
			in_chamber = null
			rounds--
			if(!rounds)
				visible_message(SPAN_NOTICE(" [htmlicon(src, viewers(src))] \The M56D beeps steadily and its ammo light blinks red."))
				playsound(src.loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)
				update_icon() //final safeguard.
	return

// New proc for MGs and stuff replaced handle_manual_fire(). Same arguements though, so alls good.
/obj/structure/machinery/m56d_hmg/handle_click(mob/living/carbon/human/user, atom/A, var/list/mods)
	if(!operator) return HANDLE_CLICK_UNHANDLED
	if(operator != user) return HANDLE_CLICK_UNHANDLED
	if(istype(A,/obj/screen)) return HANDLE_CLICK_UNHANDLED
	if(is_bursting) return HANDLE_CLICK_UNHANDLED
	if(user.lying || get_dist(user,src) > 1 || user.is_mob_incapacitated())
		user.unset_interaction()
		return HANDLE_CLICK_UNHANDLED
	if(user.get_active_hand())
		to_chat(usr, SPAN_WARNING("You need a free hand to shoot the [src]."))
		return HANDLE_CLICK_UNHANDLED

	target = A
	if(!istype(target))
		return HANDLE_CLICK_UNHANDLED

	if(target.z != src.z || target.z == 0 || src.z == 0 || isnull(operator.loc) || isnull(src.loc))
		return HANDLE_CLICK_UNHANDLED

	if(get_dist(target,src.loc) > 15)
		return HANDLE_CLICK_UNHANDLED

	if(mods["middle"] || mods["shift"] || mods["alt"] || mods["ctrl"])
		return HANDLE_CLICK_PASS_THRU

	var/angle = get_dir(src,target)
	//we can only fire in a 90 degree cone
	if((dir & angle) && target.loc != src.loc && target.loc != operator.loc)

		if(!rounds)
			to_chat(user, SPAN_WARNING("<b>*click*</b>"))
			playsound(src, 'sound/weapons/gun_empty.ogg', 25, 1, 5)
		else
			process_shot(user)
		return HANDLE_CLICK_HANDLED

	return HANDLE_CLICK_UNHANDLED

/obj/structure/machinery/m56d_hmg/proc/muzzle_flash(var/angle) // Might as well keep this too.
	if(isnull(angle)) return

	SetLuminosity(muzzle_flash_lum)
	spawn(10)
		SetLuminosity(-muzzle_flash_lum)

	var/image_layer = layer + 0.1
	var/offset = 8

	var/image/I = image('icons/obj/items/weapons/projectiles.dmi', src, "muzzle_flash",image_layer)
	var/matrix/rotate = matrix() //Change the flash angle.
	rotate.Translate(0, offset)
	rotate.Turn(angle)
	I.transform = rotate
	I.flick_overlay(src, 3)

/obj/structure/machinery/m56d_hmg/MouseDrop(over_object, src_location, over_location) //Drag the MG to us to man it.
	if(!ishuman(usr)) 
		return
	var/mob/living/carbon/human/user = usr //this is us

	if(!Adjacent(user)) 
		return
	src.add_fingerprint(usr)
	if((over_object == user && (in_range(src, user) || locate(src) in user))) //Make sure its on ourselves
		if(user.interactee == src)
			user.unset_interaction()
			visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("[user] decided to let someone else have a go ")]")
			to_chat(usr, SPAN_NOTICE("You decided to let someone else have a go on the MG "))
			return
		if(operator) //If there is already a operator then they're manning it.
			if(operator.interactee == null)
				operator = null //this shouldn't happen, but just in case
			else
				to_chat(user, "Someone's already controlling it.")
				return
		else
			if(user.interactee) //Make sure we're not manning two guns at once, tentacle arms.
				to_chat(user, "You're already manning something!")
				return
			if(user.get_active_hand() != null)
				to_chat(user, SPAN_WARNING("You need a free hand to man the [src]."))
			else
				visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("[user] mans the M56D!")]")
				to_chat(user, SPAN_NOTICE("You man the gun!"))
				user.set_interaction(src)

/obj/structure/machinery/m56d_hmg/on_set_interaction(mob/user)
	flags_atom |= RELAY_CLICK
	user.status_flags |= IMMOBILE_ACTION
	user.reset_view(src)
	if(zoom)
		var/tilesize = 32
		var/viewoffset = tilesize * 5
		switch(dir)
			if(NORTH)
				user.client.pixel_x = 0
				user.client.pixel_y = viewoffset
			if(SOUTH)
				user.client.pixel_x = 0
				user.client.pixel_y = -viewoffset
			if(EAST)
				user.client.pixel_x = viewoffset
				user.client.pixel_y = 0
			if(WEST)
				user.client.pixel_x = -viewoffset
				user.client.pixel_y = 0
	operator = user

/obj/structure/machinery/m56d_hmg/on_unset_interaction(mob/user)
	flags_atom &= ~RELAY_CLICK
	user.status_flags &= ~IMMOBILE_ACTION
	user.reset_view(null)
	if(zoom && user.client)
		user.client.change_view(world_view_size)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
	if(operator == user)
		operator = null

/obj/structure/machinery/m56d_hmg/check_eye(mob/user)
	if(user.lying || get_dist(user,src) > 1 || user.is_mob_incapacitated() || !user.client)
		user.unset_interaction()

/obj/structure/machinery/m56d_hmg/clicked(var/mob/user, var/list/mods) //Making it possible to toggle burst fire. Perhaps have altclick be the safety on the gun?
	if (isobserver(user)) return

	if (mods["ctrl"])
		if(operator != user) return //only the operatore can toggle fire mode
		burst_fire = !burst_fire
		to_chat(user, SPAN_NOTICE("You set [src] to [burst_fire ? "burst fire" : "single fire"] mode."))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
		return 1
	return ..()

/obj/structure/machinery/m56d_hmg/Collided(atom/movable/AM)
	..()

	if(istype(AM, /mob/living/carbon/Xenomorph/Crusher))
		update_health(400)


/obj/structure/machinery/m56d_hmg/mg_turret //Our mapbound version with stupid amounts of ammo.
	name = "\improper scoped M56D heavy machine gun nest"
	desc = "A scoped M56D heavy machine gun mounted upon a small reinforced post with sandbags to provide a small machine gun nest for all your defensive needs. Drag its sprite onto yourself to man it. Ctrl-click it to toggle burst fire. <span class='notice'>!!DANGER: M56D DOES NOT HAVE IFF FEATURES!!</span>"
	burst_fire = 1
	fire_delay = 2
	rounds = 1500
	rounds_max = 1500
	locked = 1
	projectile_coverage = PROJECTILE_COVERAGE_HIGH
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_full = "towergun"
	icon_empty = "towergun"
	zoom = 1

/obj/structure/machinery/m56d_hmg/mg_turret/dropship
	name = "\improper scoped M56D heavy machine gun"
	desc = "A scoped M56D heavy machine gun mounted behind a metal shield. Drag its sprite onto yourself to man it. Ctrl-click it to toggle burst fire. <span class='notice'>!!DANGER: M56D DOES NOT HAVE IFF FEATURES!!</span>"
	icon_full = "towergun_folding"
	icon_empty = "towergun_folding"
	var/obj/structure/dropship_equipment/mg_holder/deployment_system

	Dispose()
		if(deployment_system)
			deployment_system.deployed_mg = null
			deployment_system = null
		. = ..()