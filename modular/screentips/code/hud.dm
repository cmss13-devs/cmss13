/datum/hud
	///UI for screentips that appear when you mouse over things
	var/atom/movable/screen/screentip/screentip_text

	/// Whether or not screentips are enabled.
	/// This is updated by the preference for cheaper reads than would be
	/// had with a proc call, especially on one of the hottest procs in the
	/// game (MouseEntered).
	var/screentips_enabled = TRUE

	/// The color to use for the screentips.
	/// This is updated by the preference for cheaper reads than would be
	/// had with a proc call, especially on one of the hottest procs in the
	/// game (MouseEntered).
	var/screentip_color = "#DEEFFF"

/datum/hud/New(mob/owner)
	. = ..()
	screentip_text = new(null, src)
	screentips_enabled = owner?.client?.prefs?.screentips
	static_inventory += screentip_text

/datum/hud/Destroy()
	QDEL_NULL(screentip_text)
	. = ..()
