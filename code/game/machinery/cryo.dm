#define HEAT_CAPACITY_HUMAN 100 //249840 J/K, for a 72 kg person.

/obj/structure/machinery/cryo_cell
	name = "cryo cell"
	icon = 'icons/obj/structures/machinery/cryogenics2.dmi'
	icon_state = "cell"
	density = FALSE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	var/temperature = 0
	var/autoeject = FALSE
	var/release_notice = FALSE
	var/on = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 200

	var/mob/living/carbon/occupant = null
	var/obj/item/reagent_container/glass/beaker = null

/obj/structure/machinery/cryo_cell/Initialize()
	. = ..()
	start_processing()

/obj/structure/machinery/cryo_cell/Destroy()
	QDEL_NULL(beaker)
	. = ..()


/obj/structure/machinery/cryo_cell/process()
	if(!on)
		updateUsrDialog()
		return

	if(occupant)
		if(occupant.stat != DEAD)
			process_occupant()
		else
			go_out(TRUE, TRUE) //Whether auto-eject is on or not, we don't permit literal deadbeats to hang around.
			playsound(src.loc, 'sound/machines/ping.ogg', 25, 1)
			visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("\The [src] pings: Patient is dead!")]")

	updateUsrDialog()
	return TRUE

/obj/structure/machinery/cryo_cell/allow_drop()
	return FALSE

/obj/structure/machinery/cryo_cell/relaymove(mob/user)
	if(user.is_mob_incapacitated(TRUE))
		return
	go_out()

/obj/structure/machinery/cryo_cell/attack_hand(mob/user)
	tgui_interact(user)

/obj/structure/machinery/cryo_cell/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_DISABLED
	if(user == occupant)
		return UI_CLOSE //can't use it from inside!


/obj/structure/machinery/cryo_cell/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Cryo", name)
		ui.open()

