#define WO_MAX_WAVE 15

//Global proc for checking if the game is whiskey outpost so I dont need to type if(gamemode == whiskey outpost) 50000 times
/proc/Check_WO()
	if(ticker.mode == "Whiskey Outpost" || map_tag == "Whiskey Outpost")
		return 1
	return 0

/datum/game_mode/whiskey_outpost
	name = "Whiskey Outpost"
	config_tag = "Whiskey Outpost"
	required_players 		= 0
	xeno_bypass_timer 		= 1
	role_instruction		= 1
	roles_for_mode = list(/datum/job/command/commander/whiskey,
					/datum/job/command/executive/whiskey,
					/datum/job/civilian/synthetic/whiskey,
					/datum/job/command/warrant/whiskey,
					/datum/job/command/bridge/whiskey,
					/datum/job/command/tank_crew/whiskey,
					/datum/job/command/police/whiskey,
					/datum/job/command/pilot/whiskey,
					/datum/job/logistics/requisition/whiskey,
					/datum/job/civilian/professor/whiskey,
					/datum/job/civilian/doctor/whiskey,
					/datum/job/civilian/researcher/whiskey,
					/datum/job/logistics/engineering/whiskey,
					/datum/job/logistics/tech/maint/whiskey,
					/datum/job/logistics/tech/cargo/whiskey,
					/datum/job/civilian/liaison/whiskey,
					/datum/job/marine/leader/equipped/whiskey,
					/datum/job/marine/specialist/equipped/whiskey,
					/datum/job/marine/smartgunner/equipped/whiskey,
					/datum/job/marine/medic/equipped/whiskey,
					/datum/job/marine/engineer/equipped/whiskey,
					/datum/job/marine/standard/equipped/whiskey
)


	latejoin_larva_drop = 0 //You never know

	//var/mob/living/carbon/human/Commander //If there is no Commander, marines wont get any supplies
	//No longer relevant to the game mode, since supply drops are getting changed.
	var/checkwin_counter = 0
	var/finished = 0
	var/has_started_timer = 10 //This is a simple timer so we don't accidently check win conditions right in post-game
	var/randomovertime = 0 //This is a simple timer so we can add some random time to the game mode.
	var/spawn_next_wave = MINUTES_10 / SECONDS_2 //Spawn first batch at ~10 minutes (we divide it by the game ticker time of 2 seconds)
	var/xeno_wave = 1 //Which wave is it

	var/wave_ticks_passed = 0 //Timer for xeno waves

	var/list/players = list()

	var/list/turf/xeno_spawns = list()
	var/list/turf/supply_spawns = list()

	//Who to spawn and how often which caste spawns
		//The more entires with same path, the more chances there are to pick it
			//This will get populated with spawn_xenos() proc
	var/list/spawnxeno = list()

	var/next_supply = MINUTES_1 //At which wave does the next supply drop come?

	var/ticks_passed = 0
	var/lobby_time = 0 //Lobby time does not count for marine 1h win condition
	var/wave_times_delayed = 0 //How many time was the current wave delayed due to pop limit?

	var/map_locale = 0 // 0 is Jungle Whiskey Outpost, 1 is Big Red Whiskey Outpost, 2 is Ice Colony Whiskey Outpost, 3 is space
	var/spawn_next_wo_wave = FALSE

	var/list/whiskey_outpost_waves = list()

/datum/game_mode/whiskey_outpost/announce()
	return 1

/datum/game_mode/whiskey_outpost/pre_setup()
	for(var/obj/effect/landmark/whiskey_outpost/xenospawn/X)
		xeno_spawns += X.loc
	for(var/obj/effect/landmark/whiskey_outpost/supplydrops/S)
		supply_spawns += S.loc


	//  WO waves
	var/list/paths = typesof(/datum/whiskey_outpost_wave) - /datum/whiskey_outpost_wave - /datum/whiskey_outpost_wave/random
	for(var/i in 1 to WO_MAX_WAVE)
		whiskey_outpost_waves += i
		whiskey_outpost_waves[i] = list()
	for(var/T in paths)
		var/datum/whiskey_outpost_wave/WOW = new T
		if(WOW.wave_number > 0)
			whiskey_outpost_waves[WOW.wave_number] += WOW

	return 1

