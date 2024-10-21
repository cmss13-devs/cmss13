/obj/effect/alien/resin/special/pylon/core/weave_pool
	name = XENO_STRUCTURE_WEAVE_POOL
	desc = "A pool of fey energies, who knows what lies within its depths."
	icon = 'icons/mob/xenonids/structures64x64.dmi'
	icon_state = "weave_pool"
	health = 2000

	var/damage_amount = 20

	luminosity = 5
	lesser_drone_spawn_limit = 0

/obj/effect/alien/resin/special/pylon/core/weave_pool/New(loc, hive_ref)
	..(loc, hive_ref)
	if(isnull(linked_hive))
		linked_hive = GLOB.hive_datum[XENO_HIVE_WEAVE]

/obj/effect/alien/resin/special/pylon/core/weave_pool/update_icon()
	..()
	overlays.Cut()
	underlays.Cut()
	underlays += "[icon_state]_underlay"
	overlays += mutable_appearance(icon, "[icon_state]_overlay", layer = ABOVE_MOB_LAYER, plane = GAME_PLANE)
	var/datum/hive_status/mutated/weave/weave_hive = linked_hive
	if(!istype(weave_hive))
		return
	if(weave_hive.weave_energy >= (weave_hive.weave_energy_max * 0.25))
		overlays += mutable_appearance(icon,"[icon_state]_bubbling", layer = ABOVE_MOB_LAYER + 0.1, plane = GAME_PLANE)

/obj/effect/alien/resin/special/pylon/core/weave_pool/Crossed(mob/AM)//I want to make this chance an infection of fey manipulation.
	. = ..()
	update_icon()
	if(!ishuman(AM) || AM.stat == DEAD)
		return

	var/mob/living/carbon/human/H = AM

	H.emote("pain")
	if(prob(20))
		to_chat(H, SPAN_DANGER("You trip into the pool!"))
		H.KnockDown(5)
	do_human_damage(H)

/obj/effect/alien/resin/special/pylon/core/weave_pool/proc/do_human_damage(mob/living/carbon/human/H)
	if(H.loc != loc)
		return

	playsound(H, get_sfx("acid_sizzle"), 30)
	addtimer(CALLBACK(src, PROC_REF(do_human_damage), H), 3 SECONDS, TIMER_UNIQUE)

	if(H.resting)
		for(var/i in DEFENSE_ZONES_LIVING)
			H.apply_armoured_damage(damage_amount * 0.35, ARMOR_BIO, BURN, i)
		return
	H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "l_foot")
	H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "r_foot")
	H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "l_leg")
	H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "r_leg")
