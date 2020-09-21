//The Marine mortar, the M402 Mortar
//Works like a contemporary crew weapon mortar

/obj/structure/mortar
	name = "\improper M402 mortar"
	desc = "A manual, crew-operated mortar system intended to rain down 80mm goodness on anything it's aimed at. Uses an advanced targeting computer. Insert round to fire."
	icon = 'icons/obj/structures/mortar.dmi'
	icon_state = "mortar_m402"
	anchored = 1
	unslashable = TRUE
	unacidable = TRUE
	density = 1
	layer = ABOVE_MOB_LAYER //So you can't hide it under corpses
	flags_atom = RELAY_CLICK
	var/computer_enabled = TRUE
	var/targ_x = 0 //Initial target coordinates
	var/targ_y = 0
	var/offset_x = 0 //Automatic offset from target
	var/offset_y = 0
	var/offset_per_turfs = 20 //Number of turfs to offset from target by 1
	var/dial_x = 0 //Dial adjustment from target
	var/dial_y = 0
	var/travel_time = 45 //Constant, assuming perfect parabolic trajectory. ONLY THE DELAY BEFORE INCOMING WARNING WHICH ADDS 45 TICKS
	var/busy = 0
	var/firing = 0 //Used for deconstruction and aiming sanity
	var/fixed = 0 //If set to 1, can't unanchor and move the mortar, used for map spawns and WO
	var/has_created_ceiling_debris = 0 //prevents mortar from creating endless piles of glass shards

/obj/structure/mortar/New()
	. = ..()
	targ_x = deobfuscate_x(0)//Makes coords appear as 0 in UI
	targ_y = deobfuscate_y(0)

/obj/structure/mortar/attack_hand(mob/user as mob)
	if(isYautja(user))
		to_chat(user, SPAN_WARNING("You kick [src] but nothing happens."))
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You don't have the training to use [src]."))
		return
	if(busy)
		to_chat(user, SPAN_WARNING("Someone else is currently using [src]."))
		return
	if(firing)
		to_chat(user, SPAN_WARNING("[src]'s barrel is still steaming hot. Wait a few seconds and stop firing it."))
		return
	add_fingerprint(user)

	if(computer_enabled)
		ui_interact(user)
	else
		var/choice = alert(user, "Would you like to set the mortar's target coordinates, or dial the mortar? Setting coordinates will make you lose your fire adjustment.", "Mortar Dialing", "Target", "Dial", "Cancel")
		if(choice == "Cancel")
			return
		if(choice == "Target")
			handle_target(TRUE, user)
		if(choice == "Dial")
			handle_dial(TRUE, user)

/obj/structure/mortar/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	var/list/data = list(
		"src" = "\ref[src]",//Needed to use forms with Topic()
		"target_x" = obfuscate_x(targ_x),
		"target_y" = obfuscate_y(targ_y),
		"dial_x" = dial_x,
		"dial_y" = dial_y,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "mortar.tmpl", "Mortar Targeting Computer" , 340, 270)
		ui.add_script("mortar.js")
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(FALSE)//Auto update is NOT compatible with forms.

/obj/structure/mortar/Topic(href, href_list)
	var/mob/user = usr
	if(get_dist(user, src) > 1)
		return
	switch(href_list["choice"])
		if ("target")
			handle_target(FALSE, user, text2num(href_list["target_x"]), text2num(href_list["target_y"]))

		if ("dial")
			handle_dial(FALSE, user, text2num(href_list["dial_x"]), text2num(href_list["dial_y"]))
			
	ui_interact(user)

