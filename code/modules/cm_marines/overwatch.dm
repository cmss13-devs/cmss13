#define HIDE_ALMAYER 2
#define HIDE_GROUND 1
#define HIDE_NONE 0

/obj/structure/machinery/computer/overwatch
	name = "Overwatch Console"
	desc = "State of the art machinery for giving orders to a squad."
	icon_state = "dummy"
	req_access = list(ACCESS_MARINE_DATABASE)
	unacidable = TRUE

	var/datum/squad/current_squad = null
	var/obj/structure/machinery/camera/cam = null
	var/list/network = list(CAMERA_NET_OVERWATCH)
	var/x_supply = 0
	var/y_supply = 0
	var/x_bomb = 0
	var/y_bomb = 0
	var/busy = FALSE //The overwatch computer is busy launching an OB/SB, lock controls
	var/dead_hidden = FALSE //whether or not we show the dead marines in the squad
	var/z_hidden = 0 //which z level is ignored when showing marines.
	var/list/marine_filter = list() // individual marine hiding control - list of string references
	var/marine_filter_enabled = TRUE
	var/faction = FACTION_MARINE

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM
	var/supply_cooldown_time = 500 SECONDS

/obj/structure/machinery/computer/overwatch/Initialize()
	. = ..()
	tacmap = new(src, minimap_type)

/obj/structure/machinery/computer/overwatch/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/obj/structure/machinery/computer/overwatch/attackby(obj/current_obj, mob/user)  //Can't break or disassemble.
	return

/obj/structure/machinery/computer/overwatch/bullet_act(obj/item/projectile/Proj) //Can't shoot it
	return FALSE

/obj/structure/machinery/computer/overwatch/attack_remote(mob/user as mob)
	if(!ismaintdrone(user))
		return attack_hand(user)

/obj/structure/machinery/computer/overwatch/attack_hand(mob/user)
	if(..())  //Checks for power outages
		return

	if(istype(src, /obj/structure/machinery/computer/overwatch/almayer/broken))
		return

	if(!ishighersilicon(usr) && !skillcheck(user, SKILL_LEADERSHIP, SKILL_LEAD_EXPERT) && SSmapping.configs[GROUND_MAP].map_name != MAP_WHISKEY_OUTPOST)
		to_chat(user, SPAN_WARNING("You don't have the training to use [src]."))
		return

	tgui_interact(user)
	return

//returns the helmet camera the human is wearing
/obj/structure/machinery/computer/overwatch/proc/get_camera_from_target(mob/living/carbon/human/selected_human)
	if(current_squad)
		if(selected_human && istype(selected_human) && istype(selected_human.head, /obj/item/clothing/head/helmet/marine))
			var/obj/item/clothing/head/helmet/marine/helm = selected_human.head
			return helm.camera

// Alerts all groundside marines about the incoming OB
/obj/structure/machinery/computer/overwatch/proc/alert_ob(turf/target)
	var/area/ob_area = get_area(target)
	if(!ob_area)
		return
	var/ob_type = almayer_orbital_cannon.tray.warhead ? almayer_orbital_cannon.tray.warhead.warhead_kind : "UNKNOWN"

	for(var/datum/squad/current_squad as anything in RoleAuthority.squads)
		if(!current_squad.active)
			continue
		for(var/mob/living/carbon/human/current_human in current_squad.marines_list)
			if(!is_ground_level(current_human.z))
				continue
			if(current_human.stat != CONSCIOUS || !current_human.client)
				continue
			playsound_client(current_human.client, 'sound/effects/ob_alert.ogg', current_human)
			to_chat(current_human, SPAN_HIGHDANGER("Orbital bombardment launch command detected!"))
			to_chat(current_human, SPAN_DANGER("Launch command informs [ob_type] warhead. Estimated impact area: [ob_area.name]"))

		return

