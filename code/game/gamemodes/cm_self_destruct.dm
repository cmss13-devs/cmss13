/*
TODO
Look into animation screen not showing on self-destruct and other weirdness
Intergrate distress into this controller.
Finish nanoui conversion for comm console.
Make sure people who get nuked and wake up from SSD don't live.
Add flashing lights to evac. //DEFERRED TO BETTER LIGHTING
Finish the game mode announcement thing.
Fix escape doors to work properly.
*/

/*
How this works:

First: All of the linking is done automatically on world start, so nothing needs to be done on that end other than making
sure that objects are actually placed in the game world. If not, the game will error and let you know about it. But you
don't need to modify variables or worry about area placement. It's all done for you.
The rods, for example, configure the time per activation based on their number. Shuttles link their own machines via area.
Nothing in this controller is linked to game mode, so it's stand alone, more or less, but it's best used during a game mode.
Admins have a lot of tools in their disposal via the check antagonist panel, and devs can access the VV of this controller
through that panel.

Second: The communication console handles most of the IC triggers for activating these functions, the rest is handled elsewhere.
Check communications.dm for that. shuttle_controller.dm handles the set up for the escape pods. escape_pods.dm handles most of the
functions of the escape pods themselves. This file would likely need to be broken down into individual parts at some point in the
future.

Evacuation takes place when sufficient alert level is reaised and a distress beacon was launched. All of the evac pods come online
and open their doors to allow entry inside. Characters may then get inside of the cryo units to before the shuttles automatically launch.
If wanted, a nearby controller object may launch each individual shuttle early. Only three people may ride on a shuttle to escape,
otherwise the launch will fail and the shuttle will become inoperable.
Any launched shuttles are taken out of the game. If the evacuation is canceled, any persons inside of the cryo tubes will be ejected.
They may temporarily open the door to exit if they are stuck inside after evac is canceled.

When the self-destruct is enabled, the console comes online. This usually happens during an evacuation. Once the console is
interacted with, it fires up the self-destruct sequence. Several rods rise and must be interacted with in order to arm the system.
Once that happens, the console must be interacted with again to trigger the self-destruct. The self-destruct may also be
canceled from the console.

The self-destruct may also happen if a nuke is detonated on the ship's zlevel; if it is detonated elsewhere, the ship will not blow up.
Regardless of where it's detonated, or how, a successful detonation will end the round or automatically restart the game.

All of the necessary difines are stored under mode.dm in defines.
*/

var/global/datum/authority/branch/evacuation/EvacuationAuthority //This is initited elsewhere so that the world has a chance to load in.

#define SOUND_CHANNEL_SD 666

/datum/authority/branch/evacuation
	var/name = "Evacuation Authority"
	var/evac_time //Time the evacuation was initiated.
	var/evac_status = EVACUATION_STATUS_STANDING_BY //What it's doing now? It can be standing by, getting ready to launch, or finished.

	var/obj/structure/machinery/self_destruct/console/C //The main console that does the brunt of the work.
	var/dest_rods[] //Slave devices to make the explosion work.
	var/dest_cooldown //How long it takes between rods, determined by the amount of total rods present.
	var/dest_index = 1 //What rod the thing is currently on.
	var/dest_status = NUKE_EXPLOSION_INACTIVE
	var/dest_started_at = 0
	var/dest_start_time
	var/dest_already_armed = 0

	var/flags_scuttle = NO_FLAGS

/datum/authority/branch/evacuation/New()
	..()
	C = locate()
	if(!C)
		log_debug("ERROR CODE SD1: could not find master self-destruct C")
		to_world(SPAN_DEBUG("ERROR CODE SD1: could not find master self-destruct C"))
		return FALSE
	dest_rods = new
	for(var/obj/structure/machinery/self_destruct/rod/I in C.loc.loc) dest_rods += I
	if(!dest_rods.len)
		log_debug("ERROR CODE SD2: could not find any self-destruct rods")
		to_world(SPAN_DEBUG("ERROR CODE SD2: could not find any self-destruct rods"))
		QDEL_NULL(C)
		return FALSE
	dest_cooldown = SELF_DESTRUCT_ROD_STARTUP_TIME / dest_rods.len
	C.desc = "The main operating panel for a self-destruct system. It requires very little user input, but the final safety mechanism is manually unlocked.\nAfter the initial start-up sequence, [dest_rods.len] control rods must be armed, followed by manually flipping the detonation switch."

