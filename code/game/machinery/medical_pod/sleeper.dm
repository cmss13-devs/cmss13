/////////////////////////////////////////
// SLEEPER CONSOLE
/////////////////////////////////////////

/obj/structure/machinery/sleep_console
	name = "sleeper console"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "sleeperconsole"
	var/obj/structure/machinery/medical_pod/sleeper/connected = null
	anchored = TRUE //About time someone fixed this.
	density = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	unslashable = TRUE


/obj/structure/machinery/sleep_console/Initialize()
	. = ..()
	connect_sleeper()
	flags_atom |= USES_HEARING

/obj/structure/machinery/sleep_console/proc/connect_sleeper()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/medical_pod/sleeper,get_step(src, WEST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/medical_pod/sleeper,get_step(src, EAST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/sleep_console/Destroy()
	if(connected)
		if(connected.occupant)
			connected.go_out()

		connected.connected = null
		QDEL_NULL(connected)
	. = ..()


/obj/structure/machinery/sleep_console/process()
	if(inoperable())
		return
	updateUsrDialog()


/obj/structure/machinery/sleep_console/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/machinery/sleep_console/attack_remote(mob/living/user)
	return attack_hand(user)

// tgui \\

/obj/structure/machinery/sleep_console/attack_hand(mob/living/user)
	if(..())
		return
	if(inoperable())
		return

	tgui_interact(user)

/obj/structure/machinery/sleep_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper", "Sleeper", 550, 775)
		ui.open()

/obj/structure/machinery/sleep_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/sleep_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/sleep_console/ui_data(mob/user)
	var/list/data = list()

	if(!connected)
		data["connected"] = null
		return data
	else
		data["connected"] = connected
		data["connected_operable"] = connected.inoperable()

	var/mob/living/occupant = connected.occupant

	data["amounts"] = connected.amounts
	data["hasOccupant"] = occupant ? 1 : 0
	var/occupantData[0]
	var/crisis = 0
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
		occupantData["paralysis"] = occupant.getHalLoss()
		occupantData["hasBlood"] = 0
		occupantData["bodyTemperature"] = occupant.bodytemperature
		occupantData["maxTemp"] = 1000 // If you get a burning vox armalis into the sleeper, congratulations
		// Because we can put simple_animals in here, we need to do something tricky to get things working nice
		occupantData["temperatureSuitability"] = 0 // 0 is the baseline
		if(ishuman(occupant))
			var/mob/living/carbon/human/human_occupant = occupant
			if(human_occupant.species)
				// I wanna do something where the bar gets bluer as the temperature gets lower
				// For now, I'll just use the standard format for the temperature status
				var/datum/species/sp = human_occupant.species
				if(occupant.bodytemperature < sp.cold_level_3)
					occupantData["temperatureSuitability"] = -3
				else if(occupant.bodytemperature < sp.cold_level_2)
					occupantData["temperatureSuitability"] = -2
				else if(occupant.bodytemperature < sp.cold_level_1)
					occupantData["temperatureSuitability"] = -1
				else if(occupant.bodytemperature > sp.heat_level_3)
					occupantData["temperatureSuitability"] = 3
				else if(occupant.bodytemperature > sp.heat_level_2)
					occupantData["temperatureSuitability"] = 2
				else if(occupant.bodytemperature > sp.heat_level_1)
					occupantData["temperatureSuitability"] = 1
		else if(istype(occupant, /mob/living/simple_animal))
			var/mob/living/simple_animal/silly = occupant
			if(silly.bodytemperature < silly.minbodytemp)
				occupantData["temperatureSuitability"] = -3
			else if(silly.bodytemperature > silly.maxbodytemp)
				occupantData["temperatureSuitability"] = 3
		// Blast you, imperial measurement system
		occupantData["btCelsius"] = occupant.bodytemperature - T0C
		occupantData["btFaren"] = ((occupant.bodytemperature - T0C) * (9.0/5.0))+ 32

		occupantData["totalreagents"] = occupant.reagents.total_volume
		occupantData["reagentswhenstarted"] = connected.dialysis_started_reagent_vol

		crisis = (occupant.health < connected.min_health)
		// I'm not sure WHY you'd want to put a simple_animal in a sleeper, but precedent is precedent
		// Runtime is aptly named, isn't she?
		if(ishuman(occupant))
			var/mob/living/carbon/human/human_occupant = occupant
			if(!(NO_BLOOD in human_occupant.species.flags))
				occupantData["pulse"] = human_occupant.get_pulse(GETPULSE_TOOL)
				occupantData["hasBlood"] = 1
				occupantData["bloodLevel"] = round(occupant.blood_volume)
				occupantData["bloodMax"] = occupant.max_blood
				occupantData["bloodPercent"] = round(100*(occupant.blood_volume/occupant.max_blood), 0.01)

	data["occupant"] = occupantData
	data["maxchem"] = connected.max_chem
	data["minhealth"] = connected.min_health
	data["dialysis"] = connected.filtering
	data["auto_eject_dead"] = connected.auto_eject_dead

	var/chemicals[0]
	for(var/re in connected.available_chemicals)
		var/datum/reagent/temp = chemical_reagents_list[re]
		if(temp)
			var/reagent_amount = 0
			var/pretty_amount
			var/injectable = occupant ? 1 : 0
			var/overdosing = 0
			var/caution = 0 // To make things clear that you're coming close to an overdose
			if(crisis && !(temp.id in connected.emergency_chems))
				injectable = 0

			if(occupant && occupant.reagents)
				reagent_amount = occupant.reagents.get_reagent_amount(temp.id)
				// If they're mashing the highest concentration, they get one warning
				if(temp.overdose && reagent_amount + 10 > temp.overdose)
					caution = 1
				if(temp.overdose && reagent_amount >= temp.overdose)
					overdosing = 1

			pretty_amount = round(reagent_amount, 0.05)

			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("chemical" = temp.id), "occ_amount" = reagent_amount, "pretty_amount" = pretty_amount, "injectable" = injectable, "overdosing" = overdosing, "od_warning" = caution)))
	data["chemicals"] = chemicals
	return data