/obj/structure/machinery/computer/overwatch/proc/change_lead(picked)
	var/mob/living/carbon/human/selected_human = locate(picked)
	if(!istype(selected_human))
		return
	if(current_squad.squad_leader)
		current_squad.send_message("Attention: [current_squad.squad_leader] is [current_squad.squad_leader.stat == DEAD ? "stepping down" : "demoted"]. A new Squad Leader has been set: [selected_human.real_name].")
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Squad Leader [current_squad.squad_leader] of squad '[current_squad]' has been [current_squad.squad_leader.stat == DEAD ? "replaced" : "demoted and replaced"] by [selected_human.real_name]! Logging to enlistment files.")]")
		var/old_lead = current_squad.squad_leader
		current_squad.demote_squad_leader(current_squad.squad_leader.stat != DEAD)
		SStracking.start_tracking(current_squad.tracking_id, old_lead)
	else
		current_squad.send_message("Attention: A new Squad Leader has been set: [selected_human.real_name].")
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[selected_human.real_name] is the new Squad Leader of squad '[current_squad]'! Logging to enlistment file.")]")

	to_chat(selected_human, "[icon2html(src, selected_human)] <font size='3' color='blue'><B>Overwatch: You've been promoted to \'[selected_human.job == JOB_SQUAD_LEADER ? "SQUAD LEADER" : "ACTING SQUAD LEADER"]\' for [current_squad.name]. Your headset has access to the command channel (:v).</B></font>")
	to_chat(usr, "[icon2html(src, usr)] [selected_human.real_name] is [current_squad]'s new leader!")

	if(selected_human.assigned_fireteam)
		if(selected_human == current_squad.fireteam_leaders[selected_human.assigned_fireteam])
			current_squad.unassign_ft_leader(selected_human.assigned_fireteam, TRUE, FALSE)
		current_squad.unassign_fireteam(selected_human, FALSE)

	current_squad.squad_leader = selected_human
	current_squad.update_squad_leader()
	current_squad.update_free_mar()

	SStracking.set_leader(current_squad.tracking_id, selected_human)
	SStracking.start_tracking("marine_sl", selected_human)

	if(selected_human.job == JOB_SQUAD_LEADER)//a real SL
		selected_human.comm_title = "SL"
	else //an acting SL
		selected_human.comm_title = "aSL"
	ADD_TRAIT(selected_human, TRAIT_LEADERSHIP, TRAIT_SOURCE_SQUAD_LEADER)

	var/obj/item/device/radio/headset/almayer/marine/marine_radio = selected_human.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine)
	if(marine_radio)
		marine_radio.keys += new /obj/item/device/encryptionkey/squadlead/acting(marine_radio)
		marine_radio.recalculateChannels()
	if(istype(selected_human.wear_id, /obj/item/card/id))
		var/obj/item/card/id/ID = selected_human.wear_id
		ID.access += ACCESS_MARINE_LEADER
	selected_human.hud_set_squad()
	selected_human.update_inv_head() //updating marine helmet leader overlays
	selected_human.update_inv_wear_suit()

/obj/structure/machinery/computer/overwatch/proc/mark_insubordination(picked)
	if(!usr || usr != operator)
		return
	if(!current_squad)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("No squad selected!")]")
		return

	var/mob/living/carbon/human/wanted_marine = locate(picked)
	if(!wanted_marine)
		return
	if(!istype(wanted_marine))//gibbed/deleted, all we have is a name.
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[wanted_marine] is missing in action.")]")
		return

	var/marine_ref = WEAKREF(wanted_marine)
	for(var/datum/data/record/records in GLOB.data_core.general)
		if(records.fields["ref"] == marine_ref)
			for(var/datum/data/record/sec_record in GLOB.data_core.security)
				if(sec_record.fields["id"] == records.fields["id"])
					if(!findtext(sec_record.fields["ma_crim"],"Insubordination."))
						sec_record.fields["criminal"] = "*Arrest*"
						if(sec_record.fields["ma_crim"] == "None")
							sec_record.fields["ma_crim"] = "Insubordination."
						else
							sec_record.fields["ma_crim"] += "Insubordination."

						var/insub = "[icon2html(src, usr)] [SPAN_BOLDNOTICE("[wanted_marine] has been reported for insubordination. Logging to enlistment file.")]"
						if(isRemoteControlling(usr))
							usr << insub
						else
							visible_message(insub)
						to_chat(wanted_marine, "[icon2html(src, wanted_marine)] <font size='3' color='blue'><B>Overwatch:</b> You've been reported for insubordination by your overwatch officer.</font>")
						wanted_marine.sec_hud_set_security_status()
					return

