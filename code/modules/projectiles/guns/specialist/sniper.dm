//-------------------------------------------------------
//SNIPER RIFLES
//Keyword rifles. They are subtype of rifles, but still contained here as a specialist weapon.

//Because this parent type did not exist
//Note that this means that snipers will have a slowdown of 3, due to the scope
/obj/item/weapon/gun/rifle/sniper
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/marksman_rifles.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/marksman_rifles.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/marksman_rifles_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/marksman_rifles_righthand.dmi'
	)
	mouse_pointer = 'icons/effects/mouse_pointer/sniper_mouse.dmi'

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

	/// Variables for Focus Fire and alternate icons for lockon and laser.
	var/enable_aimed_shot_icon_alt = FALSE
	var/sniper_lockon_icon_max = "sniper_lockon_intense"
	var/sniper_beam_icon_max = "laser_beam_intense"

/obj/item/weapon/gun/rifle/sniper/get_examine_text(mob/user)
	. = ..()
	if(!has_aimed_shot)
		return
	. += SPAN_NOTICE("This weapon has a special ability, Aimed Shot, allowing it to deal increased damage and inflict additional crippling effects after a windup, depending on the ammunition used.<br><b> Additionally, the aimed shot can be sped up with a spotter or by using the tracking laser, which is enabled by default but may be disabled.</b>")

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

/*
		ACTIONS SPECIALSIT SNIPER CAN TAKE
*/
/datum/action/item_action/specialist/aimed_shot/action_activate()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.selected_ability == src)
		to_chat(H, "You will no longer use [name] with [H.get_ability_mouse_name()].")
		button.icon_state = "template"
		H.set_selected_ability(null)
	else
		to_chat(H, "You will now use [name] with [H.get_ability_mouse_name()].")
		if(H.selected_ability)
			H.selected_ability.button.icon_state = "template"
			H.set_selected_ability(null)
		button.icon_state = "template_on"
		H.set_selected_ability(src)

/datum/action/item_action/specialist/aimed_shot/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && (holder_item == H.r_hand || holder_item || H.l_hand))
		return TRUE

/datum/action/item_action/specialist/aimed_shot/proc/use_ability(atom/A)
	var/mob/living/carbon/human/human = owner
	if(!istype(A, /mob/living))
		return

	var/mob/living/target = A

	if(target.stat == DEAD || target == human)
		return

	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item
	if(world.time < sniper_rifle.aimed_shot_cooldown || !sniper_rifle.able_to_fire(human))
		return

	if(!check_can_use(target))
		return

	human.face_atom(target)

	///Add a decisecond to the default 1.5 seconds for each two tiles to hit.
	var/distance = floor(get_dist(target, human) * 0.5)
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

	var/beam
	var/lockon

	if(istype(sniper_rifle, /obj/item/weapon/gun/rifle/sniper/XM43E1))
		var/obj/item/weapon/gun/rifle/sniper/XM43E1/amr = sniper_rifle
		if(amr.focused_fire_counter == 1 && target == amr.focused_fire_target?.resolve())
			sniper_rifle.enable_aimed_shot_icon_alt = TRUE
		else
			sniper_rifle.enable_aimed_shot_icon_alt = FALSE

	if(sniper_rifle.enable_aimed_shot_icon_alt)
		beam = sniper_rifle.sniper_beam_icon_max
		lockon = sniper_rifle.sniper_lockon_icon_max
	else
		beam = sniper_rifle.sniper_beam_icon
		lockon = sniper_rifle.sniper_lockon_icon

	var/image/lockon_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = lockon)

	var/x_offset =  -target.pixel_x + target.base_pixel_x
	var/y_offset = (target.icon_size - world.icon_size) * 0.5 - target.pixel_y + target.base_pixel_y

	lockon_icon.pixel_x = x_offset
	lockon_icon.pixel_y = y_offset
	target.overlays += lockon_icon

	var/image/lockon_direction_icon
	if(!sniper_rifle.enable_aimed_shot_laser)
		lockon_direction_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "[lockon]_direction", dir = get_cardinal_dir(target, human))
		lockon_direction_icon.pixel_x = x_offset
		lockon_direction_icon.pixel_y = y_offset
		target.overlays += lockon_direction_icon
	if(human.client)
		playsound_client(human.client, 'sound/weapons/TargetOn.ogg', human, 50)
	playsound(target, 'sound/weapons/TargetOn.ogg', 70, FALSE, 8, falloff = 0.4)

	var/datum/beam/laser_beam
	if(sniper_rifle.enable_aimed_shot_laser)
		laser_beam = target.beam(human, beam, 'icons/effects/beam.dmi', (f_aiming_time + 1 SECONDS), beam_type = sniper_rifle.sniper_beam_type)
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

	if(!check_can_use(target, TRUE) || target.is_dead() || !sniper_rifle.able_to_fire(human))
		return

	var/obj/projectile/aimed_proj = sniper_rifle.in_chamber
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

	var/obj/projectile/P = sniper_rifle.in_chamber
	// TODO: Make the below logic only occur in certain circumstances. Check goggles, maybe? -Kaga
	if(check_shot_is_blocked(H, M, P))
		to_chat(H, SPAN_WARNING("Something is in the way, or you're out of range!"))
		if(cover_lose_focus)
			to_chat(H, SPAN_WARNING("You lose focus."))
			COOLDOWN_START(sniper_rifle, aimed_shot_cooldown, sniper_rifle.aimed_shot_cooldown_delay * 0.5)
		return FALSE

	COOLDOWN_START(sniper_rifle, aimed_shot_cooldown, sniper_rifle.aimed_shot_cooldown_delay)
	return TRUE

