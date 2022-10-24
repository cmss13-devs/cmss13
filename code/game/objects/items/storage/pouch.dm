/obj/item/storage/pouch
	name = "abstract pouch"
	desc = "The physical manifestation of a concept of a pouch. Woah."
	icon = 'icons/obj/items/clothing/pouches.dmi'
	icon_state = "small_drop"
	w_class = SIZE_LARGE //does not fit in backpack
	max_w_class = SIZE_SMALL
	flags_equip_slot = SLOT_STORE
	storage_slots = 1
	storage_flags = STORAGE_FLAGS_POUCH
	cant_hold = list(/obj/item/weapon/melee/throwing_knife)
	///If it closes a flap over its contents, and therefore update_icon should lift that flap when opened. If it doesn't have _half and _full iconstates, this doesn't matter either way.
	var/flap = TRUE

/obj/item/storage/pouch/update_icon()
	overlays.Cut()
	if(!length(contents))
		return TRUE //For the pistol pouch to know it's empty.
	if(content_watchers && flap) //If it has a flap and someone's looking inside it, don't close the flap.
		return

	if(isnull(storage_slots))//uses weight instead of slots
		var/fullness = 0
		for(var/obj/item/C as anything in contents)
			fullness += C.w_class
		if(fullness <= max_storage_space * 0.5)
			overlays += "+[icon_state]_half"
		else
			overlays += "+[icon_state]_full"
		return

	else if(length(contents) <= storage_slots * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"


/obj/item/storage/pouch/get_examine_text(mob/user)
	. = ..()
	. += "Can be worn by attaching it to a pocket."


/obj/item/storage/pouch/equipped(mob/user, slot)
	if(slot == WEAR_L_STORE || slot == WEAR_R_STORE)
		mouse_opacity = 2 //so it's easier to click when properly equipped.
	..()

/obj/item/storage/pouch/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()


/obj/item/storage/pouch/general
	name = "light general pouch"
	desc = "A general-purpose pouch used to carry a small item, or two tiny ones."
	icon_state = "small_drop"
	storage_flags = STORAGE_FLAGS_DEFAULT
	max_w_class = SIZE_MEDIUM
	cant_hold = list(	//Prevent inventory bloat
		/obj/item/storage/firstaid,
		/obj/item/storage/bible
	)
	storage_slots = null
	max_storage_space = 2

/obj/item/storage/pouch/general/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_ammo_to(M,user)
	else if(istype(W, /obj/item/storage/box/nade_box) || istype(W, /obj/item/storage/box/m94))
		dump_into(W, user)
	else
		return ..()

/obj/item/storage/pouch/general/can_be_inserted(obj/item/W, stop_messages)
	. = ..()
	if(. && W.w_class == SIZE_MEDIUM)
		for(var/obj/item/I in return_inv())
			if(I.w_class >= SIZE_MEDIUM)
				if(!stop_messages)
					to_chat(usr, SPAN_NOTICE("[src] is already too bulky with [I]."))
				return FALSE

/obj/item/storage/pouch/general/medium
	name = "medium general pouch"
	desc = "A general-purpose pouch used to carry a variety of differently sized items."
	icon_state = "medium_drop"
	storage_slots = null
	max_storage_space = 4

/obj/item/storage/pouch/general/large
	name = "large general pouch"
	desc = "A general-purpose pouch used to carry more differently sized items."
	icon_state = "large_drop"
	storage_slots = null
	max_storage_space = 6

/obj/item/storage/pouch/flamertank
	name = "fuel tank strap pouch"
	desc = "Two ring straps to loop around M240-pattern napalm tanks. Handle with care."
	storage_slots = 2
	icon_state = "fueltank_pouch"
	storage_flags = STORAGE_FLAGS_POUCH
	can_hold = list(
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/tool/extinguisher
					)
	bypass_w_limit = list(
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/tool/extinguisher
					)

/obj/item/storage/pouch/general/large/m39ap/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/m39/ap(src)

/obj/item/storage/pouch/bayonet
	name = "bayonet sheath"
	desc = "Knife to meet you!"
	can_hold = list(
		/obj/item/weapon/melee/throwing_knife,
		/obj/item/attachable/bayonet
	)
	cant_hold = list()
	icon_state = "bayonet"
	storage_slots = 5
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD|STORAGE_ALLOW_QUICKDRAW
	var/draw_cooldown = 0
	var/draw_cooldown_interval = 1 SECONDS
	var/default_knife_type = /obj/item/weapon/melee/throwing_knife

/obj/item/storage/pouch/bayonet/Initialize()
	. = ..()
	for(var/total_storage_slots in 1 to storage_slots)
		new default_knife_type(src)

/obj/item/storage/pouch/bayonet/upp
	default_knife_type = /obj/item/attachable/bayonet/upp

/obj/item/storage/pouch/bayonet/_item_insertion(obj/item/W, prevent_warning = 0)
	..()
	playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)

/obj/item/storage/pouch/bayonet/_item_removal(obj/item/W, atom/new_location)
	..()
	playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)

/obj/item/storage/pouch/bayonet/attack_hand(mob/user, mods)
	if(draw_cooldown < world.time)
		..()
		draw_cooldown = world.time + draw_cooldown_interval
		playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)
	else
		to_chat(user, SPAN_WARNING("You need to wait before drawing another knife!"))
		return 0