/obj/structure/machinery/computer/overwatch/proc/transfer_squad(picked)
	if(!usr || usr != operator)
		return
	var/datum/squad/transfered_squad = current_squad
	var/mob/living/carbon/human/transfer_marine = locate(picked)
	if(!transfer_marine || transfered_squad != current_squad) //don't change overwatched squad, idiot.
		return

	if(!istype(transfer_marine) || !transfer_marine.mind || transfer_marine.stat == DEAD) //gibbed, decapitated, dead
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[transfer_marine] is KIA.")]")
		return

	if(!istype(transfer_marine.wear_id, /obj/item/card/id))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Transfer aborted. [transfer_marine] isn't wearing an ID.")]")
		return

	var/list/available_squads = list()
	for(var/datum/squad/squad as anything in RoleAuthority.squads)
		if(squad.active && !squad.locked && squad.faction == faction && squad.name != "Root")
			available_squads += squad
			available_squads -= transfer_marine.assigned_squad

	var/datum/squad/new_squad = tgui_input_list(usr, "Choose the marine's new squad", "Squad Selection", available_squads)
	if(!new_squad || transfered_squad != current_squad)
		return

	if(!istype(transfer_marine) || !transfer_marine.mind || transfer_marine.stat == DEAD)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[transfer_marine] is KIA.")]")
		return

	if(!istype(transfer_marine.wear_id, /obj/item/card/id))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Transfer aborted. [transfer_marine] isn't wearing an ID.")]")
		return

	var/datum/squad/old_squad = transfer_marine.assigned_squad
	if(new_squad == old_squad)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[transfer_marine] is already in [new_squad]!")]")
		return

	if(RoleAuthority.check_squad_capacity(transfer_marine, new_squad))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Transfer aborted. [new_squad] can't have another [transfer_marine.job].")]")
		return

	if(transfer_marine_to_squad(transfer_marine, new_squad, old_squad))
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[transfer_marine] has been transfered from squad '[old_squad]' to squad '[new_squad]'. Logging to enlistment file.")]")
		to_chat(transfer_marine, "[icon2html(src, transfer_marine)] <font size='3' color='blue'><B>\[Overwatch\]:</b> You've been transfered to [new_squad]!</font>")
	else
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[transfer_marine] transfer from squad '[old_squad]' to squad '[new_squad]' unsuccessful.")]")

/obj/structure/machinery/computer/overwatch/proc/handle_bombard(mob/user)
	if(!user)
		return

	if(busy)
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The [name] is busy processing another action!")]")
		return

	if(!current_squad)
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("No squad selected!")]")
		return

	if(!almayer_orbital_cannon.chambered_tray)
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The orbital cannon has no ammo chambered.")]")
		return

	var/x_coord = deobfuscate_x(x_bomb)
	var/y_coord = deobfuscate_y(y_bomb)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/selected_turf = locate(x_coord, y_coord, z_coord)

	if(isnull(selected_turf) || istype(selected_turf, /turf/open/space))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The target zone appears to be out of bounds. Please check coordinates.")]")
		return

	if(protected_by_pylon(TURF_PROTECTION_OB, selected_turf))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The target zone has strong biological protection. The orbital strike cannot reach here.")]")
		return

	var/area/selected_area = get_area(selected_turf)

	if(istype(selected_area) && CEILING_IS_PROTECTED(selected_area.ceiling, CEILING_DEEP_UNDERGROUND))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The target zone is deep underground. The orbital strike cannot reach here.")]")
		return


	//All set, let's do this.
	busy = TRUE
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Orbital bombardment request for squad '[current_squad]' accepted. Orbital cannons are now calibrating.")]")
	playsound(selected_turf,'sound/effects/alert.ogg', 25, 1)  //Placeholder
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, alert_ob), selected_turf), 2 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, begin_fire)), 6 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, fire_bombard), user, selected_area, selected_turf), 6 SECONDS + 6)

/obj/structure/machinery/computer/overwatch/proc/begin_fire()
	for(var/mob/living/carbon/current_human in GLOB.alive_mob_list)
		if(is_mainship_level(current_human.z) && !current_human.stat) //USS Almayer decks.
			to_chat(current_human, SPAN_WARNING("The deck of the [MAIN_SHIP_NAME] shudders as the orbital cannons open fire on the colony."))
			if(current_human.client)
				shake_camera(current_human, 10, 1)
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Orbital bombardment for squad '[current_squad]' has fired! Impact imminent!")]")
	current_squad.send_message("WARNING! Ballistic trans-atmospheric launch detected! Get outside of Danger Close!")