/datum/action/item_action/specialist/aimed_shot/proc/check_shot_is_blocked(mob/firer, mob/target, obj/projectile/P)
	var/list/turf/path = get_line(firer, target, include_start_atom = FALSE)
	if(!length(path) || get_dist(firer, target) > P.ammo.max_range)
		return TRUE

	var/blocked = FALSE
	for(var/turf/T in path)
		if(T.density && T.opacity)
			blocked = TRUE
			break

		for(var/obj/O in T)
			if(O.get_projectile_hit_boolean(P) && O.opacity)
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
	. = ..()
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

/obj/item/weapon/gun/rifle/sniper/verb/toggle_gun_laser()
	set category = "Weapons"
	set name = "Toggle Laser"
	set desc = "Toggles your laser on or off."
	set src = usr.contents

	var/obj/item/weapon/gun/rifle/sniper/sniper = get_active_firearm(usr)
	if((sniper == src) && has_aimed_shot)
		toggle_laser(usr)

//Pow! Headshot.

// end of actions sniper spe can take.

/obj/item/weapon/gun/rifle/sniper/M42A
	name = "\improper M42A scoped rifle"
	desc = "A heavy sniper rifle manufactured by Armat Systems. It has a scope system and fires armor penetrating rounds out of a 15-round magazine.\n'Peace Through Superior Firepower'"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/marksman_rifles.dmi'
	icon_state = "m42a"
	item_state = "m42a"
	unacidable = TRUE
	explo_proof = TRUE

	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/sniper
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	map_specific_decoration = TRUE

	flags_item = TWOHANDED|NO_CRYO_STORE
	pixel_x = -6
	hud_offset = -6

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
	set_fire_delay(FIRE_DELAY_TIER_SNIPER)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3 + HIT_ACCURACY_MULT_TIER_3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_NONE
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/sniper/XM43E1
	name = "\improper XM43E1 experimental anti-materiel rifle"
	desc = "An experimental anti-materiel rifle produced by Armat Systems, recently reacquired from the deep storage of an abandoned prototyping facility. This one in particular is currently undergoing field testing. Chambered in 10x99mm Caseless.\n\nThis weapon can punch through thin metal plating and walls, though it'll lose most of its lethality in the process. It can even work for demolitions, with experienced users known to disassemble segments of solid, reinforced walls in the field with just a single standard magazine of 10x99mm. In lieu of explosives or an engineer, they instead use each of the 8 shots to break down vital structural supports, taking the wall apart in the process."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/marksman_rifles.dmi'
	icon_state = "xm43e1"
	item_state = "xm43e1"
	unacidable = TRUE
	explo_proof = TRUE
	aiming_time = 2 SECONDS
	aimed_shot_cooldown_delay = 4.5 SECONDS
	var/focused_fire_counter = 0
	var/datum/weakref/focused_fire_target = null

	fire_sound = 'sound/weapons/sniper_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/anti_materiel //Renamed from anti-tank to align with new identity/description. Other references have been changed as well. -Kaga
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	sniper_beam_type = /obj/effect/ebeam/laser
	sniper_beam_icon = "laser_beam"
	sniper_lockon_icon = "sniper_lockon"
	pixel_x = -4
	hud_offset = -4

/obj/item/weapon/gun/rifle/sniper/XM43E1/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/variable_zoom/S = new(src)
	S.icon_state = "pmcscope"
	S.attach_icon = "pmcscope"
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/sniper/XM43E1/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 15, "rail_y" = 19, "under_x" = 20, "under_y" = 15, "stock_x" = 20, "stock_y" = 15)


