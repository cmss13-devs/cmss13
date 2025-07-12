/datum/battlepass_challenge/kill_enemies/xenomorphs/weapon
	name = "Kill Xenomorphs - Weapon"
	desc = "Kill AMOUNT Xenomorphs using a WEAPON."
	kill_requirement_lower = 1
	kill_requirement_upper = 2
	challenge_category = CHALLENGE_NONE
	/// A list of possible weapons for this challenge to choose from. I would do it with typepaths but cause data only tracks names
	var/list/possible_weapons = list()
	/// The weapon chosen for this challenge
	var/weapon_to_use = "" as text

/datum/battlepass_challenge/kill_enemies/xenomorphs/weapon/New(client/owning_client)
	. = ..()
	if(!.)
		return .

	weapon_to_use = pick(possible_weapons)
	regenerate_desc()

/datum/battlepass_challenge/kill_enemies/xenomorphs/weapon/regenerate_desc()
	desc = "Kill [enemy_kills_required] Xenomorph\s using \an [weapon_to_use]."

/datum/battlepass_challenge/kill_enemies/xenomorphs/weapon/on_kill(mob/source, mob/killed_mob, datum/cause_data/cause_data)
	if(!findtext(cause_data.cause_name, weapon_to_use))
		return

	return ..()

/datum/battlepass_challenge/kill_enemies/xenomorphs/weapon/serialize()
	. = ..()
	.["weapon_to_use"] = weapon_to_use

/datum/battlepass_challenge/kill_enemies/xenomorphs/weapon/deserialize(list/save_list)
	. = ..()
	weapon_to_use = save_list["weapon_to_use"]
