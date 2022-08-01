#define HEAT_CAPACITY_HUMAN 100 //249840 J/K, for a 72 kg person.

/obj/structure/machinery/cryo_cell
	name = "cryo cell"
	icon = 'icons/obj/structures/machinery/cryogenics2.dmi'
	icon_state = "cell-off"
	density = 0
	anchored = 1.0
	layer = BELOW_OBJ_LAYER

	var/temperature = 0

	var/on = 0
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 200

	var/mob/living/carbon/occupant = null
	var/obj/item/reagent_container/glass/beaker = null

/obj/structure/machinery/cryo_cell/Initialize()
	. = ..()
	start_processing()

/obj/structure/machinery/cryo_cell/process()
	if(!on)
		updateUsrDialog()
		return

	if(occupant)
		if(occupant.stat != DEAD)
			process_occupant()
		else
			go_out()

	updateUsrDialog()
	return 1

/obj/structure/machinery/cryo_cell/allow_drop()
	return 0

/obj/structure/machinery/cryo_cell/cryo_cell/relaymove(mob/user)
	if(user.is_mob_incapacitated(TRUE))
		return
	go_out()

/obj/structure/machinery/cryo_cell/attack_hand(mob/user)
	ui_interact(user)

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable (which is inherited by /obj and /mob)
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  * @param ui /datum/nanoui This parameter is passed by the nanoui process() proc when updating an open ui
  *
  * @return nothing
  */
/obj/structure/machinery/cryo_cell/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(user == occupant || user.stat)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["isOperating"] = on
	data["hasOccupant"] = occupant ? 1 : 0

	var/occupantData[0]
	if (occupant)
		occupantData["name"] = occupant.name
		occupantData["stat"] = occupant.stat
		occupantData["health"] = occupant.health
		occupantData["maxHealth"] = occupant.maxHealth
		occupantData["minHealth"] = HEALTH_THRESHOLD_DEAD
		occupantData["bruteLoss"] = occupant.getBruteLoss()
		occupantData["oxyLoss"] = occupant.getOxyLoss()
		occupantData["toxLoss"] = occupant.getToxLoss()
		occupantData["fireLoss"] = occupant.getFireLoss()
		occupantData["bodyTemperature"] = occupant.bodytemperature
	data["occupant"] = occupantData;

	data["cellTemperature"] = round(temperature)
	data["cellTemperatureStatus"] = "good"
	if(temperature > T0C) // if greater than 273.15 kelvin (0 celcius)
		data["cellTemperatureStatus"] = "bad"
	else if(temperature > 225)
		data["cellTemperatureStatus"] = "average"

	data["isBeakerLoaded"] = beaker ? 1 : 0

	data["beakerLabel"] = null
	data["beakerVolume"] = 0
	if(beaker)
		data["beakerLabel"] = beaker.label_text ? beaker.label_text : null
		if (beaker.reagents && beaker.reagents.reagent_list.len)
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				data["beakerVolume"] += R.volume

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "cryo.tmpl", "Cryo Cell Control System", 520, 410)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/structure/machinery/cryo_cell/Topic(href, href_list)
	if(usr == occupant)
		return 0 // don't update UIs attached to this object

	if(..())
		return 0 // don't update UIs attached to this object

	if(href_list["switchOn"])
		on = 1
		update_icon()

	if(href_list["switchOff"])
		on = 0
		update_icon()

	if(href_list["ejectBeaker"])
		if(beaker)
			beaker.forceMove(get_step(loc, SOUTH))
			beaker = null

	if(href_list["ejectOccupant"])
		if(!occupant)
			return // don't update UIs attached to this object
		go_out()

	return 1 // update UIs attached to this object

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

		msg_admin_niche("[key_name(user)] put a [beaker] into [src], containing [reagentnames] at ([src.loc.x],[src.loc.y],[src.loc.z]) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>).", 1)

		if(user.drop_inv_item_to_loc(W, src))
			user.visible_message("[user] adds \a [W] to \the [src]!", "You add \a [W] to \the [src]!")
	else if(istype(W, /obj/item/grab))
		if(isXeno(user)) return
		var/obj/item/grab/G = W
		if(!ismob(G.grabbed_thing))
			return
		var/mob/M = G.grabbed_thing
		put_mob(M)

	updateUsrDialog()


