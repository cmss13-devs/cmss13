//Autodoc
/obj/structure/machinery/autodoc
	name = "\improper autodoc medical system"
	desc = "A fancy machine developed to be capable of operating on people with minimal human intervention. The interface is rather complex and would only be useful to trained Doctors however."
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "autodoc_open"
	density = 1
	anchored = 1
	var/mob/living/carbon/human/occupant = null
	var/list/surgery_todo_list = list() //a list of surgeries to do.
	var/surgery = 0 //Are we operating or no? 0 for no, 1 for yes
	var/surgery_mod = 1 //What multiple to increase the surgery timer? This is used for any non-WO maps or events that are done.
	var/obj/item/reagent_container/blood/OMinus/blood_pack = new()
	var/filtering = 0
	var/blood_transfer = 0
	var/heal_brute = 0
	var/heal_burn = 0
	var/heal_toxin = 0
	var/event = FALSE

	var/obj/structure/machinery/autodoc_console/connected

	//It uses power
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 450 //Capable of doing various activities

	var/stored_metal = 500 // starts with 500 metal loaded


/obj/structure/machinery/autodoc/Initialize()
	. = ..()
	connect_autodoc_console()

/obj/structure/machinery/autodoc/proc/connect_autodoc_console()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/autodoc_console,get_step(src, EAST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/autodoc_console,get_step(src, WEST))
	if(connected)
		connected.connected = src

/obj/structure/machinery/autodoc/Dispose()
	if(occupant)
		occupant.forceMove(loc)
		occupant = null
		stop_processing()
		if(connected)
			connected.stop_processing()
	if(connected)
		connected.connected = null
		qdel(connected)
		connected = null
	. = ..()



/obj/structure/machinery/autodoc/power_change(var/area/master_area = null)
	..()
	if(stat & NOPOWER)
		visible_message("\The [src] engages the safety override, ejecting the occupant.")
		surgery = 0
		go_out()
		return

/obj/structure/machinery/autodoc/proc/heal_limb(var/mob/living/carbon/human/human, var/brute, var/burn)
	var/list/obj/limb/parts = human.get_damaged_limbs(brute,burn)
	if(!parts.len)	return
	var/obj/limb/picked = pick(parts)
	if(LIMB_ROBOT)
		picked.heal_damage(brute, burn, 0, 1)
	else
		picked.heal_damage(brute,burn)
	human.UpdateDamageIcon()
	human.updatehealth()

/obj/structure/machinery/autodoc/process()
	set background = 1

	updateUsrDialog()
	if(occupant)
		if(occupant.stat == DEAD)
			visible_message("[htmlicon(src, viewers(src), viewers(src))] \The <b>[src]</b> speaks: Patient has expired.")
			surgery = 0
			go_out()
			return
		if(surgery)
			// keep them alive
			occupant.adjustToxLoss(-1 * REM) // pretend they get IV dylovene
			occupant.adjustOxyLoss(-occupant.getOxyLoss()) // keep them breathing, pretend they get IV dexplus
			if(filtering)
				var/filtered = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.remove_reagent(x.id, 3) // same as sleeper, may need reducing
					filtered += 3
				if(!filtered)
					filtering = 0
					visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Blood filtering complete.")
				else if(prob(10))
					visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> whirrs and gurgles as the dialysis module operates.")
					to_chat(occupant, SPAN_INFO("You feel slightly better."))
			if(blood_transfer)
				if(occupant.blood_volume < BLOOD_VOLUME_NORMAL)
					if(blood_pack.reagents.get_reagent_amount("blood") < 4)
						blood_pack.reagents.add_reagent("blood", 195, list("viruses"=null,"blood_type"="O-","resistances"=null))
						visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Blood reserves depleted, switching to fresh bag.")
					occupant.inject_blood(blood_pack, 8) // double iv stand rate
					if(prob(10))
						visible_message("\The [src] whirrs and gurgles as it tranfuses blood.")
						to_chat(occupant, SPAN_INFO("You feel slightly less faint."))
				else
					blood_transfer = 0
					visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Blood transfer complete.")
			if(heal_brute)
				if(occupant.getBruteLoss() > 0)
					heal_limb(occupant, 3, 0)
					if(prob(10))
						visible_message("\The [src] whirrs and clicks as it stitches flesh together.")
						to_chat(occupant, SPAN_INFO("You feel your wounds being stitched and sealed shut."))
				else
					heal_brute = 0
					visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Trauma repair surgery complete.")
			if(heal_burn)
				if(occupant.getFireLoss() > 0)
					heal_limb(occupant, 0, 3)
					if(prob(10))
						visible_message("\The [src] whirrs and clicks as it grafts synthetic skin.")
						to_chat(occupant, SPAN_INFO("You feel your burned flesh being sliced away and replaced."))
				else
					heal_burn = 0
					visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Skin grafts complete.")
			if(heal_toxin)
				if(occupant.getToxLoss() > 0)
					occupant.adjustToxLoss(-3)
					if(prob(10))
						visible_message("\The [src] whirrs and gurgles as it kelates the occupant.")
						to_chat(occupant, SPAN_INFO("You feel slighly less ill."))
				else
					heal_toxin = 0
					visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Chelation complete.")


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
	var/datum/autodoc_surgery/A = new()
	A.type_of_surgery = type_of_surgery
	A.surgery_procedure = surgery_procedure
	A.unneeded = unneeded
	A.limb_ref = limb_ref
	A.organ_ref = organ_ref
	return A

