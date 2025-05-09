
// Bolt Action Rifle Code, credit to Alardun and Optimisticdude. This is for bolt action rifles which use external magazines, such as the AWM International, rather than internally fed rifles such as the Mosin-Nagant.
// For internally fed bolt actions, it'd be more advised to use pump shotgun code, or obj/item/weapon/gun/shotgun/pump, to create that type of variant of bolt action rifle.

/obj/item/weapon/gun/boltaction
	name = "\improper Basira-Armstrong bolt-action hunting rifle"
	desc = "Named after its eccentric designers, the Basira-Armstrong is a cheap but reliable civilian bolt-action rifle frequently found in the outer colonies. Despite its legally-mandated limited magazine capacity, its light weight and legendary accuracy makes it popular among hunters and competitive shooters."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony/marksman_rifles.dmi'
	icon_state = "boltaction"
	item_state = "hunting"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/marksman_rifles.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/marksman_rifles.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/marksman_rifles_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/marksman_rifles_righthand.dmi'
	)
	mouse_pointer = 'icons/effects/mouse_pointer/sniper_mouse.dmi'

	pixel_x = -6
	hud_offset = -6

	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	force = 5
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY
	gun_category = GUN_CATEGORY_RIFLE
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	wield_delay = WIELD_DELAY_NORMAL
	current_mag = /obj/item/ammo_magazine/rifle/boltaction
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/antique,
		/obj/item/attachable/bayonet/custom,
		/obj/item/attachable/bayonet/wy,
		/obj/item/attachable/bayonet/custom/red,
		/obj/item/attachable/bayonet/custom/blue,
		/obj/item/attachable/bayonet/custom/black,
		/obj/item/attachable/bayonet/tanto,
		/obj/item/attachable/bayonet/tanto/blue,
		/obj/item/attachable/bayonet/rmc_replica,
		/obj/item/attachable/bayonet/rmc,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini/hunting,
	)
	starting_attachment_types = list(/obj/item/attachable/scope/mini/hunting)
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	wield_delay = WIELD_DELAY_NORMAL
	civilian_usable_override = TRUE
	unacidable = TRUE // Like other 1-of-a-kind weapons, it can't be gotten rid of that fast
	explo_proof = TRUE

	cocked_sound = 'sound/weapons/gun_cocked2.ogg'
	fire_sound = 'sound/weapons/gun_boltaction.ogg'
	var/open_bolt_sound ='sound/weapons/handling/gun_boltaction_open.ogg'
	var/close_bolt_sound ='sound/weapons/handling/gun_boltaction_close.ogg'

	var/bolted = TRUE // FALSE IS OPEN, TRUE IS CLOSE
	var/bolt_delay
	var/recent_cycle //world.time to see when they last bolted it.
	/// If this gun should change icon states when the bolt is open
	var/has_openbolt_icon = TRUE

/obj/item/weapon/gun/boltaction/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 45, "muzzle_y" = 17,"rail_x" = 18, "rail_y" = 18, "under_x" = 38, "under_y" = 14, "stock_x" = 20, "stock_y" = 9)

/obj/item/weapon/gun/boltaction/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()
	bolt_delay = FIRE_DELAY_TIER_5

/obj/item/weapon/gun/boltaction/update_icon() // needed for bolt action sprites
	..()

	var/new_icon_state = icon_state
	if(!bolted && has_openbolt_icon)
		new_icon_state += "_o"

	icon_state = new_icon_state

/obj/item/weapon/gun/boltaction/set_gun_config_values()
	..()
	set_burst_amount(0)
	set_fire_delay(FIRE_DELAY_TIER_4)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10 - HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	movement_onehanded_acc_penalty_mult = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8
	recoil = RECOIL_OFF
	recoil_unwielded = RECOIL_AMOUNT_TIER_0

/obj/item/weapon/gun/boltaction/unique_action(mob/user)
	if(world.time < (recent_cycle + bolt_delay) )  //Don't spam it.
		to_chat(user, SPAN_DANGER("You can't cycle the bolt again right now."))
		return

	bolted = !bolted

	if(bolted)
		to_chat(user, SPAN_DANGER("You close the bolt of [src]!"))
		playsound(get_turf(src), open_bolt_sound, 15, TRUE, 1)
		ready_in_chamber()
		recent_cycle = world.time
	else
		to_chat(user, SPAN_DANGER("You open the bolt of [src]!"))
		playsound(get_turf(src), close_bolt_sound, 65, TRUE, 1)
		unload_chamber(user)

	update_icon()

/obj/item/weapon/gun/boltaction/able_to_fire(mob/user)
	. = ..()

	if(. && !bolted)
		to_chat(user, SPAN_WARNING("The bolt is still open, you can't fire [src]."))
		return FALSE

