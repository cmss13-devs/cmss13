//-------------------------------------------------------
//SNIPER RIFLES
//Keyword rifles. They are subtype of rifles, but still contained here as a specialist weapon.

//Because this parent type did not exist
//Note that this means that snipers will have a slowdown of 3, due to the scope
/obj/item/weapon/gun/rifle/sniper
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	wield_delay = WIELD_DELAY_SLOW

	var/has_aimed_shot = TRUE
	var/aiming_time = 1.25 SECONDS
	var/aimed_shot_cooldown
	var/aimed_shot_cooldown_delay = 2.5 SECONDS

	var/enable_aimed_shot_laser = TRUE
	var/sniper_lockon_icon = "sniper_lockon"
	var/obj/effect/ebeam/sniper_beam_type = /obj/effect/ebeam/laser
	var/sniper_beam_icon = "laser_beam"
	var/skill_locked = TRUE

/obj/item/weapon/gun/rifle/sniper/get_examine_text(mob/user)
	. = ..()
	if(!has_aimed_shot)
		return
	. += SPAN_NOTICE("This weapon has an unique ability, Aimed Shot, allowing it to deal great damage after a windup.<br><b> Additionally, the aimed shot can be sped up with a tracking laser, which is enabled by default but may be disabled.</b>")

/obj/item/weapon/gun/rifle/sniper/Initialize(mapload, spawn_empty)
	if(has_aimed_shot)
		LAZYADD(actions_types, list(/datum/action/item_action/specialist/aimed_shot, /datum/action/item_action/specialist/toggle_laser))
	return ..()

/obj/item/weapon/gun/rifle/sniper/able_to_fire(mob/living/user)
	. = ..()
	if(. && istype(user) && skill_locked) //Let's check all that other stuff first.
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SNIPER)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use \the [src]..."))
			return 0

// Aimed shot ability
/datum/action/item_action/specialist/aimed_shot
	ability_primacy = SPEC_PRIMARY_ACTION_2
	var/minimum_aim_distance = 2

/datum/action/item_action/specialist/aimed_shot/New(mob/living/user, obj/item/holder)
	..()
	name = "Aimed Shot"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "sniper_aim")
	button.overlays += IMG
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item
	sniper_rifle.aimed_shot_cooldown = world.time


/datum/action/item_action/specialist/aimed_shot/action_activate()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.selected_ability == src)
		to_chat(H, "You will no longer use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		button.icon_state = "template"
		H.selected_ability = null
	else
		to_chat(H, "You will now use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		if(H.selected_ability)
			H.selected_ability.button.icon_state = "template"
			H.selected_ability = null
		button.icon_state = "template_on"
		H.selected_ability = src

/datum/action/item_action/specialist/aimed_shot/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && !H.lying && (holder_item == H.r_hand || holder_item || H.l_hand))
		return TRUE

/datum/action/item_action/specialist/aimed_shot/proc/use_ability(atom/A)
	var/mob/living/carbon/human/human = owner
	if(!istype(A, /mob/living))
		return

	var/mob/living/target = A

	if(target.stat == DEAD || target == human)
		return

	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item
	if(world.time < sniper_rifle.aimed_shot_cooldown)
		return

	if(!check_can_use(target))
		return

	sniper_rifle.aimed_shot_cooldown = world.time + sniper_rifle.aimed_shot_cooldown_delay
	human.face_atom(target)

	///Add a decisecond to the default 1.5 seconds for each two tiles to hit.
	var/distance = round(get_dist(target, human) * 0.5)
	var/f_aiming_time = sniper_rifle.aiming_time + distance

	var/aim_multiplier = 1
	var/aiming_buffs

	if(sniper_rifle.enable_aimed_shot_laser)
		aim_multiplier = 0.6
		aiming_buffs++

	if(HAS_TRAIT(target, TRAIT_SPOTTER_LAZED))
		aim_multiplier = 0.5
		aiming_buffs++

	if(aiming_buffs > 1)
		aim_multiplier = 0.35

	f_aiming_time *= aim_multiplier

	var/image/lockon_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = sniper_rifle.sniper_lockon_icon)

	var/x_offset =  -target.pixel_x + target.base_pixel_x
	var/y_offset = (target.icon_size - world.icon_size) * 0.5 - target.pixel_y + target.base_pixel_y

	lockon_icon.pixel_x = x_offset
	lockon_icon.pixel_y = y_offset
	target.overlays += lockon_icon

	var/image/lockon_direction_icon
	if(!sniper_rifle.enable_aimed_shot_laser)
		lockon_direction_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "[sniper_rifle.sniper_lockon_icon]_direction", dir = get_cardinal_dir(target, human))
		lockon_direction_icon.pixel_x = x_offset
		lockon_direction_icon.pixel_y = y_offset
		target.overlays += lockon_direction_icon
	if(human.client)
		playsound_client(human.client, 'sound/weapons/TargetOn.ogg', human, 50)
	playsound(target, 'sound/weapons/TargetOn.ogg', 70, FALSE, 8, falloff = 0.4)

	var/datum/beam/laser_beam
	if(sniper_rifle.enable_aimed_shot_laser)
		laser_beam = target.beam(human, sniper_rifle.sniper_beam_icon, 'icons/effects/beam.dmi', (f_aiming_time + 1 SECONDS), beam_type = sniper_rifle.sniper_beam_type)
		laser_beam.visuals.alpha = 0
		animate(laser_beam.visuals, alpha = initial(laser_beam.visuals.alpha), f_aiming_time, easing = SINE_EASING|EASE_OUT)

	////timer is (f_spotting_time + 1 SECONDS) because sometimes it janks out before the doafter is done. blame sleeps or something

	if(!do_after(human, f_aiming_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, NO_BUSY_ICON))
		target.overlays -= lockon_icon
		target.overlays -= lockon_direction_icon
		qdel(laser_beam)
		return

	target.overlays -= lockon_icon
	target.overlays -= lockon_direction_icon
	qdel(laser_beam)

	if(!check_can_use(target, TRUE))
		return

	var/obj/item/projectile/aimed_proj = sniper_rifle.in_chamber
	aimed_proj.projectile_flags |= PROJECTILE_BULLSEYE
	aimed_proj.AddComponent(/datum/component/homing_projectile, target, human)
	sniper_rifle.Fire(target, human)

