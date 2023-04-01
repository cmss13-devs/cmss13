#define CODEX_ARMOR_MAX 50
#define CODEX_ARMOR_STEP 5

/obj/item/weapon/gun
	name = "gun"
	desc = "It's a gun. It's pretty terrible, though."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = ""
	item_state = "gun"
	pickup_sound = "gunequip"
	drop_sound = "gunrustle"
	pickupvol = 7
	dropvol = 15
	matter = null
						//Guns generally have their own unique levels.
	w_class = SIZE_MEDIUM
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	force = 5
	attack_verb = null
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi'
		)
	flags_atom = FPRINT|CONDUCT
	flags_item = TWOHANDED

	var/accepted_ammo = list()
	///Determines what kind of bullet is created when the gun is unloaded - used to match rounds to magazines. Set automatically when reloading.
	var/caliber
	var/muzzle_flash = "muzzle_flash"
	///muzzle flash brightness
	var/muzzle_flash_lum = 3

	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	/// If fire_sound is null, it will pick a sound from the list here instead.
	var/list/fire_sounds = list('sound/weapons/Gunshot.ogg', 'sound/weapons/gun_uzi.ogg')
	var/firesound_volume = 60 //Volume of gunshot, adjust depending on volume of shot
	///Does our gun have a unique empty mag sound? If so use instead of pitch shifting.
	var/fire_rattle = null
	var/unload_sound = 'sound/weapons/flipblade.ogg'
	var/empty_sound = 'sound/weapons/smg_empty_alarm.ogg'
	//We don't want these for guns that don't have them.
	var/reload_sound = null
	var/cocked_sound = null
	///world.time value, to prevent COCK COCK COCK COCK
	var/cock_cooldown = 0
	///Delay before we can cock again, in tenths of seconds
	var/cock_delay = 30

	/**How the bullet will behave once it leaves the gun, also used for basic bullet damage and effects, etc.
	Ammo will be replaced on New() for things that do not use mags.**/
	var/datum/ammo/ammo = null
	///What is currently in the chamber. Most guns will want something in the chamber upon creation.
	var/obj/item/projectile/in_chamber = null
	/*Ammo mags may or may not be internal, though the difference is a few additional variables. If they are not internal, don't call
	on those unique vars. This is done for quicker pathing. Just keep in mind most mags aren't internal, though some are.
	This is also the default magazine path loaded into a projectile weapon for reverse lookups on New(). Leave this null to do your own thing.*/
	var/obj/item/ammo_magazine/internal/current_mag = null

	//Basic stats.
	///Multiplier. Increased and decreased through attachments. Multiplies the projectile's accuracy by this number.
	var/accuracy_mult = 0
	///Multiplier. Increased and decreased through attachments. Multiplies the projectile's damage by this number.
	var/damage_mult = 1
	///Multiplier. Increased and decreased through attachments. Multiplies the projectile's damage bleed (falloff) by this number.
	var/damage_falloff_mult = 1
	///Multiplier. Increased and decreased through attachments. Multiplies the projectile's damage bleed (buildup) by this number.
	var/damage_buildup_mult = 1
	///Screen shake when the weapon is fired.
	var/recoil = 0
	///How much the bullet scatters when fired.
	var/scatter = 0
	/// Added velocity to fired bullet.
	var/velocity_add = 0
	///Multiplier. Increases or decreases how much bonus scatter is added with each bullet during burst fire (wielded only).
	var/burst_scatter_mult = 4

	///What minimum range the weapon deals full damage, builds up the closer you get. 0 for no minimum.
	var/effective_range_min = 0
	///What maximum range the weapon deals full damage, tapers off using damage_falloff after hitting this value. 0 for no maximum.
	var/effective_range_max = 0

	///Multiplier. Increased and decreased through attachments. Multiplies the projectile's accuracy when unwielded by this number.
	var/accuracy_mult_unwielded = 1
	///Multiplier. Increased and decreased through attachments. Multiplies the gun's recoil when unwielded by this number.
	var/recoil_unwielded = 0
	///Multiplier. Increased and decreased through attachments. Multiplies the projectile's scatter when the gun is unwielded by this number.
	var/scatter_unwielded = 0

	///Multiplier. Increased and decreased through attachments. Multiplies the accuracy/scatter penalty of the projectile when firing onehanded while moving.
	var/movement_onehanded_acc_penalty_mult = 5 //Multiplier. Increased and decreased through attachments. Multiplies the accuracy/scatter penalty of the projectile when firing onehanded while moving.

	///For regular shots, how long to wait before firing again.
	var/fire_delay = 0
	///When it was last fired, related to world.time.
	var/last_fired = 0

	///Self explanatory. How much does aiming (wielding the gun) slow you
	var/aim_slowdown = 0
	///How long between wielding and firing in tenths of seconds
	var/wield_delay = WIELD_DELAY_FAST
	///Storing value for wield delay.
	var/wield_time = 0
	///Storing value for guaranteed delay
	var/guaranteed_delay_time = 0
	///Storing value for how long pulling a gun takes before you can use it
	var/pull_time = 0

	///Determines what happens when you fire a gun before its wield or pull time has finished. This one is extra scatter and an acc. malus.
	var/delay_style = WEAPON_DELAY_SCATTER_AND_ACCURACY

	//Burst fire.
	///How many shots can the weapon shoot in burst? Anything less than 2 and you cannot toggle burst.
	var/burst_amount = 1
	///The delay in between shots. Lower = less delay = faster.
	var/burst_delay = 1
	///When burst-firing, this number is extra time before the weapon can fire again. Depends on number of rounds fired.
	var/extra_delay = 0
	///When PB burst firing and handing off to /fire after a target moves out of range, this is how many bullets have been fired.
	var/PB_burst_bullets_fired = 0

	// Full auto
	///Whether or not the gun is firing full-auto
	var/fa_firing = FALSE
	///How many shots have been fired using full-auto. Used to figure out scatter
	var/fa_shots = 0
	///How many full-auto shots to get to max scatter?
	var/fa_scatter_peak = 8
	///How bad does the scatter get on full auto?
	var/fa_max_scatter = 5
	///The delay when firing full-auto
	var/fa_delay = 2.5
	///The atom we're shooting at while full-autoing
	var/atom/fa_target = null
	///Click parameters to use when firing full-auto
	var/fa_params = null

	//Targeting.
	///List of who yer targeting.
	var/tmp/list/mob/living/target
	///Used to fire faster at more than one person.
	var/tmp/mob/living/last_moved_mob
	var/tmp/lock_time = -100
	///Used to determine if you can target multiple people.
	var/automatic = 0
	///So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/told_cant_shoot = 0

	//Attachments.
	///List of all current attachments on the gun.
	var/list/attachments = list()
	///List of overlays so we can switch them in an out, instead of using Cut() on overlays.
	var/attachable_overlays[] = null
	///Is a list, see examples of from the other files. Initiated on New() because lists don't initial() properly.
	var/attachable_offset[] = null
	///Must be the exact path to the attachment present in the list. Empty list for a default.
	var/list/attachable_allowed = list()
	///Chance for random attachments to spawn in general.
	var/random_spawn_chance = 50
	///Chance for random spawn to give this gun a rail attachment.
	var/random_rail_chance = 100
	//Used when a gun will have a chance to spawn with attachments.
	var/list/random_spawn_rail = list()
	///Chance for random spawn to give this gun a muzzle attachment.
	var/random_muzzle_chance = 100
	///Used when a gun will have a chance to spawn with attachments.
	var/list/random_spawn_muzzle = list()
	///Chance for random spawn to give this gun a underbarrel attachment.
	var/random_under_chance = 100
	///Used when a gun will have a chance to spawn with attachments.
	var/list/random_spawn_under = list()
	///Chance for random spawn to give this gun a stock attachment.
	var/random_stock_chance = 100
	///Used when a gun will have a chance to spawn with attachments.
	var/list/random_spawn_stock = list()
	///This will link to one of the attachments, or remain null.
	var/obj/item/attachable/attached_gun/active_attachable = null
	///What attachments this gun starts with THAT CAN BE REMOVED. Important to avoid nuking the attachments on restocking! Added on New()
	var/list/starting_attachment_types = null

	var/flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK
	///Only guns of the same category can be fired together while dualwielding.
	var/gun_category

	///the default gun icon_state. change to reskin the gun
	var/base_gun_icon
	/// whether gun has icon state of (base_gun_icon)_e
	var/has_empty_icon = TRUE
	/// whether gun has icon state of (base_gun_icon)_o
	var/has_open_icon = FALSE
	var/bonus_overlay_x = 0
	var/bonus_overlay_y = 0

	/// How much recoil_buildup is lost per second. Builds up as time passes, and is set to 0 when a single shot is fired
	var/recoil_loss_per_second = 10
	/// The recoil on a dynamic recoil gun
	var/recoil_buildup = 0

	///The limit at which the recoil on a gun can reach. Usually the maximum value
	var/recoil_buildup_limit = 0

	var/last_recoil_update = 0

	var/auto_retrieval_slot

	/** An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	that will be given to a projectile with the current ammo datum**/
	var/list/list/traits_to_give

	/**
	* The group or groups of the gun where a fire delay is applied and the delays applied to each group when the gun is dropped
	* after being fired
	*
	* Guns with this var set will apply the gun's remaining fire delay to any other guns in the same group
	*
	* Set as null (does not apply any fire delays to any other gun group) or a list of fire delay groups (string defines)
	* matched with the corresponding fire delays applied
	*/
	var/list/fire_delay_group
	var/additional_fire_group_delay = 0 // adds onto the fire delay of the above

	// Set to TRUE or FALSE, it overrides the is_civilian_usable check with its value. Does nothing if null.
	var/civilian_usable_override = null

