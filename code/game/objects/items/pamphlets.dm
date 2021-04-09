/obj/item/pamphlet
	name = "instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge."
	icon = 'icons/obj/items/pamphlets.dmi'
	icon_state = "pamphlet_written"
	item_state = "pamphlet_written"
	w_class = SIZE_TINY
	throw_speed = SPEED_FAST
	throw_range = 20
	var/datum/character_trait/trait = /datum/character_trait
	var/flavour_text = "You read over the pamphlet a few times, learning a new skill."
	var/bypass_pamphlet_limit = FALSE

obj/item/pamphlet/Initialize()
	. = ..()

	trait = GLOB.character_traits[trait]

/obj/item/pamphlet/attack_self(mob/living/carbon/human/user)
	if(!user.traits || !istype(user))
		return

	if(trait in user.traits)
		to_chat(user, SPAN_WARNING("You know this already!"))
		return

	if(user.has_used_pamphlet == TRUE && !bypass_pamphlet_limit)
		to_chat(user, SPAN_WARNING("You've already used a pamphlet!"))
		return

	to_chat(user, SPAN_NOTICE(flavour_text))

	trait.apply_trait(user)

	if(!bypass_pamphlet_limit)
		user.has_used_pamphlet = TRUE

	qdel(src)


/obj/item/pamphlet/skill/medical
	name = "medical instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a medical insignia."
	icon_state = "pamphlet_medical"
	trait = /datum/character_trait/skills/medical

/obj/item/pamphlet/skill/engineer
	name = "engineer instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering insignia."
	icon_state = "pamphlet_construction"
	trait = /datum/character_trait/skills/miniengie

/obj/item/pamphlet/skill/jtac
	name = "JTAC instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has the image of a radio on it."
	icon_state = "pamphlet_jtac"
	trait = /datum/character_trait/skills/jtac

/obj/item/pamphlet/skill/machinegunner
	name = "heavy machinegunner instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering and a machinegun insignia."
	icon_state = "pamphlet_machinegunner"
	trait = /datum/character_trait/skills/engineering
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/powerloader
	name = "powerloader instructional pamphlet"
	desc = "A pamphlet used to quickly impart vital knowledge. This one has a powerloader insignia. The title reads 'Moving freight and squishing heads - a practical guide to Caterpillar P-5000 Work Loader'."
	icon_state = "pamphlet_powerloader"
	trait = /datum/character_trait/skills/powerloader
	bypass_pamphlet_limit = TRUE //it's really not necessary to stop people from learning powerloader skill


/obj/item/pamphlet/language
	name = "translation pamphlet"
	desc = "A pamphlet used by lazy USCM interpreters to quickly learn new languages on the spot."
	flavour_text = "You go over the pamphlet, learning a new language."

	bypass_pamphlet_limit = TRUE