/datum/action/item_action/specialist/aimed_shot/proc/check_can_use(mob/M, cover_lose_focus)
	var/mob/living/carbon/human/H = owner
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item

	if(!can_use_action())
		return FALSE

	if(sniper_rifle != H.r_hand && sniper_rifle != H.l_hand)
		to_chat(H, SPAN_WARNING("How do you expect to do this without your sniper rifle?"))
		return FALSE

	if(!(sniper_rifle.flags_item & WIELDED))
		to_chat(H, SPAN_WARNING("Your aim is not stable enough with one hand. Use both hands!"))
		return FALSE

	if(!sniper_rifle.in_chamber)
		to_chat(H, SPAN_WARNING("\The [sniper_rifle] is unloaded!"))
		return FALSE

	if(get_dist(H, M) < minimum_aim_distance)
		to_chat(H, SPAN_WARNING("\The [M] is too close to get a proper shot!"))
		return FALSE

	var/obj/item/projectile/P = sniper_rifle.in_chamber
	// TODO: Make the below logic only occur in certain circumstances. Check goggles, maybe? -Kaga
	if(check_shot_is_blocked(H, M, P))
		to_chat(H, SPAN_WARNING("Something is in the way, or you're out of range!"))
		if(cover_lose_focus)
			to_chat(H, SPAN_WARNING("You lose focus."))
			sniper_rifle.aimed_shot_cooldown = world.time + sniper_rifle.aimed_shot_cooldown_delay * 0.5
		return FALSE

	return TRUE

/datum/action/item_action/specialist/aimed_shot/proc/check_shot_is_blocked(mob/firer, mob/target, obj/item/projectile/P)
	var/list/turf/path = getline2(firer, target, include_from_atom = FALSE)
	if(!path.len || get_dist(firer, target) > P.ammo.max_range)
		return TRUE

	var/blocked = FALSE
	for(var/turf/T in path)
		if(T.density || T.opacity)
			blocked = TRUE
			break

		for(var/obj/O in T)
			if(O.get_projectile_hit_boolean(P))
				blocked = TRUE
				break

		for(var/obj/effect/particle_effect/smoke/S in T)
			blocked = TRUE
			break

	return blocked

// Snipers may enable or disable their laser tracker at will.
/datum/action/item_action/specialist/toggle_laser

/datum/action/item_action/specialist/toggle_laser/New(mob/living/user, obj/item/holder)
	..()
	name = "Toggle Tracker Laser"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "sniper_toggle_laser_on")
	button.overlays += IMG
	update_button_icon()

/datum/action/item_action/specialist/toggle_laser/update_button_icon()
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item

	var/icon = 'icons/mob/hud/actions.dmi'
	var/icon_state = "sniper_toggle_laser_[sniper_rifle.enable_aimed_shot_laser ? "on" : "off"]"

	button.overlays.Cut()
	var/image/IMG = image(icon, button, icon_state)
	button.overlays += IMG

/datum/action/item_action/specialist/toggle_laser/can_use_action()
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item

	if(owner.is_mob_incapacitated())
		return FALSE

	if(owner.get_held_item() != sniper_rifle)
		to_chat(owner, SPAN_WARNING("How do you expect to do this without the sniper rifle in your hand?"))
		return FALSE
	return TRUE

/datum/action/item_action/specialist/toggle_laser/action_activate()
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item

	if(owner.get_held_item() != sniper_rifle)
		to_chat(owner, SPAN_WARNING("How do you expect to do this without the sniper rifle in your hand?"))
		return FALSE
	sniper_rifle.toggle_laser(owner, src)

/obj/item/weapon/gun/rifle/sniper/proc/toggle_laser(mob/user, datum/action/toggling_action)
	enable_aimed_shot_laser = !enable_aimed_shot_laser
	to_chat(user, SPAN_NOTICE("You flip a switch on \the [src] and [enable_aimed_shot_laser ? "enable" : "disable"] its targeting laser."))
	playsound(user, 'sound/machines/click.ogg', 15, TRUE)
	if(!toggling_action)
		toggling_action = locate(/datum/action/item_action/specialist/toggle_laser) in actions
	if(toggling_action)
		toggling_action.update_button_icon()

/obj/item/weapon/gun/rifle/sniper/toggle_burst(mob/user)
	if(has_aimed_shot)
		toggle_laser(user)
	else
		..()

//Pow! Headshot.
/obj/item/weapon/gun/rifle/sniper/M42A
	name = "\improper M42A scoped rifle"
	desc = "A heavy sniper rifle manufactured by Armat Systems. It has a scope system and fires armor penetrating rounds out of a 15-round magazine.\n'Peace Through Superior Firepower'"
	icon_state = "m42a"
	item_state = "m42a"
	unacidable = TRUE
	indestructible = 1

	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/sniper
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod)
	starting_attachment_types = list(/obj/item/attachable/sniperbarrel)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	map_specific_decoration = TRUE

	flags_item = TWOHANDED|NO_CRYO_STORE

/obj/item/weapon/gun/rifle/sniper/M42A/verb/toggle_scope_zoom_level()
	set name = "Toggle Scope Zoom Level"
	set category = "Weapons"
	set src in usr
	var/obj/item/attachable/scope/variable_zoom/S = attachments["rail"]
	S.toggle_zoom_level()

/obj/item/weapon/gun/rifle/sniper/M42A/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/variable_zoom/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.ignore_clash_fog = TRUE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/sniper/M42A/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/rifle/sniper/M42A/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 39, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 20, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)


/obj/item/weapon/gun/rifle/sniper/M42A/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*3
	burst_amount = BURST_AMOUNT_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/sniper/XM42B
	name = "\improper XM42B experimental anti-materiel rifle"
	desc = "An experimental anti-materiel rifle produced by Armat Systems, recently reacquired from the deep storage of an abandoned prototyping facility. This one in particular is currently undergoing field testing. Chambered in 10x99mm Caseless."
	icon_state = "xm42b"
	item_state = "xm42b"
	unacidable = TRUE
	indestructible = 1

	fire_sound = 'sound/weapons/sniper_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/anti_materiel //Renamed from anti-tank to align with new identity/description. Other references have been changed as well. -Kaga
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/sniperbarrel)
	sniper_beam_type = /obj/effect/ebeam/laser/intense
	sniper_beam_icon = "laser_beam_intense"
	sniper_lockon_icon = "sniper_lockon_intense"

/obj/item/weapon/gun/rifle/sniper/XM42B/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/variable_zoom/S = new(src)
	S.icon_state = "pmcscope"
	S.attach_icon = "pmcscope"
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.ignore_clash_fog = TRUE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/sniper/XM42B/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 15, "rail_y" = 19, "under_x" = 20, "under_y" = 15, "stock_x" = 20, "stock_y" = 15)