/obj/structure/machinery/computer/overwatch/proc/fire_bombard(mob/user, area/selected_area, turf/selected_turf)
	if(!selected_area || !selected_turf)
		return

	var/ob_name = lowertext(almayer_orbital_cannon.tray.warhead.name)
	announce_dchat("\A [ob_name] targeting [selected_area.name] has been fired!", selected_turf)
	message_admins(FONT_SIZE_HUGE("ALERT: [key_name(user)] fired an orbital bombardment in [selected_area.name] for squad '[current_squad]' (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[selected_turf.x];Y=[selected_turf.y];Z=[selected_turf.z]'>JMP</a>)"))
	log_attack("[key_name(user)] fired an orbital bombardment in [selected_area.name] for squad '[current_squad]'")

	busy = FALSE
	var/turf/target = locate(selected_turf.x + rand(-3, 3), selected_turf.y + rand(-3, 3), selected_turf.z)
	if(target && istype(target))
		almayer_orbital_cannon.fire_ob_cannon(target, user)
		user.count_niche_stat(STATISTICS_NICHE_OB)

/obj/structure/machinery/computer/overwatch/proc/handle_supplydrop()
	SHOULD_NOT_SLEEP(TRUE)
	if(!usr || usr != operator)
		return

	if(busy)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The [name] is busy processing another action!")]")
		return

	var/obj/structure/closet/crate/target_crate = locate() in current_squad.drop_pad.loc //This thing should ALWAYS exist.
	if(!istype(target_crate))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("No crate was detected on the drop pad. Get Requisitions on the line!")]")
		return

	var/x_coord = deobfuscate_x(x_supply)
	var/y_coord = deobfuscate_y(y_supply)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/selected_turf = locate(x_coord, y_coord, z_coord)
	if(!selected_turf)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Error, invalid coordinates.")]")
		return

	var/area/selected_area = get_area(selected_turf)
	if(selected_area && CEILING_IS_PROTECTED(selected_area.ceiling, CEILING_PROTECTION_TIER_2))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The landing zone is underground. The supply drop cannot reach here.")]")
		return

	if(istype(selected_turf, /turf/open/space) || selected_turf.density)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The landing zone appears to be obstructed or out of bounds. Package would be lost on drop.")]")
		return

	to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The supply drop is now loading into the launch tube.")]")
	busy = TRUE
	target_crate.visible_message(SPAN_WARNING("\The [target_crate] loads into a launch tube. Stand clear!"))
	target_crate.anchored = TRUE //To avoid accidental pushes
	current_squad.send_message("'[target_crate.name]' supply drop incoming. Heads up!")
	current_squad.send_maptext(target_crate.name, "Incoming Supply Drop:")
	var/datum/squad/selected_squad = current_squad //in case the operator changes the overwatched squad mid-drop
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, finish_supplydrop), target_crate, selected_squad, selected_turf), 10 SECONDS)

/obj/structure/machinery/computer/overwatch/proc/finish_supplydrop(obj/structure/closet/crate/target_crate, datum/squad/selected_squad, turf/selected_turf)
	if(!target_crate || target_crate.loc != selected_squad.drop_pad.loc) //Crate no longer on pad somehow, abort.
		if(target_crate) target_crate.anchored = FALSE
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Launch aborted! No crate detected on the drop pad.")]")
		return
	COOLDOWN_START(selected_squad, next_supplydrop, supply_cooldown_time)
	if(ismob(usr))
		var/mob/current_human = usr
		current_human.count_niche_stat(STATISTICS_NICHE_CRATES)

	playsound(target_crate.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehh
	var/obj/structure/droppod/supply/pod = new()
	target_crate.forceMove(pod)
	pod.launch(selected_turf)
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("'[target_crate.name]' supply drop launched! Another launch will be available in five minutes.")]")
	busy = FALSE

/obj/structure/machinery/computer/overwatch/almayer
	density = FALSE
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "overwatch"