/obj/item/storage/pouch/survival
	name = "survival pouch"
	desc = "It can carry flashlights, a pill, a crowbar, metal sheets, and some bandages."
	icon_state = "tools"
	storage_slots = 6
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/device/flashlight,
		/obj/item/tool/crowbar,
		/obj/item/storage/pill_bottle/packet,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/device/radio,
		/obj/item/attachable/bayonet
	)

/obj/item/storage/pouch/survival/full/fill_preset_inventory()
	new /obj/item/device/flashlight(src)
	new /obj/item/tool/crowbar/red(src)
	new /obj/item/storage/pill_bottle/packet/tricordrazine(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/device/radio(src)
	new /obj/item/attachable/bayonet(src)

/obj/item/storage/pouch/survival/synth
	name = "synth survival pouch"
	desc = "An emergency pouch given to synthetics in the event of an emergency."
	icon_state = "tools"
	storage_slots = 7
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/device/flashlight,
		/obj/item/tool/crowbar,
		/obj/item/tool/weldingtool,
		/obj/item/stack/cable_coil,
		/obj/item/stack/sheet/metal,
		/obj/item/device/radio,
		/obj/item/attachable/bayonet
	)

/obj/item/storage/pouch/survival/synth/full/fill_preset_inventory()
	new /obj/item/device/flashlight(src)
	new /obj/item/tool/crowbar/red(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/stack/sheet/metal/large_stack(src)
	new /obj/item/device/radio(src)
	new /obj/item/attachable/bayonet(src)

/obj/item/storage/pouch/firstaid
	name = "first-aid pouch"
	desc = "It contains, by default, autoinjectors. But it may also hold ointments, bandages, and pill packets."
	icon_state = "firstaid"
	storage_slots = 4
	can_hold = list(
		/obj/item/stack/medical/ointment,
		/obj/item/reagent_container/hypospray/autoinjector,
		/obj/item/storage/pill_bottle/packet,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint
	)

/obj/item/storage/pouch/firstaid/full
	desc = "Contains a painkiller autoinjector, first-aid autoinjector, some ointment, and some bandages."

/obj/item/storage/pouch/firstaid/full/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/emergency/skillless(src)

/obj/item/storage/pouch/firstaid/full/alternate/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/bruise_pack(src)

/obj/item/storage/pouch/firstaid/full/pills/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/packet/bicaridine(src)
	new /obj/item/storage/pill_bottle/packet/kelotane(src)
	new /obj/item/storage/pill_bottle/packet/tramadol(src)
	new /obj/item/storage/pill_bottle/packet/tramadol(src)

/obj/item/storage/pouch/firstaid/ert
	desc = "It can contain autoinjectors, ointments, and bandages. This one has some extra stuff."
	icon_state = "firstaid"
	storage_slots = 5
	can_hold = list(
		/obj/item/stack/medical/ointment,
		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/storage/pill_bottle/packet/tramadol,
		/obj/item/storage/pill_bottle/packet/tricordrazine,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint,
		/obj/item/reagent_container/hypospray/autoinjector/emergency
	)

/obj/item/storage/pouch/firstaid/ert/fill_preset_inventory()
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/skillless(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/emergency(src)

///Pistol pouch.
/obj/item/storage/pouch/pistol
	name = "sidearm pouch"
	desc = "You could carry a pistol in this; more importantly, you could draw it quickly. Useful for emergencies."
	icon_state = "pistol"
	use_sound = null
	max_w_class = SIZE_MEDIUM
	can_hold = list(/obj/item/weapon/gun/pistol, /obj/item/weapon/gun/revolver,/obj/item/weapon/gun/flare)
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD|STORAGE_ALLOW_QUICKDRAW
	flap = FALSE

	///Display code pulled from belt.dm gun belt. Can shave quite a lot off because this pouch can only hold one item at a time.
	var/obj/item/weapon/gun/current_gun //The gun it holds, used for referencing later so we can update the icon.
	var/image/gun_underlay //The underlay we will use.
	var/sheatheSound = 'sound/weapons/gun_pistol_sheathe.ogg'
	var/drawSound = 'sound/weapons/gun_pistol_draw.ogg'
	var/icon_x = 0
	var/icon_y = -3

/obj/item/storage/pouch/pistol/Destroy()
	gun_underlay = null
	current_gun = null
	. = ..()

/obj/item/storage/pouch/pistol/on_stored_atom_del(atom/movable/AM)
	if(AM == current_gun)
		current_gun = null
		update_gun_icon()

/obj/item/storage/pouch/pistol/can_be_inserted(obj/item/W, stop_messages) //A little more detailed than just 'the pouch is full'.
	. = ..()
	if(!.)
		return
	if(current_gun && isgun(W))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src] already holds a gun."))
		return FALSE

/obj/item/storage/pouch/pistol/_item_insertion(obj/item/I, prevent_warning = 0, mob/user)
	if(isgun(I))
		current_gun = I
		update_gun_icon()
	..()

/obj/item/storage/pouch/pistol/_item_removal(obj/item/I, atom/new_location)
	if(I == current_gun)
		current_gun = null
		update_gun_icon()
	..()

/obj/item/storage/pouch/pistol/proc/update_gun_icon()
	if(current_gun)
		playsound(src, drawSound, 15, TRUE)
		gun_underlay = image('icons/obj/items/clothing/belts.dmi', current_gun.base_gun_icon)
		gun_underlay.pixel_x = icon_x
		gun_underlay.pixel_y = icon_y
		gun_underlay.color = current_gun.color
		underlays += gun_underlay
	else
		playsound(src, sheatheSound, 15, TRUE)
		underlays -= gun_underlay
		gun_underlay = null

///CO pouch. This pouch can hold only 1 of each type of item: 1 sidearm, 1 pair of binoculars, 1 CO tablet
/obj/item/storage/pouch/pistol/command
	name = "command pouch"
	desc = "A specialized, sturdy pouch issued to Captains. Can hold their sidearm, the command tablet and a set of binoculars."
	storage_slots = 3
	icon_state = "command_pouch"
	can_hold = list(
					/obj/item/weapon/gun/revolver,
					/obj/item/weapon/gun/pistol,
					/obj/item/device/binoculars,
					/obj/item/device/cotablet
					)

	var/obj/item/device/binoculars/binos
	var/obj/item/device/cotablet/tablet
	icon_x = -6
	icon_y = 0

/obj/item/storage/pouch/pistol/command/Destroy()
	binos = null
	tablet = null
	. = ..()

/obj/item/storage/pouch/pistol/command/on_stored_atom_del(atom/movable/AM)
	..()
	if(AM == binos)
		binos = null
	else if(AM == tablet)
		tablet = null

/obj/item/storage/pouch/pistol/command/can_be_inserted(obj/item/I, stop_messages)
	. = ..()
	if(!.)
		return
	if(binos && istype(I, /obj/item/device/binoculars))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src] already holds a pair of binoculars."))
		return FALSE
	else if(tablet && istype(I, /obj/item/device/cotablet))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src] already holds a tablet."))
		return FALSE

