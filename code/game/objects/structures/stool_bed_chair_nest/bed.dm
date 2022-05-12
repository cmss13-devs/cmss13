/*
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "A mattress seated on a rectangular metallic frame. This is used to support a lying person in a comfortable manner, notably for regular sleep. Ancient technology, but still useful."
	icon_state = "bed"
	icon = 'icons/obj/objects.dmi'
	can_buckle = TRUE
	buckle_lying = TRUE
	throwpass = TRUE
	debris = list(/obj/item/stack/sheet/metal)
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 1
	var/foldabletype //To fold into an item (e.g. roller bed item)
	var/buckling_y = 0 //pixel y shift to give to the buckled mob.
	var/obj/structure/closet/bodybag/buckled_bodybag
	var/accepts_bodybag = FALSE //Whether you can buckle bodybags to this bed
	var/base_bed_icon //Used by beds that change sprite when something is buckled to them
	var/hit_bed_sound = 'sound/effects/metalhit.ogg' //sound player when attacked by a xeno
	/// Sound when buckled to a bed/chair/stool
	var/buckling_sound = 'sound/effects/buckle.ogg'
	surgery_duration_multiplier = SURGERY_SURFACE_MULT_UNSUITED

/obj/structure/bed/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND|PASS_UNDER

/obj/structure/bed/update_icon()
	if(base_bed_icon)
		if(buckled_mob || buckled_bodybag)
			icon_state = "[base_bed_icon]_up"
		else
			icon_state = "[base_bed_icon]_down"

obj/structure/bed/Destroy()
	if(buckled_bodybag)
		unbuckle()
	. = ..()

/obj/structure/bed/ex_act(var/power)
	if(power >= EXPLOSION_THRESHOLD_VLOW)
		if(!isnull(buildstacktype))
			new buildstacktype(get_turf(src), buildstackamount)
		qdel(src)

/obj/structure/bed/afterbuckle(mob/M)
	. = ..()
	if(. && buckled_mob == M)
		M.pixel_y = buckling_y
		M.old_y = buckling_y
		if(base_bed_icon)
			density = 1
	else
		M.pixel_y = initial(buckled_mob.pixel_y)
		M.old_y = initial(buckled_mob.pixel_y)
		if(base_bed_icon)
			density = 0

	update_icon()

//Unsafe proc
/obj/structure/bed/proc/do_buckle_bodybag(obj/structure/closet/bodybag/B, mob/user)
	B.visible_message(SPAN_NOTICE("[user] buckles [B] to [src]!"))
	B.roller_buckled = src
	B.forceMove(loc)
	B.setDir(dir)
	buckled_bodybag = B
	density = 1
	update_icon()
	if(buckling_y)
		buckled_bodybag.pixel_y = buckled_bodybag.buckle_offset + buckling_y
	add_fingerprint(user)

/obj/structure/bed/unbuckle()
	if(buckled_bodybag)
		buckled_bodybag.pixel_y = initial(buckled_bodybag.pixel_y)
		buckled_bodybag.roller_buckled = null
		buckled_bodybag = null
		density = 0
		update_icon()
	else
		..()

/obj/structure/bed/manual_unbuckle(mob/user)
	if(buckled_bodybag)
		unbuckle()
		add_fingerprint(user)
		return 1
	else
		. = ..()

//Trying to buckle a mob
/obj/structure/bed/buckle_mob(mob/M, mob/user)
	if(buckled_bodybag)
		return
	..()
	if(M.loc == src.loc && buckling_sound && M.buckled)
		playsound(src, buckling_sound, 20)

/obj/structure/bed/Move(NewLoc, direct)
	. = ..()
	if(. && buckled_bodybag && !handle_buckled_bodybag_movement(loc,direct)) //Movement fails if buckled mob's move fails.
		return 0

/obj/structure/bed/proc/handle_buckled_bodybag_movement(NewLoc, direct)
	if(!(direct & (direct - 1))) //Not diagonal move. the obj's diagonal move is split into two cardinal moves and those moves will handle the buckled bodybag's movement.
		if(!buckled_bodybag.Move(NewLoc, direct))
			forceMove(buckled_bodybag.loc)
			last_move_dir = buckled_bodybag.last_move_dir
			return 0
	return 1

/obj/structure/bed/roller/BlockedPassDirs(atom/movable/mover, target_dir)
	if(mover == buckled_bodybag)
		return NO_BLOCKED_MOVEMENT
	return ..()

/obj/structure/bed/MouseDrop_T(atom/dropping, mob/user)
	if(accepts_bodybag && !buckled_bodybag && !buckled_mob && istype(dropping,/obj/structure/closet/bodybag) && ishuman(user))
		var/obj/structure/closet/bodybag/B = dropping
		if(!B.roller_buckled)
			do_buckle_bodybag(B, user)
			return TRUE
	else
		. = ..()

/obj/structure/bed/MouseDrop(atom/over_object)
	. = ..()
	if(foldabletype && !buckled_mob && !buckled_bodybag)
		if (istype(over_object, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = over_object
			if (H==usr && !H.is_mob_incapacitated() && Adjacent(H) && in_range(src, over_object))
				var/obj/item/I = new foldabletype(get_turf(src))
				H.put_in_hands(I)
				H.visible_message(SPAN_WARNING("[H] grabs [src] from the floor!"),
				SPAN_WARNING("You grab [src] from the floor!"))
				qdel(src)


/obj/structure/bed/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		if(buildstacktype)
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			new buildstacktype(loc, buildstackamount)
			qdel(src)

	else if(istype(W, /obj/item/grab) && !buckled_mob)
		var/obj/item/grab/G = W
		if(ismob(G.grabbed_thing))
			var/mob/M = G.grabbed_thing
			var/atom/blocker = LinkBlocked(user, user.loc, loc)
			if(blocker)
				to_chat(user, SPAN_WARNING("\The [blocker] is in the way!"))
			else
				to_chat(user, SPAN_NOTICE("You place [M] on [src]."))
				M.forceMove(loc)
		return TRUE

	else
		. = ..()

/obj/structure/bed/alien
	icon_state = "abed"

/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "roller bed"
	desc = "A basic cushioned leather board resting on a small frame. Not very comfortable at all, but allows the patient to rest lying down while moved to another location rapidly. Not great for surgery, but better than nothing."
	icon = 'icons/obj/structures/rollerbed.dmi'
	icon_state = "roller_down"
	anchored = FALSE
	drag_delay = 0 //Pulling something on wheels is easy
	buckling_y = 3
	foldabletype = /obj/item/roller
	accepts_bodybag = TRUE
	base_bed_icon = "roller"

/obj/structure/bed/roller/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/roller_holder) && !buckled_bodybag)
		if(buckled_mob || buckled_bodybag)
			manual_unbuckle()
		else
			visible_message(SPAN_NOTICE("[user] collapses [name]."))
			new/obj/item/roller(get_turf(src))
			qdel(src)
		return
	. = ..()

/obj/structure/bed/roller/buckle_mob(mob/M, mob/user)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.handcuffed)
			to_chat(user, SPAN_DANGER("You cannot buckle someone who is handcuffed onto this bed."))
			return
	..()

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/structures/rollerbed.dmi'
	icon_state = "folded"
	w_class = SIZE_SMALL //Fits in a backpack
	drag_delay = 1 //Pulling something on wheels is easy
	matter = list("plastic" = 5000)
	var/rollertype = /obj/structure/bed/roller

/obj/item/roller/attack_self(mob/user)
	..()
	deploy_roller(user, user.loc)

/obj/item/roller/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(isturf(target))
		var/turf/T = target
		if(!T.density)
			deploy_roller(user, target)

/obj/item/roller/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/roller_holder) && rollertype == /obj/structure/bed/roller)
		var/obj/item/roller_holder/RH = W
		if(!RH.held)
			to_chat(user, SPAN_NOTICE("You pick up [src]."))
			forceMove(RH)
			RH.held = src
			return
	. = ..()

/obj/item/roller/proc/deploy_roller(mob/user, atom/location)
	var/obj/structure/bed/roller/R = new rollertype(location)
	R.add_fingerprint(user)
	user.temp_drop_inv_item(src)
	qdel(src)

/obj/item/roller_holder
	name = "roller bed rack"
	desc = "A rack for carrying a collapsed roller bed."
	icon = 'icons/obj/structures/rollerbed.dmi'
	icon_state = "folded"
	var/obj/item/roller/held

/obj/item/roller_holder/Initialize()
	. = ..()
	held = new /obj/item/roller(src)

/obj/item/roller_holder/attack_self(mob/user)
	..()

	if(!held)
		to_chat(user, SPAN_WARNING("The rack is empty."))
		return

	var/obj/structure/bed/roller/R = new(user.loc)
	to_chat(user, SPAN_NOTICE("You deploy [R]."))
	R.add_fingerprint(user)
	QDEL_NULL(held)

//////////////////////////////////////////////
//			PORTABLE SURGICAL BED			//
//////////////////////////////////////////////

/obj/structure/bed/portable_surgery
	name = "portable surgical bed"
	desc = "A collapsible surgical bed. It's not perfect, but it's the best you'll get short of an actual surgical table."
	icon = 'icons/obj/structures/rollerbed.dmi'
	icon_state = "surgical_down"
	buckling_y = 2
	foldabletype = /obj/item/roller/surgical
	base_bed_icon = "surgical"
	accepts_bodybag = FALSE
	surgery_duration_multiplier = SURGERY_SURFACE_MULT_ADEQUATE

/obj/item/roller/surgical
	name = "portable surgical bed"
	desc = "A collapsed surgical bed that can be carried around."
	icon_state = "surgical_folded"
	rollertype = /obj/structure/bed/portable_surgery
	matter = list("plastic" = 6000)

////////////////////////////////////////////
			//MEDEVAC STRETCHER
//////////////////////////////////////////////

//List of all activated medevac stretchers
var/global/list/activated_medevac_stretchers = list()

/obj/structure/bed/medevac_stretcher
	name = "medevac stretcher"
	desc = "A medevac stretcher with integrated beacon for rapid evacuation of an injured patient via dropship lift. Accepts patients and body bags. Completely useless for surgery."
	icon = 'icons/obj/structures/rollerbed.dmi'
	icon_state = "stretcher_down"
	buckling_y = -1
	foldabletype = /obj/item/roller/medevac
	base_bed_icon = "stretcher"
	accepts_bodybag = TRUE
	var/stretcher_activated
	var/obj/structure/dropship_equipment/medevac_system/linked_medevac
	surgery_duration_multiplier = SURGERY_SURFACE_MULT_AWFUL //On the one hand, it's a big stretcher. On the other hand, you have a big sheet covering the patient and those damned Fulton hookups everywhere.

/obj/structure/bed/medevac_stretcher/Destroy()
	if(stretcher_activated)
		stretcher_activated = FALSE
		activated_medevac_stretchers -= src
		if(linked_medevac)
			linked_medevac.linked_stretcher = null
			linked_medevac = null
		update_icon()
	. = ..()

/obj/structure/bed/medevac_stretcher/update_icon()
	..()
	overlays.Cut()
	if(stretcher_activated)
		overlays += image("beacon_active_[density ? "up":"down"]")

	if(buckled_mob || buckled_bodybag)
		overlays += image("icon_state"="stretcher_box","layer"=LYING_LIVING_MOB_LAYER + 0.1)


/obj/structure/bed/medevac_stretcher/verb/activate_medevac_beacon()
	set name = "Activate medevac"
	set desc = "Toggle the medevac beacon inside the stretcher."
	set category = "Object"
	set src in oview(1)

	toggle_medevac_beacon(usr)

/obj/structure/bed/medevac_stretcher/proc/toggle_medevac_beacon(mob/user)
	if(!ishuman(user))
		return

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You don't know how to use [src]."))
		return

	if(user == buckled_mob)
		to_chat(user, SPAN_WARNING("You can't reach the beacon activation button while buckled to [src]."))
		return

	if(stretcher_activated)
		stretcher_activated = FALSE
		activated_medevac_stretchers -= src
		if(linked_medevac)
			linked_medevac.linked_stretcher = null
			linked_medevac = null
		to_chat(user, SPAN_NOTICE("You deactivate [src]'s beacon."))
		update_icon()

	else
		if(!is_ground_level(z))
			to_chat(user, SPAN_WARNING("You can't activate [src]'s beacon here."))
			return

		var/area/AR = get_area(src)
		if(CEILING_IS_PROTECTED(AR.ceiling, CEILING_PROTECTION_TIER_1))
			to_chat(user, SPAN_WARNING("[src] must be in the open or under a glass roof."))
			return

		if(buckled_mob || buckled_bodybag)
			stretcher_activated = TRUE
			activated_medevac_stretchers += src
			to_chat(user, SPAN_NOTICE("You activate [src]'s beacon."))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("You need to attach something to [src] before you can activate its beacon yet."))

/obj/item/roller/medevac
	name = "medevac stretcher"
	desc = "A collapsed medevac stretcher that can be carried around."
	icon_state = "stretcher_folded"
	rollertype = /obj/structure/bed/medevac_stretcher
	matter = list("plastic" = 5000, "metal" = 5000)
