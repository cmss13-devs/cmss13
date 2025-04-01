/datum/origin/uscm
	name = ORIGIN_USCM
	desc = "You were born in the US-of-A, the best god damn country in the entire universe."


/datum/origin/uscm/luna
	name = ORIGIN_USCM_LUNA
	desc = "You were born on a moonbase orbiting the earth. Pretty fuckin' cool if you ask me."


/datum/origin/uscm/other
	name = ORIGIN_USCM_OTHER
	desc = "You were born in an non-descript country within the United Americas."


/datum/origin/uscm/colony
	name = ORIGIN_USCM_COLONY
	desc = "You were born on a Weyland-Yutani colony, and your only way of escaping that hell-hole was signing up with the marines."


/datum/origin/uscm/foreign
	name = ORIGIN_USCM_FOREIGN
	desc = "You were born outside of the United Americas, designated irrelevant at birth."


/datum/origin/uscm/aw
	name = ORIGIN_USCM_AW
	desc = "You were a product of an experimental military programme that sought to breed the perfect supersoldier. In some aspects, they've succeeded."

/datum/origin/uscm/aw/generate_human_name(gender = MALE)
	return pick(gender == MALE ? GLOB.first_names_male : GLOB.first_names_female) + " A.W. " + pick(GLOB.weapon_surnames)

/datum/origin/uscm/aw/validate_name(name_to_check)
	if(!findtext(name_to_check, "A.W. "))
		return "Sorry, as a Artificial-Womb soldier, your character's 'middle-name' must be 'A.W.'."
	return null

/datum/origin/uscm/aw/correct_name(name_to_check, gender = MALE)
	if(!findtext(name_to_check, "A.W. "))
		name_to_check = generate_human_name(gender)
	return name_to_check

/datum/origin/uscm/convict
	name = null // Abstract type

/datum/origin/uscm/convict/minor
	name = ORIGIN_USCM_CONVICT_MINOR
	desc = "Where you were born is irrelevant, as far as anyone is concerned you are were convicted for numerous minor crimes and offered a way out: the USCM."

/datum/origin/uscm/convict/gang
	name = ORIGIN_USCM_CONVICT_GANG
	desc = "Where you were born is irrelevant, as far as anyone is concerned you are were convicted for gang related crimes and offered a way out: the USCM."

/datum/origin/uscm/convict/smuggling
	name = ORIGIN_USCM_CONVICT_SMUGGLING
	desc = "Where you were born is irrelevant, as far as anyone is concerned you are were convicted for smuggling (and likely some piracy) and offered a way out: the USCM."