/obj/item/storage/pouch/pistol/command/_item_insertion(obj/item/I, prevent_warning = 0, mob/user)
	if(istype(I, /obj/item/device/binoculars))
		binos = I
	else if(istype(I, /obj/item/device/cotablet))
		tablet = I
	..()

/obj/item/storage/pouch/pistol/command/_item_removal(obj/item/I, atom/new_location)
	if(I == binos)
		binos = null
	else if(I == tablet)
		tablet = null
	..()

/obj/item/storage/pouch/pistol/command/update_icon()
	overlays.Cut()
	if(!length(contents))
		return
	if(content_watchers) //Opened flaps.
		if(binos)
			overlays += "+command_pouch_binos"
		if(tablet)
			overlays += "+command_pouch_tablet"
	else
		if(binos)
			overlays += "+command_pouch_binos_flap"
		if(tablet)
			overlays += "+command_pouch_tablet_flap"

/obj/item/storage/pouch/pistol/command/attack_hand(mob/user, mods) //Mostly copied from gunbelt.
	if(current_gun && ishuman(user) && loc == user)
		if(mods && mods["alt"] && length(contents) > 1) //Withdraw the most recently inserted nongun item if possible.
			var/obj/item/I = contents[length(contents)]
			if(isgun(I))
				I = contents[length(contents) - 1]
			I.attack_hand(user)
		else
			current_gun.attack_hand(user)
		return
	..()

//// MAGAZINE POUCHES /////

/obj/item/storage/pouch/magazine
	name = "magazine pouch"
	desc = "It can carry magazines."
	icon_state = "medium_ammo_mag"
	max_w_class = SIZE_MEDIUM
	storage_slots = 3
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg/m39
	)
	can_hold = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/handful
	)

/obj/item/storage/pouch/magazine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		if(istype(src, /obj/item/storage/pouch/magazine/pistol))
			return..()
		else
			dump_ammo_to(M,user, M.transfer_handful_amount)
	else
		return ..()

/obj/item/storage/pouch/magazine/large
	name = "large magazine pouch"
	desc = "It can carry many magazines."
	icon_state = "large_ammo_mag"
	storage_slots = 4

/obj/item/storage/pouch/magazine/pistol
	name = "pistol magazine pouch"
	desc = "It can carry pistol magazines and revolver speedloaders."
	max_w_class = SIZE_SMALL
	icon_state = "pistol_mag"
	storage_slots = 3

	can_hold = list(
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/pistol/heavy,
		/obj/item/ammo_magazine/revolver,
	)

/obj/item/storage/pouch/magazine/pistol/large
	name = "large pistol magazine pouch"
	desc = "It can carry many pistol magazines or revolver speedloaders."
	storage_slots = 6
	icon_state = "large_pistol_mag"

/obj/item/storage/pouch/magazine/pistol/large/mateba/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/revolver/mateba(src)

/obj/item/storage/pouch/magazine/pistol/large/mateba/impact/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)

/obj/item/storage/pouch/magazine/shotgun/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_ammo_to(M, user, M.transfer_handful_amount)
	else
		return ..()


/obj/item/storage/pouch/magazine/pistol/pmc_mateba/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/revolver/mateba(src)

/obj/item/storage/pouch/magazine/pistol/pmc_mod88/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/pistol/mod88(src)

/obj/item/storage/pouch/magazine/pistol/pmc_vp78/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/pistol/vp78(src)

