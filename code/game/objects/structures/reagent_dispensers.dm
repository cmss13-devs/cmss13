/obj/structure/reagent_dispensers
	name = "dispenser"
	desc = "..."
	icon = 'icons/obj/structures/liquid_tanks.dmi'
	icon_state = "watertank"
	density = TRUE
	anchored = FALSE
	drag_delay = 1
	health = 100 // Can be destroyed in 2-4 slashes.
	flags_atom = CAN_BE_SYRINGED
	wrenchable = TRUE
	unslashable = FALSE
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(5,10,20,30,40,50,60,100,200,300)
	var/chemical = ""
	var/dispensing = TRUE

/obj/structure/reagent_dispensers/Initialize(mapload, reagent_amount = 1000)
	. = ..()
	ADD_TRAIT(src, TRAIT_REACTS_UNSAFELY, TRAIT_SOURCE_INHERENT)
	create_reagents(reagent_amount)
	if(!possible_transfer_amounts)
		verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
	if(chemical)
		reagents.add_reagent(chemical, reagent_amount)
	if(!anchored && is_ground_level(z) && prob(70))
		anchored = TRUE

/obj/structure/reagent_dispensers/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND|PASS_UNDER

/obj/structure/reagent_dispensers/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user, src) > 2 && user != loc)
		return
	. += SPAN_NOTICE("It contains:")
	if(reagents && length(reagents.reagent_list))
		for(var/datum/reagent/R in reagents.reagent_list)
			. += SPAN_NOTICE(" [R.volume] units of [R.name]")
	else
		. += SPAN_NOTICE(" Nothing.")
	if(reagents)
		. += SPAN_NOTICE("Total volume: [reagents.total_volume] / [reagents.maximum_volume].")
	if(dispensing)
		. += SPAN_NOTICE("\nTransfer mode: Dispensing")
	else
		. += SPAN_NOTICE("\nTransfer mode: Filling")
	. += SPAN_NOTICE("Transfer rate: [amount_per_transfer_from_this] units")

