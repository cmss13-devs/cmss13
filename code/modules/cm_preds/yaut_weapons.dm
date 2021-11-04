/*#########################################
########### Weapon Reused Procs ###########
#########################################*/
//Onehanded Weapons
/obj/item/weapon/melee/yautja/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/melee/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/weapon/melee/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

//Twohanded Weapons
/obj/item/weapon/melee/twohanded/yautja/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/melee/twohanded/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/weapon/melee/twohanded/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

//Ranged Weapons
/obj/item/weapon/gun/energy/yautja/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/gun/energy/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/gun/energy/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

//Spike Launcher
/obj/item/weapon/gun/launcher/spike/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/gun/launcher/spike/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/gun/launcher/spike/Destroy()
	. = ..()
	remove_from_missing_pred_gear(src)
	STOP_PROCESSING(SSobj, src)

/*#########################################
############## Misc Weapons ###############
#########################################*/
/obj/item/weapon/melee/harpoon/yautja
	name = "large harpoon"
	desc = "A huge metal spike, with a hook at the end. It's carved with mysterious alien writing."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "spike"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)
	item_state = "harpoon"

	embeddable = FALSE
	attack_verb = list("jabbed","stabbed","ripped", "skewered")
	throw_range = 4
	unacidable = TRUE
	edge = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharp = IS_SHARP_ITEM_BIG

/obj/item/weapon/melee/harpoon/yautja/New()
	. = ..()

	force = MELEE_FORCE_TIER_2
	throwforce = MELEE_FORCE_TIER_6

/obj/item/weapon/wristblades
	name = "wrist blades"
	desc = "A pair of huge, serrated blades extending from a metal gauntlet."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "wrist"
	item_state = "wristblade"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)

	w_class = SIZE_HUGE
	edge = TRUE
	sharp = IS_SHARP_ITEM_ACCURATE
	flags_item = NOSHIELD|NODROP|ITEM_PREDATOR
	flags_equip_slot = NO_FLAGS
	hitsound = 'sound/weapons/wristblades_hit.ogg'
	attack_speed = 6
	force = MELEE_FORCE_TIER_4
	pry_capable = IS_PRY_CAPABLE_FORCE
	attack_verb = list("sliced", "slashed", "jabbed", "torn", "gored")

/obj/item/weapon/wristblades/New()
	..()
	if(usr)
		var/obj/item/weapon/wristblades/W = usr.get_inactive_hand()
		if(istype(W)) //wristblade in usr's other hand.
			attack_speed = attack_speed - attack_speed/3

/obj/item/weapon/wristblades/dropped(mob/living/carbon/human/M)
	playsound(M,'sound/weapons/wristblades_off.ogg', 15, 1)
	if(M)
		var/obj/item/weapon/wristblades/W = M.get_inactive_hand()
		if(istype(W))
			W.attack_speed = initial(attack_speed)
	..()

/obj/item/weapon/wristblades/afterattack(atom/A, mob/user, proximity)
	if(!proximity || !user || user.action_busy)
		return FALSE

	if(istype(A, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/D = A
		if(D.operating || !D.density || D.locked)
			return FALSE
		if(D.heavy)
			to_chat(usr, SPAN_DANGER("[D] is too heavy to be forced open."))
			return FALSE
		user.visible_message(SPAN_DANGER("[user] jams their [name] into [D] and strains to rip it open."),
		SPAN_DANGER("You jam your [name] into [D] and strain to rip it open."))
		playsound(user,'sound/weapons/wristblades_hit.ogg', 15, TRUE)
		if(do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && D.density)
			user.visible_message(SPAN_DANGER("[user] forces [D] open with the [name]."),
			SPAN_DANGER("You force [D] open with the [name]."))
			D.open(TRUE)

	else if(istype(A, /obj/structure/mineral_door/resin))
		var/obj/structure/mineral_door/resin/D = A
		if(D.isSwitchingStates || user.a_intent == INTENT_HARM || user.action_busy) return
		if(D.density)
			user.visible_message(SPAN_DANGER("[user] jams their [name] into [D] and strains to rip it open."),
			SPAN_DANGER("You jam your [name] into [D] and strain to rip it open."))
			playsound(user, 'sound/weapons/wristblades_hit.ogg', 15, TRUE)
			if(do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && D.density)
				user.visible_message(SPAN_DANGER("[user] forces [D] open using the [name]."),
				SPAN_DANGER("You force [D] open with your [name]."))
				D.Open()
		else
			user.visible_message(SPAN_DANGER("[user] pushes [D] with their [name] to force it closed."),
			SPAN_DANGER("You push [D] with your [name] to force it closed."))
			playsound(user, 'sound/weapons/wristblades_hit.ogg', 15, TRUE)
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && !D.density)
				user.visible_message(SPAN_DANGER("[user] forces [D] closed using the [name]."),
				SPAN_DANGER("You force [D] closed with your [name]."))
				D.Close()

/obj/item/weapon/wristblades/attack_self(mob/user)
	..()
	for(var/obj/item/clothing/gloves/yautja/Y in user.contents)
		Y.wristblades()

/obj/item/weapon/wristblades/blades //simplest way to ensure scimitars don't get speedup buff.

/obj/item/weapon/wristblades/blades/afterattack(atom/A, mob/user, proximity)
	if(!proximity || !user || user.action_busy)
		return FALSE
	if(user)
		var/obj/item/weapon/wristblades/blades/W = user.get_inactive_hand()
		attack_speed = (istype(W)) ? 4 : initial(attack_speed)

	..()

/obj/item/weapon/wristblades/scimitar
	name = "wrist scimitar"
	desc = "A huge, serrated blade extending from a metal gauntlet."
	icon_state = "scim"
	item_state = "scim"
	attack_speed = 5
	attack_verb = list("sliced", "slashed", "jabbed", "torn", "gored")
	force = MELEE_FORCE_TIER_5

/*#########################################
########### One Handed Weapons ############
#########################################*/
/obj/item/weapon/melee/yautja
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)

