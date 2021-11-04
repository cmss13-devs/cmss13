/*
				INTERNAL ORGANS
*/


/datum/internal_organ
	var/name = "organ"
	var/mob/living/carbon/human/owner
	var/obj/limb/parent_limb //Limb where the organ is located
	var/allowed_limb //Name of the type of limb which this organ can be attached to

	var/min_malf_damage = 10 //Bruised damage should always come before broken
	var/min_bruised_integrity = LIMB_INTEGRITY_NONE
	var/min_broken_damage = 30
	var/min_broken_integrity = LIMB_INTEGRITY_NONE

	var/vital //Lose a vital limb, die immediately.
	var/damage = 0 // amount of damage to the organ

	var/organ_item_type //Which type of obj/item/organ should
	var/organ_tag

	//Most of the stuff below should be removed after the surgery changes are in
	var/robotic = 0 //1 for 'assisted' organs (e.g. pacemaker), 2 for actual cyber organ.
	var/cut_away = FALSE //internal organ has its links to the body severed, organ is ready to be removed.
	var/removed_type //When removed, forms this object.
	var/robotic_type //robotic version of removed_type, used in mechanize().
	var/rejecting            // Is this organ already being rejected?
	var/obj/item/organ/organ_holder // If not in a body, held in this item.
	var/list/transplant_data

/datum/internal_organ/New(mob/living/carbon/human/H)
	. = ..()
	if(H)
		link_to_body(H, TRUE)

/datum/internal_organ/Destroy()
	if(owner)
		unlink_from_body()

	return ..()

/datum/internal_organ/proc/rejuvenate()
	damage = 0

/datum/internal_organ/proc/link_to_body(mob/living/carbon/human/H, initializing)
	owner = H
	LAZYADD(owner.internal_organs, src)
	parent_limb = H.get_limb(allowed_limb)
	LAZYADD(parent_limb.internal_organs, src)
	RegisterSignal(parent_limb, COMSIG_LIMB_INTEGRITY_CHANGED, .proc/handle_parent_limb_integrity)

/datum/internal_organ/proc/unlink_from_body()
	LAZYREMOVE(owner.internal_organs, src)
	LAZYREMOVE(parent_limb.internal_organs, src)
	UnregisterSignal(parent_limb, COMSIG_LIMB_INTEGRITY_CHANGED)
	parent_limb = null
	if(vital)
		owner.death(create_cause_data("organ removal"))
	owner = null

/datum/internal_organ/proc/take_damage(amount, silent)
	var/old_dmg = damage

	if (!silent)
		owner.custom_pain("Something inside your [parent_limb.display_name] hurts a lot.", 1)

	if(old_dmg < min_malf_damage)
		if(damage >= min_malf_damage)
			on_malfunction(TRAIT_SOURCE_ORGAN)

	if(old_dmg < min_broken_damage)
		if(damage >= min_broken_damage)
			on_break(TRAIT_SOURCE_ORGAN)

/datum/internal_organ/proc/heal_damage(amount)
	damage = max(0, damage - amount)

/datum/internal_organ/proc/on_malfunction(trait_source = TRAIT_SOURCE_ORGAN)
	ADD_TRAIT(src, TRAIT_ORGAN_MALFUNCTIONING, trait_source)

/datum/internal_organ/proc/on_break(trait_source = TRAIT_SOURCE_ORGAN)
	ADD_TRAIT(src, TRAIT_ORGAN_BROKEN, trait_source)

///Handles malfunctioning and breaking due to integrity
/datum/internal_organ/proc/handle_parent_limb_integrity(limb, old_level, new_level)
	SIGNAL_HANDLER
	if(old_level < min_bruised_integrity && new_level >= min_bruised_integrity)
		on_malfunction(TRAIT_SOURCE_INTEGRITY)
	if(old_level < min_broken_integrity && new_level >= min_broken_integrity)
		on_break(TRAIT_SOURCE_INTEGRITY)

/datum/internal_organ/proc/emp_act(severity)
	switch(robotic)
		if(0)
			return
		if(1)
			switch (severity)
				if (1.0)
					take_damage(20,0)
					return
				if (2.0)
					take_damage(7,0)
					return
				if(3.0)
					take_damage(3,0)
					return
		if(2)
			switch (severity)
				if (1.0)
					take_damage(40,0)
					return
				if (2.0)
					take_damage(15,0)
					return
				if(3.0)
					take_damage(10,0)
					return

/datum/internal_organ/proc/mechanize() //Being used to make robutt hearts, etc
	if(robotic_type)
		robotic = ORGAN_ROBOT
		removed_type = robotic_type


/datum/internal_organ/proc/mechassist() //Used to add things like pacemakers, etc
	robotic = ORGAN_ASSISTED
	min_malf_damage = 15
	min_broken_damage = 35

///Transfer to an organ which is outside of the body
/datum/internal_organ/proc/transfer_to_organ(obj/item/organ/to_transfer)
	unlink_from_body()

	to_transfer.organ_data = src

	organ_holder = to_transfer