/datum/game_mode/whiskey_outpost/post_setup()
	set waitfor = 0
	update_controllers()
	initialize_post_marine_gear_list()
	lobby_time = world.time
	randomovertime = pickovertime()
	var/mob/M
	for(var/obj/effect/landmark/start/S in world)
		if(!istype(S, /obj/effect/landmark/start/whiskey))
			qdel(S)

	if(config) config.remove_gun_restrictions = 1

	for(M in mob_list)
		if(M.client && istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			players += H
			if(H.job in ROLES_MARINES)
				spawn_player(H)
	sleep(10)
	to_world("<span class='round_header'>The current game mode is - WHISKEY OUTPOST!</span>")
	to_world(SPAN_ROUNDBODY("It is the year [game_year - 5] on the planet LV-624, five years before the arrival of the USS Almayer and the 7th 'Falling Falcons' Battalion in the sector"))
	to_world(SPAN_ROUNDBODY("The 3rd 'Dust Raiders' Battalion is charged with establishing a USCM prescence in the Tychon's Rift sector"))
	to_world(SPAN_ROUNDBODY("[map_tag], one of the Dust Raider bases being established in the sector, has come under attack from unrecognized alien forces"))
	to_world(SPAN_ROUNDBODY("With casualties mounting and supplies running thin, the Dust Raiders at [map_tag] must survive for an hour to alert the rest of their battalion in the sector"))
	to_world(SPAN_ROUNDBODY("Hold out for as long as you can."))
	world << sound('sound/effects/siren.ogg')

	sleep(10)
	switch(map_locale) //Switching it up.
		if(0)
			marine_announcement("This is Captain Hans Naiche, commander of the 3rd Battalion 'Dust Raiders' forces here on LV-624. In our attempts to establish a base on this planet, several of our patrols were wiped out by hostile creatures.  We're setting up a distress call, but we need you to hold [map_tag] in order for our engineers to set up the relay. We're prepping several M402 mortar units to provide fire support. If they overrun your positon, we will be wiped out with no way to call for help. Hold the line or we all die.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")

/datum/game_mode/whiskey_outpost/proc/update_controllers()
	//Update controllers while we're on this mode
	if(SSitem_cleanup)
		//Cleaning stuff more aggresively
		SSitem_cleanup.start_processing_time = 0
		SSitem_cleanup.percentage_of_garbage_to_delete = 1.0
		SSitem_cleanup.wait = MINUTES_1
		SSitem_cleanup.next_fire = MINUTES_1
		spawn(0)
			//Deleting Almayer, for performance!
			SSitem_cleanup.delete_almayer()
	if(SSdefcon)
		//Don't need DEFCON
		SSdefcon.wait = MINUTES_30
	if(SSxenocon)
		//Don't need XENOCON
		SSxenocon.wait = MINUTES_30


//PROCCESS
/datum/game_mode/whiskey_outpost/process()
	. = ..()
	checkwin_counter++
	ticks_passed++
	wave_ticks_passed++

	if(wave_ticks_passed >= spawn_next_wave)
		if(count_xenos() < 50)//Checks braindead too, so we don't overpopulate! Also make sure its less than twice us in the world, so we advance waves/get more xenos the more marines survive.
			wave_ticks_passed = 0
			spawn_next_wo_wave = TRUE
		else
			wave_ticks_passed -= 50 //Wait 50 ticks and try again
			wave_times_delayed++

	if(spawn_next_wo_wave)
		spawn_next_xeno_wave()

	if(has_started_timer > 0) //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.
		has_started_timer--

	if(world.time > next_supply)
		place_whiskey_outpost_drop()
		next_supply += MINUTES_2

	if(checkwin_counter >= 10) //Only check win conditions every 10 ticks.
		if(!finished && round_should_check_for_win)
			check_win()
		checkwin_counter = 0
	return 0

/datum/game_mode/whiskey_outpost/proc/spawn_next_xeno_wave()
	spawn_next_wo_wave = FALSE
	var/wave = pick(whiskey_outpost_waves[xeno_wave])
	spawn_whiskey_outpost_xenos(wave)
	announce_xeno_wave(wave)
	if(xeno_wave == 7)
		//Wave when Marines get reinforcements!
		get_specific_call("Marine Reinforcements (Squad)", TRUE, FALSE)
	xeno_wave = min(xeno_wave + 1, WO_MAX_WAVE)


/datum/game_mode/whiskey_outpost/proc/announce_xeno_wave(var/datum/whiskey_outpost_wave/wave_data)
	if(!istype(wave_data))
		return
	if(wave_data.command_announcement.len > 0)
		marine_announcement(wave_data.command_announcement[1], wave_data.command_announcement[2])
	if(wave_data.sound_effect.len > 0)
		playsound_z(SURFACE_Z_LEVEL, pick(wave_data.sound_effect))

//CHECK WIN
/datum/game_mode/whiskey_outpost/check_win()
	var/C = count_humans_and_xenos(SURFACE_Z_LEVELS)

	if(C[1] == 0)
		finished = 1 //Alien win
	else if(world.time > HOURS_1 + MINUTES_20 + lobby_time + initial(spawn_next_wave) + randomovertime)//one hour or so, plus lobby time, plus the setup time marines get
		finished = 2 //Marine win

/datum/game_mode/whiskey_outpost/proc/disablejoining()
	enter_allowed = 0
	to_world("<B>New players may no longer join the game.</B>")
	message_admins("wave one disabled new player game joining.")
	world.update_status()

/datum/game_mode/whiskey_outpost/count_xenos()//Counts braindead too
	var/xeno_count = 0
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X) //Prevent any runtime errors
			if(X.z == 1 && !istype(X.loc,/turf/open/space)) // If they're connected/unghosted and alive and not debrained
				xeno_count += 1 //Add them to the amount of people who're alive.

	return xeno_count