/obj/item/weapon/melee/yautja/chain
	name = "chainwhip"
	desc = "A segmented, lightweight whip made of durable, acid-resistant metal. Not very common among Yautja Hunters, but still a dangerous weapon capable of shredding prey."
	icon_state = "whip"
	item_state = "whip"
	flags_atom = FPRINT|CONDUCT
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_WAIST
	embeddable = FALSE
	w_class = SIZE_MEDIUM
	unacidable = TRUE
	force = MELEE_FORCE_TIER_6
	throwforce = MELEE_FORCE_TIER_5
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = TRUE
	attack_verb = list("whipped", "slashed","sliced","diced","shredded")
	hitsound = 'sound/weapons/chain_whip.ogg'


/obj/item/weapon/melee/yautja/chain/attack(mob/target, mob/living/user)
	. = ..()
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30

/obj/item/weapon/melee/yautja/sword
	name = "clan sword"
	desc = "An expertly crafted Yautja blade carried by hunters who wish to fight up close. Razor sharp, and capable of cutting flesh into ribbons. Commonly carried by aggresive and lethal hunters."
	icon_state = "clansword"
	flags_atom = FPRINT|CONDUCT
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_BACK
	force = MELEE_FORCE_TIER_7
	throwforce = MELEE_FORCE_TIER_5
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = TRUE
	embeddable = FALSE
	w_class = SIZE_LARGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 0.9 SECONDS
	unacidable = TRUE

	var/parrying
	var/parrying_duration = 3 SECONDS
	var/cur_parrying_cooldown
	var/parrying_delay = 11 SECONDS // effectively 8, starts counting on activation


/obj/item/weapon/melee/yautja/sword/attack(mob/living/target, mob/living/carbon/human/user, var/riposte)
	if(parrying && !riposte)
		to_chat(user, SPAN_WARNING("You're a bit busy concentrating to hit something."))
		return
	. = ..()
	if(!.)
		return
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30