/obj/item/storage/pouch/magazine/upp/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/type71(src)

/obj/item/storage/pouch/magazine/large/upp/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/type71(src)

/obj/item/storage/pouch/magazine/large/pmc_m39/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/m39/ap(src)

/obj/item/storage/pouch/magazine/large/nsg_ap/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/nsg23/ap(src)

/obj/item/storage/pouch/magazine/large/nsg_ext/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/nsg23/extended(src)

/obj/item/storage/pouch/magazine/large/pmc_p90/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/fp9000(src)

/obj/item/storage/pouch/magazine/large/pmc_lmg/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/lmg(src)

/obj/item/storage/pouch/magazine/large/pmc_sniper/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/sniper/elite(src)

/obj/item/storage/pouch/magazine/large/pmc_rifle/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/ap(src)

/obj/item/storage/pouch/magazine/large/pmc_sg/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smartgun/dirty(src)

/obj/item/storage/pouch/magazine/large/m16/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16(src)

/obj/item/storage/pouch/magazine/large/m16/ap/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16/ap(src)

/obj/item/storage/pouch/shotgun
	name = "shotgun shell pouch"
	desc = "It can contain handfuls of shells, or bullets if you choose to for some reason."
	icon_state = "medium_shotshells"
	max_w_class = SIZE_SMALL
	storage_slots = 5
	bypass_w_limit = list()
	can_hold = list(
		/obj/item/ammo_magazine/handful
	)
	flap = FALSE

/obj/item/storage/pouch/shotgun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_ammo_to(M, user, M.transfer_handful_amount)
	else
		return ..()

/obj/item/storage/pouch/shotgun/heavybuck/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot(src)

/obj/item/storage/pouch/shotgun/heavyslug/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/heavy/slug(src)

/obj/item/storage/pouch/shotgun/heavyflechette/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/heavy/flechette(src)

/obj/item/storage/pouch/shotgun/large
	name = "large shotgun shell pouch"
	desc = "It can contain more handfuls of shells, or bullets if you choose to for some reason."
	icon_state = "large_shotshells"
	storage_slots = 7

/obj/item/storage/pouch/shotgun/large/riot/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/beanbag/riot(src)

/obj/item/storage/pouch/shotgun/large/slug/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/slug(src)

/obj/item/storage/pouch/shotgun/large/buckshot/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/buckshot(src)

/obj/item/storage/pouch/explosive
	name = "explosive pouch"
	desc = "It can carry grenades, plastic explosives, mine boxes, and other explosives."
	icon_state = "large_explosive"
	storage_slots = 3
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/explosive/plastic,
		/obj/item/explosive/mine,
		/obj/item/explosive/grenade,
		/obj/item/storage/box/explosive_mines
	)

/obj/item/storage/pouch/explosive/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/nade_box))
		var/obj/item/storage/box/nade_box/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/pouch/explosive/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/explosive/grenade/HE(src)

/obj/item/storage/pouch/explosive/upp/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/explosive/grenade/HE/upp(src)

/obj/item/storage/pouch/explosive/C4/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/explosive/plastic(src)

/obj/item/storage/pouch/explosive/emp_dutch/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/explosive/grenade/empgrenade/dutch(src)

/obj/item/storage/pouch/medical
	name = "medical pouch"
	desc = "It can carry small medical supplies."
	icon_state = "medical"
	storage_slots = 4

	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/reagent_container/hypospray,
		/obj/item/tool/extinguisher/mini,
		/obj/item/storage/syringe_case,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft
	)

/obj/item/storage/pouch/medical/full/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)

/obj/item/storage/pouch/medical/full/pills/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/dexalin(src)

/obj/item/storage/pouch/medical/socmed
	name = "tactical medical pouch"
	desc = "A heavy pouch containing everything one needs to get themselves back on their feet. Quite the selection."
	icon_state = "socmed"
	storage_slots = 13
	can_hold = list(
		/obj/item/stack/medical,
		/obj/item/storage/pill_bottle,
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/hypospray,
		/obj/item/tool/extinguisher/mini,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft
	)

/obj/item/storage/pouch/medical/socmed/full/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/splint/nano(src)
	new /obj/item/stack/medical/advanced/bruise_pack/upgraded(src)
	new /obj/item/stack/medical/advanced/ointment/upgraded(src)
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/emergency(src)
	new /obj/item/reagent_container/hypospray/autoinjector/emergency(src)
	new /obj/item/tool/extinguisher/mini(src)
	new /obj/item/reagent_container/hypospray/autoinjector/stimulant/brain_stimulant(src)
	new /obj/item/reagent_container/hypospray/autoinjector/stimulant/redemption_stimulant(src)
	new /obj/item/reagent_container/hypospray/autoinjector/stimulant/speed_stimulant(src)

/obj/item/storage/pouch/medical/socmed/dutch
	name = "\improper Dutch's Medical Pouch"
	desc = "A pouch bought from a black market trader by Dutch quite a few years ago. Rumoured to be stolen from secret USCM assets. Its contents have been slowly used up and replaced over the years."

/obj/item/storage/pouch/medical/socmed/dutch/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/emergency(src)
	new /obj/item/tool/extinguisher/mini(src)

