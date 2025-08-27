//Autodoc
/obj/structure/machinery/medical_pod/autodoc
	name = "autodoc emergency medical system"
	desc = "An emergency surgical device designed to perform life-saving treatments and basic surgeries on patients automatically, without the need of a surgeon. <br>It still requires someone with medical knowledge to program the treatments correctly; for this reason, colonies that use these often have paramedics trained in autodoc operation."
	icon_state = "autodoc_open"

	entry_timer = 2 SECONDS
	skilllock = SKILL_SURGERY_NOVICE

	var/list/surgery_todo_list = list() //a list of surgeries to do.
	var/surgery = 0 //Are we operating or no? 0 for no, 1 for yes
	var/surgery_mod = 1 //What multiple to increase the surgery timer? This is used for any non-WO maps or events that are done.
	var/obj/item/reagent_container/blood/OMinus/blood_pack = new()
	var/filtering = 0
	var/blood_transfer = 0
	var/heal_brute = 0
	var/heal_burn = 0
	var/heal_toxin = 0

	var/obj/structure/machinery/autodoc_console/connected

	//It uses power
	use_power = USE_POWER_IDLE
	idle_power_usage = 15
	active_power_usage = 450 //Capable of doing various activities

	var/stored_metal = 125 // starts with 125 metal loaded
	var/max_metal = 500

/obj/structure/machinery/medical_pod/autodoc/update_icon()
	if(occupant)
		if(surgery)
			icon_state = "autodoc_operate"
		else
			icon_state = "autodoc_closed"
	else
		icon_state = "autodoc_open"

/obj/structure/machinery/medical_pod/autodoc/Initialize()
	. = ..()
	connect_autodoc_console()
	flags_atom |= USES_HEARING

// --- MEDICAL POD PROC OVERRIDES --- \\

/obj/structure/machinery/medical_pod/autodoc/go_in(mob/patient)
	. = ..()
	start_processing()
	if(connected)
		connected.start_processing()

/obj/structure/machinery/medical_pod/autodoc/go_out()
	. = ..()
	surgery = FALSE
	heal_brute = FALSE
	heal_burn = FALSE
	heal_toxin = FALSE
	filtering = FALSE
	blood_transfer = FALSE
	surgery_todo_list = list()
	stop_processing()
	if(connected)
		connected.stop_processing()
		connected.process() // one last update

/obj/structure/machinery/medical_pod/autodoc/extra_eject_checks()
	if(usr == occupant)
		if(surgery)
			to_chat(usr, SPAN_WARNING("There's no way you're getting out while this thing is operating on you!"))
			return FALSE
		else
			visible_message("[usr] engages the internal release mechanism, and climbs out of \the [src].")
			return TRUE
	if(surgery)
		visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> malfunctions as [usr] aborts the surgery in progress.")
		occupant.take_limb_damage(rand(30,50),rand(30,50))
		// message_admins for now, may change to message_admins later
		message_admins("[key_name(usr)] ejected [key_name(occupant)] from the autodoc during surgery causing damage.")
		return TRUE
	return TRUE


/obj/structure/machinery/medical_pod/autodoc/proc/connect_autodoc_console()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/autodoc_console,get_step(src, EAST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/autodoc_console,get_step(src, WEST))
	if(connected)
		connected.connected = src

/obj/structure/machinery/medical_pod/autodoc/Destroy()
	if(occupant)
		occupant.forceMove(loc)
		occupant = null
		stop_processing()
		if(connected)
			connected.stop_processing()
	if(connected)
		connected.connected = null
		QDEL_NULL(connected)
	. = ..()



/obj/structure/machinery/medical_pod/autodoc/power_change(area/master_area = null)
	..()
	if((stat & NOPOWER) && occupant)
		visible_message("\The [src] engages the safety override, ejecting the occupant.")
		go_out()
		return

