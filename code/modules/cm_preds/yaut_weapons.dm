#define FLAY_STAGE_SCALP 1
#define FLAY_STAGE_STRIP 2
#define FLAY_STAGE_SKIN 3

#define ABILITY_COST_COMBI 1
#define ABILITY_COST_CHAIN 3
#define ABILITY_COST_SCYTHE 5
#define ABILITY_COST_SWORD 0
#define ABILITY_COST_GLAIVE 0
#define ABILITY_COST_NO_ABILITY 0

#define ABILITY_CHARGE_SMALL 0.5
#define ABILITY_CHARGE_NORMAL 1
#define ABILITY_CHARGE_LARGE 2

#define ABILITY_MAX_SMALL 1
#define ABILITY_MAX_DEFAULT 2
#define ABILITY_MAX_LARGE 5

#define ABILITY_FILTER_NAME "ability_charge"

/*#########################################
########### Weapon Reused Procs ###########
#########################################*/
//Onehanded Weapons

/obj/item/weapon/gun/energy/yautja/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/gun/launcher/spike/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/*#########################################
############## Misc Weapons ###############
#########################################*/
/obj/item/weapon/harpoon/yautja
	name = "large harpoon"
	desc = "A huge metal spike with a hook at the end. It's carved with mysterious alien writing."

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
	edge = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharp = IS_SHARP_ITEM_BIG

/obj/item/weapon/harpoon/yautja/New()
	. = ..()

	force = MELEE_FORCE_TIER_2
	throwforce = MELEE_FORCE_TIER_6

/obj/item/weapon/wristblades
	name = "wrist blades"
	var/plural_name = "wrist blades"
	desc = "A pair of huge, serrated blades extending out from metal gauntlets."

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

	var/has_speed_bonus = TRUE

/obj/item/weapon/wristblades/equipped(mob/user, slot)
	. = ..()
	if(has_speed_bonus && (slot == WEAR_L_HAND || slot == WEAR_R_HAND) && istype(user.get_inactive_hand(), /obj/item/weapon/wristblades))
		attack_speed = initial(attack_speed) - 2

/obj/item/weapon/wristblades/dropped(mob/living/carbon/human/M)
	. = ..()
	attack_speed = initial(attack_speed)

/obj/item/weapon/wristblades/afterattack(atom/attacked_target, mob/user, proximity)
	if(!proximity || !user || user.action_busy)
		return FALSE

	if(istype(attacked_target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/door = attacked_target
		if(door.operating || !door.density || door.locked)
			return FALSE
		if(door.heavy)
			to_chat(usr, SPAN_DANGER("[door] is too heavy to be forced open."))
			return FALSE
		user.visible_message(SPAN_DANGER("[user] jams their [name] into [door] and strains to rip it open..."), SPAN_DANGER("You jam your [name] into [door] and strain to rip it open..."))
		playsound(user,'sound/weapons/wristblades_hit.ogg', 15, TRUE)
		if(do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && door.density)
			user.visible_message(SPAN_DANGER("[user] forces [door] open with the [name]!"), SPAN_DANGER("You force [door] open with the [name]."))
			door.open(TRUE)

	else if(istype(attacked_target, /obj/structure/mineral_door/resin))
		var/obj/structure/mineral_door/resin/door = attacked_target
		if(door.isSwitchingStates || user.a_intent == INTENT_HARM)
			return
		if(door.density)
			user.visible_message(SPAN_DANGER("[user] jams their [name] into [door] and strains to rip it open..."), SPAN_DANGER("You jam your [name] into [door] and strain to rip it open..."))
			playsound(user, 'sound/weapons/wristblades_hit.ogg', 15, TRUE)
			if(do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && door.density)
				user.visible_message(SPAN_DANGER("[user] forces [door] open using the [name]!"), SPAN_DANGER("You force [door] open with your [name]."))
				door.Open()
		else
			user.visible_message(SPAN_DANGER("[user] pushes [door] with their [name] to force it closed..."), SPAN_DANGER("You push [door] with your [name] to force it closed..."))
			playsound(user, 'sound/weapons/wristblades_hit.ogg', 15, TRUE)
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && !door.density)
				user.visible_message(SPAN_DANGER("[user] forces [door] closed using the [name]!"), SPAN_DANGER("You force [door] closed with your [name]."))
				door.Close()

/obj/item/weapon/wristblades/attack_self(mob/living/carbon/human/user)
	..()
	if(istype(user))
		var/obj/item/clothing/gloves/yautja/hunter/gloves = user.gloves
		gloves.wristblades_internal(user, TRUE) // unlikely that the yaut would have gloves without blades, so if they do, runtime logs here would be handy

/obj/item/weapon/wristblades/scimitar
	name = "wrist scimitar"
	plural_name = "wrist scimitars"
	desc = "A huge, serrated blade extending from metal gauntlets."
	icon_state = "scim"
	item_state = "scim"
	attack_speed = 5
	attack_verb = list("sliced", "slashed", "jabbed", "torn", "gored")
	force = MELEE_FORCE_TIER_6
	has_speed_bonus = FALSE

/obj/item/weapon/wristblades/scimitar/alt
	name = "wrist scimitar"
	plural_name = "wrist scimitars"
	desc = "A huge, serrated blade extending from metal gauntlets."
	icon_state = "scim_alt"
	item_state = "scim_alt"
	attack_speed = 5
	force = MELEE_FORCE_TIER_5
	has_speed_bonus = FALSE

/*#########################################
########### One Handed Weapons ############
#########################################*/
/obj/item/weapon/yautja
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)

	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_item = ITEM_PREDATOR
	unacidable = TRUE
	edge = TRUE
	w_class = SIZE_LARGE
	embeddable = FALSE

	var/human_adapted = FALSE
	///The amount this weapon interrupts hivemind link on Xenomorphs.
	var/xeno_interfere_amount = 30

	///The amount of charges towards use of special abilities.
	var/ability_charge = 0
	var/ability_charge_max = ABILITY_MAX_DEFAULT
	var/ability_charge_rate = ABILITY_CHARGE_NORMAL
	var/ability_cost = ABILITY_COST_NO_ABILITY
	///Whether the ability is ready to trigger
	var/ability_primed = FALSE

/obj/item/weapon/yautja/dropped()
	if(ability_primed)
		ability_primed = FALSE
	..()

/obj/item/weapon/yautja/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if((human_adapted || isspeciesyautja(user)) && isxeno(target))
		var/mob/living/carbon/xenomorph/xenomorph = target
		xenomorph.AddComponent(/datum/component/status_effect/interference, xeno_interfere_amount, xeno_interfere_amount)

	if(!ability_cost || !(HAS_TRAIT(user, TRAIT_YAUTJA_TECH)))
		return

	progress_ability(target, user)

