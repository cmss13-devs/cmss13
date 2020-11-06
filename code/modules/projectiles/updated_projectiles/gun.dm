#define CODEX_ARMOR_MAX 50
#define CODEX_ARMOR_STEP 5

/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/items/weapons/guns/gun.dmi'
	icon_state = ""
	item_state = "gun"
	matter = null
						//Guns generally have their own unique levels.
	w_class 	= SIZE_MEDIUM
	throwforce 	= 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	force 		= 5
	attack_verb = null
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi'
		)
	flags_atom = FPRINT|CONDUCT
	flags_item = TWOHANDED

	var/iff_enabled_current = FALSE
	var/iff_enabled = FALSE
	var/iff_group_cache

	var/accepted_ammo = list()
	var/muzzle_flash 	= "muzzle_flash"
	var/muzzle_flash_lum = 3 //muzzle flash brightness

	var/fire_sound 		= 'sound/weapons/Gunshot.ogg'
	var/fire_rattle		= null //Does our gun have a unique empty mag sound? If so use instead of pitch shifting.
	var/unload_sound 	= 'sound/weapons/flipblade.ogg'
	var/empty_sound 	= 'sound/weapons/smg_empty_alarm.ogg'
	var/reload_sound 	= null					//We don't want these for guns that don't have them.
	var/cocked_sound 	= null
	var/cock_cooldown	= 0						//world.time value, to prevent COCK COCK COCK COCK
	var/cock_delay		= 30					//Delay before we can cock again, in tenths of seconds

	//Ammo will be replaced on New() for things that do not use mags..
	var/datum/ammo/ammo = null					//How the bullet will behave once it leaves the gun, also used for basic bullet damage and effects, etc.
	var/obj/item/projectile/in_chamber = null 	//What is currently in the chamber. Most guns will want something in the chamber upon creation.
	/*Ammo mags may or may not be internal, though the difference is a few additional variables. If they are not internal, don't call
	on those unique vars. This is done for quicker pathing. Just keep in mind most mags aren't internal, though some are.
	This is also the default magazine path loaded into a projectile weapon for reverse lookups on New(). Leave this null to do your own thing.*/
	var/obj/item/ammo_magazine/internal/current_mag = null

	//Basic stats.
	var/accuracy_mult 			= 0				//Multiplier. Increased and decreased through attachments. Multiplies the projectile's accuracy by this number.
	var/damage_mult 			= 1				//Same as above, for damage.
	var/damage_falloff_mult 	= 1				//Same as above, for damage bleed (falloff)
	var/damage_buildup_mult		= 1				//Same as above, for damage bleed (buildup)
	var/recoil 					= 0				//Screen shake when the weapon is fired.
	var/scatter					= 0				//How much the bullet scatters when fired.
	var/burst_scatter_mult		= 4				//Multiplier. Increases or decreases how much bonus scatter is added with each bullet during burst fire (wielded only).

	var/effective_range_min		= 0				//What minimum range the weapon deals full damage, builds up the closer you get. 0 for no minimum.
	var/effective_range_max		= 0				//What maximum range the weapon deals full damage, tapers off using damage_falloff after hitting this value. 0 for no maximum.

	var/accuracy_mult_unwielded 		= 1		//same vars as above but for unwielded firing.
	var/recoil_unwielded 				= 0
	var/scatter_unwielded 				= 0

	var/movement_acc_penalty_mult = 5				//Multiplier. Increased and decreased through attachments. Multiplies the accuracy/scatter penalty of the projectile when firing onehanded while moving.

	var/fire_delay = 0							//For regular shots, how long to wait before firing again.
	var/last_fired = 0							//When it was last fired, related to world.time.

	var/aim_slowdown	= 0						//Self explanatory. How much does aiming (wielding the gun) slow you
	var/wield_delay		= WIELD_DELAY_FAST		//How long between wielding and firing in tenths of seconds
	var/wield_time		= 0						//Storing value for above
	var/guaranteed_delay_time = 0				//Storing value for guaranteed delay
	var/pull_time		= 0						//Storing value for how long pulling a gun takes before you can use it
	var/fast_pulled		= 0						//If 1, next pull will be fast, this halves pulling time

	var/delay_style		= WEAPON_DELAY_SCATTER_AND_ACCURACY

	//Burst fire.
	var/burst_amount 	= 1						//How many shots can the weapon shoot in burst? Anything less than 2 and you cannot toggle burst.
	var/burst_delay 	= 1						//The delay in between shots. Lower = less delay = faster.
	var/extra_delay 	= 0						//When burst-firing, this number is extra time before the weapon can fire again. Depends on number of rounds fired.

	// Full auto
	var/fa_firing = FALSE						//Whether or not the gun is firing full-auto
	var/fa_shots = 0							//How many shots have been fired using full-auto. Used to figure out scatter
	var/fa_scatter_peak = 8						//How many full-auto shots to get to max scatter?
	var/fa_max_scatter = 5						//How bad does the scatter get on full auto?
	var/fa_delay = 2.5							//The delay when firing full-auto
	var/atom/fa_target = null					//The atom we're shooting at while full-autoing
	var/fa_params = null						//Click parameters to use when firing full-auto

	//Targeting.
	var/tmp/list/mob/living/target				//List of who yer targeting.
	var/tmp/mob/living/last_moved_mob			//Used to fire faster at more than one person.
	var/tmp/lock_time 		= -100
	var/automatic 			= 0					//Used to determine if you can target multiple people.
	var/tmp/told_cant_shoot = 0					//So that it doesn't spam them with the fact they cannot hit them.

	//Attachments.
	var/list/attachments = list()				//List of all current attachments on the gun.
	var/attachable_overlays[] = null			//List of overlays so we can switch them in an out, instead of using Cut() on overlays.
	var/attachable_offset[] = null				//Is a list, see examples of from the other files. Initiated on New() because lists don't initial() properly.
	var/list/attachable_allowed = list()		//Must be the exact path to the attachment present in the list. Empty list for a default.
	var/list/random_spawn_rail = list() 		//Used when a gun will have a chance to spawn with attachments.
	var/list/random_spawn_muzzle = list()  		//Used when a gun will have a chance to spawn with attachments.
	var/list/random_spawn_underbarrel = list()  //Used when a gun will have a chance to spawn with attachments.
	var/list/random_spawn_stock = list()  		//Used when a gun will have a chance to spawn with attachments.
	var/random_spawn_chance = 50				//Chance for an attachment to spawn in each slot.
	var/obj/item/attachable/attached_gun/active_attachable = null //This will link to one of the attachments, or remain null.
	var/list/starting_attachment_types = null //What attachments this gun starts with THAT CAN BE REMOVED. Important to avoid nuking the attachments on restocking! Added on New()

	var/flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK

	var/base_gun_icon //the default gun icon_state. change to reskin the gun
	var/has_empty_icon = TRUE // whether gun has icon state of (base_gun_icon)_e
	var/has_open_icon = FALSE // whether gun has icon state of (base_gun_icon)_o

	var/recoil_loss_per_second = 10 // How much recoil_buildup is lost per second. Builds up as time passes, and is set to 0 when a single shot is fired
	var/recoil_buildup = 0 // The recoil on a dynamic recoil gun

	var/recoil_buildup_limit = 0 //The limit at which the recoil on a gun can reach. Usually the maximum value

	var/last_recoil_update = 0


//----------------------------------------------------------
				//				    \\
				// NECESSARY PROCS  \\
				//					\\
				//					\\
//----------------------------------------------------------

