/obj/item/hardpoint/primary/chimera_launchers
	name = "\improper Chimera Launchers"
	desc = ""

	icon_state = "ace_autocannon"
	activation_sounds = list('sound/vehicles/vtol/launcher.ogg')

	health = 500
	firing_arc = 180

	ammo = new /obj/item/ammo_magazine/hardpoint/chimera_launchers_ammo
	max_clips = 2

	gun_firemode = GUN_FIREMODE_SEMIAUTO
	gun_firemode_list = list(
		GUN_FIREMODE_SEMIAUTO,
	)
	fire_delay = 10 SECONDS

	var/safety = TRUE

/obj/item/hardpoint/primary/chimera_launchers/try_fire(atom/target, mob/living/user, params)
	if(safety)
		to_chat(user, SPAN_WARNING("Targeting mode is not enabled, unable to fire."))
		return

	if(ammo && ammo.current_rounds <= 0)
		reload(user)
		return
	
	return ..()

// Just removes the sleep because it sucks
/obj/item/hardpoint/primary/chimera_launchers/reload(mob/user)
	if(!LAZYLEN(backup_clips))
		to_chat(usr, SPAN_WARNING("\The [name] has no remaining backup clips."))
		return

	var/obj/item/ammo_magazine/A = LAZYACCESS(backup_clips, 1)
	if(!A)
		to_chat(user, SPAN_DANGER("Something went wrong! Ahelp and ask for a developer! Code: HP_RLDHP"))
		return

	forceMove(ammo, get_turf(src))
	ammo.update_icon()
	ammo = A
	LAZYREMOVE(backup_clips, A)

	to_chat(user, SPAN_NOTICE("You reload \the [name]."))