/obj/item/weapon/yautja/proc/progress_ability(mob/living/target, mob/living/carbon/human/user)
	if(target == user || target.stat == DEAD || isanimal(target))
		to_chat(user, SPAN_DANGER("You think you're smart?")) //very funny
		return FALSE

	if(ability_charge < ability_charge_max)
		ability_charge = min(ability_charge_max, ability_charge + ability_charge_rate)
		to_chat(user, SPAN_DANGER("[src]'s reservoir fills up with your opponent's blood!"))

	if(ability_charge >= ability_cost)
		ready_ability(target, user)
	return TRUE

/obj/item/weapon/yautja/unique_action(mob/user)
	if(user.get_active_hand() != src)
		return FALSE
	if(ability_charge < ability_cost)
		to_chat(user, SPAN_WARNING("The blood reservoir is not full enough to do this!"))
		return FALSE
	return TRUE

/obj/item/weapon/yautja/get_examine_text(mob/user)
	. = ..()
	if(isyautja(user) && ability_cost)
		. += SPAN_WARNING("It currently has <b>[ability_charge]/[ability_charge_max]</b> blood charge(s).")
		. += SPAN_ORANGE("It requires <b>[ability_cost]</b> blood charge(s) to use its ability.")

/obj/item/weapon/yautja/proc/ready_ability(mob/living/target as mob, mob/living/carbon/human/user as mob)
	if(ability_charge >= ability_cost)
		var/color = target.get_blood_color()
		var/alpha = 70
		color += num2text(alpha, 2, 16)
		add_filter(ABILITY_FILTER_NAME, 1, list("type" = "outline", "color" = color, "size" = 2))
		return TRUE
	return FALSE

/obj/item/weapon/yautja/chain
	name = "chainwhip"
	desc = "A segmented, lightweight whip made of durable, acid-resistant metal. Not very common among Yautja Hunters, but still a dangerous weapon capable of shredding prey."
	icon_state = "whip"
	item_state = "whip"
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM
	force = MELEE_FORCE_TIER_7
	throwforce = MELEE_FORCE_TIER_4
	sharp = IS_SHARP_ITEM_SIMPLE
	attack_verb = list("whipped", "slashed","sliced","diced","shredded")
	attack_speed = 0.8 SECONDS
	hitsound = 'sound/weapons/chain_whip.ogg'

	ability_cost = ABILITY_COST_CHAIN
	ability_charge_max = ABILITY_COST_CHAIN

	var/chain_range = 3
	var/chain_duration = 30 SECONDS
	var/mob/trapped_mob
	var/datum/effects/tethering/tether_effect

/obj/item/weapon/yautja/chain/progress_ability(mob/living/target, mob/living/carbon/human/user)
	if(trapped_mob)
		return FALSE//No recharging ability while a mob is already captured.
	..()

/obj/item/weapon/yautja/chain/attack_self(mob/user)
	..()
	if(trapped_mob)
		var/choice = tgui_alert(user, "Do you wish to release your captive?", "Confirmation", list("Yes", "No"))
		if(choice != "Yes")
			return FALSE
		release_capture(user)
		reset_tether()
		return TRUE
	if(!(ability_charge >= ability_cost))
		return FALSE
	ability_primed = !ability_primed
	var/message = "You tighten your grip on [src], preparing to whirl it around your target."
	if(!ability_primed)
		message = "You relax your grip on [src]."
	to_chat(user, SPAN_WARNING(message))
	return TRUE

/obj/item/weapon/yautja/chain/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if(ability_primed)
		capture_target(user, target)

/obj/item/weapon/yautja/chain/proc/capture_target(mob/living/user, mob/living/target)
	var/real_chain_duration = chain_duration
	var/real_chain_range = chain_range
	if(target.mob_size >= MOB_SIZE_BIG)
		real_chain_duration = (chain_duration / 2)
		real_chain_range = (chain_range / 2)

	var/list/tether_effects = apply_tether(user, target, range = real_chain_range, resistable = TRUE)
	tether_effect = tether_effects["tetherer_tether"]
	RegisterSignal(tether_effect, COMSIG_PARENT_QDELETING, PROC_REF(reset_tether))
	RegisterSignal(target, COMSIG_MOB_DEATH, PROC_REF(reset_tether))
	addtimer(CALLBACK(src, PROC_REF(reset_tether), user), real_chain_duration)
	trapped_mob = target
	ability_primed = FALSE
	ability_charge = max(ability_charge - ability_cost, 0)

/obj/item/weapon/yautja/chain/dropped(mob/user)
	if(trapped_mob || tether_effect)
		release_capture(user)
		reset_tether()
	. = ..()

/obj/item/weapon/yautja/chain/proc/release_capture(mob/user)
	SIGNAL_HANDLER
	if(user)
		to_chat(user, SPAN_WARNING("[src] is no longer wrapped around [trapped_mob]!"))
		//user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] has disarmed \the [src] at [get_location_in_text(user)].</font>")
		//log_attack("[key_name(user)] has disarmed \a [src] at [get_location_in_text(user)].")
	if(trapped_mob)
		//if(isxeno(trapped_mob))
		//	var/mob/living/carbon/xenomorph/xeno = trapped_mob
		//	UnregisterSignal(xeno, COMSIG_XENO_PRE_HEAL)
		UnregisterSignal(trapped_mob, COMSIG_MOB_DEATH)
	trapped_mob = null
	remove_filter(ABILITY_FILTER_NAME)

/obj/item/weapon/yautja/chain/Destroy()
	release_capture()
	reset_tether()
	. = ..()

/obj/item/weapon/yautja/chain/proc/reset_tether()
	SIGNAL_HANDLER
	if(trapped_mob)
		release_capture()
	if(tether_effect)
		UnregisterSignal(tether_effect, COMSIG_PARENT_QDELETING)
		if(!QDESTROYING(tether_effect))
			qdel(tether_effect)
		tether_effect = null

/obj/item/weapon/yautja/sword
	name = "clan sword"
	desc = "An expertly crafted Yautja blade carried by hunters who wish to fight up close. Razor sharp and capable of cutting flesh into ribbons. Commonly carried by aggressive and lethal hunters."
	icon_state = "clansword"
	flags_equip_slot = SLOT_BACK
	force = MELEE_FORCE_TIER_7
	throwforce = MELEE_FORCE_TIER_5
	sharp = IS_SHARP_ITEM_ACCURATE
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 1 SECONDS
	hitsound = "clan_sword_hit"
	ability_cost = ABILITY_COST_SWORD

