#define WO_SPAWN_MULTIPLIER 1.0
#define WO_SCALED_WAVE 1
#define WO_STATIC_WAVE 2

//SPAWN XENOS
/proc/spawn_whiskey_outpost_xenos(var/datum/whiskey_outpost_wave/wave_data)
	var/datum/game_mode/whiskey_outpost/wo_game_mode
	if(istype(ticker.mode,/datum/game_mode/whiskey_outpost))
		wo_game_mode = ticker.mode
	else
		return
	if(!istype(wave_data))
		return
	var/turf/picked
	var/list/xeno_spawn_loc = list()
	var/datum/hive_status/hive = hive_datum[XENO_HIVE_NORMAL]
	if(hive.slashing_allowed != 1)
		hive.slashing_allowed = 1 //Allows harm intent for aliens
	var/xenos_to_spawn
	if(wave_data.wave_type == WO_SCALED_WAVE)
		xenos_to_spawn = max(wo_game_mode.count_marines(SURFACE_Z_LEVELS),5) * wave_data.scaling_factor * WO_SPAWN_MULTIPLIER
	else
		xenos_to_spawn = wave_data.number_of_xenos

	xeno_spawn_loc = wo_game_mode.xeno_spawns.Copy()

	wo_game_mode.spawn_next_wave = wave_data.wave_delay

	var/xeno_type
	var/mob/living/carbon/Xenomorph/new_xeno
	if(wave_data.wave_number == 1)
		call(/datum/game_mode/whiskey_outpost/proc/disablejoining)()
	while(xenos_to_spawn-- > 0)
		if(xeno_spawn_loc.len <= 0)
			break // no spawn points left
		picked = pick(xeno_spawn_loc)
		xeno_spawn_loc -= picked
		xeno_type = pick(wave_data.wave_castes)
		new_xeno = new xeno_type(picked)
		new_xeno.away_timer = 300 //So ghosts can join instantly
		new_xeno.flags_pass = NO_FLAGS
		new_xeno.nocrit(wave_data.wave_number)

/datum/whiskey_outpost_wave
	var/wave_number = 1
	var/list/wave_castes = list()
	var/wave_type = WO_SCALED_WAVE
	var/scaling_factor = 1.0
	var/number_of_xenos = 0 // not used for scaled waves
	var/wave_delay = 250
	var/list/sound_effect = list('sound/voice/alien_distantroar_3.ogg','sound/voice/xenos_roaring.ogg', 'sound/voice/4_xeno_roars.ogg')
	var/list/command_announcement = list()

/datum/whiskey_outpost_wave/wave1
	wave_number = 1
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner)
	sound_effect = list('sound/effects/siren.ogg')
	command_announcement = list("We're tracking the creatures that wiped out our patrols heading towards your outpost.. Stand-by while we attempt to establish a signal with the USS Alistoun to alert them of these creatures.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")
	scaling_factor = 0.3

/datum/whiskey_outpost_wave/wave2
	wave_number = 2
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Sentinel)
	scaling_factor = 0.4

/datum/whiskey_outpost_wave/wave3 //Tier II versions added, but rare
	wave_number = 3
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender)
	scaling_factor = 0.6

/datum/whiskey_outpost_wave/wave4 //Tier II more common
	wave_number = 4
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner/mature,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Sentinel/mature,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone)
	scaling_factor = 0.7

/datum/whiskey_outpost_wave/wave5 //Reset the spawns	so we don't drown in xenos again.
	wave_number = 5
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner/mature,
					/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Sentinel/mature,
					/mob/living/carbon/Xenomorph/Sentinel/elite,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone)
	scaling_factor = 0.8

/datum/whiskey_outpost_wave/wave6 //Tier II more common
	wave_number = 6
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner/mature,
					/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Sentinel/mature,
					/mob/living/carbon/Xenomorph/Sentinel/elite,
					/mob/living/carbon/Xenomorph/Lurker/mature,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter/mature,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior)
	scaling_factor = 0.9

/datum/whiskey_outpost_wave/wave7
	wave_number = 7
	wave_type = WO_STATIC_WAVE
	number_of_xenos = 0
	command_announcement = list("Major Ike Saker speaking, The Captain is still trying to try and get off world contact. An engineer platoon managed to destroy the main entrance into this valley this should give you a short break while the aliens find another way in. I have also recieved word that the 7th 'Falling Falcons' Battalion. Should be near. I used to be stationed with them they are top notch!", "Major Ike Saker, 3rd Battalion Command, LV-624 Garrison")
	wave_delay = 500

/datum/whiskey_outpost_wave/wave8
	wave_number = 8
	wave_castes = list(/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior)
	wave_delay = 250 //Slow down now, strong castes introduced next wave
	sound_effect = list()
	command_announcement = list("Captain Naiche speaking, we've been unsuccessful in establishing offworld communication for the moment. We're prepping our M402 mortars to destroy the inbound xeno force on the main road. Standby for fire support.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")

/datum/whiskey_outpost_wave/wave9 //Ravager and Praetorian Added, Tier II more common, Tier I less common
	wave_number = 9
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner/mature,
					/mob/living/carbon/Xenomorph/Runner/mature,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker/mature,
					/mob/living/carbon/Xenomorph/Lurker/mature,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter/mature,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender/mature,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Drone/mature,
					/mob/living/carbon/Xenomorph/Warrior)
	wave_delay = 250 //Speed it up again. After the period of grace.
	sound_effect = list('sound/voice/alien_queen_command.ogg')
	command_announcement = list("Our garrison forces are reaching seventy percent casualties, we are losing our grip on LV-624. It appears that vanguard of the hostile force is still approaching, and most of the other Dust Raider platoons have been shattered. We're counting on you to keep holding.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")

