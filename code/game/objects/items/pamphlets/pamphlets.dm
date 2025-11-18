//-------//
//parent dm file for pamphlets
//------//

/obj/item/pamphlet
	name = "instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge."
	icon = 'icons/obj/items/pamphlets.dmi'
	icon_state = "pamphlet_written"
	item_state = "paper"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi'
	)
	pickup_sound = 'sound/handling/paper_pickup.ogg'
	drop_sound = 'sound/handling/paper_drop.ogg'
	w_class = SIZE_TINY
	throw_speed = SPEED_FAST
	throw_range = 20
	var/datum/character_trait/trait = /datum/character_trait
	var/flavour_text = "You read over the pamphlet a few times, learning a new skill."
	var/bypass_pamphlet_limit = FALSE

/obj/item/pamphlet/Initialize()
	. = ..()

	trait = GLOB.character_traits[trait]

/obj/item/pamphlet/attack_self(mob/living/carbon/human/user)
	..()

	if(!can_use(user))
		return
	on_use(user)

	qdel(src)

/obj/item/pamphlet/proc/can_use(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE
	if(trait in user.traits)
		to_chat(user, SPAN_WARNING("You know this already!"))
		return FALSE
	if(user.has_used_pamphlet == TRUE && !bypass_pamphlet_limit)
		to_chat(user, SPAN_WARNING("You've already used a pamphlet!"))
		return FALSE
	return TRUE

/obj/item/pamphlet/proc/on_use(mob/living/carbon/human/user)
	to_chat(user, SPAN_NOTICE(flavour_text))
	trait.apply_trait(user)
	if(!bypass_pamphlet_limit)
		user.has_used_pamphlet = TRUE

//-------//
//antag skill pamphlets, kinda deprecated but oh well
//------//

/obj/item/pamphlet/antag/attack_self(mob/living/carbon/human/user)
	if(!user.skills || !user)
		return

	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		to_chat(user, SPAN_WARNING("This pamphlet is written in code-speak! You don't quite understand it."))
		return

	. = ..()

/obj/item/pamphlet/antag/skill/engineer
	name = "suspicious looking pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering insignia. This one is written in code-speak."
	trait = /datum/character_trait/skills/miniengie/antag
	bypass_pamphlet_limit = TRUE

//-------//
//standard skill pamphlets, like specs and stuff
//------//
/obj/item/pamphlet/skill/spotter
	name = "Spotter instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has the image of a pair of binoculars on it."
	icon_state = "pamphlet_spotter"
	trait = /datum/character_trait/skills/spotter
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/spotter/can_use(mob/living/carbon/human/user)
	var/specialist_skill = user.skills.get_skill_level(SKILL_SPEC_WEAPONS)
	if(specialist_skill == SKILL_SPEC_SNIPER)
		to_chat(user, SPAN_WARNING("You don't need to use this! Give it to another marine to make them your spotter."))
		return FALSE
	if(specialist_skill != SKILL_SPEC_DEFAULT)
		to_chat(user, SPAN_WARNING("You're already a specialist! Give this to a lesser trained marine."))
		return FALSE

	if(user.job != JOB_SQUAD_MARINE)
		to_chat(user, SPAN_WARNING("Only squad riflemen can use this."))
		return

	var/obj/item/card/id/ID = user.get_idcard()
	if(!ID) //not wearing an ID
		to_chat(user, SPAN_WARNING("You should wear your ID before doing this."))
		return FALSE
	if(!ID.check_biometrics(user))
		to_chat(user, SPAN_WARNING("You should wear your ID before doing this."))
		return FALSE

	return ..()

/obj/item/pamphlet/skill/spotter/on_use(mob/living/carbon/human/user)
	. = ..()
	user.rank_fallback = "ass"
	user.hud_set_squad()

	var/obj/item/card/id/ID = user.get_idcard()
	ID.set_assignment((user.assigned_squad ? (user.assigned_squad.name + " ") : "") + "Spotter")
	ID.minimap_icon_override = "spotter"
	user.update_minimap_icon()
	GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), "Spotter")

