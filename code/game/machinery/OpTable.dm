// patient_exam defines
#define PATIENT_NOT_AWAKE 1
#define PATIENT_LOW_BLOOD 2
#define PATIENT_LOW_NUTRITION 4

/obj/structure/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/structures/machinery/surgery.dmi'
	icon_state = "table2-idle"
	density = TRUE
	layer = TABLE_LAYER
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	climbable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 1
	active_power_usage = 5
	var/strapped = 0
	can_buckle = TRUE
	buckle_lying = TRUE
	var/buckling_y = -4
	surgery_duration_multiplier = SURGERY_SURFACE_MULT_IDEAL //Ideal surface for surgery.
	var/patient_exam = 0
	var/obj/item/tank/anesthetic/anes_tank

	var/obj/structure/machinery/computer/operating/computer = null

/obj/structure/machinery/optable/Initialize()
	. = ..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/structure/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break
	anes_tank = new(src)

/obj/structure/machinery/optable/Destroy()
	QDEL_NULL(anes_tank)
	QDEL_NULL(computer)
	. = ..()

/obj/structure/machinery/optable/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND

/obj/structure/machinery/optable/ex_act(severity)

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				src.density = FALSE
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return
		else
	return

/obj/structure/machinery/optable/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user, src) > 2 && !isobserver(user))
		return
	if(anes_tank)
		. += SPAN_INFO("It has an [anes_tank] connected with the gauge showing [round(anes_tank.pressure,0.1)] kPa.")

/obj/structure/machinery/optable/attack_hand(mob/living/user)
	if(buckled_mob)
		unbuckle(user)
		return
	if(anes_tank)
		user.put_in_active_hand(anes_tank)
		to_chat(user, SPAN_NOTICE("You remove \the [anes_tank] from \the [src]."))
		anes_tank = null

// Removing marines connected to anesthetic
/obj/structure/machinery/optable/attack_alien(mob/living/carbon/xenomorph/alien, mob/living/user)
	if(buckled_mob)
		to_chat(alien, SPAN_XENONOTICE("You rip the tubes away from the host, releasing it!"))
		playsound(alien, "alien_claw_flesh", 25, 1)
		unbuckle(user)
	else
		. = ..()

