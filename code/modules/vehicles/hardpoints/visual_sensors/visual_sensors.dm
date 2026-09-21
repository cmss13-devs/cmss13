/obj/item/hardpoint/visual_sensors
	name = "\improper visual sensors"
	desc = "External cameras and periscopes feeding the crew's view. Obscures their vision, like a fouled welding mask, as it takes damage."

	slot = HDPT_VISUAL_SENSORS
	hdpt_layer = HDPT_LAYER_SUPPORT

	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "camera-0"

	health = 350
	damage_multiplier = 0.2
	power_draw = VISUAL_SENSORS_POWER_DRAW

/obj/item/hardpoint/visual_sensors/uscm
	name = "\improper M39 visual sensors"
	desc = "The external cameras and periscopes feeding a USCM vehicle crew's view."

/obj/item/hardpoint/visual_sensors/update_icon()
	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "camera-[get_shared_damage_suffix()]"

/obj/item/hardpoint/visual_sensors/on_uninstall(obj/vehicle/multitile/vehicle)
	update_icon()
	. = ..()

/**
 * How obscured a seated crew member's vision should be right now.
 * Always maxed out if the vehicle has no power.
 *
 * Returns:
 * * A VISION_IMPAIR_* severity, from none to ultra when destroyed or unpowered.
 */
/obj/item/hardpoint/visual_sensors/proc/get_overlay_severity()
	if(!owner?.has_vehicle_power())
		return VISION_IMPAIR_ULTRA
	var/damage_scale = 1 - (get_integrity_percent() / 100)
	var/severity = damage_scale * VISION_IMPAIR_ULTRA + get_wound_effect_sum("vision_impair_add")
	return clamp(round(severity), VISION_IMPAIR_NONE, VISION_IMPAIR_ULTRA)

/obj/item/hardpoint/visual_sensors/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	. = ..()
	refresh_seated_overlays()

/obj/item/hardpoint/visual_sensors/recalculate_wound_effects()
	. = ..()
	refresh_seated_overlays()

/obj/item/hardpoint/visual_sensors/handle_repair(obj/item/tool/weldingtool/WT, mob/user)
	. = ..()
	refresh_seated_overlays()

/// Immediattely refreshes the vision-impair overlay for every currently seated crew member.
/obj/item/hardpoint/visual_sensors/proc/refresh_seated_overlays()
	if(!owner)
		return
	for(var/seat_key in owner.seats)
		owner.update_visual_sensor_overlay(owner.seats[seat_key])
