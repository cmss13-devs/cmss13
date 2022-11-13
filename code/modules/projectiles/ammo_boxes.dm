//---------------------------MAGAZINE BOXES------------------

/obj/item/ammo_box
	name = "generic ammo box"
	icon = 'icons/obj/items/weapons/guns/ammo_box.dmi'
	icon_state = "base"
	w_class = SIZE_HUGE
	var/empty = FALSE
	var/can_explode = FALSE
	var/burning = FALSE
	var/limit_per_tile = 1	//how many you can deploy per tile
	layer = LOWER_ITEM_LAYER	//to not hide other items

//---------------------GENERAL PROCS

/obj/item/ammo_box/Destroy()
	SetLuminosity(0)
	. = ..()

/obj/item/ammo_box/proc/unfold_box(turf/T)
	new /obj/item/stack/sheet/cardboard(T)
	qdel(src)

//---------------------FIRE HANDLING PROCS
/obj/item/ammo_box/flamer_fire_act(var/severity, var/datum/cause_data/flame_cause_data)
	if(burning)
		return
	burning = TRUE

	SetLuminosity(3)
	apply_fire_overlay()
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), 5 SECONDS)

/obj/item/ammo_box/proc/get_severity()
	return

/obj/item/ammo_box/proc/apply_fire_overlay()
	return

/obj/item/ammo_box/proc/process_burning()
	return

/obj/item/ammo_box/proc/handle_side_effects()
	return

/obj/item/ammo_box/proc/explode(var/severity, var/datum/cause_data/flame_cause_data)
	if(severity > 0)
		explosion(get_turf(src),  -1, ((severity > 2) ? 0 : -1), severity - 1, severity + 1, 1, 0, 0, flame_cause_data)
	//just in case
	if(!QDELETED(src))
		qdel(src)
	return

/obj/item/ammo_box/magazine
	name = "magazine box (M41A x 10)"
	icon_state = "base_m41"			//base color of box
	var/overlay_ammo_type = "_reg"		//used for ammo type color overlay
	var/overlay_gun_type = "_m41"		//used for text overlay
	var/overlay_content = "_reg"
	var/magazine_type = /obj/item/ammo_magazine/rifle
	var/num_of_magazines = 10
	var/handfuls = FALSE
	var/icon_state_deployed = null
	var/handful = "shells" //used for 'magazine' boxes that give handfuls to determine what kind for the sprite
	can_explode = TRUE
	limit_per_tile = 2

/obj/item/ammo_box/magazine/empty
	empty = TRUE

//---------------------GENERAL PROCS

/obj/item/ammo_box/magazine/Initialize()
	. = ..()
	if(handfuls)
		var/obj/item/ammo_magazine/AM = new magazine_type(src)
		AM.max_rounds = num_of_magazines
		AM.current_rounds = empty ? 0 : num_of_magazines
	else if(!empty)
		var/i = 0
		while(i < num_of_magazines)
			contents += new magazine_type(src)
			i++
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	update_icon()

/obj/item/ammo_box/magazine/update_icon()
	if(overlays)
		overlays.Cut()
	overlays += image(icon, icon_state = "[icon_state]_lid")				//adding lid
	if(overlay_gun_type)
		overlays += image(icon, icon_state = "text[overlay_gun_type]")		//adding text
	if(overlay_ammo_type)
		overlays += image(icon, icon_state = "base_type[overlay_ammo_type]")	//adding base color stripes
	if(overlay_ammo_type!="_reg" && overlay_ammo_type!="_blank")
		overlays += image(icon, icon_state = "lid_type[overlay_ammo_type]")	//adding base color stripes

//---------------------INTERACTION PROCS

/obj/item/ammo_box/magazine/get_examine_text(mob/living/user)
	. = ..()
	. += SPAN_INFO("[SPAN_HELPFUL("Activate")] box in hand or [SPAN_HELPFUL("click")] with it on the ground to deploy it. Activating it while empty will fold it into cardboard sheet.")
	if(src.loc != user)		//feeling box weight in a distance is unnatural and bad
		return
	if(!handfuls)
		if(contents.len < (num_of_magazines/3))
			. += SPAN_INFO("It feels almost empty.")
			return
		if(contents.len < ((num_of_magazines*2)/3))
			. += SPAN_INFO("It feels about half full.")
			return
		. += SPAN_INFO("It feels almost full.")
	else
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in contents
		if(AM)
			if(AM.current_rounds < (AM.max_rounds/3))
				. += SPAN_INFO("It feels almost empty.")
				return
			if(AM.current_rounds < ((AM.max_rounds*2)/3))
				. += SPAN_INFO("It feels about half full.")
				return
			. += SPAN_INFO("It feels almost full.")
	if(burning)
		. += SPAN_DANGER("It's on fire and might explode!")

/obj/item/ammo_box/magazine/attack_self(mob/living/user)
	..()
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return

	if(length(contents))
		if(!handfuls)
			deploy_ammo_box(user, user.loc)
			return
		else
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in contents
			if(AM && AM.current_rounds)
				deploy_ammo_box(user, user.loc)
				return
	unfold_box(user.loc)

/obj/item/ammo_box/magazine/proc/deploy_ammo_box(var/mob/living/user, var/turf/T)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return

	var/box_on_tile = 0
	for(var/obj/structure/magazine_box/found_MB in T.contents)
		if(limit_per_tile != found_MB.limit_per_tile)
			to_chat(user, SPAN_WARNING("You can't deploy different size boxes in one place!"))
			return
		box_on_tile++
		if(box_on_tile >= limit_per_tile)
			to_chat(user, SPAN_WARNING("You can't cram any more boxes in here!"))
			return

	var/obj/structure/magazine_box/M = new /obj/structure/magazine_box(T)
	M.icon_state = icon_state_deployed ? icon_state_deployed : icon_state
	M.name = name
	M.desc = desc
	M.item_box = src
	M.can_explode = can_explode
	M.limit_per_tile = limit_per_tile
	M.update_icon()
	if(limit_per_tile > 1)
		M.assign_offsets(T)
	user.drop_inv_item_on_ground(src)
	Move(M)