/**
 * An assoc list where the keys are fire delay group string defines
 * and the keys are when the guns of the group can be fired again
 */
/mob/var/list/fire_delay_next_fire


//----------------------------------------------------------
				// \\
				// NECESSARY PROCS  \\
				// \\
				// \\
//----------------------------------------------------------

/obj/item/weapon/gun/Initialize(mapload, spawn_empty) //You can pass on spawn_empty to make the sure the gun has no bullets or mag or anything when created.
	. = ..() //This only affects guns you can get from vendors for now. Special guns spawn with their own things regardless.
	base_gun_icon = icon_state
	attachable_overlays = list("muzzle" = null, "rail" = null, "under" = null, "stock" = null, "mag" = null, "special" = null)

	LAZYSET(item_state_slots, WEAR_BACK, item_state)
	LAZYSET(item_state_slots, WEAR_JACKET, item_state)

	if(current_mag)
		if(spawn_empty && !(flags_gun_features & GUN_INTERNAL_MAG)) //Internal mags will still spawn, but they won't be filled.
			current_mag = null
			update_icon()
		else
			current_mag = new current_mag(src, spawn_empty? 1:0)
			replace_ammo(null, current_mag)
	else ammo = GLOB.ammo_list[ammo] //If they don't have a mag, they fire off their own thing.

	set_gun_attachment_offsets()
	set_gun_config_values()
	set_bullet_traits()
	update_force_list() //This gives the gun some unique attack verbs for attacking.
	handle_starting_attachment()
	handle_random_attachments()
	GLOB.gun_list += src
	if(auto_retrieval_slot)
		AddElement(/datum/element/drop_retrieval/gun, auto_retrieval_slot)
	update_icon() //for things like magazine overlays

/obj/item/weapon/gun/proc/set_gun_attachment_offsets()
	attachable_offset = null

/obj/item/weapon/gun/Destroy()
	in_chamber = null
	ammo = null
	current_mag = null
	target = null
	last_moved_mob = null
	if(flags_gun_features & GUN_FLASHLIGHT_ON)//Handle flashlight.
		flags_gun_features &= ~GUN_FLASHLIGHT_ON
		if(ismob(loc))
			for(var/slot in attachments)
				var/obj/item/attachable/potential_attachment = attachments[slot]
				if(!potential_attachment)
					continue
				loc.SetLuminosity(0, FALSE, src)
		else
			SetLuminosity(0)
	attachments = null
	attachable_overlays = null
	QDEL_NULL(active_attachable)
	fa_target = null
	GLOB.gun_list -= src
	. = ..()

/*
* Called by the gun's New(), set the gun variables' values.
* Each gun gets its own version of the proc instead of adding/substracting
* amounts to get specific values in each gun subtype's New().
* This makes reading each gun's values MUCH easier.
*/
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
	movement_onehanded_acc_penalty_mult = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_1

	effective_range_min = EFFECTIVE_RANGE_OFF
	effective_range_max = EFFECTIVE_RANGE_OFF

	recoil_buildup_limit = RECOIL_AMOUNT_TIER_1 / RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER

	//reset initial define-values
	aim_slowdown = initial(aim_slowdown)
	wield_delay = initial(wield_delay)

/// Populate traits_to_give in this proc
/obj/item/weapon/gun/proc/set_bullet_traits()
	return

/// @bullet_trait_entries: A list of bullet trait entries
/obj/item/weapon/gun/proc/add_bullet_traits(list/list/bullet_trait_entries)
	LAZYADD(traits_to_give, bullet_trait_entries)
	for(var/entry in bullet_trait_entries)
		if(!in_chamber)
			break
		var/list/L
		// Check if this is an ID'd bullet trait
		if(istext(entry))
			L = bullet_trait_entries[entry].Copy()
		else
			// Prepend the bullet trait to the list
			L = list(entry) + bullet_trait_entries[entry]
		// Apply bullet traits from gun to current projectile
		in_chamber.apply_bullet_trait(L)

/// @bullet_traits: A list of bullet trait typepaths or ids
/obj/item/weapon/gun/proc/remove_bullet_traits(list/bullet_traits)
	for(var/entry in bullet_traits)
		if(!LAZYISIN(traits_to_give, entry))
			continue
		var/list/L
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			L = list(entry) + traits_to_give[entry]
		LAZYREMOVE(traits_to_give, entry)
		if(in_chamber)
			// Remove bullet traits of gun from current projectile
			// Need to use the proc instead of the wrapper because each entry is a list
			in_chamber._RemoveElement(L)

/obj/item/weapon/gun/proc/recalculate_attachment_bonuses()
	//reset weight and force mods
	force = initial(force)
	w_class = initial(w_class)

	//reset HUD and pixel offsets
	hud_offset = initial(hud_offset)
	pixel_x = initial(hud_offset)

	//reset traits from attachments
	for(var/slot in attachments)
		REMOVE_TRAITS_IN(src, TRAIT_SOURCE_ATTACHMENT(slot))

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
		velocity_add += R.velocity_mod
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
		movement_onehanded_acc_penalty_mult += R.movement_onehanded_acc_penalty_mod
		force += R.melee_mod
		w_class += R.size_mod
		if(!R.hidden)
			hud_offset += R.hud_offset_mod
			pixel_x += R.hud_offset_mod

		for(var/trait in R.gun_traits)
			ADD_TRAIT(src, trait, TRAIT_SOURCE_ATTACHMENT(slot))

	//Refresh location in HUD.
	if(ishuman(loc))
		var/mob/living/carbon/human/M = loc
		if(M.l_hand == src)
			M.update_inv_l_hand()
		else if(M.r_hand == src)
			M.update_inv_r_hand()

/obj/item/weapon/gun/proc/handle_random_attachments()
	var/attachmentchoice

	var/randchance = random_spawn_chance
	if(!prob(randchance))
		return

	var/railchance = random_rail_chance
	if(prob(railchance) && !attachments["rail"]) // Rail
		attachmentchoice = SAFEPICK(random_spawn_rail)
		if(attachmentchoice)
			var/obj/item/attachable/R = new attachmentchoice(src)
			R.Attach(src)
			update_attachable(R.slot)
			attachmentchoice = FALSE

	var/muzzlechance = random_muzzle_chance
	if(prob(muzzlechance) && !attachments["muzzle"]) // Muzzle
		attachmentchoice = SAFEPICK(random_spawn_muzzle)
		if(attachmentchoice)
			var/obj/item/attachable/M = new attachmentchoice(src)
			M.Attach(src)
			update_attachable(M.slot)
			attachmentchoice = FALSE

	var/underchance = random_under_chance
	if(prob(underchance) && !attachments["under"]) // Underbarrel
		attachmentchoice = SAFEPICK(random_spawn_under)
		if(attachmentchoice)
			var/obj/item/attachable/U = new attachmentchoice(src)
			U.Attach(src)
			update_attachable(U.slot)
			attachmentchoice = FALSE

	var/stockchance = random_stock_chance
	if(prob(stockchance) && !attachments["stock"]) // Stock
		attachmentchoice = SAFEPICK(random_spawn_stock)
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



/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/weapon/gun/equipped(mob/user, slot)
	if(flags_item & NODROP) return
	if(slot != WEAR_L_HAND && slot != WEAR_R_HAND)
		stop_aim()
		if (user.client)
			user.update_gun_icons()

	unwield(user)
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