/obj/item/storage/pouch/first_responder
	name = "first responder pouch"
	desc = "A pouch designed for carrying supplies to assist medical personnel and quickly respond to injuries on the battlefield without immediately treating them. Can hold supplies such as roller beds, stasis bags, and health analysers."
	icon_state = "frt_med"
	storage_slots = 4

	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/reagent_container/hypospray,
		/obj/item/tool/extinguisher/mini,
		/obj/item/roller,
		/obj/item/bodybag,
	)

/obj/item/storage/pouch/first_responder/full/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/roller(src)
	new /obj/item/tool/extinguisher/mini(src)
	new /obj/item/bodybag/cryobag(src)


/obj/item/storage/pouch/vials
	name = "vial pouch"
	desc = "A pouch for carrying glass vials."
	icon_state = "vial"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_container/glass/beaker/vial)

/obj/item/storage/pouch/vials/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/fancy/vials))
		var/obj/item/storage/fancy/vials/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/pouch/vials/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/reagent_container/glass/beaker/vial(src)

/obj/item/storage/pouch/chem
	name = "chemist pouch"
	desc = "A pouch for carrying glass beakers."
	icon_state = "chemist"
	storage_slots = 2
	can_hold = list(
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/bottle
	)

/obj/item/storage/pouch/chem/fill_preset_inventory()
	new /obj/item/reagent_container/glass/beaker/large(src)
	new /obj/item/reagent_container/glass/beaker(src)

/obj/item/storage/pouch/autoinjector
	name = "auto-injector pouch"
	desc = "A pouch specifically for auto-injectors."
	icon_state = "injectors"
	storage_slots = 7
	can_hold = list(/obj/item/reagent_container/hypospray/autoinjector)

/obj/item/storage/pouch/autoinjector/full/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tramadol(src)
	new /obj/item/reagent_container/hypospray/autoinjector/tramadol(src)
	new /obj/item/reagent_container/hypospray/autoinjector/emergency(src)

/obj/item/storage/pouch/syringe
	name = "syringe pouch"
	desc = "It can carry syringes."
	icon_state = "syringe"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_container/syringe)

/obj/item/storage/pouch/syringe/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/reagent_container/syringe(src)

/obj/item/storage/pouch/medkit
	name = "medkit pouch"
	max_w_class = SIZE_MEDIUM
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD
	icon_state = "medkit"
	desc = "It's specifically made to hold a medkit."
	can_hold = list(/obj/item/storage/firstaid)

/obj/item/storage/pouch/medkit/handle_mmb_open(var/mob/user)
	var/obj/item/storage/firstaid/FA = locate() in contents
	if(FA)
		FA.open(user)
		return
	return ..()


/obj/item/storage/pouch/medkit/full/fill_preset_inventory()
	new /obj/item/storage/firstaid/regular(src)

/obj/item/storage/pouch/medkit/full_advanced/fill_preset_inventory()
	new /obj/item/storage/firstaid/adv(src)


/obj/item/storage/pouch/pressurized_reagent_canister
	name = "Pressurized Reagent Canister Pouch"
	max_w_class = SIZE_SMALL
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD
	icon_state = "pressurized_reagent_canister"
	desc = "A pressurized reagent canister pouch. It is used to refill custom injectors, and can also store one. May be refilled with a reagent tank or a Chemical Dispenser."
	can_hold = list(/obj/item/reagent_container/hypospray/autoinjector/empty)
	var/obj/item/reagent_container/glass/pressurized_canister/inner
	matter = list("plastic" = 3000)

/obj/item/storage/pouch/pressurized_reagent_canister/Initialize()
	. = ..()
	inner = new /obj/item/reagent_container/glass/pressurized_canister()
	update_icon()

/obj/item/storage/pouch/pressurized_reagent_canister/bicaridine/Initialize()
	. = ..()
	inner.reagents.add_reagent("bicaridine", inner.volume)
	new /obj/item/reagent_container/hypospray/autoinjector/empty/medic(src)
	update_icon()

/obj/item/storage/pouch/pressurized_reagent_canister/kelotane/Initialize()
	. = ..()
	inner.reagents.add_reagent("kelotane", inner.volume)
	new /obj/item/reagent_container/hypospray/autoinjector/empty/medic/(src)
	update_icon()

/obj/item/storage/pouch/pressurized_reagent_canister/oxycodone/Initialize()
	. = ..()
	inner.reagents.add_reagent("oxycodone", inner.volume)
	new /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/verysmall/(src)
	update_icon()

/obj/item/storage/pouch/pressurized_reagent_canister/revival/Initialize()
	. = ..()
	inner.reagents.add_reagent("adrenaline", inner.volume/3)
	inner.reagents.add_reagent("inaprovaline", inner.volume/3)
	inner.reagents.add_reagent("tricordrazine", inner.volume/3)
	new /obj/item/reagent_container/hypospray/autoinjector/empty/medic(src)
	update_icon()

/obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine/Initialize()
	. = ..()
	inner.reagents.add_reagent("tricordrazine", inner.volume)
	new /obj/item/reagent_container/hypospray/autoinjector/empty/medic/(src)
	update_icon()

