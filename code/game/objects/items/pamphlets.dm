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

	var/bypass_pamphlet_limit = FALSE

/obj/item/pamphlet/attack_self(mob/living/carbon/human/user)
	if(!user.skills || !istype(user))
		return
	if(user.has_used_pamphlet == TRUE && !bypass_pamphlet_limit)
		to_chat(usr, SPAN_WARNING("You've already used a pamphlet!"))
		return
	var/needs_primary = !skillcheck(user, skill_to_increment, skill_increment)
	var/needs_secondary = FALSE
	if(secondary_skill)
		needs_secondary = !skillcheck(user, secondary_skill, skill_increment)
	if(!(needs_primary || needs_secondary))
		to_chat(usr, SPAN_WARNING("You don't need this, you're already trained!"))
		return

	to_chat(usr, SPAN_NOTICE("You read over the pamphlet a few times, learning a new skill."))
	if(needs_primary)
		user.skills.set_skill(skill_to_increment, skill_increment)
	if(needs_secondary)
		user.skills.set_skill(secondary_skill, skill_increment)
	if(!bypass_pamphlet_limit)
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

/obj/item/pamphlet/powerloader
	name = "powerloader instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a powerloader insignia. The title reads 'Moving freight and squishing heads - a practical guide to Caterpillar P-5000 Work Loader'."
	skill_to_increment = SKILL_POWERLOADER
	skill_increment = SKILL_POWERLOADER_TRAINED
	bypass_pamphlet_limit = TRUE //it's really not necessary to stop people from learning powerloader skill