/obj/item/weapon/gun/get_examine_text(mob/user)
	. = ..()
	if(flags_gun_features & GUN_NO_DESCRIPTION)
		return .
	var/dat = ""
	if(flags_gun_features & GUN_TRIGGER_SAFETY)
		dat += "The safety's on!<br>"
	else
		dat += "The safety's off!<br>"

	for(var/slot in attachments)
		var/obj/item/attachable/R = attachments[slot]
		if(!R) continue
		dat += R.handle_attachment_description()

	if(!(flags_gun_features & (GUN_INTERNAL_MAG|GUN_UNUSUAL_DESIGN))) //Internal mags and unusual guns have their own stuff set.
		if(current_mag && current_mag.current_rounds > 0)
			if(flags_gun_features & GUN_AMMO_COUNTER) dat += "Ammo counter shows [current_mag.current_rounds] round\s remaining.<br>"
			else dat += "It's loaded[in_chamber?" and has a round chambered":""].<br>"
		else dat += "It's unloaded[in_chamber?" but has a round chambered":""].<br>"
	if(!(flags_gun_features & GUN_UNUSUAL_DESIGN))
		dat += "<a href='?src=\ref[src];list_stats=1'>\[See combat statistics]</a>"

	if(dat)
		. += dat

/obj/item/weapon/gun/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!ishuman(usr) && !isobserver(usr))
		return

	if(href_list["list_stats"]&& !(flags_gun_features & GUN_UNUSUAL_DESIGN))
		tgui_interact(usr)

// TGUI GOES HERE \\

/obj/item/weapon/gun/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "WeaponStats", name)
		ui.open()

/obj/item/weapon/gun/ui_state(mob/user)
	return GLOB.always_state // can't interact why should I care

/obj/item/weapon/gun/ui_data(mob/user)
	var/list/data = list()

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
			in_ammo = GLOB.ammo_list[current_mag.chamber_contents[current_mag.chamber_position]]
			if(!istype(in_ammo))
				in_ammo = GLOB.ammo_list[current_mag.default_ammo]
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
			damage_armor_profile_marine.Add(round(armor_damage_reduction(GLOB.marine_ranged_stats, damage, i, penetration)))
			damage_armor_profile_xeno.Add(round(armor_damage_reduction(GLOB.xeno_ranged_stats, damage, i, penetration)))
			if(!GLOB.xeno_general.armor_ignore_integrity)
				if(i != 0)
					damage_armor_profile_armorbreak.Add("[round(armor_break_calculation(GLOB.xeno_ranged_stats, damage, i, penetration, in_ammo.pen_armor_punch, armor_punch)/i)]%")
				else
					damage_armor_profile_armorbreak.Add("N/A")

	var/rpm = max(fire_delay, 1)
	var/burst_rpm = max((fire_delay * 1.5 + (burst_amount - 1) * burst_delay)/max(burst_amount, 1), 0.0001)

	// weapon info

	data["icon"] = SSassets.transport.get_asset_url("no_name.png")

	if(SSassets.cache["[base_gun_icon].png"])
		data["icon"] = SSassets.transport.get_asset_url("[base_gun_icon].png")

	data["name"] = name
	data["desc"] = desc
	data["two_handed_only"] = (flags_gun_features & GUN_WIELDED_FIRING_ONLY)
	data["recoil"] = max(gun_recoil, 0.1)
	data["unwielded_recoil"] = max(recoil_unwielded, 0.1)
	data["firerate"] = round(1 MINUTES / rpm) // 3 minutes so that the values look greater than they actually are
	data["burst_firerate"] = round(1 MINUTES / burst_rpm)
	data["firerate_second"] = round(1 SECONDS / rpm, 0.01)
	data["burst_firerate_second"] = round(1 SECONDS / burst_rpm, 0.01)
	data["scatter"] = max(0.1, scatter + src.scatter)
	data["unwielded_scatter"] = max(0.1, scatter + scatter_unwielded)
	data["burst_scatter"] = src.burst_scatter_mult
	data["burst_amount"] = burst_amount

	// ammo info

	data["has_ammo"] = has_ammo
	data["ammo_name"] = ammo_name
	data["damage"] = damage
	data["falloff"] = falloff
	data["total_projectile_amount"] = bonus_projectile_amount+1
	data["armor_punch"] = armor_punch
	data["penetration"] = penetration
	data["accuracy"] = accuracy * accuracy_mult
	data["unwielded_accuracy"] = accuracy * accuracy_mult_unwielded
	data["min_accuracy"] = min_accuracy
	data["max_range"] = max_range

	// damage table data

	data["damage_armor_profile_headers"] = damage_armor_profile_headers
	data["damage_armor_profile_marine"] = damage_armor_profile_marine
	data["damage_armor_profile_xeno"] = damage_armor_profile_xeno
	data["damage_armor_profile_armorbreak"] = damage_armor_profile_armorbreak

	return data

/obj/item/weapon/gun/ui_static_data(mob/user)
	var/list/data = list()

	// consts (maxes)

	data["recoil_max"] = RECOIL_AMOUNT_TIER_1
	data["scatter_max"] = SCATTER_AMOUNT_TIER_1
	data["firerate_max"] = 1 MINUTES / FIRE_DELAY_TIER_10
	data["damage_max"] = 100
	data["accuracy_max"] = 32
	data["range_max"] = 32
	data["falloff_max"] = DAMAGE_FALLOFF_TIER_1
	data["penetration_max"] = ARMOR_PENETRATION_TIER_10
	data["punch_max"] = 5
	data["glob_armourbreak"] = GLOB.xeno_general.armor_ignore_integrity
	data["automatic"] = flags_gun_features & GUN_HAS_FULL_AUTO
	data["auto_only"] = flags_gun_features & GUN_FULL_AUTO_ONLY

	return data

/obj/item/weapon/gun/ui_assets(mob/user)
	. = ..() || list()
	. += get_asset_datum(/datum/asset/simple/firemodes)
	//. += get_asset_datum(/datum/asset/spritesheet/gun_lineart)

// END TGUI \\

/obj/item/weapon/gun/wield(mob/user)

	if(!(flags_item & TWOHANDED) || flags_item & WIELDED)
		return

	if(world.time < pull_time) //Need to wait until it's pulled out to aim
		return

	var/obj/item/I = user.get_inactive_hand()
	if(I)
		if(!user.drop_inv_item_on_ground(I))
			return

	if(ishuman(user))
		var/check_hand = user.r_hand == src ? "l_hand" : "r_hand"
		var/mob/living/carbon/human/wielder = user
		var/obj/limb/hand = wielder.get_limb(check_hand)
		if(!istype(hand) || !hand.is_usable())
			to_chat(user, SPAN_WARNING("Your other hand can't hold \the [src]!"))
			return

	flags_item ^= WIELDED
	name += " (Wielded)"
	item_state += "_w"
	slowdown = initial(slowdown) + aim_slowdown
	place_offhand(user, initial(name))
	wield_time = world.time + wield_delay
	if(user.dazed)
		wield_time += 5
	guaranteed_delay_time = world.time + WEAPON_GUARANTEED_DELAY
	//slower or faster wield delay depending on skill.
	if(user.skills)
		if(user.skills.get_skill_level(SKILL_FIREARMS) == SKILL_FIREARMS_CIVILIAN && !is_civilian_usable(user))
			wield_time += 3
		else
			wield_time -= 2*user.skills.get_skill_level(SKILL_FIREARMS)

	if(flags_gun_features & GUN_FULL_AUTO_ON)
		ADD_TRAIT(user, TRAIT_OVERRIDE_CLICKDRAG, TRAIT_SOURCE_WEAPON)

	return 1

/obj/item/weapon/gun/unwield(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_OVERRIDE_CLICKDRAG, TRAIT_SOURCE_WEAPON)
	if(.)
		slowdown = initial(slowdown)

//----------------------------------------------------------
			// \\
			// LOADING, RELOADING, AND CASINGS  \\
			// \\
			// \\
//----------------------------------------------------------

/obj/item/weapon/gun/proc/replace_ammo(mob/user = null, obj/item/ammo_magazine/magazine)
	if(!magazine.default_ammo)
		to_chat(user, "Something went horribly wrong. Ahelp the following: ERROR CODE A1: null ammo while reloading.")
		log_debug("ERROR CODE A1: null ammo while reloading. User: <b>[user]</b> Weapon: <b>[src]</b> Magazine: <b>[magazine]</b>")
		ammo = GLOB.ammo_list[/datum/ammo/bullet] //Looks like we're defaulting it.
	else
		ammo = GLOB.ammo_list[magazine.default_ammo]
	if(!magazine.caliber)
		to_chat(user, "Something went horribly wrong. Ahelp the following: ERROR CODE A2: null calibre while reloading.")
		log_debug("ERROR CODE A2: null calibre while reloading. User: <b>[user]</b> Weapon: <b>[src]</b> Magazine: <b>[magazine]</b>")
		caliber = "bugged calibre"
	else
		caliber = magazine.caliber

