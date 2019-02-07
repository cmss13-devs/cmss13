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

/obj/item/pamphlet/attack_self(mob/user)
	if(user.mind.cm_skills)
		if(user.mind.cm_skills.vars["[skill_to_increment]"] >= skill_increment)
			usr << "<span class='warning'>You don't need this, you're already trained!</span>"
		else
			usr << "<span class='notice'>You read over the pamphlet a few times, learning a new skill.</span>"
			user.mind.cm_skills.vars["[skill_to_increment]"] = skill_increment
			cdel(src)

/obj/item/pamphlet/engineering
	name = "engineering instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering insignia."
	icon_state = "pamphlet_engineering"
	skill_to_increment = "engineer"

/obj/item/pamphlet/medical
	name = "medical instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a medical insignia."
	icon_state = "pamphlet_medical"
	skill_to_increment = "medical"

/obj/item/pamphlet/construction
	name = "construction instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a construction insignia."
	icon_state = "pamphlet_construction"
	skill_to_increment = "construction"