/obj/structure/machinery/medical_pod/autodoc/proc/heal_limb(mob/living/carbon/human/human, brute, burn)
	var/list/obj/limb/parts = human.get_damaged_limbs(brute,burn)
	if(!length(parts))
		return
	var/obj/limb/picked = pick(parts)
	if(picked.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		picked.heal_damage(brute, burn, TRUE)
		human.pain.apply_pain(-brute, BRUTE)
		human.pain.apply_pain(-burn, BURN)
	else
		human.apply_damage(-brute, BRUTE, picked)
		human.apply_damage(-burn, BURN, picked)

	human.UpdateDamageIcon()
	human.updatehealth()

/obj/structure/machinery/medical_pod/autodoc/process()
	set background = 1

	updateUsrDialog()
	if(occupant)
		if(occupant.stat == DEAD)
			visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Patient has expired.")
			go_out()
			return
		if(surgery)
			// keep them alive
			occupant.apply_damage(-1 * REM, TOX) // pretend they get IV dylovene
			occupant.apply_damage(-occupant.getOxyLoss(), OXY) // keep them breathing, pretend they get IV dexplus
			if(filtering)
				var/filtered = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.remove_reagent(x.id, 3) // same as sleeper, may need reducing
					filtered += 3
				if(!filtered)
					filtering = 0
					visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Blood filtering complete.")
				else if(prob(10))
					visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> whirrs and gurgles as the dialysis module operates.")
					to_chat(occupant, SPAN_INFO("You feel slightly better."))
			if(blood_transfer)
				if(occupant.blood_volume < BLOOD_VOLUME_NORMAL)
					if(blood_pack.reagents.get_reagent_amount("blood") < 4)
						blood_pack.reagents.add_reagent("blood", 195, list("viruses"=null,"blood_type"="O-","resistances"=null))
						visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Blood reserves depleted, switching to fresh container.")
					occupant.inject_blood(blood_pack, 8) // double iv stand rate
					if(prob(10))
						visible_message("\The [src] whirrs and gurgles as it transfuses blood.")
						to_chat(occupant, SPAN_INFO("You feel slightly less faint."))
				else
					blood_transfer = 0
					visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Blood transfusion complete.")
			if(heal_brute)
				if(occupant.getBruteLoss() > 0)
					heal_limb(occupant, 3, 0)
					if(prob(10))
						visible_message("\The [src] whirrs and clicks as it stitches flesh together.")
						to_chat(occupant, SPAN_INFO("You feel your wounds being stitched and sealed shut."))
				else
					heal_brute = 0
					visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Trauma repair surgery complete.")
			if(heal_burn)
				if(occupant.getFireLoss() > 0)
					heal_limb(occupant, 0, 3)
					if(prob(10))
						visible_message("\The [src] whirrs and clicks as it grafts synthetic skin.")
						to_chat(occupant, SPAN_INFO("You feel your burned flesh being sliced away and replaced."))
				else
					heal_burn = 0
					visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Skin grafts complete.")
			if(heal_toxin)
				if(occupant.getToxLoss() > 0)
					occupant.apply_damage(-3, TOX)
					if(prob(10))
						visible_message("\The [src] whirrs and gurgles as it chelates the occupant.")
						to_chat(occupant, SPAN_INFO("You feel slightly less ill."))
				else
					heal_toxin = 0
					visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Toxin removal complete.")


#define LIMB_SURGERY 1
#define ORGAN_SURGERY 2
#define EXTERNAL_SURGERY 3

#define UNNEEDED_DELAY 100 // how long to waste if someone queues an unneeded surgery

/datum/autodoc_surgery
	var/obj/limb/limb_ref = null
	var/datum/internal_organ/organ_ref = null
	var/type_of_surgery = 0 // the above constants
	var/surgery_procedure = "" // text of surgery
	var/unneeded = 0

/proc/create_autodoc_surgery(limb_ref, type_of_surgery, surgery_procedure, unneeded=0, organ_ref=null)
	var/datum/autodoc_surgery/auto_surgery = new()
	auto_surgery.type_of_surgery = type_of_surgery
	auto_surgery.surgery_procedure = surgery_procedure
	auto_surgery.unneeded = unneeded
	auto_surgery.limb_ref = limb_ref
	auto_surgery.organ_ref = organ_ref
	return auto_surgery

/obj/structure/machinery/medical_pod/autodoc/allow_drop()
	return 0

/proc/generate_autodoc_surgery_list(mob/living/carbon/human/patient)
	if(!ishuman(patient))
		return list()
	var/surgery_list = list()
	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)

	for(var/obj/limb/limb in patient.limbs)
		if(limb)
			for(var/datum/wound/wound in limb.wounds)
				if(wound.internal)
					surgery_list += create_autodoc_surgery(limb,LIMB_SURGERY,"internal")
					break

			var/organdamagesurgery = 0
			for(var/datum/internal_organ/organ in limb.internal_organs)
				if(organ.robotic == ORGAN_ASSISTED || organ.robotic == ORGAN_ROBOT)
					// we can't deal with these
					continue
				if(organ.damage > 0)
					if(organ.name == "eyeballs") // treat eye surgery differently
						continue
					if(organdamagesurgery > 0)
						continue // avoid duplicates
					surgery_list += create_autodoc_surgery(limb,ORGAN_SURGERY,"organdamage",0,organ)
					organdamagesurgery++

			if(limb.status & LIMB_BROKEN)
				surgery_list += create_autodoc_surgery(limb,LIMB_SURGERY,"broken")
			if(limb.status & LIMB_DESTROYED)
				if(!(limb.parent.status & LIMB_DESTROYED) && limb.name != "head")
					surgery_list += create_autodoc_surgery(limb,LIMB_SURGERY,"missing")
			if(length(limb.implants))
				for(var/implant in limb.implants)
					if(!is_type_in_list(implant,known_implants))
						surgery_list += create_autodoc_surgery(limb,LIMB_SURGERY,"shrapnel")
			if(patient.incision_depths[limb.name] != SURGERY_DEPTH_SURFACE)
				surgery_list += create_autodoc_surgery(limb,LIMB_SURGERY,"open")
	var/datum/internal_organ/eyes = patient.internal_organs_by_name["eyes"]
	if(eyes && (patient.disabilities & NEARSIGHTED || patient.sdisabilities & DISABILITY_BLIND || eyes.damage > 0))
		surgery_list += create_autodoc_surgery(null,ORGAN_SURGERY,"eyes",0,eyes)
	if(patient.getBruteLoss() > 0)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"brute")
	if(patient.getFireLoss() > 0)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"burn")
	if(patient.getToxLoss() > 0)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"toxin")
	var/overdoses = 0
	for(var/datum/reagent/chem in patient.reagents.reagent_list)
		if(istype(chem,/datum/reagent/toxin) || patient.reagents.get_reagent_amount(chem.id) > chem.overdose)
			overdoses++
	if(overdoses)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"dialysis")
	if(patient.blood_volume < BLOOD_VOLUME_NORMAL)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"blood")
	return surgery_list