/obj/item/weapon/gun/rifle/sniper/XM42B/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6 * 6 //Big boy damage, but it takes a lot of time to fire a shot.
	//Kaga: Adjusted from 56 (Tier 4, 7*8) -> 30 (Tier 6, 5*6) ticks. 95 really wasn't big-boy damage anymore, although I updated it to 125 to remain consistent with the other 10x99mm caliber weapon (M42C). Now takes only twice as long as the M42A.
	burst_amount = BURST_AMOUNT_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT + 2*HIT_ACCURACY_MULT_TIER_10 //Who coded this like this, and why? It just calculates out to 1+1=2. Leaving a note here to check back later.
	scatter = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/rifle/sniper/XM42B/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff),
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating),
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 11, GLOB.damage_boost_turfs),
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 11, GLOB.damage_boost_breaching),
		//At 1375 per shot it'll take 1 shot to break resin turfs, and a full mag of 8 to break reinforced walls.
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 6, GLOB.damage_boost_pylons)
		//At 750 per shot it'll take 3 to break a Pylon (1800 HP). No Damage Boost vs other xeno structures yet, those will require a whole new list w/ the damage_boost trait.
	))

/*
//Disabled until an identity is better defined. -Kaga
/obj/item/weapon/gun/rifle/sniper/M42B/afterattack(atom/target, mob/user, flag)
	if(able_to_fire(user))
		if(get_dist(target,user) <= 8)
			to_chat(user, SPAN_WARNING("The [src.name] beeps, indicating that the target is within an unsafe proximity to the rifle, refusing to fire."))
			return
		else ..()
*/

/obj/item/weapon/gun/rifle/sniper/elite
	name = "\improper M42C anti-tank sniper rifle"
	desc = "A high-end superheavy magrail sniper rifle from Weyland-Armat chambered in a specialized variant of the heaviest ammo available, 10x99mm Caseless. This weapon requires a specialized armor rig for recoil mitigation in order to be used effectively."
	icon_state = "m42c"
	item_state = "m42c" //NEEDS A TWOHANDED STATE

	fire_sound = 'sound/weapons/sniper_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/elite
	force = 17
	zoomdevicename = "scope"
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/sniperbarrel)
	sniper_beam_type = /obj/effect/ebeam/laser/intense
	sniper_beam_icon = "laser_beam_intense"
	sniper_lockon_icon = "sniper_lockon_intense"

/obj/item/weapon/gun/rifle/sniper/elite/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.icon_state = "pmcscope"
	S.attach_icon = "pmcscope"
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.ignore_clash_fog = TRUE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/sniper/elite/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/rifle/sniper/elite/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 15, "rail_y" = 19, "under_x" = 20, "under_y" = 15, "stock_x" = 20, "stock_y" = 15)

/obj/item/weapon/gun/rifle/sniper/elite/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*5
	burst_amount = BURST_AMOUNT_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT * 3 //Was previously BAM + HAMT10, similar to the XM42B, and coming out to 1.5? Changed to be consistent with M42A. -Kaga
	scatter = SCATTER_AMOUNT_TIER_10 //Was previously 8, changed to be consistent with the XM42B.
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/rifle/sniper/elite/simulate_recoil(total_recoil = 0, mob/user, atom/target)
	. = ..()
	if(.)
		var/mob/living/carbon/human/PMC_sniper = user
		if(PMC_sniper.lying == 0 && !istype(PMC_sniper.wear_suit,/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc) && !istype(PMC_sniper.wear_suit,/obj/item/clothing/suit/storage/marine/veteran))
			PMC_sniper.visible_message(SPAN_WARNING("[PMC_sniper] is blown backwards from the recoil of the [src.name]!"),SPAN_HIGHDANGER("You are knocked prone by the blowback!"))
			step(PMC_sniper,turn(PMC_sniper.dir,180))
			PMC_sniper.apply_effect(5, WEAKEN)

//SVD //Based on the actual Dragunov DMR rifle.

/obj/item/weapon/gun/rifle/sniper/svd
	name = "\improper SVD Dragunov-033 designated marksman rifle"
	desc = "A wannabe replica of an SVD, constructed from a MAR-40 by someone probably illiterate that thought the original SVD was built from an AK pattern. Fires 7.62x54mmR rounds."
	icon_state = "svd003"
	item_state = "svd003" //NEEDS A ONE HANDED STATE

	fire_sound = 'sound/weapons/gun_kt42.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/svd
	attachable_allowed = list(
		//Muzzle,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp_replica,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		//Barrel,
		/obj/item/attachable/slavicbarrel,
		//Rail,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/variable_zoom,
		/obj/item/attachable/scope/variable_zoom/slavic,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/slavic,
		//Under,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/bipod,
		//Stock,
		/obj/item/attachable/stock/slavic,
	)
	has_aimed_shot = FALSE
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY
	starting_attachment_types = list(/obj/item/attachable/scope/variable_zoom/slavic)
	sniper_beam_type = null
	skill_locked = FALSE

/obj/item/weapon/gun/rifle/sniper/svd/handle_starting_attachment()
	..()
	var/obj/item/attachable/attachie = new /obj/item/attachable/slavicbarrel(src)
	attachie.flags_attach_features &= ~ATTACH_REMOVABLE
	attachie.Attach(src)
	update_attachable(attachie.slot)

	attachie = new /obj/item/attachable/stock/slavic(src)
	attachie.flags_attach_features &= ~ATTACH_REMOVABLE
	attachie.Attach(src)
	update_attachable(attachie.slot)

/obj/item/weapon/gun/rifle/sniper/svd/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 13, "rail_y" = 19, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/sniper/svd/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6
	burst_amount = BURST_AMOUNT_TIER_2
	burst_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	damage_falloff_mult = 0

//M4RA marksman rifle

/obj/item/weapon/gun/rifle/m4ra
	name = "\improper M4RA battle rifle"
	desc = "The M4RA battle rifle is a designated marksman rifle in service with the USCM. Only fielded in small numbers, and sporting a bullpup configuration, the M4RA battle rifle is perfect for reconnaissance and fire support teams.\nIt is equipped with rail scope and takes 10x24mm A19 high velocity magazines."
	icon_state = "m41b"
	item_state = "m4ra" //PLACEHOLDER
	unacidable = TRUE
	indestructible = 1

	fire_sound = 'sound/weapons/gun_m4ra.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m4ra
	force = 16
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/bipod,
		/obj/item/attachable/compensator,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/marksman)

	flags_item = TWOHANDED|NO_CRYO_STORE


/obj/item/weapon/gun/rifle/m4ra/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 20, "under_x" = 23, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/m4ra/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6
	burst_amount = BURST_AMOUNT_TIER_2
	burst_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/m4ra/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SCOUT)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use \the [src]..."))
			return FALSE

//-------------------------------------------------------
//HEAVY WEAPONS

