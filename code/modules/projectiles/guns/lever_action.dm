/*
LEVER-ACTION RIFLES
mostly a copypaste of shotgun code but not *entirely*
their unique feature is that a direct hit will buff your damage and firerate
*/

#define USES_STREAKS					(1<<0)
#define DANGEROUS_TO_ONEHAND_LEVER		(1<<1)
#define MOVES_WHEN_LEVERING				(1<<2)

/obj/item/weapon/gun/lever_action
	name = "lever-action rifle"
	desc = "Welcome to the Wild West!\nThis gun is levered via Unique-Action, but it has a bonus feature: Hitting a target directly will grant you a fire rate and damage buff for your next shot during a short interval. Combo precision hits for massive damage."
	icon_state = "r4t-placeholder" //placeholder for a 'base' leveraction
	item_state = "r4t-placeholder"
	w_class = SIZE_LARGE
	fire_sound = 'sound/weapons/gun_lever_action_fire.ogg'
	reload_sound = 'sound/weapons/handling/gun_lever_action_reload.ogg'
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG
	current_mag = /obj/item/ammo_magazine/internal/lever_action
	gun_category = GUN_CATEGORY_RIFLE
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_FAST
	has_empty_icon = FALSE
	has_open_icon = FALSE
	var/flags_gun_lever_action = MOVES_WHEN_LEVERING|USES_STREAKS|DANGEROUS_TO_ONEHAND_LEVER
	var/default_caliber = "45-70"
	var/lever_sound = 'sound/weapons/handling/gun_lever_action_lever.ogg'
	var/lever_super_sound = 'sound/weapons/handling/gun_lever_action_superload.ogg'
	var/lever_hitsound = 'sound/weapons/handling/gun_lever_action_hitsound.ogg'
	var/levering_sprite = "r4t_l" //does it use a unique sprite when levering?
	var/lever_delay
	var/recent_lever
	var/levered = FALSE
	var/message_cooldown
	var/cur_onehand_chance = 85
	var/reset_onehand_chance = 85
	var/hit_buff_reset_cooldown = 1 SECONDS //how much time after a direct hit until streaks reset
	var/lever_message = "<i>You work the lever.<i>"
	var/lever_name = "lever" //the thing we use to chamber the next round. Lever, button, etc. for to_chats
	var/buff_fire_reduc = 2
	var/streak

/obj/item/weapon/gun/lever_action/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag)
		replace_internal_mag(current_mag.current_rounds)

/obj/item/weapon/gun/lever_action/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_1 + FIRE_DELAY_TIER_10
	lever_delay = FIRE_DELAY_TIER_3
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = 0
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3
	recoil_unwielded = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/lever_action/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19, "rail_x" = 11, "rail_y" = 21, "under_x" = 24, "under_y" = 16, "stock_x" = 15, "stock_y" = 11)

/obj/item/weapon/gun/lever_action/wield(var/mob/M)
	. = ..()
	if(. && (flags_gun_lever_action & USES_STREAKS))
		RegisterSignal(M, COMSIG_DIRECT_BULLET_HIT, .proc/direct_hit_buff)

/obj/item/weapon/gun/lever_action/unwield(var/mob/M)
	. = ..()
	if(. && (flags_gun_lever_action & USES_STREAKS))
		UnregisterSignal(M, COMSIG_DIRECT_BULLET_HIT)

/obj/item/weapon/gun/lever_action/dropped(mob/user)
	. = ..()
	reset_hit_buff()
	addtimer(VARSET_CALLBACK(src, cur_onehand_chance, reset_onehand_chance), 4 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)

