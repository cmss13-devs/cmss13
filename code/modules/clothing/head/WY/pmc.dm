//=============================//PMCS\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE //Let's make these keep their name and icon.
	built_in_visors = list()

/obj/item/clothing/head/helmet/marine/veteran/pmc
	name = "\improper PMC tactical cap"
	desc = "A protective cap made from flexible kevlar. Standard issue for most security forms in the place of a helmet."
	icon_state = "pmc_hat"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/WY.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/WY.dmi',
	)
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

	camera_factions = FACTION_LIST_WY

/obj/item/clothing/head/helmet/marine/veteran/pmc/black
	name = "\improper PMC black tactical cap"
	icon_state = "pmc_hat_dark"

/obj/item/clothing/head/helmet/marine/veteran/pmc/leader
	name = "\improper PMC beret"
	desc = "The pinnacle of fashion for any aspiring mercenary leader. Designed to protect the head from light impacts."
	icon_state = "officer_hat"

/obj/item/clothing/head/helmet/marine/veteran/pmc/sec
	name = "\improper W-Y armored cap"
	icon_state = "newcorpo_cap"

/obj/item/clothing/head/helmet/marine/veteran/pmc/sniper
	name = "\improper PMC sniper helmet"
	desc = "A helmet worn by PMC Marksmen."
	icon_state = "pmc_sniper_hat"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed
	name = "\improper PMC helmet"
	desc = "A standard enclosed helmet utilized by Weyland-Yutani PMC."
	icon_state = "pmc_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = ARMOR_LAMP_OVERLAY
	light_color = LIGHT_COLOR_FLARE
	light_power = 3
	light_range = 4
	light_system = MOVABLE_LIGHT
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	var/atom/movable/marine_light/light_holder
	var/flashlight_cooldown = 0 //Cooldown for toggling the light

/datum/action/item_action/toggle_helmet_light

/datum/action/item_action/toggle_helmet_light/New()
	..()
	name = "Toggle Headlight"
	button.name = name

/datum/action/item_action/toggle_helmet_light/action_activate()
	. = ..()
	var/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/light = holder_item
	var/mob/living/carbon/human/human_owner = owner

	if(!isturf(human_owner.loc))
		to_chat(human_owner, SPAN_WARNING("You cannot turn the light [light.light_on ? "off" : "on"] while in [human_owner.loc].")) //To prevent some lighting anomalies.
		return

	if(light.flashlight_cooldown > world.time)
		return

	if(!ishuman(human_owner))
		return

	light.turn_light(human_owner, !light.light_on)

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/Initialize()
	. = ..()
	light_holder = new(src)
	update_icon()

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/Destroy()
	QDEL_NULL(light_holder)
	return ..()

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/update_icon(mob/user)
	if(flags_marine_helmet & ARMOR_LAMP_OVERLAY)
		if(flags_marine_helmet & ARMOR_LAMP_ON)
			icon_state = initial(icon_state) + "_on"
		else
			icon_state = initial(icon_state)
	if(user)
		user.update_inv_head()

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/turn_light(mob/user, toggle_on)
	. = ..()
	if(. != CHECKS_PASSED)
		return
	set_light_range(initial(light_range))
	set_light_power(floor(initial(light_power) * 0.5))
	set_light_color(LIGHT_COLOR_FLARE)
	set_light_on(toggle_on)
	flags_marine_helmet ^= ARMOR_LAMP_ON

	light_holder.set_light_flags(LIGHT_ATTACHED)
	light_holder.set_light_range(initial(light_range))
	light_holder.set_light_power(initial(light_power))
	light_holder.set_light_color(initial(light_color))
	light_holder.set_light_on(toggle_on)

	if(!toggle_on)
		playsound(src, 'sound/handling/click_2.ogg', 50, 1)

	playsound(src, 'sound/handling/suitlight_on.ogg', 50, 1)
	update_icon(user)

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/attack_alien(mob/living/carbon/xenomorph/being)
	. = ..()
	if(flags_marine_helmet & ARMOR_LAMP_ON)
		turn_light()

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/engineer
	name = "\improper PMC engineer helmet"
	desc = "An advanced technician helmet with a black finish, including advanced welding protection and resistence to the potential industrial hazards, but has less kevlar against potential firefights."
	icon_state = "pmc_engineer_helmet"
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	eye_protection = EYE_PROTECTION_WELDING
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_heat_protection = BODY_FLAG_HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROT

/////

//=============================//PMC GUARD (POLICE)\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/guard
	name = "\improper PMC riot guard helmet"
	desc = "A modified enclosed helmet utilized by Weyland-Yutani PMC crowd control units."
	icon_state = "guard_heavy_helmet"
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	actions_types = null

/obj/item/clothing/head/helmet/marine/veteran/pmc/guard
	name = "\improper PMC guard tactical cap"
	icon_state = "guard_cap"

/obj/item/clothing/head/helmet/marine/veteran/pmc/guard/crewman
	name = "\improper PMC driver tactical cap"
	icon_state = "guard_cap"

/obj/item/clothing/head/helmet/marine/veteran/pmc/guard/lead
	name = "\improper PMC guard leader tactical cap"
	icon_state = "guard_lead_cap"