/obj/item/weapon/gun/New(loc, spawn_empty) //You can pass on spawn_empty to make the sure the gun has no bullets or mag or anything when created.
	..()					//This only affects guns you can get from vendors for now. Special guns spawn with their own things regardless.
	base_gun_icon = icon_state
	attachable_overlays = list("muzzle" = null, "rail" = null, "under" = null, "stock" = null, "mag" = null, "special" = null)
	item_state_slots = list("back" = item_state, "j_store" = item_state)

	if(current_mag)
		if(spawn_empty && !(flags_gun_features & GUN_INTERNAL_MAG)) //Internal mags will still spawn, but they won't be filled.
			current_mag = null
			update_icon()
		else
			current_mag = new current_mag(src, spawn_empty? 1:0)
			ammo = current_mag.default_ammo ? ammo_list[current_mag.default_ammo] : ammo_list[/datum/ammo/bullet] //Latter should never happen, adding as a precaution.
	else ammo = ammo_list[ammo] //If they don't have a mag, they fire off their own thing.

	set_gun_attachment_offsets()
	set_gun_config_values()
	update_force_list() //This gives the gun some unique attack verbs for attacking.
	handle_starting_attachment()
	handle_random_attachments(random_spawn_chance)


/obj/item/weapon/gun/proc/set_gun_attachment_offsets()
	attachable_offset = null


//Called by the gun's New(), set the gun variables' values.
//Each gun gets its own version of the proc instead of adding/substracting
//amounts to get specific values in each gun subtype's New().
//This makes reading each gun's values MUCH easier.
/obj/item/weapon/gun/proc/set_gun_config_values()
	fire_delay = FIRE_DELAY_TIER_5
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	burst_amount = BURST_AMOUNT_TIER_1
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	damage_falloff_mult = DAMAGE_FALLOFF_TIER_10
	damage_buildup_mult = DAMAGE_BUILDUP_TIER_1
	recoil = RECOIL_OFF
	recoil_unwielded = RECOIL_OFF
	movement_acc_penalty_mult = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_1

	effective_range_min = EFFECTIVE_RANGE_OFF
	effective_range_max = EFFECTIVE_RANGE_OFF

	recoil_buildup_limit = RECOIL_AMOUNT_TIER_1 / RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER

	//reset initial define-values
	aim_slowdown = initial(aim_slowdown)
	wield_delay = initial(wield_delay)

/obj/item/weapon/gun/proc/recalculate_attachment_bonuses()
	//Reset silencer mod
	flags_gun_features &= ~GUN_SILENCED
	muzzle_flash = initial(muzzle_flash)
	fire_sound = initial(fire_sound)

	//reset weight and force mods
	force = initial(force)
	w_class = initial(w_class)

	//Get default gun config values
	set_gun_config_values()

	//Add attachment bonuses
	for(var/slot in attachments)
		var/obj/item/attachable/R = attachments[slot]
		if(!R) continue
		fire_delay += R.delay_mod
		accuracy_mult += R.accuracy_mod
		accuracy_mult_unwielded += R.accuracy_unwielded_mod
		scatter += R.scatter_mod
		scatter_unwielded += R.scatter_unwielded_mod
		damage_mult += R.damage_mod
		damage_falloff_mult += R.damage_falloff_mod
		damage_buildup_mult += R.damage_buildup_mod
		effective_range_min += R.range_min_mod
		effective_range_max += R.range_max_mod
		recoil += R.recoil_mod
		burst_scatter_mult += R.burst_scatter_mod
		burst_amount += R.burst_mod
		recoil_unwielded += R.recoil_unwielded_mod
		aim_slowdown += R.aim_speed_mod
		wield_delay += R.wield_delay_mod
		movement_acc_penalty_mult += R.movement_acc_penalty_mod
		force += R.melee_mod
		w_class += R.size_mod

		if(R.silence_mod)
			flags_gun_features |= GUN_SILENCED
			muzzle_flash = null
			fire_sound = "gun_silenced"

/obj/item/weapon/gun/proc/handle_random_attachments(var/randchance)
	var/attachmentchoice

	if(prob(randchance) && !attachments["rail"]) // Rail
		attachmentchoice = safepick(random_spawn_rail)
		if(attachmentchoice)
			var/obj/item/attachable/R = new attachmentchoice(src)
			R.Attach(src)
			update_attachable(R.slot)
			attachmentchoice = FALSE

	if(prob(randchance) && !attachments["muzzle"]) // Muzzle
		attachmentchoice = safepick(random_spawn_muzzle)
		if(attachmentchoice)
			var/obj/item/attachable/M = new attachmentchoice(src)
			M.Attach(src)
			update_attachable(M.slot)
			attachmentchoice = FALSE

	if(prob(randchance) && !attachments["under"]) // Underbarrel
		attachmentchoice = safepick(random_spawn_underbarrel)
		if(attachmentchoice)
			var/obj/item/attachable/U = new attachmentchoice(src)
			U.Attach(src)
			update_attachable(U.slot)
			attachmentchoice = FALSE

	if(prob(randchance) && !attachments["stock"]) // Stock
		attachmentchoice = safepick(random_spawn_stock)
		if(attachmentchoice)
			var/obj/item/attachable/S = new attachmentchoice(src)
			S.Attach(src)
			update_attachable(S.slot)
			attachmentchoice = FALSE


/obj/item/weapon/gun/proc/handle_starting_attachment()
	if(starting_attachment_types && starting_attachment_types.len)
		for(var/path in starting_attachment_types)
			var/obj/item/attachable/A = new path(src)
			A.Attach(src)
			update_attachable(A.slot)


/obj/item/weapon/gun/Destroy()
	in_chamber 		= null
	ammo 			= null
	current_mag 	= null
	target 			= null
	last_moved_mob 	= null
	if(flags_gun_features & GUN_FLASHLIGHT_ON)//Handle flashlight.
		flags_gun_features &= ~GUN_FLASHLIGHT_ON
		if(ismob(loc))
			for(var/slot in attachments)
				var/obj/item/attachable/R = attachments[slot]
				if(!R) continue
				loc.SetLuminosity(-R.light_mod)
		else
			SetLuminosity(0)
	attachments = null
	attachable_overlays = null
	. = ..()

/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/weapon/gun/equipped(mob/user, slot)
	if(slot != WEAR_L_HAND && slot != WEAR_R_HAND)
		stop_aim()
		if (user.client)
			user.update_gun_icons()

	unwield(user)
	if(fast_pulled)
		pull_time = world.time + wield_delay
		if(user.dazed)
			pull_time += 3
		guaranteed_delay_time = world.time + WEAPON_GUARANTEED_DELAY
		fast_pulled = 0
	else
		pull_time = world.time + wield_delay
		if(user.dazed)
			pull_time += 3
		guaranteed_delay_time = world.time + WEAPON_GUARANTEED_DELAY

	return ..()

/obj/item/weapon/gun/update_icon()
	if(overlays)
		overlays.Cut()
	else
		overlays = list()
	..()
	if(blood_overlay) //need to reapply bloodstain because of the Cut.
		overlays += blood_overlay

	var/new_icon_state = base_gun_icon

	if(has_empty_icon && (!current_mag || current_mag.current_rounds <= 0))
		new_icon_state += "_e"

	if(has_open_icon && (!current_mag || !current_mag.chamber_closed))
		new_icon_state += "_o"

	icon_state = new_icon_state
	update_mag_overlay()
	update_attachables()