/obj/item/weapon/yautja/scythe
	name = "dual war scythe"
	desc = "A huge, incredibly sharp dual blade used for hunting dangerous prey. This weapon is commonly carried by Yautja who wish to disable and slice apart their foes."
	icon_state = "predscythe"
	item_state = "scythe_dual"
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_TIER_7
	throwforce = MELEE_FORCE_TIER_5
	sharp = IS_SHARP_ITEM_SIMPLE
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	has_unique_action = TRUE

	ability_cost = ABILITY_COST_SCYTHE
	ability_charge_max = ABILITY_COST_SCYTHE
	ability_charge_rate = ABILITY_CHARGE_NORMAL

/obj/item/weapon/yautja/scythe/attack_self(mob/user)
	..()
	ability_primed = !ability_primed
	var/message = "You tighten your grip on [src], preparing to whirl it in a spin."
	if(!ability_primed)
		message = "You relax your grip on [src]."
	to_chat(user, SPAN_WARNING(message))

/obj/item/weapon/yautja/scythe/unique_action(mob/user)
	. = ..()
	if(!.)
		return
	if(!ability_primed)
		to_chat(user, SPAN_WARNING("You need a stronger grip for this!"))
		return FALSE
	user.spin_circle(2)
	for(var/mob/living/carbon/target in orange(1, user))
		if(!isxeno_human(target) || isyautja(target))
			continue

		if(target.stat == DEAD)
			continue

		if(!check_clear_path_to_target(user, target))
			continue

		user.visible_message(SPAN_HIGHDANGER("[user] slices open the guts of [target]!"), SPAN_HIGHDANGER("You slice open the guts of [target]!"))
		target.spawn_gibs()
		playsound(get_turf(target), 'sound/effects/gibbed.ogg', 30, 1)
		target.Slow(get_xeno_stun_duration(target, 3))
		target.apply_armoured_damage(get_xeno_damage_slash(target, (force * 1.25)), ARMOR_MELEE, BRUTE, "chest", 25)

		user.attack_log += text("\[[time_stamp()]\] <font color='red'>[key_name(user)] sliced [key_name(target)] with their whirling scythe.</font>")
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(target)] was sliced by [key_name(user)] whirling their scythe.</font>")
		log_attack("[key_name(target)] was sliced by [key_name(user)] whirling their scythe.")

	ability_charge -= ability_cost
	if(ability_charge < ability_cost)
		remove_filter(ABILITY_FILTER_NAME)
	return TRUE

/obj/item/weapon/yautja/scythe/alt
	name = "double war scythe"
	desc = "A huge, incredibly sharp double blade used for hunting dangerous prey. This weapon is commonly carried by Yautja who wish to disable and slice apart their foes."
	icon_state = "predscythe_alt"
	item_state = "scythe_double"

//Combistick
/obj/item/weapon/yautja/combistick
	name = "combi-stick"
	desc = "A compact yet deadly personal weapon. Can be concealed when folded. Functions well as a throwing weapon or defensive tool. A common sight in Yautja packs due to its versatility."
	icon_state = "combistick"
	has_unique_action = TRUE
	flags_equip_slot = SLOT_BACK
	flags_item = TWOHANDED|ITEM_PREDATOR
	embeddable = FALSE //It shouldn't embed so that the Yautja can actually use the yank combi verb, and so that it's not useless upon throwing it at someone.
	throw_speed = SPEED_VERY_FAST
	throw_range = 4
	force = MELEE_FORCE_TIER_6
	throwforce = MELEE_FORCE_TIER_7
	sharp = IS_SHARP_ITEM_SIMPLE
	attack_verb = list("speared", "stabbed", "impaled")
	hitsound = 'sound/weapons/bladeslice.ogg'

	ability_cost = ABILITY_COST_COMBI
	ability_charge_max = ABILITY_MAX_DEFAULT
	ability_charge_rate = ABILITY_CHARGE_SMALL

	var/on = TRUE

	var/force_wielded = MELEE_FORCE_TIER_6
	var/force_unwielded = MELEE_FORCE_TIER_2
	var/force_storage = MELEE_FORCE_TIER_1
	/// Ref to the tether effect when thrown
	var/datum/effects/tethering/chain
	///The mob the chain is linked to
	var/mob/living/linked_to

/obj/item/weapon/yautja/combistick/Destroy()
	cleanup_chain()
	return ..()

/obj/item/weapon/yautja/combistick/dropped(mob/user)
	. = ..()
	if(on && isturf(loc))
		setup_chain(user)

/obj/item/weapon/yautja/combistick/try_to_throw(mob/living/user)
	if(ability_charge < ability_cost)
		to_chat(user, SPAN_WARNING("Your combistick refuses to leave your hand. You must charge it with blood from prey before throwing it."))
		return FALSE
	ability_charge -= ability_cost
	if(ability_charge < ability_cost)
		remove_filter(ABILITY_FILTER_NAME)
	unwield(user) //Otherwise stays wielded even when thrown
	return TRUE

/obj/item/weapon/yautja/combistick/proc/setup_chain(mob/living/user)
	give_action(user, /datum/action/predator_action/bracer/combistick)
	add_verb(user, /mob/living/carbon/human/proc/call_combi)
	linked_to = user

	var/list/tether_effects = apply_tether(user, src, range = 6, resistable = FALSE)
	chain = tether_effects["tetherer_tether"]
	RegisterSignal(chain, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_chain))
	RegisterSignal(src, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))

/// The chain normally breaks if it's put into a container, so let's yank it back if that's the case
/obj/item/weapon/yautja/combistick/proc/on_move(datum/source, atom/moved, dir, forced)
	SIGNAL_HANDLER
	if(!z && !is_type_in_list(loc, list(/obj/structure/surface, /mob))) // I rue for the day I can remove the surface snowflake check
		recall()

/// Clean up the chain, deleting/nulling/unregistering as needed
/obj/item/weapon/yautja/combistick/proc/cleanup_chain()
	SIGNAL_HANDLER
	if(linked_to)
		remove_action(linked_to, /datum/action/predator_action/bracer/combistick)
		remove_verb(linked_to, /mob/living/carbon/human/proc/call_combi)

	if(!QDELETED(chain))
		QDEL_NULL(chain)

	else
		chain = null

	UnregisterSignal(src, COMSIG_ITEM_PICKUP)
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)

/obj/item/weapon/yautja/combistick/proc/on_pickup(datum/source, mob/user)
	SIGNAL_HANDLER
	if(user != chain.affected_atom)
		to_chat(chain.affected_atom, SPAN_WARNING("You feel the chain of [src] be torn from your grasp!")) // Recall the fuckin combi my man

	cleanup_chain()