/obj/item/weapon/gun/boltaction/load_into_chamber(mob/user)
	return in_chamber

/obj/item/weapon/gun/boltaction/reload_into_chamber(mob/user)
	in_chamber = null
	return TRUE

/obj/item/weapon/gun/boltaction/cock(mob/user)
	return

/obj/item/weapon/gun/boltaction/replace_magazine(mob/user, obj/item/ammo_magazine/magazine) //mostly standard but without the cock-and-load if unchambered.
	user.drop_inv_item_to_loc(magazine, src) //Click!
	current_mag = magazine
	replace_ammo(user,magazine)
	user.visible_message(SPAN_NOTICE("[user] loads [magazine] into [src]!"),
		SPAN_NOTICE("You load [magazine] into [src]!"), null, 3, CHAT_TYPE_COMBAT_ACTION)
	if(reload_sound)
		playsound(user, reload_sound, 25, 1, 5)


/obj/item/weapon/gun/boltaction/vulture
	name = "\improper M707 \"Vulture\" anti-materiel rifle"
	desc = "The M707 is a crude but highly powerful rifle, designed for disabling lightly armored vehicles and hitting targets inside buildings. Its unwieldy scope and caliber necessitates a spotter to be fully effective, suffering severe scope drift without one."
	desc_lore = {"
		Put into production in 2175 as an economical answer to rising militancy in the Outer Rim, the M707 was derived from jury-rigged anti-materiel rifles that were captured during the Linna 349 campaign.

		The rebels (colloquially known among the USCMC as bug-boys and beebops) had achieved extensive success at Neusheune using the aforementioned rifles to pick off incinerator-wielding marines by detonating their napthal fuel tank in the midst of squad formations, subsequently leading to the USCMC designating users of those rifles as high-priority targets, as well as changes in USCMC patrol tactics.

		Some of the failings and quirks of the beebops' jury-rigged rifle were quickly noticed by vehicle crews early on in the campaign, as in multiple memoirs the crews mention that: "Once the rain starts, that's when you know you've got an ambush."

		The 'pitter-patter' of 'rain' that the crews heard was in fact multiple rifles failing to penetrate through the vehicle's external armor. Once a number of the anti-materiel rifles were examined, it was deemed a high priority to produce a Corps version. In the process, the rifles were designed for a higher calibre then that of the rebel versions, so the M707 would be capable of penetrating the light vehicle armor of their UPP peers in the event of another Dog War or Tientsin."}

	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/marksman_rifles.dmi' // overridden with camos
	icon_state = "vulture"
	item_state = "vulture"
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'
	fire_sound = 'sound/weapons/gun_vulture_fire.ogg'
	open_bolt_sound ='sound/weapons/handling/gun_vulture_bolt_eject.ogg'
	close_bolt_sound ='sound/weapons/handling/gun_vulture_bolt_close.ogg'
	flags_equip_slot = SLOT_BACK|SLOT_BLOCK_SUIT_STORE
	w_class = SIZE_LARGE
	force = 5
	flags_gun_features = NONE
	gun_category = GUN_CATEGORY_HEAVY
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST // Consider SUPERWEAPON, but it's not like you can fire this without being bipodded
	wield_delay = WIELD_DELAY_VERY_SLOW
	map_specific_decoration = TRUE
	current_mag = /obj/item/ammo_magazine/rifle/boltaction/vulture
	attachable_allowed = list(
		/obj/item/attachable/vulture_scope,
		/obj/item/attachable/bipod/vulture,
	)
	starting_attachment_types = list(
		/obj/item/attachable/vulture_scope,
		/obj/item/attachable/bipod/vulture,
	)
	civilian_usable_override = FALSE
	projectile_type = /obj/projectile/vulture
	actions_types = list(
		/datum/action/item_action/vulture,
	)
	has_openbolt_icon = FALSE
	bolt_delay = 1 SECONDS
	/// How far out people can tell the direction of the shot
	var/fire_message_range = 25
	/// If the gun should bypass the trait requirement
	var/bypass_trait = FALSE

/obj/item/weapon/gun/boltaction/vulture/update_icon()
	..()
	var/new_icon_state = src::icon_state
	if(!current_mag)
		new_icon_state += "_e"

	icon_state = new_icon_state

	if(!bolted)
		overlays += "vulture_bolt_open"


/obj/item/weapon/gun/boltaction/vulture/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_VULTURE)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_NONE - SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	damage_falloff_mult = 0

/obj/item/weapon/gun/boltaction/vulture/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 39, "muzzle_y" = 19, "rail_x" = 17, "rail_y" = 24, "under_x" = 31, "under_y" = 14, "stock_x" = 11, "stock_y" = 15)