/**
 * This proc returns the ship's z level list (or whatever specified),
 * when an evac/self-destruct happens.
 */
/datum/authority/branch/evacuation/proc/get_affected_zlevels()
	//Nuke is not in progress, end the round on ship only.
	if(dest_status < NUKE_EXPLOSION_IN_PROGRESS && SSticker?.mode.is_in_endgame)
		. = SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP))
		return

//=========================================================================================
//=========================================================================================
//=====================================EVACUATION==========================================
//=========================================================================================
//=========================================================================================


/datum/authority/branch/evacuation/proc/initiate_evacuation(force=0) //Begins the evacuation procedure.
	if(force || (evac_status == EVACUATION_STATUS_STANDING_BY && !(flags_scuttle & FLAGS_EVACUATION_DENY)))
		evac_time = world.time
		evac_status = EVACUATION_STATUS_INITIATING
		marine_announcement("Внимание. Тревога. Всему персоналу немедленно эвакуироваться. У вас есть [round(EVACUATION_ESTIMATE_DEPARTURE/60,1)] минут перед отправлением.", "[MAIN_AI_SYSTEM]", 'sound/AI/evacuate.ogg')
		xeno_message_all("Волна адреналина прокатывается по обитателям улья. Эти мясные существа пытаются сбежать!")

		for(var/obj/structure/machinery/status_display/SD in machines)
			if(is_mainship_level(SD.z))
				SD.set_picture("evac")
		for(var/obj/docking_port/mobile/crashable/escape_shuttle/shuttle in SSshuttle.mobile)
			shuttle.prepare_evac()
		activate_lifeboats()
		process_evacuation()
		return TRUE

/datum/authority/branch/evacuation/proc/cancel_evacuation() //Cancels the evac procedure. Useful if admins do not want the marines leaving.
	if(evac_status == EVACUATION_STATUS_INITIATING)
		evac_time = null
		evac_status = EVACUATION_STATUS_STANDING_BY
		deactivate_lifeboats()
		marine_announcement("Эвакуация была отменена.", "[MAIN_AI_SYSTEM]", 'sound/AI/evacuate_cancelled.ogg')

		if(get_security_level() == "red")
			for(var/obj/structure/machinery/status_display/SD in machines)
				if(is_mainship_level(SD.z))
					SD.set_picture("redalert")

		for(var/obj/docking_port/mobile/crashable/escape_shuttle/shuttle in SSshuttle.mobile)
			shuttle.cancel_evac()
		return TRUE

