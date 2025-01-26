/obj/item/pamphlet/skill/minimed
	name = "Advance medical instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a medical insignia."
	icon_state = "pamphlet_medical"
	trait = /datum/character_trait/skills/minimed

/obj/item/pamphlet/skill/minimed/can_use(mob/living/carbon/human/user)

	if(user.job != JOB_SQUAD_MARINE)
		to_chat(user, SPAN_WARNING("Only squad riflemen can use this."))
		return FALSE
	return ..()