/obj/item/weapon/gun/boltaction/vulture/able_to_fire(mob/user)
	if(!bypass_trait && !HAS_TRAIT(user, TRAIT_VULTURE_USER))
		to_chat(user, SPAN_WARNING("You don't know how to use this!"))
		return FALSE

	return ..()

/obj/item/weapon/gun/boltaction/vulture/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	var/obj/item/attachable/vulture_scope/scope = attachments["rail"]
	if(istype(scope) && scope.scoping)
		var/turf/viewed_turf = scope.get_viewed_turf()
		target = viewed_turf
		var/mob/living/living_mob = locate(/mob/living) in viewed_turf
		if(living_mob)
			target = living_mob

	. = ..()
	if(!.)
		return .

	for(var/mob/current_mob as anything in get_mobs_in_z_level_range(get_turf(user), fire_message_range) - user)
		var/relative_dir = Get_Compass_Dir(current_mob, user)
		var/final_dir = dir2text(relative_dir)
		to_chat(current_mob, SPAN_HIGHDANGER("You hear a massive boom coming from [final_dir ? "the [final_dir]" : "nearby"]!"))
		if(current_mob.client)
			playsound_client(current_mob.client, 'sound/weapons/gun_vulture_report.ogg', src, 25)

	if(!HAS_TRAIT(src, TRAIT_GUN_BIPODDED))
		fired_without_bipod(user)
	else
		shake_camera(user, 3, 4) // equivalent to getting hit with a heavy round

	return .

/// Someone tried to fire this without using a bipod, so we break their arm along with sending them flying backwards
/obj/item/weapon/gun/boltaction/vulture/proc/fired_without_bipod(mob/living/user)
	SEND_SIGNAL(src, COMSIG_GUN_VULTURE_FIRED_ONEHAND)
	to_chat(user, SPAN_HIGHDANGER("You get flung backwards as you fire [src], breaking your firing arm in the process!"))
	user.apply_effect(0.7, WEAKEN)
	user.apply_effect(1, SUPERSLOW)
	user.apply_effect(2, SLOW)

	if(ishuman(user))
		if(user.hand)
			break_arm(user, RIGHT)
		else
			break_arm(user, LEFT)

	//Either knockback or slam them into an obstacle.
	var/direction = REVERSE_DIR(user.dir)
	if(direction && !step(user, direction))
		user.animation_attack_on(get_step(user, direction))
		user.visible_message(SPAN_DANGER("[user] slams into an obstacle!"), SPAN_HIGHDANGER("You slam into an obstacle!"), null, 4, CHAT_TYPE_TAKING_HIT)
		user.apply_damage(MELEE_FORCE_TIER_2)

	shake_camera(user, 7, 6) // Around 2x worse than getting hit with a heavy round

/// The code that takes care of breaking a person's firing arm
/obj/item/weapon/gun/boltaction/vulture/proc/break_arm(mob/living/carbon/human/user, arm = LEFT)
	var/obj/limb/arm/found_limb
	var/obj/limb/hand/found_hand
	if(arm == LEFT)
		found_limb = locate(/obj/limb/arm/l_arm) in user.limbs
		found_hand = locate(/obj/limb/hand/l_hand) in user.limbs
	else
		found_limb = locate(/obj/limb/arm/r_arm) in user.limbs
		found_hand = locate(/obj/limb/hand/r_hand) in user.limbs

	if(!found_limb || !found_hand)
		return
	found_limb.take_damage((found_limb.status & LIMB_BROKEN) ? rand(25, 30) : rand(10, 15))
	found_hand.take_damage((found_hand.status & LIMB_BROKEN) ? rand(25, 30) : rand(10, 15))
	found_limb.fracture(100)
	found_hand.fracture(100)

	for(var/obj/limb/limb as anything in list(found_limb, found_hand))
		if(!(limb.status & LIMB_SPLINTED_INDESTRUCTIBLE) && (limb.status & LIMB_SPLINTED)) //If they have it splinted, the splint won't hold.
			limb.status &= ~LIMB_SPLINTED
			playsound(user, 'sound/items/splintbreaks.ogg', 20)
			to_chat(user, SPAN_DANGER("The splint on your [limb.display_name] comes apart under the recoil!"))
			user.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)
			user.update_med_icon()


/obj/item/weapon/gun/boltaction/vulture/skillless
	bypass_trait = TRUE

/obj/item/weapon/gun/boltaction/vulture/holo_target
	current_mag = /obj/item/ammo_magazine/rifle/boltaction/vulture/holo_target

/obj/item/weapon/gun/boltaction/vulture/holo_target/skillless
	bypass_trait = TRUE