/// recall the combistick to the pred's hands or to be at their feet
/obj/item/weapon/yautja/combistick/proc/recall()
	SIGNAL_HANDLER
	if(!chain)
		return

	var/mob/living/carbon/human/user = chain.affected_atom
	if((src in user.contents) || !istype(user.gloves, /obj/item/clothing/gloves/yautja/hunter))
		cleanup_chain()
		return

	var/obj/item/clothing/gloves/yautja/hunter/pred_gloves = user.gloves

	if(user.put_in_hands(src, TRUE))
		if(!pred_gloves.drain_power(user, 70))
			return TRUE
		user.visible_message(SPAN_WARNING("<b>[user] yanks [src]'s chain back, catching it in [user.p_their()] hand!</b>"), SPAN_WARNING("<b>You yank [src]'s chain back, catching it inhand!</b>"))
		cleanup_chain()

	else
		if(!pred_gloves.drain_power(user, 70))
			return TRUE
		user.visible_message(SPAN_WARNING("<b>[user] yanks [src]'s chain back, letting [src] fall at [user.p_their()]!</b>"), SPAN_WARNING("<b>You yank [src]'s chain back, letting it drop at your feet!</b>"))
		cleanup_chain()

/obj/item/weapon/yautja/combistick/IsShield()
	return on

/obj/item/weapon/yautja/combistick/verb/fold_combistick()
	set category = "Weapons"
	set name = "Collapse Combi-stick"
	set desc = "Collapse or extend the combistick."
	set src = usr.contents

	unique_action(usr)

/obj/item/weapon/yautja/combistick/attack_self(mob/user)
	..()
	if(on)
		if(flags_item & WIELDED)
			unwield(user)
		else
			wield(user)
	else
		to_chat(user, SPAN_WARNING("You need to extend the combi-stick before you can wield it."))


/obj/item/weapon/yautja/combistick/wield(mob/user)
	. = ..()
	if(!.)
		return
	force = force_wielded
	update_icon()

/obj/item/weapon/yautja/combistick/unwield(mob/user)
	. = ..()
	if(!.)
		return
	force = force_unwielded
	update_icon()

/obj/item/weapon/yautja/combistick/update_icon()
	if(flags_item & WIELDED)
		item_state = "combistick_w"
	else if(!on)
		item_state = "combistick_f"
	else
		item_state = "combistick"

/obj/item/weapon/yautja/combistick/unique_action(mob/living/user)
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