/datum/whiskey_outpost_wave/wave10
	wave_number = 10
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner/mature,
					/mob/living/carbon/Xenomorph/Runner/mature,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker/mature,
					/mob/living/carbon/Xenomorph/Lurker/mature,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter/mature,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender/mature,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Drone/mature,
					/mob/living/carbon/Xenomorph/Warrior)
	wave_delay = 250 //Speed it up again. After the period of grace.

/datum/whiskey_outpost_wave/wave11
	wave_number = 11
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker/elite,
					/mob/living/carbon/Xenomorph/Lurker/elite,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter/elite,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender/elite,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Drone/elite,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Warrior/mature)

/datum/whiskey_outpost_wave/wave12
	wave_number = 12
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker/elite,
					/mob/living/carbon/Xenomorph/Lurker/elite,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter/elite,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender/elite,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Drone/elite,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Warrior/mature,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Ravager/mature,
					/mob/living/carbon/Xenomorph/Praetorian,
					/mob/living/carbon/Xenomorph/Praetorian/mature)
	scaling_factor = 2
	command_announcement = list("This is Captain Naiche, we are picking up large signatures inbound, we'll see what we can do to delay them.", "Captain Naich, 3rd Battalion Command, LV-624")

/datum/whiskey_outpost_wave/wave13
	wave_number = 13
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker/elite,
					/mob/living/carbon/Xenomorph/Lurker/elite,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter/elite,
					/mob/living/carbon/Xenomorph/Spitter/elite,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender/elite,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Warrior/mature,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Ravager/mature,
					/mob/living/carbon/Xenomorph/Ravager/elite,
					/mob/living/carbon/Xenomorph/Praetorian,
					/mob/living/carbon/Xenomorph/Praetorian/mature,
					/mob/living/carbon/Xenomorph/Praetorian/elite,
					/mob/living/carbon/Xenomorph/Boiler,
					/mob/living/carbon/Xenomorph/Crusher/mature,
					/mob/living/carbon/Xenomorph/Hivelord/elite)
	scaling_factor = 2

/datum/whiskey_outpost_wave/wave14
	wave_number = 14
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Runner/elite,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker/elite,
					/mob/living/carbon/Xenomorph/Lurker/elite,
					/mob/living/carbon/Xenomorph/Lurker/ancient,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter/elite,
					/mob/living/carbon/Xenomorph/Spitter/elite,
					/mob/living/carbon/Xenomorph/Spitter/ancient,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender/elite,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Warrior/mature,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Ravager/mature,
					/mob/living/carbon/Xenomorph/Ravager/elite,
					/mob/living/carbon/Xenomorph/Ravager/ancient,
					/mob/living/carbon/Xenomorph/Praetorian/mature,
					/mob/living/carbon/Xenomorph/Praetorian/elite,
					/mob/living/carbon/Xenomorph/Praetorian/ancient,
					/mob/living/carbon/Xenomorph/Boiler,
					/mob/living/carbon/Xenomorph/Boiler/ancient,
					/mob/living/carbon/Xenomorph/Crusher/mature,
					/mob/living/carbon/Xenomorph/Crusher/ancient,
					/mob/living/carbon/Xenomorph/Hivelord/elite)
	wave_type = WO_STATIC_WAVE
	number_of_xenos = 50
	command_announcement = list("This is Captain Naiche, we've established our distress beacon for the USS Alistoun and the remaining Dust Raiders. Hold on for a bit longer while we trasmit our coordinates!", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")

/datum/whiskey_outpost_wave/random
	wave_type = WO_STATIC_WAVE
	wave_number = 15
	number_of_xenos = 50
	wave_delay = 250

/datum/whiskey_outpost_wave/random/wave1 //Runner madness
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Runner/ancient,
					/mob/living/carbon/Xenomorph/Ravager/ancient)

/datum/whiskey_outpost_wave/random/wave2 //Spitter madness
	wave_castes = list(/mob/living/carbon/Xenomorph/Sentinel/ancient,
						/mob/living/carbon/Xenomorph/Sentinel/ancient,
						/mob/living/carbon/Xenomorph/Sentinel/ancient,
						/mob/living/carbon/Xenomorph/Sentinel/ancient,
						/mob/living/carbon/Xenomorph/Sentinel/ancient,
						/mob/living/carbon/Xenomorph/Sentinel/ancient,
						/mob/living/carbon/Xenomorph/Spitter/ancient,
						/mob/living/carbon/Xenomorph/Spitter/ancient,
						/mob/living/carbon/Xenomorph/Spitter/ancient,
						/mob/living/carbon/Xenomorph/Spitter/ancient,
						/mob/living/carbon/Xenomorph/Praetorian/ancient)
	number_of_xenos = 45

/datum/whiskey_outpost_wave/random/wave3 //Siege madness
	wave_castes = list(/mob/living/carbon/Xenomorph/Boiler/ancient,
					/mob/living/carbon/Xenomorph/Boiler/ancient,
					/mob/living/carbon/Xenomorph/Crusher/ancient)
	number_of_xenos = 15