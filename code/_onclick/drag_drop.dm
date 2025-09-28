/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	receiving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/
/atom/MouseDrop(atom/over)
	if(!usr || !over)
		return

	if(!Adjacent(usr) || !over.Adjacent(usr))
		return // should stop you from dragging through windows

	spawn(0)
		if(over)
			over.MouseDrop_T(src, usr)
	return

/*
	MouseDrop_T:

	Called on the atom that you release mouse drag over. "dropping" is the atom being mouse dragged
*/
/atom/proc/MouseDrop_T(atom/dropping, mob/user)
	if(HAS_TRAIT(usr, TRAIT_HAULED))
		return
	if (dropping.flags_atom & NOINTERACT)
		return