/obj/structure/machinery/cryo_cell/ui_data(mob/user)
	var/list/data = list()
	data["isOperating"] = on
	data["hasOccupant"] = occupant ? TRUE : FALSE
	data["autoEject"] = autoeject
	data["notify"] = release_notice

	data["occupant"] = list()
	if(occupant)
		var/mob/living/mob_occupant = occupant
		data["occupant"]["name"] = mob_occupant.name
		switch(mob_occupant.stat)
			if(CONSCIOUS)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "good"
			if(UNCONSCIOUS)
				data["occupant"]["stat"] = "Unconscious"
				data["occupant"]["statstate"] = "average"
			if(DEAD)
				data["occupant"]["stat"] = "Dead"
				data["occupant"]["statstate"] = "bad"
		data["occupant"]["health"] = round(mob_occupant.health, 1)
		data["occupant"]["maxHealth"] = mob_occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["occupant"]["bruteLoss"] = round(mob_occupant.getBruteLoss(), 1)
		data["occupant"]["oxyLoss"] = round(mob_occupant.getOxyLoss(), 1)
		data["occupant"]["toxLoss"] = round(mob_occupant.getToxLoss(), 1)
		data["occupant"]["fireLoss"] = round(mob_occupant.getFireLoss(), 1)
		data["occupant"]["bodyTemperature"] = round(mob_occupant.bodytemperature, 1)
		if(mob_occupant.bodytemperature < 255)
			data["occupant"]["temperaturestatus"] = "good"
		else if(mob_occupant.bodytemperature < T0C)
			data["occupant"]["temperaturestatus"] = "average"
		else
			data["occupant"]["temperaturestatus"] = "bad"

	data["cellTemperature"] = round(temperature)

	data["isBeakerLoaded"] = beaker ? TRUE : FALSE
	var/beakerContents = list()
	if(beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents += list(list("name" = R.name, "volume" = R.volume))
	data["beakerContents"] = beakerContents
	return data

/obj/structure/machinery/cryo_cell/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			update_icon()
			. = TRUE
		if("eject")
			if(!occupant)
				return
			go_out()
			. = TRUE
		if("autoeject")
			autoeject = !autoeject
			. = TRUE
		if("ejectbeaker")
			if(beaker)
				beaker.forceMove(get_step(loc, dir))
				if(Adjacent(usr))
					usr.put_in_hands(beaker)
				beaker = null
				. = TRUE
		if("notice")
			release_notice = !release_notice
			. = TRUE
	updateUsrDialog()

/obj/structure/machinery/cryo_cell/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/reagent_container/glass))
		if(beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return

		if(istype(W, /obj/item/reagent_container/glass/bucket))
			to_chat(user, SPAN_WARNING("That's too big to fit!"))
			return

		beaker =  W

		var/reagentnames = ""
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			reagentnames += ";[R.name]"

		msg_admin_niche("[key_name(user)] put \a [beaker] into \the [src], containing [reagentnames] at ([src.loc.x],[src.loc.y],[src.loc.z]) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>).", 1)

		if(user.drop_inv_item_to_loc(W, src))
			user.visible_message("[user] adds \a [W] to \the [src]!", "You add \a [W] to \the [src]!")
	else if(istype(W, /obj/item/grab))
		if(isxeno(user)) return
		var/obj/item/grab/G = W
		if(!ismob(G.grabbed_thing))
			return
		var/mob/M = G.grabbed_thing
		put_mob(M)

	updateUsrDialog()


/obj/structure/machinery/cryo_cell/update_icon()
	icon_state = initial(icon_state)
	icon_state = "[icon_state]-[on ? "on" : "off"]-[occupant ? "occupied" : "empty"]"

/obj/structure/machinery/cryo_cell/proc/process_occupant()
	if(occupant)
		if(occupant.stat == DEAD)
			return
		occupant.bodytemperature += 2*(temperature - occupant.bodytemperature)
		occupant.bodytemperature = max(occupant.bodytemperature, temperature) // this is so ugly i'm sorry for doing it i'll fix it later i promise
		occupant.recalculate_move_delay = TRUE
		occupant.set_stat(UNCONSCIOUS)
		if(occupant.bodytemperature < T0C)
			occupant.Sleeping(10)
			occupant.apply_effect(10, PARALYZE)

			if(occupant.getOxyLoss())
				occupant.apply_damage(-1, OXY)

			//severe damage should heal waaay slower without proper chemicals
			if(occupant.bodytemperature < 225)
				if(occupant.getToxLoss())
					occupant.apply_damage(max(-1, -20/occupant.getToxLoss()), TOX)
				var/heal_brute = occupant.getBruteLoss() ? min(1, 20/occupant.getBruteLoss()) : 0
				var/heal_fire = occupant.getFireLoss() ? min(1, 20/occupant.getFireLoss()) : 0
				occupant.heal_limb_damage(heal_brute,heal_fire)
		var/has_cryo = occupant.reagents.get_reagent_amount("cryoxadone") >= 1
		var/has_clonexa = occupant.reagents.get_reagent_amount("clonexadone") >= 1
		var/has_cryo_medicine = has_cryo || has_clonexa
		if(beaker && !has_cryo_medicine)
			beaker.reagents.trans_to(occupant, 1, 10)
			beaker.reagents.reaction(occupant)
		if(!occupant.getBruteLoss(TRUE) && !occupant.getFireLoss(TRUE) && !occupant.getCloneLoss() && autoeject) //release the patient automatically when brute and burn are handled on non-robotic limbs
			display_message("external wounds are")
			go_out(TRUE)
			return
		if(occupant.health >= 100 && autoeject)
			display_message("external wounds are")
			go_out(TRUE)
			return

/obj/structure/machinery/cryo_cell/proc/go_out(auto_eject = null, dead = null)
	if(!(occupant))
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	switch(dir)
		if(NORTH)
			occupant.forceMove(get_step(loc, NORTH))
		if(EAST)
			occupant.forceMove(get_step(loc, EAST))
		if(WEST)
			occupant.forceMove(get_step(loc, WEST))
		else
			occupant.forceMove(get_step(loc, SOUTH))
	if(occupant.bodytemperature < 261 && occupant.bodytemperature >= 70)
		occupant.bodytemperature = 261
		occupant.recalculate_move_delay = TRUE
	occupant = null
	if(auto_eject) //Turn off and announce if auto-ejected because patient is recovered or dead.
		on = FALSE
		if(release_notice) //If auto-release notices are on as it should be, let the doctors know what's up
			playsound(src.loc, 'sound/machines/ping.ogg', 100, 14)
			var/reason = "Reason for release:</b> Patient recovery."
			if(dead)
				reason = "<b>Reason for release:</b> Patient death."
			ai_silent_announcement("Patient [occupant] has been automatically released from \the [src] at: [get_area(occupant)]. [reason]", MED_FREQ)
	update_use_power(USE_POWER_IDLE)
	update_icon()
	return

/obj/structure/machinery/cryo_cell/proc/put_mob(mob/living/carbon/M as mob)
	if(inoperable())
		to_chat(usr, SPAN_DANGER("The cryo cell is not functioning."))
		return
	if(!istype(M) || isxeno(M))
		to_chat(usr, SPAN_DANGER("<B>The cryo cell cannot handle such a lifeform!</B>"))
		return
	if(occupant)
		to_chat(usr, SPAN_DANGER("<B>The cryo cell is already occupied!</B>"))
		return
	if(M.abiotic())
		to_chat(usr, SPAN_DANGER("Subject may not have abiotic items on."))
		return
	if(do_after(usr, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(usr, SPAN_NOTICE("You move [M.name] inside the cryo cell."))
		M.forceMove(src)
		if(M.health >= -100 && (M.health <= 0 || M.sleeping))
			to_chat(M, SPAN_NOTICE("<b>You feel cold liquid surround you. Your skin starts to freeze up.</b>"))
		occupant = M
		update_use_power(USE_POWER_ACTIVE)
		update_icon()
		return TRUE

/obj/structure/machinery/cryo_cell/proc/display_message(msg)
	playsound(src.loc, 'sound/machines/ping.ogg', 25, 1)
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("\The [src] pings: Patient's " + msg + " healed.")]")

/obj/structure/machinery/cryo_cell/verb/move_eject()
	set name = "Eject occupant"
	set category = "Object"
	set src in oview(1)
	if(usr == occupant)//If the user is inside the tube...
		if(usr.stat == 2)//and he's not dead....
			return

		if(alert(usr, "Would you like to activate the ejection sequence of the cryo cell? Healing may be in progress.", "Confirm", "Yes", "No") == "Yes")
			to_chat(usr, SPAN_NOTICE("Cryo cell release sequence activated. This will take thirty seconds."))
			visible_message(SPAN_WARNING ("The cryo cell's tank starts draining as its ejection lights blare!"))
			sleep(300)
			if(!src || !usr || !occupant || (occupant != usr)) //Check if someone's released/replaced/bombed him already
				return
			go_out()//and release him from the eternal prison.
		else
			if(usr.stat != 0)
				return
			go_out()
	return

/obj/structure/machinery/cryo_cell/verb/move_inside()
	set name = "Move Inside"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != CONSCIOUS)
		return
	put_mob(usr)
	return


//clickdrag code - "resist to get out" code is in living_verbs.dm
/obj/structure/machinery/cryo_cell/MouseDrop_T(mob/target, mob/user)
	. = ..()
	var/mob/living/H = user
	if(!istype(H) || target != user) //cant make others get in. grab-click for this
		return

	put_mob(target)


/datum/data/function/proc/reset()
	return

/datum/data/function/proc/r_input(href, href_list, mob/user as mob)
	return

/datum/data/function/proc/display()
	return