/obj/item/weapon/yautja/combistick/attack_hand(mob/user) //Prevents marines from instantly picking it up via pickup macros.
	if(!human_adapted && !HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		user.visible_message(SPAN_DANGER("[user] starts to untangle the chain on \the [src]..."), SPAN_NOTICE("You start to untangle the chain on \the [src]..."))
		if(do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			..()
	else ..()

/obj/item/weapon/yautja/combistick/launch_impact(atom/hit_atom)
	if(isyautja(hit_atom))
		var/mob/living/carbon/human/human = hit_atom
		if(human.put_in_hands(src))
			hit_atom.visible_message(SPAN_NOTICE(" [hit_atom] expertly catches [src] out of the air. "), \
				SPAN_NOTICE(" You easily catch [src]. "))
			return
	..()

/obj/item/weapon/yautja/knife
	name = "ceremonial dagger"
	desc = "A viciously sharp dagger inscribed with ancient Yautja markings. Smells thickly of blood. Carried by some hunters."
	icon_state = "predknife"
	item_state = "knife"
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
	actions_types = list(/datum/action/item_action/toggle/use)
	unacidable = TRUE

/obj/item/weapon/yautja/knife/attack(mob/living/target, mob/living/carbon/human/user)
	if(target.stat != DEAD)
		return ..()

	if(!ishuman(target))
		to_chat(user, SPAN_WARNING("You can only use this dagger to flay humanoids!"))
		return

	var/mob/living/carbon/human/victim = target

	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		to_chat(user, SPAN_WARNING("You're not strong enough to rip an entire humanoid apart. Also, that's kind of fucked up.")) //look at this dumbass
		return TRUE

	if(issamespecies(user, victim))
		to_chat(user, SPAN_HIGHDANGER("ARE YOU OUT OF YOUR MIND!?"))
		return

	if(isspeciessynth(victim))
		to_chat(user, SPAN_WARNING("You can't flay metal...")) //look at this dumbass
		return TRUE

	if(SEND_SIGNAL(victim, COMSIG_HUMAN_FLAY_ATTEMPT, user, src) & COMPONENT_CANCEL_ATTACK)
		return TRUE

	if(victim.overlays_standing[FLAY_LAYER]) //Already fully flayed. Possibly the user wants to cut them down?
		return ..()

	if(!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
		return TRUE

	user.visible_message(SPAN_DANGER("<B>[user] begins to flay [victim] with \a [src]...</B>"),
		SPAN_DANGER("<B>You start flaying [victim] with your [src.name]...</B>"))
	playsound(loc, 'sound/weapons/pierce.ogg', 25)
	if(do_after(user, 4 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
		if(SEND_SIGNAL(victim, COMSIG_HUMAN_FLAY_ATTEMPT, user, src) & COMPONENT_CANCEL_ATTACK) //In case two preds try to flay the same person at once.
			return TRUE
		user.visible_message(SPAN_DANGER("<B>[user] makes a series of cuts in [victim]'s skin.</B>"),
			SPAN_DANGER("<B>You prepare the skin, cutting the flesh off in vital places.</B>"))
		playsound(loc, 'sound/weapons/slash.ogg', 25)

		for(var/limb in victim.limbs)
			victim.apply_damage(15, BRUTE, limb, sharp = FALSE)
		victim.add_flay_overlay(stage = 1)

		var/datum/flaying_datum/flay_datum = new(victim)
		flay_datum.create_leftovers(victim, TRUE, 0)
		SEND_SIGNAL(victim, COMSIG_HUMAN_FLAY_ATTEMPT, user, src, TRUE)
	else
		to_chat(user, SPAN_WARNING("You were interrupted before you could finish your work!"))
	return TRUE

///Records status of flaying attempts and handles progress.
/datum/flaying_datum
	var/mob/living/carbon/human/victim
	var/current_flayer
	var/flaying_stage = FLAY_STAGE_SCALP

/datum/flaying_datum/New(mob/living/carbon/human/target)
	. = ..()
	victim = target
	RegisterSignal(victim, COMSIG_HUMAN_FLAY_ATTEMPT, PROC_REF(begin_flaying))

///Loops until interrupted or done.
/datum/flaying_datum/proc/begin_flaying(mob/living/carbon/human/target, mob/living/carbon/human/user, obj/item/tool, ongoing_attempt)
	SIGNAL_HANDLER
	if(current_flayer)
		if(current_flayer != user)
			to_chat(user, SPAN_WARNING("You can't flay [target], [current_flayer] is already at work!"))
	else
		current_flayer = user
		if(!ongoing_attempt)
			playsound(user.loc, 'sound/weapons/pierce.ogg', 25)
			user.visible_message(SPAN_DANGER("<B>[user] resumes the flaying of [victim] with \a [tool]...</B>"),
				SPAN_DANGER("<B>You resume the flaying of [victim] with your [tool.name]...</B>"))
		INVOKE_ASYNC(src, PROC_REF(flay), target, user, tool) //do_after sleeps.
	return COMPONENT_CANCEL_ATTACK

/datum/flaying_datum/proc/flay(mob/living/carbon/human/target, mob/living/carbon/human/user, obj/item/tool)
	if(!do_after(user, 4 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, victim))
		to_chat(user, SPAN_WARNING("You were interrupted before you could finish your work!"))
		current_flayer = null
		return

	switch(flaying_stage)
		if(FLAY_STAGE_SCALP)
			playsound(user.loc, 'sound/weapons/slashmiss.ogg', 25)
			flaying_stage = FLAY_STAGE_STRIP
			var/obj/limb/head/v_head = victim.get_limb("head")
			if(!v_head || (v_head.status & LIMB_DESTROYED)) //they might be beheaded
				victim.apply_damage(10, BRUTE, "chest", sharp = TRUE)
				user.visible_message(SPAN_DANGER("<B>[user] peels the skin around the stump of [victim]'s head loose with \the [tool].</B>"),
					SPAN_DANGER("<B>[victim] is missing \his head. Pelts like this just aren't the same... You peel the skin around the stump loose with your [tool.name].</B>"))
			else
				victim.apply_damage(10, BRUTE, v_head, sharp = TRUE)
				create_leftovers(victim, has_meat = FALSE, skin_amount = 1)
				if(victim.h_style == "Bald") //you can't scalp someone with no hair.
					user.visible_message(SPAN_DANGER("<B>[user] makes some rough cuts on [victim]'s head and face with \a [tool].</B>"),
						SPAN_DANGER("<B>You make some rough cuts on [victim]'s head and face.</B>"))
				else
					user.visible_message(SPAN_DANGER("<B>[user] cuts around [victim]'s hairline, then tears \his scalp from \his head!</B>"),
						SPAN_DANGER("<B>You cut around [victim]'s hairline, then rip \his scalp from \his head.</B>"))
					var/obj/item/scalp/cut_scalp = new(get_turf(user), victim, user) //Create a scalp of the victim at the user's feet.
					user.put_in_inactive_hand(cut_scalp) //Put it in the user's offhand if possible.
					victim.h_style = "Bald"
					victim.update_hair() //tear the hair off with the scalp

		if(FLAY_STAGE_STRIP)
			user.visible_message(SPAN_DANGER("<B>[user] jabs \his [tool.name] into [victim]'s cuts, prying, cutting, then tearing off large areas of skin. The remainder hangs loosely.</B>"),
				SPAN_DANGER("<B>You jab your [tool.name] into [victim]'s cuts, prying, cutting, then tearing off large areas of skin. The remainder hangs loosely.</B>"))
			playsound(user.loc, 'sound/weapons/bladeslice.ogg', 25)
			create_leftovers(victim, has_meat = FALSE, skin_amount = 3)
			flaying_stage = FLAY_STAGE_SKIN
			for(var/limb in victim.limbs)
				victim.apply_damage(18, BRUTE, limb, sharp = TRUE)
			victim.remove_overlay(UNDERWEAR_LAYER)
			victim.drop_inv_item_on_ground(victim.get_item_by_slot(WEAR_BODY)) //Drop uniform, belt etc as well.
			victim.f_style = "Shaved"
			victim.update_hair() //then rip the beard off along the skin
			victim.add_flay_overlay(stage = 2)

		if(FLAY_STAGE_SKIN)
			user.visible_message(SPAN_DANGER("<B>[user] completely flays [victim], pulling the remaining skin off of \his body like a glove!</B>"),
				SPAN_DANGER("<B>You completely flay [victim], pulling the remaining skin off of \his body like a glove.\nUse rope to hang \him from the ceiling.</B>"))
			playsound(user.loc, 'sound/weapons/wristblades_hit.ogg', 25)
			create_leftovers(victim, has_meat = TRUE, skin_amount = 2)
			for(var/limb in victim.limbs)
				victim.apply_damage(22, BRUTE, limb, sharp = TRUE)
			for(var/obj/item/item in victim)
				victim.drop_inv_item_to_loc(item, victim.loc, FALSE, TRUE)
				victim.status_flags |= PERMANENTLY_DEAD
			victim.add_flay_overlay(stage = 3)

			//End the loop and remove all references to the datum.
			current_flayer = null
			UnregisterSignal(victim, COMSIG_HUMAN_FLAY_ATTEMPT)
			victim = null
			return

	flay(target, user, tool)

/mob/living/carbon/human/proc/add_flay_overlay(stage = 1)
	remove_overlay(FLAY_LAYER)
	var/image/flay_icon = new /image('icons/mob/humans/dam_human.dmi', "human_[stage]")
	flay_icon.layer = -FLAY_LAYER
	flay_icon.blend_mode = BLEND_INSET_OVERLAY
	overlays_standing[FLAY_LAYER] = flay_icon
	apply_overlay(FLAY_LAYER)

/datum/flaying_datum/proc/create_leftovers(mob/living/victim, has_meat, skin_amount)
	if(has_meat)
		var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
		meat.name = "raw [victim.name] steak"

	if(skin_amount)
		var/obj/item/stack/sheet/animalhide/human/hide = new /obj/item/stack/sheet/animalhide/human(victim.loc)
		hide.name = "[victim.name]-hide"
		hide.singular_name = "[victim.name]-hide"
		hide.stack_id = "[victim.name]-hide"
		hide.amount = skin_amount

/obj/item/weapon/yautja/knife/afterattack(obj/attacked_obj, mob/living/user, proximity)
	if(!proximity)
		return

	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		return

	if(!istype(attacked_obj, /obj/item/limb))
		return
	var/obj/item/limb/current_limb = attacked_obj

	if(current_limb.flayed)
		to_chat(user, SPAN_NOTICE("This limb has already been flayed."))
		return

	playsound(loc, 'sound/weapons/pierce.ogg', 25)
	to_chat(user, SPAN_WARNING("You start flaying the skin from [current_limb]."))
	if(!do_after(user, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, current_limb))
		to_chat(user, SPAN_NOTICE("You decide not to flay [current_limb]."))
		return
	to_chat(user, SPAN_WARNING("You finish flaying [current_limb]."))
	current_limb.flayed = TRUE

/*#########################################
########### Two Handed Weapons ############
#########################################*/
/obj/item/weapon/twohanded/yautja
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)

	flags_item = NOSHIELD|TWOHANDED|ITEM_PREDATOR
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	unacidable = TRUE
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	throw_speed = SPEED_VERY_FAST
	edge = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/human_adapted = FALSE
	///The amount this weapon interrupts hivemind link on Xenomorphs.
	var/xeno_interfere_amount = 30

	///The amount of charges towards use of special abilities.
	var/ability_charge = 0
	var/ability_charge_max = ABILITY_MAX_DEFAULT
	var/ability_charge_rate = ABILITY_CHARGE_NORMAL
	var/ability_cost = ABILITY_COST_NO_ABILITY
	///Whether the ability is ready to trigger
	var/ability_primed = FALSE

/obj/item/weapon/twohanded/yautja/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if((human_adapted || isspeciesyautja(user)) && isxeno(target))
		var/mob/living/carbon/xenomorph/xenomorph = target
		xenomorph.AddComponent(/datum/component/status_effect/interference, xeno_interfere_amount, xeno_interfere_amount)

	if(!ability_cost || !(HAS_TRAIT(user, TRAIT_YAUTJA_TECH)))
		return

	progress_ability(target, user)

/obj/item/weapon/twohanded/yautja/proc/progress_ability(mob/living/target, mob/living/carbon/human/user)
	if(target == user || target.stat == DEAD || isanimal(target))
		to_chat(user, SPAN_DANGER("You think you're smart?")) //very funny
		return FALSE

	if(ability_charge < ability_charge_max)
		ability_charge = min(ability_charge_max, ability_charge + ability_charge_rate)
		to_chat(user, SPAN_DANGER("[src]'s reservoir fills up with your opponent's blood!"))

	if(ability_charge >= ability_cost)
		ready_ability(target, user)
	return TRUE

/obj/item/weapon/twohanded/yautja/unique_action(mob/user)
	if(user.get_active_hand() != src)
		return FALSE
	if(ability_charge < ability_cost)
		to_chat(user, SPAN_WARNING("The blood reservoir is not full enough to do this!"))
		return FALSE
	return TRUE

/obj/item/weapon/twohanded/yautja/get_examine_text(mob/user)
	. = ..()
	if(isyautja(user) && ability_cost)
		. += SPAN_WARNING("It currently has <b>[ability_charge]/[ability_charge_max]</b> blood charge(s).")
		. += SPAN_ORANGE("It requires <b>[ability_cost]</b> blood charge(s) to use its ability.")

/obj/item/weapon/twohanded/yautja/proc/ready_ability(mob/living/target as mob, mob/living/carbon/human/user as mob)
	if(ability_charge >= ability_cost)
		var/color = target.get_blood_color()
		var/alpha = 70
		color += num2text(alpha, 2, 16)
		add_filter(ABILITY_FILTER_NAME, 1, list("type" = "outline", "color" = color, "size" = 2))
		return TRUE
	return FALSE

/obj/item/weapon/twohanded/yautja/spear
	name = "hunter spear"
	desc = "A spear of exquisite design, used by an ancient civilisation."
	icon_state = "spearhunter"
	item_state = "spearhunter"
	flags_item = NOSHIELD|TWOHANDED
	force = MELEE_FORCE_TIER_4
	force_wielded = MELEE_FORCE_TIER_7
	sharp = IS_SHARP_ITEM_SIMPLE
	attack_verb = list("attacked", "stabbed", "jabbed", "torn", "gored")

	var/busy_fishing = FALSE
	var/common_weight = 60
	var/uncommon_weight = 15
	var/rare_weight = 5
	var/ultra_rare_weight = 1

/obj/item/weapon/twohanded/yautja/spear/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(proximity_flag && !busy_fishing && isturf(target))
		var/turf/T = target
		if(!T.supports_fishing)
			return
		busy_fishing = TRUE
		user.visible_message(SPAN_NOTICE("[user] starts aiming \the [src] at the water..."), SPAN_NOTICE("You prepare to catch something in the water..."), max_distance = 3)
		if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			if(prob(60)) // fishing rods are prefered
				busy_fishing = FALSE
				to_chat(user, SPAN_WARNING("You fail to catch anything!"))
				return
			user.animation_attack_on(T)
			var/obj/item/caught_item = get_fishing_loot(T, get_area(T), common_weight, uncommon_weight, rare_weight, ultra_rare_weight)
			if(user.put_in_inactive_hand(caught_item))
				user.visible_message(SPAN_NOTICE("[user] quickly stabs \the [T] and pulls out \a <b>[caught_item]</b> with their free hand!"), SPAN_NOTICE("You quickly stab \the [T] and pull out \a <b>[caught_item]</b> with your free hand!"), max_distance = 3)
				var/image/trick = image(caught_item.icon, user, caught_item.icon_state, BIG_XENO_LAYER)
				switch(pick(1,2))
					if(1) animation_toss_snatch(trick)
					if(2) animation_toss_flick(trick, pick(1,-1))
				caught_item.invisibility = 100
				var/list/client/displayed_for = list()
				for(var/mob/M in viewers(user))
					var/client/C = M.client
					if(C)
						C.images += trick
						displayed_for += C
				sleep(6) // BOO
				for(var/client/C in displayed_for)
					C.images -= trick
				trick = null
				caught_item.invisibility = 0
			else
				user.visible_message(SPAN_NOTICE("[user] quickly stabs \the [T] and \a <b>[caught_item]</b> drifts to the surface!"), SPAN_NOTICE("You quickly stab \the [T] and \a <b>[caught_item]</b> drifts to the surface!"), max_distance = 3)
				caught_item.sway_jitter(3, 6)
		busy_fishing = FALSE

/obj/item/weapon/twohanded/yautja/glaive
	name = "war glaive"
	desc = "A huge, powerful blade on a metallic pole. Mysterious writing is carved into the weapon."
	icon_state = "glaive"
	item_state = "glaive"
	force = MELEE_FORCE_TIER_3
	force_wielded = MELEE_FORCE_TIER_10
	throwforce = MELEE_FORCE_TIER_3
	sharp = IS_SHARP_ITEM_BIG
	attack_verb = list("sliced", "slashed", "carved", "diced", "gored")
	attack_speed = 14 //Default is 7.
	ability_cost = ABILITY_COST_GLAIVE

/obj/item/weapon/twohanded/yautja/glaive/alt
	icon_state = "glaive_alt"
	item_state = "glaive_alt"

/obj/item/weapon/twohanded/yautja/glaive/damaged
	name = "ancient war glaive"
	desc = "A huge, powerful blade on a metallic pole. Mysterious writing is carved into the weapon. This one is ancient and has suffered serious acid damage, making it near-useless."
	force = MELEE_FORCE_WEAK
	force_wielded = MELEE_FORCE_NORMAL
	throwforce = MELEE_FORCE_WEAK
	icon_state = "glaive_alt"
	item_state = "glaive_alt"
	flags_item = NOSHIELD|TWOHANDED


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
	flags_item = ITEM_PREDATOR|TWOHANDED
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	has_unique_action = FALSE

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
	verbs -= /obj/item/weapon/gun/verb/use_toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag

/obj/item/weapon/gun/launcher/spike/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/launcher/spike/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 25, GLOB.damage_boost_turfs),
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 25, GLOB.damage_boost_breaching)
	))

