/*
	AI has no need for the UnarmedAttack() and RangedAttack() procs,
	because the AI code is not generic; attack_remote() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/living/silicon/ai/UnarmedAttack(atom/A)
	A.attack_remote(src)
/mob/living/silicon/ai/RangedAttack(atom/A)
	A.attack_remote(src)

/atom/proc/attack_remote(mob/user as mob)
	return

/*
	The following criminally helpful code is just the previous code cleaned up;
	I have no idea why it was in atoms.dm instead of respective files.
*/

/atom/proc/AICtrlShiftClick()
	return

/atom/proc/AIShiftClick()
	return

/obj/structure/machinery/door/AIShiftClick()  // Opens and closes doors!
	if(density)
		open()
	else
		close()
	return

/atom/proc/AICtrlClick()
	return

/atom/proc/AIAltClick()
	return

/obj/structure/machinery/door/airlock/AICtrlClick() // Bolts doors
	if(!locked)
		lock(TRUE)
	else
		unlock(TRUE)

/obj/structure/machinery/power/apc/AICtrlClick() // turns off/on APCs.
	Topic("breaker=1", list("breaker"="1"), 0) // 0 meaning no window (consistency! wait...)

/obj/structure/machinery/door/airlock/AIAltClick() // Electrifies doors.
	if(!secondsElectrified)
		// permanent shock
		secondsElectrified = -1 // 1 meaning no window (consistency!)
	else
		secondsElectrified = 0
	return

/atom/proc/AIMiddleClick()
	return

