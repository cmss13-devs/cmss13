#define M2C_SETUP_TIME 4
#define M2C_OVERHEAT_CRITICAL 18
#define M2C_OVERHEAT_BAD 10
#define M2C_OVERHEAT_OK 2
#define M2C_OVERHEAT_DAMAGE 30
#define M2C_LOW_COOLDOWN_ROLL 0.3
#define M2C_HIGH_COOLDOWN_ROLL 0.45
#define M2C_PASSIVE_COOLDOWN_AMOUNT 3
#define M2C_OVERHEAT_OVERLAY 14
#define M2C_CRUSHER_STUN 3

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

/obj/item/storage/box/m56d_hmg/Initialize()
	. = ..()
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
	..()

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
	if(!ishuman(user))
		return FALSE
	if(!has_mount)
		return FALSE
	if(user.z == GLOB.interior_manager.interior_z)
		to_chat(usr, SPAN_WARNING("It's too cramped in here to deploy \a [src]."))
		return
	if(do_after(user, 1 SECOND, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		var/obj/structure/machinery/m56d_post/M = new /obj/structure/machinery/m56d_post(user.loc)
		M.setDir(user.dir) // Make sure we face the right direction
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
	if(!ishuman(usr))
		return
	if(user.z == GLOB.interior_manager.interior_z)
		to_chat(usr, SPAN_WARNING("It's too cramped in here to deploy \a [src]."))
		return
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

/obj/structure/machinery/m56d_post/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

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
		setDir(turn(dir, -90))
		return

	if(istype(O,/obj/item/device/m56d_gun)) //lets mount the MG onto the mount.
		var/obj/item/device/m56d_gun/MG = O
		if(!anchored)
			to_chat(user, SPAN_WARNING("[src] must be anchored! Use a screwdriver!"))
			return
		to_chat(user, "You begin mounting [MG]...")
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && !gun_mounted && anchored)
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
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && gun_mounted)
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
			if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				disassemble_time = 5

			if(do_after(user, disassemble_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] screws the M56D into the mount."),SPAN_NOTICE("You finalize the M56D heavy machine gun."))
				var/obj/structure/machinery/m56d_hmg/G = new(src.loc) //Here comes our new turret.
				G.visible_message("[icon2html(G)] <B>[G] is now complete!</B>") //finished it for everyone to
				G.setDir(dir) //make sure we face the right direction
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

	var/gun_noise = 'sound/weapons/gun_rifle.ogg' // Variations for gun noises for M56D, M56DE, the auto one, uses a different set of sounds. emergency_cooling
	var/empty_alarm = 'sound/weapons/smg_empty_alarm.ogg'

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
	..()

	ammo = ammo_list[ammo] //dunno how this works but just sliding this in from sentry-code.
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	update_icon()

/obj/structure/machinery/m56d_hmg/Destroy() //Make sure we pick up our trash.
	if(operator)
		operator.unset_interaction()
	SetLuminosity(0)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/machinery/m56d_hmg/examine(mob/user) //Let us see how much ammo we got in this thing.
	..()
	if(ishuman(user))
		if(rounds)
			to_chat(user, SPAN_NOTICE("It has [rounds] round\s out of [rounds_max]."))
		else
			to_chat(user, SPAN_WARNING("It seems to be lacking ammo."))
		switch(damage_state)
			if(M56D_DMG_NONE) to_chat(user, SPAN_INFO("It looks like it's in good shape."))
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

	if(QDELETED(O))
		return

	if(istype(O,/obj/item/tool/wrench)) // Let us rotate this stuff.
		if(locked)
			to_chat(user, "This one is anchored in place and cannot be rotated.")
			return
		else
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message("[user] rotates the [src].","You rotate the [src].")
			setDir(turn(dir, -90))
		return

	if(isscrewdriver(O)) // Lets take it apart.
		if(locked)
			to_chat(user, "This one cannot be disassembled.")
		else
			to_chat(user, "You begin disassembling [src]...")

			var/disassemble_time = 30
			if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				disassemble_time = 5

			if(do_after(user, disassemble_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
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
		if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_DEFAULT))
			if(rounds)
				to_chat(user, SPAN_WARNING("You only know how to swap the ammo drum when it's empty."))
				return
			if(user.action_busy) return
			if(!do_after(user, 25 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
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
			if(do_after(user, SECONDS_5 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
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
	set waitfor = FALSE

	if(isnull(target))
		return //Acqure our victim.

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

			var/total_scatter_angle = get_scatter()

			if(total_scatter_angle > 0)
				final_angle += rand(-total_scatter_angle, total_scatter_angle)
				target = get_angle_target_turf(T, final_angle, 30)

			in_chamber.weapon_source_mob = user
			in_chamber.setDir(dir)
			in_chamber.def_zone = pick("chest","chest","chest","head")
			playsound(loc,gun_noise, 50, 1)
			in_chamber.fire_at(target,user,src,ammo.max_range,ammo.shell_speed)
			if(target)
				muzzle_flash(final_angle)
			in_chamber = null
			rounds--
			if(!rounds)
				handle_ammo_out()
	return

/obj/structure/machinery/m56d_hmg/proc/get_scatter(shots_fired = 1)
	var/total_scatter_angle = in_chamber.ammo.scatter

	if (shots_fired > 1)
		total_scatter_angle += burst_scatter_mult * (shots_fired -1)
	return total_scatter_angle

/obj/structure/machinery/m56d_hmg/proc/handle_ammo_out(mob/user)
	visible_message(SPAN_NOTICE(" [icon2html(src, viewers(src))] [src] beeps steadily and its ammo light blinks red."))
	playsound(loc, empty_alarm, 25, 1)
	update_icon() //final safeguard.

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
			visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("[user] decided to let someone else have a go ")]")
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
				visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("[user] mans the M56D!")]")
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

/obj/structure/machinery/m56d_hmg/proc/CrusherImpact()
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

/obj/structure/machinery/m56d_hmg/mg_turret/dropship/Destroy()
	if(deployment_system)
		deployment_system.deployed_mg = null
		deployment_system = null
	return ..()

/*M2C HEAVY MACHINEGUN AND ITS COMPONENTS */
// AMMO
/obj/item/ammo_magazine/m2c
	name = "M2C Ammunition Box (10x28mm tungsten rounds)"
	desc = "A box of 125, 10x28mm tungsten rounds for the M2 Heavy Machinegun System. Click the heavy machinegun while there's no ammo box loaded to reload the M2C."
	w_class = SIZE_LARGE
	icon = 'icons/obj/items/weapons/guns/ammo.dmi'
	icon_state = "m56de"
	item_state = "m56de"
	max_rounds = 125
	default_ammo = /datum/ammo/bullet/smartgun
	gun_type = null

//STORAGE BOX FOR THE MACHINEGUN
/obj/item/storage/box/m56d/m2c
	name = "\improper M2C Assembly-Supply Crate"
	desc = "A large case labelled 'M2C, 10x28mm caliber heavy machinegun', seems to be fairly heavy to hold. contains a deadly M2C Heavy Machinegun System and its ammunition."
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56D_case"
	w_class = SIZE_HUGE
	storage_slots = 5

/obj/item/storage/box/m56d/m2c/Initialize()
	..()

	new /obj/item/device/m2c_gun(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/ammo_magazine/m2c(src)

// THE GUN ITSELF

/obj/item/device/m2c_gun
	name = "\improper M2C heavy machine gun"
	desc = "The disassembled M2C HMG, with its telescopic tripods folded up and unable to fire."
	unacidable = TRUE
	w_class = SIZE_HUGE
	flags_equip_slot = SLOT_BACK
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56DE_gun_mount"
	item_state = "M56DE_gun_mount"
	var/rounds = 0
	var/overheat_value = 0
	var/anti_cadehugger_range = 1
	var/broken_gun = FALSE
	var/field_recovery = 130
	health = 230

/obj/item/device/m2c_gun/Initialize()
	. = ..()
	update_icon()

/obj/item/device/m2c_gun/update_icon() //Lets generate the icon based on how much ammo it has.
	var/icon_name = initial(icon_state)
	if(broken_gun)
		icon_name += "_broken"
		if(!rounds)
			icon_name += "_e"

	else if(!broken_gun && !rounds)
		icon_name += "_e"

	icon_state = icon_name

/obj/item/device/m2c_gun/attack_self(mob/user)
	if(!ishuman(user))
		return FALSE
	var/turf/rotate_check = get_step(user.loc, turn(user.dir,180))
	var/turf/open/OT = usr.loc
	var/list/ACR = range(anti_cadehugger_range, user.loc)
	if(OT.density)
		to_chat(user, SPAN_WARNING("You can't set up [src] here."))
		return
	if(rotate_check.density)
		to_chat(user, SPAN_WARNING("You can't set up [src] that way, there's a wall behind you!"))
		return
	if((locate(/obj/structure/barricade) in ACR) || (locate(/obj/structure/window_frame) in ACR))
		to_chat(user, SPAN_WARNING("There's barriers nearby, you can't set up here!"))
		return
	if(broken_gun)
		to_chat(user, SPAN_WARNING("You can't set up [src], it's completely broken!"))
		return
	if(!(user.alpha > 60))
		to_chat(user, SPAN_WARNING("You can't set this up while cloaked!"))
		return

	if(!do_after(user, M2C_SETUP_TIME , INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
		return
	var/obj/structure/machinery/m56d_hmg/auto/M = new /obj/structure/machinery/m56d_hmg/auto(user.loc)
	M.setDir(user.dir) // Make sure we face the right direction
	M.anchored = TRUE
	playsound(M, 'sound/items/m56dauto_setup.ogg', 75, 1)
	to_chat(user, SPAN_NOTICE("You deploy [M]."))
	if((rounds > 0) && !user.get_inactive_hand())
		user.set_interaction(M)
	M.rounds = rounds
	M.overheat_value = overheat_value
	M.health = health
	M.update_icon()
	qdel(src)

/obj/item/device/m2c_gun/attackby(var/obj/item/O as obj, mob/user as mob)
	if(!ishuman(user))
		return

	if(!iswelder(O) || user.action_busy)
		return

	if(!broken_gun)
		to_chat(user, SPAN_WARNING("[src] isn't critically broken, no need for field recovery operations."))
		return

	var/obj/item/tool/weldingtool/WT = O

	if(WT.remove_fuel(2, user))
		user.visible_message(SPAN_NOTICE("[user] begins field recovering [src]."), \
			SPAN_NOTICE("You begin repairing the severe damages on the [src] in an effort to restore its functions."))
		playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		if(!do_after(user, field_recovery * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
			return
		user.visible_message(SPAN_NOTICE("[user] field recovers [src], restoring it back to its original state."), \
			SPAN_NOTICE("You repair [src] back to a functional state."))
		broken_gun = FALSE
		unacidable = TRUE
		health = 110
		update_icon()
		return
	else
		to_chat(user, SPAN_WARNING("You need more fuel in [WT] to start field recovery on [src]."))

// MACHINEGUN, AUTOMATIC
/obj/structure/machinery/m56d_hmg/auto
	name = "\improper M2C Heavy Machinegun"
	desc = "A deployable, heavy machine gun. The M2C 'Chimp' HB is a modified M2 HB recongifured to fire 10x28 Caseless Tungsten rounds for USCM use. It is capable of recoiless fire and fast-rotating. However it has a debilitating overheating issue due to the poor quality of metals used in the parts, forcing it to be used in decisive, crushing engagements as a squad support weapon. <B> Click its sprite while behind it without holding anything to man it. Click-drag on NON-GRAB intent to disassemble the gun, GRAB INTENT to remove ammo magazines."
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56DE"
	icon_full = "M56DE"
	icon_empty = "M56DE_e"
	rounds_max = 125
	ammo = /datum/ammo/bullet/machinegun/auto
	fire_delay = 1.2
	last_fired = 0
	var/grip_dir = null
	var/fold_time = 24
	var/repair_time = 5 SECONDS
	density = 1
	health = 230
	health_max = 230
	var/list/cadeblockers = list()
	var/cadeblockers_range = 1

	// USED FOR ANIMATIONS AND ROTATIONS
	var/user_old_x = 0
	var/user_old_y = 0

	gun_noise = 'sound/weapons/gun_m56d_auto.ogg'
	empty_alarm = 'sound/weapons/hmg_eject_mag.ogg'

	// OVERHEAT MECHANIC VARIABLES
	var/overheat_value = 0
	var/overheat_threshold = 30
	var/emergency_cooling = FALSE
	var/overheat_text_cooldown = 0
	var/force_cooldown_timer = 12
	var/rotate_timer = 0
	var/fire_stopper = FALSE

// ANTI-CADE EFFECT, CREDIT TO WALTERMELDRON

/obj/structure/machinery/m56d_hmg/auto/Initialize()
	. = ..()
	for(var/turf/T in range(cadeblockers_range, src))
		var/obj/structure/blocker/anti_cade/CB = new(T)
		CB.hmg = src

		cadeblockers.Add(CB)

/obj/structure/machinery/m56d_hmg/auto/Destroy()
	QDEL_NULL_LIST(cadeblockers)
	return ..()

/obj/structure/machinery/m56d_hmg/auto/process()

	var/mob/user = operator
	overheat_value -= M2C_PASSIVE_COOLDOWN_AMOUNT
	if(overheat_value <= 0)
		overheat_value = 0
		STOP_PROCESSING(SSobj, src)

	if(overheat_value >= M2C_OVERHEAT_CRITICAL)
		to_chat(user, SPAN_HIGHDANGER("[src]'s barrel is critically hot, it might start melting at this rate."))
	else if(overheat_value >= M2C_OVERHEAT_BAD)
		to_chat(user, SPAN_DANGER("[src]'s barrel is terribly hot, but is still able to fire."))
	else if(overheat_value  >= M2C_OVERHEAT_OK)
		to_chat(user, SPAN_DANGER("[src]'s barrel is pretty hot, although it's still stable."))
	else if (overheat_value > 0)
		to_chat(user, SPAN_WARNING("[src]'s barrel is mildly warm."))

	update_icon()

// ANTI-CADE EFFECT, CREDIT TO WALTERMELDRON
/obj/structure/blocker/anti_cade
	health = INFINITY
	anchored = 1
	density = 0
	unacidable = TRUE
	indestructible = TRUE
	invisibility = 101 // no looking at it with alt click

	var/obj/structure/machinery/m56d_hmg/auto/hmg

	alpha = 0

/obj/structure/blocker/anti_cade/BlockedPassDirs(atom/movable/AM, target_dir)
	if(istype(AM, /obj/structure/barricade))
		return BLOCKED_MOVEMENT

	return ..()

/obj/structure/blocker/anti_cade/Destroy()
	if(hmg)
		hmg.cadeblockers.Remove(src)
		hmg = null

	return ..()

/obj/structure/machinery/m56d_hmg/auto/update_icon() //Lets generate the icon based on how much ammo it has.
	if(!rounds)
		icon_state = "[icon_empty]"
	else
		icon_state = "[icon_full]"

	if(overheat_value >= M2C_OVERHEAT_OVERLAY)
		overlays += image('icons/turf/whiskeyoutpost.dmi', "+m56de_overheat")

	else
		overlays -= image('icons/turf/whiskeyoutpost.dmi', "+m56de_overheat")

// DED

/obj/structure/machinery/m56d_hmg/auto/update_health(amount) //Negative values restores health.
	health -= amount
	if(health <= 0)
		playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		visible_message(SPAN_WARNING("[src] has broken down completely!"))
		var/obj/item/device/m2c_gun/HMG = new(src.loc)
		HMG.rounds = rounds
		HMG.broken_gun = TRUE
		HMG.unacidable = FALSE
		HMG.health = 0
		HMG.update_icon()
		qdel(src)
		return

	if(health > health_max)
		health = health_max
	update_damage_state()
	update_icon()

/obj/structure/machinery/m56d_hmg/auto/CrusherImpact()
	update_health(health*0.45)
	var/mob/user = operator
	to_chat(user, SPAN_HIGHDANGER("You are knocked off the gun by the sheer force of the ram, temporairly disabling it!"))
	user.unset_interaction()
	user.KnockDown(M2C_CRUSHER_STUN)

/obj/structure/machinery/m56d_hmg/auto/attackby(var/obj/item/O as obj, mob/user as mob)
	if(!ishuman(user))
		return
	// RELOADING
	if(istype(O, /obj/item/ammo_magazine/m2c))
		var/obj/item/ammo_magazine/m2c/M = O
		if(rounds)
			to_chat(user, SPAN_WARNING("There's already an ammo box inside of the machinegun, remove it first!"))
			return
		if(user.action_busy) return
		user.visible_message(SPAN_NOTICE(" [user] loads [src] with an ammo box! "),SPAN_NOTICE(" You load [src] with an ammo box!"))
		playsound(src.loc, 'sound/items/m56dauto_load.ogg', 75, 1)
		rounds = min(rounds + M.current_rounds, rounds_max)
		update_icon()
		user.temp_drop_inv_item(O)
		qdel(O)
		return

	// WELDER REPAIR
	if(iswelder(O))
		if(user.action_busy)
			return

		var/obj/item/tool/weldingtool/WT = O

		if(health == health_max)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs, it's well-maintained."))
			return

		if(WT.remove_fuel(2, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing damage on [src]."), \
				SPAN_NOTICE("You begin repairing the damage on the [src]."))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			if(!do_after(user, repair_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
				return
			user.visible_message(SPAN_NOTICE("[user] repairs some of the damage on [src]."), \
					SPAN_NOTICE("You repair [src]."))
			update_health(-round(health_max*0.2))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("You need more fuel in [WT] to repair damage to [src]."))
		return
	return

// HANDLING THE CLICK

/obj/structure/machinery/m56d_hmg/auto/handle_click(mob/living/carbon/human/user, atom/A, var/list/mods)
	if(!operator) return HANDLE_CLICK_UNHANDLED
	if(operator != user) return HANDLE_CLICK_UNHANDLED
	if(istype(A,/obj/screen)) return HANDLE_CLICK_UNHANDLED
	if(user.lying || get_dist(user,src) > 0 || user.is_mob_incapacitated() || user.frozen)
		user.unset_interaction()
		return HANDLE_CLICK_UNHANDLED
	if(user.get_active_hand() || user.get_inactive_hand())
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
			playsound(src, 'sound/weapons/gun_empty.ogg', 30, 1, 5)
		else
			process_shot(user)
		return HANDLE_CLICK_HANDLED

	else
		if(world.time > rotate_timer)
			rotate_timer = world.time + 5
			rotate_to(user, A)

	return HANDLE_CLICK_UNHANDLED


// AUTOMATIC FIRING

/obj/structure/machinery/m56d_hmg/auto/proc/auto_fire_start(var/atom/A)
	if(!ismob(operator))
		return
	var/mob/user = operator
	target = A

	auto_fire_repeat(user)

/obj/structure/machinery/m56d_hmg/auto/proc/auto_fire_stop(var/atom/A)
	target = null

/obj/structure/machinery/m56d_hmg/auto/proc/auto_fire_new_target(var/atom/start, var/atom/hovered)
	if(!ismob(operator))
		return
	var/mob/user = operator

	if(istype(hovered, /obj/screen))
		return

	if(get_turf(hovered) == get_turf(user))
		return

	target = hovered

/obj/structure/machinery/m56d_hmg/auto/proc/auto_fire_repeat(var/mob/user, var/atom/A)
	if(!target) return
	if(operator != user) return
	if(fire_stopper) return
	if(user.get_active_hand() || user.get_inactive_hand())
		to_chat(usr, SPAN_WARNING("You need both your hands free to shoot [src]."))
		return

	var/angle = get_dir(src,target)
	if((dir & angle) && target.loc != src.loc && target.loc != operator.loc)

		if(overheat_value >= overheat_threshold)
			if(world.time > overheat_text_cooldown)
				user.visible_message(SPAN_HIGHDANGER("[src] has overheated and has been shortly disabled!"),SPAN_HIGHDANGER("[src] has overheated! You have to wait for it to cooldown!"))
				overheat_text_cooldown = world.time + 3 SECONDS
			if(!emergency_cooling)
				emergency_cooling = TRUE
				to_chat(user, SPAN_DANGER("You wait for [src]'s barrel to cooldown to continue sustained fire."))
				fire_stopper = TRUE
				STOP_PROCESSING(SSobj, src)
				addtimer(CALLBACK(src, .proc/force_cooldown), force_cooldown_timer)

		else if(overheat_value < overheat_threshold)
			fire_shot(1, user)
			if(rounds)
				overheat_value = overheat_value + 1
				START_PROCESSING(SSobj, src)
	else
		rotate_to(user, A)
		return

	addtimer(CALLBACK(src, .proc/auto_fire_repeat, user), fire_delay)

// SCATTER WAS SUPERBUGGED, REVISED M56E FIRING CODE TO AVOID FUTURE INCIDENTS

/obj/structure/machinery/m56d_hmg/auto/handle_ammo_out(mob/user)
	visible_message(SPAN_NOTICE(" [icon2html(src, viewers(src))] [src]'s ammo box drops onto the ground, now completely empty."))
	playsound(loc, empty_alarm, 70, 1)
	update_icon() //final safeguard.
	var/obj/item/ammo_magazine/m2c/AM = new /obj/item/ammo_magazine/m2c(src.loc)
	AM.current_rounds = 0
	AM.update_icon()


/obj/structure/machinery/m56d_hmg/auto/get_scatter()
	return 0

// ACTIVE COOLING

/obj/structure/machinery/m56d_hmg/auto/proc/force_cooldown(var/mob/user)
	user = operator

	overheat_value = round((rand(M2C_LOW_COOLDOWN_ROLL,M2C_HIGH_COOLDOWN_ROLL) * overheat_threshold))
	playsound(src.loc, 'sound/weapons/hmg_cooling.ogg', 75, 1)
	to_chat(user, SPAN_NOTICE("[src]'s barrel has cooled down enough to restart firing."))
	emergency_cooling = FALSE
	fire_stopper = FALSE
	fire_delay = initial(fire_delay)
	update_health(M2C_OVERHEAT_DAMAGE)
	START_PROCESSING(SSobj, src)
	update_icon()

// TOGGLE MODE

/obj/structure/machinery/m56d_hmg/auto/clicked(var/mob/user, var/list/mods, var/atom/A)
	if (isobserver(user)) return

	if (mods["ctrl"])
		if(operator != user) return
		to_chat(user, SPAN_NOTICE("This isn't a M56D, there IS no burst fire option for the M2C."))
		return

	return ..()

/obj/structure/machinery/m56d_hmg/auto/fire_shot(shots_fired = 1, var/mob/user)
	if(fire_stopper) return

	return ..()

//ATTACK WITH BOTH HANDS COMBO

/obj/structure/machinery/m56d_hmg/auto/attack_hand(mob/user)
	..()
	grip_dir = reverse_direction(dir)
	var/turf/T = get_step(src.loc, grip_dir)
	if(user.loc == T)
		if(operator) //If there is already a operator then they're manning it.
			if(operator.interactee == null)
				operator = null //this shouldn't happen, but just in case
			else
				to_chat(user, "Someone's already controlling it.")
				return
		if(!(user.alpha > 60))
			to_chat(user, SPAN_WARNING("You aren't going to be setting up while cloaked."))
			return
		else
			if(user.interactee) //Make sure we're not manning two guns at once, tentacle arms.
				to_chat(user, "You're already manning something!")
				return

		if(user.get_active_hand() == null && user.get_inactive_hand() == null)
			user.set_interaction(src)
		else
			to_chat(usr, SPAN_NOTICE("Your hands are too busy holding things to grab the handles!"))

	else
		to_chat(usr, SPAN_NOTICE("You are too far from the handles to man [src]!"))

// DISASSEMBLY

/obj/structure/machinery/m56d_hmg/auto/MouseDrop(over_object, src_location, over_location)
	if(!ishuman(usr)) return
	var/mob/living/carbon/human/user = usr

	if(over_object == user && in_range(src, user))
		if((rounds > 0) && (user.a_intent & (INTENT_GRAB)))
			playsound(src.loc, 'sound/items/m56dauto_load.ogg', 75, 1)
			user.visible_message(SPAN_NOTICE(" [user] removes [src]'s ammo box."),SPAN_NOTICE(" You remove [src]'s ammo box, preparing the gun for disassembly."))
			var/obj/item/ammo_magazine/m2c/used_ammo = new(user.loc)
			used_ammo.current_rounds = rounds
			user.put_in_active_hand(used_ammo)
			rounds = 0

		else
			if(!do_after(user, fold_time* user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src)) // disassembly time reduced
				return
			user.visible_message(SPAN_NOTICE("[user] disassembles [src]."),SPAN_NOTICE("You fold up the tripod for [src], disassembling it."))
			playsound(src.loc, 'sound/items/m56dauto_setup.ogg', 75, 1)
			var/obj/item/device/m2c_gun/HMG = new(src.loc)
			HMG.rounds = src.rounds
			HMG.overheat_value = round(0.5 * src.overheat_value)
			if (HMG.overheat_value <= 10)
				HMG.overheat_value = 0
			HMG.update_icon()
			HMG.health = health
			user.put_in_active_hand(HMG)
			qdel(src)

	update_icon()

// MOUNT THE MG

/obj/structure/machinery/m56d_hmg/auto/on_set_interaction(mob/user)
	user.frozen = TRUE
	flags_atom |= RELAY_CLICK
	user.visible_message(SPAN_NOTICE("[user] handles [src]."),SPAN_NOTICE("You handle [src], locked and loaded!"))
	user.update_canmove()
	user.forceMove(src.loc)
	user.setDir(dir)
	user_old_x = user.pixel_x
	user_old_y = user.pixel_y
	update_pixels(user)
	user.reset_view(src)

	update_pixels(user)

	if(user.client)
		RegisterSignal(user.client, COMSIG_CLIENT_LMB_DOWN, .proc/auto_fire_start)
		RegisterSignal(user.client, COMSIG_CLIENT_LMB_UP, .proc/auto_fire_stop)
		RegisterSignal(user.client, COMSIG_CLIENT_LMB_DRAG, .proc/auto_fire_new_target)
	RegisterSignal(user, COMSIG_MOB_MOVE, .proc/disable_interaction)
	RegisterSignal(user, COMSIG_MOB_POST_UPDATE_CANMOVE, .proc/disable_canmove_interaction)
	operator = user

	user.frozen = FALSE

// DISMOUNT THE MG

/obj/structure/machinery/m56d_hmg/auto/on_unset_interaction(mob/user)
	flags_atom &= ~RELAY_CLICK
	UnregisterSignal(user, list(
		COMSIG_MOB_MOVE,
		COMSIG_MOB_POST_UPDATE_CANMOVE
	))
	user.visible_message(SPAN_NOTICE("[user] releases [src]."),SPAN_NOTICE("You handle [src], letting the gun rest."))
	user.update_canmove()
	user.reset_view(null)
	var/grip_dir = reverse_direction(dir)
	var/old_dir = dir
	step(user, grip_dir)
	user_old_x = 0
	user_old_y = 0
	user.setDir(old_dir)

	if(user.client)
		user.client.change_view(world_view_size)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
		UnregisterSignal(user.client, list(
			COMSIG_CLIENT_LMB_DOWN,
			COMSIG_CLIENT_LMB_UP,
			COMSIG_CLIENT_LMB_DRAG,
		))

	animate(user, pixel_x=user_old_x, pixel_y=user_old_y, 4, 1)
	if(operator == user)
		operator = null

// GET ANIMATED

/obj/structure/machinery/m56d_hmg/auto/proc/update_pixels(mob/user as mob)
	var/diff_x = 0
	var/diff_y = 0
	var/tilesize = 32
	var/viewoffset = tilesize * 5

	user.reset_view(src)
	if(dir == EAST)
		diff_x = -16 + user_old_x
		user.client.pixel_x = viewoffset
		user.client.pixel_y = 0
	if(dir == WEST)
		diff_x = 16 + user_old_x
		user.client.pixel_x = -viewoffset
		user.client.pixel_y = 0
	if(dir == NORTH)
		diff_y = -16 + user_old_y
		user.client.pixel_x = 0
		user.client.pixel_y = viewoffset
	if(dir == SOUTH)
		diff_y = 16 + user_old_y
		user.client.pixel_x = 0
		user.client.pixel_y = -viewoffset

	animate(user, pixel_x=diff_x, pixel_y=diff_y, 0.4 SECONDS)

//ROTATE THE MACHINEGUN

/obj/structure/machinery/m56d_hmg/auto/proc/rotate_to(mob/user, atom/A)
	if(!A || !user.x || !user.y || !A.x || !A.y)
		return
	var/dx = A.x - user.x
	var/dy = A.y - user.y
	if(!dx && !dy)
		return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)
			direction = NORTH
		else
			direction = SOUTH
	else
		if(dx > 0)
			direction = EAST
		else
			direction = WEST

	var/turf/rotate_check = get_step(src.loc, turn(direction,180))
	if(rotate_check.density)
		to_chat(user, "You can't rotate it that way.")
		return

	src.setDir(direction)
	user.setDir(direction)
	update_pixels(user)
	playsound(src.loc, 'sound/items/m56dauto_rotate.ogg', 25, 1)
	to_chat(user, "You rotate [src], using the tripod to support your pivoting movement.")

/obj/structure/machinery/m56d_hmg/auto/check_eye(mob/user)
	if(user.lying || get_dist(user,src) > 0 || user.is_mob_incapacitated() || !user.client)
		user.unset_interaction()

/obj/structure/machinery/m56d_hmg/auto/proc/disable_interaction(mob/user, NewLoc, direction)
	SIGNAL_HANDLER

	if(user.lying || get_dist(user,src) > 0 || user.is_mob_incapacitated() || !user.client)
		user.unset_interaction()

/obj/structure/machinery/m56d_hmg/auto/proc/disable_canmove_interaction(mob/user, canmove, laid_down, lying)
	SIGNAL_HANDLER

	if(laid_down)
		user.unset_interaction()

#undef M2C_OVERHEAT_CRITICAL
#undef M2C_OVERHEAT_BAD
#undef M2C_OVERHEAT_OK
#undef M2C_SETUP_TIME
#undef M2C_OVERHEAT_DAMAGE
#undef M2C_LOW_COOLDOWN_ROLL
#undef M2C_HIGH_COOLDOWN_ROLL
#undef M2C_PASSIVE_COOLDOWN_AMOUNT
#undef M2C_OVERHEAT_OVERLAY
#undef M2C_CRUSHER_STUN