/datum/authority/branch/evacuation/proc/begin_launch() //Launches the pods.
	if(evac_status == EVACUATION_STATUS_INITIATING)
		evac_status = EVACUATION_STATUS_IN_PROGRESS //Cannot cancel at this point. All shuttles are off.
		spawn() //One of the few times spawn() is appropriate. No need for a new proc.
			marine_announcement("ПРЕДУПРЕЖДЕНИЕ: Указ об эвакуации подтвержден. Запуск спасательных шлюпок.", "[MAIN_AI_SYSTEM]", 'sound/AI/evacuation_confirmed.ogg')
			addtimer(CALLBACK(src, PROC_REF(launch_lifeboats)), 10 SECONDS) // giving some time to board lifeboats

			for(var/obj/docking_port/mobile/crashable/escape_shuttle/shuttle in SSshuttle.mobile)
				shuttle.evac_launch()
				sleep(50)

			sleep(300) //Sleep 30 more seconds to make sure everyone had a chance to leave.
			var/lifesigns = 0
			// lifesigns += P.passengers
			var/obj/docking_port/mobile/crashable/lifeboat/lifeboat1 = SSshuttle.getShuttle(MOBILE_SHUTTLE_LIFEBOAT_PORT)
			lifeboat1.check_for_survivors()
			lifesigns += lifeboat1.survivors
			var/obj/docking_port/mobile/crashable/lifeboat/lifeboat2 = SSshuttle.getShuttle(MOBILE_SHUTTLE_LIFEBOAT_STARBOARD)
			lifeboat2.check_for_survivors()
			lifesigns += lifeboat2.survivors
			marine_announcement("ВНИМАНИЕ: Эвакуация завершена. Внешних признаков жизни: [lifesigns ? lifesigns  : "Ноль"].", "[MAIN_AI_SYSTEM]", 'sound/AI/evacuation_complete.ogg')
			evac_status = EVACUATION_STATUS_COMPLETE
		return TRUE

/datum/authority/branch/evacuation/proc/process_evacuation() //Process the timer.
	set background = 1

	spawn while(evac_status == EVACUATION_STATUS_INITIATING) //If it's not departing, no need to process.
		if(world.time >= evac_time + EVACUATION_AUTOMATIC_DEPARTURE) begin_launch()
		sleep(10) //One second.

/datum/authority/branch/evacuation/proc/get_status_panel_eta()
	switch(evac_status)
		if(EVACUATION_STATUS_INITIATING)
			var/eta = EVACUATION_ESTIMATE_DEPARTURE
			. = "[(eta / 60) % 60]:[add_zero(num2text(eta % 60), 2)]"
		if(EVACUATION_STATUS_IN_PROGRESS) . = "СЕЙЧАС"

// LIFEBOATS CORNER
/datum/authority/branch/evacuation/proc/activate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.status = LIFEBOAT_ACTIVE
			lifeboat_dock.open_dock()


/datum/authority/branch/evacuation/proc/deactivate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.status = LIFEBOAT_INACTIVE

/datum/authority/branch/evacuation/proc/launch_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.evac_launch()

//=========================================================================================
//=========================================================================================
//=====================================SELF DETRUCT========================================
//=========================================================================================
//=========================================================================================

/datum/authority/branch/evacuation/proc/enable_self_destruct(force=0)
	if(force || (dest_status == NUKE_EXPLOSION_INACTIVE && !(flags_scuttle & FLAGS_SELF_DESTRUCT_DENY)))
		if(!C)
			C = locate()
		if(!dest_rods)
			dest_rods = new
			for(var/obj/structure/machinery/self_destruct/rod/I in C.loc.loc) dest_rods += I
			dest_cooldown = SELF_DESTRUCT_ROD_STARTUP_TIME / dest_rods.len
		dest_status = NUKE_EXPLOSION_ACTIVE
		C.lock_or_unlock()
		dest_started_at = world.time
		set_security_level(SEC_LEVEL_DELTA) //also activate Delta alert, to open the SD shutters.
		spawn(0)
			for(var/obj/structure/machinery/door/poddoor/shutters/almayer/D in machines)
				if(D.id == "sd_lockdown")
					D.open()
		return TRUE