/obj/item/weapon/gun/examine(mob/user)
	..()
	var/dat = ""
	if(flags_gun_features & GUN_TRIGGER_SAFETY)
		dat += "The safety's on!<br>"
	else
		dat += "The safety's off!<br>"

	for(var/slot in attachments)
		var/obj/item/attachable/R = attachments[slot]
		if(!R) continue
		switch(R.slot)
			if("rail") 	dat += "It has [htmlicon(R)] [R.name] mounted on the top.<br>"
			if("muzzle") 	dat += "It has [htmlicon(R)] [R.name] mounted on the front.<br>"
			if("stock") 	dat += "It has [htmlicon(R)] [R.name] for a stock.<br>"
			if("under")
				dat += "It has [htmlicon(R)] [R.name]"
				if(istype(R, /obj/item/attachable/attached_gun/extinguisher))
					var/obj/item/attachable/attached_gun/extinguisher/E = R
					dat += " ([E.internal_extinguisher.reagents.total_volume]/[E.internal_extinguisher.max_water])"
				else if(R.flags_attach_features & ATTACH_WEAPON)
					dat += " ([R.current_rounds]/[R.max_rounds])"
				dat += " mounted underneath.<br>"
			else dat += "It has [htmlicon(R)] [R.name] attached.<br>"

	if(!(flags_gun_features & (GUN_INTERNAL_MAG|GUN_UNUSUAL_DESIGN))) //Internal mags and unusual guns have their own stuff set.
		if(current_mag && current_mag.current_rounds > 0)
			if(flags_gun_features & GUN_AMMO_COUNTER) dat += "Ammo counter shows [current_mag.current_rounds] round\s remaining.<br>"
			else 								dat += "It's loaded[in_chamber?" and has a round chambered":""].<br>"
		else 									dat += "It's unloaded[in_chamber?" but has a round chambered":""].<br>"
	if(!(flags_gun_features & GUN_UNUSUAL_DESIGN))
		dat += "[htmlicon(src)] <a href='?src=\ref[src];list_stats=1'>\[See combat statistics]</a><br>"
	
	if(dat)
		to_chat(user, dat)

/obj/item/weapon/gun/Topic(href, href_list)
	if(!ishuman(usr) && !isobserver(usr))
		return

	if(href_list["list_stats"] && !(flags_gun_features & GUN_UNUSUAL_DESIGN))
		ui_interact(usr, "weapon_stat")


/obj/item/weapon/gun/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)
	var/datum/asset/assets = get_asset_datum(/datum/asset/nanoui/weapons)
	assets.send(user)

	var/ammo_name = "bullet"

	var/damage = 0
	var/bonus_projectile_amount = 0

	var/falloff = 0

	var/gun_recoil = src.recoil

	if(flags_gun_features & GUN_RECOIL_BUILDUP)
		update_recoil_buildup() // Need to update recoil values

		gun_recoil = recoil_buildup

	var/penetration = 0
	var/armor_punch = 0

	var/accuracy = 0

	var/min_accuracy = 0

	var/max_range = 0
	var/scatter = 0
	
	var/list/damage_armor_profile_xeno = list()
	var/list/damage_armor_profile_marine = list()
	var/list/damage_armor_profile_armorbreak = list()
	var/list/damage_armor_profile_headers = list()

	var/datum/ammo/in_ammo
	if(in_chamber && in_chamber.ammo)
		in_ammo = in_chamber.ammo
	else if(current_mag && current_mag.current_rounds > 0)
		if(istype(current_mag) && current_mag.chamber_contents[current_mag.chamber_position] != "empty")
			in_ammo = ammo_list[current_mag.chamber_contents[current_mag.chamber_position]]
			if(!istype(in_ammo))
				in_ammo = ammo_list[current_mag.default_ammo]
		else if(!istype(current_mag) && ammo)
			in_ammo = ammo

	var/has_ammo = istype(in_ammo)

	if(has_ammo)
		ammo_name = in_ammo.name

		damage = in_ammo.damage * damage_mult
		bonus_projectile_amount = in_ammo.bonus_projectiles_amount
		falloff = in_ammo.damage_falloff * damage_falloff_mult

		penetration = in_ammo.penetration
		armor_punch = in_ammo.damage_armor_punch

		accuracy = in_ammo.accurate_range

		min_accuracy = in_ammo.accurate_range_min

		max_range = in_ammo.max_range
		scatter = in_ammo.scatter

		for(var/i = 0; i<=CODEX_ARMOR_MAX; i+=CODEX_ARMOR_STEP)
			damage_armor_profile_headers.Add(i)
			damage_armor_profile_marine.Add(round(armor_damage_reduction(config.marine_ranged_stats, damage, i, penetration)))
			damage_armor_profile_xeno.Add(round(armor_damage_reduction(config.xeno_ranged_stats, damage, i, penetration)))
			if(i != 0)
				damage_armor_profile_armorbreak.Add("[round(armor_break_calculation(config.xeno_ranged_stats, damage, i, penetration, in_ammo.pen_armor_punch, armor_punch)/i)]%")
			else
				damage_armor_profile_armorbreak.Add("N/A")
	
	var/rpm = max(fire_delay, 0.0001)
	var/burst_rpm = max(((fire_delay + (burst_delay * burst_amount)) / max(burst_amount, 1)), 0.0001)

	var/list/data = list(
		"name" = name,
		"desc" = desc,
		"icon" = SSassets.transport.get_asset_url("[base_gun_icon].png"),

		"two_handed_only" = (flags_gun_features & GUN_WIELDED_FIRING_ONLY),

		"recoil" = max(gun_recoil, 0.1),
		"unwielded_recoil" = max(recoil_unwielded, 0.1),

		"has_ammo" = has_ammo,

		"automatic" = (flags_gun_features & GUN_HAS_FULL_AUTO),

		"ammo_name" = ammo_name,
		"damage" = damage,
		"falloff" = falloff,
		"total_projectile_amount" = bonus_projectile_amount+1,
		
		"armor_punch" = armor_punch,
		"penetration" = penetration,

		"accuracy" = accuracy * accuracy_mult,
		"unwielded_accuracy" = accuracy * accuracy_mult_unwielded,
		"min_accuracy" = min_accuracy,
		"max_range" = max_range,
		"scatter" = max(0.1, scatter + src.scatter),
		"unwielded_scatter" = max(0.1, scatter + scatter_unwielded),

		"burst_scatter" = src.burst_scatter_mult,
		"burst_amount" = burst_amount,
		"firerate" = round(MINUTES_1 / rpm), // 3 minutes so that the values look greater than they actually are
		"burst_firerate" = round(MINUTES_1 / burst_rpm),

		"firerate_second" = round(SECONDS_1 / rpm, 0.01),
		"burst_firerate_second" = round(SECONDS_1 / burst_rpm, 0.01),

		"recoil_max" = RECOIL_AMOUNT_TIER_1,
		"scatter_max" = SCATTER_AMOUNT_TIER_1,
		"firerate_max" = MINUTES_1 / FIRE_DELAY_TIER_10,
		"damage_max" = BULLET_DAMAGE_TIER_20,
		"accuracy_max" = AMMO_RANGE_TIER_15,
		"range_max" = AMMO_RANGE_TIER_15,
		"falloff_max" = DAMAGE_FALLOFF_TIER_1,
		"penetration_max" = ARMOR_PENETRATION_TIER_10,
		"punch_max" = 5,

		"damage_armor_profile_headers" = damage_armor_profile_headers,
		"damage_armor_profile_marine" = damage_armor_profile_marine,
		"damage_armor_profile_xeno" = damage_armor_profile_xeno,
		"damage_armor_profile_armorbreak" = damage_armor_profile_armorbreak,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "weapon_stats.tmpl", "USCM Weapon Codex", 850, 915)
		ui.set_initial_data(data)
		ui.set_auto_update(FALSE)
		ui.open()

/obj/item/weapon/gun/wield(var/mob/user)

	if(!(flags_item & TWOHANDED) || flags_item & WIELDED)
		return

	if(world.time < pull_time) //Need to wait until it's pulled out to aim
		return

	var/obj/item/I = user.get_inactive_hand()
	if(I)
		user.drop_inv_item_on_ground(I)

	if(ishuman(user))
		var/check_hand = user.r_hand == src ? "l_hand" : "r_hand"
		var/mob/living/carbon/human/wielder = user
		var/obj/limb/hand = wielder.get_limb(check_hand)
		if(!istype(hand) || !hand.is_usable())
			to_chat(user, SPAN_WARNING("Your other hand can't hold \the [src]!"))
			return

	flags_item 	   ^= WIELDED
	name 	   += " (Wielded)"
	item_state += "_w"
	slowdown = initial(slowdown) + aim_slowdown
	place_offhand(user, initial(name))
	wield_time = world.time + wield_delay
	if(user.dazed)
		wield_time += 5
	guaranteed_delay_time = world.time + WEAPON_GUARANTEED_DELAY
	//slower or faster wield delay depending on skill.
	if(user.skills)
		if(user.skills.get_skill_level(SKILL_FIREARMS) == 0) //no training in any firearms
			wield_time += 3
		else
			wield_time -= 2*user.skills.get_skill_level(SKILL_FIREARMS)
	return 1