/obj/structure/machinery/autodoc/allow_drop()
	return 0

/proc/generate_autodoc_surgery_list(mob/living/carbon/human/M)
	if(!ishuman(M))
		return list()
	var/surgery_list = list()
	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)

	for(var/obj/limb/L in M.limbs)
		if(L)
			for(var/datum/wound/W in L.wounds)
				if(W.internal)
					surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"internal")
					break

			var/organdamagesurgery = 0
			for(var/datum/internal_organ/I in L.internal_organs)
				if(I.robotic == ORGAN_ASSISTED||I.robotic == ORGAN_ROBOT)
					// we can't deal with these
					continue
				if(I.damage > 0)
					if(I.name == "eyeballs") // treat eye surgery differently
						continue
					if(organdamagesurgery > 0) continue // avoid duplicates
					surgery_list += create_autodoc_surgery(L,ORGAN_SURGERY,"damage",0,I)
					organdamagesurgery++

			if(istype(L,/obj/limb/head))
				var/obj/limb/head/H = L
				if(H.disfigured || H.face_surgery_stage > 0)
					surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"facial")

			if(L.status & LIMB_BROKEN)
				surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"broken")
			if(L.status & LIMB_DESTROYED)
				if(!(L.parent.status & LIMB_DESTROYED) && L.name != "head")
					surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"missing")
			if(L.implants.len)
				for(var/I in L.implants)
					if(!is_type_in_list(I,known_implants))
						surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"shrapnel")
			if(L.surgery_open_stage)
				surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"open")
	var/datum/internal_organ/I = M.internal_organs_by_name["eyes"]
	if(I && (M.disabilities & NEARSIGHTED || M.sdisabilities & BLIND || I.damage > 0))
		surgery_list += create_autodoc_surgery(null,ORGAN_SURGERY,"eyes",0,I)
	if(M.getBruteLoss() > 0)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"brute")
	if(M.getFireLoss() > 0)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"burn")
	if(M.getToxLoss() > 0)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"toxin")
	var/overdoses = 0
	for(var/datum/reagent/x in M.reagents.reagent_list)
		if(istype(x,/datum/reagent/toxin)||M.reagents.get_reagent_amount(x.id) > x.overdose)
			overdoses++
	if(overdoses)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"dialysis")
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"blood")
	return surgery_list

