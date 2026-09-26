/obj/item/hardpoint/secondary/doorgun
	name = "\improper Doorgun"
	desc = ""

	icon = 'icons/obj/vehicles/hardpoints/blackfoot.dmi'
	icon_state = "doorgun-module"

	activation_sounds = list('sound/vehicles/vtol/doorgun.ogg')

	health = 500
	firing_arc = 180

	ammo = new /obj/item/ammo_magazine/hardpoint/doorgun_ammo
	max_clips = 2

	gun_firemode = GUN_FIREMODE_SEMIAUTO
	gun_firemode_list = list(
		GUN_FIREMODE_SEMIAUTO,
	)
	fire_delay = 0.6 SECONDS

	allowed_seat = VEHICLE_GUNNER

	origins = list(0, 2)

	var/interior_type = /datum/map_template/interior/blackfoot_doorgun

/obj/item/hardpoint/secondary/doorgun/on_install(obj/vehicle/multitile/vehicle)
	if(!istype(vehicle, /obj/vehicle/multitile/blackfoot))
		return

	var/obj/vehicle/multitile/blackfoot/blackfoot = vehicle
	
	blackfoot.interior = new(blackfoot)
	blackfoot.interior_map = interior_type
	INVOKE_ASYNC(blackfoot, TYPE_PROC_REF(/obj/vehicle/multitile, do_create_interior))
	blackfoot.update_icon()

/obj/item/hardpoint/secondary/doorgun/reset_rotation()
	rotate(turning_angle(dir, NORTH))

/obj/item/hardpoint/secondary/doorgun/in_firing_arc(atom/target)
	return !..() // Just return the opposite since it fires in the back

/obj/item/hardpoint/secondary/doorgun/try_fire(atom/target, mob/living/user, params)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	if(!blackfoot_owner.back_door || !blackfoot_owner.back_door.open)
		to_chat(user, SPAN_WARNING("You should probably open the rear door before firing."))
		return
	
	if(ammo && ammo.current_rounds <= 0)
		reload(user)
		return

	return ..()

// Just removes the sleep because it sucks
/obj/item/hardpoint/secondary/doorgun/reload(mob/user)
	if(!LAZYLEN(backup_clips))
		to_chat(usr, SPAN_WARNING("\The [name] has no remaining backup clips."))
		return

	var/obj/item/ammo_magazine/A = LAZYACCESS(backup_clips, 1)
	if(!A)
		to_chat(user, SPAN_DANGER("Something went wrong! Ahelp and ask for a developer! Code: HP_RLDHP"))
		return

	ammo.forceMove(get_turf(src))
	ammo.update_icon()
	ammo = A
	LAZYREMOVE(backup_clips, A)

	to_chat(user, SPAN_NOTICE("You reload \the [name]."))

/obj/item/hardpoint/secondary/doorgun/can_be_removed(mob/remover)
	to_chat(remover, SPAN_WARNING("[src] cannot be removed from [owner]."))
	return FALSE

