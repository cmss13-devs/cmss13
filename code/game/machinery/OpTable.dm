// patient_exam defines
#define PATIENT_NOT_AWAKE		1
#define	PATIENT_LOW_BLOOD		2
#define PATIENT_LOW_NUTRITION	4

/obj/structure/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/structures/machinery/surgery.dmi'
	icon_state = "table2-idle"
	density = 1
	layer = TABLE_LAYER
	anchored = 1
	unslashable = TRUE
	unacidable = TRUE
	climbable = TRUE
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5
	var/strapped = 0.0
	can_buckle = TRUE
	buckle_lying = TRUE
	var/patient_exam = 0
	var/obj/item/tank/anesthetic/anes_tank

	var/obj/structure/machinery/computer/operating/computer = null

/obj/structure/machinery/optable/New()
	..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/structure/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break
	anes_tank = new(src)

/obj/structure/machinery/optable/Destroy()
	QDEL_NULL(anes_tank)
	. = ..()

/obj/structure/machinery/optable/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND

/obj/structure/machinery/optable/ex_act(severity)

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				src.density = 0
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
		else
	return

/obj/structure/machinery/optable/examine(mob/user)
	..()
	if(get_dist(user, src) > 2 && !isobserver(user))
		return
	if(anes_tank)
		to_chat(user, SPAN_INFO("It has an [anes_tank] connected with the gauge showing [round(anes_tank.pressure,0.1)] kPa."))

/obj/structure/machinery/optable/attack_hand(mob/living/user)
	if(buckled_mob)
		unbuckle(user)
		return
	if(anes_tank)
		user.put_in_active_hand(anes_tank)
		to_chat(user, SPAN_NOTICE("You remove \the [anes_tank] from \the [src]."))
		anes_tank = null