/obj/item/ammo_box/magazine/afterattack(atom/target, mob/living/user, proximity)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return
	if(!proximity)
		return
	if(isturf(target))
		var/turf/T = target
		if(!T.density)
			deploy_ammo_box(user, T)

//---------------------FIRE HANDLING PROCS

/obj/item/ammo_box/magazine/flamer_fire_act(var/damage, var/datum/cause_data/flame_cause_data)
	if(burning)
		return
	burning = TRUE
	process_burning(flame_cause_data)
	return

//we need a lot of bullets to produce an explosion. Different scaling because of very different ammo counts
/obj/item/ammo_box/magazine/get_severity()
	var/severity = 0
	if(handfuls)
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in contents
		if(AM)
			severity = round(AM.current_rounds / 40)
	else
		for(var/obj/item/ammo_magazine/AM in contents)
			severity += AM.current_rounds
		severity = round(severity / 150)
	return severity

/obj/item/ammo_box/magazine/process_burning(var/datum/cause_data/flame_cause_data)
	var/obj/structure/magazine_box/host_box
	if(istype(loc, /obj/structure/magazine_box))
		host_box = loc
	if(can_explode)
		var/severity = get_severity()
		if(severity > 0)
			handle_side_effects(host_box, TRUE)
			addtimer(CALLBACK(src, .proc/explode, severity, flame_cause_data), max(5 - severity, 2))	//the more ammo inside, the faster and harder it cooks off
			return
	handle_side_effects(host_box)
	//need to make sure we delete the structure box if it exists, it will handle the deletion of ammo box inside
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, (host_box ? host_box : src)), 5 SECONDS)
	return

/obj/item/ammo_box/magazine/handle_side_effects(var/obj/structure/magazine_box/host_box, var/will_explode = FALSE)
	var/shown_message = "\The [src] catches on fire!"
	if(will_explode)
		shown_message = "\The [src] catches on fire and ammunition starts cooking off! It's gonna blow!"

	if(host_box)
		host_box.apply_fire_overlay(will_explode)
		host_box.SetLuminosity(3)
		host_box.visible_message(SPAN_WARNING(shown_message))
	else
		apply_fire_overlay(will_explode)
		SetLuminosity(3)
		visible_message(SPAN_WARNING(shown_message))

/obj/item/ammo_box/magazine/apply_fire_overlay(var/will_explode = FALSE)
	//original fire overlay is made for standard mag boxes, so they don't need additional offsetting
	var/offset_y = 0
	if(limit_per_tile == 1)	//snowflake nailgun ammo box again
		offset_y += -2
	var/image/fire_overlay = image(icon, icon_state = will_explode ? "on_fire_explode_overlay" : "on_fire_overlay", pixel_y = offset_y)
	overlays.Add(fire_overlay)

//-----------------------------------------------------------------------------------

//-----------------------SHOTGUN SHELL BOXES-----------------------

/obj/item/ammo_box/magazine/shotgun
	name = "shotgun shell box (Slugs x 100)"
	icon_state = "base_slug"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = ""
	overlay_gun_type = "_shells"
	overlay_content = "_slug"
	magazine_type = /obj/item/ammo_magazine/shotgun/slugs
	num_of_magazines = 100
	handfuls = TRUE

/obj/item/ammo_box/magazine/shotgun/update_icon()
	if(overlays)
		overlays.Cut()
	overlays += image(icon, icon_state = "[icon_state]_lid")				//adding lid
	overlays += image(icon, icon_state = "text[overlay_gun_type]")		//adding text

/obj/item/ammo_box/magazine/shotgun/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/buckshot
	name = "shotgun shell box (Buckshot x 100)"
	icon_state = "base_buck"
	overlay_content = "_buck"
	magazine_type = /obj/item/ammo_magazine/shotgun/buckshot

/obj/item/ammo_box/magazine/shotgun/buckshot/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/flechette
	name = "shotgun shell box (Flechette x 100)"
	icon_state = "base_flech"
	overlay_content = "_flech"
	magazine_type = /obj/item/ammo_magazine/shotgun/flechette

/obj/item/ammo_box/magazine/shotgun/flechette/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/incendiary
	name = "shotgun shell box (Incendiary slug x 100)"
	icon_state = "base_inc"
	overlay_content = "_incen"
	magazine_type = /obj/item/ammo_magazine/shotgun/incendiary

/obj/item/ammo_box/magazine/shotgun/incendiary/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/beanbag
	name = "shotgun shell box (Beanbag x 100)"
	icon_state = "base_bean"
	overlay_content = "_bean"
	magazine_type = /obj/item/ammo_magazine/shotgun/beanbag
	can_explode = FALSE


/obj/item/ammo_box/magazine/shotgun/beanbag/empty
	empty = TRUE

//-----------------------M41A Rifle Mag Boxes-----------------------

/obj/item/ammo_box/magazine/ap
	name = "magazine box (AP M41A x 10)"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_ap"
	overlay_content = "_ap"
	magazine_type = /obj/item/ammo_magazine/rifle/ap

/obj/item/ammo_box/magazine/ap/empty
	empty = TRUE

/obj/item/ammo_box/magazine/le
	name = "magazine box (LE M41A x 10)"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_le"
	overlay_content = "_le"
	magazine_type = /obj/item/ammo_magazine/rifle/le

/obj/item/ammo_box/magazine/le/empty
	empty = TRUE

/obj/item/ammo_box/magazine/ext
	name = "magazine box (Ext M41A x 8)"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_ext"
	num_of_magazines = 8
	magazine_type = /obj/item/ammo_magazine/rifle/extended

/obj/item/ammo_box/magazine/ext/empty
	empty = TRUE