//Override is for admins bypassing normal player restrictions.
/datum/authority/branch/evacuation/proc/cancel_self_destruct(override)
	if(dest_status == NUKE_EXPLOSION_ACTIVE)
		var/obj/structure/machinery/self_destruct/rod/I
		var/i
		if(world.time >= dest_start_time + 3000 && dest_already_armed == 1 && !override) //Если пройден рубеж в 5 минут (но только после полноценного запуска) - пиздос
			C.state("<span class='warning'>ОШИБКА: Невозможно отменить операцию.</span>")
			return FALSE
		for(i in EvacuationAuthority.dest_rods)
			I = i
			if(I.active_state == SELF_DESTRUCT_MACHINE_ARMED && !override)
				C.state(SPAN_WARNING("ОШИБКА: Невозможно отменить операцию. Отключите все стержни."))
				return FALSE

		C.in_progress = 1
		dest_start_time = 0

		for(i in dest_rods)
			I = i
			if(I.active_state == SELF_DESTRUCT_MACHINE_ACTIVE || (I.active_state == SELF_DESTRUCT_MACHINE_ARMED && override)) I.lock_or_unlock(1)
		C.lock_or_unlock(1)
		dest_index = 1
		marine_announcement("Система аварийного самоуничтожения отключена.", "Система Самоуничтожения", 'sound/AI/selfdestruct_deactivated.ogg')
		xeno_message("Мне комфортнее. Устройство очищения отключили!")
		world << sound(null, repeat=0, wait=0, channel=SOUND_CHANNEL_SD)
		dest_already_armed = 0
		if(evac_status == EVACUATION_STATUS_STANDING_BY) //the evac has also been cancelled or was never started.
			set_security_level(SEC_LEVEL_RED, TRUE) //both SD and evac are inactive, lowering the security level.
		dest_status = NUKE_EXPLOSION_INACTIVE
		return TRUE

/datum/authority/branch/evacuation/proc/initiate_self_destruct(override)
	if(dest_status < NUKE_EXPLOSION_IN_PROGRESS)
		var/obj/structure/machinery/self_destruct/rod/I
		var/i
		for(i in dest_rods)
			I = i
		C.in_progress = !C.in_progress
		for(i in EvacuationAuthority.dest_rods)
			I = i
			I.in_progress = 1
		trigger_self_destruct(,,override)
		return TRUE

/datum/authority/branch/evacuation/proc/trigger_self_destruct(list/z_levels = SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP), origin = C, override = FALSE, end_type = NUKE_EXPLOSION_FINISHED, play_anim = TRUE, end_round = TRUE)
	set waitfor = 0
	if(dest_status < NUKE_EXPLOSION_IN_PROGRESS) //One more check for good measure, in case it's triggered through a bomb instead of the destruct mechanism/admin panel.
		dest_status = NUKE_EXPLOSION_IN_PROGRESS
//		playsound(origin, 'sound/machines/Alarm.ogg', 75, 0, 30)
//		world << pick('sound/theme/nuclear_detonation1.ogg','sound/theme/nuclear_detonation2.ogg')

		var/ship_status = 1
		for(var/i in z_levels)
			if(is_mainship_level(i))
				ship_status = 0 //Destroyed.
			break

		var/list/alive_mobs = list() //Everyone who will be destroyed on the zlevel(s).
		var/list/dead_mobs = list() //Everyone who only needs to see the cinematic.
		for(var/mob/current_mob as anything in GLOB.mob_list) //This only does something cool for the people about to die, but should prove pretty interesting.
			if(!current_mob || !current_mob.loc)
				continue //In case something changes when we sleep().
			if(current_mob.stat == DEAD)
				dead_mobs |= current_mob
				continue
			var/turf/current_turf = get_turf(current_mob)
			if(current_turf.z in z_levels)
				alive_mobs |= current_mob
				shake_camera(current_mob, 110, 4)


		/*Hardcoded for now, since this was never really used for anything else.
		Would ideally use a better system for showing cutscenes.*/
		var/atom/movable/screen/cinematic/explosion/C = new

		if(play_anim)
			for(var/mob/current_mob as anything in alive_mobs + dead_mobs)
				if(current_mob && current_mob.loc && current_mob.client)
					current_mob.client.add_to_screen(C)  //They may have disconnected in the mean time.

			sleep(15) //Extra 1.5 seconds to look at the ship.
			flick(override ? "intro_override" : "intro_nuke", C)
		sleep(35)
		for(var/mob/current_mob in alive_mobs)
			if(current_mob && current_mob.loc) //Who knows, maybe they escaped, or don't exist anymore.
				var/turf/current_mob_turf = get_turf(current_mob)
				if(current_mob_turf.z in z_levels)
					if(istype(current_mob.loc, /obj/structure/closet/secure_closet/freezer/fridge))
						continue
					current_mob.death(create_cause_data("nuclear explosion"))
				else
					if(play_anim)
						current_mob.client.remove_from_screen(C) //those who managed to escape the z level at last second shouldn't have their view obstructed.
		if(play_anim)
			flick(ship_status ? "ship_spared" : "ship_destroyed", C)
			C.icon_state = ship_status ? "summary_spared" : "summary_destroyed"
