/obj/structure/barricade/deployable
	name = "portable composite barricade"
	desc = "A plasteel-carbon composite barricade. Resistant to most acids while being simple to repair. There are two pushplates that allow this barricade to fold into a neat package. Use a blowtorch to repair."
	icon_state = "folding_0"
	health = 350
	maxhealth = 350
	burn_multiplier = 0.85
	brute_multiplier = 1
	crusher_resistant = TRUE
	force_level_absorption = 15
	barricade_hitsound = 'sound/effects/metalhit.ogg'
	barricade_type = "folding"
	can_wire = FALSE
	can_change_dmg_state = 1
	climbable = FALSE
	unacidable = TRUE
	anchored = TRUE
	repair_materials = list("metal" = 0.3, "plasteel" = 0.45)
	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines
	var/source_type = /obj/item/stack/folding_barricade //had to add this here, cause mapped in porta cades were unfoldable.

/obj/structure/barricade/deployable/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("Drag its sprite onto yourself to undeploy.")

/obj/structure/barricade/deployable/attackby(obj/item/item, mob/user)
	if(iswelder(item))
		try_weld_cade(item, user)
		return

	if(HAS_TRAIT(item, TRAIT_TOOL_CROWBAR))
		if(user.action_busy)
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
			to_chat(user, SPAN_WARNING("You do not know how to collapse [src] using a crowbar..."))
			return
		user.visible_message(SPAN_NOTICE("[user] starts collapsing [src]."),
			SPAN_NOTICE("You begin collapsing [src]..."))
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		if(do_after(user, 1.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, src))
			collapse(usr)
		else
			to_chat(user, SPAN_WARNING("You stop collapsing [src]."))

	if(try_nailgun_usage(item, user))
		return

	return ..()

/obj/structure/barricade/deployable/MouseDrop(obj/over_object as obj)
	if(!ishuman(usr))
		return

	if(usr.is_mob_incapacitated())
		return

	if(over_object == usr && Adjacent(usr))
		usr.visible_message(SPAN_NOTICE("[usr] starts collapsing [src]."),
			SPAN_NOTICE("You begin collapsing [src]."))
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		if(do_after(usr, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, src))
			collapse(usr)
		else
			to_chat(usr, SPAN_WARNING("You stop collapsing [src]."))

/obj/structure/barricade/deployable/proc/collapse(mob/living/carbon/human/user)
	var/obj/item/stack/folding_barricade/folding = new source_type(loc)
	folding.stack_health = list(health)
	folding.maxhealth = maxhealth
	if(istype(user))
		user.visible_message(SPAN_NOTICE("[user] collapses [src]."),
			SPAN_NOTICE("You collapse [src]."))
		user.put_in_active_hand(folding)
	qdel(src)

/obj/structure/barricade/deployable/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if(PF)
		PF.flags_can_pass_front &= ~PASS_OVER_THROW_MOB
		PF.flags_can_pass_behind &= ~PASS_OVER_THROW_MOB


// Cade in hands
/obj/item/stack/folding_barricade
	name = "MB-6 Folding Barricade"
	desc = "A folding barricade that can be used to quickly deploy an all-round resistant barricade."
	health = 350
	var/maxhealth = 350

	amount = 1
	max_amount = 3
	stack_id = "folding"
	display_maptext = FALSE
	var/singular_type = /obj/item/stack/folding_barricade

	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK|SLOT_SUIT_STORE
	flags_item = SMARTGUNNER_BACKPACK_OVERRIDE
	icon_state = "folding-1"
	item_state = "folding"
	item_state_slots = list(
		WEAR_BACK = "folding",
		WEAR_J_STORE = "folding"
	)
	icon = 'icons/obj/items/marine-items.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/misc.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/construction_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/construction_righthand.dmi',
	)

	var/list/stack_health = list()

/obj/item/stack/folding_barricade/Initialize(mapload, init_amount)
	. = ..()
	for(var/counter in 1 to amount)
		stack_health += initial(health)


/obj/item/stack/folding_barricade/update_icon()
	. = ..()
	icon_state = "folding-[amount]"


