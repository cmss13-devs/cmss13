/datum/battlepass_reward
	/// The name of this reward
	var/name = "" as text
	/// The iconfile that contains the image of this reward
	var/icon
	/// The iconstate of the image of this reward
	var/icon_state = "" as text

/datum/battlepass_reward/test
	name = "Debug"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "coin_diamond"