//		world << sound('sound/effects/explosionfar.ogg')
		dest_status = NUKE_EXPLOSION_INACTIVE

		if(end_round)
			dest_status = end_type

			sleep(5)
			if(SSticker.mode)
				SSticker.mode.check_win()
				world << sound('sound/misc/hell_march.ogg')

			if(!SSticker.mode) //Just a safety, just in case a mode isn't running, somehow.
				to_world(SPAN_ROUNDBODY("Перезапуск через 30 секунд!"))
				sleep(300)
				log_game("Перезагрузка из-за ядерного взрыва.")
				world.Reboot()
			return TRUE

/datum/authority/branch/evacuation/proc/process_self_destruct()
	set background = 1

	spawn while(C && C.loc && C.active_state == SELF_DESTRUCT_MACHINE_ARMED && dest_status == NUKE_EXPLOSION_ACTIVE && dest_index <= dest_rods.len)
		var/obj/structure/machinery/self_destruct/rod/I = dest_rods[dest_index]
		if(world.time >= dest_cooldown + I.activate_time)
			I.lock_or_unlock() //Unlock it.
			if(++dest_index <= dest_rods.len)
				I = dest_rods[dest_index]//Start the next sequence.
				I.activate_time = world.time
		sleep(10) //Checks every second. Could integrate into another controller for better tracking.

/datum/authority/branch/evacuation/proc/process_sd_ticking() //Новый процесс для постоянной активации. Через 10 минут после запуска автоматом взорвет помойку алмаер
	set background = 1

	spawn while(C && C.loc && C.active_state == SELF_DESTRUCT_MACHINE_ARMED && dest_status == NUKE_EXPLOSION_ACTIVE)
		if(world.time >= dest_start_time + 5970)
			initiate_self_destruct()
			return
		sleep(10)


//Generic parent base for the self_destruct items.
/obj/structure/machinery/self_destruct
	icon = 'icons/obj/structures/machinery/self_destruct.dmi'
	icon_state = "console_1"
	var/base_icon_state = "console"
	use_power = USE_POWER_NONE //Runs unpowered, may need to change later.
	density = FALSE
	anchored = TRUE //So it doesn't go anywhere.
	unslashable = TRUE
	unacidable = TRUE //Cannot C4 it either.
	var/in_progress = 0 //Cannot interact with while it's doing something, like an animation.
	var/active_state = SELF_DESTRUCT_MACHINE_INACTIVE //What step of the process it's on.

/obj/structure/machinery/self_destruct/New(mapload, ...)
	. = ..()
	icon_state = "[base_icon_state]_1"

/obj/structure/machinery/self_destruct/Destroy()
	. = ..()
	machines -= src
	operator = null

/obj/structure/machinery/self_destruct/ex_act(severity)
	return FALSE

/obj/structure/machinery/self_destruct/attack_hand()
	if(..() || in_progress) return FALSE //This check is backward, ugh.
	return TRUE

//Add sounds.
/obj/structure/machinery/self_destruct/proc/lock_or_unlock(lock)
	set waitfor = 0
	in_progress = 1
	flick("[base_icon_state]" + (lock? "_5" : "_2"),src)
	sleep(9)
	icon_state = "[base_icon_state]" + (lock? "_1" : "_3")
	in_progress = 0
	active_state = active_state > SELF_DESTRUCT_MACHINE_INACTIVE ? SELF_DESTRUCT_MACHINE_INACTIVE : SELF_DESTRUCT_MACHINE_ACTIVE