//Hardcoded and horrible
/obj/item/weapon/gun/proc/cock_gun(mob/user)
	set waitfor = 0
	if(cocked_sound)
		addtimer(CALLBACK(src, PROC_REF(cock_sound), user), 0.5 SECONDS)

/obj/item/weapon/gun/proc/cock_sound(mob/user)
	if(user && loc)
		playsound(user, cocked_sound, 25, TRUE)

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
			if(!do_after(user, magazine.reload_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				to_chat(user, SPAN_WARNING("Your reload was interrupted!"))
				return
		replace_magazine(user, magazine)
	else
		current_mag = magazine
		magazine.forceMove(src)
		replace_ammo(,magazine)
		if(!in_chamber) load_into_chamber()

	update_icon()
	return TRUE

/obj/item/weapon/gun/proc/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	user.drop_inv_item_to_loc(magazine, src) //Click!
	current_mag = magazine
	replace_ammo(user,magazine)
	if(!in_chamber)
		ready_in_chamber()
		cock_gun(user)
	user.visible_message(SPAN_NOTICE("[user] loads [magazine] into [src]!"),
		SPAN_NOTICE("You load [magazine] into [src]!"), null, 3, CHAT_TYPE_COMBAT_ACTION)
	if(reload_sound)
		playsound(user, reload_sound, 25, 1, 5)


//Drop out the magazine. Keep the ammo type for next time so we don't need to replace it every time.
//This can be passed with a null user, so we need to check for that as well.
/obj/item/weapon/gun/proc/unload(mob/user, reload_override = 0, drop_override = 0, loc_override = 0) //Override for reloading mags after shooting, so it doesn't interrupt burst. Drop is for dropping the magazine on the ground.
	if(!reload_override && (flags_gun_features & (GUN_BURST_FIRING|GUN_UNUSUAL_DESIGN|GUN_INTERNAL_MAG)))
		return

	if(!current_mag || QDELETED(current_mag) || (current_mag.loc != src && !loc_override))
		cock(user)
		return

	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		current_mag.forceMove(get_turf(src))//Drop it on the ground.
	else
		user.put_in_hands(current_mag)

	playsound(user, unload_sound, 25, 1, 5)
	user.visible_message(SPAN_NOTICE("[user] unloads [current_mag] from [src]."),
	SPAN_NOTICE("You unload [current_mag] from [src]."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	current_mag.update_icon()
	current_mag = null

	update_icon()

///Unload a chambered round, if one exists, and empty the chamber.
/obj/item/weapon/gun/proc/unload_chamber(mob/user)
	if(!in_chamber)
		return
	var/found_handful
	for(var/obj/item/ammo_magazine/handful/H in user.loc)
		if(H.default_ammo == in_chamber.ammo.type && H.caliber == caliber && H.current_rounds < H.max_rounds)
			found_handful = TRUE
			H.current_rounds++
			H.update_icon()
			break
	if(!found_handful)
		var/obj/item/ammo_magazine/handful/new_handful = new(get_turf(src))
		new_handful.generate_handful(in_chamber.ammo.type, caliber, 8, 1, type)

	QDEL_NULL(in_chamber)

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
		unload_chamber(user)
	else
		user.visible_message(SPAN_NOTICE("[user] cocks [src]."),
		SPAN_NOTICE("You cock [src]."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	display_ammo(user)
	ready_in_chamber() //This will already check for everything else, loading the next bullet.


//----------------------------------------------------------
			// \\
			// AFTER ATTACK AND CHAMBERING  \\
			// \\
			// \\
//----------------------------------------------------------

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, flag, params)
	if(active_attachable && (active_attachable.flags_attach_features & ATTACH_MELEE)) //this is expected to do something in melee.
		active_attachable.fire_attachment(A, src, user)
		return TRUE
	if(flag)
		return FALSE //It's adjacent, is the user, or is on the user's person
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
	else if(user.client?.prefs?.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY && (user.a_intent == INTENT_HELP))
		if (world.time % 3) // Limits how often this message pops up, saw this somewhere else and thought it was clever
			//Absolutely SCREAM this at people so they don't get killed by it
			to_chat(user, SPAN_HIGHDANGER("Help intent safety is on! Switch to another intent to fire your weapon."))
			click_empty(user)
		return FALSE
	else if(user.gun_mode && !(A in target))
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
	else
		Fire(A,user,params) //Otherwise, fire normally.
	return TRUE

/**
load_into_chamber(), reload_into_chamber(), and clear_jam() do all of the heavy lifting.
If you need to change up how a gun fires, just change these procs for that subtype
and you're good to go.
**/
/obj/item/weapon/gun/proc/load_into_chamber(mob/user)
	//The workhorse of the bullet procs.
	//If we have a round chambered and no active attachable, we're good to go.
	if(in_chamber && !active_attachable)
		return in_chamber //Already set!

	//Let's check on the active attachable. It loads ammo on the go, so it never chambers anything
	if(active_attachable)
		if(active_attachable.current_rounds > 0) //If it's still got ammo and stuff.
			active_attachable.current_rounds--
			var/obj/item/projectile/bullet = create_bullet(active_attachable.ammo, initial(name))
			// For now, only bullet traits from the attachment itself will apply to its projectiles
			for(var/entry in active_attachable.traits_to_give_attached)
				var/list/L
				// Check if this is an ID'd bullet trait
				if(istext(entry))
					L = active_attachable.traits_to_give_attached[entry].Copy()
				else
					// Prepend the bullet trait to the list
					L = list(entry) + active_attachable.traits_to_give_attached[entry]
				bullet.apply_bullet_trait(L)
			return bullet
		else
			to_chat(user, SPAN_WARNING("[active_attachable] is empty!"))
			to_chat(user, SPAN_NOTICE("You disable [active_attachable]."))
			playsound(user, active_attachable.activation_sound, 15, 1)
			active_attachable.activate_attachment(src, null, TRUE)
	else
		return ready_in_chamber()//We're not using the active attachable, we must use the active mag if there is one.

/obj/item/weapon/gun/proc/apply_traits(obj/item/projectile/P)
	// Apply bullet traits from gun
	for(var/entry in traits_to_give)
		var/list/L
		// Check if this is an ID'd bullet trait
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			// Prepend the bullet trait to the list
			L = list(entry) + traits_to_give[entry]
		P.apply_bullet_trait(L)

	// Apply bullet traits from attachments
	for(var/slot in attachments)
		if(!attachments[slot])
			continue

		var/obj/item/attachable/AT = attachments[slot]
		for(var/entry in AT.traits_to_give)
			var/list/L
			// Check if this is an ID'd bullet trait
			if(istext(entry))
				L = AT.traits_to_give[entry].Copy()
			else
				// Prepend the bullet trait to the list
				L = list(entry) + AT.traits_to_give[entry]
			P.apply_bullet_trait(L)

/obj/item/weapon/gun/proc/ready_in_chamber()
	QDEL_NULL(in_chamber)
	if(current_mag && current_mag.current_rounds > 0)
		in_chamber = create_bullet(ammo, initial(name))
		apply_traits(in_chamber)
		current_mag.current_rounds-- //Subtract the round from the mag.
		return in_chamber


/obj/item/weapon/gun/proc/create_bullet(datum/ammo/chambered, bullet_source)
	if(!chambered)
		to_chat(usr, "Something has gone horribly wrong. Ahelp the following: ERROR CODE I2: null ammo while create_bullet()")
		log_debug("ERROR CODE I2: null ammo while create_bullet(). User: <b>[usr]</b> Weapon: <b>[src]</b> Magazine: <b>[current_mag]</b>")
		chambered = GLOB.ammo_list[/datum/ammo/bullet] //Slap on a default bullet if somehow ammo wasn't passed.

	var/weapon_source_mob = null
	if(isliving(loc))
		var/mob/M = loc
		weapon_source_mob = M
	var/obj/item/projectile/P = new /obj/item/projectile(src, create_cause_data(bullet_source, weapon_source_mob))
	P.generate_bullet(chambered, 0, NO_FLAGS)

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
				if (user.client?.prefs && (user.client?.prefs?.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF))
					update_icon()
				else if (!(flags_gun_features & GUN_BURST_FIRING) || !in_chamber) // Magazine will only unload once burstfire is over
					var/drop_to_ground = TRUE
					if (user.client?.prefs && (user.client?.prefs?.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND))
						drop_to_ground = FALSE
						unwield(user)
						user.swap_hand()
					unload(user, TRUE, drop_to_ground) // We want to quickly autoeject the magazine. This proc does the rest based on magazine type. User can be passed as null.
					playsound(src, empty_sound, 25, 1)
		else // Just fired a chambered bullet with no magazine in the gun
			update_icon()

	return in_chamber //Returns the projectile if it's actually successful.

/obj/item/weapon/gun/proc/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	if(active_attachable) //Attachables don't chamber rounds, so we want to delete it right away.
		qdel(projectile_to_fire) //Getting rid of it. Attachables only use ammo after the cycle is over.
		if(refund)
			active_attachable.current_rounds++ //Refund the bullet.
		return 1

/obj/item/weapon/gun/proc/clear_jam(obj/item/projectile/projectile_to_fire, mob/user as mob) //Guns jamming, great.
	flags_gun_features &= ~GUN_BURST_FIRING // Also want to turn off bursting, in case that was on. It probably was.
	delete_bullet(projectile_to_fire, 1) //We're going to clear up anything inside if we need to.
	//If it's a regular bullet, we're just going to keep it chambered.
	extra_delay = 2 + (burst_delay + extra_delay)*2 // Some extra delay before firing again.
	to_chat(user, SPAN_WARNING("[src] jammed! You'll need a second to get it fixed!"))

//----------------------------------------------------------
		//    \\
		// FIRE BULLET AND POINT BLANK/SUICIDE \\
		//    \\
		//    \\
//----------------------------------------------------------

/obj/item/weapon/gun/proc/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	set waitfor = 0

	if(!able_to_fire(user) || !target)
		return

	var/turf/curloc = get_turf(user) //In case the target or we are expired.
	var/turf/targloc = get_turf(target)
	if(!targloc || !curloc)
		return //Something has gone wrong...
	var/atom/original_target = target //This is for burst mode, in case the target changes per scatter chance in between fired bullets.

	/*
	This is where the grenade launcher and flame thrower function as attachments.
	This is also a general check to see if the attachment can fire in the first place.
	*/
	var/check_for_attachment_fire = 0

	//Number of bullets based on burst. If an active attachable is shooting, bursting is always zero.
	var/bullets_to_fire = 1
	if(active_attachable?.flags_attach_features & ATTACH_WEAPON) //Attachment activated and is a weapon.
		check_for_attachment_fire = 1
		if(!(active_attachable.flags_attach_features & ATTACH_PROJECTILE)) //If it's unique projectile, this is where we fire it.
			if(active_attachable.current_rounds <= 0)
				click_empty(user) //If it's empty, let them know.
				to_chat(user, SPAN_WARNING("[active_attachable] is empty!"))
				to_chat(user, SPAN_NOTICE("You disable [active_attachable]."))
				active_attachable.activate_attachment(src, null, TRUE)
			else
				active_attachable.fire_attachment(target, src, user) //Fire it.
				active_attachable.last_fired = world.time
			return
			//If there's more to the attachment, it will be processed farther down, through in_chamber and regular bullet act.
	/*
	This is where burst is established for the proceeding section. Which just means the proc loops around that many times.
	If burst = 1, you must null it if you ever RETURN during the for() cycle. If for whatever reason burst is left on while
	the gun is not firing, it will break a lot of stuff. BREAK is fine, as it will null it.
	*/
	else if((flags_gun_features & GUN_BURST_ON) && burst_amount > 1)
		bullets_to_fire = burst_amount
		flags_gun_features |= GUN_BURST_FIRING
		if(PB_burst_bullets_fired) //Has a burst been carried over from a PB?
			bullets_to_fire -= PB_burst_bullets_fired
			PB_burst_bullets_fired = 0 //Don't need this anymore. The torch is passed.

	//Dual wielding. Do we have a gun in the other hand, is it loaded, and is it the same category?
	if(!reflex && !dual_wield && user)
		var/obj/item/weapon/gun/akimbo = user.get_inactive_hand()
		if(istype(akimbo) && akimbo.gun_category == gun_category && !(akimbo.flags_gun_features & GUN_WIELDED_FIRING_ONLY))
			/*Does the offhand weapon have a loaded selected attachable gun or ammo? This doesn't necessarily mean the offhand gun can be *fired*,
			an unpumped shotgun or opened double-barrel or a revolver with a spun cylinder would pass it, but it's less indiscrimate than it used to be.*/
			if(akimbo.active_attachable?.current_rounds || akimbo.has_ammunition())
				dual_wield = TRUE //increases recoil, increases scatter, and reduces accuracy.
				if(user?.client?.prefs?.toggle_prefs & TOGGLE_ALTERNATING_DUAL_WIELD)
					user.swap_hand()
				else
					akimbo.Fire(target,user,params, 0, TRUE)

	var/bullets_fired
	for(bullets_fired = 1 to bullets_to_fire)
		if(loc != user || (flags_gun_features & GUN_WIELDED_FIRING_ONLY && !(flags_item & WIELDED)))
			break //If you drop it while bursting, for example.

		if (bullets_fired > 1 && !(flags_gun_features & GUN_BURST_FIRING)) // No longer burst firing somehow
			break

		//The gun should return the bullet that it already loaded from the end cycle of the last Fire().
		var/obj/item/projectile/projectile_to_fire = load_into_chamber(user) //Load a bullet in or check for existing one.
		if(!projectile_to_fire) //If there is nothing to fire, click.
			click_empty(user)
			flags_gun_features &= ~GUN_BURST_FIRING
			return

		apply_bullet_effects(projectile_to_fire, user, bullets_fired, reflex, dual_wield) //User can be passed as null.
		SEND_SIGNAL(projectile_to_fire, COMSIG_BULLET_USER_EFFECTS, user)

		curloc = get_turf(user)
		if(QDELETED(original_target)) //If the target's destroyed, shoot at where it was last.
			target = targloc
		else
			target = original_target
			targloc = get_turf(target)

		projectile_to_fire.original = target

		// turf-targeted projectiles are fired without scatter, because proc would raytrace them further away
		var/ammo_flags = projectile_to_fire.ammo.flags_ammo_behavior | projectile_to_fire.projectile_override_flags
		if(!(ammo_flags & AMMO_HITS_TARGET_TURF))
			target = simulate_scatter(projectile_to_fire, target, curloc, targloc, user, bullets_fired)

		var/bullet_velocity = projectile_to_fire?.ammo?.shell_speed + velocity_add

		if(params) // Apply relative clicked position from the mouse info to offset projectile
			if(!params["click_catcher"])
				if(params["vis-x"])
					projectile_to_fire.p_x = text2num(params["vis-x"])
				else if(params["icon-x"])
					projectile_to_fire.p_x = text2num(params["icon-x"])
				if(params["vis-y"])
					projectile_to_fire.p_y = text2num(params["vis-y"])
				else if(params["icon-y"])
					projectile_to_fire.p_y = text2num(params["icon-y"])
				var/atom/movable/clicked_target = original_target
				if(istype(clicked_target))
					projectile_to_fire.p_x -= clicked_target.bound_width / 2
					projectile_to_fire.p_y -= clicked_target.bound_height / 2
				else
					projectile_to_fire.p_x -= world.icon_size / 2
					projectile_to_fire.p_y -= world.icon_size / 2
			else
				projectile_to_fire.p_x -= world.icon_size / 2
				projectile_to_fire.p_y -= world.icon_size / 2

		//Finally, make with the pew pew!
		if(QDELETED(projectile_to_fire) || !isobj(projectile_to_fire))
			to_chat(user, "ERROR CODE I1: Gun malfunctioned due to invalid chambered projectile, clearing it. AHELP if this persists.")
			log_debug("ERROR CODE I1: projectile malfunctioned while firing. User: <b>[user]</b> Weapon: <b>[src]</b> Magazine: <b>[current_mag]</b>")
			flags_gun_features &= ~GUN_BURST_FIRING
			in_chamber = null
			click_empty(user)
			return

		if(targloc != curloc)
			simulate_recoil(dual_wield, user, target)

			//This is where the projectile leaves the barrel and deals with projectile code only.
			//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			in_chamber = null // It's not in the gun anymore
			INVOKE_ASYNC(projectile_to_fire, TYPE_PROC_REF(/obj/item/projectile, fire_at), target, user, src, projectile_to_fire?.ammo?.max_range, bullet_velocity, original_target)
			projectile_to_fire = null // Important: firing might have made projectile collide early and ALREADY have deleted it. We clear it too.
			//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

			if(check_for_attachment_fire)
				active_attachable.last_fired = world.time
			else
				last_fired = world.time
			SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN, src)
			. = TRUE

			if(flags_gun_features & GUN_FULL_AUTO_ON)
				fa_shots++

		else // This happens in very rare circumstances when you're moving a lot while burst firing, so I'm going to toss it up to guns jamming.
			clear_jam(projectile_to_fire,user)
			break

		//>>POST PROCESSING AND CLEANUP BEGIN HERE.<<
		var/angle = round(Get_Angle(user,target)) //Let's do a muzzle flash.
		muzzle_flash(angle,user)

		//This is where we load the next bullet in the chamber. We check for attachments too, since we don't want to load anything if an attachment is active.
		if(!check_for_attachment_fire && !reload_into_chamber(user)) // It has to return a bullet, otherwise it's empty. Unless it's an undershotgun.
			click_empty(user)
			break //Nothing else to do here, time to cancel out.

		if(bullets_fired < bullets_to_fire) // We still have some bullets to fire.
			extra_delay = fire_delay * 0.5
			sleep(burst_delay)

	flags_gun_features &= ~GUN_BURST_FIRING // We always want to turn off bursting when we're done, mainly for when we break early mid-burstfire.
	display_ammo(user)

#define EXECUTION_CHECK (attacked_mob.stat == UNCONSCIOUS || attacked_mob.is_mob_restrained()) && ((user.a_intent == INTENT_GRAB)||(user.a_intent == INTENT_DISARM))

/obj/item/weapon/gun/attack(mob/living/attacked_mob, mob/living/user)
	if(active_attachable && (active_attachable.flags_attach_features & ATTACH_MELEE)) //this is expected to do something in melee.
		active_attachable.last_fired = world.time
		active_attachable.fire_attachment(attacked_mob, src, user)
		return TRUE

	if(!(flags_gun_features & GUN_CAN_POINTBLANK)) // If it can't point blank, you can't suicide and such.
		return ..()

	if(attacked_mob == user && user.zone_selected == "mouth" && ishuman(user))
		var/mob/living/carbon/human/HM = user
		if(!able_to_fire(user))
			return TRUE

		var/ffl = " (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>) ([user.client ? "<a href='?priv_msg=[user.client.ckey]'>PM</a>" : "NO CLIENT"])"

		var/obj/item/weapon/gun/revolver/current_revolver = src
		if(istype(current_revolver) && current_revolver.russian_roulette)
			attacked_mob.visible_message(SPAN_WARNING("[user] puts their revolver to their head, ready to pull the trigger."))
		else
			attacked_mob.visible_message(SPAN_WARNING("[user] sticks their gun in their mouth, ready to pull the trigger."))

		flags_gun_features ^= GUN_CAN_POINTBLANK //If they try to click again, they're going to hit themselves.
		if(!do_after(user, 4 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) || !able_to_fire(user))
			attacked_mob.visible_message(SPAN_NOTICE("[user] decided life was worth living."))
			flags_gun_features ^= GUN_CAN_POINTBLANK //Reset this.
			return TRUE

		if(active_attachable && !(active_attachable.flags_attach_features & ATTACH_PROJECTILE))
			active_attachable.activate_attachment(src, null, TRUE)//We're not firing off a nade into our mouth.
		var/obj/item/projectile/projectile_to_fire = load_into_chamber(user)
		if(projectile_to_fire) //We actually have a projectile, let's move on.
			user.visible_message(SPAN_WARNING("[user] pulls the trigger!"))
			var/actual_sound
			if(active_attachable && active_attachable.fire_sound)
				actual_sound = active_attachable.fire_sound
			else if(!isnull(fire_sound))
				actual_sound = fire_sound
			else actual_sound = pick(fire_sounds)
			var/sound_volume = (flags_gun_features & GUN_SILENCED && !active_attachable) ? 25 : 60
			playsound(user, actual_sound, sound_volume, 1)
			simulate_recoil(2, user)
			var/t
			var/datum/cause_data/cause_data
			if(projectile_to_fire.ammo.damage == 0)
				t += "\[[time_stamp()]\] <b>[key_name(user)]</b> tried to commit suicide with a [name]"
				cause_data = create_cause_data("failed suicide by [initial(name)]")
				to_chat(user, SPAN_DANGER("Ow..."))
				msg_admin_ff("[key_name(user)] tried to commit suicide with a [name] in [get_area(user)] [ffl]")
				user.apply_damage(200, HALLOSS)
			else
				t += "\[[time_stamp()]\] <b>[key_name(user)]</b> committed suicide with <b>[src]</b>" //Log it.
				cause_data = create_cause_data("suicide by [initial(name)]")
				if(istype(current_revolver) && current_revolver.russian_roulette) //If it's a revolver set to Russian Roulette.
					t += " after playing Russian Roulette"
					HM.apply_damage(projectile_to_fire.damage * 3, projectile_to_fire.ammo.damage_type, "head", used_weapon = "An unlucky pull of the trigger during Russian Roulette!", no_limb_loss = TRUE, permanent_kill = TRUE)
					HM.apply_damage(200, OXY) //Fill out the rest of their healthbar.
					HM.death(create_cause_data("russian roulette with \a [name]", user)) //Make sure they're dead. permanent_kill above will make them unrevivable.
					HM.update_headshot_overlay(projectile_to_fire.ammo.headshot_state) //Add headshot overlay.
					msg_admin_ff("[key_name(user)] lost at Russian Roulette with \a [name] in [get_area(user)] [ffl]")
					to_chat(user, SPAN_HIGHDANGER("Your life flashes before you as your spirit is torn from your body!"))
					user.ghostize(0) //No return.
				else
					HM.apply_damage(projectile_to_fire.damage * 2.5, projectile_to_fire.ammo.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [projectile_to_fire]", no_limb_loss = TRUE, permanent_kill = TRUE)
					HM.apply_damage(200, OXY) //Fill out the rest of their healthbar.
					HM.death(cause_data) //Make sure they're dead. permanent_kill above will make them unrevivable.
					HM.update_headshot_overlay(projectile_to_fire.ammo.headshot_state) //Add headshot overlay.
					msg_admin_ff("[key_name(user)] committed suicide with \a [name] in [get_area(user)] [ffl]")
			attacked_mob.last_damage_data = cause_data
			user.attack_log += t //Apply the attack log.
			last_fired = world.time //This is incorrect if firing an attached undershotgun, but the user is too dead to care.
			SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN, src)

			projectile_to_fire.play_hit_effect(user)
			// No projectile code to handhold us, we do the cleaning ourselves:
			QDEL_NULL(projectile_to_fire)
			in_chamber = null
			reload_into_chamber(user) //Reload the sucker.
		else
			click_empty(user)//If there's no projectile, we can't do much.
			if(istype(current_revolver) && current_revolver.russian_roulette && current_revolver.current_mag && current_revolver.current_mag.current_rounds)
				msg_admin_niche("[key_name(user)] played live Russian Roulette with \a [name] in [get_area(user)] [ffl]") //someone might want to know anyway...

		flags_gun_features ^= GUN_CAN_POINTBLANK //Reset this.
		return TRUE

	if(EXECUTION_CHECK) //Execution
		if(!able_to_fire(user)) //Can they actually use guns in the first place?
			return ..()
		user.visible_message(SPAN_DANGER("[user] puts [src] up to [attacked_mob], steadying their aim."), SPAN_WARNING("You put [src] up to [attacked_mob], steadying your aim."),null, null, CHAT_TYPE_COMBAT_ACTION)
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|INTERRUPT_DIFF_INTENT, BUSY_ICON_HOSTILE))
			return TRUE
	else if(user.a_intent != INTENT_HARM) //Thwack them
		return ..()

	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_ATTACK_DEAD) && attacked_mob.stat == DEAD) // don't shoot dead people
		return afterattack(attacked_mob, user, TRUE)

	user.next_move = world.time //No click delay on PBs.

	//Point blanking doesn't actually fire the projectile. Instead, it simulates firing the bullet proper.
	if(!able_to_fire(user)) //If it's a valid PB aside from that you can't fire the gun, do nothing.
		return TRUE

	//The following relating to bursts was borrowed from Fire code.
	var/check_for_attachment_fire = FALSE
	if(active_attachable)
		if(active_attachable.flags_attach_features & ATTACH_PROJECTILE)
			check_for_attachment_fire = TRUE
		else
			active_attachable.activate_attachment(src, null, TRUE)//No way.


	var/bullets_to_fire = 1

	if(!check_for_attachment_fire && (flags_gun_features & GUN_BURST_ON) && burst_amount > 1)
		bullets_to_fire = burst_amount
		flags_gun_features |= GUN_BURST_FIRING

	var/bullets_fired
	for(bullets_fired = 1 to bullets_to_fire)
		if(loc != user || (flags_gun_features & GUN_WIELDED_FIRING_ONLY && !(flags_item & WIELDED)))
			break //If you drop it while bursting, for example.

		if (bullets_fired > 1 && !(flags_gun_features & GUN_BURST_FIRING)) // No longer burst firing somehow
			break

		if(QDELETED(attacked_mob)) //Target deceased.
			break

		var/obj/item/projectile/projectile_to_fire = load_into_chamber(user)
		if(!projectile_to_fire)
			click_empty(user)
			break

		if(SEND_SIGNAL(projectile_to_fire.ammo, COMSIG_AMMO_POINT_BLANK, attacked_mob, projectile_to_fire, user, src) & COMPONENT_CANCEL_AMMO_POINT_BLANK)
			flags_gun_features &= ~GUN_BURST_FIRING
			return TRUE

		//We actually have a projectile, let's move on. We're going to simulate the fire cycle.
		if(projectile_to_fire.ammo.on_pointblank(attacked_mob, projectile_to_fire, user, src))
			flags_gun_features &= ~GUN_BURST_FIRING
			return TRUE

		var/damage_buff = BASE_BULLET_DAMAGE_MULT
		//if target is lying or unconscious - add damage bonus
		if(attacked_mob.lying == TRUE || attacked_mob.stat == UNCONSCIOUS)
			damage_buff += BULLET_DAMAGE_MULT_TIER_4
		projectile_to_fire.damage *= damage_buff //Multiply the damage for point blank.
		if(bullets_fired == 1) //First shot gives the PB message.
			user.visible_message(SPAN_DANGER("[user] fires [src] point blank at [attacked_mob]!"),
				SPAN_WARNING("You fire [src] point blank at [attacked_mob]!"), null, null, CHAT_TYPE_WEAPON_USE)

		user.track_shot(initial(name))
		apply_bullet_effects(projectile_to_fire, user, bullets_fired) //We add any damage effects that we need.

		SEND_SIGNAL(projectile_to_fire, COMSIG_BULLET_USER_EFFECTS, user)
		SEND_SIGNAL(user, COMSIG_BULLET_DIRECT_HIT, attacked_mob)
		simulate_recoil(1, user)

		if(projectile_to_fire.ammo.bonus_projectiles_amount)
			var/obj/item/projectile/BP
			for(var/i in 1 to projectile_to_fire.ammo.bonus_projectiles_amount)
				BP = new /obj/item/projectile(attacked_mob.loc, create_cause_data(initial(name), user))
				BP.generate_bullet(GLOB.ammo_list[projectile_to_fire.ammo.bonus_projectiles_type], 0, NO_FLAGS)
				BP.accuracy = round(BP.accuracy * projectile_to_fire.accuracy/initial(projectile_to_fire.accuracy)) //Modifies accuracy of pellets per fire_bonus_projectiles.
				BP.damage *= damage_buff
				projectile_to_fire.give_bullet_traits(BP)
				if(bullets_fired > 1)
					BP.original = attacked_mob //original == the original target of the projectile. If the target is downed and this isn't set, the projectile will try to fly over it. Of course, it isn't going anywhere, but it's the principle of the thing. Very embarrassing.
					if(!BP.handle_mob(attacked_mob) && attacked_mob.lying) //This is the 'handle impact' proc for a flying projectile, including hit RNG, on_hit_mob and bullet_act. If it misses, it doesn't go anywhere. We'll pretend it slams into the ground or punches a hole in the ceiling, because trying to make it bypass the xeno or shoot from the tile beyond it is probably more spaghet than my life is worth.
						if(BP.ammo.sound_bounce)
							playsound(attacked_mob.loc, BP.ammo.sound_bounce, 35, 1)
						attacked_mob.visible_message(SPAN_AVOIDHARM("[BP] slams into [get_turf(attacked_mob)]!"), //Managing to miss an immobile target flat on the ground deserves some recognition, don't you think?
							SPAN_AVOIDHARM("[BP] narrowly misses you!"), null, 4, CHAT_TYPE_TAKING_HIT)
				else
					BP.ammo.on_hit_mob(attacked_mob, BP, user)
					attacked_mob.bullet_act(BP)
				qdel(BP)

		if(bullets_fired > 1)
			projectile_to_fire.original = attacked_mob
			if(!projectile_to_fire.handle_mob(attacked_mob) && attacked_mob.lying)
				if(projectile_to_fire.ammo.sound_bounce)
					playsound(attacked_mob.loc, projectile_to_fire.ammo.sound_bounce, 35, 1)
				attacked_mob.visible_message(SPAN_AVOIDHARM("[projectile_to_fire] slams into [get_turf(attacked_mob)]!"),
					SPAN_AVOIDHARM("[projectile_to_fire] narrowly misses you!"), null, 4, CHAT_TYPE_TAKING_HIT)
		else
			projectile_to_fire.ammo.on_hit_mob(attacked_mob, projectile_to_fire, user)
			attacked_mob.bullet_act(projectile_to_fire)

		if(check_for_attachment_fire)
			active_attachable.last_fired = world.time
		else
			last_fired = world.time

		SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN, src)

		if(EXECUTION_CHECK) //Continue execution if on the correct intent. Accounts for change via the earlier do_after
			user.visible_message(SPAN_DANGER("[user] has executed [attacked_mob] with [src]!"), SPAN_DANGER("You have executed [attacked_mob] with [src]!"), message_flags = CHAT_TYPE_WEAPON_USE)
			attacked_mob.death()
			bullets_to_fire = bullets_fired //Giant bursts are not compatible with precision killshots.
		// No projectile code to handhold us, we do the cleaning ourselves:
		QDEL_NULL(projectile_to_fire)
		in_chamber = null

		//This is where we load the next bullet in the chamber. We check for attachments too, since we don't want to load anything if an attachment is active.
		if(!check_for_attachment_fire && !reload_into_chamber(user)) // It has to return a bullet, otherwise it's empty. Unless it's an undershotgun.
			click_empty(user)
			break //Nothing else to do here, time to cancel out.

		if(bullets_fired < bullets_to_fire) // We still have some bullets to fire.
			extra_delay = fire_delay * 0.5
			sleep(burst_delay)
			if(get_dist(user, attacked_mob) > 1) //We can each move around while burst-PBing, but if we get too far from the target, we'll have to shoot at them normally.
				PB_burst_bullets_fired = bullets_fired
				break

	flags_gun_features &= ~GUN_BURST_FIRING
	display_ammo(user)

	if(PB_burst_bullets_fired)
		Fire(get_turf(attacked_mob), user, reflex = TRUE) //Reflex prevents dual-wielding.

	return TRUE