/obj/item/weapon/gun/unwield(var/mob/user)

	if((flags_item|TWOHANDED|WIELDED) != flags_item)
		return //Have to be actually a twohander and wielded.

	on_unwield()

	flags_item ^= WIELDED
	name 	    = copytext(name, 1, -10)
	item_state  = copytext(item_state, 1, -2)
	slowdown = initial(slowdown)
	remove_offhand(user)
	return 1

//----------------------------------------------------------
			//							        \\
			// LOADING, RELOADING, AND CASINGS  \\
			//							        \\
			//						   	        \\
//----------------------------------------------------------

/obj/item/weapon/gun/proc/replace_ammo(mob/user = null, var/obj/item/ammo_magazine/magazine)
	reset_iff_group_cache()
	if(!magazine.default_ammo)
		to_chat(user, "Something went horribly wrong. Ahelp the following: ERROR CODE A1: null ammo while reloading.")
		log_debug("ERROR CODE A1: null ammo while reloading. User: <b>[user]</b>")
		ammo = ammo_list[/datum/ammo/bullet] //Looks like we're defaulting it.
	else ammo = ammo_list[magazine.default_ammo]

//Hardcoded and horrible
/obj/item/weapon/gun/proc/cock_gun(mob/user)
	set waitfor = 0
	if(cocked_sound)
		sleep(3)
		if(user && loc) playsound(user, cocked_sound, 25, 1)

/*
Reload a gun using a magazine.
This sets all the initial datum's stuff. The bullet does the rest.
User can be passed as null, (a gun reloading itself for instance), so we need to watch for that constantly.
*/
/obj/item/weapon/gun/proc/reload(mob/user, obj/item/ammo_magazine/magazine) //override for guns who use more special mags.
	if(flags_gun_features & (GUN_BURST_FIRING|GUN_UNUSUAL_DESIGN|GUN_INTERNAL_MAG))
		return

	if(!magazine || !istype(magazine))
		to_chat(user, SPAN_WARNING("That's not a magazine!"))
		return

	if(magazine.flags_magazine & AMMUNITION_HANDFUL)
		to_chat(user, SPAN_WARNING("[src] needs an actual magazine."))
		return

	if(magazine.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("[magazine] is empty!"))
		return

	if(!istype(src, magazine.gun_type) && !((magazine.type) in src.accepted_ammo))
		to_chat(user, SPAN_WARNING("That magazine doesn't fit in there!"))
		return

	if(current_mag)
		to_chat(user, SPAN_WARNING("It's still got something loaded."))
		return



	if(user)
		if(magazine.reload_delay > 1)
			to_chat(user, SPAN_NOTICE("You begin reloading [src]. Hold still..."))
			if(do_after(user, magazine.reload_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY)) replace_magazine(user, magazine)
			else
				to_chat(user, SPAN_WARNING("Your reload was interrupted!"))
				return
		else replace_magazine(user, magazine)
	else
		current_mag = magazine
		magazine.loc = src
		replace_ammo(,magazine)
		if(!in_chamber) load_into_chamber()

	update_icon()
	return 1

/obj/item/weapon/gun/proc/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	user.drop_inv_item_to_loc(magazine, src) //Click!
	current_mag = magazine
	replace_ammo(user,magazine)
	if(!in_chamber)
		ready_in_chamber()
		cock_gun(user)
	user.visible_message(SPAN_NOTICE("[user] loads [magazine] into [src]!"),
	SPAN_NOTICE("You load [magazine] into [src]!"), null, 3, CHAT_TYPE_COMBAT_ACTION)
	if(reload_sound) playsound(user, reload_sound, 25, 1, 5)