/obj/structure/machinery/sleep_console/ui_act(action, params)
	if(..())
		return
	if(usr == connected.occupant)
		return
	if(stat & (NOPOWER|BROKEN))
		return

	. = TRUE
	switch(action)
		if("chemical")
			if(!connected.occupant)
				return
			if(connected.occupant.stat == DEAD)
				to_chat(usr, SPAN_DANGER("This person has no life to preserve anymore. Take them to a department capable of reanimating them."))
				return
			var/chemical = params["chemid"]
			var/amount = text2num(params["amount"])
			if(!length(chemical) || amount <= 0)
				return
			if(connected.occupant.health > connected.min_health || (chemical in connected.emergency_chems))
				connected.inject_chemical(usr, chemical, amount)
			else
				to_chat(usr, SPAN_DANGER("This person is not in good enough condition for sleepers to be effective! Use another means of treatment, such as cryogenics!"))
		if("togglefilter")
			connected.toggle_filter()
		if("ejectify")
			connected.eject()
		if("auto_eject_dead_on")
			connected.auto_eject_dead = TRUE
		if("auto_eject_dead_off")
			connected.auto_eject_dead = FALSE
		else
			return FALSE
	add_fingerprint(usr)

/////////////////////////////////////////
// THE SLEEPER ITSELF
/////////////////////////////////////////

/obj/structure/machinery/medical_pod/sleeper
	name = "sleeper"
	icon_state = "sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."

	entry_timer = 2 SECONDS

	var/available_chemicals = list("inaprovaline", "paracetamol", "anti_toxin", "dexalin", "tricordrazine")
	var/emergency_chems = list("inaprovaline", "paracetamol", "anti_toxin", "dexalin", "tricordrazine", "oxycodone", "bicaridine", "kelotane")
	var/amounts = list(5, 10)
	var/filtering = FALSE
	var/obj/structure/machinery/sleep_console/connected
	var/min_health = 10
	var/max_chem = 40
	var/auto_eject_dead = FALSE
	var/reagent_removed_per_second = AMOUNT_PER_TIME(3, 1 SECONDS)
	var/dialysis_started_reagent_vol = null // how many reagents the occupant had in them when we STARTED dialysis

	use_power = USE_POWER_IDLE
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.


/obj/structure/machinery/medical_pod/sleeper/Initialize()
	. = ..()
	connect_sleeper_console()

// --- MEDICAL POD PROC OVERRIDES --- \\


/obj/structure/machinery/medical_pod/sleeper/go_in(mob/M)
	. = ..()
	START_PROCESSING(SSobj, src)
	START_PROCESSING(SSobj, connected)



/obj/structure/machinery/medical_pod/sleeper/go_out()
	. = ..()
	if(filtering)
		toggle_filter()
	STOP_PROCESSING(SSobj, src)
	STOP_PROCESSING(SSobj, connected)



