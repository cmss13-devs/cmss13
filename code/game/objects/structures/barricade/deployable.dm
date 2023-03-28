/obj/structure/barricade/deployable
	name = "portable composite barricade"
	desc = "A plasteel-carbon composite barricade. Resistant to most acids while being simple to repair. There are two pushplates that allow this barricade to fold into a neat package. Use a blowtorch to repair."
	icon_state = "folding_0"
	health = 350
	maxhealth = 350
	burn_multiplier = 1.15
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

/obj/structure/barricade/deployable/attackby(obj/item/W, mob/user)

	if(iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		if(user.action_busy)
			return
		var/obj/item/tool/weldingtool/WT = W
		if(health == maxhealth)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return

		weld_cade(WT, user)
		return

	else if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		if(user.action_busy)
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You do not know where the loosening bolts are on [src]..."))
			return
		else
			if(build_state == BARRICADE_BSTATE_UNSECURED)
				to_chat(user, SPAN_NOTICE("You tighten the bolts on [src]."))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				build_state = BARRICADE_BSTATE_SECURED
			else
				to_chat(user, SPAN_NOTICE("You loosen the bolts on [src]."))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				build_state = BARRICADE_BSTATE_UNSECURED

	else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		if(build_state != BARRICADE_BSTATE_UNSECURED)
			return
		if(user.action_busy)
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You do not know how to collapse [src] using a crowbar..."))
			return
		else
			user.visible_message(SPAN_NOTICE("[user] starts collapsing [src]."), \
				SPAN_NOTICE("You begin collapsing [src]..."))
			playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
				collapse(usr)
			else
				to_chat(user, SPAN_WARNING("You stop collapsing [src]."))

	if(try_nailgun_usage(W, user))
		return

	. = ..()

/obj/structure/barricade/deployable/MouseDrop(obj/over_object as obj)
	if(!ishuman(usr))
		return

	if(usr.lying)
		return

	if(over_object == usr && Adjacent(usr))
		usr.visible_message(SPAN_NOTICE("[usr] starts collapsing [src]."),
			SPAN_NOTICE("You begin collapsing [src]."))
		playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
		if(do_after(usr, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
			collapse(usr)
		else
			to_chat(usr, SPAN_WARNING("You stop collapsing [src]."))

/obj/structure/barricade/deployable/proc/collapse(mob/living/carbon/human/user)
	var/obj/item/stack/folding_barricade/FB = new source_type(loc)
	FB.health = health
	FB.maxhealth = maxhealth
	if(istype(user))
		user.visible_message(SPAN_NOTICE("[user] collapses [src]."),
			SPAN_NOTICE("You collapse [src]."))
		user.put_in_active_hand(FB)
	qdel(src)

/obj/structure/barricade/deployable/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if(PF)
		PF.flags_can_pass_front &= ~PASS_OVER_THROW_MOB


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
	icon_state = "folding-1"
	item_state = "folding"
	item_state_slots = list(
		WEAR_BACK = "folding",
		WEAR_J_STORE = "folding"
	)
	icon = 'icons/obj/items/marine-items.dmi'

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

	var/turf/open/OT = usr.loc
	var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in OT // for M2C HMG, look at smartgun_mount.dm

	if(!OT.allow_construction)
		to_chat(usr, SPAN_WARNING("[src.singular_name] must be constructed on a proper surface!"))
		return
	if(AC)
		to_chat(usr, SPAN_WARNING("[src.singular_name] cannot be built here!"))
		return

	user.visible_message(SPAN_NOTICE("[user] begins deploying [src.singular_name]."),
			SPAN_NOTICE("You begin deploying [src.singular_name]."))

	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)

	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("You were interrupted."))
		return

	for(var/obj/structure/barricade/B in usr.loc) //second check so no memery
		if(B.dir == user.dir)
			to_chat(user, SPAN_WARNING("There is already \a [B] in this direction!"))
			return

	user.visible_message(SPAN_NOTICE("[user] has finished deploying [src.singular_name]."),
			SPAN_NOTICE("You finish deploying [src.singular_name]."))

	var/obj/structure/barricade/deployable/cade = new(user.loc)
	cade.setDir(user.dir)
	cade.health = health
	cade.maxhealth = maxhealth
	cade.source_type = singular_type
	cade.update_damage_state()
	cade.update_icon()

	use(1)

/obj/item/stack/folding_barricade/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/folding_barricade))
		var/obj/item/stack/folding_barricade/F = W

		if(health != maxhealth || F.health != F.maxhealth)
			to_chat(user, "You cannot stack damaged [src.singular_name]\s.")
			return

		if(!ismob(src.loc))
			return ..()

		if(amount >= max_amount)
			to_chat(user, "You cannot stack more [src.singular_name]\s.")
			return

		var/to_transfer = min(max_amount - amount, F.amount)
		F.use(to_transfer)
		add(to_transfer)
		to_chat(user, SPAN_INFO("You transfer [to_transfer] between the stacks."))
		return

	else if(iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		if(src != user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You need to hold [src.singular_name] in hand or deploy to repair it."))
			return

		if(user.action_busy)
			return

		var/obj/item/tool/weldingtool/WT = W
		if(health == maxhealth)
			to_chat(user, SPAN_WARNING("[src.singular_name] doesn't need repairs."))
			return

		if(!(WT.remove_fuel(2, user)))
			return

		user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
		SPAN_NOTICE("You begin repairing the damage to [src]."))
		playsound(src.loc, 'sound/items/Welder2.ogg', 25, TRUE)

		var/welding_time = skillcheck(user, SKILL_CONSTRUCTION, 2) ? 5 SECONDS : 10 SECONDS
		if(!do_after(user, welding_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
			return

		user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
		SPAN_NOTICE("You repair [src]."))
		user.count_niche_stat(STATISTICS_NICHE_REPAIR_CADES)

		health += 200
		if(health > maxhealth)
			health = maxhealth

		playsound(src.loc, 'sound/items/Welder2.ogg', 25, TRUE)
		return

	. = ..()

/obj/item/stack/folding_barricade/attack_hand(mob/user)
	var/mob/living/carbon/human/H = user
	if(!(amount > 1 && H.back == src))
		return ..()
	var/obj/item/stack/F = new singular_type(user, 1)
	transfer_fingerprints_to(F)
	user.put_in_hands(F)
	src.add_fingerprint(user)
	F.add_fingerprint(user)
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
	if(health < maxhealth)
		. += SPAN_WARNING("It appears to be damaged.")

/obj/item/stack/folding_barricade/three
	amount = 3