/obj/item/weapon/gun/launcher
	gun_category = GUN_CATEGORY_HEAVY
	has_empty_icon = FALSE
	has_open_icon = FALSE
	///gun update_icon doesn't detect that guns with no magazine are loaded or not, and will always append _o or _e if possible.
	var/GL_has_empty_icon = TRUE
	///gun update_icon doesn't detect that guns with no magazine are loaded or not, and will always append _o or _e if possible.
	var/GL_has_open_icon = FALSE

	///Internal storage item used as magazine. Must be initialised to work! Set parameters by variables or it will inherit standard numbers from storage.dm. Got to call it *something* and 'magazine' or w/e would be confusing.
	var/obj/item/storage/internal/cylinder
	/// Variable that initializes the above.
	var/has_cylinder = FALSE
	///What single item to fill the storage with, if any. This does not respect w_class.
	var/preload
	///How many items can be inserted. "Null" = backpack-style size-based inventory. You'll have to set max_storage_space too if you do that, and arrange any initial contents. Iff you arrange to put in more items than the storage can hold, they can be taken out but not replaced.
	var/internal_slots
	///how big an item can be inserted.
	var/internal_max_w_class
	///the sfx played when the storage is opened.
	var/use_sound = null
	///Whether clicking a held weapon with an empty hand will open its inventory or draw a munition out.
	var/direct_draw = TRUE

/obj/item/weapon/gun/launcher/Initialize(mapload, spawn_empty) //If changing vars on init, be sure to do the parent proccall *after* the change.
	. = ..()
	if(has_cylinder)
		cylinder = new /obj/item/storage/internal(src)
		cylinder.storage_slots = internal_slots
		cylinder.max_w_class = internal_max_w_class
		cylinder.use_sound = use_sound
		if(direct_draw)
			cylinder.storage_flags ^= STORAGE_USING_DRAWING_METHOD
		if(preload && !spawn_empty) for(var/i = 1 to cylinder.storage_slots)
			new preload(cylinder)
		update_icon()

/obj/item/weapon/gun/launcher/verb/toggle_draw_mode()
	set name = "Switch Storage Drawing Method"
	set category = "Object"
	set src in usr

	cylinder.storage_draw_logic(src.name)

//-------------------------------------------------------
//GRENADE LAUNCHER

/obj/item/weapon/gun/launcher/grenade //Parent item for GLs.
	w_class = SIZE_LARGE
	throw_speed = SPEED_SLOW
	throw_range = 10
	force = 5

	fire_sound = 'sound/weapons/armbomb.ogg'
	cocked_sound = 'sound/weapons/gun_m92_cocked.ogg'
	reload_sound = 'sound/weapons/gun_shotgun_open2.ogg' //Played when inserting nade.
	unload_sound = 'sound/weapons/gun_revolver_unload.ogg'

	has_cylinder = TRUE //This weapon won't work otherwise.
	preload = /obj/item/explosive/grenade/high_explosive
	internal_slots = 1 //This weapon must use slots.
	internal_max_w_class = SIZE_MEDIUM //MEDIUM = M15.

	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	wield_delay = WIELD_DELAY_SLOW
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	///Can you access the storage by clicking it, put things into it, or take things out? Meant for break-actions mostly but useful for any state where you want access to be toggleable. Make sure to call cylinder.close(user) so they don't still have the screen open!
	var/open_chamber = TRUE
	///Does it launch its grenades in a low arc or a high? Do they strike people in their path, or fly beyond?
	var/is_lobbing = FALSE
	///Verboten munitions. This is a blacklist. Anything in this list isn't loadable.
	var/disallowed_grenade_types = list(/obj/item/explosive/grenade/spawnergrenade, /obj/item/explosive/grenade/alien, /obj/item/explosive/grenade/incendiary/molotov, /obj/item/explosive/grenade/flashbang)
	///What is this weapon permitted to fire? This is a whitelist. Anything in this list can be fired. Anything.
	var/valid_munitions = list(/obj/item/explosive/grenade)


/obj/item/weapon/gun/launcher/grenade/set_gun_config_values()
	..()
	recoil = RECOIL_AMOUNT_TIER_4 //Same as m37 shotgun.


/obj/item/weapon/gun/launcher/grenade/on_pocket_insertion() //Plays load sfx whenever a nade is put into storage.
	playsound(usr, reload_sound, 25, 1)
	update_icon()

/obj/item/weapon/gun/launcher/grenade/on_pocket_removal()
	update_icon()

/obj/item/weapon/gun/launcher/grenade/get_examine_text(mob/user) //Different treatment for single-shot VS multi-shot GLs.
	. = ..()
	if(get_dist(user, src) > 2 && user != loc)
		return
	if(length(cylinder.contents))
		if(internal_slots == 1)
			. += SPAN_NOTICE("It is loaded with a grenade.")
		else
			. += SPAN_NOTICE("It is loaded with <b>[length(cylinder.contents)] / [internal_slots]</b> grenades.")
	else
		. += SPAN_NOTICE("It is empty.")


/obj/item/weapon/gun/launcher/grenade/update_icon()
	..()
	var/GL_sprite = base_gun_icon
	if(GL_has_empty_icon && cylinder && !length(cylinder.contents))
		GL_sprite += "_e"
		playsound(loc, cocked_sound, 25, 1)
	if(GL_has_open_icon && open_chamber)
		GL_sprite += "_o"
		playsound(loc, cocked_sound, 25, 1)
	icon_state = GL_sprite


/obj/item/weapon/gun/launcher/grenade/attack_hand(mob/user)
	if(!open_chamber || src != user.get_inactive_hand()) //Need to have the GL in your hands to open the cylinder.
		return ..()
	if(cylinder.handle_attack_hand(user))
		..()


/obj/item/weapon/gun/launcher/grenade/unload(mob/user, reload_override = FALSE, drop_override = FALSE, loc_override = FALSE)
	if(!open_chamber)
		to_chat(user, SPAN_WARNING("[src] is closed!"))
		return
	if(!length(cylinder.contents))
		to_chat(user, SPAN_WARNING("It's empty!"))
		return

	var/obj/item/explosive/grenade/nade = cylinder.contents[length(cylinder.contents)] //Grab the last-inserted one. Or the only one, as the case may be.
	cylinder.remove_from_storage(nade, user.loc)

	if(drop_override || !user)
		nade.forceMove(get_turf(src))
	else
		user.put_in_hands(nade)

	user.visible_message(SPAN_NOTICE("[user] unloads [nade] from [src]."),
	SPAN_NOTICE("You unload [nade] from [src]."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	playsound(user, unload_sound, 30, 1)


/obj/item/weapon/gun/launcher/grenade/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/attachable) && check_inactive_hand(user))
		attach_to_gun(user,I)
		return
	return cylinder.attackby(I, user)