/obj/structure/machinery/computer/overwatch/almayer/broken
	name = "Broken Overwatch Console"

/obj/structure/machinery/computer/overwatch/clf
	faction = FACTION_CLF
/obj/structure/machinery/computer/overwatch/upp
	faction = FACTION_UPP
/obj/structure/machinery/computer/overwatch/pmc
	faction = FACTION_PMC
/obj/structure/machinery/computer/overwatch/twe
	faction = FACTION_TWE
/obj/structure/machinery/computer/overwatch/freelance
	faction = FACTION_FREELANCER

/obj/structure/supply_drop
	name = "Supply Drop Pad"
	desc = "Place a crate on here to allow bridge Overwatch officers to drop them on people's heads."
	icon = 'icons/effects/warning_stripes.dmi'
	anchored = TRUE
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE
	layer = 2.1 //It's the floor, man
	var/squad = SQUAD_MARINE_1
	var/sending_package = 0

/obj/structure/supply_drop/Initialize(mapload, ...)
	. = ..()
	GLOB.supply_drop_list += src

/obj/structure/supply_drop/Destroy()
	GLOB.supply_drop_list -= src
	return ..()

/obj/structure/supply_drop/alpha
	icon_state = "alphadrop"
	squad = SQUAD_MARINE_1

/obj/structure/supply_drop/bravo
	icon_state = "bravodrop"
	squad = SQUAD_MARINE_2

/obj/structure/supply_drop/charlie
	icon_state = "charliedrop"
	squad = SQUAD_MARINE_3

/obj/structure/supply_drop/delta
	icon_state = "deltadrop"
	squad = SQUAD_MARINE_4

/obj/structure/supply_drop/echo //extra supply drop pad
	icon_state = "echodrop"
	squad = SQUAD_MARINE_5

/obj/structure/machinery/computer/overwatch/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "OverwatchConsole", "[src.name]")
		ui.open()

/obj/structure/machinery/computer/overwatch/proc/get_squad_data(datum/squad/squad)

	var/list/marines_list = squad.marines_list
	var/list/squad_leader_candidates = list()
	var/alive_squad_members = 0

	for(var/mob/living/carbon/human/squaddie in marines_list)
		if(ishuman(squaddie) && squaddie.stat != DEAD)
			if(squaddie.mind && !jobban_isbanned(squaddie, JOB_SQUAD_LEADER) && !(squaddie == current_squad.squad_leader))
				squad_leader_candidates += squaddie
		alive_squad_members++

	var/list/squad_data = list(
	"current_squad" = squad,
	"squad_name" = squad.name,
	"color" = squad_colors[squad?.color],
	"current_squad_leader" = ref(squad.squad_leader),
	"current_squad_leader_name" = squad.squad_leader?.name,
	"primary_objective" = squad.primary_objective,
	"secondary_objective" = squad.secondary_objective,
	"engineers" = squad.num_engineers,
	"medics" = squad.num_medics,
	"smartgun" = squad.num_smartgun,
	"specialists" = squad.num_specialists,
	"rto" = squad.num_rto,
	"total_deployed" = squad.count,
	"sl_candidates" = squad_leader_candidates,
	"alive" = alive_squad_members,
	)

	return(squad_data)

