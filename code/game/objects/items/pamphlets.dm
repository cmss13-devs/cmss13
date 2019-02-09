/obj/item/pamphlet
	name = "instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge."
	icon = 'icons/obj/items/pamphlets.dmi'
	icon_state = "pamphlet_written"
	item_state = "pamphlet_written"
	w_class = 1
	throw_speed = 1
	throw_range = 20
	var/skill_increment = 1 //The skill level we want to go to.
	var/skill_to_increment = "cqc" //The skill we want to increase.
	var/secondary_skill //If there's a second skill we want a single pamphlet to increase.

/obj/item/pamphlet/attack_self(mob/living/carbon/human/user)
	if(user.mind.cm_skills)
		if(user.has_used_pamphlet == TRUE)
			usr << "<span class='warning'>You've already used a pamphlet!</span>"
			return
		if(user.mind.cm_skills.vars["[skill_to_increment]"] >= skill_increment || (secondary_skill && user.mind.cm_skills.vars["[secondary_skill]"] >= skill_increment))
			usr << "<span class='warning'>You don't need this, you're already trained!</span>"
			return
		else
			usr << "<span class='notice'>You read over the pamphlet a few times, learning a new skill.</span>"
			user.mind.cm_skills.vars["[skill_to_increment]"] = skill_increment
			if(secondary_skill)
				user.mind.cm_skills.vars["[secondary_skill]"] = skill_increment
			user.has_used_pamphlet = TRUE
			cdel(src)

/obj/item/pamphlet/medical
	name = "medical instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a medical insignia."
	icon_state = "pamphlet_medical"
	skill_to_increment = "medical"

/obj/item/pamphlet/engineer
	name = "engineer instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering insignia."
	icon_state = "pamphlet_construction"
	skill_to_increment = "construction"
	secondary_skill = "engineer"