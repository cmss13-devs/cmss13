/* -- ACTIVATABLE ACTIONS -- */

/datum/action/human_action/activable/synth_bracer
	var/mob/living/carbon/human/synth
	var/obj/item/clothing/gloves/synth/synth_bracer
	var/charge_cost = 0

/datum/action/human_action/activable/synth_bracer/give_to(user)
	if(!isSynth(user))
		return FALSE
	synth = user
	synth_bracer = synth.gloves// never add a check to see if the synth has gloves on, because they shouldn't have these abilities while not wearing gloves. it should runtime to let us know
	return ..()

/datum/action/human_action/activable/synth_bracer/remove_from(mob/living/carbon/human/H)
	synth = null
	synth_bracer = null
	return ..()

/datum/action/human_action/activable/synth_bracer/can_use_action()
	if(synth_bracer.battery_charge < charge_cost)
		return FALSE
	return ..()

/datum/action/human_action/activable/synth_bracer/use_ability(var/mob/M)
	if(charge_cost)
		synth_bracer.drain_charge(owner, charge_cost)

/* -- ON-CLICK ACTIONS -- */

/datum/action/human_action/synth_bracer
	var/mob/living/carbon/human/synth
	var/obj/item/clothing/gloves/synth/synth_bracer
	var/charge_cost = 0

/datum/action/human_action/synth_bracer/give_to(user)
	if(!isSynth(user))
		return FALSE
	synth = user
	synth_bracer = synth.gloves
	return ..()

/datum/action/human_action/synth_bracer/remove_from(mob/living/carbon/human/H)
	synth = null
	synth_bracer = null
	return ..()

/datum/action/human_action/synth_bracer/can_use_action()
	if(synth_bracer.battery_charge < charge_cost)
		return FALSE
	return ..()

/datum/action/human_action/synth_bracer/action_activate()
	if(charge_cost)
		synth_bracer.drain_charge(owner, charge_cost)