/obj/structure/machinery/computer/overwatch/proc/get_marine_data(datum/squad/squad)
	for(var/current_member in squad.marines_list)

		if(ishuman(current_member))
			var/mob/living/carbon/human/current_squaddie = current_member

			if(QDELETED(current_squaddie))
				continue

			if(!(current_squaddie.stat))
				continue

			var/manually_filtered = FALSE
			var/marine_status = "Unknown"
			var/filtered = FALSE
			switch(current_squaddie.stat)
				if(CONSCIOUS)
					marine_status = "Conscious"
				if(UNCONSCIOUS)
					marine_status = "Unconscious"
				if(DEAD)
					marine_status = "Dead"
					if(dead_hidden)
						filtered = TRUE

			var/turf/current_turf = get_turf(current_squaddie)
			switch(z_hidden)
				if(HIDE_ALMAYER)
					if(is_mainship_level(current_turf?.z))
						filtered = TRUE
				if(HIDE_GROUND)
					if(is_ground_level(current_turf?.z))
						filtered = TRUE

			if("\ref[current_squaddie]" in marine_filter)
				manually_filtered = TRUE
				if(marine_filter_enabled)
					filtered = TRUE

			var/obj/item/card/id/ID = current_squaddie.get_idcard()

			var/area/current_area = get_area(current_squaddie)
			current_marines_list[current_squaddie] = list(
				"ref" = ref(current_squaddie),
				"name" = current_squaddie.real_name,
				"mob_state" = marine_status,
				"role" = current_squaddie.job ? current_squaddie?.job : current_squaddie?.wear_id?.rank,
				"act_sl" = current_squaddie.job != JOB_SQUAD_LEADER && squad.squad_leader == current_squaddie,
				"fteam" = current_squaddie?.assigned_fireteam,
				"dist" = squad.squad_leader ? current_squaddie != squad.squad_leader ? get_dist(current_squaddie, current_squad.squad_leader) : null : null,
				"dir" = squad.squad_leader ? current_squaddie != squad.squad_leader ? dir2text_short(get_dir(current_squad.squad_leader, current_squaddie)) : null : null,
				"area_name" = sanitize_area(current_area?.name),
				"helmet" = istype(current_squaddie.head, /obj/item/clothing/head/helmet/marine),
				"filtered" = filtered,
				"manually_filtered" = manually_filtered,
				"SSD" = !current_squaddie.key || !current_squaddie.client && current_squaddie.stat != DEAD,
				"paygrade" = ID ? get_paygrades(ID.paygrade, 1) : ""
				)

		else
			var/record_role = "Unknown"
			for(var/datum/data/record/data_record in GLOB.data_core.general)
				if(data_record.fields["name"] == current_member)
					record_role = data_record.fields["real_rank"]
					break

			current_marines_list[current_member] = list(
				"name" = current_member,
				"role" = record_role,
				"mob_state" = "Dead",
			)


	return(current_marines_list)

/obj/structure/machinery/computer/overwatch/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/overwatch/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/overwatch/ui_data(mob/user)
	var/list/data = list()

	data["z_hidden"] = z_hidden
	data["x_supply"] = x_supply
	data["y_supply"] = y_supply
	data["x_bomb"] = x_bomb
	data["y_bomb"] = y_bomb
	data["dead_hidden"] = dead_hidden
	data["marine_filter"] = marine_filter
	data["marine_filter_enabled"] = marine_filter_enabled
	data["operator"] = operator?.name
	data["world_time"] = world.time
	data["user"] = user
	data["busy"] = busy

	var/list/squad_list = list()
	for(var/datum/squad/squad in RoleAuthority.squads)
		if(squad.active && !squad.overwatch_officer && squad.faction == faction && squad.name != "Root")
			squad_list += squad.name
	data["squad_list"] = squad_list

	data["bombardment_cooldown"] = almayer_orbital_cannon?.ob_firing_cooldown
	data["almayer_cannon_ready"] = almayer_orbital_cannon?.tray.warhead
	data["almayer_cannon_disabled"] = almayer_orbital_cannon?.is_disabled

	data["supply_cooldown"] = current_squad?.next_supplydrop
	data["marine_list"] = current_squad ? get_marine_data(current_squad) : FALSE
	data["squad_data"] = current_squad ? get_squad_data(current_squad) : FALSE

	if(current_squad?.drop_pad)
		var/obj/structure/closet/crate/drop_closet = locate() in current_squad?.drop_pad.loc
		data["supply_pad_ready"] = drop_closet ? TRUE : FALSE
	else
		data["supply_pad_ready"] = FALSE

	return(data)

/obj/structure/machinery/computer/overwatch/ui_static_data(mob/user)

	var/list/data = list()

	data["max_supply_cooldown"] = supply_cooldown_time
	data["max_bombardment_cooldown"] = almayer_orbital_cannon?.fire_cooldown_time

	return(data)

/obj/structure/machinery/computer/overwatch/ui_close(mob/user)
	. = ..()
	user.reset_view(null)