/obj/structure/mortar/proc/handle_target(var/manual, var/mob/user, var/temp_targ_x = 0, var/temp_targ_y = 0)
	if(manual)
		temp_targ_x = input("Input the longitude of the target.") as num
		temp_targ_y = input("Input the latitude of the target.") as num
	if(dial_x + deobfuscate_x(temp_targ_x) > world.maxx || dial_x + deobfuscate_x(temp_targ_x) < 0)
		to_chat(user, SPAN_WARNING("You cannot aim at this coordinate, it is outside of the area of operations."))
		return
	if(dial_y + deobfuscate_y(temp_targ_y) > world.maxy || dial_y + deobfuscate_y(temp_targ_y) < 0)
		to_chat(user, SPAN_WARNING("You cannot aim at this coordinate, it is outside of the area of operations."))
		return
	var/turf/T = locate(deobfuscate_x(temp_targ_x) + dial_x, deobfuscate_y(temp_targ_y) + dial_y, z)
	if(get_dist(loc, T) < 10)
		to_chat(user, SPAN_WARNING("You cannot aim at this coordinate, it is too close to your mortar."))
		return
	if(busy)
		to_chat(user, SPAN_WARNING("Someone else is currently using this mortar."))
		return
	user.visible_message(SPAN_NOTICE("[user] starts adjusting [src]'s firing angle and distance."),
	SPAN_NOTICE("You start adjusting [src]'s firing angle and distance to match the new coordinates."))
	busy = 1
	if(manual)
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	else
		playsound(loc, 'sound/machines/scanning.ogg', 25, 1)
	if(do_after(user, SECONDS_3, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		user.visible_message(SPAN_NOTICE("[user] finishes adjusting [src]'s firing angle and distance."),
		SPAN_NOTICE("You finish adjusting [src]'s firing angle and distance to match the new coordinates."))
		busy = 0
		targ_x = deobfuscate_x(temp_targ_x)
		targ_y = deobfuscate_y(temp_targ_y)
		var/offset_x_max = round(abs((targ_x + dial_x) - x)/offset_per_turfs) //Offset of mortar shot, grows by 1 every 20 tiles travelled
		var/offset_y_max = round(abs((targ_y + dial_y) - y)/offset_per_turfs)
		offset_x = rand(-offset_x_max, offset_x_max)
		offset_y = rand(-offset_y_max, offset_y_max)
	else busy = 0

/obj/structure/mortar/proc/handle_dial(var/manual, var/mob/user, var/temp_dial_x = 0, var/temp_dial_y = 0)
	if(manual)
		temp_dial_x = input("Set longitude adjustement from -10 to 10.") as num
		temp_dial_y = input("Set latitude adjustement from -10 to 10.") as num
	if(temp_dial_x + targ_x > world.maxx || temp_dial_x + targ_x < 0)
		to_chat(user, SPAN_WARNING("You cannot dial to this coordinate, it is outside of the area of operations."))
		return
	if(temp_dial_x < -10 || temp_dial_x > 10)
		to_chat(user, SPAN_WARNING("You cannot dial to this coordinate, it is too far away. You need to set [src] up instead."))
		return
	if(temp_dial_y + targ_y > world.maxy || temp_dial_y + targ_y < 0)
		to_chat(user, SPAN_WARNING("You cannot dial to this coordinate, it is outside of the area of operations."))
		return
	if(get_dist(loc, locate(targ_x + temp_dial_x, targ_y + temp_dial_y, z)) < 10)
		to_chat(user, SPAN_WARNING("You cannot dial to this coordinate, it is too close to your mortar."))
		return
	if(temp_dial_y < -10 || temp_dial_y > 10)
		to_chat(user, SPAN_WARNING("You cannot dial to this coordinate, it is too far away. You need to set [src] up instead."))
		return
	if(busy)
		to_chat(user, SPAN_WARNING("Someone else is currently using this mortar."))
		return
	user.visible_message(SPAN_NOTICE("[user] starts dialing [src]'s firing angle and distance."),
	SPAN_NOTICE("You start dialing [src]'s firing angle and distance to match the new coordinates."))
	busy = 1
	if(manual)
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	else
		playsound(loc, 'sound/machines/scanning.ogg', 25, 1)
	if(do_after(user, 1.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		user.visible_message(SPAN_NOTICE("[user] finishes dialing [src]'s firing angle and distance."),
		SPAN_NOTICE("You finish dialing [src]'s firing angle and distance to match the new coordinates."))
		busy = 0
		dial_x = temp_dial_x
		dial_y = temp_dial_y
	else busy = 0

/obj/structure/mortar/attackby(var/obj/item/O as obj, mob/user as mob)

	if(istype(O, /obj/item/mortar_shell))

		var/obj/item/mortar_shell/mortar_shell = O
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You don't have the training to fire [src]."))
			return
		if(busy)
			to_chat(user, SPAN_WARNING("Someone else is currently using [src]."))
			return
		if(z != 1)
			to_chat(user, SPAN_WARNING("You cannot fire [src] here."))
			return
		if(targ_x == 0 && targ_y == 0) //Mortar wasn't set
			to_chat(user, SPAN_WARNING("[src] needs to be aimed first."))
			return
		var/turf/T = locate(targ_x + dial_x + offset_x, targ_y + dial_y + offset_y, z)
		if(!isturf(T))
			to_chat(user, SPAN_WARNING("You cannot fire [src] to this target."))
			return
		var/area/A = get_area(T)
		if((istype(A) && A.ceiling >= CEILING_UNDERGROUND) || protected_by_pylon(TURF_PROTECTION_MORTAR, T))
			to_chat(user, SPAN_WARNING("You cannot hit the target. It is probably underground."))
			return

		//Small amount of spread so that consecutive mortar shells don't all land on the same tile
		var/turf/T1 = locate(T.x + pick(-1,0,0,1), T.y + pick(-1,0,0,1), T.z)
		if(isturf(T1))
			T = T1

		user.visible_message(SPAN_NOTICE("[user] starts loading \a [mortar_shell.name] into [src]."),
		SPAN_NOTICE("You start loading \a [mortar_shell.name] into [src]."))
		playsound(loc, 'sound/weapons/gun_mortar_reload.ogg', 50, 1)
		busy = 1
		if(do_after(user, 1.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			user.visible_message(SPAN_NOTICE("[user] loads \a [mortar_shell.name] into [src]."),
			SPAN_NOTICE("You load \a [mortar_shell.name] into [src]."))
			visible_message("[htmlicon(src, viewers(src))] [SPAN_DANGER("The [name] fires!")]")
			user.drop_inv_item_to_loc(mortar_shell, src)
			playsound(loc, 'sound/weapons/gun_mortar_fire.ogg', 50, 1)
			busy = 0
			firing = 1
			flick(icon_state + "_fire", src)
			mortar_shell.source_mob = user
			mortar_shell.forceMove(src)

			if(!has_created_ceiling_debris)
				var/turf/G = get_turf(src)
				G.ceiling_debris_check(2)
				has_created_ceiling_debris = 1

			for(var/mob/M in range(7))
				shake_camera(M, 3, 1)
			spawn(travel_time) //What goes up
				playsound(T, 'sound/weapons/gun_mortar_travel.ogg', 50, 1)
				spawn(45) //Must go down //This should always be 45 ticks!
					T.ceiling_debris_check(2)
					mortar_shell.detonate(T)
					qdel(mortar_shell)
					firing = 0
		else
			busy = 0

	if(istype(O, /obj/item/tool/wrench))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You don't have the training to undeploy [src]."))
			return
		if(fixed)
			to_chat(user, SPAN_WARNING("[src]'s supports are bolted and welded into the floor. It looks like it's going to be staying there."))
			return
		if(busy)
			to_chat(user, SPAN_WARNING("Someone else is currently using [src]."))
			return
		if(firing)
			to_chat(user, SPAN_WARNING("[src]'s barrel is still steaming hot. Wait a few seconds and stop firing it."))
			return
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] starts undeploying [src]."), \
				SPAN_NOTICE("You start undeploying [src]."))
		if(do_after(user, SECONDS_4, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user] undeploys [src]."), \
				SPAN_NOTICE("You undeploy [src]."))
			playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
			new /obj/item/mortar_kit(loc)
			qdel(src)

	if(istype(O, /obj/item/tool/screwdriver))
		if(do_after(user, SECONDS_1, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user] toggles the targeting computer on [src]."), \
				SPAN_NOTICE("You toggle the targeting computer on [src]."))
			computer_enabled = !computer_enabled
			playsound(loc, 'sound/machines/switch.ogg', 25, 1)

/obj/structure/mortar/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
	return

/obj/structure/mortar/fixed
	desc = "A manual, crew-operated mortar system intended to rain down 80mm goodness on anything it's aimed at. Uses manual targetting dials. Insert round to fire. This one is bolted and welded into the ground."
	fixed = 1

//The portable mortar item
/obj/item/mortar_kit
	name = "\improper M402 mortar portable kit"
	desc = "A manual, crew-operated mortar system intended to rain down 80mm goodness on anything it's aimed at. Needs to be set down first"
	icon = 'icons/obj/structures/mortar.dmi'
	icon_state = "mortar_m402_carry"
	unacidable = TRUE
	w_class = SIZE_HUGE //No dumping this in a backpack. Carry it, fatso

/obj/item/mortar_kit/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
	return

/obj/item/mortar_kit/attack_self(mob/user)

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You don't have the training to deploy [src]."))
		return
	if(user.z != 1)
		to_chat(user, SPAN_WARNING("You cannot deploy [src] here."))
		return
	var/area/A = get_area(src)
	if(A.ceiling >= CEILING_METAL)
		to_chat(user, SPAN_WARNING("You probably shouldn't deploy [src] indoors."))
		return
	user.visible_message(SPAN_NOTICE("[user] starts deploying [src]."), \
		SPAN_NOTICE("You start deploying [src]."))
	playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
	if(do_after(user, SECONDS_4, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		user.visible_message(SPAN_NOTICE("[user] deploys [src]."), \
			SPAN_NOTICE("You deploy [src]."))
		playsound(loc, 'sound/weapons/gun_mortar_unpack.ogg', 25, 1)
		var/obj/structure/mortar/M = new /obj/structure/mortar(get_turf(user))
		M.dir = user.dir
		qdel(src)

/obj/item/mortar_shell
	name = "\improper 80mm mortar shell"
	desc = "An unlabeled 80mm mortar shell, probably a casing."
	icon = 'icons/obj/structures/mortar.dmi'
	icon_state = "mortar_ammo_cas"
	w_class = SIZE_HUGE
	flags_atom = FPRINT|CONDUCT
	var/source_mob

/obj/item/mortar_shell/proc/detonate(var/turf/T)
	forceMove(T)

/obj/item/mortar_shell/he
	name = "\improper 80mm high explosive mortar shell"
	desc = "An 80mm mortar shell, loaded with a high explosive charge."
	icon_state = "mortar_ammo_he"

/obj/item/mortar_shell/he/detonate(var/turf/T)
	explosion(T, 0, 3, 5, 7, , , , initial(name), source_mob)

/obj/item/mortar_shell/frag
	name = "\improper 80mm fragmentation mortar shell"
	desc = "An 80mm mortar shell, loaded with a fragmentation charge."
	icon_state = "mortar_ammo_frag"

/obj/item/mortar_shell/frag/detonate(var/turf/T)
	create_shrapnel(T, 60, shrapnel_source = initial(name), shrapnel_source_mob = source_mob)
	sleep(2)
	cell_explosion(T, 60, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, initial(name), source_mob)

/obj/item/mortar_shell/incendiary
	name = "\improper 80mm incendiary mortar shell"
	desc = "An 80mm mortar shell, loaded with a napalm charge."
	icon_state = "mortar_ammo_inc"

/obj/item/mortar_shell/incendiary/detonate(var/turf/T)
	explosion(T, 0, 2, 4, 7, , , , initial(name), source_mob)
	flame_radius(initial(name), source_mob, 5, T)
	playsound(T, 'sound/weapons/gun_flamethrower2.ogg', 35, 1, 4)

/obj/item/mortar_shell/flare
	name = "\improper 80mm flare mortar shell"
	desc = "An 80mm mortar shell, loaded with an illumination flare."
	icon_state = "mortar_ammo_flr"

/obj/item/mortar_shell/flare/detonate(var/turf/T)
	new /obj/item/device/flashlight/flare/on/illumination(T)
	playsound(T, 'sound/weapons/gun_flare.ogg', 50, 1, 4)

/obj/item/mortar_shell/custom
	name = "\improper 80mm custom mortar shell"
	desc = "An 80mm mortar shell."
	icon_state = "mortar_ammo_custom"
	matter = list("metal" = 18750) //5 sheets
	var/obj/item/explosive/warhead/mortar/warhead
	var/obj/item/reagent_container/glass/fuel
	var/fuel_requirement = 60
	var/fuel_type = "hydrogen"
	var/locked = FALSE

/obj/item/mortar_shell/custom/detonate(var/turf/T)
	if(fuel)
		var/fuel_amount = fuel.reagents.get_reagent_amount(fuel_type)
		if(fuel_amount >= fuel_requirement)
			forceMove(T)
	if(warhead && locked && warhead.detonator)
		warhead.prime()

/obj/item/mortar_shell/custom/attack_self(mob/user as mob)
	if(!locked)
		if(warhead)
			user.put_in_hands(warhead)
			warhead = null
		else if(fuel)
			user.put_in_hands(fuel)
			fuel = null
		icon_state = initial(icon_state)
		desc = initial(desc) + "\n Contains[fuel?" fuel":""] [warhead?" and warhead":""]."
		return

/obj/item/mortar_shell/custom/attackby(obj/item/W as obj, mob/user as mob)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You do not know how to tinker with [name]."))
		return
	if(istype(W,/obj/item/tool/screwdriver))
		if(!warhead)
			to_chat(user, SPAN_NOTICE("[name] must contain a warhead to do that!"))
			return
		if(locked)
			to_chat(user, SPAN_NOTICE("You unlock [name]."))
			icon_state = initial(icon_state) +"_unlocked"
		else
			to_chat(user, SPAN_NOTICE("You lock [name]."))
			if(fuel && fuel.reagents.get_reagent_amount(fuel_type) >= fuel_requirement)
				icon_state = initial(icon_state) +"_locked"
			else
				icon_state = initial(icon_state) +"_no_fuel"
		locked = !locked
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 0, 6)
		return
	else if(istype(W,/obj/item/reagent_container/glass) && !locked)
		if(fuel)
			to_chat(user, SPAN_DANGER("The [name] already has a fuel container!"))
			return
		else
			user.temp_drop_inv_item(W)
			W.forceMove(src)
			fuel = W
			to_chat(user, SPAN_DANGER("You add [W] to [name]."))
			desc = initial(desc) + "\n Contains[fuel?" fuel":""] [warhead?" and warhead":""]."
			playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)
	else if(istype(W,/obj/item/explosive/warhead/mortar) && !locked)
		if(warhead)
			to_chat(user, SPAN_DANGER("The [name] already has a warhead!"))
			return
		var/obj/item/explosive/warhead/mortar/det = W
		if(det.assembly_stage < ASSEMBLY_LOCKED)
			to_chat(user, SPAN_DANGER("The [W] is not secured!"))
			return
		user.temp_drop_inv_item(W)
		W.forceMove(src)
		warhead = W
		to_chat(user, SPAN_DANGER("You add [W] to [name]."))
		icon_state = initial(icon_state) +"_unlocked"
		desc = initial(desc) + "\n Contains[fuel?" fuel":""] [warhead?" and warhead":""]."
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)

//Special flare subtype for the illumination flare shell
//Acts like a flare, just even stronger, and set length
/obj/item/device/flashlight/flare/on/illumination

	name = "illumination flare"
	desc = "It's really bright, and unreachable."
	icon_state = "" //No sprite
	invisibility = 101 //Can't be seen or found, it's "up in the sky"
	mouse_opacity = 0
	brightness_on = 7 //Way brighter than most lights

/obj/item/device/flashlight/flare/on/illumination/New()
	..()
	fuel = rand(400, 500) // Half the duration of a flare, but justified since it's invincible

/obj/item/device/flashlight/flare/on/illumination/turn_off()
	..()
	qdel(src)

/obj/item/device/flashlight/flare/on/illumination/ex_act(severity)
	return //Nope

/obj/structure/closet/crate/secure/mortar_ammo
	name = "\improper M402 mortar ammo crate"
	desc = "A crate containing live mortar shells with various payloads. DO NOT DROP. KEEP AWAY FROM FIRE SOURCES."
	icon = 'icons/obj/structures/mortar.dmi'
	icon_state = "secure_locked_mortar"
	icon_opened = "secure_open_mortar"
	icon_locked = "secure_locked_mortar"
	icon_unlocked = "secure_unlocked_mortar"
	req_one_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_CARGO, ACCESS_MARINE_ENGPREP)

/obj/structure/closet/crate/secure/mortar_ammo/full/New()
	..()
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/frag(src)
	new /obj/item/mortar_shell/frag(src)
	new /obj/item/mortar_shell/frag(src)
	new /obj/item/mortar_shell/frag(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/mortar_shell/flare(src)

/obj/structure/closet/crate/secure/mortar_ammo/mortar_kit
	name = "\improper M402 mortar kit"
	desc = "A crate containing a basic set of a mortar and some shells, to get an engineer started."

/obj/structure/closet/crate/secure/mortar_ammo/mortar_kit/New()
	..()
	new /obj/item/mortar_kit(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/frag(src)
	new /obj/item/mortar_shell/frag(src)
	new /obj/item/mortar_shell/frag(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/device/encryptionkey/engi(src)
	new /obj/item/device/encryptionkey/engi(src)
	new /obj/item/device/encryptionkey/jtac(src)
	new /obj/item/device/encryptionkey/jtac(src)
	new /obj/item/device/binoculars/range(src)
	new /obj/item/device/binoculars/range(src)

/obj/structure/mortar/wo
	//offset_per_turfs = 1
	fixed = 1