/obj/item/ammo_box/magazine/incen
	name = "magazine box (Incen M41A x 10)"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_incen"
	overlay_content = "_incen"
	magazine_type = /obj/item/ammo_magazine/rifle/incendiary

/obj/item/ammo_box/magazine/incen/empty
	empty = TRUE

/obj/item/ammo_box/magazine/explosive
	name = "magazine box (Explosive M41A x 10)"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_expl"
	overlay_content = "_expl"
	magazine_type = /obj/item/ammo_magazine/rifle/explosive

/obj/item/ammo_box/magazine/explosive/empty
	empty = TRUE

//-----------------------M39 Rifle Mag Boxes-----------------------

/obj/item/ammo_box/magazine/m39
	name = "magazine box (M39 x 12)"
	icon_state = "base_m39"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_m39"
	overlay_content = "_hv"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/smg/m39

/obj/item/ammo_box/magazine/m39/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m39/ap
	name = "magazine box (AP M39 x 12)"
	overlay_ammo_type = "_ap"
	overlay_content = "_ap"
	magazine_type = /obj/item/ammo_magazine/smg/m39/ap

/obj/item/ammo_box/magazine/m39/ap/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m39/ext
	name = "magazine box (Ext m39 x 10)"
	overlay_ammo_type = "_ext"
	overlay_content = "_hv"
	num_of_magazines = 10
	magazine_type = /obj/item/ammo_magazine/smg/m39/extended

/obj/item/ammo_box/magazine/m39/ext/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m39/incen
	name = "magazine box (Incen m39 x 12)"
	overlay_ammo_type = "_incen"
	overlay_content = "_incen"
	magazine_type = /obj/item/ammo_magazine/smg/m39/incendiary

/obj/item/ammo_box/magazine/m39/incen/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m39/le
	name = "magazine box (LE m39 x 12)"
	overlay_ammo_type = "_le"
	overlay_content = "_le"
	magazine_type = /obj/item/ammo_magazine/smg/m39/le

/obj/item/ammo_box/magazine/m39/le/empty
	empty = TRUE

//-----------------------L42A Battle Rifle Mag Boxes-----------------------

/obj/item/ammo_box/magazine/l42a
	name = "magazine box (L42A x 16)"
	icon_state = "base_l42"
	flags_equip_slot = SLOT_BACK
	overlay_gun_type = "_l42"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/rifle/l42a

/obj/item/ammo_box/magazine/l42a/empty
	empty = TRUE

/obj/item/ammo_box/magazine/l42a/ap
	name = "magazine box (AP L42A x 16)"
	overlay_ammo_type = "_ap"
	overlay_content = "_ap"
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/ap

/obj/item/ammo_box/magazine/l42a/ap/empty
	empty = TRUE

/obj/item/ammo_box/magazine/l42a/le
	name = "magazine box (LE L42A x 16)"
	overlay_ammo_type = "_le"
	overlay_content = "_le"
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/le

/obj/item/ammo_box/magazine/l42a/le/empty
	empty = TRUE

/obj/item/ammo_box/magazine/l42a/ext
	name = "magazine box (Ext L42A x 12)"
	overlay_ammo_type = "_ext"
	overlay_content = "_reg"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/extended

/obj/item/ammo_box/magazine/l42a/ext/empty
	empty = TRUE

/obj/item/ammo_box/magazine/l42a/incen
	name = "magazine box (Incen L42A x 16)"
	overlay_ammo_type = "_incen"
	overlay_content = "_incen"
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/incendiary

/obj/item/ammo_box/magazine/l42a/incen/empty
	empty = TRUE

//-----------------------M16 Rifle Mag Box-----------------------

/obj/item/ammo_box/magazine/M16
	name = "magazine box (M16 x 12)"
	icon_state = "base_m16"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_m16"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/rifle/m16

/obj/item/ammo_box/magazine/M16/empty
	empty = TRUE

/obj/item/ammo_box/magazine/M16/ap
	name = "magazine box (AP M16 x 12)"
	icon_state = "base_m16"
	overlay_ammo_type = "_ap"
	overlay_gun_type = "_m16"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/rifle/m16/ap

/obj/item/ammo_box/magazine/M16/ap/empty
	empty = TRUE

//-----------------------R4T Lever-action rifle handfuls box-----------------------

/obj/item/ammo_box/magazine/lever_action
	name = "45-70 bullets box (45-70 x 300)"
	icon_state = "base_4570"
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_4570"
	overlay_content = "_4570"
	magazine_type = /obj/item/ammo_magazine/handful/lever_action
	num_of_magazines = 300
	handfuls = TRUE
	handful = "rounds"

/obj/item/ammo_box/magazine/lever_action/empty
	empty = TRUE

/obj/item/ammo_box/magazine/lever_action/training
	name = "45-70 blank box (45-70 x 300)"
	icon_state = "base_4570"
	overlay_ammo_type = "_45_training"
	overlay_gun_type = "_4570"
	overlay_content = "_training"
	magazine_type = /obj/item/ammo_magazine/handful/lever_action/training

/obj/item/ammo_box/magazine/lever_action/training/empty
	empty = TRUE

//unused
/obj/item/ammo_box/magazine/lever_action/tracker
	name = "45-70 tracker bullets box (45-70 x 300)"
	icon_state = "base_4570"
	overlay_ammo_type = "_45_tracker"
	overlay_gun_type = "_4570"
	overlay_content = "_tracker"
	magazine_type = /obj/item/ammo_magazine/handful/lever_action/tracker

/obj/item/ammo_box/magazine/lever_action/tracker/empty
	empty = TRUE

//unused
/obj/item/ammo_box/magazine/lever_action/marksman
	name = "45-70 marksman bullets box (45-70 x 300)"
	icon_state = "base_4570"
	overlay_ammo_type = "_45_marksman"
	overlay_gun_type = "_4570"
	overlay_content = "_marksman"
	magazine_type = /obj/item/ammo_magazine/handful/lever_action/marksman

