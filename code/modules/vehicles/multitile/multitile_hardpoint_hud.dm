/**
 * Vehicle hardpoint status HUD. A west-side vertical stack of 16x16 icons, one per hardpoint slot
 * the vehicle's design supports, plus "hull". Only visible to viewers granted GLOB.vehicle_hardpoint_hud.
 *
 * Refreshed on a plain timer (hardpoint_hud_loop()) rather than hooked into every damage/wound/
 * install/uninstall call site, since this is a passive diagnostic display, not a twitch mechanic.
 */

/// slot string to HUD sprite icon_state. Keep in sync with GLOB.hardpoint_hud_slot_order below.
/proc/get_hardpoint_hud_sprite(slot)
	switch(slot)
		if(WOUND_SLOT_HULL)
			return "hull"
		if(HDPT_ENGINE)
			return "engine"
		if(HDPT_TREADS, HDPT_WHEELS)
			return "wheels"
		if(HDPT_FUEL_TANK)
			return "fuel_tank"
		if(HDPT_RADIATOR)
			return "radiator"
		if(HDPT_BATTERY)
			return "battery"
		if(HDPT_ARMOR)
			return "armor"
		if(HDPT_TURRET)
			return "turret"
		if(HDPT_TURRET_RING)
			return "turret_ring"
		if(HDPT_PRIMARY)
			return "primary"
		if(HDPT_SECONDARY)
			return "secondary"
		if(HDPT_IFF_MODULE)
			return "iff"
		if(HDPT_VISUAL_SENSORS)
			return "sensors"
		if(HDPT_AIR_FILTER)
			return "air_filter"
	return null

/// Vertical stacking order (top to bottom) for every slot the hardpoint HUD knows how to render.
GLOBAL_LIST_INIT(hardpoint_hud_slot_order, list(
	WOUND_SLOT_HULL,
	HDPT_ENGINE,
	HDPT_TREADS,
	HDPT_WHEELS,
	HDPT_FUEL_TANK,
	HDPT_RADIATOR,
	HDPT_BATTERY,
	HDPT_ARMOR,
	HDPT_TURRET,
	HDPT_TURRET_RING,
	HDPT_PRIMARY,
	HDPT_SECONDARY,
	HDPT_IFF_MODULE,
	HDPT_VISUAL_SENSORS,
	HDPT_AIR_FILTER,
))

/**
 * Maps a wound family to the outline color its wound type should render as. Brute families are red,
 * acid families are green, and "gunked" families are yellow/gold despite being flagged acid.
 */
/proc/get_hardpoint_hud_wound_color(datum/hardpoint_wound_family/family)
	if(family.neuro_alt_trigger_only)
		return COLOR_YELLOW
	if(family.damage_type == WOUND_DAMTYPE_ACID)
		return COLOR_GREEN
	return COLOR_RED

/**
 * Every currently-active wound on a hardpoint/hull, as outline colors ordered most-to-least severe.
 * Uses a plain insertion sort since there are never more than a handful of wound families at once.
 *
 * Arguments:
 * * wound_tiers = A hardpoint's own wound_tiers or a vehicle's hull_wound_tiers.
 */
/proc/get_hardpoint_hud_wound_colors(list/wound_tiers)
	var/list/tier_color_pairs = list()
	for(var/family_type in wound_tiers)
		var/tier = wound_tiers[family_type]
		if(!tier)
			continue
		var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
		if(!family)
			continue
		tier_color_pairs += list(list(tier, get_hardpoint_hud_wound_color(family)))

	for(var/i in 2 to length(tier_color_pairs))
		var/list/current = tier_color_pairs[i]
		var/j = i - 1
		while(j >= 1 && tier_color_pairs[j][1] < current[1])
			tier_color_pairs[j + 1] = tier_color_pairs[j]
			j--
		tier_color_pairs[j + 1] = current

	. = list()
	for(var/list/pair in tier_color_pairs)
		. += pair[2]

/**
 * Builds one slot's outline overlay image(s) from its sorted wound colors. None for 0 wounds,
 * full_outline for 1, tr_outline + bl_outline for 2. For 3+, only the 3 most severe show:
 * tr_outline holds the worst solid, bl_outline alternates the other two by blink_phase.
 */
/proc/build_hardpoint_hud_outlines(list/colors, blink_phase)
	. = list()
	switch(length(colors))
		if(0)
			return
		if(1)
			. += get_hardpoint_hud_outline_image("full_outline", colors[1])
		if(2)
			. += get_hardpoint_hud_outline_image("tr_outline", colors[1])
			. += get_hardpoint_hud_outline_image("bl_outline", colors[2])
		else
			. += get_hardpoint_hud_outline_image("tr_outline", colors[1])
			. += get_hardpoint_hud_outline_image("bl_outline", blink_phase ? colors[2] : colors[3])

/**
 * Builds one wound-outline overlay image, colored independently of the base part icon's integrity
 * color. RESET_COLOR is required on the overlay itself, or it blends with the parent's color
 * instead of rendering its own.
 */