#undef EXECUTION_CHECK
//----------------------------------------------------------
				// \\
				// FIRE CYCLE RELATED PROCS \\
				// \\
				// \\
//----------------------------------------------------------

/**Returns TRUE if the weapon is loaded. Separate proc because there's no single way to check this for all weapons: chamber isn't always loaded,
not all weapons use normal magazines etc. load_into_chamber() itself is designed to be called immediately before firing, and isn't suitable.**/
/obj/item/weapon/gun/proc/has_ammunition()
	if(in_chamber)
		return TRUE //Chambered round.
	if(current_mag?.current_rounds > 0)
		return TRUE //Loaded magazine.

/obj/item/weapon/gun/proc/able_to_fire(mob/user)
	/*
	Removed ishuman() check. There is no reason for it, as it just eats up more processing, and adding fingerprints during the fire cycle is silly.
	Consequently, predators are able to fire while cloaked.
	*/

	if(flags_gun_features & GUN_BURST_FIRING)
		return
	if(world.time < guaranteed_delay_time)
		return
	if((world.time < wield_time || world.time < pull_time) && (delay_style & WEAPON_DELAY_NO_FIRE > 0))
		return //We just put the gun up. Can't do it that fast

	if(ismob(user)) //Could be an object firing the gun.
		if(!user.IsAdvancedToolUser())
			to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
			return

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(!H.allow_gun_usage)
				if(issynth(user))
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

		if((flags_gun_features & GUN_WY_RESTRICTED) && !wy_allowed_check(user))
			return

		//Has to be on the bottom of the stack to prevent delay when failing to fire the weapon for the first time.
		//Can also set last_fired through New(), but honestly there's not much point to it.

		// The rest is delay-related. If we're firing full-auto it doesn't matter
		if(fa_firing)
			return TRUE

		var/next_shot

		if(active_attachable) //Underbarrel attached weapon?
			next_shot += active_attachable.last_fired + active_attachable.attachment_firing_delay
		else //Normal fire.
			next_shot += last_fired + fire_delay

		if(world.time >= next_shot + extra_delay) //check the last time it was fired.
			extra_delay = 0
		else if(!PB_burst_bullets_fired) //Special delay exemption for handed-off PB bursts. It's the same burst, after all.
			return

		if(fire_delay_group)
			for(var/group in fire_delay_group)
				var/group_next_fire = LAZYACCESS(user.fire_delay_next_fire, group)
				if(!isnull(group_next_fire) && world.time < group_next_fire)
					return
	return TRUE

