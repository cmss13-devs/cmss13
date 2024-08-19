// Flags.

/obj/item/stack/flag
	name = "flags"
	desc = "Some colorful flags."
	singular_name = "flag"
	amount = 10
	max_amount = 10
	icon = 'icons/obj/structures/props/mining.dmi'
	stack_id = "flags"
	var/upright = FALSE
	var/base_state

/obj/item/stack/flag/Initialize()
	. = ..()
	base_state = icon_state

/obj/item/stack/flag/red
	name = "red flags"
	singular_name = "red flag"
	icon_state = "redflag"

/obj/item/stack/flag/yellow
	name = "yellow flags"
	singular_name = "yellow flag"
	icon_state = "yellowflag"

/obj/item/stack/flag/green
	name = "green flags"
	singular_name = "green flag"
	icon_state = "greenflag"

/obj/item/stack/flag/blue
	name = "blue flags"
	singular_name = "blue flag"
	icon_state = "blueflag"

/obj/item/stack/flag/purple
	name = "purple flags"
	singular_name = "purple flag"
	icon_state = "purpleflag"

/obj/item/stack/flag/attackby(obj/item/W, mob/user)
	if(upright && istype(W,src.type))
		src.attack_hand(user)
	else
		..()

/obj/item/stack/flag/attack_hand(user)
	if(upright)
		upright = 0
		icon_state = base_state
		anchored = FALSE
		src.visible_message("<b>[user]</b> knocks down [src].")
	else
		..()

/obj/item/stack/flag/attack_self(mob/user)
	..()

	var/turf/T = get_turf(src)
	if(!T)
		to_chat(user, "The flag won't stand up in this terrain.")
		return

	var/obj/item/stack/flag/F = locate() in get_turf(src)
	if(F && F.upright)
		to_chat(user, "There is already a flag here.")
		return

	var/obj/item/stack/flag/newflag = new src.type(T)
	newflag.amount = 1
	newflag.upright = TRUE
	newflag.anchored = TRUE
	newflag.name = newflag.singular_name
	newflag.icon_state = "[newflag.base_state]_open"
	newflag.visible_message("<b>[user]</b> plants [newflag] firmly in the ground.")
	src.use(1)


/// PLANTABLE FLAG

/obj/structure/flag/plantable
	name = "flag"
	desc = "A flag of something. This one looks like you could dismantle it."
	icon = 'icons/obj/structures/plantable_flag.dmi'
	pixel_x = 9 // All flags need to be offset to the right by 9 to be centered.
	layer = ABOVE_XENO_LAYER
	health = 150
	unacidable = TRUE

	/// The typepath for the flag item that gets spawned when the flag is taken down.
	var/flag_type = /obj/item/flag/plantable
	/// Used to limit the spam of the warcry_extra_sound
	COOLDOWN_DECLARE(warcry_cooldown_struc)

/obj/structure/flag/plantable/attack_hand(mob/user)
	..()
	disassemble(user, flag_type)

/// Proc for dismantling the flag into an item that can be picked up.
/obj/structure/flag/plantable/proc/disassemble(mob/user, flag_type)
	if(user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user] starts taking [src] down..."), SPAN_NOTICE("You start taking [src] down..."))

	playsound(loc, 'sound/effects/flag_raising.ogg', 30)
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC) || QDELETED(src))
		return

	playsound(loc, 'sound/effects/flag_raised.ogg', 30)
	user.visible_message(SPAN_NOTICE("[user] starts takes [src] down!"), SPAN_NOTICE("You take [src] down!"))
	var/obj/item/flag/plantable/flag_item = new flag_type(loc)
	user.put_in_hands(flag_item)
	COOLDOWN_START(flag_item, warcry_cooldown_item, COOLDOWN_TIMELEFT(src, warcry_cooldown_struc))
	qdel(src)