/obj/item/ammo_box/magazine/lever_action/marksman/empty
	empty = TRUE

//-----------------------M4A3 Pistol Mag Box-----------------------

/obj/item/ammo_box/magazine/m4a3
	name = "magazine box (M4A3 x 16)"
	icon_state = "base_m4a3"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_m4a3"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol

/obj/item/ammo_box/magazine/m4a3/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m4a3/ap
	name = "magazine box (AP M4A3 x 16)"
	overlay_ammo_type = "_ap"
	overlay_content = "_ap"
	magazine_type = /obj/item/ammo_magazine/pistol/ap

/obj/item/ammo_box/magazine/m4a3/ap/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m4a3/hp
	name = "magazine box (HP M4A3 x 16)"
	overlay_ammo_type = "_hp"
	overlay_content = "_hp"
	magazine_type = /obj/item/ammo_magazine/pistol/hp

/obj/item/ammo_box/magazine/m4a3/hp/empty
	empty = TRUE

//-----------------------M44 Revolver Speed Loaders Box-----------------------

/obj/item/ammo_box/magazine/m44
	name = "speed loaders box (M44 x 16)"
	icon_state = "base_m44"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_m44_reg"
	overlay_gun_type = "_m44"
	overlay_content = "_speed"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/revolver

/obj/item/ammo_box/magazine/m44/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m44/marksman
	name = "speed loaders box (Marksman M44 x 16)"
	overlay_ammo_type = "_m44_mark"
	magazine_type = /obj/item/ammo_magazine/revolver/marksman

/obj/item/ammo_box/magazine/m44/marksman/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m44/heavy
	name = "speed loaders box (Heavy M44 x 16)"
	overlay_ammo_type = "_m44_heavy"
	magazine_type = /obj/item/ammo_magazine/revolver/heavy

/obj/item/ammo_box/magazine/m44/heavy/empty
	empty = TRUE

//-----------------------SU-6 Smartpistol Mag Box-----------------------

/obj/item/ammo_box/magazine/su6
	name = "magazine box (SU-6 x 16)"
	icon_state = "base_su6"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_su6"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/smart

/obj/item/ammo_box/magazine/su6/empty
	empty = TRUE

//-----------------------88M4 Pistol Mag Box-----------------------

/obj/item/ammo_box/magazine/mod88
	name = "magazine box (88 Mod 4 AP x 16)"
	icon_state = "base_mod88"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_ap"
	overlay_gun_type = "_mod88"
	overlay_content = "_ap"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/mod88

/obj/item/ammo_box/magazine/mod88/empty
	empty = TRUE

//-----------------------VP78 Pistol Mag Box-----------------------

/obj/item/ammo_box/magazine/vp78
	name = "magazine box (VP78 x 16)"
	icon_state = "base_vp78"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_vp78"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/vp78

/obj/item/ammo_box/magazine/vp78/empty
	empty = TRUE

//-----------------------Type71 Rifle Mag Box-----------------------

/obj/item/ammo_box/magazine/type71
	name = "magazine box (Type71 x 10)"
	icon_state = "base_type71"
	flags_equip_slot = SLOT_BACK
	overlay_ammo_type = "_type71_reg"
	overlay_gun_type = "_type71"
	overlay_content = "_type71_reg"
	num_of_magazines = 14
	magazine_type = /obj/item/ammo_magazine/rifle/type71

/obj/item/ammo_box/magazine/type71/empty
	empty = TRUE

/obj/item/ammo_box/magazine/type71/ap
	name = "magazine box (Type71 AP x 10)"
	overlay_ammo_type = "_type71_ap"
	overlay_content = "_type71_ap"
	magazine_type = /obj/item/ammo_magazine/rifle/type71/ap

/obj/item/ammo_box/magazine/type71/ap/empty
	empty = TRUE

//-----------------------Nailgun Mag Box-----------------------

/obj/item/ammo_box/magazine/smg/nailgun
	name = "magazine box (Nailgun x 10)"
	icon_state = "base_nailgun"			//base color of box
	icon_state_deployed = "base_nailgun_deployed"
	overlay_ammo_type = "_nail"		//used for ammo type color overlay
	overlay_gun_type = null	//used for text overlay
	overlay_content = "_nailgun"
	magazine_type = /obj/item/ammo_magazine/smg/nailgun
	num_of_magazines = 10
	handfuls = FALSE
	can_explode = FALSE
	limit_per_tile = 1	//this one has unique too big sprite, so not stackable

/obj/item/ammo_box/magazine/smg/nailgun/empty
	empty = TRUE

//-----------------------MAG BOX STRUCTURE-----------------------

/obj/structure/magazine_box
	name = "magazine_box"
	icon = 'icons/obj/items/weapons/guns/ammo_box.dmi'
	icon_state = "base_m41"
	var/obj/item/ammo_box/magazine/item_box
	var/can_explode = TRUE
	var/burning = FALSE
	var/limit_per_tile = 1 //this is inherited from the item when deployed
	layer = LOWER_ITEM_LAYER	//to not hide other items

//---------------------GENERAL PROCS

/obj/structure/magazine_box/Destroy()
	SetLuminosity(0)
	if(item_box)
		qdel(item_box)
		item_box = null
	return ..()

