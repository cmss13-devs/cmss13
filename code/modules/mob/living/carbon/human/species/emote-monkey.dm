/datum/emote/living/carbon/human/primate
	species_type_allowed_typecache = list(/datum/species/monkey)
	species_type_blacklist_typecache = list()
	keybind = FALSE

/datum/emote/living/carbon/human/primate/New()  //Monkey's are blacklisted from human emotes on emote.dm, we need to not block the new emotes below
	. = ..()

/datum/emote/living/carbon/human/primate/jump
	key = "jump"
	key_third_person = "jumps"
	message = "jumps!"

/datum/emote/living/carbon/human/primate/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."

/datum/emote/living/carbon/human/primate/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."

/datum/emote/living/carbon/human/primate/tail
	key = "tail"
	message = "swipes their tail."

/datum/emote/living/carbon/human/primate/chimper
	key = "chimper"
	key_third_person = "chimpers"
	message = "chimpers."

/datum/emote/living/carbon/human/primate/whimper
	key = "whimper"
	key_third_person = "whimpers"
	message = "whimpers."