/obj/item/weapon/gun/launcher/spike/get_examine_text(mob/user)
	if(isyautja(user))
		. = ..()
		. += SPAN_NOTICE("It currently has <b>[spikes]/[max_spikes]</b> spikes.")
	else
		. = list()
		. += SPAN_NOTICE("Looks like some kind of...mechanical donut.")

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
		apply_traits(in_chamber)
		spikes--
		return in_chamber

/obj/item/weapon/gun/launcher/spike/has_ammunition()
	if(spikes > 0)
		return TRUE //Enough spikes for a shot.

/obj/item/weapon/gun/launcher/spike/reload_into_chamber()
	update_icon()
	return TRUE

/obj/item/weapon/gun/launcher/spike/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) spikes++
	return TRUE


/obj/item/weapon/gun/energy/yautja
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = null
	works_in_recharger = FALSE
	muzzle_flash = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_MAGENTA
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT

/obj/item/weapon/gun/energy/yautja/plasmarifle
	name = "plasma rifle"
	desc = "A long-barreled heavy plasma weapon. Intended for combat, not hunting. Has an integrated battery that allows for a functionally unlimited amount of shots to be discharged. Equipped with an internal gyroscopic stabilizer allowing its operator to fire the weapon one-handed if desired"
	icon_state = "plasmarifle"
	item_state = "plasmarifle"
	unacidable = TRUE
	fire_sound = 'sound/weapons/pred_plasma_shot.ogg'
	ammo = /datum/ammo/energy/yautja/rifle/bolt
	zoomdevicename = "scope"
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_HUGE
	var/charge_time = 0
	var/last_regen = 0
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR|TWOHANDED
	has_unique_action = FALSE