/datum/game_mode/whiskey_outpost/proc/pickovertime()
	var/randomtime = ((rand(0,6)+rand(0,6)+rand(0,6)+rand(0,6))*SECONDS_50)
	var/maxovertime = MINUTES_20
	if (randomtime >= maxovertime)
		return maxovertime
	return randomtime

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/whiskey_outpost/check_finished()
	if(finished != 0)
		return 1

	return 0

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/whiskey_outpost/declare_completion()
	if(round_statistics)
		round_statistics.track_round_end()
	if(finished == 1)
		log_game("Round end result - xenos won")
		to_world("<span class='round_header'>The Xenos have succesfully defended their hive from colonization.</span>")
		to_world(SPAN_ROUNDBODY("Well done, you've secured LV-624 for the hive!"))
		to_world(SPAN_ROUNDBODY("It will be another five years before the USCM returns to the Tychon's Rift sector, with the arrival of the 7th 'Falling Falcons' Battalion and the USS Almayer."))
		to_world(SPAN_ROUNDBODY("The xenomorph hive on LV-624 remains unthreatened until then.."))
		world << sound('sound/misc/Game_Over_Man.ogg')
		if(round_statistics)
			round_statistics.round_result = MODE_INFESTATION_X_MAJOR

	else if(finished == 2)
		log_game("Round end result - marines won")
		to_world("<span class='round_header'>Against the onslaught, the marines have survived.</span>")
		to_world(SPAN_ROUNDBODY("The signal rings out to the USS Alistoun, and Dust Raiders stationed elsewhere in Tychon's Rift begin to converge on LV-624."))
		to_world(SPAN_ROUNDBODY("Eventually, the Dust Raiders secure LV-624 and the entire Tychon's Rift sector in 2182, pacifiying it and establishing peace in the sector for decades to come."))
		to_world(SPAN_ROUNDBODY("The USS Almayer and the 7th 'Falling Falcons' Battalion are never sent to the sector and are spared their fate in 2186."))
		world << sound('sound/misc/hell_march.ogg')
		if(round_statistics)
			round_statistics.round_result = MODE_INFESTATION_M_MAJOR

	else
		log_game("Round end result - no winners")
		to_world("<span class='round_header'>NOBODY WON!</span>")
		to_world(SPAN_ROUNDBODY("How? Don't ask me..."))
		world << 'sound/misc/sadtrombone.ogg'
		if(round_statistics)
			round_statistics.round_result = MODE_INFESTATION_DRAW_DEATH

	if(round_statistics)
		round_statistics.game_mode = name
		round_statistics.round_length = world.time
		round_statistics.end_round_player_population = clients.len

		round_statistics.log_round_statistics()

		round_finished = 1
	return 1