/obj/structure/magazine_box/update_icon()
	if(overlays)
		overlays.Cut()
		if(item_box.overlay_gun_type)
			overlays += image(icon, icon_state = "text[item_box.overlay_gun_type]")			//adding text

	if(!item_box.handfuls)
		if(item_box.overlay_ammo_type)
			overlays += image(icon, icon_state = "base_type[item_box.overlay_ammo_type]")		//adding base color stripes
		if(item_box.contents.len == item_box.num_of_magazines)
			overlays += image(icon, icon_state = "magaz[item_box.overlay_content]")
		else if(item_box.contents.len > (item_box.num_of_magazines/2))
			overlays += image(icon, icon_state = "magaz[item_box.overlay_content]_3")
		else if(item_box.contents.len > (item_box.num_of_magazines/4))
			overlays += image(icon, icon_state = "magaz[item_box.overlay_content]_2")
		else if(item_box.contents.len > 0)
			overlays += image(icon, icon_state = "magaz[item_box.overlay_content]_1")
	else
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
		if(item_box.overlay_ammo_type)
			overlays += image(icon, icon_state = "base_type[item_box.overlay_ammo_type]")
		if(AM.current_rounds == item_box.num_of_magazines)
			overlays += image(icon, icon_state = "[item_box.handful][item_box.overlay_content]")
		else if(AM.current_rounds > (item_box.num_of_magazines/2))
			overlays += image(icon, icon_state = "[item_box.handful][item_box.overlay_content]_3")
		else if(AM.current_rounds > (item_box.num_of_magazines/4))
			overlays += image(icon, icon_state = "[item_box.handful][item_box.overlay_content]_2")
		else if(AM.current_rounds > 0)
			overlays += image(icon, icon_state = "[item_box.handful][item_box.overlay_content]_1")

//handles assigning offsets for stacked boxes
/obj/structure/magazine_box/proc/assign_offsets(var/turf/T)
	if(limit_per_tile == 2)	//you can deploy 2 mag boxes per tile
		for(var/obj/structure/magazine_box/found_MB in T.contents)
			if(found_MB != src)
				pixel_y = found_MB.pixel_y * -1	//we assign a mirrored offset
				return
		pixel_y = -8	//if there is no box, by default we offset the box to the bottom
	else if(limit_per_tile == 4)	//you can deploy 4 misc boxes per tile
		var/list/possible_offsets = list(list(-8, -3, TRUE), list(7, -3, TRUE), list(-8, 13, TRUE), list(7, 13, TRUE))	//x_offset, y_offset, available
		for(var/obj/structure/magazine_box/found_MB in T.contents)
			if(found_MB == src)
				continue
			for(var/list/L in possible_offsets)
				if(L[1] == found_MB.pixel_x && L[2] == found_MB.pixel_y)
					L[3] = FALSE
					break
		for(var/list/L in possible_offsets)
			if(L[3])
				pixel_x = L[1]
				pixel_y = L[2]
				return

//---------------------INTERACTION PROCS

/obj/structure/magazine_box/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr))
		if(burning)
			to_chat(usr, SPAN_DANGER("It's on fire and might explode!"))
			return

		if(!ishuman(usr))
			return
		visible_message(SPAN_NOTICE("[usr] picks up the [name]."))

		usr.put_in_hands(item_box)
		item_box = null
		qdel(src)

/obj/structure/magazine_box/get_examine_text(mob/user)
	. = ..()
	if(get_dist(src,user) > 2 && !isobserver(user))
		return
	. += SPAN_INFO("[SPAN_HELPFUL("Click")] on the box with an empty hand to take a magazine out. [SPAN_HELPFUL("Drag")] it onto yourself to pick it up.")
	if(item_box.handfuls)
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
		if(AM)
			. +=  SPAN_INFO("It has roughly [round(AM.current_rounds/5)] handfuls remaining.")
	else
		. +=  SPAN_INFO("It has [item_box.contents.len] magazines out of [item_box.num_of_magazines].")
	if(burning)
		. +=  SPAN_DANGER("It's on fire and might explode!")

/obj/structure/magazine_box/attack_hand(mob/living/user)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return
	if(item_box.contents.len)
		if(!item_box.handfuls)
			var/obj/item/ammo_magazine/AM = pick(item_box.contents)
			item_box.contents -= AM
			user.put_in_hands(AM)
			to_chat(user, SPAN_NOTICE("You retrieve \a [AM] from \the [src]."))
		else
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
			if(AM)
				AM.create_handful(user, AM.transfer_handful_amount, src)
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))

