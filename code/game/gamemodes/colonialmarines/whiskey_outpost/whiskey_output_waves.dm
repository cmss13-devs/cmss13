#define WO_SPAWN_MULTIPLIER 1.0
#define WO_SCALED_WAVE 1
#define WO_STATIC_WAVE 2

//SPAWN XENOS
/datum/game_mode/whiskey_outpost/proc/spawn_whiskey_outpost_xenos(var/datum/whiskey_outpost_wave/wave_data)
	if(!istype(wave_data))
		return
	var/turf/picked
	var/list/xeno_spawn_loc = list()
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	if(hive.slashing_allowed != XENO_SLASH_ALLOWED)
		hive.slashing_allowed = XENO_SLASH_ALLOWED //Allows harm intent for aliens
	var/xenos_to_spawn
	if(wave_data.wave_type == WO_SCALED_WAVE)
		xenos_to_spawn = max(count_marines(SSmapping.levels_by_trait(ZTRAIT_GROUND)),5) * wave_data.scaling_factor * WO_SPAWN_MULTIPLIER
	else
		xenos_to_spawn = wave_data.number_of_xenos

	xeno_spawn_loc = xeno_spawns.Copy()

	spawn_next_wave = wave_data.wave_delay

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
		new_xeno.pass_flags.flags_pass = list()
		new_xeno.nocrit(wave_data.wave_number)

/datum/whiskey_outpost_wave
	var/wave_number = 1
	var/list/wave_castes = list()
	var/wave_type = WO_SCALED_WAVE
	var/scaling_factor = 1.0
	var/number_of_xenos = 0 // not used for scaled waves
	var/wave_delay = 100
	var/list/sound_effect = list('sound/voice/alien_distantroar_3.ogg','sound/voice/xenos_roaring.ogg', 'sound/voice/4_xeno_roars.ogg')
	var/list/command_announcement = list()

/datum/whiskey_outpost_wave/wave1
	wave_number = 1
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner)
	sound_effect = list('sound/effects/siren.ogg')
	command_announcement = list("We're tracking the creatures that wiped out our patrols heading towards your outpost.. Stand-by while we attempt to establish a signal with the USS Alistoun to alert them of these creatures.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")
	scaling_factor = 0.3
	wave_delay = 50 //Early, quick waves

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
	wave_delay = 50 //Early, quick waves

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
	wave_delay = 50 //Early, quick waves

/datum/whiskey_outpost_wave/wave4 //Tier II more common
	wave_number = 4
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone)
	scaling_factor = 0.7

/datum/whiskey_outpost_wave/wave5 //Reset the spawns	so we don't drown in xenos again.
	wave_number = 5
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone)
	scaling_factor = 0.8

/datum/whiskey_outpost_wave/wave6 //Tier II more common
	wave_number = 6
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Sentinel,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
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
	sound_effect = list()
	command_announcement = list("Captain Naiche speaking, we've been unsuccessful in establishing offworld communication for the moment. We're prepping our M402 mortars to destroy the inbound xeno force on the main road. Standby for fire support.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")

/datum/whiskey_outpost_wave/wave9 //Ravager and Praetorian Added, Tier II more common, Tier I less common
	wave_number = 9
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior)
	sound_effect = list('sound/voice/alien_queen_command.ogg')
	command_announcement = list("Our garrison forces are reaching seventy percent casualties, we are losing our grip on LV-624. It appears that vanguard of the hostile force is still approaching, and most of the other Dust Raider platoons have been shattered. We're counting on you to keep holding.", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")

/datum/whiskey_outpost_wave/wave10
	wave_number = 10
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior)

/datum/whiskey_outpost_wave/wave11
	wave_number = 11
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Warrior)

/datum/whiskey_outpost_wave/wave12
	wave_number = 12
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Praetorian,
					/mob/living/carbon/Xenomorph/Praetorian)
	scaling_factor = 2
	command_announcement = list("This is Captain Naiche, we are picking up large signatures inbound, we'll see what we can do to delay them.", "Captain Naich, 3rd Battalion Command, LV-624")

/datum/whiskey_outpost_wave/wave13
	wave_number = 13
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Praetorian,
					/mob/living/carbon/Xenomorph/Praetorian,
					/mob/living/carbon/Xenomorph/Praetorian,
					/mob/living/carbon/Xenomorph/Boiler,
					/mob/living/carbon/Xenomorph/Crusher,
					/mob/living/carbon/Xenomorph/Hivelord)
	scaling_factor = 2

/datum/whiskey_outpost_wave/wave14
	wave_number = 14
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Lurker,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Spitter,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Defender,
					/mob/living/carbon/Xenomorph/Drone,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Warrior,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Ravager,
					/mob/living/carbon/Xenomorph/Praetorian,
					/mob/living/carbon/Xenomorph/Praetorian,
					/mob/living/carbon/Xenomorph/Praetorian,
					/mob/living/carbon/Xenomorph/Boiler,
					/mob/living/carbon/Xenomorph/Boiler,
					/mob/living/carbon/Xenomorph/Crusher,
					/mob/living/carbon/Xenomorph/Crusher,
					/mob/living/carbon/Xenomorph/Hivelord)
	wave_type = WO_STATIC_WAVE
	number_of_xenos = 50
	command_announcement = list("This is Captain Naiche, we've established our distress beacon for the USS Alistoun and the remaining Dust Raiders. Hold on for a bit longer while we trasmit our coordinates!", "Captain Naich, 3rd Battalion Command, LV-624 Garrison")

/datum/whiskey_outpost_wave/random
	wave_type = WO_STATIC_WAVE
	wave_number = 15
	number_of_xenos = 50

/datum/whiskey_outpost_wave/random/wave1 //Runner madness
	wave_castes = list(/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Runner,
					/mob/living/carbon/Xenomorph/Ravager)

/datum/whiskey_outpost_wave/random/wave2 //Spitter madness
	wave_castes = list(/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Sentinel,
						/mob/living/carbon/Xenomorph/Spitter,
						/mob/living/carbon/Xenomorph/Spitter,
						/mob/living/carbon/Xenomorph/Spitter,
						/mob/living/carbon/Xenomorph/Spitter,
						/mob/living/carbon/Xenomorph/Praetorian)
	number_of_xenos = 45

/datum/whiskey_outpost_wave/random/wave3 //Siege madness
	wave_castes = list(/mob/living/carbon/Xenomorph/Boiler,
					/mob/living/carbon/Xenomorph/Boiler,
					/mob/living/carbon/Xenomorph/Crusher)
	number_of_xenos = 15
