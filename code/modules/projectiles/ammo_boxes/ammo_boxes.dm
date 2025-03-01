//---------------------------MAGAZINE BOXES------------------

/obj/item/ammo_box
	name = "\improper generic ammo box"
	icon = 'icons/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/ammo_boxes.dmi'
	)
	icon_state = "base"
	w_class = SIZE_HUGE
	var/empty = FALSE
	var/can_explode = FALSE
	var/burning = FALSE
	var/limit_per_tile = 1 //how many you can deploy per tile
	layer = LOWER_ITEM_LAYER //to not hide other items

	var/text_markings_icon = 'icons/obj/items/weapons/guns/ammo_boxes/text.dmi'
	var/handfuls_icon = 'icons/obj/items/weapons/guns/ammo_boxes/handfuls.dmi'
	var/magazines_icon = 'icons/obj/items/weapons/guns/ammo_boxes/magazines.dmi'
	var/flames_icon = 'icons/obj/items/weapons/guns/ammo_boxes/misc.dmi'

//---------------------GENERAL PROCS

/obj/item/ammo_box/attack_self(mob/living/user)
	..()
	if(burning)
		to_chat(user, SPAN_DANGER("It's on fire and might explode!"))
		return

	if(user.a_intent == INTENT_HARM)
		unfold_box(user)
		return
	deploy_ammo_box(user, user.loc)

/obj/item/ammo_box/proc/unfold_box(mob/user)
	if(is_loaded())
		to_chat(user, SPAN_WARNING("You need to empty the box before unfolding it!"))
		return
	new /obj/item/stack/sheet/cardboard(user.loc)
	qdel(src)

/obj/item/ammo_box/proc/is_loaded()
	return FALSE

/obj/item/ammo_box/proc/deploy_ammo_box(mob/user, turf/T)
	user.drop_held_item()

//---------------------FIRE HANDLING PROCS
/obj/item/ammo_box/flamer_fire_act(severity, datum/cause_data/flame_cause_data)
	if(burning)
		return
	burning = TRUE

	set_light(3)
	apply_fire_overlay()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), 5 SECONDS)

/obj/item/ammo_box/proc/get_severity()
	return

/obj/item/ammo_box/proc/apply_fire_overlay()
	return

/obj/item/ammo_box/proc/process_burning()
	return

/obj/item/ammo_box/proc/handle_side_effects()
	return

/obj/item/ammo_box/proc/explode(severity, datum/cause_data/flame_cause_data)
	if(severity > 0)
		explosion(get_turf(src),  -1, ((severity > 2) ? 0 : -1), severity - 1, severity + 1, 1, 0, 0, flame_cause_data)
	//just in case
	if(!QDELETED(src))
		qdel(src)
	return

/obj/item/ammo_box/magazine
	name = "magazine box (M41A x 10)"
	icon_state = "base_m41" //base color of box
	var/overlay_ammo_type = "_reg" //used for ammo type color overlay
	var/overlay_gun_type = "_m41" //used for text overlay
	var/overlay_content = "_reg"
	var/obj/item/ammo_magazine/magazine_type = /obj/item/ammo_magazine/rifle
	var/num_of_magazines = 10
	var/handfuls = FALSE
	var/icon_state_deployed = null
	var/handful = "shells" //used for 'magazine' boxes that give handfuls to determine what kind for the sprite
	can_explode = TRUE
	limit_per_tile = 2
	ground_offset_x = 5
	ground_offset_y = 5

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
	update_icon()

/obj/item/ammo_box/magazine/update_icon()
	if(overlays)
		overlays.Cut()
	if(!icon_state_deployed) // The lid is on the sprite already.
		overlays += image(icon, icon_state = "[icon_state]_lid") //adding lid
	if(overlay_gun_type)
		overlays += image(text_markings_icon, icon_state = "text[overlay_gun_type]") //adding text
	if(overlay_ammo_type)
		overlays += image(text_markings_icon, icon_state = "base_type[overlay_ammo_type]") //adding base color stripes
	if(overlay_ammo_type!="_reg" && overlay_ammo_type!="_blank" && (!icon_state_deployed) )
		overlays += image(text_markings_icon, icon_state = "lid_type[overlay_ammo_type]") //adding base color stripes

//---------------------INTERACTION PROCS

/obj/item/ammo_box/magazine/get_examine_text(mob/living/user)
	. = ..()
	. += SPAN_INFO("[SPAN_HELPFUL("Activate")] box in hand or [SPAN_HELPFUL("click")] with it on the ground to deploy it. Activating it while empty will fold it into cardboard sheet.")
	if(src.loc != user) //feeling box weight in a distance is unnatural and bad
		return
	if(!handfuls)
		if(length(contents) < (num_of_magazines/3))
			. += SPAN_INFO("It feels almost empty.")
			return
		if(length(contents) < ((num_of_magazines*2)/3))
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

/obj/item/ammo_box/magazine/is_loaded()
	if(handfuls)
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in contents
		return AM?.current_rounds
	return length(contents)

/obj/item/ammo_box/magazine/deploy_ammo_box(mob/living/user, turf/T)
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

	// Make sure a platform wouldn't block it
	if(box_on_tile * 2 >= limit_per_tile) // Allow 2 if limit is 4
		var/obj/structure/platform/platform = locate() in T
		if(platform?.dir == NORTH)
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

