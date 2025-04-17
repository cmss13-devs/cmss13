// Default behavior: ignore double clicks (the second click that makes the doubleclick call already calls for a normal click)
/mob/proc/DblClickOn(atom/A, params)
	var/list/modifiers = params2list(params)
	if(modifiers[SHIFT_CLICK] && modifiers[MIDDLE_CLICK])
		ShiftMiddleDblClickOn(A)
		return
	if(modifiers[SHIFT_CLICK] && modifiers[CTRL_CLICK])
		CtrlShiftDblClickOn(A)
		return
	if(modifiers[CTRL_CLICK] && modifiers[MIDDLE_CLICK])
		CtrlMiddleDblClickOn(A)
		return
	if(modifiers[MIDDLE_CLICK])
		MiddleDblClickOn(A)
		return
	if(modifiers[SHIFT_CLICK])
		ShiftDblClickOn(A)
		return
	if(modifiers[ALT_CLICK])
		AltDblClickOn(A)
		return
	if(modifiers[CTRL_CLICK])
		CtrlDblClickOn(A)
		return


/mob/proc/ShiftMiddleDblClickOn(atom/A)
	A.ShiftMiddleDblClick(src)

/atom/proc/ShiftMiddleDblClick(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_DBLCLICK_SHIFT_MIDDLE, user)


/mob/proc/CtrlShiftDblClickOn(atom/A)
	A.CtrlShiftDblClick(src)

/atom/proc/CtrlShiftDblClick(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_DBLCLICK_CTRL_SHIFT, user)


/mob/proc/CtrlMiddleDblClickOn(atom/A)
	A.CtrlMiddleDblClick(src)

/atom/proc/CtrlMiddleDblClick(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_DBLCLICK_CTRL_MIDDLE, user)


/mob/proc/MiddleDblClickOn(atom/A)
	A.MiddleDblClick(src)

/atom/proc/MiddleDblClick(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_DBLCLICK_MIDDLE, user)


/mob/proc/ShiftDblClickOn(atom/A)
	A.ShiftDblClick(src)

/atom/proc/ShiftDblClick(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_DBLCLICK_SHIFT, user)


/mob/proc/AltDblClickOn(atom/A)
	A.AltDblClick(src)

/atom/proc/AltDblClick(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_DBLCLICK_ALT, user)


/mob/proc/CtrlDblClickOn(atom/A)
	A.CtrlDblClick(src)

/atom/proc/CtrlDblClick(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_DBLCLICK_CTRL, user)