/obj/item/storage/pouch/pressurized_reagent_canister/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/reagent_container/glass/pressurized_canister))
		if(inner)
			to_chat(user, SPAN_WARNING("There already is a container inside [src]!"))
		else
			user.drop_inv_item_to_loc(W, src)
			inner = W
			contents -= W
			to_chat(user, SPAN_NOTICE("You insert [W] into [src]!"))
			update_icon()
		return

	if(istype(W, /obj/item/reagent_container/hypospray/autoinjector/empty))
		var/obj/item/reagent_container/hypospray/autoinjector/A = W
		var/max_uses = A.volume / A.amount_per_transfer_from_this
		max_uses = round(max_uses) == max_uses ? max_uses : round(max_uses) + 1
		if(inner && inner.reagents.total_volume > 0 && (A.uses_left < max_uses))
			inner.reagents.trans_to(A, A.volume)
			var/uses_left = A.reagents.total_volume / A.amount_per_transfer_from_this
			uses_left = round(uses_left) == uses_left ? uses_left : round(uses_left) + 1
			A.uses_left = uses_left
			playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
			A.update_icon()
		return ..()
	else if(istype(W, /obj/item/reagent_container/hypospray/autoinjector))
		to_chat(user, SPAN_WARNING("[W] is not compatible with this system!"))
	return ..()


/obj/item/storage/pouch/pressurized_reagent_canister/afterattack(obj/target, mob/user, flag) //refuel at fueltanks & chem dispensers.
	if(!inner)
		to_chat(user, SPAN_WARNING("[src] has no internal container!"))
		return ..()

	if(istype(target, /obj/structure/machinery/chem_dispenser))
		var/obj/structure/machinery/chem_dispenser/cd = target
		if(!cd.beaker)
			to_chat(user, SPAN_NOTICE("You unhook the inner container and connect it to [target]."))
			inner.forceMove(cd)
			cd.beaker = inner
			inner = null
			update_icon()
		else
			to_chat(user, SPAN_WARNING("[cd] already has a container!"))
		return

	if(!istype(target, /obj/structure/reagent_dispensers/fueltank))
		return ..()

	if(get_dist(user,target) > 1)
		return ..()

	var/obj/O = target
	if(!O.reagents || O.reagents.reagent_list.len < 1)
		to_chat(user, SPAN_WARNING("[O] is empty!"))
		return

	var/amt_to_remove = Clamp(O.reagents.total_volume, 0, inner.volume)
	if(!amt_to_remove)
		to_chat(user, SPAN_WARNING("[O] is empty!"))
		return

	O.reagents.trans_to(inner, amt_to_remove)
	playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)

	to_chat(user, SPAN_NOTICE("You refill the [src]."))
	update_icon()

/obj/item/storage/pouch/pressurized_reagent_canister/get_examine_text(mob/user)
	. = ..()
	var/display_info = display_contents(user)
	if(display_info)
		. += display_info

/obj/item/storage/pouch/pressurized_reagent_canister/update_icon()
	overlays.Cut()
	if(length(contents))
		overlays += "+[icon_state]_full"
	if(inner)
		overlays += "+[icon_state]_loaded"


/obj/item/storage/pouch/pressurized_reagent_canister/empty(mob/user)
	return //Useless, it's a one slot.

/obj/item/storage/pouch/pressurized_reagent_canister/proc/display_contents(mob/user) // Used on examine for properly skilled people to see contents.
	if(isXeno(user))
		return
	if(!inner)
		return "This [src] has no container inside!"
	if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
		return "This [src] contains: [get_reagent_list_text()]"
	else
		return "You don't know what's in it."

//returns a text listing the reagents (and their volume) in the atom. Used by Attack logs for reagents in pills
/obj/item/storage/pouch/pressurized_reagent_canister/proc/get_reagent_list_text()
	if(inner && inner.reagents && inner.reagents.reagent_list && inner.reagents.reagent_list.len)
		var/datum/reagent/R = inner.reagents.reagent_list[1]
		. = "[R.name]([R.volume]u)"

		if(inner.reagents.reagent_list.len < 2)
			return

		for(var/i in 2 to inner.reagents.reagent_list.len)
			R = inner.reagents.reagent_list[i]

			if(!R)
				continue

			. += "; [R.name]([R.volume]u)"
	else
		. = "No reagents"

/obj/item/storage/pouch/pressurized_reagent_canister/verb/flush_container()
	set category = "Weapons"
	set name = "Flush Container"
	set desc = "Forces the container to empty its reagents."
	set src in usr
	if(!inner)
		to_chat(usr, SPAN_WARNING("There is no container inside this pouch!"))
		return

	to_chat(usr, SPAN_NOTICE("You hold down the emergency flush button. Wait 3 seconds..."))
	if(do_after(usr, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		if(inner)
			to_chat(usr, SPAN_NOTICE("You flush the [src]."))
			inner.reagents.clear_reagents()

/obj/item/storage/pouch/document
	name = "large document pouch"
	desc = "It can contain papers, folders, disks, technical manuals, and clipboards."
	icon_state = "document"
	storage_slots = 21
	max_w_class = SIZE_MEDIUM
	max_storage_space = 21
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_CLICK_GATHER
	can_hold = list(
		/obj/item/paper,
		/obj/item/clipboard,
		/obj/item/document_objective/paper,
		/obj/item/document_objective/report,
		/obj/item/document_objective/folder,
		/obj/item/disk/objective,
		/obj/item/document_objective/technical_manual
	)

/obj/item/storage/pouch/document/small
	name = "small document pouch"
	desc = "A smaller version of the document pouch. It can contain papers, folders, disks, technical manuals, and clipboards."
	storage_slots = 7

/obj/item/storage/pouch/flare
	name = "flare pouch"
	desc = "A pouch designed to hold flares. Refillable with an M94 flare pack."
	max_w_class = SIZE_SMALL
	storage_slots = 8
	max_storage_space = 8
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD
	icon_state = "flare"
	can_hold = list(/obj/item/device/flashlight/flare,/obj/item/device/flashlight/flare/signal)

/obj/item/storage/pouch/flare/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/m94))
		var/obj/item/storage/box/m94/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/pouch/flare/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/device/flashlight/flare(src)