/obj/structure/reagent_dispensers/Destroy()
	playsound(src.loc, 'sound/effects/slosh.ogg', 50, 1, 3)
	visible_message(SPAN_NOTICE("\The [src] falls apart as its contents spill everywhere!"))
	. = ..()

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)

	if(!ishuman(usr))
		return

	if(!reagents || reagents.locked)
		return

	var/N = tgui_input_list(usr, "Amount per transfer from this:","[src]", possible_transfer_amounts)
	if(N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/proc/healthcheck()
	if(health <= 0)
		deconstruct(FALSE)

/obj/structure/reagent_dispensers/bullet_act(obj/projectile/Proj)
	health -= Proj.damage
	if(Proj.firer)
		msg_admin_niche("[key_name_admin(Proj.firer)] fired a projectile at [name] in [loc.loc.name] ([loc.x],[loc.y],[loc.z]) [ADMIN_JMP(loc)].")
		log_game("[key_name(Proj.firer)] fired a projectile at [name] in [loc.loc.name] ([loc.x],[loc.y],[loc.z]).")
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	healthcheck()
	return TRUE

/obj/structure/reagent_dispensers/verb/set_transfer_direction() //set amount_per_transfer_from_this
	set name = "Set transfer direction"
	set category = "Object"
	set src in view(1)

	if(!ishuman(usr))
		return

	if(!reagents || reagents.locked)
		return

	dispensing = !dispensing
	if(dispensing)
		to_chat(usr, SPAN_NOTICE("[src] is now dispensing"))
	else
		to_chat(usr, SPAN_NOTICE("[src] is now filling"))

/obj/structure/reagent_dispensers/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(5))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/reagent_dispensers/attack_hand()
	if(!reagents || reagents.locked)
		return

	var/N = tgui_input_list(usr, "Amount per transfer from this:","[src]", possible_transfer_amounts)
	if(N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/clicked(mob/user, list/mods)
	if(!Adjacent(user))
		return ..()

	if(!ishuman(user))
		return ..()

	if(!reagents || reagents.locked)
		return ..()

	if(mods[ALT_CLICK])
		dispensing = !dispensing
		if(dispensing)
			to_chat(user, SPAN_NOTICE("[src] is now dispensing"))
		else
			to_chat(user, SPAN_NOTICE("[src] is now filling"))
		return TRUE
	return ..()

/obj/structure/reagent_dispensers/attackby(obj/item/hit_item, mob/living/user)
	if(istype(hit_item, /obj/item/reagent_container))
		return
	. = ..()

//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "watertank"
	desc = "A water tank"
	icon_state = "watertank"
	chemical = "water"

/obj/structure/reagent_dispensers/watertank/yautja
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'

/obj/structure/reagent_dispensers/ammoniatank
	name = "ammoniatank"
	desc = "An ammonia tank"
	icon_state = "ammoniatank"
	chemical = "ammonia"

/obj/structure/reagent_dispensers/acidtank
	name = "sulfuric acid tank"
	desc = "A sulfuric acid tank"
	icon_state = "sacidtank"
	chemical = "sulphuric acid"

/obj/structure/reagent_dispensers/pacidtank
	name = "polytrinic acid tank"
	desc = "A polytrinic acid tank"
	icon_state = "pacidtank"
	chemical = "pacid"

/obj/structure/reagent_dispensers/ethanoltank
	name = "ethanol tank"
	desc = "An ethanol tank."
	icon_state = "ethanoltank"
	chemical = "ethanol"

/obj/structure/reagent_dispensers/fueltank
	name = "fueltank"
	desc = "A fuel tank"
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	chemical = "fuel"
	black_market_value = 25
	var/modded = 0
	var/obj/item/device/assembly_holder/rig = null
	var/exploding = 0
	var/reinforced = FALSE
	var/datum/weakref/source_mob

/obj/structure/reagent_dispensers/fueltank/get_examine_text(mob/user)
	. = ..()
	if(user != loc)
		return
	if(modded)
		. += SPAN_DANGER("The fuel faucet is wrenched open, leaking the fuel!")
	if(rig)
		. += SPAN_NOTICE("There is some kind of device rigged to the tank.")
	if(reinforced)
		. += SPAN_NOTICE("It seems to be reinforced with metal shielding.")

/obj/structure/reagent_dispensers/fueltank/attack_hand()
	if(rig)
		usr.visible_message("[usr] begins to detach [rig] from \the [src].", "You begin to detach [rig] from \the [src]")
		if(do_after(usr, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			usr.visible_message(SPAN_NOTICE("[usr] detaches [rig] from \the [src]."), SPAN_NOTICE(" You detach [rig] from \the [src]"))
			rig.forceMove(get_turf(usr))
			rig = null
			update_icon()
	else
		. = ..()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(user.action_busy)
		to_chat(user, SPAN_WARNING("You're already peforming an action!"))
		return

	if(istype(W,/obj/item/device/assembly_holder))

		if(rig)
			to_chat(user, SPAN_DANGER("There is another device in the way."))
			return ..()

		user.visible_message("[user] begins rigging [W] to \the [src].", "You begin rigging [W] to \the [src]")

		if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL))
			return

		if(rig)
			to_chat(user, SPAN_DANGER("There is another device in the way."))
			return ..()

		user.visible_message(SPAN_NOTICE("[user] rigs [W] to \the [src]."), SPAN_NOTICE(" You rig [W] to \the [src]"))

		var/obj/item/device/assembly_holder/H = W
		if (istype(H.a_left,/obj/item/device/assembly/igniter) || istype(H.a_right,/obj/item/device/assembly/igniter))
			msg_admin_niche("[key_name_admin(user)] rigged [name] at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion. [ADMIN_JMP(loc)]")
			log_game("[key_name(user)] rigged [name] at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion.")

		rig = W
		user.drop_inv_item_to_loc(W, src)

		update_icon()

	else if(istype(W,/obj/item/stack/sheet/plasteel))
		var/obj/item/stack/sheet/plasteel/M = W
		if(M.get_amount() < STACK_10)
			to_chat(user, SPAN_WARNING("You don't have enough of [M] to reinforce [src]."))
			return

		user.visible_message(SPAN_NOTICE("[user] begins reinforcing the exterior of [src] with [M]."),
		SPAN_NOTICE("You begin reinforcing [src] with [M]."))

		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD, src, INTERRUPT_ALL) || reinforced)
			return

		if(!M.use(STACK_10))
			to_chat(user, SPAN_WARNING("You don't have enough of [M] to reinforce [src]."))
			return

		user.visible_message(SPAN_NOTICE("[user] reinforces the exterior of [src] with [M]."),
		SPAN_NOTICE("You reinforce [src] with [M]."))

		reinforced = TRUE
		update_icon()

	else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))

		user.visible_message(SPAN_DANGER("[user] begins to remove the shielding from [src]."),
		SPAN_NOTICE("You begin to remove the shielding from [src]."))

		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD, src, INTERRUPT_ALL) || !reinforced)
			return

		user.visible_message(SPAN_DANGER("[user] removes the shielding from [src]."),
		SPAN_NOTICE("You remove the shielding from [src]."))
		new /obj/item/stack/sheet/plasteel(loc, STACK_10)

		reinforced = FALSE
		update_icon()

	return ..()