/obj/structure/machinery/cryo_cell/update_icon()
	if(on)
		if(occupant)
			icon_state = "cell-occupied"
			return
		icon_state = "cell-on"
		return
	icon_state = "cell-off"

/obj/structure/machinery/cryo_cell/proc/process_occupant()
	if(occupant)
		if(occupant.stat == DEAD)
			return
		occupant.bodytemperature += 2*(temperature - occupant.bodytemperature)
		occupant.bodytemperature = max(occupant.bodytemperature, temperature) // this is so ugly i'm sorry for doing it i'll fix it later i promise
		occupant.recalculate_move_delay = TRUE
		occupant.stat = 1
		if(occupant.bodytemperature < T0C)
			occupant.Sleeping(10)
			occupant.KnockOut(10)

			if(occupant.getOxyLoss())
				occupant.apply_damage(-1, OXY)

			//severe damage should heal waaay slower without proper chemicals
			if(occupant.bodytemperature < 225)
				if (occupant.getToxLoss())
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
		if(occupant.health >= 100)
			display_message("external wounds are")
			go_out()

/obj/structure/machinery/cryo_cell/proc/go_out()
	if(!( occupant ))
		return
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	switch(dir)
		if(1)
			occupant.forceMove(get_step(loc, NORTH))
		if(4)
			occupant.forceMove(get_step(loc, EAST))
		if(8)
			occupant.forceMove(get_step(loc, WEST))
		else
			occupant.forceMove(get_step(loc, SOUTH))
	if (occupant.bodytemperature < 261 && occupant.bodytemperature >= 70)
		occupant.bodytemperature = 261
		occupant.recalculate_move_delay = TRUE
	occupant = null
	update_use_power(1)
	update_icon()
	return

/obj/structure/machinery/cryo_cell/proc/put_mob(mob/living/carbon/M as mob)
	if (inoperable())
		to_chat(usr, SPAN_DANGER("The cryo cell is not functioning."))
		return
	if (!istype(M) || isXeno(M))
		to_chat(usr, SPAN_DANGER("<B>The cryo cell cannot handle such a lifeform!</B>"))
		return
	if (occupant)
		to_chat(usr, SPAN_DANGER("<B>The cryo cell is already occupied!</B>"))
		return
	if (M.abiotic())
		to_chat(usr, SPAN_DANGER("Subject may not have abiotic items on."))
		return
	if(do_after(usr, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(usr, SPAN_NOTICE("You move [M.name] inside the cryo cell."))
		M.forceMove(src)
		if(M.health >= -100 && (M.health <= 0 || M.sleeping))
			to_chat(M, SPAN_NOTICE(" <b>You feel cold liquid surround you. Your skin starts to freeze up.</b>"))
		occupant = M
		update_use_power(2)
		update_icon()
		return 1

/obj/structure/machinery/cryo_cell/proc/display_message(msg)
	playsound(src.loc, 'sound/machines/ping.ogg', 25, 1)
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("\The [src] pings: Patient's " + msg + " healed.")]")

/obj/structure/machinery/cryo_cell/verb/move_eject()
	set name = "Eject occupant"
	set category = "Object"
	set src in oview(1)
	if(usr == occupant)//If the user is inside the tube...
		if (usr.stat == 2)//and he's not dead....
			return

		if (alert(usr, "Would you like to activate the ejection sequence of the cryo cell? Healing may be in progress.", "Confirm", "Yes", "No") == "Yes")
			to_chat(usr, SPAN_NOTICE("Cryo cell release sequence activated. This will take thirty seconds."))
			visible_message(SPAN_WARNING ("The cryo cell's tank starts draining as its ejection lights blare!"))
			sleep(300)
			if(!src || !usr || !occupant || (occupant != usr)) //Check if someone's released/replaced/bombed him already
				return
			go_out()//and release him from the eternal prison.
		else
			if (usr.stat != 0)
				return
			go_out()
	return

/obj/structure/machinery/cryo_cell/verb/move_inside()
	set name = "Move Inside"
	set category = "Object"
	set src in oview(1)
	if (usr.stat != 0)
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
