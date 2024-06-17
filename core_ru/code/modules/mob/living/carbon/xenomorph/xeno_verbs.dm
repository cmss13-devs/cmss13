/mob/living/carbon/xenomorph/verb/enter_tree()
	set name = "Enter Techtree"
	set desc = "Enter the Xenomorph techtree"
	set category = "Alien.Techtree"

	var/datum/techtree/T = GET_TREE(TREE_XENO)
	T.enter_mob(src)