/obj/item/storage/pouch/radio
	name = "radio pouch"
	storage_slots = 2
	icon_state = "radio"
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD
	desc = "It can contain two handheld radios."
	can_hold = list(/obj/item/device/radio)


/obj/item/storage/pouch/electronics
	name = "electronics pouch"
	desc = "It is designed to hold most electronics, power cells and circuit boards."
	icon_state = "electronics"
	storage_slots = 6
	can_hold = list(
		/obj/item/circuitboard,
		/obj/item/cell,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/console_screen,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/capacitor
	)

/obj/item/storage/pouch/electronics/full/fill_preset_inventory()
	new /obj/item/circuitboard/apc(src)
	new /obj/item/cell/high(src)

/obj/item/storage/pouch/construction
	name = "construction pouch"
	desc = "It's designed to hold construction materials - glass/metal sheets, metal rods, barbed wire, cable coil, and empty sandbags. It also has two hooks for an entrenching tool and light replacer."
	storage_slots = 3
	max_w_class = SIZE_MEDIUM
	icon_state = "construction"
	can_hold = list(
		/obj/item/stack/barbed_wire,
		/obj/item/stack/sheet,
		/obj/item/stack/rods,
		/obj/item/stack/cable_coil,
		/obj/item/stack/tile,
		/obj/item/tool/shovel/etool,
		/obj/item/stack/sandbags_empty,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/gun/smg/nailgun/compact,
	)

/obj/item/storage/pouch/construction/full/fill_preset_inventory()
	new /obj/item/stack/sheet/plasteel(src, 50)
	new /obj/item/stack/sheet/metal(src, 50)
	new /obj/item/stack/sandbags_empty(src, 50)

/obj/item/storage/pouch/construction/full_barbed_wire/fill_preset_inventory()
	new /obj/item/stack/sheet/plasteel(src, 50)
	new /obj/item/stack/sheet/metal(src, 50)
	new /obj/item/stack/barbed_wire(src, 20)

/obj/item/storage/pouch/construction/low_grade_full/fill_preset_inventory()
	new /obj/item/stack/sheet/plasteel(src, 30)
	new /obj/item/stack/sheet/metal(src, 50)
	new /obj/item/stack/barbed_wire(src, 15)

/obj/item/storage/pouch/tools
	name = "tools pouch"
	desc = "It's designed to hold maintenance tools - screwdriver, wrench, cable coil, etc. It also has a hook for an entrenching tool."
	storage_slots = 4
	max_w_class = SIZE_MEDIUM
	icon_state = "tools"
	can_hold = list(
		/obj/item/tool/wirecutters,
		/obj/item/tool/shovel/etool,
		/obj/item/tool/screwdriver,
		/obj/item/tool/crowbar,
		/obj/item/tool/weldingtool,
		/obj/item/device/multitool,
		/obj/item/tool/wrench,
		/obj/item/stack/cable_coil,
		/obj/item/tool/extinguisher/mini,
		/obj/item/tool/shovel/etool
	)
	bypass_w_limit = list(/obj/item/tool/shovel/etool)

/obj/item/storage/pouch/tools/tactical
	name = "tactical tools pouch"
	desc = "This particular toolkit full of sharp, heavy objects was designed for breaking into things rather than fixing them. Still does the latter pretty well, though."
	icon_state = "soctools"
	storage_slots = 8

/obj/item/storage/pouch/tools/full/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/multitool(src)
	new /obj/item/tool/wrench(src)

/obj/item/storage/pouch/tools/pfc/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/wrench(src)