/obj/item/weapon/gun/proc/click_empty(mob/user)
	if(user)
		to_chat(user, SPAN_WARNING("<b>*click*</b>"))
		playsound(user, 'sound/weapons/gun_empty.ogg', 25, 1, 5) //5 tile range
	else
		playsound(src, 'sound/weapons/gun_empty.ogg', 25, 1, 5)

/obj/item/weapon/gun/proc/display_ammo(mob/user)
	// Do not display ammo if you have an attachment
	// currently activated
	if(active_attachable)
		return

	if(flags_gun_features & GUN_AMMO_COUNTER && !(flags_gun_features & GUN_BURST_FIRING) && current_mag)
		var/chambered = in_chamber ? TRUE : FALSE
		to_chat(user, SPAN_DANGER("[current_mag.current_rounds][chambered ? "+1" : ""] / [current_mag.max_rounds] ROUNDS REMAINING"))

//This proc applies some bonus effects to the shot/makes the message when a bullet is actually fired.
/obj/item/weapon/gun/proc/apply_bullet_effects(obj/item/projectile/projectile_to_fire, mob/user, bullets_fired = 1, reflex = 0, dual_wield = 0)
	var/actual_sound = fire_sound
	if(isnull(fire_sound))
		actual_sound = pick(fire_sounds)
	if(projectile_to_fire.ammo && projectile_to_fire.ammo.sound_override)
		actual_sound = projectile_to_fire.ammo.sound_override

	var/gun_accuracy_mult = accuracy_mult_unwielded
	var/gun_scatter = scatter_unwielded

	if(flags_item & WIELDED || flags_gun_features & GUN_ONE_HAND_WIELDED)
		gun_accuracy_mult = accuracy_mult
		gun_scatter = scatter
	else if(user && world.time - user.l_move_time < 5) //moved during the last half second
		//accuracy and scatter penalty if the user fires unwielded right after moving
		gun_accuracy_mult = max(0.1, gun_accuracy_mult - max(0,movement_onehanded_acc_penalty_mult * HIT_ACCURACY_MULT_TIER_3))
		gun_scatter += max(0, movement_onehanded_acc_penalty_mult * SCATTER_AMOUNT_TIER_10)

	if(dual_wield) //akimbo firing gives terrible accuracy
		gun_accuracy_mult = max(0.1, gun_accuracy_mult - 0.1*rand(5,7))
		gun_scatter += SCATTER_AMOUNT_TIER_3

	// Apply any skill-based bonuses to accuracy
	if(user && user.mind && user.skills)
		var/skill_accuracy = 0
		if(user?.skills?.get_skill_level(SKILL_FIREARMS) == SKILL_FIREARMS_CIVILIAN && !is_civilian_usable(user))
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

	projectile_to_fire.damage = round(projectile_to_fire.damage * damage_mult) // Apply gun damage multiplier to projectile damage

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
			if(!(flags_gun_features & GUN_SILENCED))
				if (firing_sndfreq && fire_rattle)
					playsound(user, fire_rattle, firesound_volume, FALSE)//if the gun has a unique 'mag rattle' SFX play that instead of pitch shifting.
				else
					playsound(user, actual_sound, firesound_volume, firing_sndfreq)
			else
				playsound(user, actual_sound, 25, firing_sndfreq)

	return 1