/obj/item/weapon/gun/lever_action/proc/direct_hit_buff(mob/user, mob/target, var/one_hand_lever = FALSE)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/human_user = user
	if(one_hand_lever && !(flags_gun_lever_action & DANGEROUS_TO_ONEHAND_LEVER))
		return
	else if(one_hand_lever) //base marines should never be able to easily pass the skillcheck, only specialists and etc.
		if(prob(cur_onehand_chance) || skillcheck(human_user, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
			cur_onehand_chance = cur_onehand_chance - 20 //gets steadily worse if you spam it
			return
		else
			to_chat(user, SPAN_DANGER("Augh! Your hand catches on the [lever_name]!!"))
			var/obj/limb/O = human_user.get_limb(human_user.hand ? "l_hand" : "r_hand")
			if(O.status & LIMB_BROKEN)
				O = human_user.get_limb(user.hand ? "l_arm" : "r_arm")
				human_user.drop_held_item()
			O.fracture()
			O.status &= ~LIMB_SPLINTED
			human_user.pain.recalculate_pain()
			return

	if(!istype(target))
		return //sanity...

	else if(target.stat == DEAD || !(flags_gun_lever_action & USES_STREAKS))
		return

	else
		if(streak)
			to_chat(user, SPAN_BOLDNOTICE("Bullseye! [streak + 1] hits in a row!"))
		else
			to_chat(user, SPAN_BOLDNOTICE("Bullseye!"))
		streak++
		playsound(user, lever_hitsound, 25, FALSE)
	if(!(flags_gun_lever_action & USES_STREAKS))
		return
	apply_hit_buff(user, target, one_hand_lever) //this is a separate proc so it's configgable
	addtimer(CALLBACK(src, .proc/reset_hit_buff, one_hand_lever), hit_buff_reset_cooldown, TIMER_OVERRIDE|TIMER_UNIQUE)

/obj/item/weapon/gun/lever_action/proc/apply_hit_buff(mob/user, mob/target, var/one_hand_lever = FALSE)
	lever_sound = lever_super_sound
	lever_message = "<b><i>You quickly work the [lever_name]!<i><b>"
	last_fired = world.time - buff_fire_reduc //to shoot the next round faster
	lever_delay = FIRE_DELAY_TIER_10
	damage_mult = initial(damage_mult) + BULLET_DAMAGE_MULT_TIER_10
	fire_delay = FIRE_DELAY_TIER_5
	for(var/slot in attachments)
		var/obj/item/attachable/AM = attachments[slot]
		if(AM.damage_mod || AM.delay_mod)
			damage_mult += AM.damage_mod
			fire_delay += AM.delay_mod
	wield_delay = 0 //for one-handed levering

/obj/item/weapon/gun/lever_action/proc/reset_hit_buff(var/one_hand_lever) //why does this need a user arg when it doesn't use user at all?
	if(!(flags_gun_lever_action & USES_STREAKS))
		return
	SIGNAL_HANDLER
	streak = 0
	lever_sound = initial(lever_sound)
	lever_message = initial(lever_message)
	wield_delay = initial(wield_delay)
	cur_onehand_chance = initial(cur_onehand_chance)
	//these are init configs and so cannot be initial()
	lever_delay = FIRE_DELAY_TIER_3
	fire_delay = FIRE_DELAY_TIER_1
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recalculate_attachment_bonuses() //stock wield delay
	if(one_hand_lever)
		addtimer(VARSET_CALLBACK(src, cur_onehand_chance, reset_onehand_chance), 4 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)

/obj/item/weapon/gun/lever_action/proc/replace_internal_mag(number_to_replace)
	if(!current_mag)
		return
	current_mag.chamber_contents = list()
	current_mag.chamber_contents.len = current_mag.max_rounds
	for(var/i = 1 to current_mag.max_rounds) //We want to make sure to populate the internal_mag.
		current_mag.chamber_contents[i] = i > number_to_replace ? "empty" : current_mag.default_ammo
	current_mag.chamber_position = current_mag.current_rounds //The position is always in the beginning [1]. It can move from there.

/obj/item/weapon/gun/lever_action/proc/add_to_internal_mag(mob/user,selection) //bullets are added forward.
	if(!current_mag)
		return
	current_mag.chamber_position++ //We move the position up when loading ammo. New rounds are always fired next, in order loaded.
	current_mag.chamber_contents[current_mag.chamber_position] = selection //Just moves up one, unless the mag is full.
	if(current_mag.current_rounds == 1 && !in_chamber) //The previous proc in the reload() cycle adds ammo, so the best workaround here,
		update_icon()	//This is not needed for now. Maybe we'll have loaded sprites at some point, but I doubt it. Also doesn't play well with double barrel.
		ready_in_chamber()
		cock_gun(user)
	if(user) playsound(user, reload_sound, 25, TRUE)
	return TRUE

/obj/item/weapon/gun/lever_action/proc/empty_chamber(mob/user)
	if(!current_mag)
		return
	if(current_mag.current_rounds <= 0)
		if(in_chamber)
			in_chamber = null
			var/obj/item/ammo_magazine/handful/new_handful = retrieve_bullet(ammo.type)
			playsound(user, reload_sound, 25, TRUE)
			new_handful.forceMove(get_turf(src))
		else
			if(user) to_chat(user, SPAN_WARNING("\The [src] is already empty."))
		return

	unload_bullet(user)
	if(!current_mag.current_rounds && !in_chamber) update_icon()

/obj/item/weapon/gun/lever_action/proc/unload_bullet(mob/user)
	if(isnull(current_mag) || !length(current_mag.chamber_contents))
		return
	var/obj/item/ammo_magazine/handful/new_handful = retrieve_bullet(current_mag.chamber_contents[current_mag.chamber_position])

	if(user)
		user.put_in_hands(new_handful)
		playsound(user, reload_sound, 25, TRUE)
	else new_handful.forceMove(get_turf(src))

	current_mag.current_rounds--
	current_mag.chamber_contents[current_mag.chamber_position] = "empty"
	current_mag.chamber_position--
	return TRUE

/obj/item/weapon/gun/lever_action/proc/retrieve_bullet(selection)
	var/obj/item/ammo_magazine/handful/new_handful = new /obj/item/ammo_magazine/handful
	new_handful.generate_handful(selection, default_caliber, 9, 1, /obj/item/weapon/gun/lever_action)
	return new_handful

/obj/item/weapon/gun/lever_action/reload(mob/user, var/obj/item/ammo_magazine/magazine)

	if(!magazine || !istype(magazine,/obj/item/ammo_magazine/handful)) //Can only reload with handfuls.
		to_chat(user, SPAN_WARNING("You can't use that to reload!"))
		return

	var/mag_caliber = magazine.default_ammo //Handfuls can get deleted, so we need to keep this on hand for later.
	if(current_mag.transfer_ammo(magazine,user,1))
		add_to_internal_mag(user,mag_caliber) //This will check the other conditions.

/obj/item/weapon/gun/lever_action/proc/ready_lever_action_internal_mag()
	if(isnull(current_mag) || !length(current_mag.chamber_contents))
		return
	if(current_mag.current_rounds > 0)
		ammo = GLOB.ammo_list[current_mag.chamber_contents[current_mag.chamber_position]]
		in_chamber = create_bullet(ammo, initial(name))
		current_mag.current_rounds--
		current_mag.chamber_contents[current_mag.chamber_position] = "empty"
		current_mag.chamber_position--
		return in_chamber

/obj/item/weapon/gun/lever_action/ready_in_chamber()
	return ready_lever_action_internal_mag()

/obj/item/weapon/gun/lever_action/reload_into_chamber(mob/user)
	if(!active_attachable)
		in_chamber = null

		//Time to move the internal_mag position.
		ready_in_chamber() //We're going to try and reload. If we don't get anything, icon change.
		if(!current_mag.current_rounds && !in_chamber) //No rounds, nothing chambered.
			update_icon()

	return TRUE

/obj/item/weapon/gun/lever_action/unique_action(mob/user)
	work_lever(user)

/obj/item/weapon/gun/lever_action/ready_in_chamber()
	return

/obj/item/weapon/gun/lever_action/add_to_internal_mag(mob/user, selection) //Load it on the go, nothing chambered.
	if(!current_mag)
		return
	current_mag.chamber_position++
	current_mag.chamber_contents[current_mag.chamber_position] = selection
	playsound(user, reload_sound, 25, TRUE)
	return TRUE

/obj/item/weapon/gun/lever_action/proc/work_lever(mob/living/carbon/human/user)
	if(world.time < (recent_lever + lever_delay))
		return
	if(levered)
		if (world.time > (message_cooldown + lever_delay))
			to_chat(user, SPAN_WARNING("<i>\The [src] already has a bullet in the chamber!<i>"))
			message_cooldown = world.time
		return
	if(in_chamber) //eject the chambered round
		in_chamber = null
		var/obj/item/ammo_magazine/handful/new_handful = retrieve_bullet(ammo.type)
		new_handful.forceMove(get_turf(src))

	ready_lever_action_internal_mag()

	recent_lever = world.time
	if(in_chamber)
		if(levering_sprite)
			flick(levering_sprite, src)
		if(world.time < (last_fired + 2 SECONDS)) //if it's not wielded and you shot recently, one-hand lever
			try_onehand_lever(user)
		else
			twohand_lever(user)

		playsound(user, lever_sound, 25, TRUE)
		levered = TRUE

/obj/item/weapon/gun/lever_action/proc/twohand_lever(mob/living/carbon/human/user)
	to_chat(user, SPAN_WARNING(lever_message))
	if(flags_gun_lever_action & MOVES_WHEN_LEVERING)
		animation_move_up_slightly(src)

/obj/item/weapon/gun/lever_action/proc/try_onehand_lever(mob/living/carbon/human/user)
	if(flags_item & WIELDED)
		twohand_lever(user)
		return
	if(flags_gun_lever_action & MOVES_WHEN_LEVERING)
		to_chat(user, SPAN_WARNING("<i>You spin \the [src] one-handed! Fuck yeah!<i>"))
		animation_wrist_flick(src)
	direct_hit_buff(user, ,TRUE)

/obj/item/weapon/gun/lever_action/reload_into_chamber(mob/user)
	if(!current_mag)
		return
	if(!active_attachable)
		levered = FALSE //It was fired, so let's unlock the lever.
		in_chamber = null
		if(!current_mag.current_rounds && !in_chamber)
			update_icon() //No rounds, nothing chambered.

	return TRUE

/obj/item/weapon/gun/lever_action/unload(mob/user)
	if(levered)
		to_chat(user, SPAN_WARNING("You open the lever on \the [src]."))
		levered = FALSE
	return empty_chamber(user)


//===================THE R4T===================\\

/obj/item/weapon/gun/lever_action/r4t
	name = "R4T lever-action rifle"
	desc = "This lever-action was designed for small scout operations in harsh environments such as the jungle or particularly windy deserts, as such its internal mechanisms are simple yet robust."
	icon_state = "r4t"
	item_state = "r4t"
	flags_equip_slot = SLOT_BACK
	attachable_allowed = list(
						//Barrel
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/suppressor,
						/obj/item/attachable/compensator,
						//Rail
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/scope/mini,
						//Under
						/obj/item/attachable/gyro,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/magnetic_harness/lever_sling,
						//Stock
						/obj/item/attachable/stock/r4t
						)
	map_specific_decoration = TRUE
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG|GUN_AMMO_COUNTER
	flags_gun_lever_action = MOVES_WHEN_LEVERING|DANGEROUS_TO_ONEHAND_LEVER

/obj/item/weapon/gun/lever_action/r4t/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19, "rail_x" = 11, "rail_y" = 21, "under_x" = 24, "under_y" = 16, "stock_x" = 15, "stock_y" = 14)

//===================THE XM88===================\\

#define FLOATING_PENETRATION_TIER_0	0
#define FLOATING_PENETRATION_TIER_1	1
#define FLOATING_PENETRATION_TIER_2	2
#define FLOATING_PENETRATION_TIER_3	3
#define FLOATING_PENETRATION_TIER_4	4

/obj/item/weapon/gun/lever_action/xm88
	name = "\improper XM88 heavy rifle"
	desc = "An experimental man-portable anti-material rifle chambered in .458 SOCOM. It must be manually chambered for every shot.\nIt has a special property - when you obtain multiple direct hits in a row, its armour penetration and damage will increase."
	desc_lore = "Originally developed by ARMAT Battlefield Systems for the government of the state of Greater Brazil for use in the Favela Wars (2161 - Ongoing) against mechanized infantry. The platform features an onboard computerized targeting system, sensor array, and an electronic autoloader; these features work in tandem to reduce and render inert armor on the users target with successive hits. The Almayer was issued a small amount of XM88s while preparing for Operation Swamp Hopper with the USS Nan-Shan."
	icon_state = "boomslang"
	item_state = "boomslang"
	fire_sound = 'sound/weapons/gun_boomslang_fire.ogg'
	reload_sound = 'sound/weapons/handling/gun_boomslang_reload.ogg'
	lever_sound = 'sound/weapons/handling/gun_boomslang_lever.ogg'
	lever_super_sound = 'sound/weapons/handling/gun_lever_action_superload.ogg'
	lever_hitsound = 'sound/weapons/handling/gun_boomslang_hitsound.ogg'
	flags_equip_slot = SLOT_BACK
	map_specific_decoration = TRUE
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG|GUN_AMMO_COUNTER
	levering_sprite = null
	flags_gun_lever_action = USES_STREAKS
	lever_name = "chambering button"
	lever_message = "<i>You press the chambering button.<i>"
	current_mag = /obj/item/ammo_magazine/internal/lever_action/xm88
	default_caliber = ".458"
	hit_buff_reset_cooldown = 2 SECONDS //how much time after a direct hit until streaks reset
	var/floating_penetration = FLOATING_PENETRATION_TIER_0 //holder var
	var/floating_penetration_upper_limit = FLOATING_PENETRATION_TIER_4
	attachable_allowed = list(
						//Barrel
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/suppressor,
						/obj/item/attachable/compensator,
						//Rail
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/scope/mini/xm88,
						//Under
						/obj/item/attachable/gyro,
						/obj/item/attachable/lasersight,
						//Stock
						/obj/item/attachable/stock/xm88
						)

/obj/item/weapon/gun/lever_action/xm88/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_1
	lever_delay = FIRE_DELAY_TIER_3
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = 0
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3
	recoil_unwielded = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/lever_action/xm88/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 17, "rail_x" = 11, "rail_y" = 21, "under_x" = 22, "under_y" = 13, "stock_x" = 12, "stock_y" = 15)