/obj/item/weapon/gun/energy/yautja/plasmarifle/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time
	update_icon()

	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/use_toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag

/obj/item/weapon/gun/energy/yautja/plasmarifle/process()
	if(charge_time < 100)
		charge_time++
		if(charge_time == 99)
			if(ismob(loc)) to_chat(loc, SPAN_NOTICE("[src] hums as it achieves maximum charge."))
		update_icon()


/obj/item/weapon/gun/energy/yautja/plasmarifle/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_4*2)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


/obj/item/weapon/gun/energy/yautja/plasmarifle/get_examine_text(mob/user)
	if(isyautja(user))
		. = ..()
		. += SPAN_NOTICE("It currently has <b>[charge_time]/100</b> charge.")
	else
		. = list()
		. += SPAN_NOTICE("This thing looks like an alien rifle of some kind. Strange.")

/obj/item/weapon/gun/energy/yautja/plasmarifle/update_icon()
	if(last_regen < charge_time + 20 || last_regen > charge_time || charge_time > 95)
		var/new_icon_state = charge_time <=15 ? null : icon_state + "[round(charge_time/33, 1)]"
		update_special_overlay(new_icon_state)
		last_regen = charge_time

/obj/item/weapon/gun/energy/yautja/plasmarifle/able_to_fire(mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return
	if(charge_time < 7)
		to_chat(user, SPAN_WARNING("The rifle does not have enough power remaining!"))
		return

	return ..()

/obj/item/weapon/gun/energy/yautja/plasmarifle/load_into_chamber()
	ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/rifle/bolt]
	charge_time -= 7
	var/obj/projectile/projectile = create_bullet(ammo, initial(name))
	projectile.set_light(1)
	in_chamber = projectile
	return in_chamber

/obj/item/weapon/gun/energy/yautja/plasmarifle/has_ammunition()
	return TRUE //Plasma rifle appears to have infinite ammunition.

/obj/item/weapon/gun/energy/yautja/plasmarifle/reload_into_chamber()
	update_icon()
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasmarifle/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund)
		charge_time += 7
	return TRUE

#define FIRE_MODE_STANDARD "Standard"
#define FIRE_MODE_INCENDIARY "Incendiary"

/obj/item/weapon/gun/energy/yautja/plasmapistol
	name = "plasma pistol"
	desc = "A plasma pistol capable of rapid fire. It has an integrated battery. Can be used to set fires, either to braziers or on people."
	icon_state = "plasmapistol"
	item_state = "plasmapistol"

	unacidable = TRUE
	fire_sound = 'sound/weapons/pulse3.ogg'
	flags_equip_slot = SLOT_WAIST
	ammo = /datum/ammo/energy/yautja/pistol
	muzzle_flash = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_MUZZLE_BLUE
	w_class = SIZE_MEDIUM
	/// Max amount of shots
	var/charge_time = 40
	/// Amount of charge_time drained per shot
	var/shot_cost = 1
	/// standard (sc = 1) or incendiary (sc = 5)
	var/mode = FIRE_MODE_STANDARD
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR|IGNITING_ITEM|TWOHANDED

	heat_source = 1500 // Plasma Pistols fire burning hot bounbs of plasma. Makes sense they're hot

/obj/item/weapon/gun/energy/yautja/plasmapistol/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/use_toggle_burst
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
	set_fire_delay(FIRE_DELAY_TIER_7)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/energy/yautja/plasmapistol/get_examine_text(mob/user)
	if(isyautja(user))
		. = ..()
		. += SPAN_NOTICE("It currently has <b>[charge_time]/40</b> charge.")

		if(mode == FIRE_MODE_INCENDIARY)
			. += SPAN_RED("It is set to fire incendiary plasma bolts.")
		else
			. += SPAN_ORANGE("It is set to fire plasma bolts.")
	else
		. = list()
		. += SPAN_NOTICE("This thing looks like an alien gun of some kind. Strange.")


