/datum/equipment_preset/guardian
	name = "Guardian"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id
	languages = list(LANGUAGE_ENGLISH,LANGUAGE_XENOMORPH, LANGUAGE_HIVEMIND)
	job_title = "Guardian"
	faction = FACTION_XENO_CULTIST
	faction_group = FACTION_LIST_XENO_CULTIST
	uses_special_name = TRUE
	skills = /datum/skills/yautja/warrior //CHANGE THIS ONCE WE KNOW WHAT SKILLS WE WANT

	minimap_icon = "guardian"

/datum/equipment_preset/guardian/load_race(mob/living/carbon/human/guardian/new_human, client/mob_client)
	. = ..()
	new_human.set_species(SPECIES_GUARDIAN)
	new_human.bubble_icon = "guardian"

/datum/equipment_preset/guardian/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/guardian(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/guardian(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/guardian(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/guardian(new_human), WEAR_JACKET)
	new_human.equip_to_slot_if_possible(new /obj/item/storage/hugger_box, WEAR_L_HAND)


/obj/item/clothing/shoes/guardian
	name = "Guardian boots"
	icon = 'icons/mob/humans/species/t_guardian.dmi'
	icon_state = "guardian_boots"
	item_state = "guardian_boots"

/obj/item/clothing/under/guardian
	name = "Guardian uniform"
	icon = 'icons/mob/humans/species/t_guardian.dmi'
	icon_state = "guardian_uniform"
	item_state = "guardian_uniform"
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/misc_ert_colony.dmi'
	)
/obj/item/clothing/mask/gas/guardian
	name = "Guardian mask"
	icon = 'icons/mob/humans/species/t_guardian.dmi'
	icon_state = "guardian_mask"
	item_state = "guardian_mask"
	flags_inventory = COVERMOUTH|ALLOWINTERNALS|BLOCKGASEFFECT|ALLOWREBREATH
	flags_equip_slot = SLOT_FACE
	flags_inventory = CANTSTRIP

/obj/item/clothing/suit/armor/guardian
	name = "Guardian armor"
	icon = 'icons/mob/humans/species/t_guardian.dmi'
	icon_state = "guardian_torso"
	item_state= "guardian_torso"
	flags_inventory = CANTSTRIP

/obj/item/storage/hugger_box
	icon = 'icons/obj/items/storage/small_containment_box.dmi'
	icon_state = "small_containment_box"

	can_hold = list(/obj/item/clothing/mask/facehugger)
	bypass_w_limit = list(/obj/item/clothing/mask/facehugger)
	storage_slots = 1
	flags_item = NOBLUDGEON
	var/list/tripwires = list()
	var/active = FALSE
	var/priming = FALSE
	var/lid_icon_state = "small_containment_box_closed"

/obj/item/storage/hugger_box/cultist
	lid_icon_state = "cultmark_closed"

/obj/item/storage/hugger_box/glass
	lid_icon_state = "small_containment_box_glass_closed"

/obj/item/storage/hugger_box/afterattack(atom/target, mob/user, proximity)
	. = ..()
	for(var/obj/item/clothing/mask/facehugger/facehugger in contents)
		return
	if(istype(target, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/facehugger = target
		if(facehugger.stat == DEAD)
			return
		handle_item_insertion(facehugger)
		if(facehugger.death_timer)
			deltimer(facehugger.death_timer)
		facehugger.death_timer = null

/obj/item/storage/hugger_box/attack_self(mob/user)
	if(priming)
		return
	addtimer(CALLBACK(src, PROC_REF(prime)), 3 SECONDS)
	to_chat(user, SPAN_ALERT("You started unlock timer on the box!"))
	priming = TRUE
	. = ..()

/obj/item/storage/hugger_box/bullet_act(obj/projectile/bullet)
	. = ..()
	deactivate()

/obj/item/storage/hugger_box/empty(mob/user, turf/T)
	return

/obj/item/storage/hugger_box/open(mob/user)
	. = ..()
	leap(user)

/obj/item/storage/hugger_box/Crossed(atom/A)
	if(!active)
		return
	leap(A)

/obj/item/storage/hugger_box/update_icon()
	. = ..()
	overlays.Cut()
	for(var/obj/item/clothing/mask/facehugger/facehugger in contents)
		overlays += image(icon, "facehugger_box")
		if(!active)
			overlays += image(icon, lid_icon_state)
		return

/obj/item/storage/hugger_box/proc/leap(atom/A)
	if(!ishuman(A))
		return
	for(var/obj/item/clothing/mask/facehugger/facehugger in contents)
		if(!facehugger)
			return
		var/mob/living/carbon/human/human = A
		if(facehugger.attach(human))
			deactivate()
			update_icon()
			return

/obj/item/storage/hugger_box/proc/prime(mob/user)
	priming = FALSE
	if(!loc)
		return
	active = TRUE
	Crossed(loc) //in case we are in someones hand
	for(var/mob/living/carbon/human/human in loc)
		leap(human)
		break
	update_icon()

/obj/item/storage/hugger_box/proc/deactivate()
	active = FALSE
	update_icon()