/obj/item/pamphlet/skill/honorguard
	name = "Honor Guard instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one details the responsibilities of an Honor Guard."
	icon_state = "pamphlet_written"
	trait = null
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/honorguard/can_use(mob/living/carbon/human/user)
	if(user.job != JOB_POLICE)
		to_chat(user, SPAN_WARNING("Only Military Police can use this."))
		return

	var/obj/item/card/id/id_card = user.get_idcard()
	if(!id_card || !id_card.check_biometrics(user)) //not wearing an ID
		to_chat(user, SPAN_WARNING("You should wear your ID before doing this."))
		return FALSE

	if(user.rank_fallback == "hgmp"|| (id_card.minimap_icon_override == "honorguard"))
		to_chat(user, SPAN_WARNING("You are already an honor guard!"))
		return FALSE

	return ..()

/obj/item/pamphlet/skill/honorguard/on_use(mob/living/carbon/human/user)
	. = ..()
	user.rank_fallback = "hgmp"
	user.hud_set_squad()

	var/obj/item/card/id/id_card = user.get_idcard()
	id_card.set_assignment((user.assigned_squad ? (user.assigned_squad.name + " ") : "") + JOB_POLICE_HG)
	id_card.minimap_icon_override = "honorguard"//Different to Whiskey Honor Guard
	user.update_minimap_icon()
	GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), JOB_POLICE_HG)

/obj/item/pamphlet/skill/cosmartgun
	name = "Cavalier instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has the image of a smartgun on it."
	icon_state = "pamphlet_loader"
	bypass_pamphlet_limit = TRUE
	trait = /datum/character_trait/skills/cosmartgun

/obj/item/pamphlet/skill/cosmartgun/can_use(mob/living/carbon/human/user)
	if(user.job != JOB_CO && user.job != JOB_WO_CO)
		to_chat(user, SPAN_WARNING("Only the Commanding Officer can use this."))
		return
	return ..()

/obj/item/pamphlet/skill/loader
	name = "Loader instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has the image of a rocket on it."
	icon_state = "pamphlet_loader"
	trait = /datum/character_trait/skills/loader
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/loader/can_use(mob/living/carbon/human/user)
	var/specialist_skill = user.skills.get_skill_level(SKILL_SPEC_WEAPONS)
	if(specialist_skill == SKILL_SPEC_ROCKET)
		to_chat(user, SPAN_WARNING("You don't need to use this! Give it to another marine to make them your loader."))
		return FALSE
	if(specialist_skill != SKILL_SPEC_DEFAULT)
		to_chat(user, SPAN_WARNING("You're already a specialist! Give this to a lesser trained marine."))
		return FALSE

	if(user.job != JOB_SQUAD_MARINE)
		to_chat(user, SPAN_WARNING("Only squad riflemen can use this."))
		return

	var/obj/item/card/id/ID = user.get_idcard()
	if(!ID) //not wearing an ID
		to_chat(user, SPAN_WARNING("You should wear your ID before doing this."))
		return FALSE
	if(!ID.check_biometrics(user))
		to_chat(user, SPAN_WARNING("You should wear your ID before doing this."))
		return FALSE

	return ..()

/obj/item/pamphlet/skill/loader/on_use(mob/living/carbon/human/user)
	. = ..()
	user.rank_fallback = "load"
	user.hud_set_squad()

	var/obj/item/card/id/ID = user.get_idcard()
	ID.set_assignment((user.assigned_squad ? (user.assigned_squad.name + " ") : "") + "Loader")
	ID.minimap_icon_override = "loader"
	user.update_minimap_icon()
	GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), "Loader")

/obj/item/pamphlet/skill/mortar_operator
	name = "Mortar Operator instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has the image of a mortar on it."
	icon_state = "pamphlet_mortar"
	trait = /datum/character_trait/skills/mortar
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/mortar_operator/can_use(mob/living/carbon/human/user)
	if(user.job != JOB_SQUAD_MARINE)
		to_chat(user, SPAN_WARNING("Only squad riflemen can use this."))
		return

	var/obj/item/card/id/ID = user.get_idcard()
	if(!ID) //not wearing an ID
		to_chat(user, SPAN_WARNING("You should wear your ID before doing this."))
		return FALSE
	if(!ID.check_biometrics(user))
		to_chat(user, SPAN_WARNING("You should wear your ID before doing this."))
		return FALSE

	return ..()