/obj/item/weapon/gun/energy/yautja/plasmapistol/able_to_fire(mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return
	else
		return ..()

/obj/item/weapon/gun/energy/yautja/plasmapistol/load_into_chamber()
	if(charge_time < 1)
		return
	var/obj/projectile/projectile = create_bullet(ammo, initial(name))
	projectile.set_light(1)
	in_chamber = projectile
	charge_time -= shot_cost
	return in_chamber

/obj/item/weapon/gun/energy/yautja/plasmapistol/has_ammunition()
	if(charge_time >= 1)
		return TRUE //Enough charge for a shot.

/obj/item/weapon/gun/energy/yautja/plasmapistol/reload_into_chamber()
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasmapistol/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund)
		charge_time += shot_cost
		log_debug("Plasma Pistol refunded shot.")
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasmapistol/unique_action()
	switch(mode)
		if(FIRE_MODE_STANDARD)
			mode = FIRE_MODE_INCENDIARY
			shot_cost = 5
			fire_delay = FIRE_DELAY_TIER_5
			to_chat(usr, SPAN_NOTICE("[src] will now fire incendiary plasma bolts."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/pistol/incendiary]

		if(FIRE_MODE_INCENDIARY)
			mode = FIRE_MODE_STANDARD
			shot_cost = 1
			fire_delay = FIRE_DELAY_TIER_7
			to_chat(usr, SPAN_NOTICE("[src] will now fire plasma bolts."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/pistol]

#undef FIRE_MODE_STANDARD
#undef FIRE_MODE_INCENDIARY

/obj/item/weapon/gun/energy/yautja/plasma_caster
	name = "plasma caster"
	desc = "A powerful, shoulder-mounted energy weapon."
	icon_state = "plasma_ebony"
	var/base_icon_state = "plasma"
	var/base_item_state = "plasma_wear"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)
	item_state_slots = list(
		WEAR_BACK = "plasma_wear_off",
		WEAR_J_STORE = "plasma_wear_off"
	)
	fire_sound = 'sound/weapons/pred_plasmacaster_fire.ogg'
	ammo = /datum/ammo/energy/yautja/caster/stun
	muzzle_flash = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_MUZZLE_BLUE
	w_class = SIZE_HUGE
	force = 0
	fire_delay = 3
	flags_item = NOBLUDGEON|DELONDROP|IGNITING_ITEM //Can't bludgeon with this.
	flags_gun_features = GUN_UNUSUAL_DESIGN
	has_empty_icon = FALSE
	explo_proof = TRUE

	heat_source = 1500 // Plasma Casters fire burning hot bounbs of plasma. Makes sense they're hot

	var/obj/item/clothing/gloves/yautja/hunter/source = null
	charge_cost = 100 //How much energy is needed to fire.
	var/mode = "stun"//fire mode (stun/lethal)
	var/strength = "low power stun bolts"//what it's shooting

/obj/item/weapon/gun/energy/yautja/plasma_caster/Initialize(mapload, spawn_empty, caster_material = "ebony")
	icon_state = "[base_icon_state]_[caster_material]"
	item_state = "[base_item_state]_[caster_material]"
	item_state_slots[WEAR_BACK] = "[base_item_state]_off_[caster_material]"
	item_state_slots[WEAR_J_STORE] = "[base_item_state]_off_[caster_material]"
	. = ..()
	source = loc
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/use_toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag

/obj/item/weapon/gun/energy/yautja/plasma_caster/Destroy()
	. = ..()
	source = null


/obj/item/weapon/gun/energy/yautja/plasma_caster/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6)
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
					charge_cost = 50
					set_fire_delay(FIRE_DELAY_TIER_1)
					fire_sound = 'sound/weapons/pred_lasercannon.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/bolt/stun]
				if("high power stun bolts")
					strength = "plasma immobilizers"
					charge_cost = 200
					set_fire_delay(FIRE_DELAY_TIER_2 * 8)
					fire_sound = 'sound/weapons/pulse.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/sphere/stun]
				if("plasma immobilizers")
					strength = "low power stun bolts"
					charge_cost = 30
					set_fire_delay(FIRE_DELAY_TIER_6)
					fire_sound = 'sound/weapons/pred_plasmacaster_fire.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/stun]
		if("lethal")
			switch(strength)
				if("plasma bolts")
					strength = "plasma spheres"
					charge_cost = 1000
					set_fire_delay(FIRE_DELAY_TIER_2 * 12)
					fire_sound = 'sound/weapons/pulse.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/sphere]
				if("plasma spheres")
					strength = "plasma bolts"
					charge_cost = 100
					set_fire_delay(FIRE_DELAY_TIER_6 * 3)
					fire_sound = 'sound/weapons/pred_lasercannon.ogg'
					to_chat(user, SPAN_NOTICE("[src] will now fire [strength]."))
					ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/bolt]

/obj/item/weapon/gun/energy/yautja/plasma_caster/unique_action()
	switch(mode)
		if("stun")
			mode = "lethal"
			to_chat(usr, SPAN_YAUTJABOLD("[src.source] beeps: [src] is now set to [mode] mode"))
			strength = "plasma bolts"
			charge_cost = 100
			set_fire_delay(FIRE_DELAY_TIER_6 * 3)
			fire_sound = 'sound/weapons/pred_lasercannon.ogg'
			to_chat(usr, SPAN_NOTICE("[src] will now fire [strength]."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/bolt]

		if("lethal")
			mode = "stun"
			to_chat(usr, SPAN_YAUTJABOLD("[src.source] beeps: [src] is now set to [mode] mode"))
			strength = "low power stun bolts"
			charge_cost = 30
			set_fire_delay(FIRE_DELAY_TIER_6)
			fire_sound = 'sound/weapons/pred_plasmacaster_fire.ogg'
			to_chat(usr, SPAN_NOTICE("[src] will now fire [strength]."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/stun]

/obj/item/weapon/gun/energy/yautja/plasma_caster/get_examine_text(mob/user)
	. = ..()
	var/msg = "It is set to fire [strength]."
	if(mode == "lethal")
		. += SPAN_RED(msg)
	else
		. += SPAN_ORANGE(msg)

/obj/item/weapon/gun/energy/yautja/plasma_caster/dropped(mob/living/carbon/human/M)
	playsound(M, 'sound/weapons/pred_plasmacaster_off.ogg', 15, 1)
	to_chat(M, SPAN_NOTICE("You deactivate your plasma caster."))

	var/datum/action/predator_action/bracer/caster/caster_action
	for(caster_action as anything in M.actions)
		if(istypestrict(caster_action, /datum/action/predator_action/bracer/caster))
			caster_action.update_button_icon(FALSE)
			break

	if(source)
		forceMove(source)
		source.caster_deployed = FALSE
		return
	..()

/obj/item/weapon/gun/energy/yautja/plasma_caster/able_to_fire(mob/user)
	if(!source)
		return
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return
	return ..()

/obj/item/weapon/gun/energy/yautja/plasma_caster/load_into_chamber(mob/user)
	if(source.drain_power(user, charge_cost))
		in_chamber = create_bullet(ammo, initial(name))
		return in_chamber

/obj/item/weapon/gun/energy/yautja/plasma_caster/has_ammunition()
	if(source?.charge >= charge_cost)
		return TRUE //Enough charge for a shot.

/obj/item/weapon/gun/energy/yautja/plasma_caster/reload_into_chamber()
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasma_caster/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund)
		source.charge += charge_cost
		var/perc = source.charge / source.charge_max * 100
		var/mob/living/carbon/human/user = usr //Hacky...
		user.update_power_display(perc)
	return TRUE

#undef FLAY_STAGE_SCALP
#undef FLAY_STAGE_STRIP
#undef FLAY_STAGE_SKIN
