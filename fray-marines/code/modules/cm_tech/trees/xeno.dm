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
	var/title = "Вы ощущаете, что . . ."
	var/input = "Улей стал сильнее. Открыт [tier.tier] уровень эволюции.\n\nДА ЗДРАВСТВУЕТ КОРОЛЕВА!"
	xeno_announcement(input, hivenumber, title)

/datum/techtree/xenomorph/enter_mob(mob/M, force)
	if(!M.mind || M.stat == DEAD)
		return FALSE

	if(!has_access(M, TREE_ACCESS_VIEW) && !force)
		to_chat(M, SPAN_WARNING("You do not have access to this tech tree"))
		return FALSE

	if(SEND_SIGNAL(M, COMSIG_MOB_ENTER_TREE, src, force) & COMPONENT_CANCEL_TREE_ENTRY) return

	new/mob/hologram/techtree(entrance, M)

	if(M.lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE)
		M.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	M.sync_lighting_plane_alpha()

/// no reset_lighting_alpha comsig so benos aren't trolled by disabled nightvision on exit
	return TRUE