/obj/item/weapon/gun/launcher/grenade/unique_action(mob/user)
	if(isobserver(usr) || isxeno(usr))
		return
	if(locate(/datum/action/item_action/toggle_firing_level) in actions)
		toggle_firing_level(usr)

/obj/item/weapon/gun/launcher/grenade/proc/allowed_ammo_type(obj/item/I)
	for(var/G in disallowed_grenade_types) //Check for the bad stuff.
		if(istype(I, G))
			return FALSE
	for(var/G in valid_munitions) //Check if it has a ticket.
		if(istype(I, G))
			return TRUE


/obj/item/weapon/gun/launcher/grenade/on_pocket_attackby(obj/item/explosive/grenade/I, mob/user) //the attack in question is on the internal container. Complete override - normal storage attackby cannot be silenced, and will always say "you put the x into y".
	if(!open_chamber)
		to_chat(user, SPAN_WARNING("[src] is closed!"))
		return
	if(!istype(I))
		to_chat(user, SPAN_WARNING("You can't load [I] into [src]!"))
		return
	if(!allowed_ammo_type(I))
		to_chat(user, SPAN_WARNING("[src] can't fire this type of grenade!"))
		return
	if(length(cylinder.contents) >= internal_slots)
		to_chat(user, SPAN_WARNING("[src] cannot hold more grenades!"))
		return
	if(!cylinder.can_be_inserted(I)) //Technically includes whether there's room for it, but the above gives a tailored message.
		return

	user.visible_message(SPAN_NOTICE("[user] loads [I] into [src]."),
	SPAN_NOTICE("You load [I] into the grenade launcher."), null, 4, CHAT_TYPE_COMBAT_ACTION)
	playsound(usr, reload_sound, 75, 1)
	if(internal_slots > 1)
		to_chat(user, SPAN_INFO("Now storing: [length(cylinder.contents) + 1] / [internal_slots] grenades."))

	cylinder.handle_item_insertion(I, TRUE, user)


/obj/item/weapon/gun/launcher/grenade/able_to_fire(mob/living/user) //Skillchecks and fire blockers go in the child items.
	. = ..()
	if(.)
		if(!length(cylinder.contents))
			to_chat(user, SPAN_WARNING("The [name] is empty."))
			return FALSE
		var/obj/item/explosive/grenade/G = cylinder.contents[1]
		if(G.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(G, user))
			to_chat(user, SPAN_WARNING("\The [name]'s safe-area accident inhibitor prevents you from firing!"))
			msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")
			return FALSE


/obj/item/weapon/gun/launcher/grenade/afterattack(atom/target, mob/user, flag) //Not actually after the attack. After click, more like.
	if(able_to_fire(user))
		if(get_dist(target,user) <= 2)
			var/obj/item/explosive/grenade/nade = cylinder.contents[1]
			if(nade.dangerous)
				to_chat(user, SPAN_WARNING("The grenade launcher beeps a warning noise. You are too close!"))
				return
		fire_grenade(target,user)


/obj/item/weapon/gun/launcher/grenade/proc/fire_grenade(atom/target, mob/user)
	set waitfor = 0
	last_fired = world.time

	var/to_firer = "You fire the [name]!"
	if(internal_slots > 1)
		to_firer += " [length(cylinder.contents)-1]/[internal_slots] grenades remaining."
	user.visible_message(SPAN_DANGER("[user] fired a grenade!"),
	SPAN_WARNING("[to_firer]"), message_flags = CHAT_TYPE_WEAPON_USE)
	playsound(user.loc, fire_sound, 50, 1)

	var/angle = round(Get_Angle(user,target))
	muzzle_flash(angle,user)
	simulate_recoil(0, user)

	var/obj/item/explosive/grenade/F = cylinder.contents[1]
	cylinder.remove_from_storage(F, user.loc)
	var/pass_flags = NO_FLAGS
	if(is_lobbing)
		if(istype(F, /obj/item/explosive/grenade/slug/baton))
			if(ishuman(user))
				var/mob/living/carbon/human/human_user = user
				human_user.remember_dropped_object(F)
			pass_flags |= PASS_MOB_THRU_HUMAN|PASS_MOB_IS_OTHER|PASS_OVER
		else
			pass_flags |= PASS_MOB_THRU|PASS_HIGH_OVER

	msg_admin_attack("[key_name_admin(user)] fired a grenade ([F.name]) from \a ([name]).")
	log_game("[key_name_admin(user)] used a grenade ([name]).")

	F.throw_range = 20
	F.det_time = min(10, F.det_time)
	F.activate(user, FALSE)
	F.forceMove(get_turf(src))
	F.throw_atom(target, 20, SPEED_VERY_FAST, user, null, NORMAL_LAUNCH, pass_flags)



//Doesn't use these. Listed for reference.
/obj/item/weapon/gun/launcher/grenade/load_into_chamber()
	return
/obj/item/weapon/gun/launcher/grenade/reload_into_chamber()
	return

/obj/item/weapon/gun/launcher/grenade/has_ammunition()
	return length(cylinder.contents)

//-------------------------------------------------------
//Toggle firing level special action for grenade launchers

/datum/action/item_action/toggle_firing_level/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Firing Level"
	button.name = name
	update_icon()

/datum/action/item_action/toggle_firing_level/action_activate()
	var/obj/item/weapon/gun/launcher/grenade/G = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.is_mob_incapacitated() || G.get_active_firearm(H, FALSE) != holder_item)
		return
	G.toggle_firing_level(usr)

/datum/action/item_action/toggle_firing_level/proc/update_icon()
	var/obj/item/weapon/gun/launcher/grenade/G = holder_item
	if(G.is_lobbing)
		action_icon_state = "hightoss_on"
	else
		action_icon_state = "hightoss_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/obj/item/weapon/gun/launcher/grenade/proc/toggle_firing_level(mob/user)
	is_lobbing = !is_lobbing
	to_chat(user, "[icon2html(src, usr)] You changed \the [src]'s firing level. You will now fire [is_lobbing ? "in an arcing path over obstacles" : "directly at your target"].")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	var/datum/action/item_action/toggle_firing_level/TFL = locate(/datum/action/item_action/toggle_firing_level) in actions
	TFL.update_icon()

//-------------------------------------------------------
//M92 GRENADE LAUNCHER

/obj/item/weapon/gun/launcher/grenade/m92
	name = "\improper M92 grenade launcher"
	desc = "A heavy, 6-shot grenade launcher used by the Colonial Marines for area denial and big explosions."
	icon_state = "m92"
	item_state = "m92"
	unacidable = TRUE
	indestructible = 1
	matter = list("metal" = 6000)
	actions_types = list(/datum/action/item_action/toggle_firing_level)

	attachable_allowed = list(/obj/item/attachable/magnetic_harness)
	flags_item = TWOHANDED|NO_CRYO_STORE
	map_specific_decoration = TRUE

	is_lobbing = TRUE
	internal_slots = 6
	direct_draw = FALSE