/obj/structure/machinery/optable/buckle_mob(mob/living/carbon/human/H, mob/living/user)
	if(!istype(H) || !ishuman(user) || H == user || H.buckled || user.action_busy || user.is_mob_incapacitated() || buckled_mob)
		return

	if(H.loc != loc)
		to_chat(user, SPAN_WARNING("The patient needs to be on the table first."))
		return

	if(!anes_tank)
		to_chat(user, SPAN_WARNING("There is no anesthetic tank connected to the table, load one first."))
		return
	H.visible_message(SPAN_NOTICE("[user] begins to connect [H] to the anesthetic system."))
	if(!do_after(user, 25, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		to_chat(user, SPAN_NOTICE("You stop placing the mask on [H]'s face."))
		return

	if(H.buckled || buckled_mob || H.loc != loc)
		return

	if(!anes_tank)
		to_chat(user, SPAN_WARNING("There is no anesthetic tank connected to the table, load one first."))
		return
	if(H.wear_mask && !H.drop_inv_item_on_ground(H.wear_mask))
		to_chat(user, SPAN_DANGER("You can't remove their mask!"))
		return

	var/obj/item/clothing/mask/breath/medical/B = new()
	if(!H.equip_if_possible(B, WEAR_FACE, TRUE))
		to_chat(user, SPAN_DANGER("You can't fit the gas mask over their face!"))
		return
	H.update_inv_wear_mask()

	do_buckle(H, user)

/obj/structure/machinery/optable/do_buckle(mob/target, mob/user)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = target
	H.internal = anes_tank
	H.visible_message(SPAN_NOTICE("[user] fits the mask over [H]'s face and turns on the anesthetic."))
	to_chat(H, SPAN_INFO("You begin to feel sleepy."))
	H.dir = SOUTH
	start_processing()
	update_icon()

/obj/structure/machinery/optable/unbuckle(mob/living/user)
	if(!buckled_mob)
		return
	if(ishuman(buckled_mob)) // sanity check
		var/mob/living/carbon/human/H = buckled_mob
		H.internal = null
		var/obj/item/M = H.wear_mask
		H.drop_inv_item_on_ground(M)
		qdel(M)
		H.visible_message(SPAN_NOTICE("[user] turns off the anesthetic and removes the mask from [H]."))
		stop_processing()
		patient_exam = 0
		..()
		update_icon()

/obj/structure/machinery/optable/MouseDrop_T(atom/A, mob/user)

	if(istype(A, /obj/item))
		var/obj/item/I = A
		if (!istype(I) || user.get_active_hand() != I)
			return
		if(user.drop_held_item())
			if (I.loc != loc)
				step(I, get_dir(I, src))
	else if(ismob(A))
		..()

/obj/structure/machinery/optable/power_change()
	..()
	update_icon()

/obj/structure/machinery/optable/update_icon()
	if(inoperable())
		icon_state = "table2-idle"
	else if(!ishuman(buckled_mob))
		icon_state = "table2-idle"
	else
		var/mob/living/carbon/human/H = buckled_mob
		icon_state = H.pulse ? "table2-active" : "table2-idle"

/obj/structure/machinery/optable/process()
	update_icon()

	if(!ishuman(buckled_mob))
		stop_processing()

	var/mob/living/carbon/human/H = buckled_mob

	// Check for problems
	// Check for blood
	if(H.blood_volume < BLOOD_VOLUME_SAFE)
		if(!(patient_exam & PATIENT_LOW_BLOOD))
			visible_message("[htmlicon(src, viewers(src))] <b>The [src] beeps,</b> Warning: Patient has a dangerously low blood level: [round(H.blood_volume / BLOOD_VOLUME_NORMAL * 100)]%. Type: [H.blood_type].")
			patient_exam |= PATIENT_LOW_BLOOD
	else
		patient_exam &= ~PATIENT_LOW_BLOOD

	// Check for nutrition
	if(H.nutrition < NUTRITION_LOW)
		if(!(patient_exam & PATIENT_LOW_NUTRITION))
			visible_message("[htmlicon(src, viewers(src))] <b>The [src] beeps,</b> Warning: Patient has a dangerously low nutrition level: [round(H.nutrition / NUTRITION_MAX * 100)]%.")
			patient_exam |= PATIENT_LOW_NUTRITION
	else
		patient_exam &= ~PATIENT_LOW_NUTRITION

	// Check if they awake
	switch(H.stat)
		if(0)
			patient_exam &= ~PATIENT_NOT_AWAKE
		if(1)
			if(!(patient_exam & PATIENT_NOT_AWAKE))
				visible_message("[htmlicon(src, viewers(src))] <b>The [src] beeps,</b> Warning: Patient is unconscious.")
				patient_exam |= PATIENT_NOT_AWAKE
		if(2)
			if(!(patient_exam & PATIENT_NOT_AWAKE))
				visible_message("[htmlicon(src, viewers(src))] <b>The [src] beeps,</b> Warning: Patient is deceased.")
				patient_exam |= PATIENT_NOT_AWAKE

/obj/structure/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user)
	if (C == user)
		user.visible_message(SPAN_NOTICE("[user] climbs on the operating table."), \
			SPAN_NOTICE("You climb on the operating table."), null, null, 4)
	else
		visible_message(SPAN_NOTICE("[C] has been laid on the operating table by [user]."), null, 4)
	C.resting = 1
	C.forceMove(loc)

	add_fingerprint(user)

/obj/structure/machinery/optable/verb/mount_table()
	set name = "Mount Operating Table"
	set category = "Object"
	set src in oview(1)

	var/mob/living/carbon/human/H = usr
	if(!istype(H) || H.stat || H.is_mob_restrained() || !check_table(H))
		return

	take_victim(H, H)

/obj/structure/machinery/optable/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/tank/anesthetic))
		if(!anes_tank)
			user.drop_inv_item_to_loc(W, src)
			anes_tank = W
			to_chat(user, SPAN_NOTICE("You connect \the [anes_tank] to \the [src]."))
			return
	if (istype(W, /obj/item/grab) && ishuman(user))
		var/obj/item/grab/G = W
		if(buckled_mob)
			to_chat(user, SPAN_WARNING("The table is already occupied!"))
			return
		var/mob/living/carbon/M
		if(iscarbon(G.grabbed_thing))
			M = G.grabbed_thing
			if(M.buckled)
				to_chat(user, SPAN_WARNING("Unbuckle first!"))
				return
		else if(istype(G.grabbed_thing,/obj/structure/closet/bodybag/cryobag))
			var/obj/structure/closet/bodybag/cryobag/C = G.grabbed_thing
			if(!C.stasis_mob)
				return
			M = C.stasis_mob
			C.open()
			user.stop_pulling()
			user.start_pulling(M)
		else
			return

		take_victim(M,user)

/obj/structure/machinery/optable/proc/check_table(mob/living/carbon/patient)
	if(buckled_mob)
		to_chat(patient, SPAN_NOTICE(" <B>The table is already occupied!</B>"))
		return FALSE

	if(patient.buckled)
		to_chat(patient, SPAN_NOTICE(" <B>Unbuckle first!</B>"))
		return FALSE

	return TRUE