/proc/get_hardpoint_hud_outline_image(icon_state, color)
	var/image/outline = image('icons/obj/vehicles/hud/tankhud.dmi', icon_state = icon_state)
	outline.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR
	outline.color = color
	return outline

/**
 * White at full integrity, dark grey once destroyed, a green-to-red linear blend in between.
 * Missing-but-slot-exists hardpoints get the same dark grey via the caller passing null instead.
 */
/proc/get_hardpoint_hud_integrity_color(percent)
	if(percent >= 100)
		return COLOR_WHITE
	if(percent <= 0)
		return HARDPOINT_HUD_DESTROYED_COLOR
	return rgb(round(255 * (1 - percent / 100)), round(255 * (percent / 100)), 0)

/**
 * This vehicle's ordered list of hardpoint HUD slots to display right now: every slot
 * hardpoints_allowed declares, plus every slot any currently-installed holder's accepted_hardpoints
 * declares, plus "hull" always. Filtered and ordered by GLOB.hardpoint_hud_slot_order.
 */
/obj/vehicle/multitile/proc/get_hardpoint_hud_design_slots()
	var/list/design_slots = list()
	for(var/hardpoint_type in hardpoints_allowed)
		design_slots[initial(hardpoint_type:slot)] = TRUE
	for(var/obj/item/hardpoint/holder/installed_holder in hardpoints)
		for(var/nested_type in installed_holder.accepted_hardpoints)
			design_slots[initial(nested_type:slot)] = TRUE
	design_slots[WOUND_SLOT_HULL] = TRUE

	. = list()
	for(var/slot in GLOB.hardpoint_hud_slot_order)
		if(design_slots[slot])
			. += slot

/**
 * The live integrity percent and wound_tiers for one slot right now. Null percent means the slot
 * is design-supported but nothing is currently installed there.
 *
 * Returns:
 * * list(percent or null, wound_tiers list or null)
 */
/obj/vehicle/multitile/proc/get_hardpoint_hud_state(slot)
	if(slot == WOUND_SLOT_HULL)
		return list(initial(health) ? (100.0 * health / initial(health)) : 100, hull_wound_tiers)
	for(var/obj/item/hardpoint/installed as anything in get_hardpoints_copy())
		if(installed.slot == slot)
			return list(installed.get_integrity_percent(), installed.wound_tiers)
	return list(null, null)

/// Starts this vehicle's hardpoint HUD refresh loop, called once from Initialize(). Ends on deletion.
/obj/vehicle/multitile/proc/hardpoint_hud_loop()
	while(!QDELETED(src))
		update_hardpoint_hud()
		sleep(HARDPOINT_HUD_UPDATE_INTERVAL)

/**
 * Rebuilds this vehicle's entire hardpoint HUD state for the current tick: which slots to show,
 * each slot's base icon color, and each slot's wound outline(s). Slot images are only created or
 * destroyed here when the design-supported slot list actually changes.
 */
/obj/vehicle/multitile/proc/update_hardpoint_hud()
	var/list/new_slots = get_hardpoint_hud_design_slots()
	var/blink_phase = (world.time % (2 * HARDPOINT_HUD_BLINK_HALF_PERIOD)) < HARDPOINT_HUD_BLINK_HALF_PERIOD

	for(var/slot in hardpoint_hud_images)
		if(slot in new_slots)
			continue
		var/image/old_image = hardpoint_hud_images[slot]
		GLOB.vehicle_hardpoint_hud.sync_single_image(src, old_image, null)
		hardpoint_hud_images -= slot

	for(var/slot in new_slots)
		if(hardpoint_hud_images[slot])
			continue
		var/image/new_image = image('icons/obj/vehicles/hud/tankhud.dmi', src, get_hardpoint_hud_sprite(slot))
		new_image.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR
		hardpoint_hud_images[slot] = new_image
		GLOB.vehicle_hardpoint_hud.sync_single_image(src, null, new_image)

	// Two columns instead of one long column. Up to 15 slots would tower over the vehicle otherwise.
	var/slot_count = length(new_slots)
	var/row_count = CEILING(slot_count / 2, 1)
	var/index = 0
	for(var/slot in new_slots)
		var/image/element = hardpoint_hud_images[slot]
		var/column = index % 2
		var/row = (index - column) / 2
		element.pixel_x = HARDPOINT_HUD_PIXEL_X + (column ? HARDPOINT_HUD_ICON_SIZE / 2 : -HARDPOINT_HUD_ICON_SIZE / 2)
		element.pixel_y = (row_count - 1 - row) * HARDPOINT_HUD_ICON_SIZE - (row_count * HARDPOINT_HUD_ICON_SIZE) / 2 + HARDPOINT_HUD_PIXEL_Y_OFFSET
		index++

		var/list/hud_state = get_hardpoint_hud_state(slot)
		var/percent = hud_state[1]
		element.color = isnull(percent) ? HARDPOINT_HUD_DESTROYED_COLOR : get_hardpoint_hud_integrity_color(percent)
		element.overlays = build_hardpoint_hud_outlines(get_hardpoint_hud_wound_colors(hud_state[2]), blink_phase)
