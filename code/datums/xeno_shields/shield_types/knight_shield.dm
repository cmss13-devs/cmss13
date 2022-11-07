
 // Knight shield - Very strong, and reduces damage slightly, but if fully broken stuns the knight.

/datum/xeno_shield/knight_shield
	amount = 300

/datum/xeno_shield/knight_shield/on_hit(damage)
	damage -= 3
	if (damage <= 0)
		return 0
	return ..(damage)

/datum/xeno_shield/knight_shield/on_removal(broken)
	if(broken)
		linked_xeno.visible_message(SPAN_XENODANGER("[linked_xeno]'s defensive shell shatters on itself, dazing it!"), SPAN_XENODANGER("Your defensive shell collapses on itself and dazes you!"))
		linked_xeno.KnockDown(2.5)//SECONDS
		playsound(linked_xeno, "punch", 50, FALSE)
	. = ..()