/obj/item/weapon/melee/yautja/sword/attack_self(mob/living/carbon/human/user)
	..()
	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		if(do_after(user, 0.5 SECONDS, INTERRUPT_INCAPACITATED, BUSY_ICON_HOSTILE, src, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			var/wield_chance = 50 * max(1, user.skills.get_skill_level(SKILL_MELEE_WEAPONS))
			if(!prob(wield_chance))
				user.visible_message(SPAN_DANGER("[user] tries to hold \the [src] steadily but drops it!"),SPAN_DANGER("You focus on \the [src], attempting to hold it steadily, but its heavy weight makes you lose your grip!"))
				user.hand ? user.drop_l_hand() : user.drop_r_hand()
				return
	if(cur_parrying_cooldown > world.time)
		to_chat(user, SPAN_WARNING("You've attempted to parry too soon, you must wait a bit before regaining your focus."))
		return
	cur_parrying_cooldown = world.time + parrying_delay
	parry(user)

/obj/item/weapon/melee/yautja/sword/proc/parry(mob/living/carbon/human/user)
	user.visible_message(SPAN_HIGHDANGER("[user] starts holding \the [src] steadily..."),SPAN_DANGER("You focus on \the [src], holding it to parry any incoming attacks."))
	flags_item |= NODROP
	parrying = TRUE

	var/filt_color = COLOR_WHITE
	var/filt_alpha = 70
	filt_color += num2text(filt_alpha, 2, 16)
	user.add_filter("parry_sword", 1, list("type" = "outline", "color" = filt_color, "size" = 2))

	RegisterSignal(user, COMSIG_HUMAN_BULLET_ACT, .proc/deflect_bullet)
	RegisterSignal(user, COMSIG_HUMAN_XENO_ATTACK, .proc/riposte_slash)
	RegisterSignal(user, COMSIG_ITEM_ATTEMPT_ATTACK, .proc/riposte_melee)
	addtimer(CALLBACK(src, .proc/end_parry, user), parrying_duration)

/obj/item/weapon/melee/yautja/sword/proc/deflect_bullet(mob/living/carbon/human/user, var/x, var/y, obj/item/projectile/P)
	SIGNAL_HANDLER
	var/parry_chance = 100
	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		parry_chance = 50 * max(1, user.skills.get_skill_level(SKILL_MELEE_WEAPONS))

	if(P.ammo.flags_ammo_behavior & AMMO_NO_DEFLECT || P.projectile_override_flags & AMMO_NO_DEFLECT)
		return

	if(!prob(parry_chance))
		user.visible_message(SPAN_DANGER("[user] fails to deflect \the [P]!"),SPAN_DANGER("You fail to deflect \the [P]!"))
		return

	if(!P.runtime_iff_group)
		user.visible_message(SPAN_DANGER("[user] blocks \the [P] and deflects it back at [P.firer]!"),SPAN_DANGER("You parry \the [P] and deflect it at [P.firer]!"))

		var/obj/item/projectile/new_proj = new(src)
		new_proj.generate_bullet(P.ammo, special_flags = P.projectile_override_flags|AMMO_HOMING|AMMO_NO_DEFLECT)
		new_proj.firer = user

		// Move back to who fired you.
		new_proj.jank_wrapper()

		new_proj.fire_at(P.firer, user, src, 10, speed = P.ammo.shell_speed)
	return COMPONENT_CANCEL_BULLET_ACT

/obj/item/weapon/melee/yautja/sword/proc/riposte_slash(mob/living/carbon/human/user, list/slashdata, var/mob/living/carbon/Xenomorph/X)
	SIGNAL_HANDLER
	if(user.is_mob_incapacitated())
		return

	var/parry_chance = 100
	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		parry_chance = 50 * max(1, user.skills.get_skill_level(SKILL_MELEE_WEAPONS))

	if(!prob(parry_chance))
		user.visible_message(SPAN_DANGER("[user] fails to block the slash!"),SPAN_DANGER("You fail to parry the slash!"))
		return

	user.visible_message(SPAN_DANGER("[user] blocks the slash and counterattacks!"),SPAN_DANGER("You parry the slash and initiate a riposte attack!"))
	slashdata["n_damage"] = 0
	attack(X, user, riposte = TRUE)

/obj/item/weapon/melee/yautja/sword/proc/riposte_melee(mob/living/carbon/human/user, var/mob/living/carbon/human/target)
	SIGNAL_HANDLER
	if(user.is_mob_incapacitated())
		return

	if(user == target)
		return

	var/parry_chance = 100
	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		parry_chance = 50 * max(1, user.skills.get_skill_level(SKILL_MELEE_WEAPONS))

	if(!prob(parry_chance))
		user.visible_message(SPAN_DANGER("[user] fails to block the slash!"),SPAN_DANGER("You fail to parry the slash!"))
		return

	target.animation_attack_on(user)
	user.visible_message(SPAN_DANGER("[user] blocks the slash and counterattacks!"),SPAN_DANGER("You parry the slash and initiate a riposte attack!"))
	attack(target, user, riposte = TRUE)
	return COMPONENT_CANCEL_ATTACK

/obj/item/weapon/melee/yautja/sword/proc/end_parry(mob/living/carbon/human/user)
	user.visible_message(SPAN_HIGHDANGER("[user] lowers \the [src]."),SPAN_DANGER("You lower \the [src], no longer parrying."))
	flags_item &= ~NODROP
	parrying = FALSE

	user.remove_filter("parry_sword")

	UnregisterSignal(user, list(COMSIG_HUMAN_XENO_ATTACK, COMSIG_HUMAN_BULLET_ACT, COMSIG_ITEM_ATTEMPT_ATTACK))

/obj/item/projectile/proc/jank_wrapper()
	RegisterSignal(src, COMSIG_BULLET_PRE_HANDLE_MOB, .proc/bullet_ignore_mob)

/obj/item/projectile/proc/bullet_ignore_mob(var/mob/M)
	SIGNAL_HANDLER
	if(M == firer)
		return COMPONENT_BULLET_PASS_THROUGH

/obj/item/weapon/melee/yautja/scythe
	name = "double war scythe"
	desc = "A huge, incredibly sharp double blade used for hunting dangerous prey. This weapon is commonly carried by Yautja who wish to disable and slice apart their foes.."
	icon_state = "predscythe"
	item_state = "scythe"
	flags_atom = FPRINT|CONDUCT
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_TIER_6
	throwforce = MELEE_FORCE_TIER_5
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = TRUE
	embeddable = FALSE
	w_class = SIZE_LARGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	unacidable = TRUE

/obj/item/weapon/melee/yautja/scythe/attack(mob/living/target as mob, mob/living/carbon/human/user as mob)
	..()
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 15


	if(prob(15))
		user.visible_message(SPAN_DANGER("An opening in combat presents itself!"),SPAN_DANGER("You manage to strike at your foe once more!"))
		..() //Do it again! CRIT! This will be replaced by a bleed effect.

	return

//Combistick
/obj/item/weapon/melee/yautja/combistick
	name = "combi-stick"
	desc = "A compact yet deadly personal weapon. Can be concealed when folded. Functions well as a throwing weapon or defensive tool. A common sight in Yautja packs due to its versatility."
	icon_state = "combistick"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_BACK
	flags_item = TWOHANDED|ITEM_PREDATOR
	w_class = SIZE_LARGE
	embeddable = FALSE //It shouldn't embed so that the Yautja can actually use the yank combi verb, and so that it's not useless upon throwing it at someone.
	throw_speed = SPEED_VERY_FAST
	throw_range = 4
	unacidable = TRUE
	force = MELEE_FORCE_TIER_6
	throwforce = MELEE_FORCE_TIER_6
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("speared", "stabbed", "impaled")
	var/on = 1
	var/charged

	var/force_wielded = MELEE_FORCE_TIER_6
	var/force_unwielded = MELEE_FORCE_TIER_2
	var/force_storage = MELEE_FORCE_TIER_1

/obj/item/weapon/melee/yautja/combistick/try_to_throw(mob/living/user)
	if(!charged)
		to_chat(user, SPAN_WARNING("Your combistick refuses to leave your hand. You must charge it with blood from prey before throwing it."))
		return FALSE
	charged = FALSE
	remove_filter("combistick_charge")
	return TRUE


/obj/item/weapon/melee/yautja/combistick/IsShield()
	return on

/obj/item/weapon/melee/yautja/combistick/verb/use_unique_action()
	set category = "Weapons"
	set name = "Unique Action"
	set desc = "Activate or deactivate the combistick."
	set src in usr
	unique_action(usr)

/obj/item/weapon/melee/yautja/combistick/attack_self(mob/user)
	..()
	if(on)
		if(flags_item & WIELDED)
			unwield(user)
		else
			wield(user)
	else
		to_chat(user, SPAN_WARNING("You need to extend the combi-stick before you can wield it."))


/obj/item/weapon/melee/yautja/combistick/wield(var/mob/user)
	. = ..()
	if(!.)
		return
	force = force_wielded
	update_icon()

/obj/item/weapon/melee/yautja/combistick/unwield(mob/user)
	. = ..()
	if(!.)
		return
	force = force_unwielded
	update_icon()

/obj/item/weapon/melee/yautja/combistick/update_icon()
	if(flags_item & WIELDED)
		item_state = "combistick_w"
	else if(!on)
		item_state = "combistick_f"
	else
		item_state = "combistick"

/obj/item/weapon/melee/yautja/combistick/unique_action(mob/living/user)
	if(user.get_active_hand() != src)
		return
	if(!on)
		user.visible_message(SPAN_INFO("With a flick of their wrist, [user] extends [src]."),\
		SPAN_NOTICE("You extend [src]."),\
		"You hear blades extending.")
		playsound(src,'sound/handling/combistick_open.ogg', 50, TRUE, 3)
		icon_state = initial(icon_state)
		flags_equip_slot = initial(flags_equip_slot)
		flags_item |= TWOHANDED
		w_class = SIZE_LARGE
		force = force_unwielded
		throwforce = MELEE_FORCE_TIER_6
		attack_verb = list("speared", "stabbed", "impaled")

		if(blood_overlay && blood_color)
			overlays.Cut()
			add_blood(blood_color)
		on = TRUE
		update_icon()
	else
		unwield(user)
		to_chat(user, SPAN_NOTICE("You collapse [src] for storage."))
		playsound(src, 'sound/handling/combistick_close.ogg', 50, TRUE, 3)
		icon_state = initial(icon_state) + "_f"
		flags_equip_slot = SLOT_STORE
		flags_item &= ~TWOHANDED
		w_class = SIZE_TINY
		force = force_storage
		throwforce = MELEE_FORCE_TIER_6
		attack_verb = list("thwacked", "smacked")
		overlays.Cut()
		on = FALSE
		update_icon()

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)

	return

/obj/item/weapon/melee/yautja/combistick/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if(isSpeciesYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30

	if(target == user || target.stat == DEAD)
		to_chat(user, SPAN_DANGER("You think you're smart?")) //very funny
		return

	if(!charged)
		to_chat(user, SPAN_DANGER("Your combistick's reservoir fills up with your opponent's blood! You may now throw it!"))
		charged = TRUE
		var/color = target.get_blood_color()
		var/alpha = 70
		color += num2text(alpha, 2, 16)
		add_filter("combistick_charge", 1, list("type" = "outline", "color" = color, "size" = 2))

/obj/item/weapon/melee/yautja/combistick/attack_hand(mob/user) //Prevents marines from instantly picking it up via pickup macros.
	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		user.visible_message(SPAN_DANGER("[user] starts to untangle the chain on \the [src]..."), SPAN_NOTICE("You start to untangle the chain on \the [src]..."))
		if(do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			..()
	else ..()

/obj/item/weapon/melee/yautja/combistick/launch_impact(atom/hit_atom)
	if(isYautja(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		if(H.put_in_hands(src))
			hit_atom.visible_message(SPAN_NOTICE(" [hit_atom] expertly catches [src] out of the air. "), \
				SPAN_NOTICE(" You easily catch [src]. "))
			return
	..()

/obj/item/weapon/melee/yautja/knife
	name = "ceremonial dagger"
	desc = "A viciously sharp dagger enscribed with ancient Yautja markings. Smells thickly of blood. Carried by some hunters."
	icon_state = "predknife"
	item_state = "knife"
	flags_atom = FPRINT|CONDUCT
	flags_item = ITEM_PREDATOR|CAN_DIG_SHRAPNEL
	flags_equip_slot = SLOT_STORE
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_TIER_5
	w_class = SIZE_TINY
	throwforce = MELEE_FORCE_TIER_4
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	actions_types = list(/datum/action/item_action)
	unacidable = TRUE

/obj/item/weapon/melee/yautja/knife/attack(mob/living/mob_victim, mob/living/carbon/human/user)
	. =..()
	if(!.)
		return

	if(mob_victim.mob_size != MOB_SIZE_HUMAN)
		to_chat(user, SPAN_WARNING("You're not sure how to do that."))
		return

	var/mob/living/carbon/human/victim
	victim = mob_victim
	if(victim.stat != DEAD || victim.status_flags & PERMANENTLY_DEAD)
		return

	if(!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
		return

	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		to_chat(user, SPAN_WARNING("You're not strong enough to rip an entire [victim] apart. Also, that's kind of fucked up.")) //look at this dumbass
		return

	if(isSameSpecies(user, victim))
		to_chat(user, SPAN_HIGHDANGER("ARE YOU OUT OF YOUR MIND!?"))
		return

	if(isSpeciesSynth(victim))
		to_chat(user, SPAN_WARNING("You can't flay metal...")) //look at this dumbass
		return

	to_chat(user, SPAN_WARNING("You start flaying [victim].."))
	playsound(loc, 'sound/weapons/pierce.ogg', 25)
	if(do_after(user, 4 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
		to_chat(user, SPAN_WARNING("You prepare the skin, cutting the flesh off in vital places."))
		playsound(loc, 'sound/weapons/slash.ogg', 25)
		create_leftovers(victim, has_meat = TRUE, skin_amount = 0)
		for(var/L in victim.limbs)
			victim.apply_damage(15, BRUTE, L, sharp = FALSE)
		victim.add_flay_overlay(stage = 1)

		if(do_after(user, 4 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, victim))
			var/obj/limb/head/v_head = victim.get_limb("head")
			if(v_head) //they might be beheaded
				create_leftovers(victim, has_meat = FALSE, skin_amount = 1)
				victim.apply_damage(10, BRUTE, v_head, sharp = FALSE)
				v_head.disfigured = TRUE
				if(victim.h_style == "Bald") //you can't scalp someone with no hair.
					to_chat(user, SPAN_WARNING("You make some rough cuts on [victim]'s head and face with \the [src]."))
				else
					to_chat(user, SPAN_WARNING("You use \the [src] to cut around [victim]'s hairline, then rip \his scalp from \his head."))
					var/obj/item/scalp/cut_scalp = new(get_turf(user), victim, user) //Create a scalp of the victim at the user's feet.
					user.put_in_inactive_hand(cut_scalp) //Put it in the user's offhand if possible.
					victim.h_style = "Bald"
					victim.update_hair() //tear the hair off with the scalp
			playsound(loc, 'sound/weapons/slashmiss.ogg', 25)

			if(do_after(user, 4 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, victim))
				to_chat(user, SPAN_WARNING("You jab \the [src] into the flesh cuts, using them to tear off most of the skin, the remainder skin hanging off the flesh."))
				playsound(loc, 'sound/weapons/bladeslice.ogg', 25)
				create_leftovers(victim, has_meat = FALSE, skin_amount = 3)
				for(var/L in victim.limbs)
					victim.apply_damage(18, BRUTE, L, sharp = FALSE)
				victim.remove_overlay(UNDERWEAR_LAYER)
				victim.f_style = "Shaved"
				victim.update_hair() //then rip the beard off along the skin
				victim.add_flay_overlay(stage = 2)

				if(do_after(user, 4 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, victim))
					to_chat(user, SPAN_WARNING("You completely flay [victim], sloppily ripping most remaining flesh and skin off the body. Use rope to hang them from the ceiling."))
					playsound(loc, 'sound/weapons/wristblades_hit.ogg', 25)
					create_leftovers(victim, has_meat = TRUE, skin_amount = 2)
					for(var/L in victim.limbs)
						victim.apply_damage(22, BRUTE, L, sharp = FALSE)
					for(var/obj/item/I in victim)
						victim.drop_inv_item_to_loc(I, victim.loc, FALSE, TRUE)

					victim.status_flags |= PERMANENTLY_DEAD
					victim.add_flay_overlay(stage = 3)

/mob/living/carbon/human/proc/add_flay_overlay(var/stage = 1)
	remove_overlay(FLAY_LAYER)
	var/image/flay_icon = new /image('icons/mob/humans/dam_human.dmi', "human_[stage]")
	flay_icon.layer = -FLAY_LAYER
	overlays_standing[FLAY_LAYER] = flay_icon
	apply_overlay(FLAY_LAYER)

/obj/item/weapon/melee/yautja/knife/proc/create_leftovers(mob/living/victim, var/has_meat, var/skin_amount)
	if(has_meat)
		var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
		meat.name = "raw [victim.name] steak"

	if(skin_amount)
		var/obj/item/stack/sheet/animalhide/human/hide = new /obj/item/stack/sheet/animalhide/human(victim.loc)
		hide.name = "[victim.name]-hide"
		hide.singular_name = "[victim.name]-hide"
		hide.stack_id = "[victim.name]-hide"
		hide.amount = skin_amount



/*#########################################
########### Two Handed Weapons ############
#########################################*/
/obj/item/weapon/melee/twohanded/yautja
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)

	flags_item = NOSHIELD|TWOHANDED|ITEM_PREDATOR
	unacidable = TRUE
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	throw_speed = SPEED_VERY_FAST
	edge = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/melee/twohanded/yautja/spear
	name = "hunter spear"
	desc = "A spear of exquisite design, used by an ancient civilisation."
	icon_state = "spearhunter"
	item_state = "spearhunter"
	force = MELEE_FORCE_TIER_3
	force_wielded = MELEE_FORCE_TIER_7
	sharp = IS_SHARP_ITEM_SIMPLE
	attack_verb = list("attacked", "stabbed", "jabbed", "torn", "gored")

/obj/item/weapon/melee/twohanded/yautja/glaive
	name = "war glaive"
	desc = "A huge, powerful blade on a metallic pole. Mysterious writing is carved into the weapon."
	icon_state = "glaive"
	item_state = "glaive"
	force = MELEE_FORCE_TIER_3
	force_wielded = MELEE_FORCE_TIER_9
	throwforce = MELEE_FORCE_TIER_6
	embeddable = FALSE //so predators don't lose their glaive when thrown.
	sharp = IS_SHARP_ITEM_BIG
	flags_atom = FPRINT|CONDUCT
	attack_verb = list("sliced", "slashed", "carved", "diced", "gored")
	attack_speed = 14 //Default is 7.

/obj/item/weapon/melee/twohanded/yautja/glaive/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if(isYautja(user) && isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		X.interference = 30

/obj/item/weapon/melee/twohanded/yautja/glaive/damaged
	name = "ancient war glaive"
	desc = "A huge, powerful blade on a metallic pole. Mysterious writing is carved into the weapon. This one is ancient and has suffered serious acid damage, making it near-useless."
	force = MELEE_FORCE_WEAK
	force_wielded = MELEE_FORCE_NORMAL
	throwforce = MELEE_FORCE_WEAK
	icon_state = "glaive_alt"
	item_state = "glaive_alt"


/*#########################################
############## Ranged Weapons #############
#########################################*/


//Spike launcher
/obj/item/weapon/gun/launcher/spike
	name = "spike launcher"
	desc = "A compact Yautja device in the shape of a crescent. It can rapidly fire damaging spikes and automatically recharges."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "spikelauncher"
	item_state = "spikelauncher"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)

	muzzle_flash = null // TO DO, add a decent one.

	unacidable = TRUE
	fire_sound = 'sound/effects/woodhit.ogg' // TODO: Decent THWOK noise.
	ammo = /datum/ammo/alloy_spike
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	w_class = SIZE_MEDIUM //Fits in yautja bags.
	var/spikes = 12
	var/max_spikes = 12
	var/last_regen
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR

/obj/item/weapon/gun/launcher/spike/process()
	if(spikes < max_spikes && world.time > last_regen + 100 && prob(70))
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/weapon/gun/launcher/spike/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time
	update_icon()
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag
	verbs -= /obj/item/weapon/gun/verb/use_unique_action

/obj/item/weapon/gun/launcher/spike/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


/obj/item/weapon/gun/launcher/spike/examine(mob/user)
	if(isYautja(user))
		..()
		to_chat(user, "It currently has [spikes] / [max_spikes] spikes.")
	else to_chat(user, "Looks like some kind of...mechanical donut.")

/obj/item/weapon/gun/launcher/spike/update_icon()
	..()
	var/new_icon_state = spikes <=1 ? null : icon_state + "[round(spikes/4, 1)]"
	update_special_overlay(new_icon_state)

/obj/item/weapon/gun/launcher/spike/able_to_fire(mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return

	return ..()

/obj/item/weapon/gun/launcher/spike/load_into_chamber()
	if(spikes > 0)
		in_chamber = create_bullet(ammo, initial(name))
		spikes--
		return in_chamber

/obj/item/weapon/gun/launcher/spike/has_ammunition()
	if(spikes > 0)
		return TRUE //Enough spikes for a shot.

/obj/item/weapon/gun/launcher/spike/reload_into_chamber()
	update_icon()
	return TRUE

/obj/item/weapon/gun/launcher/spike/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) spikes++
	return TRUE


/obj/item/weapon/gun/energy/yautja
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)

/obj/item/weapon/gun/energy/yautja/plasmarifle
	name = "plasma rifle"
	desc = "A long-barreled heavy plasma weapon capable of taking down large game. It has a mounted scope for distant shots and an integrated battery."
	icon_state = "plasmarifle"
	item_state = "plasmarifle"
	unacidable = TRUE
	fire_sound = 'sound/weapons/pred_plasma_shot.ogg'
	ammo = /datum/ammo/energy/yautja/rifle/bolt
	muzzle_flash = null // TO DO, add a decent one.
	zoomdevicename = "scope"
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_HUGE
	var/charge_time = 0
	var/last_regen = 0
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR

/obj/item/weapon/gun/energy/yautja/plasmarifle/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time
	update_icon()

	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag
	verbs -= /obj/item/weapon/gun/verb/use_unique_action

/obj/item/weapon/gun/energy/yautja/plasmarifle/process()
	if(charge_time < 100)
		charge_time++
		if(charge_time == 99)
			if(ismob(loc)) to_chat(loc, SPAN_NOTICE("[src] hums as it achieves maximum charge."))
		update_icon()


/obj/item/weapon/gun/energy/yautja/plasmarifle/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*2
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


/obj/item/weapon/gun/energy/yautja/plasmarifle/examine(mob/user)
	if(isYautja(user))
		..()
		to_chat(user, "It currently has [charge_time] / 100 charge.")
	else to_chat(user, "This thing looks like an alien rifle of some kind. Strange.")

/obj/item/weapon/gun/energy/yautja/plasmarifle/update_icon()
	if(last_regen < charge_time + 20 || last_regen > charge_time || charge_time > 95)
		var/new_icon_state = charge_time <=15 ? null : icon_state + "[round(charge_time/33, 1)]"
		update_special_overlay(new_icon_state)
		last_regen = charge_time

/obj/item/weapon/gun/energy/yautja/plasmarifle/able_to_fire(mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return

	return ..()

/obj/item/weapon/gun/energy/yautja/plasmarifle/load_into_chamber()
	if(charge_time >= 80)
		ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/rifle/blast]
		charge_time = 0
	else
		ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/rifle/bolt]
		charge_time -= 10
	var/obj/item/projectile/P = create_bullet(ammo, initial(name))
	P.SetLuminosity(1)
	in_chamber = P
	return in_chamber

/obj/item/weapon/gun/energy/yautja/plasmarifle/has_ammunition()
	return TRUE //Plasma rifle appears to have infinite ammunition.

/obj/item/weapon/gun/energy/yautja/plasmarifle/reload_into_chamber()
	update_icon()
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasmarifle/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) charge_time *= 2
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasmapistol
	name = "plasma pistol"
	desc = "A plasma pistol capable of rapid fire. It has an integrated battery."
	icon_state = "plasmapistol"
	item_state = "plasmapistol"

	unacidable = TRUE
	fire_sound = 'sound/weapons/pulse3.ogg'
	flags_equip_slot = SLOT_WAIST
	ammo = /datum/ammo/energy/yautja/pistol
	muzzle_flash = null // TO DO, add a decent one.
	w_class = SIZE_MEDIUM
	var/charge_time = 40
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR

/obj/item/weapon/gun/energy/yautja/plasmapistol/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag



/obj/item/weapon/gun/energy/yautja/plasmapistol/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)


/obj/item/weapon/gun/energy/yautja/plasmapistol/process()
	if(charge_time < 40)
		charge_time++
		if(charge_time == 39)
			if(ismob(loc)) to_chat(loc, SPAN_NOTICE("[src] hums as it achieves maximum charge."))



/obj/item/weapon/gun/energy/yautja/plasmapistol/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_7
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT



/obj/item/weapon/gun/energy/yautja/plasmapistol/examine(mob/user)
	if(isYautja(user))
		..()
		to_chat(user, "It currently has [charge_time] / 40 charge.")
	else
		to_chat(user, "This thing looks like an alien rifle of some kind. Strange.")


/obj/item/weapon/gun/energy/yautja/plasmapistol/able_to_fire(mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return
	else
		return ..()

/obj/item/weapon/gun/energy/yautja/plasmapistol/load_into_chamber()
	if(charge_time < 1)
		return
	var/obj/item/projectile/P = create_bullet(ammo, initial(name))
	P.SetLuminosity(1)
	in_chamber = P
	charge_time--
	return in_chamber

/obj/item/weapon/gun/energy/yautja/plasmapistol/has_ammunition()
	if(charge_time >= 1)
		return TRUE //Enough charge for a shot.

/obj/item/weapon/gun/energy/yautja/plasmapistol/reload_into_chamber()
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasmapistol/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) charge_time *= 2
	return TRUE


/obj/item/weapon/gun/energy/yautja/plasma_caster
	name = "plasma caster"
	desc = "A powerful, shoulder-mounted energy weapon."
	icon_state = "plasma"
	item_state = "plasma_wear"
	fire_sound = 'sound/weapons/pred_plasmacaster_fire.ogg'
	ammo = /datum/ammo/energy/yautja/caster/stun
	muzzle_flash = null // TO DO, add a decent one.
	w_class = SIZE_HUGE
	force = 0
	fire_delay = 3
	actions_types = list(/datum/action/item_action/toggle)
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON|DELONDROP //Can't bludgeon with this.
	flags_gun_features = GUN_UNUSUAL_DESIGN
	has_empty_icon = FALSE

	var/obj/item/clothing/gloves/yautja/source = null
	var/charge_cost = 100 //How much energy is needed to fire.
	var/mode = "stun"//fire mode (stun/lethal)
	var/strength = "low power stun bolts"//what it's shooting

/obj/item/weapon/gun/energy/yautja/plasma_caster/Initialize(mapload, spawn_empty)
	. = ..()
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag

/obj/item/weapon/gun/energy/yautja/plasma_caster/Destroy()
	. = ..()
	source = null


/obj/item/weapon/gun/energy/yautja/plasma_caster/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + FIRE_DELAY_TIER_6
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/energy/yautja/plasma_caster/attack_self(mob/living/user)
	..()

	switch(mode)
		if("stun")
			switch(strength)
				if("low power stun bolts")
					strength = "high power stun bolts"
					charge_cost = 100
					fire_delay = FIRE_DELAY_TIER_6 * 3
					fire_sound = 'sound/weapons/pred_lasercannon.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/bolt/stun]
				if("high power stun bolts")
					strength = "plasma immobilizers"
					charge_cost = 300
					fire_delay = FIRE_DELAY_TIER_6 * 20
					fire_sound = 'sound/weapons/pulse.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/sphere/stun]
				if("plasma immobilizers")
					strength = "low power stun bolts"
					charge_cost = 30
					fire_delay = FIRE_DELAY_TIER_6
					fire_sound = 'sound/weapons/pred_lasercannon.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/stun]
		if("lethal")
			switch(strength)
				if("plasma bolts")
					strength = "plasma spheres"
					charge_cost = 1200
					fire_delay = FIRE_DELAY_TIER_6 * 20
					fire_sound = 'sound/weapons/pulse.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/sphere]
				if("plasma spheres")
					strength = "plasma bolts"
					charge_cost = 100
					fire_delay = FIRE_DELAY_TIER_6 * 3
					fire_sound = 'sound/weapons/pred_lasercannon.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/bolt]

/obj/item/weapon/gun/energy/yautja/plasma_caster/use_unique_action()
	switch(mode)
		if("stun")
			mode = "lethal"
			to_chat(usr, SPAN_YAUTJABOLD("[src.source] beep: [src] is now set to [mode] mode"))
			strength = "plasma bolts"
			charge_cost = 100
			fire_delay = FIRE_DELAY_TIER_6 * 3
			fire_sound = 'sound/weapons/pred_lasercannon.ogg'
			to_chat(usr, SPAN_NOTICE("[src] will now fire [strength]."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/bolt]

		if("lethal")
			mode = "stun"
			to_chat(usr, SPAN_YAUTJABOLD("[src.source] beep: [src] is now set to [mode] mode"))
			strength = "low power stun bolts"
			charge_cost = 30
			fire_delay = FIRE_DELAY_TIER_6
			fire_sound = 'sound/weapons/pred_lasercannon.ogg'
			to_chat(usr, SPAN_NOTICE("[src] will now fire [strength]."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/stun]

/obj/item/weapon/gun/energy/yautja/plasma_caster/examine(mob/user)
	. = ..()
	var/msg = "It is set to fire [strength]."
	if(mode == "lethal")
		to_chat(user, SPAN_RED(msg))
	else
		to_chat(user, SPAN_ORANGE(msg))

/obj/item/weapon/gun/energy/yautja/plasma_caster/dropped(mob/living/carbon/human/M)
	playsound(M,'sound/weapons/pred_plasmacaster_off.ogg', 15, 1)
	if(source)
		forceMove(source)
		return
	..()

/obj/item/weapon/gun/energy/yautja/plasma_caster/able_to_fire(mob/user)
	if(!source)	return
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return

	return ..()

/obj/item/weapon/gun/energy/yautja/plasma_caster/load_into_chamber()
	if(source.drain_power(usr,charge_cost))
		in_chamber = create_bullet(ammo, initial(name))
		return in_chamber

/obj/item/weapon/gun/energy/yautja/plasma_caster/has_ammunition()
	if(source?.charge >= charge_cost)
		return TRUE //Enough charge for a shot.

/obj/item/weapon/gun/energy/yautja/plasma_caster/reload_into_chamber()
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasma_caster/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund)
		source.charge += charge_cost
		var/perc = source.charge / source.charge_max * 100
		var/mob/living/carbon/human/user = usr //Hacky...
		user.update_power_display(perc)
	return TRUE