/datum/game_mode/proc/auto_declare_completion_whiskey_outpost()
	return

/datum/game_mode/whiskey_outpost/proc/place_whiskey_outpost_drop(var/OT = "sup") //Art revamping spawns 13JAN17
	var/turf/T = pick(supply_spawns)
	var/randpick
	var/list/randomitems = list()
	var/list/spawnitems = list()
	var/choosemax
	var/obj/structure/closet/crate/crate

	if(isnull(OT) || OT == "")
		OT = "sup" //no breaking anything.

	else if (OT == "sup")
		randpick = rand(0,50)
		switch(randpick)
			if(0 to 5)//Marine Gear 10% Chance.
				crate = new /obj/structure/closet/crate/secure/gear(T)
				choosemax = rand(5,10)
				randomitems = list(/obj/item/clothing/head/helmet/marine,
								/obj/item/clothing/head/helmet/marine,
								/obj/item/clothing/head/helmet/marine,
								/obj/item/clothing/suit/storage/marine,
								/obj/item/clothing/suit/storage/marine,
								/obj/item/clothing/suit/storage/marine,
								/obj/item/clothing/head/helmet/marine/tech,
								/obj/item/clothing/head/helmet/marine/medic,
								/obj/item/clothing/under/marine/medic,
								/obj/item/clothing/under/marine/engineer,
								/obj/effect/landmark/wo_supplies/storage/webbing,
								/obj/item/device/binoculars)

			if(6 to 10)//Lights and shiet 10%
				new /obj/structure/largecrate/supply/floodlights(T)
				new /obj/structure/largecrate/supply/supplies/flares(T)


			if(11 to 13) //6% Chance to drop this !FUN! junk.
				crate = new /obj/structure/closet/crate/secure/gear(T)
				spawnitems = list(/obj/item/storage/belt/utility/full,
									/obj/item/storage/belt/utility/full,
									/obj/item/storage/belt/utility/full,
									/obj/item/storage/belt/utility/full)

			if(14 to 18)//Materials 10% Chance.
				crate = new /obj/structure/closet/crate/secure/gear(T)
				choosemax = rand(3,8)
				randomitems = list(/obj/item/stack/sheet/metal,
								/obj/item/stack/sheet/metal,
								/obj/item/stack/sheet/metal,
								/obj/item/stack/sheet/plasteel,
								/obj/item/stack/sandbags_empty/half,
								/obj/item/stack/sandbags_empty/half,
								/obj/item/stack/sandbags_empty/half)

			if(19 to 20)//Blood Crate 4% chance
				crate = new /obj/structure/closet/crate/medical(T)
				spawnitems = list(/obj/item/reagent_container/blood/OMinus,
								/obj/item/reagent_container/blood/OMinus,
								/obj/item/reagent_container/blood/OMinus,
								/obj/item/reagent_container/blood/OMinus,
								/obj/item/reagent_container/blood/OMinus)

			if(21 to 25)//Advanced meds Crate 10%
				crate = new /obj/structure/closet/crate/medical(T)
				spawnitems = list(/obj/item/storage/firstaid/fire,
								/obj/item/storage/firstaid/regular,
								/obj/item/storage/firstaid/toxin,
								/obj/item/storage/firstaid/o2,
								/obj/item/storage/firstaid/adv,
								/obj/item/bodybag/cryobag,
								/obj/item/bodybag/cryobag,
								/obj/item/storage/belt/medical/lifesaver/full,
								/obj/item/storage/belt/medical/lifesaver/full,
								/obj/item/clothing/glasses/hud/health,
								/obj/item/clothing/glasses/hud/health,
								/obj/item/device/defibrillator)

			if(26 to 30)//Random Medical Items 10% as well. Made the list have less small junk
				crate = new /obj/structure/closet/crate/medical(T)
				spawnitems = list(/obj/item/storage/belt/medical/lifesaver/full,
								/obj/item/storage/belt/medical/lifesaver/full,
								/obj/item/storage/belt/medical/lifesaver/full,
								/obj/item/storage/belt/medical/lifesaver/full,
								/obj/item/storage/belt/medical/lifesaver/full)

			if(31 to 35)//Random explosives Crate 10% because the lord commeth and said let there be explosives.
				crate = new /obj/structure/closet/crate/ammo(T)
				choosemax = rand(1,5)
				randomitems = list(/obj/item/storage/box/explosive_mines,
								/obj/item/storage/box/explosive_mines,
								/obj/item/explosive/grenade/HE/m15,
								/obj/item/explosive/grenade/HE/m15,
								/obj/item/explosive/grenade/HE,
								/obj/item/storage/box/nade_box
								)
			if(36 to 40) // Junk
				crate = new /obj/structure/closet/crate/ammo(T)
				spawnitems = list(
									/obj/item/attachable/heavy_barrel,
									/obj/item/attachable/heavy_barrel,
									/obj/item/attachable/heavy_barrel,
									/obj/item/attachable/heavy_barrel)

			if(40 to 48)//Weapon + supply beacon drop. 6%
				crate = new /obj/structure/closet/crate/ammo(T)
				spawnitems = list(/obj/item/device/whiskey_supply_beacon,
								/obj/item/device/whiskey_supply_beacon,
								/obj/item/device/whiskey_supply_beacon,
								/obj/item/device/whiskey_supply_beacon)

			if(49 to 50)//Rare weapons. Around 4%
				crate = new /obj/structure/closet/crate/ammo(T)
				spawnitems = list(/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aap,
								/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aapmag,
								/obj/effect/landmark/wo_supplies/ammo/box/rare/m41aextend,
								/obj/effect/landmark/wo_supplies/ammo/box/rare/smgap,
								/obj/effect/landmark/wo_supplies/ammo/box/rare/smgextend)
	if(crate)
		crate.storage_capacity = 60

	if(randomitems.len)
		for(var/i = 0; i < choosemax; i++)
			var/path = pick(randomitems)
			var/obj/I = new path(crate)
			if(OT == "sup")
				if(I && istype(I,/obj/item/stack/sheet/mineral/phoron) || istype(I,/obj/item/stack/rods) || istype(I,/obj/item/stack/sheet/glass) || istype(I,/obj/item/stack/sheet/metal) || istype(I,/obj/item/stack/sheet/plasteel) || istype(I,/obj/item/stack/sheet/wood))
					I:amount = rand(30,50) //Give them more building materials.
				if(I && istype(I,/obj/structure/machinery/floodlight))
					I.anchored = 0


	else
		if(crate)
			for(var/path in spawnitems)
				new path(crate)