/obj/structure/magazine_box/attackby(obj/item/W, mob/living/user)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return
	if(!item_box.handfuls)
		if(istypestrict(W,item_box.magazine_type))
			if(istype(W, /obj/item/storage/box/m94))
				var/obj/item/storage/box/m94/flare_pack = W
				if(flare_pack.contents.len < flare_pack.max_storage_space)
					to_chat(user, SPAN_WARNING("\The [W] is not full."))
					return
				var/flare_type
				if(istype(W, /obj/item/storage/box/m94/signal))
					flare_type = /obj/item/device/flashlight/flare/signal
				else
					flare_type = /obj/item/device/flashlight/flare
				for(var/obj/item/device/flashlight/flare/F in flare_pack.contents)
					if(F.fuel < 1)
						to_chat(user, SPAN_WARNING("Some flares in \the [F] are used."))
						return
					if(F.type != flare_type)
						to_chat(user, SPAN_WARNING("Some flares in \the [W] are not of the correct type."))
						return
			else if(istype(W, /obj/item/storage/box/MRE))
				var/obj/item/storage/box/MRE/mre_pack = W
				if(mre_pack.isopened)
					to_chat(user, SPAN_WARNING("\The [W] was already opened and isn't suitable for storing in \the [src]."))
					return
			if(item_box.contents.len < item_box.num_of_magazines)
				user.drop_inv_item_to_loc(W, src)
				item_box.contents += W
				to_chat(user, SPAN_NOTICE("You put a [W] in to \the [src]"))
				update_icon()
			else
				to_chat(user, SPAN_WARNING("\The [src] is full."))
		else
			to_chat(user, SPAN_WARNING("You don't want to mix different magazines in one box."))
	else
		if(istype(W, /obj/item/ammo_magazine/shotgun))
			var/obj/item/ammo_magazine/O = W
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine/shotgun) in item_box.contents
			if(!O || !W)
				return
			if(O.default_ammo == AM.default_ammo)
				if(O.current_rounds <= 0)
					to_chat(user, SPAN_WARNING("\The [O] is empty."))
					return
				if(AM.current_rounds >= AM.max_rounds)
					to_chat(user, SPAN_WARNING("\The [src] is full."))
					return
				else
					if(!do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
						return
					playsound(loc, 'sound/weapons/gun_revolver_load3.ogg', 25, 1)
					var/S = min(O.current_rounds, AM.max_rounds - AM.current_rounds)
					AM.current_rounds += S
					O.current_rounds -= S
					to_chat(user, SPAN_NOTICE("You transfer shells from [O] into \the [src]"))
					update_icon()
					O.update_icon()
			else
				to_chat(user, SPAN_WARNING("Wrong type of shells."))

		if(istype(W, /obj/item/ammo_magazine/handful))
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
			AM.attackby(W, user, 1)
			update_icon()

//---------------------FIRE HANDLING PROCS
/obj/structure/magazine_box/flamer_fire_act(var/damage, var/datum/cause_data/flame_cause_data)
	if(burning || !item_box)
		return
	burning = TRUE
	item_box.flamer_fire_act(damage, flame_cause_data)
	return

/obj/structure/magazine_box/proc/apply_fire_overlay(var/will_explode = FALSE)
	//original fire overlay is made for standard mag boxes, so they don't need additional offsetting
	var/offset_x = 0
	var/offset_y = 0

	if(limit_per_tile == 4)	//misc boxes (mre, flares etc)
		offset_x += 1
		offset_y += -6
	else if(istype(src, /obj/item/ammo_box/magazine/smg/nailgun))	//this snowflake again
		offset_y += -2

	var/image/fire_overlay = image(icon, icon_state = will_explode ? "on_fire_explode_overlay" : "on_fire_overlay", pixel_x = offset_x, pixel_y = offset_y)
	overlays.Add(fire_overlay)

//-----------------------BIG AMMO BOX (with loose ammunition)---------------

/obj/item/ammo_box/rounds
	name = "rifle ammunition box (10x24mm)"
	desc = "A 10x24mm ammunition box. Used to refill M41A MK1, MK2, L42A and M41AE2 HPR magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_m41"
	item_state = "base_m41"
	flags_equip_slot = SLOT_BACK
	var/overlay_gun_type = "_rounds"		//used for ammo type color overlay
	var/overlay_content = "_reg"
	var/default_ammo = /datum/ammo/bullet/rifle
	var/bullet_amount = 600
	var/max_bullet_amount = 600
	var/caliber = "10x24mm"
	can_explode = TRUE

/obj/item/ammo_box/rounds/empty
	empty = TRUE

//---------------------GENERAL PROCS

/obj/item/ammo_box/rounds/Initialize()
	. = ..()
	if(empty)
		bullet_amount = 0
	update_icon()

/obj/item/ammo_box/rounds/update_icon()
	if(overlays)
		overlays.Cut()
	overlays += image(icon, icon_state = "text[overlay_gun_type]")	//adding base color stripes

	if(bullet_amount == max_bullet_amount)
		overlays += image(icon, icon_state = "rounds[overlay_content]")
	else if(bullet_amount > (max_bullet_amount/2))
		overlays += image(icon, icon_state = "rounds[overlay_content]_3")
	else if(bullet_amount > (max_bullet_amount/4))
		overlays += image(icon, icon_state = "rounds[overlay_content]_2")
	else if(bullet_amount > 0)
		overlays += image(icon, icon_state = "rounds[overlay_content]_1")

//---------------------INTERACTION PROCS

/obj/item/ammo_box/rounds/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("To refill a magazine click on the box with it in your hand. Being on [SPAN_HELPFUL("HARM")] intent will fill box from the magazine.")
	if(bullet_amount)
		. +=  "It contains [bullet_amount] round\s."
	else
		. +=  "It's empty."
	if(burning)
		. += SPAN_DANGER("It's on fire and might explode!")

/obj/item/ammo_box/rounds/attack_self(mob/living/user)
	..()
	if(bullet_amount < 1)
		unfold_box(user.loc)

/obj/item/ammo_box/rounds/attackby(obj/item/I, mob/user)
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return
	if(istype(I, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = I
		if(!isturf(loc))
			to_chat(user, SPAN_WARNING("\The [src] must be on the ground to be used."))
			return
		if(AM.flags_magazine & AMMUNITION_REFILLABLE)
			if(default_ammo != AM.default_ammo)
				to_chat(user, SPAN_WARNING("Those aren't the same rounds. Better not mix them up."))
				return
			if(caliber != AM.caliber)
				to_chat(user, SPAN_WARNING("The rounds don't match up. Better not mix them up."))
				return

			var/dumping = FALSE // we REFILL BOX (dump to it) on harm intent, otherwise we refill FROM box
			if(user.a_intent == INTENT_HARM)
				dumping = TRUE

			var/transfering   = 0      // Amount of bullets we're trying to transfer
			var/transferable  = 0      // Amount of bullets that can actually be transfered
			do
				// General checking
				if(dumping)
					transferable = min(AM.current_rounds, max_bullet_amount - bullet_amount)
				else
					transferable = min(bullet_amount, AM.max_rounds - AM.current_rounds)
				if(transferable < 1)
					to_chat(user, SPAN_NOTICE("You cannot transfer any more rounds."))

				// Half-Loop 1: Start transfering
				else if(!transfering)
					transfering = min(transferable, 48) // Max per transfer
					if(!do_after(user, 1.5 SECONDS, INTERRUPT_ALL, dumping ? BUSY_ICON_HOSTILE : BUSY_ICON_FRIENDLY))
						to_chat(user, SPAN_NOTICE("You stop transferring rounds."))
						transferable = 0

				// Half-Loop 2: Process transfer
				else
					transfering = min(transfering, transferable)
					transferable -= transfering
					if(dumping)
						transfering = -transfering
					AM.current_rounds += transfering
					bullet_amount     -= transfering
					playsound(src, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 20, TRUE, 6)
					to_chat(user, SPAN_NOTICE("You have transferred [abs(transfering)] round\s to [dumping ? src : AM]."))
					transfering = 0

			while(transferable >= 1)

			AM.update_icon(AM.current_rounds)
			update_icon()

		else if(AM.flags_magazine & AMMUNITION_HANDFUL)
			if(default_ammo != AM.default_ammo)
				to_chat(user, SPAN_WARNING("Those aren't the same rounds. Better not mix them up."))
				return
			if(caliber != AM.caliber)
				to_chat(user, SPAN_WARNING("The rounds don't match up. Better not mix them up."))
				return
			if(bullet_amount == max_bullet_amount)
				to_chat(user, SPAN_WARNING("\The [src] is already full."))
				return

			playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)
			var/S = min(AM.current_rounds, max_bullet_amount - bullet_amount)
			AM.current_rounds -= S
			bullet_amount += S
			AM.update_icon()
			update_icon()
			to_chat(user, SPAN_NOTICE("You put [S] round\s into [src]."))
			if(AM.current_rounds <= 0)
				user.temp_drop_inv_item(AM)
				qdel(AM)

//---------------------FIRE HANDLING PROCS

/obj/item/ammo_box/rounds/flamer_fire_act(var/damage, var/datum/cause_data/flame_cause_data)
	if(burning)
		return
	burning = TRUE
	process_burning(flame_cause_data)
	return

/obj/item/ammo_box/rounds/get_severity()
	return round(bullet_amount / 200)	//we need a lot of bullets to produce an explosion.

/obj/item/ammo_box/rounds/process_burning(var/datum/cause_data/flame_cause_data)
	if(can_explode)
		var/severity = get_severity()
		if(severity > 0)
			handle_side_effects(TRUE)
			addtimer(CALLBACK(src, .proc/explode, severity, flame_cause_data), max(5 - severity, 2))	//the more ammo inside, the faster and harder it cooks off
			return
	handle_side_effects()
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, (src)), 5 SECONDS)