/obj/item/weapon/gun/launcher/grenade/m92/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 14, "rail_y" = 22, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/launcher/grenade/m92/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_4*4

/obj/item/weapon/gun/launcher/grenade/m92/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user))
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_GRENADIER)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use \the [src]..."))
			return FALSE


//-------------------------------------------------------
//M81 GRENADE LAUNCHER

/obj/item/weapon/gun/launcher/grenade/m81
	name = "\improper M81 grenade launcher"
	desc = "A lightweight, single-shot low-angle grenade launcher used by the Colonial Marines for area denial and big explosions."
	icon_state = "m81"
	item_state = "m81" //needs a wield sprite.

	matter = list("metal" = 7000)

/obj/item/weapon/gun/launcher/grenade/m81/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 14, "rail_y" = 22, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/launcher/grenade/m81/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_4 * 1.5

/obj/item/weapon/gun/launcher/grenade/m81/on_pocket_removal()
	..()
	playsound(usr, unload_sound, 30, 1)

/obj/item/weapon/gun/launcher/grenade/m81/riot/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user))
		if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use \the [src]..."))
			return FALSE


/obj/item/weapon/gun/launcher/grenade/m81/riot
	name = "\improper M81 riot grenade launcher"
	desc = "A lightweight, single-shot low-angle grenade launcher to launch tear gas grenades. Used by the Colonial Marines Military Police during riots."
	valid_munitions = list(/obj/item/explosive/grenade/custom/teargas)
	preload = /obj/item/explosive/grenade/custom/teargas

//-------------------------------------------------------
//M79 Grenade Launcher subtype of the M81

/obj/item/weapon/gun/launcher/grenade/m81/m79//m79 variant for marines
	name = "\improper M79 grenade launcher"
	desc = "A heavy, low-angle 40mm grenade launcher. It's been in use since the Vietnam War, though this version has been modernized with an IFF enabled micro-computer. The wooden furniture is, in fact, made of painted hardened polykevlon."
	icon_state = "m79"
	item_state = "m79"
	flags_equip_slot = SLOT_BACK
	preload = /obj/item/explosive/grenade/slug/baton
	is_lobbing = TRUE
	actions_types = list(/datum/action/item_action/toggle_firing_level)

	fire_sound = 'sound/weapons/handling/m79_shoot.ogg'
	cocked_sound = 'sound/weapons/handling/m79_break_open.ogg'
	reload_sound = 'sound/weapons/handling/m79_reload.ogg'
	unload_sound = 'sound/weapons/handling/m79_unload.ogg'

	attachable_allowed = list(
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/stock/m79,
	)

/obj/item/weapon/gun/launcher/grenade/m81/m79/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/m79/S = new(src)
	S.hidden = FALSE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/launcher/grenade/m81/m79/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 9, "rail_y" = 22, "under_x" = 19, "under_y" = 14, "stock_x" = 14, "stock_y" = 14)

/obj/item/weapon/gun/launcher/grenade/m81/m79/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)//might not need this because of is_lobbing, but let's keep it just incase
	))

//-------------------------------------------------------
//M5 RPG

/obj/item/weapon/gun/launcher/rocket
	name = "\improper M5 RPG"
	desc = "The M5 RPG is the primary anti-armor weapon of the USCM. Used to take out light-tanks and enemy structures, the M5 RPG is a dangerous weapon with a variety of combat uses."
	icon_state = "m5"
	item_state = "m5"
	unacidable = TRUE
	indestructible = 1

	matter = list("metal" = 10000)
	current_mag = /obj/item/ammo_magazine/rocket
	flags_equip_slot = NO_FLAGS
	w_class = SIZE_HUGE
	force = 15
	wield_delay = WIELD_DELAY_HORRIBLE
	delay_style = WEAPON_DELAY_NO_FIRE
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	attachable_allowed = list(
		/obj/item/attachable/magnetic_harness,
	)

	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_INTERNAL_MAG
	var/datum/effect_system/smoke_spread/smoke

	flags_item = TWOHANDED|NO_CRYO_STORE
	var/skill_locked = TRUE

/obj/item/weapon/gun/launcher/rocket/Initialize(mapload, spawn_empty)
	. = ..()
	smoke = new()
	smoke.attach(src)


/obj/item/weapon/gun/launcher/rocket/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 6, "rail_y" = 19, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)


/obj/item/weapon/gun/launcher/rocket/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*2
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3


/obj/item/weapon/gun/launcher/rocket/get_examine_text(mob/user)
	. = ..()
	if(current_mag.current_rounds <= 0)
		. += "It's not loaded."
		return
	if(current_mag.current_rounds > 0)
		. += "It has an 84mm [ammo.name] loaded."


/obj/item/weapon/gun/launcher/rocket/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(skill_locked && !skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_ROCKET)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use \the [src]..."))
			return 0
		if(user.faction == FACTION_MARINE && explosive_antigrief_check(src, user))
			to_chat(user, SPAN_WARNING("\The [name]'s safe-area accident inhibitor prevents you from firing!"))
			msg_admin_niche("[key_name(user)] attempted to fire \a [name] in [get_area(src)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")
			return FALSE
		if(current_mag && current_mag.current_rounds > 0)
			make_rocket(user, 0, 1)

/obj/item/weapon/gun/launcher/rocket/load_into_chamber(mob/user)
// if(active_attachable) active_attachable = null
	return ready_in_chamber()

//No such thing
/obj/item/weapon/gun/launcher/rocket/reload_into_chamber(mob/user)
	return TRUE

/obj/item/weapon/gun/launcher/rocket/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	if(!current_mag)
		return
	qdel(projectile_to_fire)
	if(refund)
		current_mag.current_rounds++
	return TRUE

/obj/item/weapon/gun/launcher/rocket/proc/make_rocket(mob/user, drop_override = 0, empty = 1)
	if(!current_mag)
		return

	var/obj/item/ammo_magazine/rocket/r = new current_mag.type()
	//if there's ever another type of custom rocket ammo this logic should just be moved into a function on the rocket
	if(istype(current_mag, /obj/item/ammo_magazine/rocket/custom) && !empty)
		//set the custom rocket variables here.
		var/obj/item/ammo_magazine/rocket/custom/k = new /obj/item/ammo_magazine/rocket/custom
		var/obj/item/ammo_magazine/rocket/custom/cur_mag_cast = current_mag
		k.contents = cur_mag_cast.contents
		k.desc = cur_mag_cast.desc
		k.fuel = cur_mag_cast.fuel
		k.icon_state = cur_mag_cast.icon_state
		k.warhead = cur_mag_cast.warhead
		k.locked = cur_mag_cast.locked
		k.name = cur_mag_cast.name
		k.filters = cur_mag_cast.filters
		r = k

	if(empty)
		r.current_rounds = 0
	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		r.forceMove(get_turf(src)) //Drop it on the ground.
	else
		user.put_in_hands(r)
		r.update_icon()