//Whiskey Outpost Recycler Machine. Teleports objects to centcomm so it doesnt lag
/obj/structure/machinery/wo_recycler
	icon = 'icons/obj/structures/machinery/recycling.dmi'
	icon_state = "grinder-o0"
	var/icon_on = "grinder-o1"

	name = "Recycler"
	desc = "Instructions: Place objects you want to destroy on top of it and use the machine. Use with care"
	density = 0
	anchored = 1
	unslashable = TRUE
	unacidable = TRUE
	var/working = 0

	attack_hand(mob/user)
		if(inoperable(MAINT))
			return
		if(user.lying || user.stat)
			return
		if(ismaintdrone(usr) || \
			istype(usr, /mob/living/carbon/Xenomorph))
			to_chat(usr, SPAN_DANGER("You don't have the dexterity to do this!"))
			return
		if(working)
			to_chat(user, SPAN_DANGER("Wait for it to recharge first."))
			return

		var/remove_max = 10
		var/turf/T = src.loc
		if(T)
			to_chat(user, SPAN_DANGER("You turn on the recycler."))
			var/removed = 0
			for(var/i, i < remove_max, i++)
				for(var/obj/O in T)
					if(istype(O,/obj/structure/closet/crate))
						var/obj/structure/closet/crate/C = O
						if(C.contents.len)
							to_chat(user, SPAN_DANGER("[O] must be emptied before it can be recycled"))
							continue
						new /obj/item/stack/sheet/metal(get_step(src,dir))
						O.loc = get_turf(locate(84,237,2)) //z.2
