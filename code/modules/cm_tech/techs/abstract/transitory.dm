/datum/tech/transitory
	name = "Transitory tech"
	desc = "Transitions the tree to another tier."
	icon_state = "upgrade"

	var/datum/tier/before
	var/datum/tier/next

	var/techs_to_unlock = 0
	is_tier_changer = TRUE

/datum/tech/transitory/check_tier_level(mob/M)
	if(before && before != holder.tier.type)
		to_chat(M, SPAN_WARNING("You can't unlock this node!"))
		return

	if(techs_to_unlock > 0)
		var/amount_of_unlocked_techs = LAZYLEN(holder.unlocked_techs[before])

		if(amount_of_unlocked_techs < techs_to_unlock)
			to_chat(M, SPAN_WARNING("You must unlock [techs_to_unlock] techs from [initial(before.name)] before you can unlock this tech!"))
			return FALSE

	return TRUE

/datum/tech/transitory/on_unlock(mob/user)
	. = ..()
	if(!next)
		return
	var/datum/tier/previous_tier = holder.tier
	var/datum/tier/next_tier = holder.tree_tiers[next]
	if(next_tier)
		holder.tier = next_tier
		holder.on_tier_change(previous_tier)
		if(flags & TREE_FLAG_MARINE)
			/// Due to calling parent, points will have already been spent by now.
			var/current_points = holder.points + required_points
			log_ares_tech(user.real_name, is_tier_changer, "ALMAYER DEFCON LEVEL INCREASED", "THREAT ASSESSMENT LEVEL INCREASED TO LEVEL [next_tier.tier].\n\nLEVEL [next_tier.tier] assets have been authorised to handle the situation.", required_points, current_points)

/datum/tech/transitory/get_tier_overlay()
	if(!next)
		return

	var/datum/tier/next_tier = holder.tree_tiers[next]
	var/image/I = ..()
	I.color = next_tier.color

	return I

/datum/tech/transitory/tier1
	name = "Unlock Tier 1"
	tier = /datum/tier/free

	flags = TREE_FLAG_MARINE|TREE_FLAG_XENO

	next = /datum/tier/one

/datum/tech/transitory/tier2
	name = "Unlock Tier 2"
	tier = /datum/tier/one_transition_two

	before = /datum/tier/one
	next = /datum/tier/two

/datum/tech/transitory/tier2/xeno
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_XENO

/datum/tech/transitory/tier2/marine
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_MARINE

/datum/tech/transitory/tier3
	name = "Unlock Tier 3"
	tier = /datum/tier/two_transition_three

	before = /datum/tier/two
	next = /datum/tier/three

/datum/tech/transitory/tier3/xeno
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_XENO

/datum/tech/transitory/tier3/marine
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_MARINE

/datum/tech/transitory/tier4
	name = "Unlock Tier 4"
	tier = /datum/tier/three_transition_four

	before = /datum/tier/three
	next = /datum/tier/four

/datum/tech/transitory/tier4/xeno
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_XENO

/datum/tech/transitory/tier4/marine
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_MARINE