//Drop out the magazine. Keep the ammo type for next time so we don't need to replace it every time.
//This can be passed with a null user, so we need to check for that as well.
/obj/item/weapon/gun/proc/unload(mob/user, reload_override = 0, drop_override = 0, loc_override = 0) //Override for reloading mags after shooting, so it doesn't interrupt burst. Drop is for dropping the magazine on the ground.
	if(!reload_override && (flags_gun_features & (GUN_BURST_FIRING|GUN_UNUSUAL_DESIGN|GUN_INTERNAL_MAG)))
		return

	if(!current_mag || QDELETED(current_mag) || (current_mag.loc != src && !loc_override))
		cock(user)
		return

	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		current_mag.loc = get_turf(src) //Drop it on the ground.
	else
		user.put_in_hands(current_mag)

	playsound(user, unload_sound, 25, 1, 5)
	user.visible_message(SPAN_NOTICE("[user] unloads [current_mag] from [src]."),
	SPAN_NOTICE("You unload [current_mag] from [src]."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	current_mag.update_icon()
	current_mag = null

	update_icon()

//Manually cock the gun
//This only works on weapons NOT marked with UNUSUAL_DESIGN or INTERNAL_MAG
/obj/item/weapon/gun/proc/cock(mob/user)
	if(flags_gun_features & (GUN_BURST_FIRING|GUN_UNUSUAL_DESIGN|GUN_INTERNAL_MAG))
		return
	if(cock_cooldown > world.time)
		return

	cock_cooldown = world.time + cock_delay
	cock_gun(user)
	if(in_chamber)
		user.visible_message(SPAN_NOTICE("[user] cocks [src], clearing a [in_chamber.name] from its chamber."),
		SPAN_NOTICE("You cock [src], clearing a [in_chamber.name] from its chamber."), null, 4, CHAT_TYPE_COMBAT_ACTION)
		if(current_mag)
			var/found_handful
			for(var/obj/item/ammo_magazine/handful/H in user.loc)
				if(H.default_ammo == current_mag.default_ammo && H.caliber == current_mag.caliber && H.current_rounds < H.max_rounds)
					found_handful = TRUE
					H.current_rounds++
					H.update_icon()
					break
			if(!found_handful)
				var/obj/item/ammo_magazine/handful/new_handful = new /obj/item/ammo_magazine/handful
				new_handful.generate_handful(current_mag.default_ammo, current_mag.caliber, 8, 1, type)
				new_handful.loc = get_turf(src)
		in_chamber = null
	else
		user.visible_message(SPAN_NOTICE("[user] cocks [src]."),
		SPAN_NOTICE("You cock [src]."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	ready_in_chamber() //This will already check for everything else, loading the next bullet.


//----------------------------------------------------------
			//							    \\
			// AFTER ATTACK AND CHAMBERING  \\
			//							    \\
			//						   	    \\
//----------------------------------------------------------

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, flag, params)
	if(active_attachable && (active_attachable.flags_attach_features & ATTACH_MELEE)) //this is expected to do something in melee.
		return active_attachable.fire_attachment(A, src, user)
	if(flag)
		return ..() //It's adjacent, is the user, or is on the user's person
	if(!istype(A))
		return FALSE
	// If firing full-auto, the firing starts when the mouse is clicked, not when it's released
	// so the gun should already be shooting
	if(fa_firing)
		fa_firing = FALSE
		return TRUE
	if(flags_gun_features & GUN_BURST_FIRING)
		return FALSE
	if(!user || !user.client || !user.client.prefs)
		return FALSE
	else if(user.client.prefs.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY && user.a_intent == INTENT_HELP)
		if (world.time % 3) // Limits how often this message pops up, saw this somewhere else and thought it was clever
			to_chat(user, SPAN_NOTICE("You consider shooting at [A], but do not follow through."))
		return FALSE
	else if(user.gun_mode && !(A in target))
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
	else
		Fire(A,user,params) //Otherwise, fire normally.
	return TRUE

/*
load_into_chamber(), reload_into_chamber(), and clear_jam() do all of the heavy lifting.
If you need to change up how a gun fires, just change these procs for that subtype
and you're good to go.
*/
/obj/item/weapon/gun/proc/load_into_chamber(mob/user)
	//The workhorse of the bullet procs.
	//If we have a round chambered and no active attachable, we're good to go.
	if(in_chamber && !active_attachable)
		return in_chamber //Already set!

	//Let's check on the active attachable. It loads ammo on the go, so it never chambers anything
	if(active_attachable)
		if(active_attachable.current_rounds > 0) //If it's still got ammo and stuff.
			active_attachable.current_rounds--
			return create_bullet(active_attachable.ammo, initial(name))
		else
			to_chat(user, SPAN_WARNING("[active_attachable] is empty!"))
			to_chat(user, SPAN_NOTICE("You disable [active_attachable]."))
			playsound(user, active_attachable.activation_sound, 15, 1)
			active_attachable.activate_attachment(src, null, TRUE)
	else
		return ready_in_chamber()//We're not using the active attachable, we must use the active mag if there is one.


/obj/item/weapon/gun/proc/ready_in_chamber()
	if(current_mag && current_mag.current_rounds > 0)
		in_chamber = create_bullet(ammo, initial(name))
		current_mag.current_rounds-- //Subtract the round from the mag.
		return in_chamber

/obj/item/weapon/gun/proc/create_bullet(var/datum/ammo/chambered, var/bullet_source)
	if(!chambered)
		to_chat(usr, "Something has gone horribly wrong. Ahelp the following: ERROR CODE I2: null ammo while create_bullet()")
		log_debug("ERROR CODE I2: null ammo while create_bullet(). User: <b>[usr]</b>")
		chambered = ammo_list[/datum/ammo/bullet] //Slap on a default bullet if somehow ammo wasn't passed.

	var/weapon_source_mob
	if(isliving(usr))
		var/mob/M = usr
		weapon_source_mob = M
	var/obj/item/projectile/P = new /obj/item/projectile(bullet_source, weapon_source_mob, src)
	P.generate_bullet(chambered, 0, 0)

	return P

//This proc is needed for firearms that chamber rounds after firing.
/obj/item/weapon/gun/proc/reload_into_chamber(mob/user)
	/*
	ATTACHMENT POST PROCESSING
	This should only apply to the masterkey, since it's the only attachment that shoots through Fire()
	instead of its own thing through fire_attachment(). If any other bullet attachments are added, they would fire here.
	*/
	if(!active_attachable) //We don't need to check for the mag if an attachment was used to shoot.
		in_chamber = null //If we didn't fire from attachable, let's set this so the next pass doesn't think it still exists.
		if(current_mag) //If there is no mag, we can't reload.
			ready_in_chamber()

			// This is where the magazine is auto-ejected
			if(current_mag.current_rounds <= 0 && flags_gun_features & GUN_AUTO_EJECTOR)
				if (user.client && user.client.prefs && user.client.prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF)
					update_icon()
				else if (!(flags_gun_features & GUN_BURST_FIRING) || !in_chamber) // Magazine will only unload once burstfire is over
					var/drop_to_ground = TRUE
					if (user.client && user.client.prefs && user.client.prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND)
						drop_to_ground = FALSE
						unwield(user)
						user.swap_hand()
					unload(user, TRUE, drop_to_ground) // We want to quickly autoeject the magazine. This proc does the rest based on magazine type. User can be passed as null.
					playsound(src, empty_sound, 25, 1)
		else // Just fired a chambered bullet with no magazine in the gun
			update_icon()

	return in_chamber //Returns the projectile if it's actually successful.

/obj/item/weapon/gun/proc/delete_bullet(var/obj/item/projectile/projectile_to_fire, var/refund = 0)
	if(active_attachable) //Attachables don't chamber rounds, so we want to delete it right away.
		qdel(projectile_to_fire) //Getting rid of it. Attachables only use ammo after the cycle is over.
		if(refund)
			active_attachable.current_rounds++ //Refund the bullet.
		return 1

/obj/item/weapon/gun/proc/clear_jam(var/obj/item/projectile/projectile_to_fire, mob/user as mob) //Guns jamming, great.
	flags_gun_features &= ~GUN_BURST_FIRING // Also want to turn off bursting, in case that was on. It probably was.
	delete_bullet(projectile_to_fire, 1) //We're going to clear up anything inside if we need to.
	//If it's a regular bullet, we're just going to keep it chambered.
	extra_delay = 2 + (burst_delay + extra_delay)*2 // Some extra delay before firing again.
	to_chat(user, SPAN_WARNING("[src] jammed! You'll need a second to get it fixed!"))

//----------------------------------------------------------
		//									   \\
		// FIRE BULLET AND POINT BLANK/SUICIDE \\
		//									   \\
		//						   			   \\
//----------------------------------------------------------

/obj/item/weapon/gun/proc/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	set waitfor = 0

	if(!able_to_fire(user)) return

	var/turf/curloc = get_turf(user) //In case the target or we are expired.
	var/turf/targloc = get_turf(target)
	if (!targloc || !curloc) return //Something has gone wrong...
	var/atom/original_target = target //This is for burst mode, in case the target changes per scatter chance in between fired bullets.

	/*
	This is where the grenade launcher and flame thrower function as attachments.
	This is also a general check to see if the attachment can fire in the first place.
	*/
	var/check_for_attachment_fire = 0
	if(active_attachable && active_attachable.flags_attach_features & ATTACH_WEAPON) //Attachment activated and is a weapon.
		check_for_attachment_fire = 1
		if( !(active_attachable.flags_attach_features & ATTACH_PROJECTILE) ) //If it's unique projectile, this is where we fire it.
			if(active_attachable.current_rounds <= 0)
				click_empty(user) //If it's empty, let them know.
				to_chat(user, SPAN_WARNING("[active_attachable] is empty!"))
				to_chat(user, SPAN_NOTICE("You disable [active_attachable]."))
				active_attachable.activate_attachment(src, null, TRUE)
			else
				active_attachable.fire_attachment(target,src,user) //Fire it.
				last_fired = world.time
			return
			//If there's more to the attachment, it will be processed farther down, through in_chamber and regular bullet act.

	/*
	This is where burst is established for the proceeding section. Which just means the proc loops around that many times.
	If burst = 1, you must null it if you ever RETURN during the for() cycle. If for whatever reason burst is left on while
	the gun is not firing, it will break a lot of stuff. BREAK is fine, as it will null it.
	*/

	//Number of bullets based on burst. If an active attachable is shooting, bursting is always zero.
	var/bullets_to_fire = 1
	if(!check_for_attachment_fire && (flags_gun_features & GUN_BURST_ON) && burst_amount > 1)
		bullets_to_fire = burst_amount
		flags_gun_features |= GUN_BURST_FIRING

	var/bullets_fired
	for(bullets_fired = 1 to bullets_to_fire)
		if(loc != user)
			break //If you drop it while bursting, for example.

		if (bullets_fired > 1 && !(flags_gun_features & GUN_BURST_FIRING)) // No longer burst firing somehow
			break

		//The gun should return the bullet that it already loaded from the end cycle of the last Fire().
		var/obj/item/projectile/projectile_to_fire = load_into_chamber(user) //Load a bullet in or check for existing one.
		if(QDELETED(projectile_to_fire)) //If there is nothing to fire, click.
			click_empty(user)
			break

		var/recoil_comp = 0 //used by bipod and akimbo firing

		//checking for a gun in other hand to fire akimbo
		if(bullets_fired == 1 && !reflex && !dual_wield)
			if(user)
				var/obj/item/IH = user.get_inactive_hand()
				if(istype(IH, /obj/item/weapon/gun))
					var/obj/item/weapon/gun/OG = IH
					if(!(OG.flags_gun_features & GUN_WIELDED_FIRING_ONLY))
						OG.Fire(target,user,params, 0, TRUE)
						dual_wield = TRUE
						recoil_comp++

		apply_bullet_effects(projectile_to_fire, user, bullets_fired, reflex, dual_wield) //User can be passed as null.

		var/scatter_mod = 0
		var/burst_scatter_mod = 0

		target = original_target ? original_target : targloc
		projectile_to_fire.original = target
		target = simulate_scatter(projectile_to_fire, target, targloc, scatter_mod, user, burst_scatter_mod, bullets_fired)

		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				projectile_to_fire.p_x = text2num(mouse_control["icon-x"])
			if(mouse_control["icon-y"])
				projectile_to_fire.p_y = text2num(mouse_control["icon-y"])

		//Finally, make with the pew pew!
		if(QDELETED(projectile_to_fire) || !isobj(projectile_to_fire))
			to_chat(user, "Your gun is malfunctioning. Ahelp the following: ERROR CODE I1: projectile malfunctioned while firing.")
			log_debug("ERROR CODE I1: projectile malfunctioned while firing. User: <b>[user]</b>")
			flags_gun_features &= ~GUN_BURST_FIRING
			return

		if(get_turf(target) != get_turf(user))
			simulate_recoil(recoil_comp, user, target)

			// Get IFF from our shooter if necessary,
			var/iff_group_to_pass = null
			if(iff_enabled_current)
				iff_group_to_pass = get_user_iff_group(user)

			//This is where the projectile leaves the barrel and deals with projectile code only.
			//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			projectile_to_fire.fire_at(target, user, src, projectile_to_fire?.ammo?.max_range, projectile_to_fire?.ammo?.shell_speed, original_target, FALSE, iff_group_to_pass)
			//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			last_fired = world.time

			if(flags_gun_features & GUN_FULL_AUTO_ON)
				fa_shots++

		else // This happens in very rare circumstances when you're moving a lot while burst firing, so I'm going to toss it up to guns jamming.
			clear_jam(projectile_to_fire,user)
			break

		//>>POST PROCESSING AND CLEANUP BEGIN HERE.<<
		if(target) //If we had a target, let's do a muzzle flash.
			var/angle = round(Get_Angle(user,target))
			muzzle_flash(angle,user)

		if (bullets_fired == bullets_to_fire)
			flags_gun_features &= ~GUN_BURST_FIRING // We are done burstfiring

		//This is where we load the next bullet in the chamber. We check for attachments too, since we don't want to load anything if an attachment is active.
		if(!reload_into_chamber(user)) // It has to return a bullet, otherwise it's empty.
			click_empty(user)
			break //Nothing else to do here, time to cancel out.

		if(bullets_fired < bullets_to_fire) // We still have some bullets to fire.
			extra_delay = fire_delay * 0.5
			sleep(burst_delay)

	flags_gun_features &= ~GUN_BURST_FIRING // We always want to turn off bursting when we're done, mainly for when we break early mid-burstfire.

// We have a "cache" to avoid getting ID card iff every shot,
// The cache is reset upon new magazines or when necessary.
/obj/item/weapon/gun/proc/get_user_iff_group(var/mob/living/user)
	if(!ishuman(user))
		return user.faction_group

	if(isnull(iff_group_cache))
		var/mob/living/carbon/human/H = user
		iff_group_cache = H.get_id_faction_group()

	return iff_group_cache

/obj/item/weapon/gun/proc/reset_iff_group_cache()
	iff_group_cache = null

/obj/item/weapon/gun/attack(mob/living/M, mob/living/user, def_zone)
	if(!(flags_gun_features & GUN_CAN_POINTBLANK)) // If it can't point blank, you can't suicide and such.
		return ..()

	if(M == user && user.zone_selected == "mouth")
		if(!able_to_fire(user))
			return

		var/ffl = " (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>) (<a href='?priv_msg=\ref[user.client]'>PM</a>)"

		var/obj/item/weapon/gun/revolver/current_revolver = src
		if(istype(current_revolver) && current_revolver.russian_roulette)
			M.visible_message(SPAN_WARNING("[user] puts their revolver to their head, ready to pull the trigger."))
		else
			M.visible_message(SPAN_WARNING("[user] sticks their gun in their mouth, ready to pull the trigger."))

		flags_gun_features ^= GUN_CAN_POINTBLANK //If they try to click again, they're going to hit themselves.
		if(!do_after(user, 40, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			M.visible_message(SPAN_NOTICE("[user] decided life was worth living."))
			flags_gun_features ^= GUN_CAN_POINTBLANK //Reset this.
			return

		if(active_attachable && !(active_attachable.flags_attach_features & ATTACH_PROJECTILE))
			active_attachable.activate_attachment(src, null, TRUE)//We're not firing off a nade into our mouth.
		var/obj/item/projectile/projectile_to_fire = load_into_chamber(user)
		if(projectile_to_fire) //We actually have a projectile, let's move on.
			user.visible_message(SPAN_WARNING("[user] pulls the trigger!"))
			var/actual_sound = (active_attachable && active_attachable.fire_sound) ? active_attachable.fire_sound : fire_sound
			var/sound_volume = (flags_gun_features & GUN_SILENCED && !active_attachable) ? 25 : 60
			playsound(user, actual_sound, sound_volume, 1)
			simulate_recoil(2, user)
			var/t = "\[[time_stamp()]\] <b>[key_name(user)]</b> committed suicide with <b>[src]</b>" //Log it.
			if(istype(current_revolver) && current_revolver.russian_roulette) //If it's a revolver set to Russian Roulette.
				t += " after playing Russian Roulette"
				user.apply_damage(projectile_to_fire.damage * 3, projectile_to_fire.ammo.damage_type, "head", used_weapon = "An unlucky pull of the trigger during Russian Roulette!", sharp = 1)
				user.apply_damage(200, OXY) //In case someone tried to defib them. Won't work.
				user.death("russian roulette with \a [name]")
				msg_admin_ff("[key_name(user)] lost at Russian Roulette with \a [name] in [get_area(user)] [ffl]")
				to_chat(user, SPAN_HIGHDANGER("Your life flashes before you as your spirit is torn from your body!"))
				user.ghostize(0) //No return.
			else
				if(projectile_to_fire.ammo.damage_type == HALLOSS)
					to_chat(user, SPAN_NOTICE("Ow..."))
					user.apply_effect(110, AGONY, 0)
				else
					user.apply_damage(projectile_to_fire.damage * 2.5, projectile_to_fire.ammo.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [projectile_to_fire]", sharp = 1)
					user.apply_damage(100, OXY)
					if(ishuman(user) && user == M)
						var/mob/living/carbon/human/HM = user
						HM.undefibbable = TRUE //can't be defibbed back from self inflicted gunshot to head
					user.death("suicide by [initial(name)]")
					msg_admin_ff("[key_name(user)] committed suicide with \a [name] in [get_area(user)] [ffl]")
			M.last_damage_source = initial(name)
			M.last_damage_mob = null
			user.attack_log += t //Apply the attack log.
			last_fired = world.time

			projectile_to_fire.play_damage_effect(user)
			if(!delete_bullet(projectile_to_fire))
				qdel(projectile_to_fire) //If this proc DIDN'T delete the bullet, we're going to do so here.

			reload_into_chamber(user) //Reload the sucker.
		else
			click_empty(user)//If there's no projectile, we can't do much.
			if(istype(current_revolver) && current_revolver.russian_roulette && current_revolver.current_mag && current_revolver.current_mag.current_rounds)
				msg_admin_niche("[key_name(user)] played live Russian Roulette with \a [name] in [get_area(user)] [ffl]") //someone might want to know anyway...

		flags_gun_features ^= GUN_CAN_POINTBLANK //Reset this.
		return
	else if(user.a_intent != INTENT_HARM) //Thwack them
		return ..()

	if(M.stat == UNCONSCIOUS && ((user.a_intent == INTENT_GRAB)||(user.a_intent == INTENT_DISARM))) //Execution
		user.visible_message(SPAN_DANGER("[user] puts [src] up to [M], steadying their aim."), SPAN_WARNING("You put [src] up to [M], steadying your aim."),null, null, CHAT_TYPE_COMBAT_ACTION)
		if(!do_after(user, SECONDS_3, INTERRUPT_ALL|INTERRUPT_DIFF_INTENT, BUSY_ICON_HOSTILE))
			return FALSE

	//Point blanking doesn't actually fire the projectile. Instead, it simulates firing the bullet proper.
	flags_gun_features &= ~GUN_BURST_FIRING
	if(!able_to_fire(user)) //If you can't fire the gun in the first place, we're just going to hit them with it.
		return ..()

	if(active_attachable && !(active_attachable.flags_attach_features & ATTACH_PROJECTILE))
		active_attachable.activate_attachment(src, null, TRUE)//No way.
	var/obj/item/projectile/projectile_to_fire = load_into_chamber(user)

	if(QDELETED(projectile_to_fire))
		return ..()

	//We actually have a projectile, let's move on. We're going to simulate the fire cycle.
	if(projectile_to_fire.ammo.on_pointblank(M, projectile_to_fire, user)==-1)
		return FALSE
	var/damage_buff = BASE_BULLET_DAMAGE_MULT
	//if target is lying or unconscious - add damage bonus
	if(M.lying == 1 || M.stat == UNCONSCIOUS)
		damage_buff += BULLET_DAMAGE_MULT_TIER_4
	damage_buff *= damage_mult
	projectile_to_fire.damage *= damage_buff //Multiply the damage for point blank.
	user.visible_message(SPAN_DANGER("[user] fires [src] point blank at [M]!"), null, null, null, CHAT_TYPE_WEAPON_USE)
	user.track_shot(initial(name))
	apply_bullet_effects(projectile_to_fire, user) //We add any damage effects that we need.
	simulate_recoil(1, user)

	if(projectile_to_fire.ammo.bonus_projectiles_amount)
		var/obj/item/projectile/BP
		for(var/i in 0 to projectile_to_fire.ammo.bonus_projectiles_amount)
			BP = new /obj/item/projectile(initial(name), user, M.loc)
			BP.generate_bullet(ammo_list[projectile_to_fire.ammo.bonus_projectiles_type], 0)
			BP.damage *= damage_buff
			BP.ammo.on_hit_mob(M, BP)
			M.bullet_act(BP)
			qdel(BP)

	projectile_to_fire.ammo.on_hit_mob(M, projectile_to_fire)
	M.bullet_act(projectile_to_fire)

	last_fired = world.time

	if(M.stat == UNCONSCIOUS && ((user.a_intent == INTENT_GRAB)||(user.a_intent == INTENT_DISARM))) //Continue execution if on the correct intent. Accounts for change via the earlier do_after
		M.death()

	if(!delete_bullet(projectile_to_fire))
		qdel(projectile_to_fire)
	
	reload_into_chamber(user) //Reload into the chamber if the gun supports it.
	return TRUE

//----------------------------------------------------------
				//							\\
				// FIRE CYCLE RELATED PROCS \\
				//							\\
				//						   	\\
//----------------------------------------------------------

/obj/item/weapon/gun/proc/able_to_fire(mob/user)
	/*
	Removed ishuman() check. There is no reason for it, as it just eats up more processing, and adding fingerprints during the fire cycle is silly.
	Consequently, predators are able to fire while cloaked.
	*/
	if(flags_gun_features & GUN_BURST_FIRING) return
	if(world.time < guaranteed_delay_time) return
	if((world.time < wield_time || world.time < pull_time) && (delay_style & WEAPON_DELAY_NO_FIRE > 0 || user.dazed)) return //We just put the gun up. Can't do it that fast
	if(ismob(user)) //Could be an object firing the gun.
		if(!user.IsAdvancedToolUser())
			to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
			return

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(!H.allow_gun_usage)
				if(isSynth(user))
					to_chat(user, SPAN_WARNING("Your programming does not allow you to use firearms."))
				else
					to_chat(user, SPAN_WARNING("You are unable to use firearms."))
				return

		if(flags_gun_features & GUN_TRIGGER_SAFETY)
			to_chat(user, SPAN_WARNING("The safety is on!"))
			return

		if((flags_gun_features & GUN_WIELDED_FIRING_ONLY) && !(flags_item & WIELDED)) //If we're not holding the weapon with both hands when we should.
			to_chat(user, SPAN_WARNING("You need a more secure grip to fire this weapon!"))
			return

		if( (flags_gun_features & GUN_WY_RESTRICTED) && !wy_allowed_check(user) )
			return

		//Has to be on the bottom of the stack to prevent delay when failing to fire the weapon for the first time.
		//Can also set last_fired through New(), but honestly there's not much point to it.

		// The rest is delay-related. If we're firing full-auto it doesn't matter
		if(fa_firing)
			return TRUE

		var/added_delay = fire_delay
		if(active_attachable)
			if(active_attachable.attachment_firing_delay)
				added_delay = active_attachable.attachment_firing_delay
		else
			if(user && user.skills)
				if(user.skills.get_skill_level(SKILL_FIREARMS) == 0) //no training in any firearms
					added_delay += FIRE_DELAY_TIER_8 //untrained humans fire more slowly.
		if(world.time >= last_fired + added_delay + extra_delay) //check the last time it was fired.
			extra_delay = 0
		else
			return
	return 1

/obj/item/weapon/gun/proc/click_empty(mob/user)
	if(user)
		to_chat(user, SPAN_WARNING("<b>*click*</b>"))
		playsound(user, 'sound/weapons/gun_empty.ogg', 25, 1, 5) //5 tile range
	else
		playsound(src, 'sound/weapons/gun_empty.ogg', 25, 1, 5)

//This proc applies some bonus effects to the shot/makes the message when a bullet is actually fired.
/obj/item/weapon/gun/proc/apply_bullet_effects(obj/item/projectile/projectile_to_fire, mob/user, bullets_fired = 1, reflex = 0, dual_wield = 0)
	var/actual_sound = fire_sound
	if(projectile_to_fire.ammo && projectile_to_fire.ammo.sound_override)
		actual_sound = projectile_to_fire.ammo.sound_override

	var/gun_accuracy_mult = accuracy_mult_unwielded
	var/gun_scatter = scatter_unwielded

	if(flags_item & WIELDED || flags_gun_features & GUN_ONE_HAND_WIELDED)
		gun_accuracy_mult = accuracy_mult
		gun_scatter = scatter
	else if(user && world.time - user.l_move_time < 5) //moved during the last half second
		//accuracy and scatter penalty if the user fires unwielded right after moving
		gun_accuracy_mult = max(0.1, gun_accuracy_mult - max(0,movement_acc_penalty_mult * HIT_ACCURACY_MULT_TIER_3))
		gun_scatter += max(0, movement_acc_penalty_mult * SCATTER_AMOUNT_TIER_10)

	if(dual_wield) //akimbo firing gives terrible accuracy
		gun_accuracy_mult = max(0.1, gun_accuracy_mult - 0.1*rand(3,5))
		gun_scatter += SCATTER_AMOUNT_TIER_4

	// Apply any skill-based bonuses to accuracy
	if(user && user.mind && user.skills)
		var/skill_accuracy = 0
		if(user.skills.get_skill_level(SKILL_FIREARMS) == 0) //no training in any firearms
			skill_accuracy = -1
		else
			skill_accuracy = user.skills.get_skill_level(SKILL_FIREARMS)
		if(skill_accuracy)
			gun_accuracy_mult += skill_accuracy * HIT_ACCURACY_MULT_TIER_3 // Accuracy mult increase/decrease per level is equal to attaching/removing a red dot sight

	projectile_to_fire.accuracy = round(projectile_to_fire.accuracy * gun_accuracy_mult) // Apply gun accuracy multiplier to projectile accuracy
	projectile_to_fire.scatter += gun_scatter

	if(wield_delay > 0 && (world.time < wield_time || world.time < pull_time))
		var/old_time = max(wield_time, pull_time) - wield_delay
		var/new_time = world.time
		var/pct_settled = 1 - (new_time-old_time + 1)/wield_delay
		if(delay_style & WEAPON_DELAY_ACCURACY)
			var/accuracy_debuff = 1 + (SETTLE_ACCURACY_MULTIPLIER - 1) * pct_settled
			projectile_to_fire.accuracy /=accuracy_debuff
		if(delay_style & WEAPON_DELAY_SCATTER)
			var/scatter_debuff = 1 + (SETTLE_SCATTER_MULTIPLIER - 1) * pct_settled
			projectile_to_fire.scatter *= scatter_debuff

	projectile_to_fire.damage = round(projectile_to_fire.damage * damage_mult) 		// Apply gun damage multiplier to projectile damage

	// Apply effective range and falloffs/buildups
	projectile_to_fire.damage_falloff = damage_falloff_mult * projectile_to_fire.ammo.damage_falloff
	projectile_to_fire.damage_buildup = damage_buildup_mult * projectile_to_fire.ammo.damage_buildup

	projectile_to_fire.effective_range_min = effective_range_min + projectile_to_fire.ammo.effective_range_min //Add on ammo-level value, if specified.
	projectile_to_fire.effective_range_max = effective_range_max + projectile_to_fire.ammo.effective_range_max //Add on ammo-level value, if specified.

	projectile_to_fire.shot_from = src

	if(user) //The gun only messages when fired by a user.
		projectile_to_fire.firer = user
		if(isliving(user)) projectile_to_fire.def_zone = user.zone_selected
		//Guns with low ammo have their firing sound
		var/firing_sndfreq = (current_mag && (current_mag.current_rounds / current_mag.max_rounds) > GUN_LOW_AMMO_PERCENTAGE) ? FALSE : SOUND_FREQ_HIGH
		//firing from an attachment
		if(active_attachable && active_attachable.flags_attach_features & ATTACH_PROJECTILE)
			if(active_attachable.fire_sound) //If we're firing from an attachment, use that noise instead.
				playsound(user, active_attachable.fire_sound, 50)
		else
			if(current_mag && flags_gun_features & GUN_AMMO_COUNTER && bullets_fired == 1)
				to_chat(user, SPAN_DANGER("[current_mag.current_rounds] / [current_mag.max_rounds] ROUNDS REMAINING"))
			if(!(flags_gun_features & GUN_SILENCED))
				if (firing_sndfreq && fire_rattle)
					playsound(user, fire_rattle, 60, FALSE)//if the gun has a unique 'mag rattle' SFX play that instead of pitch shifting.
				else
					playsound(user, actual_sound, 60, firing_sndfreq)
			else 
				playsound(user, actual_sound, 25, firing_sndfreq)

	return 1

/obj/item/weapon/gun/proc/simulate_scatter(obj/item/projectile/projectile_to_fire, atom/target, turf/targloc, total_scatter_angle = 0, mob/user, burst_scatter_mod = 0, bullets_fired = 1)

	var/turf/curloc = get_turf(src)
	var/initial_angle = Get_Angle(curloc, targloc)
	var/final_angle = initial_angle

	total_scatter_angle += projectile_to_fire.scatter

	if(flags_gun_features & GUN_BURST_ON && bullets_fired > 1)//Much higher scatter on burst. Each additional bullet adds scatter
		var/bullet_amt_scat = min(bullets_fired-1, SCATTER_AMOUNT_TIER_6)//capped so we don't penalize large bursts too much.
		if(flags_item & WIELDED)
			total_scatter_angle += max(0, bullet_amt_scat * (burst_scatter_mult + burst_scatter_mod))
		else
			total_scatter_angle += max(0, 2 * bullet_amt_scat * (burst_scatter_mult + burst_scatter_mod))

	// Full auto fucks your scatter up big time
	// Note that full auto uses burst scatter multipliers
	if(flags_gun_features & GUN_FULL_AUTO_ON)
		// The longer you fire full-auto, the worse the scatter gets
		var/bullet_amt_scat = min((fa_shots/fa_scatter_peak) * fa_max_scatter, fa_max_scatter)
		if(flags_item & WIELDED)
			total_scatter_angle += max(0, bullet_amt_scat * (burst_scatter_mult + burst_scatter_mod))
		else
			total_scatter_angle += max(0, 2 * bullet_amt_scat * (burst_scatter_mult + burst_scatter_mod))

	if(user && user.mind && user.skills)
		if(user.skills.get_skill_level(SKILL_FIREARMS) == 0) //no training in any firearms
			total_scatter_angle += SCATTER_AMOUNT_TIER_8
		else
			total_scatter_angle -= user.skills.get_skill_level(SKILL_FIREARMS)*SCATTER_AMOUNT_TIER_8


	//Not if the gun doesn't scatter at all, or negative scatter.
	if(total_scatter_angle > 0)
		final_angle += rand(-total_scatter_angle, total_scatter_angle)
		target = get_angle_target_turf(curloc, final_angle, 30)

	return target

/obj/item/weapon/gun/proc/update_recoil_buildup()
	var/seconds_since_fired = max(world.timeofday - last_recoil_update, 0) * 0.1

	seconds_since_fired = max(seconds_since_fired - (fire_delay * 0.3), 0) // Takes into account firerate, so that recoil cannot fall whilst firing.
	// You have to be shooting at a third of the firerate of a gun to not build up any recoil if the recoil_loss_per_second is greater than the recoil_gain_per_second
	
	recoil_buildup = max(recoil_buildup - recoil_loss_per_second*seconds_since_fired, 0)

	last_recoil_update = world.timeofday

/obj/item/weapon/gun/proc/simulate_recoil(recoil_bonus = 0, mob/user, atom/target)
	var/total_recoil = recoil_bonus

	if(flags_gun_features & GUN_RECOIL_BUILDUP)
		update_recoil_buildup()

		recoil_buildup = min(recoil + recoil_buildup, recoil_buildup_limit)
		total_recoil += (recoil_buildup*RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER)

	if(flags_item & WIELDED)
		if(!(flags_gun_features & GUN_RECOIL_BUILDUP)) // We're nesting this if loop, because we don't want the "else" to run if we are wielding
			total_recoil += recoil
	else
		total_recoil += recoil_unwielded
		if(flags_gun_features & GUN_BURST_FIRING)
			total_recoil += 1

	if(user && user.mind && user.skills)
		if(user.skills.get_skill_level(SKILL_FIREARMS) == 0) //no training in any firearms
			total_recoil += RECOIL_AMOUNT_TIER_5
		else
			total_recoil -= user.skills.get_skill_level(SKILL_FIREARMS)*RECOIL_AMOUNT_TIER_5
				
	if(total_recoil > 0 && ishuman(user))
		shake_camera(user, total_recoil + 1, total_recoil)
		return TRUE

	return FALSE

/obj/item/weapon/gun/proc/muzzle_flash(angle,mob/user)
	if(!muzzle_flash || flags_gun_features & GUN_SILENCED || isnull(angle))
		return //We have to check for null angle here, as 0 can also be an angle.
	if(!istype(user) || !istype(user.loc,/turf))
		return

	if(user.luminosity <= muzzle_flash_lum)
		user.SetLuminosity(muzzle_flash_lum)
		addtimer(CALLBACK(user, /atom/proc/SetLuminosity, -muzzle_flash_lum), 10)

	var/image_layer = (user && user.dir == SOUTH) ? MOB_LAYER+0.1 : MOB_LAYER-0.1
	var/offset = 5

	var/image/I = image('icons/obj/items/weapons/projectiles.dmi',user,muzzle_flash,image_layer)
	var/matrix/rotate = matrix() //Change the flash angle.
	rotate.Translate(0, offset)
	rotate.Turn(angle)
	I.transform = rotate
	I.flick_overlay(user, 3)