/obj/structure/machinery/medical_pod/sleeper/proc/connect_sleeper_console()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/sleep_console,get_step(src, EAST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/sleep_console,get_step(src, WEST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/medical_pod/sleeper/Destroy()
	if(occupant)
		go_out()
	if(connected)
		connected.connected = null
		QDEL_NULL(connected)
	. = ..()

/obj/structure/machinery/medical_pod/sleeper/allow_drop()
	return FALSE

/obj/structure/machinery/medical_pod/sleeper/process(delta_time)
	if (inoperable())
		return

	if(filtering)
		for(var/datum/reagent/x in occupant.reagents.reagent_list)
			occupant.reagents.remove_reagent(x.id, reagent_removed_per_second*delta_time)

		if(!occupant.reagents.total_volume)
			playsound(src.loc, 'sound/machines/ping.ogg', 25, 1)
			visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("\The [src] pings: Dialysis complete!")]")
			filtering = FALSE

	if(occupant)
		if(auto_eject_dead && occupant.stat == DEAD)
			playsound(loc, 'sound/machines/buzz-sigh.ogg', 40)
			go_out()
			return

	updateUsrDialog()

/obj/structure/machinery/medical_pod/sleeper/ex_act(severity)
	if(filtering)
		toggle_filter()
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)


/obj/structure/machinery/medical_pod/sleeper/emp_act(severity)
	. = ..()
	if(filtering)
		toggle_filter()
	if(inoperable())
		return
	if(occupant)
		go_out()

/obj/structure/machinery/medical_pod/sleeper/proc/toggle_filter()
	if(!occupant)
		filtering = FALSE
		dialysis_started_reagent_vol = 0
		return
	if(filtering)
		filtering = FALSE
		dialysis_started_reagent_vol = 0
	else
		filtering = TRUE
		dialysis_started_reagent_vol = occupant.reagents.total_volume

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/medical_pod/sleeper/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant) && occupant.stat != DEAD)
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH

/obj/structure/machinery/medical_pod/sleeper/proc/inject_chemical(mob/living/user as mob, chemical, amount)
	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical) + amount <= max_chem)
			occupant.reagents.add_reagent(chemical, amount, , , user)
			var/datum/reagent/temp = chemical_reagents_list[chemical]
			to_chat(user, SPAN_NOTICE("[occupant] now has [occupant.reagents.get_reagent_amount(chemical)] units of [temp.name] in \his bloodstream."))
			return
	to_chat(user, SPAN_WARNING("There's no occupant in the sleeper or the subject has too many chemicals!"))
	return


/obj/structure/machinery/medical_pod/sleeper/proc/check(mob/living/user)
	if(occupant)
		var/msg_occupant = "[occupant]"
		to_chat(user, SPAN_NOTICE("<B>Occupant ([msg_occupant]) Statistics:</B>"))
		var/t1
		switch(occupant.stat)
			if(0)
				t1 = "Conscious"
			if(1)
				t1 = "Unconscious"
			if(2)
				t1 = "*dead*"
		to_chat(user, "[]\t Health %: [] ([])", (occupant.health > 50 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.health, t1)
		to_chat(user, "[]\t -Core Temperature: []&deg;C ([]&deg;F)</FONT><BR>", (occupant.bodytemperature > 50 ? "<font color='blue'>" : "<font color='red'>"), occupant.bodytemperature-T0C, occupant.bodytemperature*1.8-459.67)
		to_chat(user, "[]\t -Brute Damage %: []", (occupant.getBruteLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getBruteLoss())
		to_chat(user, "[]\t -Respiratory Damage %: []", (occupant.getOxyLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getOxyLoss())
		to_chat(user, "[]\t -Toxin Content %: []", (occupant.getToxLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getToxLoss())
		to_chat(user, "[]\t -Burn Severity %: []", (occupant.getFireLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getFireLoss())
		to_chat(user, SPAN_NOTICE(" Expected time till occupant can safely awake: (note: These times are always inaccurate)"))
		to_chat(user, SPAN_NOTICE(" \t [occupant.GetKnockOutDuration() * GLOBAL_STATUS_MULTIPLIER / (1 SECONDS)] second\s (if around 1 or 2 the sleeper is keeping them asleep.)"))
	else
		to_chat(user, SPAN_NOTICE(" There is no one inside!"))
	return


