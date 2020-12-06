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

/obj/item/pamphlet/engineer/machinegunner
	name = "heavy machinegunner instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering and a machinegun insignia."
	icon_state = "pamphlet_machinegunner"
	skill_to_increment = SKILL_ENGINEER
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/powerloader
	name = "powerloader instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a powerloader insignia. The title reads 'Moving freight and squishing heads - a practical guide to Caterpillar P-5000 Work Loader'."
	skill_to_increment = SKILL_POWERLOADER
	skill_increment = SKILL_POWERLOADER_TRAINED
	bypass_pamphlet_limit = TRUE //it's really not necessary to stop people from learning powerloader skill

/obj/item/pamphlet/language
	name = "translation pamphlet"
	desc = "A pamphlet used by lazy USCM interpreters to quickly learn new languages on the spot."
	var/language_type = "English"
	var/flavour_learning = "You go over the pamphlet, learning a new language."

	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/language/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return

	if(!user.add_language(language_type))
		to_chat(user, SPAN_WARNING("You are already familiar with this language, no need to read this piece of literature here."))
		return

	to_chat(user, SPAN_NOTICE("[flavour_learning]"))
	qdel(src)

/obj/item/pamphlet/language/russian
	name = "Printed Copy of Pari"
	desc = "Pari, or The Bet in English, is a short story written by Anton Checkov about a bet between a lawyer and a banker; the banker wagers that the lawyer cannot remain in solitary confinement for 15 years. Must be a refined reader if you know this one; why are you even in the USCM if you know that?"
	language_type = "Russian"
	flavour_learning = "After reading the full version of the short story, you feel temporarily morally conflicted about the themes of greed and freedom in the story before snapping back to 2189 reality."

/obj/item/pamphlet/language/japanese
	name = "Pages of Koroniaru Yohei Adobencha Zohuken"
	desc = "These are some torn pages from a famous isekai manga named 'Koroniaru Yohei Adobencha Zohuken' or Colonial Mercenary Adventure Sequel about a travelling band of Freelancers sent into a fantasy world."
	language_type = "Japanese"
	flavour_learning = "After reading the cluster of manga panels, you navigate your way past bad cliches and circular plots and refresh yourself on Japanese, but feel like a geek after finishing it."

/obj/item/pamphlet/language/german
	name = "Translated Lyrics to 99 Luftballons"
	desc = "These hastily written Spacendeutchen translations of 99 Luftballons, an iconic German hit of the 80s were meant for the yearly Battalion's Karaoke Night, I guess you can get some better use out of this."
	language_type = "Spacendeutchen"
	flavour_learning = "You quickly read and memorize the lyrics, the new wave tunes and cynic themes flowing through your mind while doing so."

/obj/item/pamphlet/language/spanish
	name = "America Latina - A Quick Translation Guide for Southern UA states"
	desc = "This pamphlet was designed for Intelligence Officers operating on Earth to interact with the local populaces of the Latin American states, but only for IOs who managed to sleep through Dialects and Mannerisms Class."
	language_type = "American Spanish"
	flavour_learning = "You quickly read and memorize the pamphlet, hoping none of your instructors notice you... even though you never attended Dialects and Mannerisms at all."