/obj/item/ammo_box/rounds/handle_side_effects(var/will_explode = FALSE)
	if(will_explode)
		visible_message(SPAN_WARNING("\The [src] catches on fire and ammunition starts cooking off! It's gonna blow!"))
	else
		visible_message(SPAN_WARNING("\The [src] catches on fire!"))

	apply_fire_overlay(will_explode)
	SetLuminosity(3)

/obj/item/ammo_box/rounds/apply_fire_overlay(var/will_explode = FALSE)
	//original fire overlay is made for standard mag boxes, so they don't need additional offsetting
	var/image/fire_overlay = image(icon, icon_state = will_explode ? "on_fire_explode_overlay" : "on_fire_overlay", pixel_x = pixel_x, pixel_y = pixel_y)
	overlays.Add(fire_overlay)

//-----------------------------------------------------------------------------------

//-----------------------AMMUNITION BOXES (LOOSE AMMO)-----------------------

//----------------10x24mm Ammunition Boxes (for M41 family and L42)------------------

/obj/item/ammo_box/rounds/ap
	name = "rifle ammunition box (10x24mm AP)"
	desc = "A 10x24mm armor-piercing ammunition box. Used to refill M41A MK2 and L42A AP magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_box/rounds/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/le
	name = "rifle ammunition box (10x24mm LE)"
	desc = "A 10x24mm armor-shredding ammunition box. Used to refill M41A MK2 and L42A LE magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_le"
	default_ammo = /datum/ammo/bullet/rifle/le

/obj/item/ammo_box/rounds/le/empty
	empty = TRUE

/obj/item/ammo_box/rounds/incen
	name = "rifle ammunition box (10x24mm Incen)"
	desc = "A 10x24mm incendiary ammunition box. Used to refill M41A MK2 and L42A incendiary magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	bullet_amount = 400		//Incen is OP
	max_bullet_amount = 400

/obj/item/ammo_box/rounds/incen/empty
	empty = TRUE

//----------------10x20mm Ammunition Boxes (for M39 SMG)------------------

/obj/item/ammo_box/rounds/smg
	name = "SMG HV ammunition box (10x20mm)"
	desc = "A 10x20mm ammunition box. Used to refill M39 HV and extended magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	icon_state = "base_m39"
	overlay_content = "_hv"
	default_ammo = /datum/ammo/bullet/smg/m39

/obj/item/ammo_box/rounds/smg/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/ap
	name = "SMG ammunition box (10x20mm AP)"
	desc = "A 10x20mm armor-piercing ammunition box. Used to refill M39 AP magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/smg/ap

/obj/item/ammo_box/rounds/smg/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/le
	name = "SMG ammunition box (10x20mm LE)"
	desc = "A 10x20mm armor-shredding ammunition box. Used to refill M39 LE magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_le"
	default_ammo = /datum/ammo/bullet/smg/le

/obj/item/ammo_box/rounds/smg/le/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/incen
	name = "SMG ammunition box (10x20mm Incen)"
	desc = "A 10x20mm incendiary ammunition box. Used to refill M39 incendiary magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/smg/incendiary
	bullet_amount = 400		//Incen is OP
	max_bullet_amount = 400

/obj/item/ammo_box/rounds/smg/incen/empty
	empty = TRUE

//----------------5.45x39mm Ammunition Boxes (for UPP Type71 family)------------------

/obj/item/ammo_box/rounds/type71
	name = "rifle ammunition box (5.45x39mm)"
	desc = "A 5.45x39mm ammunition box. Used to refill Type71 magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_reg"
	caliber = "5.45x39mm"
	default_ammo = /datum/ammo/bullet/rifle

/obj/item/ammo_box/rounds/type71/empty
	empty = TRUE

/obj/item/ammo_box/rounds/type71/ap
	name = "rifle ammunition box (5.45x39mm AP)"
	desc = "A 5.45x39mm armor-piercing ammunition box. Used to refill Type71 AP magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_box/rounds/type71/ap/empty
	empty = TRUE