/obj/structure/machinery/optable/buckle_mob(mob/living/carbon/human/human, mob/living/user)
	if(!istype(human) || !ishuman(user) || human == user || human.buckled || user.action_busy || user.is_mob_incapacitated() || buckled_mob)
		return

	if(human.loc != loc)
		to_chat(user, SPAN_WARNING("The patient needs to be on the table first."))
		return

	if(!anes_tank)
		to_chat(user, SPAN_WARNING("There is no anesthetic tank connected to the table, load one first."))
		return
	human.visible_message(SPAN_NOTICE("[user] begins to connect [human] to the anesthetic system."))
	if(!do_after(user, 25, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		to_chat(user, SPAN_NOTICE("You stop placing the mask on [human]'s face."))
		return

	if(human.buckled || buckled_mob || human.loc != loc)
		return

	if(!anes_tank)
		to_chat(user, SPAN_WARNING("There is no anesthetic tank connected to the table, load one first."))
		return
	if(human.wear_mask)
		var/obj/item/mask = human.wear_mask
		if(mask.flags_inventory & CANTSTRIP)
			to_chat(user, SPAN_DANGER("You can't remove their mask!"))
			return
		human.drop_inv_item_on_ground(mask)
	var/obj/item/clothing/mask/breath/medical/breath_mask = new()
	if(!human.equip_if_possible(breath_mask, WEAR_FACE, TRUE))
		to_chat(user, SPAN_DANGER("You can't fit the gas mask over their face!"))
		return
	human.update_inv_wear_mask()

	do_buckle(human, user)

/obj/structure/machinery/optable/do_buckle(mob/target, mob/user)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human = target
	human.internal = anes_tank
	human.visible_message(SPAN_NOTICE("[user] fits the mask over [human]'s face and turns on the anesthetic."))
	to_chat(human, SPAN_INFO("You begin to feel sleepy."))
	human.setDir(SOUTH)
	start_processing()
	update_icon()

/obj/structure/machinery/optable/unbuckle(mob/living/user)
	if(!buckled_mob)
		return
	if(ishuman(buckled_mob)) // sanity check
		var/mob/living/carbon/human/human = buckled_mob
		human.internal = null
		var/obj/item/mask = human.wear_mask
		human.drop_inv_item_on_ground(mask)
		qdel(mask)
		if(ishuman(user)) //Checks for whether a xeno is unbuckling from the operating table
			human.visible_message(SPAN_NOTICE("[user] turns off the anesthetic and removes the mask from [human]."))
		else
			human.visible_message(SPAN_WARNING("The anesthesia mask is ripped away from [human]'s face!"))
		stop_processing()
		patient_exam = 0
		..()
		update_icon()

/obj/structure/machinery/optable/afterbuckle(mob/current_mob)
	. = ..()
	if(. && buckled_mob == current_mob)
		current_mob.old_y = current_mob.pixel_y
		current_mob.pixel_y = buckling_y
	else
		current_mob.pixel_y = current_mob.old_y

/obj/structure/machinery/optable/MouseDrop_T(atom/A, mob/user)

	if(istype(A, /obj/item))
		var/obj/item/current_item = A
		if (!istype(current_item) || user.get_active_hand() != current_item)
			return
		if(user.drop_held_item())
			if (current_item.loc != loc)
				step(current_item, get_dir(current_item, src))
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
		var/mob/living/carbon/human/human = buckled_mob
		icon_state = human.pulse ? "table2-active" : "table2-idle"

/obj/structure/machinery/optable/process()
	update_icon()

	if(!ishuman(buckled_mob))
		stop_processing()

	var/mob/living/carbon/human/human = buckled_mob

	// Check for problems
	// Check for blood
	if(human.blood_volume < BLOOD_VOLUME_SAFE)
		if(!(patient_exam & PATIENT_LOW_BLOOD))
			visible_message("[icon2html(src, viewers(src))] <b>The [src] beeps,</b> Warning: Patient has a dangerously low blood level: [round(human.blood_volume / BLOOD_VOLUME_NORMAL * 100)]%. Type: [human.blood_type].")
			patient_exam |= PATIENT_LOW_BLOOD
	else
		patient_exam &= ~PATIENT_LOW_BLOOD

	// Check for nutrition
	if(human.nutrition < NUTRITION_LOW)
		if(!(patient_exam & PATIENT_LOW_NUTRITION))
			visible_message("[icon2html(src, viewers(src))] <b>The [src] beeps,</b> Warning: Patient has a dangerously low nutrition level: [round(human.nutrition / NUTRITION_MAX * 100)]%.")
			patient_exam |= PATIENT_LOW_NUTRITION
	else
		patient_exam &= ~PATIENT_LOW_NUTRITION

	// Check if they awake
	switch(human.stat)
		if(0)
			patient_exam &= ~PATIENT_NOT_AWAKE
		if(1)
			if(!(patient_exam & PATIENT_NOT_AWAKE))
				visible_message("[icon2html(src, viewers(src))] <b>The [src] beeps,</b> Warning: Patient is unconscious.")
				patient_exam |= PATIENT_NOT_AWAKE
		if(2)
			if(!(patient_exam & PATIENT_NOT_AWAKE))
				visible_message("[icon2html(src, viewers(src))] <b>The [src] beeps,</b> Warning: Patient is deceased.")
				patient_exam |= PATIENT_NOT_AWAKE

/obj/structure/machinery/optable/proc/take_victim(mob/living/carbon/current_mob, mob/living/carbon/user)
	if (current_mob == user)
		user.visible_message(SPAN_NOTICE("[user] climbs on the operating table."), \
			SPAN_NOTICE("You climb on the operating table."), null, null, 4)
	else
		visible_message(SPAN_NOTICE("[current_mob] has been laid on the operating table by [user]."), null, 4)
	current_mob.resting = 1
	current_mob.forceMove(loc)

	add_fingerprint(user)

/obj/structure/machinery/optable/verb/mount_table()
	set name = "Mount Operating Table"
	set category = "Object"
	set src in oview(1)

	var/mob/living/carbon/human/human = usr
	if(!istype(human) || human.stat || human.is_mob_restrained() || !check_table(human))
		return

	take_victim(human, human)

/obj/structure/machinery/optable/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/tank/anesthetic))
		if(!anes_tank)
			user.drop_inv_item_to_loc(W, src)
			anes_tank = W
			to_chat(user, SPAN_NOTICE("You connect \the [anes_tank] to \the [src]."))
			return
	if (istype(W, /obj/item/grab) && ishuman(user))
		var/obj/item/grab/grabbing = W
		if(buckled_mob)
			to_chat(user, SPAN_WARNING("The table is already occupied!"))
			return
		var/mob/living/carbon/human/current_mob
		if(ishuman(grabbing.grabbed_thing))
			current_mob = grabbing.grabbed_thing
			if(current_mob.buckled)
				to_chat(user, SPAN_WARNING("Unbuckle first!"))
				return
		else if(istype(grabbing.grabbed_thing,/obj/structure/closet/bodybag/cryobag))
			var/obj/structure/closet/bodybag/cryobag/bag = grabbing.grabbed_thing
			if(!bag.stasis_mob)
				return
			current_mob = bag.stasis_mob
			bag.open()
			user.stop_pulling()
			user.start_pulling(current_mob)
		else
			return

		take_victim(current_mob,user)

/obj/structure/machinery/optable/proc/check_table(mob/living/carbon/patient)
	if(buckled_mob)
		to_chat(patient, SPAN_NOTICE(" <B>The table is already occupied!</B>"))
		return FALSE

	if(patient.buckled)
		to_chat(patient, SPAN_NOTICE(" <B>Unbuckle first!</B>"))
		return FALSE

	return TRUE