/obj/structure/machinery/computer/overwatch/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)

		if("change_operator")
			if(operator && ishighersilicon(operator))
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("AI override in progress. Access denied.")]")
				return
			if(!current_squad || current_squad.assume_overwatch(usr))
				operator = usr
			if(ishighersilicon(usr))
				to_chat(usr, "[icon2html(src, usr)] [SPAN_BOLDNOTICE("Overwatch system AI override protocol successful.")]")
				current_squad?.send_squad_message("Attention. [operator.name] has engaged overwatch system control override.", displayed_icon = src)
			else
				var/mob/living/carbon/human/current_human = operator
				var/obj/item/card/id/ID = current_human.get_idcard()
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Basic overwatch systems initialized. Welcome, [ID ? "[ID.rank] ":""][operator.name]. Please select a squad.")]")
				current_squad?.send_squad_message("Attention. Your Overwatch officer is now [ID ? "[ID.rank] ":""][operator.name].", displayed_icon = src)
			return TRUE

		if("logout")
			if(current_squad?.release_overwatch())
				if(ishighersilicon(usr))
					current_squad.send_squad_message("Attention. [operator.name] has released overwatch system control. Overwatch functions deactivated.", displayed_icon = src)
					to_chat(usr, "[icon2html(src, usr)] [SPAN_BOLDNOTICE("Overwatch system control override disengaged.")]")
				else
					var/mob/living/carbon/human/current_operator = operator
					var/obj/item/card/id/ID = current_operator.get_idcard()
					current_squad.send_squad_message("Attention. [ID ? "[ID.rank] ":""][operator ? "[operator.name]":"sysadmin"] is no longer your Overwatch officer. Overwatch functions deactivated.", displayed_icon = src)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Overwatch systems deactivated. Goodbye, [ID ? "[ID.rank] ":""][operator ? "[operator.name]":"sysadmin"].")]")
				current_squad = null
			operator = null
			if(cam && !ishighersilicon(usr))
				usr.reset_view(null)
			cam = null
			return TRUE

		if("pick_squad")
			if(current_squad?.release_overwatch())
				var/mob/living/carbon/human/current_operator = operator
				var/obj/item/card/id/ID = current_operator.get_idcard()
				current_squad.send_squad_message("Attention. [ID ? "[ID.rank] ":""][operator ? "[operator.name]":"sysadmin"] is no longer your Overwatch officer. Overwatch functions deactivated.", displayed_icon = src)
				if(cam && !ishighersilicon(usr))
					usr.reset_view(null)
			var/datum/squad/selected = get_squad_by_name(params["squadpicked"])
				//Link everything together, squad, console, and officer
			if(selected.assume_overwatch(usr))
				current_squad = selected
				current_squad.send_squad_message("Attention - Your squad has been selected for Overwatch. Check your Status pane for objectives.", displayed_icon = src)
				current_squad.send_squad_message("Your Overwatch officer is: [operator.name].", displayed_icon = src)
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Tactical data for squad '[current_squad]' loaded. All tactical functions initialized.")]")
			return TRUE

		if("message")
			var/input = sanitize_control_chars(sanitize(params["message"]))
			current_squad.send_message(input, 1) //message, adds username
			current_squad.send_maptext(input, "Squad Message:")
			visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Message '[input]' sent to all Marines of squad '[current_squad]'.")]")
			log_overwatch("[key_name(usr)] sent '[input]' to squad [current_squad].")
			return TRUE

		if("sl_message")
			var/input = sanitize_control_chars(sanitize(params["message"]))
			current_squad.send_message(input, 1, 1) //message, adds username, only to leader
			current_squad.send_maptext(input, "Squad Leader Message:", 1)
			visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Message '[input]' sent to Squad Leader [current_squad.squad_leader] of squad '[current_squad]'.")]")
			log_overwatch("[key_name(usr)] sent '[input]' to Squad Leader [current_squad.squad_leader] of squad [current_squad].")
			return TRUE

		if("check_primary")
			visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Reminding primary objectives of squad '[current_squad]'.")]")
			to_chat(usr, "[icon2html(src, usr)] <b>Primary Objective:</b> [current_squad.primary_objective]")
			log_overwatch("[key_name(usr)] sent '[current_squad.primary_objective]' to squad [current_squad].")
			return TRUE

		if("check_secondary")
			visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Reminding secondary objectives of squad '[current_squad]'.")]")
			to_chat(usr, "[icon2html(src, usr)] <b>Secondary Objective:</b> [current_squad.secondary_objective]")
			log_overwatch("[key_name(usr)] sent '[current_squad.primary_objective]' to squad [current_squad].")
			return TRUE

		if("set_primary")
			var/input = sanitize_control_chars(sanitize(params["objective"]))
			current_squad.primary_objective = "[input] ([worldtime2text()])"
			current_squad.send_message("Your primary objective has been changed to '[input]'. See Status pane for details.")
			current_squad.send_maptext(input, "Primary Objective Updated:")
			visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Primary objective of squad '[current_squad]' set to '[input]'.")]")
			log_overwatch("[key_name(usr)] set [current_squad]'s primary objective to '[input]'.")
			return TRUE

		if("set_secondary")
			var/input = sanitize_control_chars(sanitize(params["objective"]))
			current_squad.secondary_objective = input + " ([worldtime2text()])"
			current_squad.send_message("Your secondary objective has been changed to '[input]'. See Status pane for details.")
			current_squad.send_maptext(input, "Secondary Objective Updated:")
			visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Secondary objective of squad '[current_squad]' set to '[input]'.")]")
			log_overwatch("[key_name(usr)] set [current_squad]'s secondary objective to '[input]'.")
			return TRUE

		if("set_supply")
			x_supply = params["target_x"]
			y_supply = params["target_y"]
			to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Longitude is now [x_supply], latitude is now [y_supply].")]")
			return TRUE

		if("set_bomb")
			x_bomb = params["target_x"]
			y_bomb = params["target_y"]
			to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Longitude is now [x_bomb], latitude is now [y_bomb].")]")
			return TRUE

		if("hide_dead")
			dead_hidden = !dead_hidden
			if(dead_hidden)
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Dead marines are now not shown.")]")
			else
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Dead marines are now shown again.")]")
			return TRUE

		if("choose_z")
			switch(params["area_picked"])
				if("Ship")
					z_hidden = HIDE_ALMAYER
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Marines on the Almayer are now hidden.")]")
				if("Ground")
					z_hidden = HIDE_GROUND
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Marines on the ground are now hidden.")]")
				if("None")
					z_hidden = HIDE_NONE
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("No location is ignored anymore.")]")
			return TRUE

		if("toggle_marine_filter")
			if(marine_filter_enabled)
				marine_filter_enabled = FALSE
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("All marines will now be shown regardless of filter.")]")
			else
				marine_filter_enabled = TRUE
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Individual Marine Filter is now enabled.")]")
			return TRUE

		if("filter_marine")
			if(current_squad)
				var/squaddie = params["squaddie"]
				var/mob/selected = locate(squaddie)
				if(!(squaddie in marine_filter))
					marine_filter += squaddie
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("[selected.real_name] now hidden.")]")
				else
					marine_filter -= squaddie
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("[selected.real_name] will now be shown.")]")
			return TRUE

		if("change_lead")
			change_lead(params["marine_picked"])
			return TRUE

		if("insubordination")
			mark_insubordination(params["marine_picked"])
			return TRUE

		if("squad_transfer")
			transfer_squad(params["marine_picked"])
			return TRUE

		if("dropsupply")
			handle_supplydrop()
			return TRUE

		if("dropbomb")
			handle_bombard(usr)
			return TRUE

		if("use_cam")
			if(isRemoteControlling(usr))
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Unable to override console camera viewer. Track with camera instead. ")]")
				return
			if(current_squad)
				var/mob/cam_target = locate(params["cam_target"])
				var/obj/structure/machinery/camera/new_cam = get_camera_from_target(cam_target)
				if(!new_cam || !new_cam.can_use())
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Searching for helmet cam. No helmet cam found for this marine! Tell your squad to put their helmets on!")]")
				else if(cam && cam == new_cam)//click the camera you're watching a second time to stop watching.
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Stopping helmet cam view of [cam_target].")]")
					cam = null
					usr.reset_view(null)
				else if(usr.client.view != world_view_size)
					to_chat(usr, SPAN_WARNING("You're too busy peering through binoculars."))
				else
					cam = new_cam
					usr.reset_view(cam)
			return TRUE

	add_fingerprint(usr)

#undef HIDE_ALMAYER
#undef HIDE_GROUND
#undef HIDE_NONE