//-----------------------------------------------------------------------------------

//-----------------------MISC SUPPLIES BOXES-----------------------

/obj/item/ammo_box/magazine/misc
	name = "miscellaneous equipment box"
	desc = "A box for miscellaneous equipment."
	icon_state = "supply_crate"
	overlay_ammo_type = "blank"
	overlay_gun_type = "blank"
	overlay_content = ""
	can_explode = FALSE
	limit_per_tile = 4

//---------------------FIRE HANDLING PROCS

/obj/item/ammo_box/magazine/misc/flamer_fire_act(var/damage, var/datum/cause_data/flame_cause_data)
	if(burning)
		return
	burning = TRUE
	process_burning()
	return

/obj/item/ammo_box/magazine/misc/get_severity()
	return

/obj/item/ammo_box/magazine/misc/process_burning(var/datum/cause_data/flame_cause_data)
	var/obj/structure/magazine_box/host_box
	if(istype(loc, /obj/structure/magazine_box))
		host_box = loc
	handle_side_effects(host_box)
	//need to make sure we delete the structure box if it exists, it will handle the deletion of ammo box inside
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, (host_box ? host_box : src)), 7 SECONDS)
	return

/obj/item/ammo_box/magazine/misc/handle_side_effects(var/obj/structure/magazine_box/host_box)
	if(host_box)
		host_box.apply_fire_overlay()
		host_box.SetLuminosity(3)
		host_box.visible_message(SPAN_WARNING("\The [src] catches on fire!"))
	else
		apply_fire_overlay()
		SetLuminosity(3)
		visible_message(SPAN_WARNING("\The [src] catches on fire!"))

/obj/item/ammo_box/magazine/misc/apply_fire_overlay(var/will_explode = FALSE)
	var/offset_x = 1
	var/offset_y = -6

	var/image/fire_overlay = image(icon, icon_state = will_explode ? "on_fire_explode_overlay" : "on_fire_overlay", pixel_x = offset_x, pixel_y = offset_y)
	overlays.Add(fire_overlay)

/obj/item/ammo_box/magazine/misc/explode(var/severity, var/datum/cause_data/flame_cause_data)
	if(!QDELETED(src))
		qdel(src)
	return

//------------------------MRE Box--------------------------

/obj/item/ammo_box/magazine/misc/mre
	name = "box of MREs"
	desc = "A box of MREs. Nutritious, but not delicious."
	magazine_type = /obj/item/storage/box/MRE
	num_of_magazines = 12
	overlay_content = "_mre"

/obj/item/ammo_box/magazine/misc/mre/empty
	empty = TRUE

//------------------------M94 Marking Flare Packs Box--------------------------

/obj/item/ammo_box/magazine/misc/flares
	name = "box of M94 marking flare packs"
	desc = "A box of M94 marking flare packs, to brighten up your day."
	magazine_type = /obj/item/storage/box/m94
	num_of_magazines = 10
	overlay_gun_type = "_m94"
	overlay_content = "_flares"

//---------------------FIRE HANDLING PROCS

//flare box has unique stuff
/obj/item/ammo_box/magazine/misc/flares/flamer_fire_act(var/damage, var/datum/cause_data/flame_cause_data)
	if(burning)
		return
	burning = TRUE
	process_burning()

/obj/item/ammo_box/magazine/misc/flares/get_severity()
	var/flare_amount = 0
	for(var/obj/item/storage/box/m94/flare_box in contents)
		flare_amount += flare_box.contents.len
	flare_amount = round(flare_amount / 8) //10 packs, 8 flares each, maximum total of 10 flares we can throw out
	return flare_amount

/obj/item/ammo_box/magazine/misc/flares/process_burning(var/datum/cause_data/flame_cause_data)
	var/obj/structure/magazine_box/host_box
	if(istype(loc, /obj/structure/magazine_box))
		host_box = loc
	var/flare_amount = get_severity()
	//need to make sure we delete the structure box if it exists, it will handle the deletion of ammo box inside
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, (host_box ? host_box : src)), 7 SECONDS)
	if(flare_amount > 0)
		handle_side_effects(host_box, TRUE)

		var/list/turf_list = list()
		for(var/turf/T in range(5, (host_box ? host_box : src)))
			turf_list += T
		for(var/i = 1, i <= flare_amount, i++)
			addtimer(CALLBACK(src, .proc/explode, (host_box ? host_box : src), turf_list), rand(1, 6) SECONDS)
		return
	handle_side_effects(host_box)
	return

/obj/item/ammo_box/magazine/misc/flares/handle_side_effects(var/obj/structure/magazine_box/host_box, var/will_explode = FALSE)
	var/shown_message = "\The [src] catches on fire!"
	if(will_explode)
		shown_message = "\The [src] catches on fire and starts shooting out flares!"

	if(host_box)
		host_box.apply_fire_overlay()
		host_box.SetLuminosity(3)
		host_box.visible_message(SPAN_WARNING(shown_message))
	else
		apply_fire_overlay()
		SetLuminosity(3)
		visible_message(SPAN_WARNING(shown_message))

//for flare box, instead of actually exploding, we throw out a flare at random direction
/obj/item/ammo_box/magazine/misc/flares/explode(var/obj/structure/magazine_box/host_box, var/list/turf_list = list())
	var/range = rand(1, 6)
	var/speed = pick(SPEED_SLOW, SPEED_AVERAGE, SPEED_FAST)

	var/turf/target_turf = pick(turf_list)
	var/obj/item/device/flashlight/flare/on/F = new (get_turf(host_box ? host_box : src))
	playsound(src,'sound/handling/flare_activate_2.ogg', 50, 1)

	INVOKE_ASYNC(F, /atom/movable.proc/throw_atom, target_turf, range, speed, null, TRUE)
	return

/obj/item/ammo_box/magazine/misc/flares/empty
	empty = TRUE