/obj/structure/machinery/self_destruct/console
	name = "self-destruct control panel"
	icon_state = "console_1"
	base_icon_state = "console"
	req_one_access = list(ACCESS_MARINE_CO, ACCESS_MARINE_SENIOR)

/obj/structure/machinery/self_destruct/console/Destroy()
	. = ..()
	EvacuationAuthority.C = null
	EvacuationAuthority.dest_rods = null

/obj/structure/machinery/self_destruct/console/lock_or_unlock(lock)
	playsound(src, 'sound/machines/hydraulics_1.ogg', 25, 1)
	..()

//TODO: Add sounds.
/obj/structure/machinery/self_destruct/console/attack_hand(mob/user)
	if(inoperable())
		return

	tgui_interact(user)

/obj/structure/machinery/self_destruct/console/attack_alien(mob/living/carbon/xenomorph) //Сука.
	if(isqueen(xenomorph))
		if(!do_after(usr, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			return
		to_chat(xenomorph, "<span class='warning'>Я взаимодействую с машиной и пытаюсь отключить устройство очищения.</span>")
		EvacuationAuthority.cancel_self_destruct()

/obj/structure/machinery/self_destruct/console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SelfDestructConsole", name)
		ui.open()

/obj/structure/machinery/sleep_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE


/obj/structure/machinery/self_destruct/console/ui_data(mob/user)
	var/list/data = list()

	data["dest_status"] = active_state

	return data

/obj/structure/machinery/self_destruct/console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("dest_start")
			to_chat(usr, SPAN_NOTICE("Нажимаю несколько кнопок на панели..."))
			to_chat(usr, SPAN_NOTICE("Да, система должна запустить механизм самоуничтожения."))
			playsound(src.loc, 'sound/items/rped.ogg', 25, TRUE)
			sleep(2 SECONDS)
			marine_announcement("Опасность. Система аварийного самоуничтожения активирована. Обратный отсчет - 20 минут до взрыва корабля.", "Система Самоуничтожения", 'sound/AI/selfdestruct.ogg')
			xeno_message("Очень дурное предчувствие. Эти создания пытаются запустить механизм очищения!")
			active_state = SELF_DESTRUCT_MACHINE_ARMED //Arm it here so the process can execute it later.
			var/obj/structure/machinery/self_destruct/rod/I = EvacuationAuthority.dest_rods[EvacuationAuthority.dest_index]
			I.activate_time = world.time
			EvacuationAuthority.process_self_destruct()
			. = TRUE

		if("dest_trigger")
			var/obj/structure/machinery/self_destruct/rod/I
			var/i
			for(i in EvacuationAuthority.dest_rods)
				I = i

			to_chat(usr, "<span class='notice'>Нажимаю несколько кнопок на панели...</span>")
			if(EvacuationAuthority.dest_already_armed != 0)
				to_chat(usr, "<span class='warning'>Система уже активирована.</span>")//"Неееет, ты не можешь запустить СД больше 2 раза!!!!!"
				return
			if(I.active_state != SELF_DESTRUCT_MACHINE_ARMED) //Все как в фильме. СД запустится только после активации всех стержней
				to_chat(usr, "<span class='warning'>ОШИБКА: Невозможно активировать систему. Пожалуйста, активируйте все стержни.</span>")
				EvacuationAuthority.dest_already_armed = 0
				return
			else
				to_chat(usr, "<span class='notice'>Система вот-вот запустит механизм самоуничтожения.</span>")
				marine_announcement("Тревога. Система аварийного самоуничтожения запущена. Обратный отсчет до уничтожения корабля - 10 минут. Обратный отсчет для отключения функции автоматического самоуничтожения - 5 минут.", "Система Самоуничтожения")
				xeno_message("Улей очень сильно беспокоится. Механизм очищения работает во всю!")
//				world << sound('sound/AI/ARES_Self_Destruct_10m_FULL.ogg', repeat = 0, wait = 0, volume = 70, channel = 666)
				world << sound('code/modules/carrotman2013/sounds/AI/selfdestruct.ogg', repeat=0,wait=0,volume=53,channel=SOUND_CHANNEL_SD)
				EvacuationAuthority.dest_start_time = world.time
				EvacuationAuthority.process_sd_ticking()
				EvacuationAuthority.dest_already_armed = 1
				EvacuationAuthority.spawn_sd_effects()
			. = TRUE

		if("dest_cancel")
			if(!allowed(usr))
				to_chat(usr, SPAN_WARNING("У меня нет необходимого доступа, чтобы отключить систему!"))
				return
			EvacuationAuthority.cancel_self_destruct()
			. = TRUE

/obj/structure/machinery/self_destruct/rod
	name = "self-destruct control rod"
	desc = "It is part of a complicated self-destruct sequence, but relatively simple to operate. Twist to arm or disarm."
	icon_state = "rod_1"
	base_icon_state = "rod"
	layer = BELOW_OBJ_LAYER
	var/activate_time

/obj/structure/machinery/self_destruct/rod/Destroy()
	. = ..()
	if(EvacuationAuthority && EvacuationAuthority.dest_rods)
		EvacuationAuthority.dest_rods -= src

/obj/structure/machinery/self_destruct/rod/lock_or_unlock(lock)
	playsound(src, 'sound/machines/hydraulics_2.ogg', 25, 1)
	..()
	if(lock)
		activate_time = null
		density = FALSE
		layer = initial(layer)
	else
		density = TRUE
		layer = ABOVE_OBJ_LAYER

/obj/structure/machinery/self_destruct/rod/attack_alien(mob/living/carbon/xenomorph/X) //Так как отключить СД можно только вырубив все стержни - логично дать квине возможность их вырубать. Nuff said.
	if(isqueen(X))
		if(world.time >= EvacuationAuthority.dest_start_time + 3000 && EvacuationAuthority.dest_already_armed == 1)
			to_chat(X, "<span class='notice'>Пытаюсь повернуть стержень, но он намертво впечатан в пол. Кажется пора сваливать.</span>")
			return
		else switch(active_state)
			if(SELF_DESTRUCT_MACHINE_ARMED)
				if(!do_after(usr, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
					return
				to_chat(X, "<span class='warning'>Я поворачиваю и отпускаю стержень, деактивируя его.</span>")
				playsound(src, 'sound/machines/switch.ogg', 25, 1)
				icon_state = "rod_3"
				active_state = SELF_DESTRUCT_MACHINE_ACTIVE
			if(SELF_DESTRUCT_MACHINE_ACTIVE)
				return

/obj/structure/machinery/self_destruct/rod/attack_hand(mob/user)
	if(..())
		if(world.time >= EvacuationAuthority.dest_start_time + 3000 && EvacuationAuthority.dest_already_armed == 1)
			to_chat(user, "<span class='notice'>Я пытаюсь повернуть стержень, но он намертво впечатан в пол. Кажется пора сваливать.</span>")
			return

		else switch(active_state)
			if(SELF_DESTRUCT_MACHINE_ACTIVE)
				to_chat(user, SPAN_NOTICE("Я поворачиваю и отпускаю стержень, активируя его."))
				playsound(src, 'sound/machines/switch.ogg', 25, 1)
				icon_state = "rod_4"
				active_state = SELF_DESTRUCT_MACHINE_ARMED
			if(SELF_DESTRUCT_MACHINE_ARMED)
				to_chat(user, SPAN_NOTICE("Я поворачиваю и отпускаю стержень, деактивируя его."))
				playsound(src, 'sound/machines/switch.ogg', 25, 1)
				icon_state = "rod_3"
				active_state = SELF_DESTRUCT_MACHINE_ACTIVE
			else to_chat(user, SPAN_WARNING("Стержень не готов."))
