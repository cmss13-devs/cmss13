//-------------------------------------------------------
//GRENADE LAUNCHER

/obj/item/weapon/gun/launcher/grenade //Parent item for GLs.
	w_class = SIZE_LARGE
	throw_speed = SPEED_SLOW
	throw_range = 10
	force = 5

	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/grenade_launchers.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/grenade_launchers.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/grenade_launchers_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/grenade_launchers_righthand.dmi'
	)

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
	var/disallowed_grenade_types = list(/obj/item/explosive/grenade/spawnergrenade,
										/obj/item/explosive/grenade/alien,
										/obj/item/explosive/grenade/nerve_gas,
										/obj/item/explosive/grenade/incendiary/bursting_pipe,
										/obj/item/explosive/grenade/xeno_acid_grenade,
										/obj/item/explosive/grenade/incendiary/molotov,
										/obj/item/explosive/grenade/flashbang)
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
	if(!cylinder.can_be_inserted(I, user)) //Technically includes whether there's room for it, but the above gives a tailored message.
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
			msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
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

	var/angle = floor(Get_Angle(user,target))
	muzzle_flash(angle,user)
	simulate_recoil(0, user)

	var/obj/item/explosive/grenade/fired = cylinder.contents[1]
	cylinder.remove_from_storage(fired, user.loc)
	var/pass_flags = NO_FLAGS
	if(is_lobbing)
		if(istype(fired, /obj/item/explosive/grenade/slug/baton))
			if(ishuman(user))
				var/mob/living/carbon/human/human_user = user
				human_user.remember_dropped_object(fired)
				fired.fingerprintslast = key_name(user)
			pass_flags |= PASS_MOB_THRU_HUMAN|PASS_MOB_IS_OTHER|PASS_OVER
		else
			pass_flags |= PASS_MOB_THRU|PASS_HIGH_OVER

	msg_admin_attack("[key_name_admin(user)] fired a grenade ([fired.name]) from \a ([name]).")
	log_game("[key_name_admin(user)] used a grenade ([name]).")

	fired.throw_range = 20
	fired.det_time = min(10, fired.det_time)
	fired.activate(user, FALSE)
	fired.forceMove(get_turf(src))
	fired.throw_atom(target, 20, SPEED_VERY_FAST, user, null, NORMAL_LAUNCH, pass_flags)



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
	. = ..()
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
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/grenade_launchers.dmi'
	icon_state = "m92"
	item_state = "m92"
	unacidable = TRUE
	explo_proof = TRUE
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
	set_fire_delay(FIRE_DELAY_TIER_4*4)

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
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony/grenade_launchers.dmi'
	icon_state = "m81"
	item_state = "m81" //needs a wield sprite.

	matter = list("metal" = 7000)

/obj/item/weapon/gun/launcher/grenade/m81/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 14, "rail_y" = 22, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/launcher/grenade/m81/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_4 * 1.5)

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
	desc = "A lightweight, single-shot low-angle grenade launcher designed to launch non-lethal or concussive ammunition. Used by the Colonial Marines Military Police during riots."
	valid_munitions = list(
		/obj/item/explosive/grenade/custom/teargas,
		/obj/item/explosive/grenade/slug/baton,
		/obj/item/explosive/grenade/smokebomb,
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/flashbang,
	)
	preload = /obj/item/explosive/grenade/slug/baton
	disallowed_grenade_types = list(/obj/item/explosive/grenade/spawnergrenade, /obj/item/explosive/grenade/alien, /obj/item/explosive/grenade/incendiary/molotov)

//-------------------------------------------------------
//M79 Grenade Launcher subtype of the M81

/obj/item/weapon/gun/launcher/grenade/m81/m79//m79 variant for marines
	name = "\improper M79 grenade launcher"
	desc = "A heavy, low-angle 40mm grenade launcher. It's been in use since the Vietnam War, though this version has been modernized with an IFF enabled micro-computer. The wooden furniture is, in fact, made of painted hardened polykevlon."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/grenade_launchers.dmi'
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
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18, "rail_x" = 11, "rail_y" = 21, "under_x" = 19, "under_y" = 14, "stock_x" = 14, "stock_y" = 14)

/obj/item/weapon/gun/launcher/grenade/m81/m79/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)//might not need this because of is_lobbing, but let's keep it just incase
	))
