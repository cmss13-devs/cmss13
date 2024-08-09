/obj/item/clothing/suit/storage/marine/medium/rto/intel
	name = "\improper XM4 pattern intelligence officer armor"
	uniform_restricted = list(/obj/item/clothing/under/marine/officer/intel)
	specialty = "XM4 pattern intel"
	desc = "Tougher than steel, quieter than whispers, the XM4 Intel Armor provides capable protection combined with an experimental integrated motion tracker. It took an R&D team a weekend to develop and costs more than the Chinook Station... probably. When worn, uniform accessories such as webbing cannot be attached due to the motion sensors occupying the clips."
	desc_lore = "ARMAT Perfection. The XM4 Soldier Awareness System mixes M4-style hard armor and a distributed series of motion sensors clipped onto the breastplate. When connected to any HUD optic, it replicates the effects of an M314 Motion Detector unit, increasing user situational awareness. It is currently undergoing field trials by intelligence operatives."
	storage_slots = 5
	/// XM4 Integral Motion Detector Ability
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/intel/toggle_motion_detector)
	var/motion_detector = FALSE
	var/obj/item/device/motiondetector/xm4/proximity
	var/long_range_cooldown = 2
	var/recycletime = 120

/obj/item/clothing/suit/storage/marine/medium/rto/intel/Initialize(mapload, ...)
	. = ..()
	proximity = new(src)
	update_icon()

/datum/action/item_action/intel/action_activate()
	. = ..()
	if(!ishuman(owner))
		return

/datum/action/item_action/intel/update_button_icon()
	return

/datum/action/item_action/intel/toggle_motion_detector/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Motion Detector"
	action_icon_state = "motion_detector"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/intel/toggle_motion_detector/action_activate()
	. = ..()
	var/obj/item/clothing/suit/storage/marine/medium/rto/intel/recon = holder_item
	recon.toggle_motion_detector(owner)

/datum/action/item_action/intel/toggle_motion_detector/proc/update_icon()
	if(!holder_item)
		return
	var/obj/item/clothing/suit/storage/marine/medium/rto/intel/recon = holder_item
	if(recon.motion_detector)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/obj/item/clothing/suit/storage/marine/medium/rto/intel/process()
	if(!motion_detector)
		STOP_PROCESSING(SSobj, src)
	if(motion_detector)
		recycletime--
		if(!recycletime)
			recycletime = initial(recycletime)
			proximity.refresh_blip_pool()
		long_range_cooldown--
		if(long_range_cooldown)
			return
		long_range_cooldown = initial(long_range_cooldown)
		proximity.scan()

/obj/item/clothing/suit/storage/marine/medium/rto/intel/proc/toggle_motion_detector(mob/user)
	to_chat(user,SPAN_NOTICE("You [motion_detector? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s motion detector."))
	if(!motion_detector)
		playsound(loc,'sound/items/detector_turn_on.ogg', 25, 1)
	else
		playsound(loc,'sound/items/detector_turn_off.ogg', 25, 1)
	motion_detector = !motion_detector
	var/datum/action/item_action/intel/toggle_motion_detector/TMD = locate(/datum/action/item_action/intel/toggle_motion_detector) in actions
	TMD.update_icon()
	motion_detector()

/obj/item/clothing/suit/storage/marine/medium/rto/intel/proc/motion_detector()
	if(motion_detector)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/suit/storage/marine/medium/rto/intel/mob_can_equip(mob/living/carbon/human/user, slot, disable_warning) //Thanks to Drathek for the help on this part!
	if(!..())
		return FALSE

	// Only equip if uniform doesn't already have a utility accessory slot equipped
	var/obj/item/clothing/under/uniform = user.w_uniform
	var/accessory = locate(/obj/item/clothing/accessory/storage) in uniform.accessories
	if(accessory)
		to_chat(user, SPAN_WARNING("[src] can't be worn with [accessory]."))
		return FALSE
	// Only equip if user has expert intel skill level
	if(!skillcheck(user, SKILL_INTEL, SKILL_INTEL_EXPERT))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return FALSE
	return TRUE

/obj/item/clothing/suit/storage/marine/medium/rto/intel/equipped(mob/user, slot, silent) //When XM4 is equipped this removes ACCESSORY_SLOT_UTILITY as a valid accessory for the uniform
	. = ..()
	if(slot == WEAR_JACKET)
		var/mob/living/carbon/human/human = user
		var/obj/item/clothing/under/uniform = human.w_uniform
		if(uniform?.valid_accessory_slots)
			uniform?.valid_accessory_slots -= ACCESSORY_SLOT_UTILITY

/obj/item/clothing/suit/storage/marine/medium/rto/intel/unequipped(mob/user, slot) //When unequipped this adds the ACCESSORY_SLOT_UTILITY back as a valid accessory
	. = ..()
	if(slot == WEAR_JACKET)
		var/mob/living/carbon/human/human = user
		var/obj/item/clothing/under/uniform = human.w_uniform
		if(uniform)
			// Figure out if the uniform originally allowed ACCESSORY_SLOT_UTILITY
			var/obj/item/clothing/under/temp_uniform = new uniform.type
			if(temp_uniform.valid_accessory_slots)
				for(var/allowed in temp_uniform.valid_accessory_slots)
					if(allowed == ACCESSORY_SLOT_UTILITY)
						// It was allowed previously, now add it back
						uniform.valid_accessory_slots += ACCESSORY_SLOT_UTILITY
						break
			qdel(temp_uniform)
