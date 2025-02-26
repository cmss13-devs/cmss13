// Glass shards

/obj/item/shard
	name = "glass shard"
	icon = 'icons/obj/items/shards.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_righthand.dmi',
	)
	icon_state = ""
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 1
	desc = "A shard of broken glass. Could probably be used as ... a throwing weapon?"
	w_class = SIZE_TINY
	force = 5
	throwforce = 8
	item_state = "shard-glass"
	matter = list("glass" = 3750)
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	var/source_sheet_type = /obj/item/stack/sheet/glass
	var/shardsize
	var/count = 1
	/// Whether to add small/medium/large to the end of the icon_state on Initialize
	var/random_size = TRUE
	garbage = TRUE

/obj/item/shard/attack(mob/living/carbon/M, mob/living/carbon/user)
	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 6)


/obj/item/shard/Initialize()
	. = ..()
	if(random_size)
		shardsize = pick("large", "medium", "small")
		switch(shardsize)
			if("small")
				pixel_x = rand(-12, 12)
				pixel_y = rand(-12, 12)
				icon_state += shardsize
			if("medium")
				pixel_x = rand(-8, 8)
				pixel_y = rand(-8, 8)
				icon_state += shardsize
			if("large")
				pixel_x = rand(-5, 5)
				pixel_y = rand(-5, 5)
				icon_state += shardsize

