//Redefining some robot procs, since drones can't be repaired and really shouldn't take component damage.
/mob/living/silicon/robot/drone/take_overall_damage(brute = 0, burn = 0, sharp = 0, used_weapon = null)
	bruteloss += brute
	fireloss += burn

/mob/living/silicon/robot/drone/heal_overall_damage(brute, burn)

	bruteloss -= brute
	fireloss -= burn

	if(bruteloss<0) bruteloss = 0
	if(fireloss<0) fireloss = 0

/mob/living/silicon/robot/drone/take_limb_damage(brute = 0, burn = 0, sharp = 0)
	take_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/heal_limb_damage(brute, burn)
	heal_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/getFireLoss()
	return fireloss

/mob/living/silicon/robot/drone/getBruteLoss()
	return bruteloss