/obj/item/stack/folding_barricade/attack_self(mob/user)
	. = ..()

	if(usr.action_busy)
		return

	for(var/obj/structure/barricade/B in usr.loc)
		if(B.dir == user.dir)
			to_chat(user, SPAN_WARNING("There is already \a [B] in this direction!"))
			return

	var/area/area = get_area(user)
	if(!area.allow_construction)
		to_chat(usr, SPAN_WARNING("[singular_name] must be constructed on a proper surface!"))
		return

	var/turf/open/OT = usr.loc
	var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in OT // for M2C HMG, look at smartgun_mount.dm

	if(!OT.allow_construction)
		to_chat(usr, SPAN_WARNING("[singular_name] must be constructed on a proper surface!"))
		return
	if(AC)
		to_chat(usr, SPAN_WARNING("[singular_name] cannot be built here!"))
		return

	user.visible_message(SPAN_NOTICE("[user] begins deploying [singular_name]."),
			SPAN_NOTICE("You begin deploying [singular_name]."))

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)

	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("You were interrupted."))
		return

	for(var/obj/structure/barricade/B in usr.loc) //second check so no memery
		if(B.dir == user.dir)
			to_chat(user, SPAN_WARNING("There is already \a [B] in this direction!"))
			return

	user.visible_message(SPAN_NOTICE("[user] has finished deploying [singular_name]."),
			SPAN_NOTICE("You finish deploying [singular_name]."))

	var/obj/structure/barricade/deployable/cade = new(user.loc)
	cade.setDir(user.dir)
	cade.health = pop(stack_health)
	cade.maxhealth = maxhealth
	cade.source_type = singular_type
	cade.update_damage_state()
	cade.update_icon()

	use(1)

/obj/item/stack/folding_barricade/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/stack/folding_barricade))
		var/obj/item/stack/folding_barricade/folding = item
		if(!ismob(loc)) //gather from ground
			if(amount >= max_amount)
				to_chat(user, "You cannot stack more [folding.singular_name]\s.")
				return
			var/to_transfer = min(folding.max_amount - folding.amount, amount)
			for(var/counter in 1 to to_transfer)
				folding.stack_health += pop(stack_health)
			use(to_transfer)
			folding.add(to_transfer)
			to_chat(user, SPAN_INFO("You transfer [to_transfer] between the stacks."))
			return
		if(amount >= max_amount)
			to_chat(user, "You cannot stack more [singular_name]\s.")
			return

		var/to_transfer = min(max_amount - amount, folding.amount)
		for(var/counter in 1 to to_transfer)
			stack_health += pop(folding.stack_health)
		folding.use(to_transfer)
		add(to_transfer)
		to_chat(user, SPAN_INFO("You transfer [to_transfer] between the stacks."))
		return

	if(iswelder(item))
		if(!HAS_TRAIT(item, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return

		if(user.action_busy)
			return

		var/need_repairs = 0
		for(var/counter in 1 to length(stack_health))
			if(stack_health[counter] < maxhealth)
				need_repairs++

		if(!need_repairs)
			to_chat(user, SPAN_WARNING("[singular_name] doesn't need repairs."))
			return

		var/obj/item/tool/weldingtool/welder = item
		if(!(welder.remove_fuel(2, user)))
			return

		user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
		SPAN_NOTICE("You begin repairing the damage to [src]."))
		playsound(loc, 'sound/items/Welder2.ogg', 25, TRUE)

		var/welding_time = (skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED) ? 5 SECONDS : 10 SECONDS) * need_repairs

		if(src != user.get_inactive_hand())
			if(!do_after(user, welding_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				return
		else
			if(!do_after(user, welding_time, (INTERRUPT_ALL & (~INTERRUPT_MOVED)), BUSY_ICON_FRIENDLY, src, INTERRUPT_DIFF_LOC)) //you can move while repairing if you have cade in hand
				return

		user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
		SPAN_NOTICE("You repair [src]."))
		user.count_niche_stat(STATISTICS_NICHE_REPAIR_CADES)

		for(var/counter in 1 to length(stack_health))
			stack_health[counter] += 200
			if(stack_health[counter] > maxhealth)
				stack_health[counter] = maxhealth

		playsound(loc, 'sound/items/Welder2.ogg', 25, TRUE)
		return

	return ..()

/obj/item/stack/folding_barricade/attack_hand(mob/user)
	var/mob/living/carbon/human/human = user
	if(!(amount > 1 && (human.back == src || human.get_inactive_hand() == src)))
		return ..()
	var/obj/item/stack/folding_barricade/folding = new singular_type(user, 1)
	transfer_fingerprints_to(folding)
	folding.stack_health = list(pop(stack_health))
	user.put_in_hands(folding)
	add_fingerprint(user)
	folding.add_fingerprint(user)
	use(1)

/obj/item/stack/folding_barricade/MouseDrop(obj/over_object as obj)
	if(CAN_PICKUP(usr, src))
		if(!istype(over_object, /atom/movable/screen))
			return ..()

		if(loc != usr || (loc && loc.loc == usr))
			return

		if(!usr.is_mob_restrained() && !usr.stat)
			switch(over_object.name)
				if("r_hand")
					if(usr.drop_inv_item_on_ground(src))
						usr.put_in_r_hand(src)
				if("l_hand")
					if(usr.drop_inv_item_on_ground(src))
						usr.put_in_l_hand(src)

/obj/item/stack/folding_barricade/get_examine_text(mob/user)
	. = ..()
	if(floor(min(stack_health)/maxhealth * 100) <= 75)
		. += SPAN_WARNING("It appears to be damaged.")

/obj/item/stack/folding_barricade/three
	amount = 3
