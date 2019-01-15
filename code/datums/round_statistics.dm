
//the datum that stores specific statistics from the current round.
//not to be confused with the round_stats var which is stores logs like round starting or ending.

var/datum/round_statistics/round_statistics = new()

/datum/round_statistics
	var/total_projectiles_fired = 0
	var/total_bullets_fired = 0
	var/total_xeno_deaths = 0
	var/total_human_deaths = 0
	var/total_xenos_created = 0
	var/total_humans_created = 0
	var/total_bullet_hits_on_humans = 0
	var/total_bullet_hits_on_xenos = 0
	var/total_larva_burst = 0
	var/carrier_traps = 0
	var/boiler_acid_smokes = 0
	var/boiler_neuro_smokes = 0
	var/crusher_stomps = 0
	var/crusher_stomp_victims = 0
	var/praetorian_acid_sprays = 0
	var/praetorian_spray_direct_hits = 0
	var/warrior_flings = 0
	var/warrior_punches = 0
	var/warrior_lunges = 0
	var/warrior_limb_rips = 0
	var/warrior_agility_toggles = 0
	var/warrior_grabs = 0
	var/defender_headbutts = 0
	var/defender_tail_sweeps = 0
	var/defender_tail_sweep_hits = 0
	var/defender_crest_lowerings = 0
	var/defender_crest_raises = 0 //manual disabling of the crest
	var/defender_fortifiy_toggles = 0

	var/total_huggers_applied = 0
	var/total_human_chestbursts = 0 //not the amount of larva burst, but the number of bursts occuring in general
	var/total_predaliens = 0

	var/xeno_count_during_hijack = 0
	var/human_count_during_hijack = 0
	var/hijack_time = ""

	var/defcon_level = 0
	var/objective_points = 0
	var/total_objective_points = 0

	var/friendly_fire_instances = 0

	//End-of-round stats:
	var/round_finished = ""
	var/game_mode = ""
	var/round_time = ""
	var/end_round_player_population = ""
	var/total_predators_spawned = 0
	var/hunter_games_winner = ""
	var/end_of_round_marines = 0
	var/end_of_round_xenos = 0

/datum/round_statistics/proc/log_round_statistics()
	if(!round_stats)
		return
	var/stats = ""
	stats += "[round_finished]\n"
	stats += "Game mode: [game_mode]\n"
	stats += "Map name: [map_tag]\n"
	stats += "Round time: [round_time]\n"
	stats += "End round player population: [end_round_player_population]\n"
	
	stats += "Total xenos spawned: [total_xenos_created]\n"
	stats += "Total Preds spawned: [total_predators_spawned]\n"
	stats += "Total Predaliens spawned: [total_predaliens]\n"
	stats += "Total humans spawned: [total_humans_created]\n"

	stats += "Xeno count during hijack: [xeno_count_during_hijack]\n"
	stats += "Human count during hijack: [human_count_during_hijack]\n"

	stats += "Total huggers applied: [total_huggers_applied]\n"
	stats += "Total chestbursts: [total_human_chestbursts]\n"

	stats += "Total friendly fire instances: [friendly_fire_instances]\n"

	stats += "DEFCON level: [defcon_level]\n"
	stats += "Objective points earned: [objective_points]\n"
	stats += "Objective points total: [total_objective_points]\n"

	//stats += ": []\n"

	stats += "Marines remaining: [end_of_round_marines]\n"
	stats += "Xenos remaining: [end_of_round_xenos]\n"
	stats += "Hijack time: [hijack_time]\n"
	
	if (hunter_games_winner)
		stats += "Big Winner: [hunter_games_winner]\n"
	stats += "[log_end]"

	round_stats << stats // Logging to data/logs/round_stats.log

/datum/round_statistics/proc/count_end_of_round_mobs_for_statistics()
	round_statistics.end_of_round_xenos = living_xeno_list.len
	round_statistics.end_of_round_marines = living_human_list.len

/datum/round_statistics/proc/count_hijack_mobs_for_statistics()
	round_statistics.xeno_count_during_hijack = living_xeno_list.len
	round_statistics.human_count_during_hijack = living_human_list.len
	round_statistics.hijack_time = duration2text()