/obj/item/weapon/gun/lever_action/xm88/apply_hit_buff()
	lever_sound = lever_super_sound
	lever_message = "<b><i>You quickly press the [lever_name]!<i><b>"
	last_fired = world.time - buff_fire_reduc //to shoot the next round faster
	fire_delay = FIRE_DELAY_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4

	if(floating_penetration < floating_penetration_upper_limit)
		floating_penetration++

	for(var/slot in attachments)
		var/obj/item/attachable/AM = attachments[slot]
		if(AM && (AM.damage_mod || AM.delay_mod))
			damage_mult += AM.damage_mod
			fire_delay += AM.delay_mod
	wield_delay = 0 //for one-handed levering

/obj/item/weapon/gun/lever_action/xm88/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	if(!able_to_fire(user) || !target) //checks here since we don't want to fuck up applying the increase
		return
	if(floating_penetration && in_chamber) //has to go before actual firing
		var/obj/item/projectile/P = in_chamber
		switch(floating_penetration)
			if(FLOATING_PENETRATION_TIER_1)
				P.ammo = GLOB.ammo_list[/datum/ammo/bullet/lever_action/xm88/pen20]
			if(FLOATING_PENETRATION_TIER_2)
				P.ammo = GLOB.ammo_list[/datum/ammo/bullet/lever_action/xm88/pen30]
			if(FLOATING_PENETRATION_TIER_3)
				P.ammo = GLOB.ammo_list[/datum/ammo/bullet/lever_action/xm88/pen40]
			if(FLOATING_PENETRATION_TIER_4)
				P.ammo = GLOB.ammo_list[/datum/ammo/bullet/lever_action/xm88/pen50]
	return ..()

