/**
 * Multitool -- A multitool is used for hacking electronic devices.
 */

/obj/item/device/multitool
	name = "\improper Security Access Tuner" //Thats what is is in-universe. From Alien: Isolation.
	desc = "A small handheld tool used to override various machine functions. Primarily used to pulse Airlock and APC wires on a shortwave frequency. It contains a small data buffer as well."
	icon_state = "multitool"
	item_state = "multitool"
	pickup_sound = 'sound/handling/multitool_pickup.ogg'
	drop_sound = 'sound/handling/multitool_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	force = 5
	w_class = SIZE_SMALL
	throwforce = 5
	throw_range = 15
	throw_speed = SPEED_VERY_FAST

	matter = list("metal" = 50,"glass" = 20)
	inherent_traits = list(TRAIT_TOOL_MULTITOOL)
	preferred_storage = list(/obj/item/clothing/accessory/storage/tool_webbing = WEAR_ACCESSORY)
	var/hack_speed = 10 SECONDS // Only used for vendors right now
	var/next_scan

	var/list/encryption_keys = list()

/obj/item/device/multitool/proc/load_encryption_key(key, obj/object)
	encryption_keys[key] = WEAKREF(object)

/obj/item/device/multitool/proc/has_encryption_key(key)
	if(encryption_keys[key])
		return TRUE
	return FALSE

/obj/item/device/multitool/proc/remove_encryption_key(key)
	return encryption_keys.Remove(key)

/obj/item/device/multitool/attack(mob/M as mob, mob/user as mob)
	return FALSE

/obj/item/device/multitool/afterattack(atom/target, mob/user, flag)
	for(var/obj/item/explosive/plastic/E in target.contents)
		E.attackby(src, user)
		return
	. = ..()

/obj/item/device/multitool/attack_self(mob/user)
	..()

	if(world.time < next_scan || !ishuman(user) || !skillcheck(user,SKILL_ENGINEER,SKILL_ENGINEER_NOVICE))
		return

	next_scan = world.time + 15
	var/area/A = get_area(src)
	var/atom/APC = A? A.get_apc() : null
	if(APC)
		to_chat(user, SPAN_NOTICE("The local APC is located at [SPAN_BOLD("[get_dist(src, APC)] units [dir2text(Get_Compass_Dir(src, APC))]")]."))
		user.balloon_alert(user, "[get_dist(src, APC)] units [dir2text(Get_Compass_Dir(src, APC))]")
		if(user.client)
			//Create the appearance so we have something to apply the filter to.
			var/mutable_appearance/apc_appearance = new(APC)
			apc_appearance.filters += list("type" = "outline", "size" = 1, "color" = COLOR_GREEN)
			//Make it an image we can give to the client
			var/image/final_image = image(apc_appearance)

			final_image.layer = WALL_OBJ_LAYER
			final_image.plane = GAME_PLANE
			final_image.loc = get_turf(APC)
			final_image.dir = apc_appearance.dir
			final_image.alpha = 225
			user.client.images += final_image
			addtimer(CALLBACK(src, PROC_REF(remove_apc_highlight), user.client, final_image), 1.4 SECONDS)


	else
		to_chat(user, SPAN_WARNING("ERROR: Could not locate local APC."))
		user.balloon_alert(user, "could not locate!")

/obj/item/device/multitool/proc/remove_apc_highlight(client/user_client, image/highlight_image)
	if(!user_client)
		return
	user_client.images -= highlight_image

