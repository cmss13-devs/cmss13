/obj/structure/barricade/deployable
	name = "portable composite barricade"
	desc = "A plasteel-carbon composite barricade. Resistant to most acids while being simple to repair. There are two pushplates that allow this barricade to fold into a neat package. Use a blowtorch to repair."
	icon_state = "folding_0"
	health = 350
	maxhealth = 350
	burn_multiplier = 1.5
	brute_multiplier = 1
	crusher_resistant = TRUE
	force_level_absorption = 15
	barricade_hitsound = "sound/effects/metalhit.ogg"
	barricade_type = "folding"
	can_wire = FALSE
	can_change_dmg_state = 1
	climbable = FALSE
	unacidable = TRUE
	anchored = TRUE
	repair_materials = list("metal" = 0.2, "plasteel" = 0.25)
	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines
	var/source_type = /obj/item/folding_barricade	//had to add this here, cause mapped in porta cades were unfoldable.

/obj/structure/barricade/deployable/examine(mob/user)
	..()
	to_chat(user, SPAN_INFO("Drag its sprite onto yourself to undeploy."))

/obj/structure/barricade/deployable/attackby(obj/item/W, mob/user)

	if(iswelder(W))
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
		if(do_after(usr, 4 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
			collapse(usr)
		else
			to_chat(usr, SPAN_WARNING("You stop collapsing [src]."))

/obj/structure/barricade/deployable/proc/collapse(mob/living/carbon/human/user)
	var/obj/item/folding_barricade/FB = new source_type(loc)
	FB.health = health
	FB.maxhealth = maxhealth
	if(istype(user))
		user.visible_message(SPAN_NOTICE("[user] collapses [src]."),
			SPAN_NOTICE("You collapse [src]."))
		user.put_in_active_hand(FB)
	qdel(src)


//CADE IN HANDS
/obj/item/folding_barricade
	name = "MB-6 Folding Barricade"
	desc = "A folding barricade that can be used to quickly deploy an all-round resistant barricade."
	health = 350
	var/maxhealth = 350
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	icon_state = "folding"
	icon = 'icons/obj/items/marine-items.dmi'

/obj/structure/barricade/metal/wired/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_front &= ~PASS_OVER_THROW_MOB

/obj/item/folding_barricade/attack_self(mob/user)
	..()

	for(var/obj/structure/barricade/B in loc)
		if(B != src && B.dir == dir)
			to_chat(user, SPAN_WARNING("There's already a barricade here."))
			return
	var/turf/open/OT = usr.loc
	var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in OT // for M2C HMG, look at smartgun_mount.dm
	if(!OT.allow_construction)
		to_chat(usr, SPAN_WARNING("[src] must be constructed on a proper surface!"))
		return
	if(AC)
		to_chat(usr, SPAN_WARNING("[src] cannot be built here!"))
		return

	user.visible_message(SPAN_NOTICE("[user] begins deploying [src]."),
			SPAN_NOTICE("You begin deploying [src]."))
	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	if(!do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	user.visible_message(SPAN_NOTICE("[user] has finished deploying [src]."),
			SPAN_NOTICE("You finish deploying [src]."))
	var/obj/structure/barricade/deployable/cade = new(user.loc)
	cade.setDir(user.dir)
	cade.health = health
	cade.maxhealth = maxhealth

	cade.source_type = type
	qdel(src)