/// Proc for when the flag gets forcefully dismantled (due to general damage, explosions, etc.)
/obj/structure/flag/plantable/proc/demolish(flag_type)
	playsound(loc, 'sound/effects/flag_raised.ogg', 30)
	visible_message(SPAN_WARNING("[src] crumples to the ground!"))
	var/obj/item/flag/plantable/flag_item = new flag_type(loc)
	COOLDOWN_START(flag_item, warcry_cooldown_item, COOLDOWN_TIMELEFT(src, warcry_cooldown_struc))
	qdel(src)

// Procs for handling damage.
/obj/structure/flag/plantable/update_health(damage)
	if(damage)
		health -= damage
	if(health <= 0)
		demolish(flag_type)

/obj/structure/flag/plantable/ex_act(severity)
	if(health <= 0)
		return
	update_health(severity)

/obj/structure/flag/plantable/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent == INTENT_HARM)
		if(unslashable)
			return
		xeno.animation_attack_on(src)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno] slashes [src]!"), SPAN_DANGER("We slash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		update_health(rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
		return XENO_ATTACK_ACTION
	else
		to_chat(xeno, SPAN_WARNING("We stare at [src] cluelessly."))
		return XENO_NONCOMBAT_ACTION

/obj/structure/flag/plantable/bullet_act(obj/projectile/bullet)
	bullet_ping(bullet)
	visible_message(SPAN_DANGER("[src] is hit by [bullet]!"), null, 4, CHAT_TYPE_TAKING_HIT)
	update_health(bullet.damage)
	return TRUE

/obj/structure/flag/plantable/attackby(obj/item/weapon, mob/living/user)
	if(!indestructible)
		visible_message(SPAN_DANGER("[src] has been hit by [user] with [weapon]!"), null, 5, CHAT_TYPE_MELEE_HIT)
		user.animation_attack_on(src)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		update_health(weapon.force * weapon.demolition_mod)

/obj/item/flag/plantable
	name = "plantable flag"
	desc = "A flag of something. This one looks ready to be planted into the ground."
	w_class = SIZE_LARGE
	throw_range = 2
	icon = 'icons/obj/structures/plantable_flag.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 15
	throwforce = 5
	hitsound = "swing_hit"
	unacidable = TRUE
	indestructible = TRUE
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_64.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_64.dmi'
		)

	/// The typepath of the flag structure that gets spawned when the flag is planted.
	var/flag_type = /obj/structure/flag/plantable
	/// Used to check if nearby mobs belong to a faction when calculating for the stronger warcry.
	var/faction
	/// Does the flag play a unique warcry when planted? (Only while on harm intent.)
	var/play_warcry = FALSE
	/// The warcry's sound path.
	var/warcry_sound
	/// When there are more than 14 allies nearby, play this stronger warcry.
	var/warcry_extra_sound
	/// How many nearby allies do we need for the stronger warcry to be played?
	var/allies_required = 14
	/// Used to limit the spam of the warcry_extra_sound
	COOLDOWN_DECLARE(warcry_cooldown_item)

/obj/item/flag/plantable/get_examine_text(mob/user)
	. = ..()
	if(play_warcry && user.faction == faction)
		. += SPAN_NOTICE("Planting the flag while in <b>HARM</b> intent will cause you to bellow out a rallying warcry!")