/obj/item/storage/pouch/tools/synth/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/device/multitool(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/stack/cable_coil(src)

/obj/item/storage/pouch/tools/tank/fill_preset_inventory()
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool/hugetank(src)
	new /obj/item/tool/extinguisher/mini(src)

/obj/item/storage/pouch/tools/mortar/fill_preset_inventory()
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/tool/shovel/etool(src)

/obj/item/storage/pouch/tools/tactical/full/fill_preset_inventory()
	new /obj/item/tool/screwdriver/tactical(src)
	new /obj/item/tool/wirecutters/tactical(src)
	new /obj/item/tool/crowbar/tactical(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/device/multitool(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)

/obj/item/storage/pouch/sling
	name = "sling strap"
	desc = "Keeps a single item attached to a strap."
	storage_slots = 1
	max_w_class = SIZE_MEDIUM
	icon_state = "sling"
	can_hold = list(/obj/item/device, /obj/item/tool)
	bypass_w_limit = list(/obj/item/tool/shovel/etool)
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD
	var/sling_range = 1
	var/obj/item/slung

/obj/item/storage/pouch/sling/get_examine_text(mob/user)
	. = ..()
	if(slung && slung.loc != src)
		. += "\The [slung] is attached to the sling."

/obj/item/storage/pouch/sling/can_be_inserted(obj/item/I, stop_messages = FALSE)
	if(slung)
		if(slung != I)
			if(!stop_messages)
				to_chat(usr, SPAN_WARNING("\the [slung] is already attached to the sling."))
			return FALSE
	else if(SEND_SIGNAL(I, COMSIG_DROP_RETRIEVAL_CHECK) & COMPONENT_DROP_RETRIEVAL_PRESENT)
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[I] is already attached to another sling."))
		return FALSE
	return ..()

/obj/item/storage/pouch/sling/_item_insertion(obj/item/I, prevent_warning = FALSE, mob/user)
	if(!slung)
		slung = I
		slung.AddElement(/datum/element/drop_retrieval/pouch_sling, src)
		if(!prevent_warning)
			to_chat(user, SPAN_NOTICE("You attach the sling to [I]."))
	..()

/obj/item/storage/pouch/sling/attack_self(mob/user)
	if(slung)
		to_chat(user, SPAN_NOTICE("You retract the sling from [slung]."))
		unsling()
		return
	return ..()

/obj/item/storage/pouch/sling/proc/unsling()
	if(!slung)
		return
	slung.RemoveElement(/datum/element/drop_retrieval/pouch_sling, src)
	slung = null

/obj/item/storage/pouch/sling/proc/sling_return(var/mob/living/carbon/human/user)
	if(!slung || !slung.loc)
		return FALSE
	if(slung.loc == user)
		return TRUE
	if(!isturf(slung.loc))
		return FALSE
	if(get_dist(slung, src) > sling_range)
		return FALSE
	if(handle_item_insertion(slung))
		if(user)
			to_chat(user, SPAN_NOTICE("[slung] snaps back into [src]."))
		return TRUE

/obj/item/storage/pouch/sling/proc/attempt_retrieval(var/mob/living/carbon/human/user)
	if(sling_return(user))
		return
	unsling()
	if(user && src.loc == user)
		to_chat(user, SPAN_WARNING("The sling of your [src] snaps back empty!"))

/obj/item/storage/pouch/sling/proc/handle_retrieval(mob/living/carbon/human/user)
	if(slung && slung.loc == src)
		return
	addtimer(CALLBACK(src, .proc/attempt_retrieval, user), 0.3 SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT)

/obj/item/storage/pouch/cassette
	name = "cassette pouch"
	desc = "A finely crafted pouch, made specifically to keep cassettes safe during wartime."
	icon_state = "cassette_pouch_closed"
	var/base_icon_state = "cassette_pouch"
	w_class = SIZE_SMALL
	can_hold = list(/obj/item/device/cassette_tape)
	storage_slots = 3

/obj/item/storage/pouch/cassette/update_icon()
	underlays.Cut()
	if(!content_watchers)
		icon_state = "[base_icon_state]_closed"
	else
		switch(min(length(contents), 2))
			if(2)
				icon_state = "[base_icon_state]_2"
				var/obj/item/device/cassette_tape/first_tape = contents[1]
				underlays += image(first_tape.icon, null, first_tape.icon_state, pixel_y = -4)
				var/obj/item/device/cassette_tape/second_tape = contents[2]
				var/image/I = image(second_tape.icon, null, second_tape.icon_state, pixel_y = 5)
				var/matrix/M = matrix()
				M.Turn(180)
				I.transform = M
				underlays += I
			if(1)
				icon_state = "[base_icon_state]_1"
				var/obj/item/device/cassette_tape/first_tape = contents[1]
				underlays += image(first_tape.icon, null, first_tape.icon_state, pixel_y = -4)
			if(0)
				icon_state = base_icon_state

/obj/item/storage/pouch/machete
	name = "\improper H6B pattern M2132 machete scabbard"
	desc = "A large leather scabbard used to carry a M2132 machete. It can be strapped to the pouch slot."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "macheteB_holster"
	item_state = "machete_holster"
	max_w_class = SIZE_LARGE
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_USING_DRAWING_METHOD|STORAGE_ALLOW_QUICKDRAW
	can_hold = list(/obj/item/weapon/melee/claymore/mercsword/machete)

	var/sheathe_sound = 'sound/weapons/gun_rifle_draw.ogg'
	var/draw_sound = 'sound/weapons/gun_rifle_draw.ogg'

/obj/item/storage/pouch/machete/update_icon()
	if(length(contents))
		icon_state = "[initial(icon_state)]_full"
	else
		icon_state = initial(icon_state)

/obj/item/storage/pouch/machete/_item_insertion(obj/item/W, prevent_warning = 0)
	..()
	playsound(src, sheathe_sound, vol = 15, vary = TRUE)

/obj/item/storage/pouch/machete/_item_removal(obj/item/W, atom/new_location)
	..()
	playsound(src, draw_sound, vol = 15, vary = TRUE)

/obj/item/storage/pouch/machete/full/fill_preset_inventory()
	new /obj/item/weapon/melee/claymore/mercsword/machete(src)