/obj/structure/reagent_dispensers/fueltank/bullet_act(obj/projectile/Proj)
	if(exploding)
		return 0
	if(ismob(Proj.firer))
		source_mob = WEAKREF(Proj.firer)

	if(Proj.damage > 10 && prob(60) && !reinforced)
		if(Proj.firer)
			message_admins("[key_name_admin(Proj.firer)] fired a projectile at [name] in [loc.loc.name] ([loc.x],[loc.y],[loc.z]) [ADMIN_JMP(loc)].")
			log_game("[key_name(Proj.firer)] fired a projectile at [name] in [loc.loc.name] ([loc.x],[loc.y],[loc.z]).")
		exploding = TRUE
		explode()

	return TRUE

/obj/structure/reagent_dispensers/fueltank/ex_act(severity)
	if(exploding)
		return

	if(severity >= EXPLOSION_THRESHOLD_HIGH)
		exploding = TRUE
		explode(TRUE)
	else if(!reinforced)
		exploding = TRUE
		explode()

	if(src)
		return ..()

/obj/structure/reagent_dispensers/fueltank/proc/explode(force)
	reagents.source_mob = source_mob
	if(reagents.handle_volatiles() || force)
		deconstruct(FALSE)
		return

	exploding = FALSE
	update_icon()


/obj/structure/reagent_dispensers/fueltank/update_icon(cut_overlays = TRUE)
	if(cut_overlays)
		overlays.Cut()
	. = ..()

	if(rig)
		overlays += image(icon, "t_signaller")
		if(exploding)
			overlays += image(icon, "t_boom")
		else
			overlays += image(icon, "t_active")
	else
		overlays += image(icon, "t_inactive")

	if(reinforced)
		overlays += image(icon, icon_state = "t_reinforced")

/obj/structure/reagent_dispensers/fueltank/fire_act(temperature, volume)
	if(temperature > T0C+500 && !reinforced)
		explode()
	return ..()