/obj/structure/machinery/autodoc/proc/surgery_op(mob/living/carbon/M)
	set background = 1

	if(M.stat == DEAD||!ishuman(M))
		visible_message("\The [src] buzzes.")
		src.go_out() //kick them out too.
		return

	var/mob/living/carbon/human/H = M
	var/datum/data/record/N = null
	for(var/datum/data/record/R in data_core.medical)
		if (R.fields["name"] == H.real_name)
			N = R
	if(isnull(N))
		visible_message("\The [src] buzzes: No records found for occupant.")
		src.go_out() //kick them out too.
		return

	var/list/surgery_todo_list = N.fields["autodoc_manual"]

	if(!surgery_todo_list.len)
		visible_message("\The [src] buzzes, no surgical procedures were queued.")
		return

	visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> begins to operate, loud audible clicks lock the pod.")
	surgery = 1
	icon_state = "autodoc_operate"

	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)

	for(var/datum/autodoc_surgery/A in surgery_todo_list)
		if(A.type_of_surgery == EXTERNAL_SURGERY)
			switch(A.surgery_procedure)
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
			surgery_todo_list -= A

	var/currentsurgery = 1
	while(surgery_todo_list.len > 0)
		if(!surgery)
			break;
		sleep(-1)
		var/datum/autodoc_surgery/S = surgery_todo_list[currentsurgery]
		surgery_mod = 1 // might need tweaking

		switch(S.type_of_surgery)
			if(ORGAN_SURGERY)
				switch(S.surgery_procedure)
					if("damage")
						if(prob(30)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Beginning organ restoration.");
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.");
							surgery_todo_list -= S
							continue
						open_incision(H,S.limb_ref)

						if(S.limb_ref.name != "groin")
							open_encased(H,S.limb_ref)

						if(!istype(S.organ_ref,/datum/internal_organ/brain))
							sleep(FIX_ORGAN_MAX_DURATION*surgery_mod)
						else
							if(S.organ_ref.damage > BONECHIPS_MAX_DAMAGE)
								sleep(FIXVEIN_MAX_DURATION*surgery_mod)
							sleep(REMOVE_OBJECT_MAX_DURATION*surgery_mod)
						if(!surgery) break
						if(istype(S.organ_ref,/datum/internal_organ))
							S.organ_ref.rejuvenate()
						else
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Organ is missing.");

						// close them
						if(S.limb_ref.name != "groin") // TODO: fix brute damage before closing
							close_encased(H,S.limb_ref)
						close_incision(H,S.limb_ref)

					if("eyes")
						if(prob(30)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Beginning corrective eye surgery.");
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.");
							surgery_todo_list -= S
							continue
						if(istype(S.organ_ref,/datum/internal_organ/eyes))
							var/datum/internal_organ/eyes/E = S.organ_ref

							if(E.eye_surgery_stage == 0)
								sleep(SCALPEL_MAX_DURATION)
								if(!surgery) break
								E.eye_surgery_stage = 1
								H.disabilities |= NEARSIGHTED // code\#define\mobs.dm

							if(E.eye_surgery_stage == 1)
								sleep(RETRACTOR_MAX_DURATION)
								if(!surgery) break
								E.eye_surgery_stage = 2

							if(E.eye_surgery_stage == 2)
								sleep(HEMOSTAT_MAX_DURATION)
								if(!surgery) break
								E.eye_surgery_stage = 3

							if(E.eye_surgery_stage == 3)
								sleep(CAUTERY_MAX_DURATION)
								if(!surgery) break
								H.disabilities &= ~NEARSIGHTED
								H.sdisabilities &= ~BLIND
								E.damage = 0
								E.eye_surgery_stage = 0


			if(LIMB_SURGERY)
				switch(S.surgery_procedure)
					if("internal")
						if(prob(30)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Beginning internal bleeding procedure.");
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.");
							surgery_todo_list -= S
							continue
						open_incision(H,S.limb_ref)
						for(var/datum/wound/W in S.limb_ref.wounds)
							if(!surgery) break
							if(W.internal)
								sleep(FIXVEIN_MAX_DURATION*surgery_mod)
								S.limb_ref.wounds -= W
								S.limb_ref.remove_all_bleeding(FALSE, TRUE)
								qdel(W)
						if(!surgery) break
						close_incision(H,S.limb_ref)

					if("broken")
						if(prob(30)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Beginning broken bone procedure.");
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.");
							surgery_todo_list -= S
							continue
						open_incision(H,S.limb_ref)
						sleep(BONEGEL_REPAIR_MAX_DURATION*surgery_mod)
						sleep(BONESETTER_MAX_DURATION*surgery_mod)
						if(S.limb_ref.brute_dam > 20)
							sleep(((S.limb_ref.brute_dam - 20)/2)*surgery_mod)
							if(!surgery) break
							S.limb_ref.heal_damage(S.limb_ref.brute_dam - 20,0)
						if(!surgery) break
						S.limb_ref.status &= ~LIMB_BROKEN
						S.limb_ref.status &= ~LIMB_SPLINTED
						S.limb_ref.status |= LIMB_REPAIRED
						S.limb_ref.perma_injury = 0
						close_incision(H,S.limb_ref)

					if("missing")
						if(prob(30)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Beginning limb replacement.");
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.");
							surgery_todo_list -= S
							continue

						sleep(SCALPEL_MAX_DURATION*surgery_mod)
						sleep(RETRACTOR_MAX_DURATION*surgery_mod)
						sleep(CAUTERY_MAX_DURATION*surgery_mod)

						if(stored_metal < LIMB_METAL_AMOUNT)
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> croaks: Metal reserves depleted.")
							playsound(src.loc, 'sound/machines/buzz-two.ogg', 15, 1)
							surgery_todo_list -= S
							continue // next surgery

						stored_metal -= LIMB_METAL_AMOUNT

						if(S.limb_ref.parent.status & LIMB_DESTROYED) // there's nothing to attach to
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> croaks: Limb attachment failed.")
							playsound(src.loc, 'sound/machines/buzz-two.ogg', 15, 1)
							surgery_todo_list -= S
							continue

						if(!surgery) break
						S.limb_ref.status |= LIMB_AMPUTATED
						S.limb_ref.setAmputatedTree()
						S.limb_ref.limb_replacement_stage = 0

						var/spillover = LIMB_PRINTING_TIME - (CAUTERY_MAX_DURATION+RETRACTOR_MAX_DURATION+SCALPEL_MAX_DURATION)
						if(spillover > 0)
							sleep(spillover*surgery_mod)

						sleep(IMPLANT_MAX_DURATION*surgery_mod)
						if(!surgery) break
						S.limb_ref.robotize()
						H.update_body()
						H.updatehealth()
						H.UpdateDamageIcon()

					if("shrapnel")
						if(prob(30)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Beginning shrapnel removal.");
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.");
							surgery_todo_list -= S
							continue

						open_incision(H,S.limb_ref)
						if(S.limb_ref.name == "chest" || S.limb_ref.name == "head")
							open_encased(H,S.limb_ref)
						if(S.limb_ref.implants.len)
							for(var/obj/item/I in S.limb_ref.implants)
								if(!surgery) break
								if(!is_type_in_list(I,known_implants))
									sleep(REMOVE_OBJECT_MAX_DURATION*surgery_mod)
									S.limb_ref.implants -= I
									H.embedded_items -= I
									qdel(I)
						if(S.limb_ref.name == "chest" || S.limb_ref.name == "head")
							close_encased(H,S.limb_ref)
						if(!surgery) break
						close_incision(H,S.limb_ref)

					if("facial") // dumb but covers for incomplete facial surgery
						if(prob(30)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Beginning Facial Reconstruction Surgery.");
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Procedure has been deemed unnecessary.");
							surgery_todo_list -= S
							continue
						if(istype(S.limb_ref,/obj/limb/head))
							var/obj/limb/head/F = S.limb_ref
							if(F.face_surgery_stage == 0)
								sleep(SCALPEL_MAX_DURATION)
								if(!surgery) break
								F.face_surgery_stage = 1
							if(F.face_surgery_stage == 1)
								sleep(HEMOSTAT_MAX_DURATION)
								if(!surgery) break
								F.face_surgery_stage = 2
							if(F.face_surgery_stage == 2)
								sleep(RETRACTOR_MAX_DURATION)
								if(!surgery) break
								F.face_surgery_stage = 3
							if(F.face_surgery_stage == 3)
								sleep(CAUTERY_MAX_DURATION)
								if(!surgery) break
								F.remove_all_bleeding(TRUE)
								F.disfigured = 0
								F.owner.name = F.owner.get_visible_name()
								F.face_surgery_stage = 0

					if("open")
						if(prob(30)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b>croaks: Closing surgical incision.");
						close_encased(H,S.limb_ref)
						close_incision(H,S.limb_ref)

		if(prob(30)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> speaks: Procedure complete.");
		surgery_todo_list -= S
		continue

	while(heal_brute||heal_burn||heal_toxin||filtering||blood_transfer)
		if(!surgery) break
		sleep(20)
		if(prob(5)) visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> beeps as it continues working.");

	visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> clicks and opens up having finished the requested operations.")
	surgery = 0
	go_out()


/obj/structure/machinery/autodoc/proc/open_incision(mob/living/carbon/human/target, var/obj/limb/L)
	if(target && L && L.surgery_open_stage < 2)
		sleep(INCISION_MANAGER_MAX_DURATION*surgery_mod)
		if(!surgery) return
		L.createwound(CUT, 1)
		L.clamp_wounds() //Hemostat function, clamp bleeders
		L.surgery_open_stage = 2 //Can immediately proceed to other surgery steps
		target.updatehealth()

/obj/structure/machinery/autodoc/proc/close_incision(mob/living/carbon/human/target, var/obj/limb/L)
	if(target && L && 0 < L.surgery_open_stage <= 2)
		sleep(CAUTERY_MAX_DURATION*surgery_mod)
		if(!surgery) return
		L.surgery_open_stage = 0
		L.remove_all_bleeding(TRUE)
		target.updatehealth()

/obj/structure/machinery/autodoc/proc/open_encased(mob/living/carbon/human/target, var/obj/limb/L)
	if(target && L && L.surgery_open_stage >= 2)
		if(L.surgery_open_stage == 2) // this will cover for half completed surgeries
			sleep(CIRCULAR_SAW_MAX_DURATION*surgery_mod)
			if(!surgery) return
			L.surgery_open_stage = 2.5
		if(L.surgery_open_stage == 2.5)
			sleep(RETRACTOR_MAX_DURATION*surgery_mod)
			if(!surgery) return
			L.surgery_open_stage = 3

/obj/structure/machinery/autodoc/proc/close_encased(mob/living/carbon/human/target, var/obj/limb/L)
	if(target && L && L.surgery_open_stage > 2)
		if(L.surgery_open_stage == 3) // this will cover for half completed surgeries
			sleep(RETRACTOR_MAX_DURATION*surgery_mod)
			if(!surgery) return
			L.surgery_open_stage = 2.5
		if(L.surgery_open_stage == 2.5)
			sleep(BONEGEL_REPAIR_MAX_DURATION*surgery_mod)
			if(!surgery) return
			L.surgery_open_stage = 2

/obj/structure/machinery/autodoc/verb/eject()
	set name = "Eject Med-Pod"
	set category = "Object"
	set src in oview(1)
	if(usr.stat == DEAD)
		return // nooooooooooo
	if(occupant)
		if(isXeno(usr)) // let xenos eject people hiding inside.
			message_staff("[key_name(usr)] ejected [key_name(occupant)] from the autodoc.")
			go_out()
			add_fingerprint(usr)
			return
		if(!ishuman(usr))
			return
		if(usr == occupant)
			if(surgery)
				to_chat(usr, SPAN_WARNING("There's no way you're getting out while this thing is operating on you!"))
			else
				visible_message("[usr] engages the internal release mechanism, and climbs out of \the [src].")
			return
		if(!skillcheck(usr, SKILL_SURGERY, SKILL_SURGERY_BEGINNER))
			to_chat(usr, SPAN_WARNING("You don't have the training to use this."))
			return
		if(surgery)
			visible_message("[htmlicon(src, viewers(src))] \The <b>[src]</b> malfunctions as [usr] aborts the surgery in progress.")
			occupant.take_limb_damage(rand(30,50),rand(30,50))
			surgery = 0
			// message_staff for now, may change to message_admins later
			message_staff("[key_name(usr)] ejected [key_name(occupant)] from the autodoc during surgery causing damage.")
		go_out()
		add_fingerprint(usr)

/obj/structure/machinery/autodoc/verb/move_inside()
	set name = "Enter Autodoc"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0 || !ishuman(usr)) return

	if(occupant)
		to_chat(usr, SPAN_NOTICE("\The [src] is already occupied!"))
		return

	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, SPAN_NOTICE("\The [src] is non-functional!"))
		return

	if(!skillcheck(usr, SKILL_SURGERY, SKILL_SURGERY_BEGINNER) && !event)
		to_chat(usr, SPAN_WARNING("You're going to need someone trained in the use of \the [src] to help you get into it."))
		return

	usr.visible_message(SPAN_NOTICE("[usr] starts climbing into \the [src]."),
	SPAN_NOTICE("You start climbing into \the [src]."))
	if(do_after(usr, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		if(occupant)
			to_chat(usr, SPAN_NOTICE("\The [src] is already occupied!"))
			return
		go_in_autodoc(usr)
		add_fingerprint(usr)

/obj/structure/machinery/autodoc/proc/go_in_autodoc(mob/M)
	M.forceMove(src)
	update_use_power(2)
	occupant = M
	icon_state = "autodoc_closed"
	start_processing()
	if(connected)
		connected.start_processing()
	//prevents occupant's belonging from landing inside the machine
	for(var/obj/O in src)
		O.loc = loc



/obj/structure/machinery/autodoc/proc/go_out()
	if(!occupant) return
	occupant.forceMove(loc)
	occupant.update_med_icon()
	occupant = null
	surgery_todo_list = list()
	update_use_power(1)
	icon_state = "autodoc_open"
	stop_processing()
	if(connected)
		connected.stop_processing()
		connected.process() // one last update


/obj/structure/machinery/autodoc/attackby(obj/item/W, mob/living/user)
	if(!ishuman(user))
		return // no
	if(istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = W
		to_chat(user, SPAN_NOTICE("\The [src] processes \the [W]."))
		stored_metal += M.amount * 100
		user.drop_held_item()
		qdel(W)
		return
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(!ishuman(G.grabbed_thing)) // stop fucking monkeys and xenos being put in.
			return
		var/mob/M = G.grabbed_thing
		if(src.occupant)
			to_chat(user, SPAN_NOTICE("\The [src] is already occupied!"))
			return

		if(stat & (NOPOWER|BROKEN))
			to_chat(user, SPAN_NOTICE("\The [src] is non-functional!"))
			return

		if(!skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_BEGINNER) && !event)
			to_chat(user, SPAN_WARNING("You have no idea how to put someone into \the [src]!"))
			return

		visible_message(SPAN_NOTICE("[user] starts putting [M] into [src]."), null, null, 3)

		if(do_after(user, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			if(src.occupant)
				to_chat(user, SPAN_NOTICE("\The [src] is already occupied!"))
				return
			if(!G || !G.grabbed_thing) return
			go_in_autodoc(M)

			add_fingerprint(user)

/////////////////////////////////////////////////////////////

//Auto Doc console that links up to it.
/obj/structure/machinery/autodoc_console
	name = "\improper autodoc medical system control console"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "sleeperconsole"
	var/obj/structure/machinery/autodoc/connected = null
	dir = 2
	anchored = 1 //About time someone fixed this.
	density = 0

	use_power = 1
	idle_power_usage = 40

/obj/structure/machinery/autodoc_console/Initialize()
	. = ..()
	connect_autodoc()

/obj/structure/machinery/autodoc_console/proc/connect_autodoc()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/autodoc,get_step(src, WEST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/autodoc,get_step(src, EAST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/autodoc_console/Dispose()
	if(connected)
		if(connected.occupant)
			connected.go_out()

		connected.connected = null
		qdel(connected)
		connected = null
	. = ..()


/obj/structure/machinery/autodoc_console/power_change(var/area/master_area = null)
	..()
	if(stat & NOPOWER)
		if(icon_state != "sleeperconsole-p")
			icon_state = "sleeperconsole-p"
		return
	if(icon_state != "sleeperconsole")
		icon_state = "sleeperconsole"

/obj/structure/machinery/autodoc_console/process()
	updateUsrDialog()

/obj/structure/machinery/autodoc_console/attack_hand(mob/living/user)
	if(..())
		return
	var/dat = ""
	if(!connected || (connected.stat & (NOPOWER|BROKEN)))
		dat += "This console is not connected to a Med-Pod or the Med-Pod is non-functional."
		to_chat(user, "This console seems to be powered down.")
	else
		if(!skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_BEGINNER) && !connected.event)
			to_chat(user, SPAN_WARNING("You have no idea how to use this."))
			return
		var/mob/living/occupant = connected.occupant
		dat += "<B>Overall Status:</B><BR>"
		if(occupant)
			var/t1
			switch(occupant.stat)
				if(0)	t1 = "conscious"
				if(1)	t1 = "<font color='blue'>unconscious</font>"
				if(2)	t1 = "<font color='red'><b>dead</b></font>"
			var/operating
			switch(connected.surgery)
				if(0) operating = "Med-Pod: STANDING BY"
				if(1) operating = "Med-Pod: IN SURGERY: DO NOT MANUALLY EJECT"
			var/damageOxy = occupant.getOxyLoss() > 50 ? "<b>[occupant.getOxyLoss()]</b>" : occupant.getOxyLoss()
			var/damageTox = occupant.getToxLoss() > 50 ? "<b>[occupant.getToxLoss()]</b>" : occupant.getToxLoss()
			var/damageFire = occupant.getFireLoss() > 50 ? "<b>[occupant.getFireLoss()]</b>" : occupant.getFireLoss()
			var/damageBrute = occupant.getBruteLoss() > 50 ? "<b>[occupant.getBruteLoss()]</b>" : occupant.getBruteLoss()
			dat += "Name: [occupant.name]<br>"
			dat += "Damage: [SET_CLASS("[damageOxy]", INTERFACE_BLUE)] - [SET_CLASS("[damageTox]", INTERFACE_GREEN)] - [SET_CLASS("[damageFire]", INTERFACE_ORANGE)] - [SET_CLASS("[damageBrute]", INTERFACE_RED)]<br>"
			dat += "The patient is [t1]. <br>"
			dat += "[operating]<br>"
			dat += "<a href='?src=\ref[src];ejectify=1'>Eject Patient</a>"
			dat += "<hr><b>Surgery Queue:</b><br>"

			var/list/surgeryqueue = list()
			var/datum/data/record/N = null
			for(var/datum/data/record/R in data_core.medical)
				if (R.fields["name"] == connected.occupant.real_name)
					N = R
			if(isnull(N))
				N = create_medical_record(connected.occupant)

			if(!isnull(N.fields["autodoc_manual"]))
				for(var/datum/autodoc_surgery/A in N.fields["autodoc_manual"])
					switch(A.type_of_surgery)
						if(EXTERNAL_SURGERY)
							switch(A.surgery_procedure)
								if("brute")
									surgeryqueue["brute"] = 1
									dat += "Brute Damage Treatment"
								if("burn")
									surgeryqueue["burn"] = 1
									dat += "Burn Damage Treatment"
								if("toxin")
									surgeryqueue["toxin"] = 1
									dat += "Toxin Damage Chelation"
								if("dialysis")
									surgeryqueue["dialysis"] = 1
									dat += "Dialysis"
								if("blood")
									surgeryqueue["blood"] = 1
									dat += "Blood Transfer"
						if(ORGAN_SURGERY)
							switch(A.surgery_procedure)
								if("damage")
									surgeryqueue["organdamage"] = 1
									dat += "Organ Damage Treatment"
								if("eyes")
									surgeryqueue["eyes"] = 1
									dat += "Corrective Eye Surgery"
						if(LIMB_SURGERY)
							switch(A.surgery_procedure)
								if("internal")
									surgeryqueue["internal"] = 1
									dat += "Internal Bleeding Surgery"
								if("broken")
									surgeryqueue["broken"] = 1
									dat += "Broken Bone Surgery"
								if("missing")
									surgeryqueue["missing"] = 1
									dat += "Limb Replacement Surgery"
								if("shrapnel")
									surgeryqueue["shrapnel"] = 1
									dat += "Shrapnel Removal Surgery"
								if("facial")
									surgeryqueue["facial"] = 1
									dat += "Facial Reconstruction Surgery"
								if("open")
									surgeryqueue["open"] = 1
									dat += "Close Open Incision"
					dat += "<br>"

			dat += "<hr><a href='?src=\ref[src];surgery=1'>Begin Surgery</a> - <a href='?src=\ref[src];refresh=1'>Refresh Menu</a> - <a href='?src=\ref[src];clear=1'>Clear Queue</a><hr>"
			if(!connected.surgery)
				dat += "<b>Trauma Surgeries</b>"
				dat += "<br>"
				if(isnull(surgeryqueue["brute"]))
					dat += "<a href='?src=\ref[src];brute=1'>Brute Damage Treatment</a><br>"
				if(isnull(surgeryqueue["burn"]))
					dat += "<a href='?src=\ref[src];burn=1'>Burn Damage Treatment</a><br>"
				dat += "<b>Orthopedic Surgeries</b>"
				dat += "<br>"
				if(isnull(surgeryqueue["broken"]))
					dat += "<a href='?src=\ref[src];broken=1'>Broken Bone Surgery</a><br>"
				if(isnull(surgeryqueue["internal"]))
					dat += "<a href='?src=\ref[src];internal=1'>Internal Bleeding Surgery</a><br>"
				if(isnull(surgeryqueue["shrapnel"]))
					dat += "<a href='?src=\ref[src];shrapnel=1'>Shrapnel Removal Surgery</a><br>"
				dat += "<b>Organ Surgeries</b>"
				dat += "<br>"
				if(isnull(surgeryqueue["eyes"]))
					dat += "<a href='?src=\ref[src];eyes=1'>Corrective Eye Surgery</a><br>"
				if(isnull(surgeryqueue["organdamage"]))
					dat += "<a href='?src=\ref[src];organdamage=1'>Organ Damage Treatment</a><br>"
				dat += "<b>Hematology Treatments</b>"
				dat += "<br>"
				if(isnull(surgeryqueue["blood"]))
					dat += "<a href='?src=\ref[src];blood=1'>Blood Transfer</a><br>"
				if(isnull(surgeryqueue["dialysis"]))
					dat += "<a href='?src=\ref[src];dialysis=1'>Dialysis</a><br>"
				if(isnull(surgeryqueue["toxin"]))
					dat += "<a href='?src=\ref[src];toxin=1'>Toxin Damage Chelation</a><br>"
				dat += "<b>Special Surgeries</b>"
				dat += "<br>"
				if(isnull(surgeryqueue["open"]))
					dat += "<a href='?src=\ref[src];open=1'>Close Open Incision</a><br>"
				if(isnull(surgeryqueue["facial"]))
					dat += "<a href='?src=\ref[src];facial=1'>Facial Reconstruction Surgery</a><br>"
				if(isnull(surgeryqueue["missing"]))
					dat += "<a href='?src=\ref[src];missing=1'>Limb Replacement Surgery</a><hr>"
		else
			dat += "The Med-Pod is empty."
	dat += text("<a href='?src=\ref[];mach_close=sleeper'>Close</a>", user)
	show_browser(user, dat, "Autodoc Medical System", "sleeper", "size=300x400")
	onclose(user, "sleeper")

/obj/structure/machinery/autodoc_console/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))))
		usr.set_interaction(src)

		if(connected.occupant && ishuman(connected.occupant))
			// manual surgery handling
			var/datum/data/record/N = null
			for(var/datum/data/record/R in data_core.medical)
				if (R.fields["name"] == connected.occupant.real_name)
					N = R
			if(isnull(N))
				N = create_medical_record(connected.occupant)

			var/needed = 0 // this is to stop someone just choosing everything
			if(href_list["brute"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"brute")
				updateUsrDialog()
			if(href_list["burn"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"burn")
				updateUsrDialog()
			if(href_list["toxin"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"toxin")
				updateUsrDialog()
			if(href_list["dialysis"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"dialysis")
				updateUsrDialog()
			if(href_list["blood"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"blood")
				updateUsrDialog()
			if(href_list["eyes"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,ORGAN_SURGERY,"eyes",0,connected.occupant.internal_organs_by_name["eyes"])
				updateUsrDialog()
			if(href_list["organdamage"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						for(var/datum/internal_organ/I in L.internal_organs)
							if(I.robotic == ORGAN_ASSISTED||I.robotic == ORGAN_ROBOT)
								// we can't deal with these
								continue
							if(I.damage > 0)
								N.fields["autodoc_manual"] += create_autodoc_surgery(L,ORGAN_SURGERY,"damage",0,I)
								needed++
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,ORGAN_SURGERY,"damage",1)
				updateUsrDialog()

			if(href_list["internal"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						for(var/datum/wound/W in L.wounds)
							if(W.internal)
								N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"internal")
								needed++
								break
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"internal",1)
				updateUsrDialog()

			if(href_list["broken"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						if(L.status & LIMB_BROKEN)
							N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"broken")
							needed++
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"broken",1)
				updateUsrDialog()

			if(href_list["missing"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						if(L.status & LIMB_DESTROYED)
							if(!(L.parent.status & LIMB_DESTROYED) && L.name != "head")
								N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"missing")
								needed++
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"missing",1)
				updateUsrDialog()

			if(href_list["shrapnel"])
				var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						if(L.implants.len)
							for(var/I in L.implants)
								if(!is_type_in_list(I,known_implants))
									N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"shrapnel")
									needed++
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"shrapnel",1)
				updateUsrDialog()

			if(href_list["facial"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						if(istype(L,/obj/limb/head))
							var/obj/limb/head/J = L
							if(J.disfigured || J.face_surgery_stage)
								N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"facial")
							else
								N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"facial",1)
							updateUsrDialog()
							break

			if(href_list["open"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						if(L.surgery_open_stage)
							N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"open")
							needed++
				if(href_list["open"])
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"open",1)
				updateUsrDialog()

			// The rest
			if(href_list["clear"])
				N.fields["autodoc_manual"] = list()
				updateUsrDialog()
		if(href_list["refresh"])
			updateUsrDialog()
		if(href_list["surgery"])
			if(connected.occupant)
				connected.surgery_op(src.connected.occupant)
			updateUsrDialog()
		if(href_list["ejectify"])
			connected.eject()
			updateUsrDialog()
		add_fingerprint(usr)

/obj/structure/machinery/autodoc/event
	event = TRUE
