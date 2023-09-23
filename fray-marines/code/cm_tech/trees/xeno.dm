#define isXenoQueenLeadingHive(A) (isqueen(A) && A?:hive?:living_xeno_queen == A)

// THE XENO TECH TREE
/datum/techtree/xenomorph
	name = TREE_XENO
	flags = TREE_FLAG_XENO

	background_icon_locked = "xeno"

	var/hivenumber = XENO_HIVE_NORMAL

/datum/techtree/xenomorph/has_access(mob/M, access_required)
	if(!isxeno(M))
		return FALSE

	var/mob/living/carbon/xenomorph/X = M

	if(X.hivenumber != hivenumber)
		return FALSE

	if(access_required == TREE_ACCESS_VIEW)
		return TRUE

	return isXenoQueenLeadingHive(X)

/datum/techtree/xenomorph/can_attack(mob/living/carbon/H)
	return !(H.hivenumber == hivenumber)

/datum/techtree/xenomorph/on_tier_change(datum/tier/oldtier)
	if(tier.tier < 2)
		return //No need to announce tier updates for tier 1
	var/title = "Новый уровень эволюции"
	var/input = "Улей стал сильнее. Открыт [tier.tier] уровень эволюции.\n\nДА ЗДРАВСТВУЕТ КОРОЛЕВА!"
	xeno_announcement(input, hivenumber, title)