/// Proc for turning the flag item into a structure.
/obj/item/flag/plantable/proc/plant_flag(mob/living/user, play_warcry = FALSE, warcry_sound, warcry_extra_sound, faction)
	if(user.action_busy)
		return

	if(SSinterior.in_interior(user))
		to_chat(usr, SPAN_WARNING("There's no way to plant [src] in here!"))
		return

	var/turf/turf_to_plant = get_step(user, user.dir)
	if(istype(turf_to_plant, /turf/open))
		var/turf/open/floor = turf_to_plant
		if(!floor.allow_construction || istype(floor, /turf/open/space))
			to_chat(user, SPAN_WARNING("You cannot deploy [src] here, find a more secure surface!"))
			return
	else
		to_chat(user, SPAN_WARNING("[turf_to_plant] is blocking you from deploying [src]!"))
		return

	for(var/obj/object in turf_to_plant)
		if(object.density)
			to_chat(usr, SPAN_WARNING("You need a clear, open area to plant [src], something is blocking the way in front of you!"))
			return

	user.visible_message(SPAN_NOTICE("[user] starts planting [src] into the ground..."), SPAN_NOTICE("You start planting [src] into the ground..."))
	playsound(user, 'sound/effects/flag_raising.ogg', 30)
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	user.visible_message(SPAN_NOTICE("[user] plants [src] into the ground!"), SPAN_NOTICE("You plant [src] into the ground!"))
	var/obj/structure/flag/plantable/planted_flag = new flag_type(turf_to_plant)

	// If there are more than 14 allies nearby, play a stronger rallying cry.
	// Otherwise, play the default warcry sound if there is one. If not, play a generic flag raising sfx.
	if(play_warcry && user.faction == faction && user.a_intent == INTENT_HARM)
		var/allies_nearby = 0
		if(COOLDOWN_FINISHED(src, warcry_cooldown_item))
			for(var/mob/living/carbon/human in orange(planted_flag, 7))
				if(human.is_dead() || human.faction != faction)
					continue
				allies_nearby++

		user.show_speech_bubble("warcry")
		if(allies_nearby >= allies_required)
			playsound(user, warcry_extra_sound, 40)
			// Start a cooldown on the flag structure. This way we can keep track of the cooldown when the flag is hoisted and taken down.
			COOLDOWN_START(planted_flag, warcry_cooldown_struc, 90 SECONDS)
			user.manual_emote("shouts an invigorating rallying cry!")
		else
			playsound(user, warcry_sound, 30)
			user.manual_emote("shouts an inspiring cry!")
			// Ditto. If the cooldown isn't finished we have to transfer the leftover time to the structure.
			COOLDOWN_START(planted_flag, warcry_cooldown_struc, COOLDOWN_TIMELEFT(src, warcry_cooldown_item))
	else
		playsound(loc, 'sound/effects/flag_raised.ogg', 30)

	qdel(src)

/obj/item/flag/plantable/attack_self(mob/user)
	..()
	plant_flag(user, play_warcry, warcry_sound, warcry_extra_sound, faction)

// UNITED AMERICAS FLAG //
//////////////////////////

/obj/item/flag/plantable/ua
	name = "\improper United Americas flag"
	desc = "The flag of the United Americas. This one looks ready to be planted into the ground."
	icon = 'icons/obj/structures/plantable_flag.dmi'
	icon_state = "flag_ua"
	flag_type = /obj/structure/flag/plantable/ua
	faction = FACTION_MARINE
	play_warcry = TRUE
	warcry_sound = 'sound/effects/flag_warcry_ua.ogg'
	warcry_extra_sound = 'sound/effects/flag_warcry_ua_extra.ogg'

/obj/structure/flag/plantable/ua
	name = "\improper United Americas flag"
	desc = "The flag of the United Americas. Semper fi."
	icon_state = "flag_ua_planted"
	flag_type = /obj/item/flag/plantable/ua

// UNION OF PROGRESSIVE PEOPLES FLAG //
//////////////////////////

/obj/item/flag/plantable/upp
	name = "\improper Union of Progressive Peoples flag"
	desc = "The flag of the Union of Progressive Peoples. This one looks ready to be planted into the ground."
	icon = 'icons/obj/structures/plantable_flag.dmi'
	icon_state = "flag_upp"
	flag_type = /obj/structure/flag/plantable/upp
	faction = FACTION_UPP
	play_warcry = TRUE
	warcry_sound = 'sound/effects/flag_upp_warcry.ogg'
	warcry_extra_sound = 'sound/effects/flag_upp_warcry_extra.ogg'

/obj/structure/flag/plantable/upp
	name = "\improper Union of Progressive Peoples flag"
	desc = "The flag of the Union of Progressive Peoples. Unity through Strength, Freedom through Unity."
	icon_state = "flag_upp_planted"
	flag_type = /obj/item/flag/plantable/upp