//						O.loc = get_turf(locate(30,70,1)) //z.1
						removed++
						break
					else if(istype(O,/obj/item))
						var/obj/item/I = O
						if(I.anchored)
							continue
						O.loc = get_turf(locate(84,237,2)) //z.2
//						O.loc = get_turf(locate(30,70,1)) //z.1
						removed++
						break
				for(var/mob/M in T)
					if(istype(M,/mob/living/carbon/Xenomorph))
						var/mob/living/carbon/Xenomorph/X = M
						if(!X.stat == DEAD)
							continue
						X.loc = get_turf(locate(84,237,2)) //z.2
//						X.loc = get_turf(locate(30,70,1)) //z.1
						removed++
						break
				if(removed && !working)
					playsound(loc, 'sound/effects/meteorimpact.ogg', 25, 1)
					working = 1 //Stops the sound from repeating
				if(removed >= remove_max)
					break

		working = 1
		spawn(100)
			working = 0

	ex_act(severity)
		return


////////////////////
//Art's Additions //
////////////////////

/////////////////////////////////////////
// Whiskey Outpost V2 Standard Edition //
/////////////////////////////////////////

////////////////////////////////////////////////////////////
//Supply drops for Whiskey Outpost via SLs
//These will come in the form of ammo drops. Will have probably like 5 settings? SLs will get a few of them.
//Should go: Regular ammo, Spec Rocket Ammo, Spec Smartgun ammo, Spec Sniper ammo, and then explosives (grenades for grenade spec).
//This should at least give SLs the ability to rearm their squad at the frontlines.

/obj/item/device/whiskey_supply_beacon //Whiskey Outpost Supply beacon. Might as well reuse the IR target beacon (Time to spook the fucking shit out of people.)
	name = "ASB beacon"
	desc = "Ammo Supply Beacon, it has 5 different settings for different supplies. Look at your weapons verb tab to be able to switch ammo drops."
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "ir_beacon"
	w_class = SIZE_SMALL
	var/activated = 0
	var/icon_activated = "ir_beacon_active"
	var/supply_drop = 0 //0 = Regular ammo, 1 = Rocket, 2 = Smartgun, 3 = Sniper, 4 = Explosives + GL