/obj/item/weapon/gun/lever_action/xm88/unload(mob/user)
	if(levered)
		to_chat(user, SPAN_WARNING("You open \the [src]'s breech and take out a round."))
		levered = FALSE
	return empty_chamber(user)

/obj/item/weapon/gun/lever_action/xm88/reset_hit_buff(var/one_hand_lever) //why does this need a user arg when it doesn't use user at all?
	if(!(flags_gun_lever_action & USES_STREAKS))
		return
	SIGNAL_HANDLER
	streak = 0
	lever_sound = initial(lever_sound)
	lever_message = initial(lever_message)
	wield_delay = initial(wield_delay)
	cur_onehand_chance = initial(cur_onehand_chance)
	if(in_chamber)
		var/obj/item/projectile/P = in_chamber
		P.ammo = GLOB.ammo_list[/datum/ammo/bullet/lever_action/xm88]
	floating_penetration = FLOATING_PENETRATION_TIER_0
	//these are init configs and so cannot be initial()
	fire_delay = FIRE_DELAY_TIER_1 + FIRE_DELAY_TIER_10
	lever_delay = FIRE_DELAY_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recalculate_attachment_bonuses() //stock wield delay
	visible_message(SPAN_WARNING("\The [src] beeps as it loses its targeting data, and returns to normal firing procedures."), max_distance = 1) // tell them they've lost stacks
	if(one_hand_lever)
		addtimer(VARSET_CALLBACK(src, cur_onehand_chance, reset_onehand_chance), 4 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)

#undef FLOATING_PENETRATION_TIER_0
#undef FLOATING_PENETRATION_TIER_1
#undef FLOATING_PENETRATION_TIER_2
#undef FLOATING_PENETRATION_TIER_3
#undef FLOATING_PENETRATION_TIER_4
