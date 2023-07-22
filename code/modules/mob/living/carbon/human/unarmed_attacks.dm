//Species unarmed attacks
/datum/unarmed_attack
	var/attack_verb = list("attack") // Empty hand hurt intent verb.
	var/damage = 0 // Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = FALSE // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = FALSE
	var/edge = FALSE

/datum/unarmed_attack/proc/is_usable(mob/living/carbon/human/user)
	if(!user.melee_allowed)
		to_chat(user, SPAN_DANGER("You are currently unable to attack."))
		return FALSE

	return TRUE

/datum/unarmed_attack/bite
	attack_verb = list("gnash", "chew", "munch", "crunch")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = FALSE
	damage = 5
	sharp = TRUE
	edge = TRUE

/datum/unarmed_attack/bite/is_usable(mob/living/carbon/human/user)
	if(!user.melee_allowed)
		return FALSE

	if (user.wear_mask && istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		return FALSE
	return TRUE

/datum/unarmed_attack/punch
	attack_verb = list("punch")
	damage = 5

/datum/unarmed_attack/punch/strong
	attack_verb = list("punch","bust","skewer")
	damage = 10

/datum/unarmed_attack/punch/synthetic
	attack_verb = list("punch","clock","slugg","bludgeon","maul")
	attack_sound = 'sound/weapons/synthpunch1.ogg'
	damage = 35

/datum/unarmed_attack/claws
	attack_verb = list("scratch", "claw")
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 5
	sharp = TRUE
	edge = TRUE

/datum/unarmed_attack/claws/strong
	attack_verb = list("slash")
	damage = 10
	shredding = TRUE

/datum/unarmed_attack/bite/strong
	attack_verb = list("maul")
	damage = 15
	shredding = TRUE