/obj/item/device/whiskey_supply_beacon/attack_self(mob/user)
	if(!ishuman(user)) return
	if(!user.mind)
		to_chat(user, "It doesn't seem to do anything for you.")
		return

	playsound(src,'sound/machines/click.ogg', 15, 1)

	var/list/supplies = list(
		"10x24mm, slugs, buckshot, and 10x20mm rounds",
		"Explosives and grenades",
		"Rocket ammo",
		"Sniper ammo",
		"Pyrotechnician tanks",
		"Scout ammo",
		"Smartgun ammo",
	)

	var/supply_drop_choice = input(user, "Which supplies to call down?") as null|anything in supplies

	switch(supply_drop_choice)
		if("10x24mm, slugs, buckshot, and 10x20mm rounds")
			supply_drop = 0
			to_chat(usr, SPAN_NOTICE("10x24mm, slugs, buckshot, and 10x20mm rounds will now drop!"))
		if("Rocket ammo")
			supply_drop = 1
			to_chat(usr, SPAN_NOTICE("Rocket ammo will now drop!"))
		if("Smartgun ammo")
			supply_drop = 2
			to_chat(usr, SPAN_NOTICE("Smartgun ammo will now drop!"))
		if("Sniper ammo")
			supply_drop = 3
			to_chat(usr, SPAN_NOTICE("Sniper ammo will now drop!"))
		if("Explosives and grenades")
			supply_drop = 4
			to_chat(usr, SPAN_NOTICE("Explosives and grenades will now drop!"))
		if("Pyrotechnician tanks")
			supply_drop = 5
			to_chat(usr, SPAN_NOTICE("Pyrotechnician tanks will now drop!"))
		if("Scout ammo")
			supply_drop = 6
			to_chat(usr, SPAN_NOTICE("Scout ammo will now drop!"))
		else
			return

	if(activated)
		to_chat(user, "Toss it to get supplies!")
		return

	if(user.z != 1)
		to_chat(user, "You have to be on the ground to use this or it won't transmit.")
		return

	activated = 1
	anchored = 1
	w_class = 10
	icon_state = "[icon_activated]"
	playsound(src, 'sound/machines/twobeep.ogg', 15, 1)
	to_chat(user, "You activate the [src]. Now toss it, the supplies will arrive in a moment!")

	var/mob/living/carbon/C = user
	if(istype(C) && !C.throw_mode)
		C.toggle_throw_mode(THROW_MODE_NORMAL)

	sleep(100) //10 seconds should be enough.
	var/turf/T = get_turf(src) //Make sure we get the turf we're tossing this on.
	drop_supplies(T, supply_drop)
	playsound(src,'sound/effects/bamf.ogg', 50, 1)
	qdel(src)
	return