/obj/structure/reagent_dispensers/fueltank/Move()
	. = ..()
	if(. && modded && reagents && !reagents.locked)
		leak_fuel(amount_per_transfer_from_this/10.0)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if(reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent(chemical,amount)
	new /obj/effect/decal/cleanable/liquid_fuel(src.loc, amount)

/obj/structure/reagent_dispensers/fueltank/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	if(!reinforced)
		reagents.source_mob = flame_cause_data?.weak_mob
		explode()

/obj/structure/reagent_dispensers/fueltank/yautja
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'

/obj/structure/reagent_dispensers/fueltank/gas
	name = "gastank"
	desc = "A gas tank"

/obj/structure/reagent_dispensers/fueltank/spacecraft
	name = "spacecraft fuel-mix tank"
	desc = "A fuel tank mix with fuel designed for various spacecraft, very combustible."
	icon_state = "weldtank_alt"

/obj/structure/reagent_dispensers/fueltank/gas/leak_fuel(amount)
	if(reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent(chemical,amount)

/obj/structure/reagent_dispensers/fueltank/gas/methane
	name = "methanetank"
	desc = "A methane tank"
	icon_state = "methanetank"
	chemical = "methane"

/obj/structure/reagent_dispensers/fueltank/gas/hydrogen
	name = "hydrogentank"
	desc = "A hydrogen tank"
	icon_state = "hydrogentank"
	chemical = "hydrogen"

/obj/structure/reagent_dispensers/fueltank/oxygentank
	name = "oxygentank"
	desc = "An oxygen tank"
	icon_state = "oxygentank"
	chemical = "oxygen"

/obj/structure/reagent_dispensers/fueltank/custom
	name = "reagent tank"
	desc = "A reagent tank, typically used to store large quantities of chemicals."

	chemical = null
	dispensing = FALSE //Empty fuel tanks start by accepting chemicals by default. Can't dispense nothing!
	icon_state = "tank_normal"

/obj/structure/reagent_dispensers/fueltank/custom/Initialize(mapload, volume)
	. = ..()
	update_icon()

/obj/structure/reagent_dispensers/fueltank/custom/on_reagent_change()
	. = ..()
	update_icon()

/obj/structure/reagent_dispensers/fueltank/custom/update_icon()
	. = ..()

	var/set_icon_state = "tn_color"

	if(icon_state == "tank_explosive")
		set_icon_state = "te_color"

	var/image/I = image(icon, icon_state=set_icon_state)

	if(reagents)
		I.color = mix_color_from_reagents(reagents.reagent_list)

	overlays += I


/obj/structure/reagent_dispensers/peppertank
	name = "pepper spray refiller"
	desc = "Refill pepper spray canisters."
	icon = 'icons/obj/structures/wall_dispensers.dmi'
	icon_state = "peppertank"
	anchored = TRUE
	drag_delay = 3
	wrenchable =  FALSE
	density = FALSE
	amount_per_transfer_from_this = 45
	chemical = "condensedcapsaicin"

/obj/structure/reagent_dispensers/forensictank
	name = "forensic spray refiller"
	desc = "Refill forensic spray bottles."
	icon = 'icons/obj/structures/wall_dispensers.dmi'
	icon_state = "forensictank"
	anchored = TRUE
	drag_delay = 3
	wrenchable =  FALSE
	density = FALSE
	amount_per_transfer_from_this = 45
	chemical = "forensic_spray"

/obj/structure/reagent_dispensers/water_cooler
	name = "water cooler"
	desc = "A machine that dispenses water to drink. It has levers for hot and cold, but it only dispenses room-temperature water."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = TRUE
	drag_delay = 3
	chemical = "water"

/obj/structure/reagent_dispensers/water_cooler/walk_past
	density = FALSE

/obj/structure/reagent_dispensers/water_cooler/stacks
	icon_state = "water_cooler_2"

/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon = 'icons/obj/structures/kegs.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	chemical = "beer"
	drag_delay = 3

/obj/structure/reagent_dispensers/beerkeg/alt
	icon_state = "beertank_alt"

/obj/structure/reagent_dispensers/beerkeg/alt_dark
	icon_state = "beertank_alt2"

/obj/structure/reagent_dispensers/virusfood
	name = "virus food dispenser"
	desc = "A dispenser of virus food."
	icon = 'icons/obj/structures/wall_dispensers.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE
	drag_delay = 3
	wrenchable = FALSE
	density = FALSE
	chemical = "virusfood"

