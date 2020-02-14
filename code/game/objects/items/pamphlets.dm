/obj/item/pamphlet
	name = "instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge."
	icon = 'icons/obj/items/pamphlets.dmi'
	icon_state = "pamphlet_written"
	item_state = "pamphlet_written"
	w_class = SIZE_TINY
	throw_speed = SPEED_FAST
	throw_range = 20
	var/skill_increment = 1 //The skill level we want to go to.
	var/skill_to_increment = SKILL_CQC //The skill we want to increase.
	var/secondary_skill //If there's a second skill we want a single pamphlet to increase.

/obj/item/pamphlet/attack_self(mob/living/carbon/human/user)
	if(!user.skills || !istype(user))
		return
	if(user.has_used_pamphlet == TRUE)
		to_chat(usr, SPAN_WARNING("You've already used a pamphlet!"))
		return
	if(skillcheck(user, skill_to_increment, skill_increment) || (secondary_skill && skillcheck(user, secondary_skill, skill_increment)))
		to_chat(usr, SPAN_WARNING("You don't need this, you're already trained!"))
		return
	else
		to_chat(usr, SPAN_NOTICE("You read over the pamphlet a few times, learning a new skill."))
		user.skills.set_skill(skill_to_increment, skill_increment)
		if(secondary_skill)
			user.skills.set_skill(secondary_skill, skill_increment)
		user.has_used_pamphlet = TRUE
		qdel(src)

/obj/item/pamphlet/medical
	name = "medical instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a medical insignia."
	icon_state = "pamphlet_medical"
	skill_to_increment = SKILL_MEDICAL

/obj/item/pamphlet/engineer
	name = "engineer instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering insignia."
	icon_state = "pamphlet_construction"
	skill_to_increment = SKILL_CONSTRUCTION
	secondary_skill = SKILL_ENGINEER