/obj/item/shard/attackby(obj/item/W, mob/user)
	if ( iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(source_sheet_type) //can be melted into something
			if(WT.remove_fuel(0, user))
				var/obj/item/stack/sheet/NG = new source_sheet_type(user.loc)
				for (var/obj/item/stack/sheet/G in user.loc)
					if(G==NG)
						continue
					if(!istype(G, source_sheet_type))
						continue
					if(G.amount>=G.max_amount)
						continue
					G.attackby(NG, user)
					to_chat(user, "You add the newly-formed glass to the stack. It now contains [NG.amount] sheets.")
				qdel(src)
				return
	return ..()

/obj/item/shard/phoron
	name = "phoron shard"
	desc = "A shard of broken phoron glass. Considerably tougher than normal glass shards. Apparently not tough enough to be a window."
	force = 8
	throwforce = 15
	icon_state = "phoron"
	source_sheet_type = /obj/item/stack/sheet/glass/phoronglass


// Shrapnel.
// on_embed is called from projectile.dm, bullet_act(obj/projectile/P).
// on_embedded_movement is called from human.dm, handle_embedded_objects().

/obj/item/large_shrapnel/proc/on_embedded_movement(mob/living/embedded_mob)
	return

/obj/item/large_shrapnel/proc/on_embed(mob/embedded_mob, obj/limb/target_organ, silent = FALSE)
	return

/obj/item/large_shrapnel/at_rocket_dud
	name = "unexploded anti-tank rocket"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/rocket_launchers.dmi'
	icon_state = "custom_rocket_no_fuel"
	desc = "An undetonated anti-tank rocket that probably hit something soft. You really shouldn't drop this..."
	/// same as custom warhead
	matter = list("metal" = 11250)
	w_class = SIZE_LARGE
	force = 20
	throw_range = 5
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	var/damage_on_move = 2
	var/vehicle_slowdown_time = 5 SECONDS
	var/throw_channel = 2 SECONDS
	var/detonating = 0
	var/thrown = 0
	var/cause = null
	/// % chance of it detonating when dropped. THIS ALSO TRIGGERS WHEN PUTTING IT IN A BAG.
	var/drop_sensitivity = 25
	/// % chance of it detonating when thrown and hitting an atom.
	var/impact_sensitivity = 75

/obj/item/large_shrapnel/at_rocket_dud/dropped(mob/user)
	. = ..()

	if(!detonating && !thrown && !cause && prob(drop_sensitivity))
		cause = "accidental"
		visible_message(SPAN_DANGER("You hear the click of a mechanism triggering inside \the [src] as [user] drops it. Uh oh."))
		manual_detonate(get_turf(src), user)
	cause = null

/obj/item/large_shrapnel/at_rocket_dud/try_to_throw(mob/living/user)
	to_chat(user, SPAN_NOTICE("You heft \the [src] up, preparing to throw it."))
	user.visible_message(SPAN_DANGER("[user] strains to lift up \the [src]. It looks like they're trying to throw it!"))
	throw_range = 5
	throw_channel = 2 SECONDS
	if(HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		throw_range = 8
		throw_channel = 1 SECONDS
	if(!do_after(user, throw_channel, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_WARNING("Your attempt to throw \the [src] was interrupted!"))
		return FALSE
	cause = "manually triggered"
	thrown = 1
	return TRUE

/obj/item/large_shrapnel/at_rocket_dud/launch_impact(atom/hit_atom)
	. = ..()
	var/datum/launch_metadata/LM = launch_metadata
	var/user = LM?.thrower
	if(!detonating && prob(impact_sensitivity))
		cause = "manually triggered"
		visible_message(SPAN_DANGER("You hear the click of a mechanism triggering inside \the [src]. Uh oh."))
		vehicle_impact(hit_atom, user)
		manual_detonate(hit_atom, user, 0)
		return
	cause = null
	thrown = 0

/obj/item/large_shrapnel/at_rocket_dud/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!detonating && (user.a_intent == INTENT_HARM) && proximity_flag && (istype(target, /obj/vehicle) || istype(target, /obj/structure) || istype(target, /turf)))
		cause = "manually triggered"
		vehicle_impact(target, user)
		manual_detonate(target, user)
		return
	cause = null

/obj/item/large_shrapnel/at_rocket_dud/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!detonating && (user.a_intent == INTENT_HARM) && istype(M, /mob/living/carbon))
		cause = "manually triggered"
		manual_detonate(M, user)
		return
	cause = null

/obj/item/large_shrapnel/at_rocket_dud/proc/vehicle_impact(atom/T, mob/U)
	if(istype(T, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/M = T
		M.next_move = world.time + vehicle_slowdown_time
		playsound(M, 'sound/effects/meteorimpact.ogg', 35)
		M.at_munition_interior_explosion_effect(cause_data = create_cause_data("Anti-Tank Rocket", U))
		M.interior_crash_effect()
		M.ex_act(1000)
		return TRUE
	return FALSE

/obj/item/large_shrapnel/at_rocket_dud/proc/manual_detonate(atom/target, mob/living/user, melee = 1, direction = null)
	detonating = 1
	if(user && (cause == "manually triggered"))
		user.visible_message(SPAN_DANGER("[user] [melee?"slams \the [src] into":"throws \the [src] at"] [target]!"))
	if((!direction) && target && user)
		direction = get_dir(user, target)
	cell_explosion(get_turf(target), 200, 150, EXPLOSION_FALLOFF_SHAPE_LINEAR, direction, create_cause_data("[cause] UXO detonation", user))
	qdel(src)

/obj/item/large_shrapnel/at_rocket_dud/on_embed(mob/embedded_mob, obj/limb/target_organ, silent = FALSE)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	if(istype(target_organ))
		target_organ.embed(src, silent)

/obj/item/large_shrapnel/at_rocket_dud/on_embedded_movement(mob/living/embedded_mob)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	var/obj/limb/organ = embedded_organ
	if(istype(organ))
		organ.take_damage(damage_on_move, 0, 0, no_limb_loss = TRUE)
		embedded_mob.pain.apply_pain(damage_on_move)
		if(prob(5))
			to_chat(embedded_mob, SPAN_DANGER("\The [src] sticking out of you jostles roughly against your innards! Oh no."))
			embedded_mob.visible_message(SPAN_DANGER("\The [src] sticking out of [embedded_mob] suddenly explodes!"))
			cell_explosion(get_turf(embedded_mob), 200, 150, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("accidental UXO detonation", embedded_mob))

/obj/item/shard/shrapnel
	name = "shrapnel"
	icon_state = "shrapnel"
	desc = "A bunch of tiny bits of shattered metal."
	matter = list("metal" = 50)
	source_sheet_type = null
	var/damage_on_move = 0.5

/obj/item/shard/shrapnel/proc/on_embed(mob/embedded_mob, obj/limb/target_organ, silent = FALSE)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	if(istype(target_organ))
		target_organ.embed(src, silent)

/obj/item/shard/shrapnel/proc/on_embedded_movement(mob/living/embedded_mob)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	var/obj/limb/organ = embedded_organ
	if(istype(organ) && damage_on_move)
		organ.take_damage(damage_on_move * count, 0, 0, no_limb_loss = TRUE)
		embedded_mob.pain.apply_pain(damage_on_move * count)

/obj/item/shard/shrapnel/upp
	name = "small shrapnel"
	desc = "Some shrapnel that used to be embedded underneath someone's skin."
	icon_state = "small"
	damage_on_move = 2
	random_size = FALSE

/obj/item/shard/shrapnel/upp/bits
	name = "tiny shrapnel"
	desc = "A tiny piece of shrapnel that used to be embedded underneath someone's skin."
	icon_state = "tiny"
	damage_on_move = 0.5

/obj/item/shard/shrapnel/bone_chips
	name = "bone shrapnel chips"
	gender = PLURAL
	icon_state = "bonechips"
	matter = list("bone" = 50)
	desc = "It looks like it came from a prehistoric animal."
	damage_on_move = 0.6
	random_size = FALSE

/obj/item/shard/shrapnel/bone_chips/human
	name = "human bone fragments"
	icon_state = "humanbonechips"
	desc = "Oh god, their bits are everywhere!"

/obj/item/shard/shrapnel/bone_chips/xeno
	name = "alien bone fragments"
	icon_state = "alienbonechips"
	desc = "Sharp, jagged fragments of alien bone. Looks like the previous owner exploded violently..."

/obj/item/shard/shrapnel/tutorial
	damage_on_move = 0

/obj/item/sharp
	name = "sharp dart shrapnel"
	desc = "It looks like a used 9X-E Sticky Explosive Dart, useless now."
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "sharp_explosive_dart"
	sharp = IS_SHARP_ITEM_BIG
	w_class = SIZE_SMALL
	edge = TRUE
	force = 0
	throwforce = 0
	garbage = TRUE
	var/damage_on_move = 3
	var/count = 1

/obj/item/sharp/Initialize(mapload, dir)
	. = ..()
	if(dir && dir <= 6)
		turn_object(90)
	else
		turn_object(270)

/obj/item/sharp/proc/on_embed(mob/embedded_mob, obj/limb/target_organ)
	return

/obj/item/sharp/proc/on_embedded_movement(mob/living/embedded_mob)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	var/obj/limb/organ = embedded_organ
	if(istype(organ))
		organ.take_damage(damage_on_move * count, 0, 0, no_limb_loss = TRUE)
		embedded_mob.pain.apply_pain(damage_on_move * count)

/obj/item/sharp/proc/turn_object(amount)
	var/matrix/initial_matrix = matrix(transform)
	initial_matrix.Turn(amount)
	apply_transform(initial_matrix)

/obj/item/sharp/explosive
	name = "\improper 9X-E Sticky Explosive Dart"

/obj/item/sharp/incendiary
	name = "\improper 9X-T Sticky Incendiary Dart"
	desc = "It looks like a used 9X-T Sticky Incendiary Dart, useless now."
	icon_state = "sharp_incendiary_dart"

/obj/item/sharp/flechette
	name = "\improper 9X-F Flechette Dart"
	desc = "It looks like a used 9X-F Flechette Dart, useless now."
	icon_state = "sharp_flechette_dart"
