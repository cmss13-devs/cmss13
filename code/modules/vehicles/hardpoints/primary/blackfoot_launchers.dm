/obj/item/hardpoint/primary/blackfoot_launchers
	name = "\improper AG-66/L Blackfoot Launcher System"
	desc = "The Blackfoot Launcher System, commonly referred two as just 'blackfoots', is a variable payload dump-salvo type disposable munitions deployer, designed for short-range, quick-arming explosives to be fired in volleys from the quad-barrel launch tubes."

	icon = 'icons/obj/vehicles/hardpoints/blackfoot.dmi'
	icon_state = "launchers"
	disp_icon = "blackfoot"
	disp_icon_state = "launchers"

	activation_sounds = list('sound/vehicles/vtol/launcher.ogg')

	health = 500
	firing_arc = 180

	ammo = new /obj/item/ammo_magazine/hardpoint/blackfoot_launchers_ammo
	max_clips = 2

	gun_firemode = GUN_FIREMODE_SEMIAUTO
	gun_firemode_list = list(
		GUN_FIREMODE_SEMIAUTO,
	)
	fire_delay = 10 SECONDS

	allowed_seat = VEHICLE_DRIVER

	var/safety = TRUE

/obj/item/hardpoint/primary/blackfoot_launchers/get_icon_image(x_offset, y_offset, new_dir)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/image/icon = image(icon = disp_icon, icon_state = "[disp_icon_state]_[blackfoot_owner.get_sprite_state()]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

	return icon

/obj/item/hardpoint/primary/blackfoot_launchers/try_fire(atom/target, mob/living/user, params)
	if(safety)
		to_chat(user, SPAN_WARNING("Targeting mode is not enabled, unable to fire."))
		return

	if(ammo && ammo.current_rounds <= 0)
		reload(user)
		return

	return ..()

// Just removes the sleep because it sucks
/obj/item/hardpoint/primary/blackfoot_launchers/reload(mob/user)
	if(!LAZYLEN(backup_clips))
		to_chat(usr, SPAN_WARNING("\The [name] has no remaining backup clips."))
		return

	var/obj/item/ammo_magazine/new_magazine = LAZYACCESS(backup_clips, 1)
	if(!new_magazine)
		to_chat(user, SPAN_DANGER("Something went wrong! Ahelp and ask for a developer! Code: HP_RLDHP"))
		return

	ammo.forceMove(get_turf(src))
	ammo.update_icon()
	ammo = new_magazine
	LAZYREMOVE(backup_clips, new_magazine)

	to_chat(user, SPAN_NOTICE("You reload \the [name]."))