/obj/item/weapon/gun/proc/simulate_scatter(obj/item/projectile/projectile_to_fire, atom/target, turf/curloc, turf/targloc, mob/user, bullets_fired = 1)
	var/fire_angle = Get_Angle(curloc, targloc)
	var/total_scatter_angle = projectile_to_fire.scatter

	if(flags_gun_features & GUN_BURST_ON && bullets_fired > 1)//Much higher scatter on burst. Each additional bullet adds scatter
		var/bullet_amt_scat = min(bullets_fired-1, SCATTER_AMOUNT_TIER_6)//capped so we don't penalize large bursts too much.
		if(flags_item & WIELDED)
			total_scatter_angle += max(0, bullet_amt_scat * burst_scatter_mult)
		else
			total_scatter_angle += max(0, 2 * bullet_amt_scat * burst_scatter_mult)

	// Full auto fucks your scatter up big time
	// Note that full auto uses burst scatter multipliers
	if(flags_gun_features & GUN_FULL_AUTO_ON)
		// The longer you fire full-auto, the worse the scatter gets
		var/bullet_amt_scat = min((fa_shots/fa_scatter_peak) * fa_max_scatter, fa_max_scatter)
		if(flags_item & WIELDED)
			total_scatter_angle += max(0, bullet_amt_scat * burst_scatter_mult)
		else
			total_scatter_angle += max(0, 2 * bullet_amt_scat * burst_scatter_mult)

	if(user && user.mind && user.skills)
		if(user?.skills?.get_skill_level(SKILL_FIREARMS) == SKILL_FIREARMS_CIVILIAN && !is_civilian_usable(user))
			total_scatter_angle += SCATTER_AMOUNT_TIER_7
		else
			total_scatter_angle -= user.skills.get_skill_level(SKILL_FIREARMS)*SCATTER_AMOUNT_TIER_8


	//Not if the gun doesn't scatter at all, or negative scatter.
	if(total_scatter_angle > 0)
		fire_angle += rand(-total_scatter_angle, total_scatter_angle)
		target = get_angle_target_turf(curloc, fire_angle, 30)

	return target