/obj/item/pamphlet/skill/mortar_operator/on_use(mob/living/carbon/human/user)
	. = ..()
	user.rank_fallback = "mortar"
	user.hud_set_squad()

	var/obj/item/card/id/ID = user.get_idcard()
	ID.set_assignment((user.assigned_squad ? (user.assigned_squad.name + " ") : "") + "Mortar Operator")
	ID.minimap_icon_override = "mortar"
	user.update_minimap_icon()
	GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), "Mortar Operator")

/obj/item/pamphlet/skill/k9_handler
	name = "K9 handler instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has the image of a Synthetic K9 Rescue unit on it."
	icon_state = "pamphlet_k9_handler"
	trait = /datum/character_trait/skills/k9_handler
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/k9_handler/can_use(mob/living/carbon/human/user)
	if(isk9synth(user))
		to_chat(user, SPAN_WARNING("You don't need to use this! Give it to another marine to make them your handler."))
		return FALSE

	if(user.job != JOB_SQUAD_MEDIC && user.job != JOB_POLICE)
		to_chat(user, SPAN_WARNING("This is not meant for you."))
		return

	var/obj/item/card/id/ID = user.get_idcard()
	if(!istype(ID)) //not wearing an ID
		to_chat(user, SPAN_WARNING("You should wear your ID before doing this."))
		return FALSE
	if(!ID.check_biometrics(user))
		to_chat(user, SPAN_WARNING("You should wear your ID before doing this."))
		return FALSE

	return ..()

/obj/item/pamphlet/skill/k9_handler/on_use(mob/living/carbon/human/user)
	. = ..()
	user.rank_fallback = "medk9"
	user.hud_set_squad()

	var/obj/item/card/id/ID = user.get_idcard()
	ID.set_assignment((user.assigned_squad ? (user.assigned_squad.name + " ") : "") + "K9 Handler")
	ID.minimap_icon_override = "medic_k9"
	user.update_minimap_icon()
	GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), "K9 Handler")

/obj/item/pamphlet/skill/vc
	name = "vehicle training manual"
	desc = "A manual used to quickly impart vital knowledge on driving vehicles."
	icon_state = "pamphlet_vehicle"
	trait = /datum/character_trait/skills/vc
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/surgery // deprecate this somehow
	name = "Surgery instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a medical insignia."
	icon_state = "pamphlet_medical"
	trait = /datum/character_trait/skills/surgery
	bypass_pamphlet_limit = TRUE

//-------//
//trait based pamphlets
//------//

/obj/item/pamphlet/trait
	bypass_pamphlet_limit = TRUE
	/// What trait to give the user
	var/trait_to_give

/obj/item/pamphlet/trait/can_use(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE

	if(HAS_TRAIT(user, trait_to_give))
		to_chat(user, SPAN_WARNING("You know this already!"))
		return FALSE

	if(!(user.job in JOB_SQUAD_ROLES_LIST))
		to_chat(user, SPAN_WARNING("Only squad riflemen can use this."))
		return FALSE

	if(user.has_used_pamphlet && !bypass_pamphlet_limit)
		to_chat(user, SPAN_WARNING("You've already used a pamphlet!"))
		return FALSE

	return TRUE

/obj/item/pamphlet/trait/on_use(mob/living/carbon/human/user)
	to_chat(user, SPAN_NOTICE(flavour_text))
	ADD_TRAIT(user, trait_to_give, "pamphlet")
	if(!bypass_pamphlet_limit)
		user.has_used_pamphlet = TRUE

/obj/item/pamphlet/trait/vulture
	name = "\improper M707 instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge of how to shoot big guns and spot for them."
	icon_state = "pamphlet_vulture"
	trait_to_give = TRAIT_VULTURE_USER
