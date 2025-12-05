/obj/item/hardpoint/support/humvee_overhead_lights
	name = "\improper JTMV overhead lights"
	desc = "Overhead lights for the JTMV. For when you really need to brighten your day."
	icon = 'icons/obj/vehicles/hardpoints/humvee.dmi'

	icon_state = "overlight"
	disp_icon = "humvee"
	disp_icon_state = "overlight"

	slot = HDPT_SUPPORT
	hdpt_layer = HDPT_LAYER_SUPPORT

	health = 150

	var/light_range_upgrade = 10
	var/light_power_upgrade = 8

/obj/item/hardpoint/support/humvee_overhead_lights/proc/turn_off_lights()
	var/obj/vehicle/multitile/humvee_owner = owner
	if(!istype(humvee_owner))
		return

	humvee_owner.lighting_holder.set_light_range(humvee_owner.vehicle_light_range)
	humvee_owner.lighting_holder.set_light_power(humvee_owner.vehicle_light_power)

/obj/item/hardpoint/support/humvee_overhead_lights/on_install(obj/vehicle/multitile/vehicle)
	. = ..()
	vehicle.lighting_holder.set_light_range(light_range_upgrade)
	vehicle.lighting_holder.set_light_power(light_power_upgrade)

/obj/item/hardpoint/support/humvee_overhead_lights/on_uninstall(obj/vehicle/multitile/vehicle)
	. = ..()
	turn_off_lights()

/obj/item/hardpoint/support/humvee_overhead_lights/on_destroy()
	. = ..()
	var/obj/vehicle/multitile/humvee_owner = owner
	if(!istype(humvee_owner))
		return
	turn_off_lights()