/obj/item/weapon/gun/proc/update_recoil_buildup()
	var/seconds_since_fired = max(world.timeofday - last_recoil_update, 0) * 0.1

	seconds_since_fired = max(seconds_since_fired - (fire_delay * 0.3), 0) // Takes into account firerate, so that recoil cannot fall whilst firing.
	// You have to be shooting at a third of the firerate of a gun to not build up any recoil if the recoil_loss_per_second is greater than the recoil_gain_per_second

	recoil_buildup = max(recoil_buildup - recoil_loss_per_second*seconds_since_fired, 0)

	last_recoil_update = world.timeofday

/obj/item/weapon/gun/proc/simulate_recoil(total_recoil = 0, mob/user, atom/target)
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
			total_recoil++

	if(user && user.mind && user.skills)
		if(user?.skills?.get_skill_level(SKILL_FIREARMS) == SKILL_FIREARMS_CIVILIAN && !is_civilian_usable(user))
			total_recoil += RECOIL_AMOUNT_TIER_5
		else
			total_recoil -= user.skills.get_skill_level(SKILL_FIREARMS)*RECOIL_AMOUNT_TIER_5

	if(total_recoil > 0 && ishuman(user))
		if(total_recoil >= 4)
			shake_camera(user, total_recoil * 0.5, total_recoil)
		else
			shake_camera(user, 1, total_recoil)
		return TRUE

	return FALSE

/obj/item/weapon/gun/proc/muzzle_flash(angle,mob/user)
	if(!muzzle_flash || flags_gun_features & GUN_SILENCED || isnull(angle))
		return //We have to check for null angle here, as 0 can also be an angle.
	if(!istype(user) || !istype(user.loc,/turf))
		return

	if(user.luminosity <= muzzle_flash_lum)
		user.SetLuminosity(muzzle_flash_lum, FALSE, src)
		addtimer(CALLBACK(user, TYPE_PROC_REF(/atom, SetLuminosity), 0, FALSE, src), 10)

	var/image_layer = (user && user.dir == SOUTH) ? MOB_LAYER+0.1 : MOB_LAYER-0.1
	var/offset = 5

	var/image/I = image('icons/obj/items/weapons/projectiles.dmi',user,muzzle_flash,image_layer)
	var/matrix/rotate = matrix() //Change the flash angle.
	rotate.Translate(0, offset)
	rotate.Turn(angle)
	I.transform = rotate
	I.flick_overlay(user, 3)

/obj/item/weapon/gun/attack_alien(mob/living/carbon/xenomorph/xeno)
	..()
	var/slashed_light = FALSE
	for(var/slot in attachments)
		if(istype(attachments[slot], /obj/item/attachable/flashlight))
			var/obj/item/attachable/flashlight/flashlight = attachments[slot]
			if(flashlight.activate_attachment(src, xeno, TRUE))
				slashed_light = TRUE
	if(slashed_light)
		playsound(loc, "alien_claw_metal", 25, 1)
		xeno.animation_attack_on(src)
		xeno.visible_message(SPAN_XENOWARNING("\The [xeno] slashes the lights on \the [src]!"), SPAN_XENONOTICE("You slash the lights on \the [src]!"))
	return XENO_ATTACK_ACTION