/obj/item/weapon/gun/launcher/rocket/reload(mob/user, obj/item/ammo_magazine/rocket)
	if(!current_mag)
		return
	if(flags_gun_features & GUN_BURST_FIRING)
		return

	if(!rocket || !istype(rocket) || !istype(src, rocket.gun_type))
		to_chat(user, SPAN_WARNING("That's not going to fit!"))
		return

	if(current_mag.current_rounds > 0)
		to_chat(user, SPAN_WARNING("[src] is already loaded!"))
		return

	if(rocket.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("That frame is empty!"))
		return

	if(user)
		to_chat(user, SPAN_NOTICE("You begin reloading [src]. Hold still..."))
		if(do_after(user,current_mag.reload_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			qdel(current_mag)
			user.drop_inv_item_on_ground(rocket)
			current_mag = rocket
			rocket.forceMove(src)
			replace_ammo(,rocket)
			to_chat(user, SPAN_NOTICE("You load [rocket] into [src]."))
			if(reload_sound)
				playsound(user, reload_sound, 25, 1)
			else
				playsound(user,'sound/machines/click.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("Your reload was interrupted!"))
			return
	else
		qdel(current_mag)
		current_mag = rocket
		rocket.forceMove(src)
		replace_ammo(,rocket)
	return TRUE

/obj/item/weapon/gun/launcher/rocket/unload(mob/user,  reload_override = 0, drop_override = 0)
	if(user && current_mag)
		if(current_mag.current_rounds <= 0)
			to_chat(user, SPAN_WARNING("[src] is already empty!"))
			return
		to_chat(user, SPAN_NOTICE("You begin unloading [src]. Hold still..."))
		if(do_after(user,current_mag.reload_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			if(current_mag.current_rounds <= 0)
				to_chat(user, SPAN_WARNING("You have already unloaded \the [src]."))
				return
			playsound(user, unload_sound, 25, 1)
			user.visible_message(SPAN_NOTICE("[user] unloads [ammo] from [src]."),
			SPAN_NOTICE("You unload [ammo] from [src]."))
			make_rocket(user, drop_override, 0)
			current_mag.current_rounds = 0

//Adding in the rocket backblast. The tile behind the specialist gets blasted hard enough to down and slightly wound anyone
/obj/item/weapon/gun/launcher/rocket/apply_bullet_effects(obj/item/projectile/projectile_to_fire, mob/user, i = 1, reflex = 0)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_EAR_PROTECTION) && ishuman(user))
		var/mob/living/carbon/human/huser = user
		to_chat(user, SPAN_WARNING("Augh!! \The [src]'s launch blast resonates extremely loudly in your ears! You probably should have worn some sort of ear protection..."))
		huser.apply_effect(6, STUTTER)
		huser.emote("pain")
		huser.SetEarDeafness(max(user.ear_deaf,10))

	var/backblast_loc = get_turf(get_step(user.loc, turn(user.dir, 180)))
	smoke.set_up(1, 0, backblast_loc, turn(user.dir, 180))
	smoke.start()
	playsound(src, 'sound/weapons/gun_rocketlauncher.ogg', 100, TRUE, 10)
	for(var/mob/living/carbon/C in backblast_loc)
		if(!C.lying && !HAS_TRAIT(C, TRAIT_EAR_PROTECTION)) //Have to be standing up to get the fun stuff
			C.apply_damage(15, BRUTE) //The shockwave hurts, quite a bit. It can knock unarmored targets unconscious in real life
			C.apply_effect(4, STUN) //For good measure
			C.apply_effect(6, STUTTER)
			C.emote("pain")

//-------------------------------------------------------
//M5 RPG'S MEAN FUCKING COUSIN

/obj/item/weapon/gun/launcher/rocket/m57a4
	name = "\improper M57-A4 'Lightning Bolt' quad thermobaric launcher"
	desc = "The M57-A4 'Lightning Bolt' is possibly the most destructive man-portable weapon ever made. It is a 4-barreled missile launcher capable of burst-firing 4 thermobaric missiles. Enough said."
	icon_state = "m57a4"
	item_state = "m57a4"

	current_mag = /obj/item/ammo_magazine/rocket/m57a4
	aim_slowdown = SLOWDOWN_ADS_SUPERWEAPON
	flags_gun_features = GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/launcher/rocket/m57a4/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_5
	burst_delay = FIRE_DELAY_TIER_7
	burst_amount = BURST_AMOUNT_TIER_4
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3


//-------------------------------------------------------
//AT rocket launchers, can be used by non specs

/obj/item/weapon/gun/launcher/rocket/anti_tank //reloadable
	name = "\improper QH-4 Shoulder-Mounted Anti-Tank RPG"
	desc = "Used to take out light-tanks and enemy structures, the QH-4 is a dangerous weapon specialised against vehicles. Requires direct hits to penetrate vehicle armour."
	icon_state = "m83a2"
	item_state = "m83a2"
	unacidable = FALSE
	indestructible = FALSE
	skill_locked = FALSE

	current_mag = /obj/item/ammo_magazine/rocket/anti_tank

	attachable_allowed = list()

	flags_gun_features = GUN_WIELDED_FIRING_ONLY

	flags_item = TWOHANDED

/obj/item/weapon/gun/launcher/rocket/anti_tank/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("vehicles", /datum/element/bullet_trait_damage_boost, 20, GLOB.damage_boost_vehicles),
	))

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable //single shot and disposable
	name = "\improper M83A2 SADAR"
	desc = "The M83A2 SADAR is a lightweight one-shot anti-armour weapon capable of engaging enemy vehicles at ranges up to 1,000m. Fully disposable, the rocket's launcher is discarded after firing. When stowed (unique-action), the SADAR system consists of a watertight carbon-fiber composite blast tube, inside of which is an aluminum launch tube containing the missile. The weapon is fired by pushing a charge button on the trigger grip.  It is sighted and fired from the shoulder."
	var/fired = FALSE

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("You can fold it up with unique-action.")

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	. = ..()
	if(.)
		fired = TRUE

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/unique_action(mob/M)
	if(fired)
		to_chat(M, SPAN_WARNING("\The [src] has already been fired - you can't fold it back up again!"))
		return

	M.visible_message(SPAN_NOTICE("[M] begins to fold up \the [src]."), SPAN_NOTICE("You start to fold and collapse closed \the [src]."))

	if(!do_after(M, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_NOTICE("You stop folding up \the [src]"))
		return

	fold(M)
	M.visible_message(SPAN_NOTICE("[M] finishes folding \the [src]."), SPAN_NOTICE("You finish folding \the [src]."))

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/proc/fold(mob/user)
	var/obj/item/prop/folded_anti_tank_sadar/F = new /obj/item/prop/folded_anti_tank_sadar(src.loc)
	transfer_label_component(F)
	qdel(src)
	user.put_in_active_hand(F)

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/reload()
	to_chat(usr, SPAN_WARNING("You cannot reload \the [src]!"))
	return

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/unload()
	to_chat(usr, SPAN_WARNING("You cannot unload \the [src]!"))
	return

//folded version of the sadar
/obj/item/prop/folded_anti_tank_sadar
	name = "\improper M83 SADAR (folded)"
	desc = "An M83 SADAR Anti-Tank RPG, compacted for easier storage. Can be unfolded with the Z key."
	icon = 'icons/obj/items/weapons/guns/gun.dmi'
	icon_state = "m83a2_folded"
	w_class = SIZE_MEDIUM
	garbage = FALSE

/obj/item/prop/folded_anti_tank_sadar/attack_self(mob/user)
	user.visible_message(SPAN_NOTICE("[user] begins to unfold \the [src]."), SPAN_NOTICE("You start to unfold and expand \the [src]."))
	playsound(src, 'sound/items/component_pickup.ogg', 20, TRUE, 5)

	if(!do_after(user, 4 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(user, SPAN_NOTICE("You stop unfolding \the [src]"))
		return

	unfold(user)

	user.visible_message(SPAN_NOTICE("[user] finishes unfolding \the [src]."), SPAN_NOTICE("You finish unfolding \the [src]."))
	playsound(src, 'sound/items/component_pickup.ogg', 20, TRUE, 5)
	. = ..()

/obj/item/prop/folded_anti_tank_sadar/proc/unfold(mob/user)
	var/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/F = new /obj/item/weapon/gun/launcher/rocket/anti_tank/disposable(src.loc)
	transfer_label_component(F)
	qdel(src)
	user.put_in_active_hand(F)

//-------------------------------------------------------
//Flare gun. Close enough to a specialist gun?

/obj/item/weapon/gun/flare
	name = "\improper M82-F flare gun"
	desc = "A flare gun issued to JTAC operators to use with flares. Comes with a miniscope. One shot, one... life saved?"
	icon_state = "m82f"
	item_state = "m82f"
	current_mag = /obj/item/ammo_magazine/internal/flare
	reload_sound = 'sound/weapons/gun_shotgun_shell_insert.ogg'
	fire_sound = 'sound/weapons/gun_flare.ogg'
	aim_slowdown = 0
	flags_equip_slot = SLOT_WAIST
	wield_delay = WIELD_DELAY_VERY_FAST
	movement_onehanded_acc_penalty_mult = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	flags_gun_features = GUN_INTERNAL_MAG|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_HANDGUN
	attachable_allowed = list(/obj/item/attachable/scope/mini/flaregun)

	var/last_signal_flare_name


/obj/item/weapon/gun/flare/Initialize(mapload, spawn_empty)
	. = ..()
	if(spawn_empty)
		update_icon()

/obj/item/weapon/gun/flare/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/flaregun/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachables()


/obj/item/weapon/gun/flare/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 20, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/flare/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = 0
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/flare/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/flare/reload_into_chamber(mob/user)
	. = ..()
	to_chat(user, SPAN_WARNING("You pop out [src]'s tube!"))
	update_icon()

/obj/item/weapon/gun/flare/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/F = I
		if(F.on)
			to_chat(user, SPAN_WARNING("You can't put a lit flare in [src]!"))
			return
		if(!F.fuel)
			to_chat(user, SPAN_WARNING("You can't put a burnt out flare in [src]!"))
			return
		if(current_mag && current_mag.current_rounds == 0)
			ammo = GLOB.ammo_list[F.ammo_datum]
			playsound(user, reload_sound, 25, 1)
			to_chat(user, SPAN_NOTICE("You load \the [F] into [src]."))
			current_mag.current_rounds++
			qdel(I)
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] is already loaded!"))
	else
		to_chat(user, SPAN_WARNING("That's not a flare!"))

/obj/item/weapon/gun/flare/unload(mob/user)
	if(flags_gun_features & GUN_BURST_FIRING)
		return
	unload_flare(user)

/obj/item/weapon/gun/flare/proc/unload_flare(mob/user)
	if(!current_mag)
		return
	if(current_mag.current_rounds)
		var/obj/item/device/flashlight/flare/unloaded_flare = new ammo.handful_type(get_turf(src))
		playsound(user, reload_sound, 25, TRUE)
		current_mag.current_rounds--
		if(user)
			to_chat(user, SPAN_NOTICE("You unload \the [unloaded_flare] from \the [src]."))
			user.put_in_hands(unloaded_flare)
		update_icon()

/obj/item/weapon/gun/flare/unique_action(mob/user)
	if(!user || !isturf(user.loc) || !current_mag || !current_mag.current_rounds)
		return

	var/turf/flare_turf = user.loc
	var/area/flare_area = flare_turf.loc

	if(flare_area.ceiling > CEILING_GLASS)
		to_chat(user, SPAN_NOTICE("The roof above you is too dense."))
		return

	if(!istype(ammo, /datum/ammo/flare))
		to_chat(user, SPAN_NOTICE("\The [src] jams as it is somehow loaded with incorrect ammo!"))
		return

	if(user.action_busy)
		return

	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	current_mag.current_rounds--

	flare_turf.ceiling_debris()

	var/datum/ammo/flare/explicit_ammo = ammo

	var/obj/item/device/flashlight/flare/fired_flare = new explicit_ammo.flare_type(get_turf(src))
	to_chat(user, SPAN_NOTICE("You fire \the [fired_flare] into the air!"))
	fired_flare.visible_message(SPAN_WARNING("\A [fired_flare] bursts into brilliant light in the sky!"))
	fired_flare.invisibility = INVISIBILITY_MAXIMUM
	fired_flare.mouse_opacity = FALSE
	playsound(user.loc, fire_sound, 50, 1)

	if(fired_flare.activate_signal(user))
		last_signal_flare_name = fired_flare.name

	update_icon()

/obj/item/weapon/gun/flare/get_examine_text(mob/user)
	. = ..()
	if(last_signal_flare_name)
		. += SPAN_NOTICE("The last signal flare fired has the designation: [last_signal_flare_name]")