/obj/item/device/whiskey_supply_beacon/proc/drop_supplies(var/turf/T,var/SD)
	if(!istype(T)) return
	var/list/spawnitems = list()
	var/obj/structure/closet/crate/crate
	crate = new /obj/structure/closet/crate/secure/weapon(T)
	switch(SD)
		if(0) // Alright 2 mags for the SL, a few mags for M41As that people would need. M39s get some love and split the shotgun load between slugs and buckshot.
			spawnitems = list(/obj/item/ammo_magazine/rifle/m41aMK1,
							/obj/item/ammo_magazine/rifle/m41aMK1,
							/obj/item/ammo_magazine/rifle,
							/obj/item/ammo_magazine/rifle,
							/obj/item/ammo_magazine/rifle,
							/obj/item/ammo_magazine/rifle/ap,
							/obj/item/ammo_magazine/smg/m39,
							/obj/item/ammo_magazine/smg/m39,
							/obj/item/ammo_magazine/smg/m39/ap,
							/obj/item/ammo_magazine/smg/m39/ap,
							/obj/item/ammo_magazine/shotgun/slugs,
							/obj/item/ammo_magazine/shotgun/buckshot)
		if(1) // Six rockets should be good. Tossed in two AP rockets for possible late round fighting.
			spawnitems = list(/obj/item/ammo_magazine/rocket,
							/obj/item/ammo_magazine/rocket,
							/obj/item/ammo_magazine/rocket,
							/obj/item/ammo_magazine/rocket,
							/obj/item/ammo_magazine/rocket,
							/obj/item/ammo_magazine/rocket,
							/obj/item/ammo_magazine/rocket,
							/obj/item/ammo_magazine/rocket,
							/obj/item/ammo_magazine/rocket/ap,
							/obj/item/ammo_magazine/rocket/ap,
							/obj/item/ammo_magazine/rocket/ap,
							/obj/item/ammo_magazine/rocket/wp,
							/obj/item/ammo_magazine/rocket/wp,
							/obj/item/ammo_magazine/rocket/wp)
		if(2) //Smartgun supplies
			spawnitems = list(
					/obj/item/cell/high,
					/obj/item/ammo_magazine/smartgun,
					/obj/item/ammo_magazine/smartgun,
					/obj/item/ammo_magazine/smartgun,
				)
		if(3) //Full Sniper ammo loadout.
			spawnitems = list(/obj/item/ammo_magazine/sniper,
							/obj/item/ammo_magazine/sniper,
							/obj/item/ammo_magazine/sniper,
							/obj/item/ammo_magazine/sniper/incendiary,
							/obj/item/ammo_magazine/sniper/flak)
		if(4) // Give them explosives + Grenades for the Grenade spec. Might be too many grenades, but we'll find out.
			spawnitems = list(/obj/item/storage/box/explosive_mines,
							/obj/item/storage/belt/grenade/full)
		if(5) // Pyrotech
			var/fuel = pick(/obj/item/ammo_magazine/flamer_tank/large/B, /obj/item/ammo_magazine/flamer_tank/large/X)
			spawnitems = list(/obj/item/ammo_magazine/flamer_tank/large,
							/obj/item/ammo_magazine/flamer_tank/large,
							fuel)
		if(6) // Scout
			spawnitems = list(/obj/item/ammo_magazine/rifle/m4ra,
							/obj/item/ammo_magazine/rifle/m4ra,
							/obj/item/ammo_magazine/rifle/m4ra/incendiary,
							/obj/item/ammo_magazine/rifle/m4ra/impact)
	crate.storage_capacity = 60
	for(var/path in spawnitems)
		new path(crate)

/obj/item/storage/box/attachments
	name = "attachment package"
	desc = "A package containing some random attachments. Why not see what's inside?"
	icon_state = "circuit"
	w_class = SIZE_TINY
	can_hold = list()
	storage_slots = 3
	max_w_class = 0
	foldable = null
	var/list/common = list(/obj/item/attachable/suppressor, /obj/item/attachable/bayonet, /obj/item/attachable/flashlight)
	var/list/attachment_1 = list(/obj/item/attachable/reddot, /obj/item/attachable/burstfire_assembly, /obj/item/attachable/lasersight,
								/obj/item/attachable/extended_barrel,/obj/item/attachable/verticalgrip, /obj/item/attachable/angledgrip,
								/obj/item/attachable/gyro, /obj/item/attachable/bipod)
	var/list/attachment_2 = list(/obj/item/attachable/stock/smg, /obj/item/attachable/stock/shotgun, /obj/item/attachable/stock/rifle, /obj/item/attachable/magnetic_harness,
								/obj/item/attachable/quickfire, /obj/item/attachable/heavy_barrel, /obj/item/attachable/scope, /obj/item/attachable/quickfire,
								/obj/item/attachable/scope/mini)

/obj/item/storage/box/attachments/New()
	..()
	Pick_Contents()

/obj/item/storage/box/attachments/proc/Pick_Contents()
	var/a1 = pick(common)
	var/a2 = pick(attachment_1)
	var/a3 = pick(attachment_2)
	if(a1) new a1 (src)
	if(a2) new a2 (src)
	if(a3) new a3 (src)
	return

/obj/item/storage/box/attachments/update_icon()
	if(!contents.len)
		var/turf/T = get_turf(src)
		if(T)
			new /obj/item/paper/crumpled(T)
		qdel(src)