/obj/structure/machinery/medical_pod/autodoc/proc/surgery_op(mob/living/carbon/enclosed)
	set background = 1

	if(enclosed.stat == DEAD||!ishuman(enclosed))
		visible_message("\The [src] buzzes.")
		src.go_out() //kick them out too.
		return

	var/mob/living/carbon/human/patient = enclosed
	var/datum/data/record/patient_record = null
	var/human_ref = WEAKREF(patient)
	for(var/datum/data/record/medrec as anything in GLOB.data_core.medical)
		if (medrec.fields["ref"] == human_ref)
			patient_record = medrec
	if(isnull(patient_record))
		patient_record = create_medical_record(patient)

	if(!length(surgery_todo_list))
		visible_message("\The [src] buzzes, no surgical procedures were queued.")
		return

	visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> begins to operate, loud audible clicks lock the pod.")
	surgery = 1
	update_icon()

	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)

	for(var/datum/autodoc_surgery/auto_surgery in surgery_todo_list)
		if(auto_surgery.type_of_surgery == EXTERNAL_SURGERY)
			switch(auto_surgery.surgery_procedure)
				if("brute")
					heal_brute = 1
				if("burn")
					heal_burn = 1
				if("toxin")
					heal_toxin = 1
				if("dialysis")
					filtering = 1
				if("blood")
					blood_transfer = 1
			surgery_todo_list -= auto_surgery

	var/currentsurgery = 1
	while(length(surgery_todo_list) > 0)
		if(!surgery)
			break;
		sleep(-1)
		var/datum/autodoc_surgery/current_surgery = surgery_todo_list[currentsurgery]
		surgery_mod = 1 // might need tweaking

		switch(current_surgery.type_of_surgery)
			if(ORGAN_SURGERY)
				switch(current_surgery.surgery_procedure)
					if("organdamage")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Beginning organ restoration.")
						if(current_surgery.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.")
							surgery_todo_list -= current_surgery
							continue
						open_incision(patient,current_surgery.limb_ref)

						if(current_surgery.limb_ref.name != "groin")
							open_encased(patient,current_surgery.limb_ref)

						if(!istype(current_surgery.organ_ref,/datum/internal_organ/brain))
							sleep(FIX_ORGAN_MAX_DURATION*surgery_mod)
						else
							if(current_surgery.organ_ref.damage > BONECHIPS_MAX_DAMAGE)
								sleep(FIXVEIN_MAX_DURATION*surgery_mod)
							sleep(REMOVE_OBJECT_MAX_DURATION*surgery_mod)
						if(!surgery)
							break
						if(istype(current_surgery.organ_ref,/datum/internal_organ))
							current_surgery.organ_ref.rejuvenate()
						else
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Organ is missing.")

						// close them
						if(current_surgery.limb_ref.name != "groin") // TODO: fix brute damage before closing
							close_encased(patient,current_surgery.limb_ref)
						close_incision(patient,current_surgery.limb_ref)

					if("eyes")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Beginning corrective eye surgery.")
						if(current_surgery.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.")
							surgery_todo_list -= current_surgery
							continue
						if(istype(current_surgery.organ_ref,/datum/internal_organ/eyes))
							var/datum/internal_organ/eyes/eye = current_surgery.organ_ref

							if(eye.eye_surgery_stage == 0)
								sleep(SCALPEL_MAX_DURATION)
								if(!surgery)
									break
								eye.eye_surgery_stage = 1
								patient.disabilities |= NEARSIGHTED // code\#define\mobs.dm

							if(eye.eye_surgery_stage == 1)
								sleep(RETRACTOR_MAX_DURATION)
								if(!surgery)
									break
								eye.eye_surgery_stage = 2

							if(eye.eye_surgery_stage == 2)
								sleep(HEMOSTAT_MAX_DURATION)
								if(!surgery)
									break
								eye.eye_surgery_stage = 3

							if(eye.eye_surgery_stage == 3)
								sleep(CAUTERY_MAX_DURATION)
								if(!surgery)
									break
								patient.disabilities &= ~NEARSIGHTED
								patient.sdisabilities &= ~DISABILITY_BLIND
								eye.heal_damage(eye.damage)
								eye.eye_surgery_stage = 0
					if("larva")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b>beeps: Removing unknown parasites.")
						if(!locate(/obj/item/alien_embryo) in occupant)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b> speaks: Procedure has been deemed unnecessary.")// >:)
							surgery_todo_list -= current_surgery
							continue
						sleep(SCALPEL_MAX_DURATION + HEMOSTAT_MAX_DURATION + REMOVE_OBJECT_MAX_DURATION)
						var/obj/item/alien_embryo/alien_larva = locate() in occupant
						var/mob/living/carbon/xenomorph/larva/living_xeno = locate() in occupant
						if(living_xeno)
							living_xeno.forceMove(get_turf(occupant)) //funny stealth larva bursts incoming
							qdel(alien_larva)
						else
							alien_larva.forceMove(get_turf(occupant))
							occupant.status_flags &= ~XENO_HOST


			if(LIMB_SURGERY)
				switch(current_surgery.surgery_procedure)
					if("internal")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Beginning internal bleeding procedure.")
						if(current_surgery.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.")
							surgery_todo_list -= current_surgery
							continue
						open_incision(patient,current_surgery.limb_ref)
						for(var/datum/wound/wound in current_surgery.limb_ref.wounds)
							if(!surgery)
								break
							if(wound.internal)
								sleep(FIXVEIN_MIN_DURATION-30)
								current_surgery.limb_ref.wounds -= wound
								current_surgery.limb_ref.remove_all_bleeding(FALSE, TRUE)
								qdel(wound)
						if(!surgery)
							break
						close_incision(patient,current_surgery.limb_ref)

					if("broken")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Beginning broken bone procedure.")
						if(current_surgery.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.")
							surgery_todo_list -= current_surgery
							continue
						open_incision(patient,current_surgery.limb_ref)
						sleep(BONEGEL_REPAIR_MAX_DURATION*surgery_mod+20)
						if(current_surgery.limb_ref.brute_dam > 20)
							sleep(((current_surgery.limb_ref.brute_dam - 20)/2)*surgery_mod)
							if(!surgery)
								break
							current_surgery.limb_ref.heal_damage(current_surgery.limb_ref.brute_dam - 20)
						if(!surgery)
							break
						if(current_surgery.limb_ref.status & LIMB_SPLINTED_INDESTRUCTIBLE)
							new /obj/item/stack/medical/splint/nano(loc, 1)
						current_surgery.limb_ref.status &= ~(LIMB_SPLINTED|LIMB_SPLINTED_INDESTRUCTIBLE|LIMB_BROKEN)
						current_surgery.limb_ref.perma_injury = 0
						patient.pain.recalculate_pain()
						close_incision(patient,current_surgery.limb_ref)

					if("missing")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Beginning limb replacement.")
						if(current_surgery.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.")
							surgery_todo_list -= current_surgery
							continue

						sleep(SCALPEL_MAX_DURATION*surgery_mod)
						sleep(RETRACTOR_MAX_DURATION*surgery_mod)
						sleep(CAUTERY_MAX_DURATION*surgery_mod)

						if(stored_metal < LIMB_METAL_AMOUNT)
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> croaks: Metal reserves depleted.")
							playsound(src.loc, 'sound/machines/buzz-two.ogg', 15, 1)
							surgery_todo_list -= current_surgery
							continue // next surgery

						stored_metal -= LIMB_METAL_AMOUNT

						if(current_surgery.limb_ref.parent.status & LIMB_DESTROYED) // there's nothing to attach to
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> croaks: Limb attachment failed.")
							playsound(src.loc, 'sound/machines/buzz-two.ogg', 15, 1)
							surgery_todo_list -= current_surgery
							continue

						if(!surgery)
							break
						current_surgery.limb_ref.setAmputatedTree()

						var/spillover = LIMB_PRINTING_TIME - (CAUTERY_MAX_DURATION+RETRACTOR_MAX_DURATION+SCALPEL_MAX_DURATION)
						if(spillover > 0)
							sleep(spillover*surgery_mod)

						sleep(IMPLANT_MAX_DURATION*surgery_mod)
						if(!surgery)
							break
						current_surgery.limb_ref.robotize()
						patient.update_body()
						patient.updatehealth()
						patient.UpdateDamageIcon()

					if("shrapnel")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Beginning shrapnel removal.");
						if(current_surgery.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.");
							surgery_todo_list -= current_surgery
							continue

						open_incision(patient,current_surgery.limb_ref)
						if(current_surgery.limb_ref.name == "chest" || current_surgery.limb_ref.name == "head")
							open_encased(patient,current_surgery.limb_ref)
						if(length(current_surgery.limb_ref.implants))
							for(var/obj/item/implant in current_surgery.limb_ref.implants)
								if(!surgery)
									break
								if(!is_type_in_list(implant,known_implants))
									sleep(REMOVE_OBJECT_MAX_DURATION*surgery_mod)
									current_surgery.limb_ref.implants -= implant
									patient.embedded_items -= implant
									qdel(implant)
						if(current_surgery.limb_ref.name == "chest" || current_surgery.limb_ref.name == "head")
							close_encased(patient,current_surgery.limb_ref)
						if(!surgery)
							break
						close_incision(patient,current_surgery.limb_ref)

					if("open")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b>croaks: Closing surgical incision.");
						close_encased(patient,current_surgery.limb_ref)
						close_incision(patient,current_surgery.limb_ref)
						switch(current_surgery.limb_ref.name)
							if("head")
								patient.overlays -= image('icons/mob/humans/dam_human.dmi', "skull_surgery_closed")
								patient.overlays -= image('icons/mob/humans/dam_human.dmi', "skull_surgery_open")
							if("chest")
								patient.overlays -= image('icons/mob/humans/dam_human.dmi', "chest_surgery_closed")
								patient.overlays -= image('icons/mob/humans/dam_human.dmi', "chest_surgery_open")

		if(prob(30))
			visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> speaks: Procedure complete.");
		surgery_todo_list -= current_surgery
		continue

	while(heal_brute||heal_burn||heal_toxin||filtering||blood_transfer)
		if(!surgery)
			break
		sleep(20)
		if(prob(5))
			visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> beeps as it continues working.");

	patient.pain.recalculate_pain()
	visible_message("[icon2html(src, viewers(src))] \The <b>[src]</b> clicks and opens up having finished the requested operations.")
	SStgui.close_uis(connected)
	go_out()


/obj/structure/machinery/medical_pod/autodoc/proc/open_incision(mob/living/carbon/human/target, obj/limb/limb)
	if(target && limb && target.incision_depths[limb.name] == SURGERY_DEPTH_SURFACE)
		sleep(INCISION_MANAGER_MAX_DURATION*surgery_mod)
		if(!surgery)
			return
		limb.createwound(CUT, 1)
		target.incision_depths[limb.name] = SURGERY_DEPTH_SHALLOW //Can immediately proceed to other surgery steps
		target.updatehealth()

/obj/structure/machinery/medical_pod/autodoc/proc/close_incision(mob/living/carbon/human/target, obj/limb/limb)
	if(target && limb && target.incision_depths[limb.name] == SURGERY_DEPTH_SHALLOW)
		sleep(CAUTERY_MAX_DURATION*surgery_mod)
		if(!surgery)
			return
		limb.reset_limb_surgeries()
		limb.remove_all_bleeding(TRUE)
		target.updatehealth()

/obj/structure/machinery/medical_pod/autodoc/proc/open_encased(mob/living/carbon/human/target, obj/limb/limb)
	if(target && limb && target.incision_depths[limb.name] == SURGERY_DEPTH_SHALLOW)
		sleep((CIRCULAR_SAW_MAX_DURATION*surgery_mod) + (RETRACTOR_MAX_DURATION*surgery_mod))
		if(!surgery)
			return
		target.incision_depths[limb.name] = SURGERY_DEPTH_DEEP

/obj/structure/machinery/medical_pod/autodoc/proc/close_encased(mob/living/carbon/human/target, obj/limb/limb)
	if(target && limb && target.incision_depths[limb.name] == SURGERY_DEPTH_DEEP)
		sleep((RETRACTOR_MAX_DURATION*surgery_mod) + (BONEGEL_REPAIR_MAX_DURATION*surgery_mod))
		if(!surgery)
			return
		target.incision_depths[limb.name] = SURGERY_DEPTH_SHALLOW

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/medical_pod/autodoc/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant) && occupant.stat != DEAD)
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH

/////////////////////////////////////////////////////////////

//Auto Doc console that links up to it.
/obj/structure/machinery/autodoc_console
	name = "autodoc medical system control console"
	desc = "The control interface used to operate the adjoining autodoc. Requires training to use properly."
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "sleeperconsole"
	var/obj/structure/machinery/medical_pod/autodoc/connected = null
	dir = SOUTH
	anchored = TRUE //About time someone fixed this.
	density = FALSE
	unslashable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	/// What kind of upgrade do we have in this console? used by research upgrades. 1 is IB. 2 is bone frac. 3 is organ damage. 4 is larva removal
	var/list/upgrades = list()

/obj/structure/machinery/autodoc_console/Initialize()
	. = ..()
	connect_autodoc()

/obj/structure/machinery/autodoc_console/proc/connect_autodoc()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/medical_pod/autodoc,get_step(src, WEST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/medical_pod/autodoc,get_step(src, EAST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/autodoc_console/Destroy()
	if(connected)
		if(connected.occupant)
			connected.go_out()

		connected.connected = null
		qdel(connected)
		connected = null
	. = ..()


/obj/structure/machinery/autodoc_console/power_change(area/master_area = null)
	..()
	if(stat & NOPOWER)
		if(icon_state != "sleeperconsole-p")
			icon_state = "sleeperconsole-p"
		return
	if(icon_state != "sleeperconsole")
		icon_state = "sleeperconsole"

/obj/structure/machinery/autodoc_console/process()
	updateUsrDialog()

/obj/structure/machinery/autodoc_console/attackby(obj/item/with, mob/user)
	if(istype(with, /obj/item/research_upgrades/autodoc))
		var/obj/item/research_upgrades/autodoc/upgrd = with
		for(var/iter in upgrades)
			if(iter == upgrd.value)
				to_chat(user, SPAN_NOTICE("This data is already present in [src]!"))
				return
		if(!user.drop_inv_item_to_loc(with, src))
			return
		to_chat(user, SPAN_NOTICE("You insert the data into [src] and the drive whirrs to life, reading the data."))
		upgrades += upgrd.value

/obj/structure/machinery/autodoc_console/attack_hand(mob/living/user)
	if(..())
		return

	if(!connected || (connected.inoperable()))
		to_chat(user, "This console seems to be powered down.")
		return

	if(connected.skilllock && !skillcheck(user, SKILL_SURGERY, connected.skilllock))
		to_chat(user, SPAN_WARNING("The interface looks too complicated for you. You're going to need someone trained in the usage of \the [connected.name]!"))
		return

	tgui_interact(user)

/obj/structure/machinery/autodoc_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autodoc", "Autodoc")
		ui.open()

/obj/structure/machinery/autodoc_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/autodoc_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/autodoc_console/ui_data(mob/user)
	. = ..()

	if(!connected)
		.["connected"] = null
		return .

	.["connected"] = connected
	.["connected_operable"] = !connected.inoperable()

	var/mob/living/occupant = connected.occupant

	.["hasOccupant"] = occupant ? 1 : 0
	var/occupantData[0]
	if(occupant)
		occupantData["name"] = occupant.name
		occupantData["stat"] = occupant.stat
		occupantData["health"] = occupant.health
		occupantData["maxHealth"] = occupant.maxHealth
		occupantData["minHealth"] = HEALTH_THRESHOLD_DEAD
		occupantData["bruteLoss"] = occupant.getBruteLoss()
		occupantData["oxyLoss"] = occupant.getOxyLoss()
		occupantData["toxLoss"] = occupant.getToxLoss()
		occupantData["fireLoss"] = occupant.getFireLoss()
		occupantData["hasBlood"] = 0
		occupantData["totalReagents"] = occupant.reagents.total_volume

		// I'm not sure WHY you'd want to put a simple_animal in a sleeper, but precedent is precedent
		if(ishuman(occupant))
			var/mob/living/carbon/human/human_occupant = occupant
			if(!(NO_BLOOD in human_occupant.species.flags))
				occupantData["pulse"] = human_occupant.get_pulse(GETPULSE_TOOL)
				occupantData["hasBlood"] = 1
				occupantData["bloodLevel"] = floor(occupant.blood_volume)
				occupantData["bloodMax"] = occupant.max_blood
				occupantData["bloodPercent"] = round(100*(occupant.blood_volume/occupant.max_blood), 0.01)

	.["occupant"] = occupantData
	.["surgery"] = connected.surgery

	var/list/selected = list()

	selected["brute"] = 0
	selected["burn"] = 0
	selected["open"] = 0
	selected["shrapnel"] = 0
	selected["toxin"] = 0
	selected["dialysis"] = 0
	selected["blood"] = 0

	for(var/iter in upgrades)
		switch(iter)
			if(RESEARCH_UPGRADE_TIER_1)
				selected["internal"] = 0
			if(RESEARCH_UPGRADE_TIER_2)
				selected["broken"] = 0
			if(RESEARCH_UPGRADE_TIER_3)
				selected["organdamage"] = 0
			if(RESEARCH_UPGRADE_TIER_4)
				selected["larva"] = 0

	for(var/datum/autodoc_surgery/item in connected.surgery_todo_list)
		var/type = item.surgery_procedure
		selected[type] = 1

	.["surgeries"] = selected

	.["filtering"] = connected.filtering
	.["blood_transfer"] = connected.blood_transfer
	.["heal_brute"] = connected.heal_brute
	.["heal_burn"] = connected.heal_burn
	.["heal_toxin"] = connected.heal_toxin

	return .

/obj/structure/machinery/autodoc_console/ui_act(action, params)
	if(..())
		return
	if(usr == connected.occupant)
		return
	if(stat & (NOPOWER|BROKEN))
		return

	add_fingerprint(usr)

	. = TRUE
	if(connected.occupant && ishuman(connected.occupant))
		var/needed = 0 // this is to stop someone just choosing everything
		switch(action)
			if("brute")
				connected.surgery_todo_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"brute")
			if("burn")
				connected.surgery_todo_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"burn")
			if("toxin")
				connected.surgery_todo_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"toxin")
			if("dialysis")
				connected.surgery_todo_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"dialysis")
			if("blood")
				connected.surgery_todo_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"blood")
			if("eyes")
				connected.surgery_todo_list += create_autodoc_surgery(null,ORGAN_SURGERY,"eyes",0,connected.occupant.internal_organs_by_name["eyes"])
			if("organdamage")
				for(var/obj/limb/limb in connected.occupant.limbs)
					if(limb)
						for(var/datum/internal_organ/organ in limb.internal_organs)
							if(organ.robotic == ORGAN_ASSISTED || organ.robotic == ORGAN_ROBOT)
								// we can't deal with these
								continue
							if(organ.damage > 0)
								connected.surgery_todo_list += create_autodoc_surgery(limb,ORGAN_SURGERY,"organdamage",0,organ)
								needed++
				if(!needed)
					connected.surgery_todo_list += create_autodoc_surgery(null,ORGAN_SURGERY,"organdamage",1)
			if("larva")
				connected.surgery_todo_list += create_autodoc_surgery("chest",ORGAN_SURGERY,"larva",0)
			if("internal")
				for(var/obj/limb/limb in connected.occupant.limbs)
					if(limb)
						for(var/datum/wound/wound in limb.wounds)
							if(wound.internal)
								connected.surgery_todo_list += create_autodoc_surgery(limb,LIMB_SURGERY,"internal")
								needed++
								break
				if(!needed)
					connected.surgery_todo_list += create_autodoc_surgery(null,LIMB_SURGERY,"internal",1)
			if("broken")
				for(var/obj/limb/limb in connected.occupant.limbs)
					if(limb)
						if(limb.status & LIMB_BROKEN)
							connected.surgery_todo_list += create_autodoc_surgery(limb,LIMB_SURGERY,"broken")
							needed++
				if(!needed)
					connected.surgery_todo_list += create_autodoc_surgery(null,LIMB_SURGERY,"broken",1)
			if("missing")
				for(var/obj/limb/limb in connected.occupant.limbs)
					if(limb)
						if(limb.status & LIMB_DESTROYED)
							if(!(limb.parent.status & LIMB_DESTROYED) && limb.name != "head")
								connected.surgery_todo_list += create_autodoc_surgery(limb,LIMB_SURGERY,"missing")
								needed++
				if(!needed)
					connected.surgery_todo_list += create_autodoc_surgery(null,LIMB_SURGERY,"missing",1)
			if("shrapnel")
				var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)
				for(var/obj/limb/limb in connected.occupant.limbs)
					if(limb)
						if(length(limb.implants))
							for(var/implant in limb.implants)
								if(!is_type_in_list(implant, known_implants))
									connected.surgery_todo_list += create_autodoc_surgery(limb,LIMB_SURGERY,"shrapnel")
									needed++
				if(!needed)
					connected.surgery_todo_list += create_autodoc_surgery(null,LIMB_SURGERY,"shrapnel",1)
			if("open")
				for(var/obj/limb/limb in connected.occupant.limbs)
					if(limb)
						if(connected.occupant.incision_depths[limb.name] != SURGERY_DEPTH_SURFACE)
							connected.surgery_todo_list += create_autodoc_surgery(limb,LIMB_SURGERY,"open")
							needed++
				if(!needed)
					connected.surgery_todo_list += create_autodoc_surgery(null,LIMB_SURGERY,"open",1)
			// The rest
			if("clear")
				connected.surgery_todo_list = list()
			if("surgery")
				if(connected.occupant)
					connected.surgery_op(src.connected.occupant)
			if("ejectify")
				connected.eject()
			else
				return FALSE
	else
		return FALSE

/obj/structure/machinery/autodoc_console/yautja
	name = "medical pod console"
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	upgrades = list(1=1, 2=2, 3=3, 4=4)

/obj/structure/machinery/medical_pod/autodoc/unskilled
	name = "advanced autodoc emergency medical system"
	desc = "A much more expensive model of autodoc modified with an A.I. diagnostic unit. The result is a much simpler, point-and-click interface that anyone, regardless of training, can use. Often employed in autodoc systems deployed to military front lines for soldiers to use."
	skilllock = null

/obj/structure/machinery/medical_pod/autodoc/yautja
	name = "automated medical pod"
	desc = "An emergency surgical alien device designed to perform life-saving treatments and basic surgeries on patients automatically, without the need of a surgeon."
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