/obj/item/ammo_box/magazine/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
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
			severity = floor(AM.current_rounds / 40)
	else
		for(var/obj/item/ammo_magazine/AM in contents)
			severity += AM.current_rounds
		severity = clamp(severity / 150, 0, 20) // explosion caps at 3k bullets
	return severity

/obj/item/ammo_box/magazine/process_burning(datum/cause_data/flame_cause_data)
	var/obj/structure/magazine_box/host_box
	if(istype(loc, /obj/structure/magazine_box))
		host_box = loc
	if(can_explode)
		var/severity = get_severity()
		if(severity > 0)
			handle_side_effects(host_box, TRUE)
			addtimer(CALLBACK(src, PROC_REF(explode), severity, flame_cause_data), max(5 - severity, 2)) //the more ammo inside, the faster and harder it cooks off
			return
	handle_side_effects(host_box)
	//need to make sure we delete the structure box if it exists, it will handle the deletion of ammo box inside
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), (host_box ? host_box : src)), 5 SECONDS)
	return

/obj/item/ammo_box/magazine/handle_side_effects(obj/structure/magazine_box/host_box, will_explode = FALSE)
	var/shown_message = "\The [src] catches on fire!"
	if(will_explode)
		shown_message = "\The [src] catches on fire and ammunition starts cooking off! It's gonna blow!"

	if(host_box)
		host_box.apply_fire_overlay(will_explode)
		host_box.set_light(3)
		host_box.visible_message(SPAN_WARNING(shown_message))
	else
		apply_fire_overlay(will_explode)
		set_light(3)
		visible_message(SPAN_WARNING(shown_message))

/obj/item/ammo_box/magazine/apply_fire_overlay(will_explode = FALSE)
	//original fire overlay is made for standard mag boxes, so they don't need additional offsetting
	var/offset_y = 0
	if(limit_per_tile == 1) //snowflake nailgun ammo box again
		offset_y += -2
	var/image/fire_overlay = image(flames_icon, icon_state = will_explode ? "on_fire_explode_overlay" : "on_fire_overlay", pixel_y = offset_y)
	overlays.Add(fire_overlay)

//-----------------------------------------------------------------------------------

//-----------------------BIG AMMO BOX (with loose ammunition)---------------

/obj/item/ammo_box/rounds
	name = "\improper rifle ammunition box (10x24mm)"
	desc = "A 10x24mm ammunition box. Used to refill M41A MK1, MK2, M4RA and M41AE2 HPR magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_m41"
	item_state = "base_m41"
	flags_equip_slot = SLOT_BACK
	var/overlay_gun_type = "_rounds" //used for ammo type color overlay
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
	overlays += image(text_markings_icon, icon_state = "text[overlay_gun_type]") //adding base color stripes

	if(bullet_amount == max_bullet_amount)
		overlays += image(handfuls_icon, icon_state = "rounds[overlay_content]")
	else if(bullet_amount > (max_bullet_amount/2))
		overlays += image(handfuls_icon, icon_state = "rounds[overlay_content]_3")
	else if(bullet_amount > (max_bullet_amount/4))
		overlays += image(handfuls_icon, icon_state = "rounds[overlay_content]_2")
	else if(bullet_amount > 0)
		overlays += image(handfuls_icon, icon_state = "rounds[overlay_content]_1")

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



/obj/item/ammo_box/rounds/is_loaded()
	return bullet_amount

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
				if(AM.flags_magazine & AMMUNITION_CANNOT_REMOVE_BULLETS)
					to_chat(user, SPAN_WARNING("You can't remove ammo from \the [AM]!"))
					return
				dumping = TRUE

			var/transfering   = 0   // Amount of bullets we're trying to transfer
			var/transferable  = 0   // Amount of bullets that can actually be transfered
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
					bullet_amount  -= transfering
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

/obj/item/ammo_box/rounds/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	if(burning)
		return
	burning = TRUE
	process_burning(flame_cause_data)
	return

/obj/item/ammo_box/rounds/get_severity()
	return floor(bullet_amount / 200) //we need a lot of bullets to produce an explosion.

/obj/item/ammo_box/rounds/process_burning(datum/cause_data/flame_cause_data)
	if(can_explode)
		var/severity = get_severity()
		if(severity > 0)
			handle_side_effects(TRUE)
			addtimer(CALLBACK(src, PROC_REF(explode), severity, flame_cause_data), max(5 - severity, 2)) //the more ammo inside, the faster and harder it cooks off
			return
	handle_side_effects()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), (src)), 5 SECONDS)

/obj/item/ammo_box/rounds/handle_side_effects(will_explode = FALSE)
	if(will_explode)
		visible_message(SPAN_WARNING("\The [src] catches on fire and ammunition starts cooking off! It's gonna blow!"))
	else
		visible_message(SPAN_WARNING("\The [src] catches on fire!"))

	apply_fire_overlay(will_explode)
	set_light(3)

/obj/item/ammo_box/rounds/apply_fire_overlay(will_explode = FALSE)
	//original fire overlay is made for standard mag boxes, so they don't need additional offsetting
	var/image/fire_overlay = image(icon, icon_state = will_explode ? "on_fire_explode_overlay" : "on_fire_overlay", pixel_x = pixel_x, pixel_y = pixel_y)
	overlays.Add(fire_overlay)