/obj/item/weapon/gun/rifle/sniper/XM43E1/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_AMR)//Big boy damage, but it takes a lot of time to fire a shot.
	//Kaga: Fixed back to half the M42A's firerate (3 seconds), using a new define.
	//This outright deals less DPS than the normal sniper rifle, 125 vs 140 per 3s.
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT + 2*(HIT_ACCURACY_MULT_TIER_10 + HIT_ACCURACY_MULT_TIER_2) - HIT_ACCURACY_MULT_TIER_1//Who coded this like this, and why? It just calculates out to 1+1=2. Leaving a note here to check back later.
	scatter = SCATTER_AMOUNT_NONE
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/rifle/sniper/XM43E1/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff),
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 11, GLOB.damage_boost_turfs),
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 11, GLOB.damage_boost_breaching),
		//At 1375 per shot it'll take 1 shot to break resin turfs usually (thick resin at 1350, RNG may vary), and a full mag of 8 to break reinforced walls.
		//However, the second wall it hits will only take 550 damage, unable to even kill a full-health normal resin wall (900).
		//Much more effective at breaking resin doors and membranes, which have less HP and slow down the projectile less.
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
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/WY/marksman_rifles.dmi'
	icon_state = "m42c"
	item_state = "m42c" //NEEDS A TWOHANDED STATE

	fire_sound = 'sound/weapons/sniper_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/elite
	force = 17
	zoomdevicename = "scope"
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	sniper_beam_type = /obj/effect/ebeam/laser/intense
	sniper_beam_icon = "laser_beam_intense"
	sniper_lockon_icon = "sniper_lockon_intense"

/obj/item/weapon/gun/rifle/sniper/elite/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.icon_state = "pmcscope"
	S.attach_icon = "pmcscope"
	S.flags_attach_features &= ~ATTACH_REMOVABLE
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
	set_fire_delay(FIRE_DELAY_TIER_6*5)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3 + HIT_ACCURACY_MULT_TIER_3 //Was previously BAM + HAMT10, similar to the XM42B, and coming out to 1.5? Changed to be consistent with M42A. -Kaga
	scatter = SCATTER_AMOUNT_NONE
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/rifle/sniper/elite/simulate_recoil(total_recoil = 0, mob/user, atom/target)
	. = ..()
	if(.)
		var/mob/living/carbon/human/PMC_sniper = user
		if(PMC_sniper.body_position == STANDING_UP && !istype(PMC_sniper.wear_suit,/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc) && !istype(PMC_sniper.wear_suit,/obj/item/clothing/suit/storage/marine/veteran))
			PMC_sniper.visible_message(SPAN_WARNING("[PMC_sniper] is blown backwards from the recoil of the [src.name]!"),SPAN_HIGHDANGER("You are knocked prone by the blowback!"))
			step(PMC_sniper,turn(PMC_sniper.dir,180))
			PMC_sniper.KnockDown(5)
			PMC_sniper.Stun(5)

//Type 88 //Based on the actual Dragunov DMR rifle.

/obj/item/weapon/gun/rifle/sniper/svd
	name = "\improper Type 88 designated marksman rifle"
	desc = "The standard issue DMR of the UPP, the Type 88 is sought after by competitive shooters and terrorists alike for its high degree of accuracy. Typically loaded with armor-piercing 7.62x54mmR rounds in a 12 round magazine."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/UPP/marksman_rifles.dmi'
	icon_state = "type88"
	item_state = "type88"

	pixel_x = -6
	hud_offset = -6

	fire_sound = 'sound/weapons/gun_mg.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/svd
	attachable_allowed = list(
		//Muzzle,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp_replica,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/antique,
		/obj/item/attachable/bayonet/wy,
		/obj/item/attachable/bayonet/custom,
		/obj/item/attachable/bayonet/custom/red,
		/obj/item/attachable/bayonet/custom/blue,
		/obj/item/attachable/bayonet/custom/black,
		/obj/item/attachable/bayonet/tanto,
		/obj/item/attachable/bayonet/tanto/blue,
		/obj/item/attachable/bayonet/rmc_replica,
		/obj/item/attachable/bayonet/rmc,
		//Under,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/bipod,
	)
	has_aimed_shot = FALSE
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_CAN_POINTBLANK
	starting_attachment_types = list()
	sniper_beam_type = null
	skill_locked = FALSE

/obj/item/weapon/gun/rifle/sniper/svd/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/variable_zoom/integrated/type88sight = new(src)
	type88sight.flags_attach_features &= ~ATTACH_REMOVABLE
	type88sight.hidden = TRUE
	type88sight.Attach(src)
	update_attachable(type88sight.slot)

/obj/item/weapon/gun/rifle/sniper/svd/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 13, "rail_y" = 19, "under_x" = 26, "under_y" = 14, "stock_x" = 24, "stock_y" = 13, "special_x" = 39, "special_y" = 18)

/obj/item/weapon/gun/rifle/sniper/svd/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	damage_falloff_mult = 0
