/*
This is a collection of procs related to CM and spawning aliens/predators/survivors. With this centralized system,
you can spawn them at round start in any game mode. You can also add additional categories, and they will be supported
at round start with no conflict. Individual game modes may override these settings to have their own unique
spawns for the various factions. It's also a bit more robust with some added parameters. For example, if xeno_required_num
is 0, you don't need aliens at the start of the game. If aliens are required for win conditions, tick it to 1 or more.

This is a basic outline of how things should function in code.
You can see a working example in the Colonial Marines game mode.

	//Minds are not transferred/made at this point, so we have to check for them so we don't double dip.
	can_start() //This should have the following in order:
		initialize_special_clamps()
		initialize_starting_predator_list()
		if(!initialize_starting_xenomorph_list()) //If we don't have the right amount of xenos, we can't start.
			return
		initialize_starting_survivor_list()

		return 1

	pre_setup()
		//Other things can take place, such as game mode specific setups.

		return 1

	post_setup()
		initialize_post_xenomorph_list()
		initialize_post_survivor_list()
		initialize_post_predator_list()

		return 1


//Flags defined in setup.dm
MODE_INFESTATION
MODE_PREDATOR

Additional game mode variables.
*/

/datum/game_mode
	var/datum/mind/xenomorphs[] = list() //These are our basic lists to keep track of who is in the game.
	var/datum/mind/survivors[] = list()
	var/datum/mind/synth_survivor = null
	var/datum/mind/predators[] = list()
	var/datum/mind/hellhounds[] = list() //Hellhound spawning is not supported at round start.
	var/pred_keys[] = list() //People who are playing predators, we can later reference who was a predator during the round.

	var/xeno_required_num 	= 0 //We need at least one. You can turn this off in case we don't care if we spawn or don't spawn xenos.
	var/xeno_starting_num 	= 0 //To clamp starting xenos.
	var/xeno_bypass_timer 	= 0 //Bypass the five minute timer before respawning.
	//var/xeno_queen_timer  	= list(0, 0, 0, 0, 0) //How long ago did the queen die?
	var/xeno_queen_deaths 	= 0 //How many times the alien queen died.
	var/surv_starting_num 	= 0 //To clamp starting survivors.
	var/merc_starting_num 	= 0 //PMC clamp.
	var/marine_starting_num = 0 //number of players not in something special
	var/pred_current_num 	= 0 //How many are there now?
	var/pred_maximum_num 	= 4 //How many are possible per round? Does not count elders.
	var/pred_round_chance 	= 20 //%
	var/pred_leader_count 	= 0 //How many Leader preds are active
	var/pred_leader_max 	= 1 //How many Leader preds are permitted. Currently fixed to 1. May add admin verb to adjust this later.

	//Some gameplay variables.
	var/round_checkwin 		= 0
	var/round_finished
	var/round_started  		= 5 //This is a simple timer so we don't accidently check win conditions right in post-game
	var/round_fog[]				//List of the fog locations.
	var/round_toxic_river[]		//List of all toxic river locations
	var/round_time_lobby 		//Base time for the lobby, for fog dispersal.
	var/round_time_fog 			//Variance time for fog dispersal, done during pre-setup.
	var/round_time_river
	var/monkey_amount		= 0 //How many monkeys do we spawn on this map ?
	var/list/monkey_types	= list() //What type of monkeys do we spawn
	var/latejoin_tally		= 0 //How many people latejoined Marines
	var/latejoin_larva_drop = 6 //A larva will spawn in once the tally reaches this level. If set to 0, no latejoin larva drop

	//Role Authority set up.
	var/role_instruction 	= 0 // 1 is to replace, 2 is to add, 3 is to remove.
	var/roles_for_mode[] //Won't have a list if the instruction is set to 0.

	//Bioscan related.
	var/bioscan_current_interval = MINUTES_5//5 minutes in
	var/bioscan_ongoing_interval = MINUTES_1//every 1 minute

	var/lz_selection_timer = MINUTES_25 //25 minutes in
	var/round_time_resin = MINUTES_40	//Time for when resin placing is allowed close to LZs
	var/resin_allow_finished

	var/flags_round_type = NOFLAGS

//===================================================\\

				//GAME MODE INITIATLIZE\\

//===================================================\\

datum/game_mode/proc/initialize_special_clamps()
	var/ready_players = num_players() // Get all players that have "Ready" selected
	xeno_starting_num = Clamp((ready_players/config.xeno_number_divider), xeno_required_num, INFINITY) //(n, minimum, maximum)
	surv_starting_num = Clamp((ready_players/config.surv_number_divider), 0, 8)
	//merc_starting_num = Clamp((ready_players/3), 1, INFINITY)
	marine_starting_num = ready_players - xeno_starting_num - surv_starting_num// - merc_starting_num
	for(var/datum/squad/sq in RoleAuthority.squads)
		if(sq)
			sq.max_engineers = engi_slot_formula(marine_starting_num)
			sq.max_medics = medic_slot_formula(marine_starting_num)

	for(var/datum/job/J in RoleAuthority.roles_by_name)
		if(J.scaled)
			J.set_spawn_positions(marine_starting_num)


//===================================================\\

				//PREDATOR INITIATLIZE\\

//===================================================\\

/datum/game_mode/proc/initialize_predator(mob/living/carbon/human/new_predator)
	predators += new_predator.mind //Add them to the proper list.
	pred_keys += new_predator.ckey //Add their key.
	if(!(RoleAuthority.roles_whitelist[new_predator.ckey] & (WHITELIST_YAUTJA_ELITE|WHITELIST_YAUTJA_ELDER|WHITELIST_YAUTJA_COUNCIL))) pred_current_num++ //If they are not an elder, tick up the max.

/datum/game_mode/proc/initialize_starting_predator_list()
	if(prob(pred_round_chance)) //First we want to determine if it's actually a predator round.
		flags_round_type |= MODE_PREDATOR //It is now a predator round.
		var/L[] = get_whitelisted_predators() //Grabs whitelisted preds who are ready at game start.
		var/datum/mind/M
		var/i //Our iterator for the maximum amount of pred spots available. The actual number is changed later on.
		while(L.len && i < pred_maximum_num)
			M = pick(L)
			if(!istype(M)) continue
			L -= M
			M.assigned_role = "MODE" //So they are not chosen later for another role.
			predators += M
			if(!(RoleAuthority.roles_whitelist[M.current.ckey] & (WHITELIST_YAUTJA_ELITE|WHITELIST_YAUTJA_ELDER|WHITELIST_YAUTJA_COUNCIL))) i++

/datum/game_mode/proc/initialize_post_predator_list() //TO DO: Possibly clean this using tranfer_to.
	var/temp_pred_list[] = predators //We don't want to use the actual predator list as it will be overriden.
	predators = list() //Empty it. The temporary minds we used aren't going to be used much longer.
	for(var/datum/mind/new_pred in temp_pred_list)
		if(!istype(new_pred)) continue
		attempt_to_join_as_predator(new_pred.current)

/datum/game_mode/proc/get_whitelisted_predators(readied = 1)
	// Assemble a list of active players who are whitelisted.
	var/players[] = new

	var/mob/new_player/new_pred
	for(var/mob/player in player_list)
		if(!player.client) continue //No client. DCed.
		if(isYautja(player)) continue //Already a predator. Might be dead, who knows.
		if(readied) //Ready check for new players.
			new_pred = player
			if(!istype(new_pred)) continue //Have to be a new player here.
			if(!new_pred.ready) continue //Have to be ready.
		else
			if(!istype(player,/mob/dead)) continue //Otherwise we just want to grab the ghosts.

		if(RoleAuthority.roles_whitelist[player.ckey] & WHITELIST_PREDATOR)  //Are they whitelisted?
			if(!player.client.prefs)
				player.client.prefs = new /datum/preferences(player.client) //Somehow they don't have one.

			if(player.client.prefs.be_special & BE_PREDATOR) //Are their prefs turned on?
				if(!player.mind) //They have to have a key if they have a client.
					player.mind_initialize() //Will work on ghosts too, but won't add them to active minds.
				players += player.mind
	return players

/datum/game_mode/proc/attempt_to_join_as_predator(mob/pred_candidate)
	var/mob/living/carbon/human/new_predator = transform_predator(pred_candidate) //Initialized and ready.
	if(!new_predator) return

	log_admin("[new_predator.key], became a new Yautja, [new_predator.real_name].")
	message_admins("([new_predator.key]) joined as Yautja, [new_predator.real_name].")

	if(pred_candidate) pred_candidate.loc = null //Nullspace it for garbage collection later.

/datum/game_mode/proc/check_predator_late_join(mob/pred_candidate, show_warning = 1)

	if(!(RoleAuthority.roles_whitelist[pred_candidate.ckey] & WHITELIST_PREDATOR))
		if(show_warning) to_chat(pred_candidate, "<span class='warning'>You are not whitelisted! You may apply on the forums to be whitelisted as a predator.</span>")
		return

	if(!(flags_round_type & MODE_PREDATOR))
		if(show_warning) to_chat(pred_candidate, "<span class='warning'>There is no Hunt this round! Maybe the next one.</span>")
		return

	if(pred_candidate.ckey in pred_keys)
		if(show_warning) to_chat(pred_candidate, "<span class='warning'>You already were a Yautja! Give someone else a chance.</span>")
		return

	if(!(RoleAuthority.roles_whitelist[pred_candidate.ckey] & (WHITELIST_YAUTJA_ELDER | WHITELIST_YAUTJA_COUNCIL)))
		if(pred_current_num >= pred_maximum_num)
			if(show_warning) to_chat(pred_candidate, "<span class='warning'>Only [pred_maximum_num] predators may spawn this round, but Elders and Leaders do not count.</span>")
			return

	return 1

/datum/game_mode/proc/transform_predator(mob/pred_candidate)
	if(!pred_candidate.client) //Something went wrong.
		message_admins("<span class='warning'><b>Warning</b>: null client in transform_predator.</span>")
		log_debug("Null client in transform_predator.")
		return

	var/mob/living/carbon/human/new_predator
	var/wants_elder = 0
	var/wants_leader = 0
	if(RoleAuthority.roles_whitelist[pred_candidate.ckey] & WHITELIST_YAUTJA_ELDER)
		if(alert(pred_candidate,"Would you like to play as an Elder or a Blooded?","Predator Type","Elder","Blooded") == "Elder")
			wants_elder = 1
	else if(RoleAuthority.roles_whitelist[pred_candidate.ckey] & WHITELIST_YAUTJA_COUNCIL)
		if(alert(pred_candidate,"Would you like to play as a Councillor or a Blooded?","Predator Type","Councillor","Blooded") == "Councillor")
			wants_leader = 1
			wants_elder = 0

	new_predator = new(wants_elder|wants_leader ? pick(pred_elder_spawn) : pick(pred_spawn))
	new_predator.set_species("Yautja")

	new_predator.mind_initialize()
	new_predator.mind.assigned_role = "MODE"
	new_predator.mind.special_role = "Predator"
	new_predator.key = pred_candidate.key
	new_predator.mind.key = new_predator.key
	if(new_predator.client) new_predator.client.change_view(world.view)

	if(!new_predator.client.prefs) new_predator.client.prefs = new /datum/preferences(new_predator.client) //Let's give them one.
	//They should have these set, but it's possible they don't have them.
	new_predator.real_name = new_predator.client.prefs.predator_name
	new_predator.gender = new_predator.client.prefs.predator_gender
	new_predator.age = new_predator.client.prefs.predator_age

	if(!new_predator.real_name || new_predator.real_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
		new_predator.real_name = "Le'pro"
		spawn(9)
			to_chat(new_predator, "<span class='warning'>You forgot to set your name in your preferences. Please do so next time.</span>")

	var/armor_number = new_predator.client.prefs.predator_armor_type
	var/boot_number = new_predator.client.prefs.predator_boot_type
	var/mask_number = new_predator.client.prefs.predator_mask_type

	new_predator.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja(new_predator, boot_number), WEAR_FEET)
	if(wants_elder)
		new_predator.real_name = "Elder [new_predator.real_name]"
		new_predator.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja(new_predator, armor_number, 1), WEAR_JACKET)
		new_predator.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(new_predator, mask_number, 1), WEAR_FACE)
		new_predator.equip_to_slot_or_del(new /obj/item/clothing/cape/eldercape(new_predator, armor_number), WEAR_BACK)
		new_predator.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(new_predator), WEAR_WAIST)

		spawn(10)
			to_chat(new_predator, SPAN_NOTICE("<B> Welcome Elder!</B>"))
			to_chat(new_predator, SPAN_NOTICE("You are responsible for the well-being of your pupils. Hunting is secondary in priority."))
			to_chat(new_predator, SPAN_NOTICE("That does not mean you can't go out and show the youngsters how it's done."))
			to_chat(new_predator, SPAN_NOTICE("You come equipped as an Elder should, with a bonus glaive and heavy armor."))

	else if(wants_leader)
		new_predator.real_name = "Councillor [new_predator.real_name]"
		new_predator.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja(new_predator, armor_number), WEAR_JACKET)
		new_predator.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(new_predator, mask_number), WEAR_FACE)
		new_predator.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(new_predator), WEAR_WAIST)

		spawn(10)
			to_chat(new_predator, SPAN_NOTICE("<B> Welcome Councillor!</B>"))
			to_chat(new_predator, SPAN_NOTICE("You are responsible for the well-being of your pupils. Hunting is secondary in priority."))
			to_chat(new_predator, SPAN_NOTICE("That does not mean you can't go out and show the youngsters how it's done."))
	else
		new_predator.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja(new_predator, armor_number), WEAR_JACKET)
		new_predator.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(new_predator, mask_number), WEAR_FACE)
		new_predator.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(new_predator), WEAR_WAIST)

		spawn(12)
			to_chat(new_predator, SPAN_NOTICE("You are <B>Yautja</b>, a great and noble predator!"))
			to_chat(new_predator, SPAN_NOTICE("Your job is to first study your opponents. A hunt cannot commence unless intelligence is gathered."))
			to_chat(new_predator, SPAN_NOTICE("Hunt at your discretion, yet be observant rather than violent."))
			to_chat(new_predator, SPAN_NOTICE("And above all, listen to your Elders!"))

	new_predator.update_icons()
	initialize_predator(new_predator)
	new_predator.mind.set_cm_skills(/datum/skills/yautja/warrior)
	return new_predator


//===================================================\\

			//XENOMORPH INITIATLIZE\\

//===================================================\\

//If we are selecting xenomorphs, we NEED them to play the round. This is the expected behavior.
//If this is an optional behavior, just override this proc or make an override here.
/datum/game_mode/proc/initialize_starting_xenomorph_list()
	var/list/datum/mind/possible_xenomorphs = get_players_for_role(BE_ALIEN)
	if(possible_xenomorphs.len < xeno_required_num) //We don't have enough aliens.
		to_world("<h2 style=\"color:red\">Not enough players have chosen to be a xenomorph in their character setup. <b>Aborting</b>.</h2>")
		return

	//Minds are not transferred at this point, so we have to clean out those who may be already picked to play.
	for(var/datum/mind/A in possible_xenomorphs)
		if(A.assigned_role == "MODE")
			possible_xenomorphs -= A

	var/i = xeno_starting_num
	var/datum/mind/new_xeno
	var/turf/larvae_spawn
	while(i > 0) //While we can still pick someone for the role.
		if(possible_xenomorphs.len) //We still have candidates
			new_xeno = pick(possible_xenomorphs)
			if(!new_xeno) break  //Looks like we didn't get anyone. Back out.
			new_xeno.assigned_role = "MODE"
			new_xeno.special_role = "Xenomorph"
			possible_xenomorphs -= new_xeno
			xenomorphs += new_xeno
		else //Out of candidates, spawn in empty larvas directly
			larvae_spawn = pick(xeno_spawn)
			new /mob/living/carbon/Xenomorph/Larva(larvae_spawn)
		i--

	/*
	Our list is empty. This can happen if we had someone ready as alien and predator, and predators are picked first.
	So they may have been removed from the list, oh well.
	*/
	if(xenomorphs.len < xeno_required_num)
		to_world("<h2 style=\"color:red\">Could not find any candidates after initial alien list pass. <b>Aborting</b>.</h2>")
		return

	return 1

/datum/game_mode/proc/initialize_post_xenomorph_list()
	for(var/datum/mind/new_xeno in xenomorphs) //Build and move the xenos.
		transform_xeno(new_xeno)

/datum/game_mode/proc/check_xeno_late_join(mob/xeno_candidate)
	if(jobban_isbanned(xeno_candidate, "Alien")) // User is jobbanned
		to_chat(xeno_candidate, "<span class='warning'>You are banned from playing aliens and cannot spawn as a xenomorph.</span>")
		return
	return 1

/datum/game_mode/proc/attempt_to_join_as_xeno(mob/xeno_candidate, instant_join = 0)
	var/list/available_xenos = list()
	var/list/available_xenos_non_ssd = list()
	var/datum/hive_status/hive = hive_datum[XENO_HIVE_NORMAL]
	var/mob/living/carbon/Xenomorph/Queen/queen = hive.living_xeno_queen

	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.z == ADMIN_Z_LEVEL) continue //xenos on admin z level don't count
		if(istype(X) && !X.client)
			if(X.away_timer >= 300) available_xenos_non_ssd += X
			available_xenos += X

	if(queen && queen.can_spawn_larva() && isnewplayer(xeno_candidate))
		available_xenos += "buried larva"

	if(!available_xenos.len || (instant_join && !available_xenos_non_ssd.len))
		to_chat(xeno_candidate, "<span class='warning'>There aren't any available xenomorphs or buried larvae. You can try getting spawned as a chestburster larva by toggling your Xenomorph candidacy in Preferences -> Toggle SpecialRole Candidacy.</span>")
		return 0

	var/mob/living/carbon/Xenomorph/new_xeno
	if(!instant_join)
		var/userInput = input("Available Xenomorphs") as null|anything in available_xenos

		if(userInput == "buried larva")
			if(!queen.ovipositor)
				to_chat(xeno_candidate, "<span class='warning'>The queen is not on her ovipositor. Try again later.</span>")
				return 0

			if(queen.can_spawn_larva()) //check again incase it hit the 1 minute mark between checks
				if(isnewplayer(xeno_candidate))
					var/mob/new_player/N = xeno_candidate
					N.close_spawn_windows()
				queen.spawn_buried_larva(xeno_candidate)
				return 1

		if(!isXeno(userInput) || !xeno_candidate)
			return 0
		new_xeno = userInput

		if(!(new_xeno in living_mob_list) || new_xeno.stat == DEAD)
			to_chat(xeno_candidate, "<span class='warning'>You cannot join if the xenomorph is dead.</span>")
			return 0

		if(new_xeno.client)
			to_chat(xeno_candidate, "<span class='warning'>That xenomorph has been occupied.</span>")
			return 0

		if(!xeno_candidate) //
			return 0

		if(!xeno_bypass_timer)
			var/deathtime = world.time - xeno_candidate.timeofdeath
			if(istype(xeno_candidate, /mob/new_player))
				deathtime = MINUTES_5 //so new players don't have to wait to latejoin as xeno in the round's first 5 mins.
			var/deathtimeminutes = round(deathtime / MINUTES_1)
			var/deathtimeseconds = round((deathtime - deathtimeminutes * MINUTES_1) / 10,1)
			if(deathtime < MINUTES_5 && ( !xeno_candidate.client.admin_holder || !(xeno_candidate.client.admin_holder.rights & R_ADMIN)) )
				var/message = "<span class='warning'>You have been dead for [deathtimeminutes >= 1 ? "[deathtimeminutes] minute\s and " : ""][deathtimeseconds] second\s.</span>"
				to_chat(xeno_candidate, message)
				to_chat(xeno_candidate, "<span class='warning'>You must wait 5 minutes before rejoining the game!</span>")
				return 0
			if(new_xeno.away_timer < SECONDS_30) //We do not want to occupy them if they've only been gone for a little bit.
				to_chat(xeno_candidate, "<span class='warning'>That player hasn't been away long enough. Please wait [SECONDS_30 - new_xeno.away_timer] second\s longer.</span>")
				return 0

		if(alert(xeno_candidate, "Everything checks out. Are you sure you want to transfer yourself into [new_xeno]?", "Confirm Transfer", "Yes", "No") == "Yes")
			if(new_xeno.client || !(new_xeno in living_mob_list) || new_xeno.stat == DEAD || !xeno_candidate) // Do it again, just in case
				to_chat(xeno_candidate, "<span class='warning'>That xenomorph can no longer be controlled. Please try another.</span>")
				return 0
		else return 0
	else new_xeno = pick(available_xenos_non_ssd) //Just picks something at random.
	if(istype(new_xeno) && xeno_candidate && xeno_candidate.client)
		if(isnewplayer(xeno_candidate))
			var/mob/new_player/N = xeno_candidate
			N.close_spawn_windows()
		if(transfer_xeno(xeno_candidate.key, new_xeno))
			return 1
	to_chat(xeno_candidate, "JAS01: Something went wrong, tell a coder.")

/datum/game_mode/proc/transfer_xeno(var/xeno_candidate, mob/living/new_xeno)
	if(!xeno_candidate)
		return 0
	if(!isXeno(new_xeno))
		return 0
	new_xeno.ghostize(0) //Make sure they're not getting a free respawn.
	new_xeno.key = xeno_candidate
	if(new_xeno.client) new_xeno.client.change_view(world.view)
	msg_admin_niche("[new_xeno.key] has joined as [new_xeno].")
	log_admin("[new_xeno.key] has joined as [new_xeno].")
	if(isXeno(new_xeno)) //Dear lord
		var/mob/living/carbon/Xenomorph/X = new_xeno
		if(X.is_ventcrawling) X.add_ventcrawl(X.loc) //If we are in a vent, fetch a fresh vent map
	return 1

/datum/game_mode/proc/transform_xeno(datum/mind/ghost_mind)
	var/mob/living/original = ghost_mind.current
	var/mob/living/carbon/Xenomorph/new_xeno
	var/is_queen = FALSE
	var/datum/hive_status/hive = hive_datum[XENO_HIVE_NORMAL]
	if(!hive.living_xeno_queen && original && original.client && original.client.prefs && (original.client.prefs.be_special & BE_QUEEN) && !jobban_isbanned(original, "Queen"))
		new_xeno = new /mob/living/carbon/Xenomorph/Queen (pick(xeno_spawn))
		is_queen = TRUE
		ghost_mind.transfer_to(new_xeno) //The mind is fine, since we already labeled them as a xeno. Away they go.
		ghost_mind.name = ghost_mind.current.name
	else
		original.first_xeno = TRUE
		original.stat = 1
		transform_survivor(ghost_mind) //Create a new host
		original.adjustBruteLoss(50) //Do some damage to the host
		var/obj/structure/bed/nest/start_nest = new /obj/structure/bed/nest(original.loc) //Create a new nest for the host
		original.buckled = start_nest
		original.dir = start_nest.dir
		original.update_canmove()
		start_nest.buckled_mob = original
		start_nest.afterbuckle(original)
		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(original) //Put the initial larva in a host
		embryo.stage = 5 //Give the embryo a head-start (make the larva burst instantly)

	if(is_queen)
		to_chat(new_xeno, "<B>You are now the alien queen!</B>")
		to_chat(new_xeno, "<B>Your job is to spread the hive.</B>")
		to_chat(new_xeno, "Talk in Hivemind using <strong>;</strong> (e.g. ';Hello my children!')")

	new_xeno.update_icons()

	if(original && !original.first_xeno) qdel(original) //Just to be sure.
	if(original.first_xeno) qdel(new_xeno)

//===================================================\\

			//SURVIVOR INITIATLIZE\\

//===================================================\\

//We don't actually need survivors to play, so long as aliens are present.
/datum/game_mode/proc/initialize_starting_survivor_list()
	var/list/datum/mind/possible_human_survivors = get_players_for_role(BE_SURVIVOR)
	var/list/datum/mind/possible_synth_survivors = get_players_for_role(BE_SYNTH_SURVIVOR)

	var/list/datum/mind/possible_survivors = possible_human_survivors.Copy() //making a copy so we'd be able to distinguish between survivor types

	for(var/datum/mind/A in possible_synth_survivors)
		if(RoleAuthority.roles_whitelist[ckey(A.key)] & WHITELIST_SYNTHETIC)
			if(A in possible_survivors)
				continue //they are already applying to be a survivor
			else
				possible_survivors += A
		else
			possible_synth_survivors -= A//Not whitelisted, get them out of here!

	possible_survivors = shuffle(possible_survivors) //Shuffle them up a bit
	if(possible_survivors.len) //We have some, it looks like.
		for(var/datum/mind/A in possible_survivors) //Strip out any xenos first so we don't double-dip.
			if(A.assigned_role == "MODE")
				possible_survivors -= A

		if(possible_survivors.len) //We may have stripped out all the contendors, so check again.
			var/i = surv_starting_num
			var/datum/mind/new_survivor
			while(i > 0)
				if(!possible_survivors.len)
					break  //Ran out of candidates! Can't have a null pick(), so just stick with what we have.
				new_survivor = pick(possible_survivors)
				if(!new_survivor)
					break  //We ran out of survivors!
				if(!synth_survivor && new_survivor in possible_synth_survivors)
					synth_survivor = new_survivor
					new_survivor.assigned_role = "MODE"
					new_survivor.special_role = "Survivor"
					monkey_amount += 5 //Extra smallhosts will be spawned to compensate the xenos for this survivor
				else if(new_survivor in possible_human_survivors) //so we don't draft people that want to be synth survivors but not normal survivors
					new_survivor.assigned_role = "MODE"
					new_survivor.special_role = "Survivor"
					survivors += new_survivor
					i--
				possible_survivors -= new_survivor //either we drafted a survivor, or we're skipping over someone, either or - remove them

/datum/game_mode/proc/initialize_post_survivor_list()
	if(synth_survivor)
		transform_survivor(synth_survivor, TRUE)
	for(var/datum/mind/survivor in survivors)
		if(transform_survivor(survivor) == 1)
			survivors -= survivor
	tell_survivor_story()

//Start the Survivor players. This must go post-setup so we already have a body.
//No need to transfer their mind as they begin as a human.
/datum/game_mode/proc/transform_survivor(var/datum/mind/ghost, var/is_synth = FALSE)
	var/picked_spawn = null
	if(ghost.current.first_xeno)
		picked_spawn = pick(xeno_spawn)
	else
		picked_spawn = pick(surv_spawn)
	var/obj/effect/landmark/survivor_spawner/surv_datum
	surv_datum = picked_spawn;
	if(istype(surv_datum))
		return survivor_event_transform(ghost.current, surv_datum, is_synth)
		//deleting datum is on us
		if(ghost.current.first_xeno)
			xeno_spawn -= picked_spawn
		else
			surv_spawn -= picked_spawn
		qdel(picked_spawn)
	else
		return survivor_non_event_transform(ghost.current, picked_spawn, is_synth)

/datum/game_mode/proc/survivor_old_equipment(var/mob/living/carbon/human/H, var/is_synth = FALSE)
	var/list/survivor_types

	if(is_synth)
		survivor_types = list(
				"Survivor - Synthetic", //to be expanded later
			)
	else
		switch(map_tag)
			if(MAP_PRISON_STATION)
				survivor_types = list(
					"Survivor - Scientist",
					"Survivor - Doctor",
					"Survivor - Corporate",
					"Survivor - Security",
					"Survivor - Prisoner",
					"Survivor - Prisoner",
					"Survivor - Prisoner",
				)
			if(MAP_LV_624,MAP_BIG_RED,MAP_DESERT_DAM)
				survivor_types = list(
					"Survivor - Assistant",
					"Survivor - Civilian",
					"Survivor - Scientist",
					"Survivor - Doctor",
					"Survivor - Chef",
					"Survivor - Botanist",
					"Survivor - Atmos Tech",
					"Survivor - Chaplain",
					"Survivor - Miner",
					"Survivor - Salesman",
					"Survivor - Colonial Marshall",
				)
			if(MAP_ICE_COLONY)
				survivor_types = list(
					"Survivor - Scientist",
					"Survivor - Doctor",
					"Survivor - Salesman",
					"Survivor - Security",
				)
			else
				survivor_types = list(
					"Survivor - Assistant",
					"Survivor - Civilian",
					"Survivor - Scientist",
					"Survivor - Doctor",
					"Survivor - Chef",
					"Survivor - Botanist",
					"Survivor - Atmos Tech",
					"Survivor - Chaplain",
					"Survivor - Miner",
					"Survivor - Salesman",
					"Survivor - Colonial Marshall",
				)

	//Give them proper jobs and stuff here later
	var/randjob = pick(survivor_types)
	arm_equipment(H, randjob, FALSE)


/datum/game_mode/proc/survivor_event_transform(var/mob/living/carbon/human/H, var/obj/effect/landmark/survivor_spawner/spawner, var/is_synth = FALSE)
	H.loc = spawner.loc
	if(spawner.roundstart_damage_max>0)
		while(spawner.roundstart_damage_times>0)
			H.take_limb_damage(rand(spawner.roundstart_damage_min,spawner.roundstart_damage_max), 0)
			spawner.roundstart_damage_times--
	if(!spawner.equipment || is_synth)
		survivor_old_equipment(H, is_synth)
	else
		if(arm_equipment(H,spawner.equipment) == -1)
			to_chat(H, "SET02: Something went wrong, tell a coder. You may ask admin to spawn you as a survivor.")
			return
	H.name = H.get_visible_name()

	if(!H.first_xeno) //Only give objectives/back-stories to uninfected survivors
		if(spawner.intro_text && spawner.intro_text.len)
			spawn(4)
				for(var/line in spawner.intro_text)
					H << line
		else
			spawn(4)
				to_chat(H, "<h2>You are a survivor!</h2>")
				switch(map_tag)
					if(MAP_PRISON_STATION)
						to_chat(H, "<span class='notice'> You are a survivor of the attack on Fiorina Orbital Penitentiary. You worked or lived on the prison station, and managed to avoid the alien attacks... until now.</span>")
					if(MAP_ICE_COLONY)
						to_chat(H, "<span class='notice'>You are a survivor of the attack on the ice habitat. You worked or lived on the colony, and managed to avoid the alien attacks... until now.</span>")
					else
						to_chat(H, "<span class='notice'>You are a survivor of the attack on the colony. You worked or lived in the archaeology colony, and managed to avoid the alien attacks... until now.</span>")
				to_chat(H, "<span class='notice'>You are fully aware of the xenomorph threat and are able to use this knowledge as you see fit.</span>")
				to_chat(H, "<span class='notice'>You are NOT aware of the marines or their intentions. </span>")
		if(spawner.story_text)
			. = 1
			spawn(6)
				var/temp_story = "<b>Your story thus far</b>: " + spawner.story_text
				H <<  temp_story
				H.mind.memory += temp_story
				//remove ourselves, so we don't get stuff generated for us
				survivors -= H.mind

		if(spawner.make_objective)
			new /datum/cm_objective/move_mob/almayer/survivor(H)

/datum/game_mode/proc/survivor_non_event_transform(var/mob/living/carbon/human/H, var/loc, var/is_synth = FALSE)
	H.loc = loc
	survivor_old_equipment(H, is_synth)
	H.name = H.get_visible_name()
	new /datum/cm_objective/move_mob/almayer/survivor(H)

	//Give them some information
	if(!H.first_xeno) //Only give objectives/back-stories to uninfected survivors
		spawn(4)
			to_chat(H, "<h2>You are a survivor!</h2>")
			switch(map_tag)
				if(MAP_PRISON_STATION)
					to_chat(H, "<span class='notice'>You are a survivor of the attack on Fiorina Orbital Penitentiary. You worked or lived on the prison station, and managed to avoid the alien attacks.. until now.</span>")
				if(MAP_ICE_COLONY)
					to_chat(H, "<span class='notice'>You are a survivor of the attack on the ice habitat. You worked or lived on the colony, and managed to avoid the alien attacks.. until now.</span>")
				else
					to_chat(H, "<span class='notice'>You are a survivor of the attack on the colony. You worked or lived in the archaeology colony, and managed to avoid the alien attacks...until now.</span>")
			to_chat(H, "<span class='notice'>You are fully aware of the xenomorph threat and are able to use this knowledge as you see fit.</span>")
			to_chat(H, "<span class='notice'>You are NOT aware of the marines or their intentions.</span>")
		return 1

/datum/game_mode/proc/tell_survivor_story()
	var/list/survivor_story = list(
								"You watched as a larva burst from the chest of your friend, {name}. You tried to capture the alien thing, but it escaped through the ventilation.",
								"{name} was attacked by a facehugging alien, which impregnated them with an alien lifeform. {name}'s chest exploded in gore as some creature escaped.",
								"You watched in horror as {name} got the alien lifeform's acid on their skin, melting away their flesh. You can still hear the screaming and panic.",
								"The Colony Marshal, {name}, made an announcement that the hostile lifeforms killed many, and that everyone should hide or stay behind closed doors.",
								"You were there when the alien lifeforms broke into the mess hall and dragged away the others. It was a terrible sight, and you have tried avoid large open areas since.",
								"It was horrible, as you watched your friend, {name}, get mauled by the horrible monsters. Their screams of agony hunt you in your dreams, leading to insomnia.",
								"You tried your best to hide, and you have seen the creatures travel through the underground tunnels and ventilation shafts. They seem to like the dark.",
								"When you woke up, it felt like you've slept for years. You don't recall much about your old life, except maybe your name. Just what the hell happened to you?",
								"You were on the front lines, trying to fight the aliens. You have seen them hatch more monsters from other humans, and you know better than to fight against death.",
								"You found something, something incredible. But your discovery was cut short when the monsters appeared and began taking people. Damn the beasts!",
								"{name} protected you when the aliens came. You don't know what happened to them, but that was some time ago, and you haven't seen them since. Maybe they are alive."
								)
	var/list/survivor_multi_story = list(
										"You were separated from your friend, {surv}. You hope they're still alive.",
										"You were having some drinks at the bar with {surv} and {name} when an alien crawled out of the vent and dragged {name} away. You and {surv} split up to find help.",
										"Something spooked you when you were out with {surv} scavenging. You took off in the opposite direction from them, and you haven't seen them since.",
										"When {name} became infected, you and {surv} argued over what to do with the afflicted. You nearly came to blows before walking away, leaving them behind.",
										"You ran into {surv} when out looking for supplies. After a tense stand off, you agreed to stay out of each other's way. They didn't seem so bad.",
										"A lunatic by the name of {name} was preaching doomsday to anyone who would listen. {surv} was there too, and you two shared a laugh before the creatures arrived.",
										"Your last decent memory before everything went to hell is of {surv}. They were generally a good person to have around, and they helped you through tough times.",
										"When {name} called for evacuation, {surv} came with you. The aliens appeared soon after and everyone scattered. You hope your friend {surv} is alright.",
										"You remember an explosion. Then everything went dark. You can only recall {name} and {surv}, who were there. Maybe they know what really happened?",
										"The aliens took your mutual friend, {name}. {surv} helped with the rescue. When you got to the alien hive, your friend was dead. You took different passages out.",
										"You were playing basketball with {surv} when the creatures descended. You bolted in opposite directions, and actually managed to lose the monsters, somehow."
										)

	var/current_survivors[] = survivors //These are the current survivors, so we can remove them once we tell a story.
	var/story //The actual story they will get to read.
	var/random_name
	var/datum/mind/survivor
	while(current_survivors.len)
		survivor = pick(current_survivors)
		if(!istype(survivor))
			current_survivors -= survivor
			continue //Not a mind? How did this happen?

		random_name = pick(random_name(FEMALE),random_name(MALE))

		if(!survivor.current.first_xeno)
			if(current_survivors.len > 1) //If we have another survivor to pick from.
				if(survivor_multi_story.len) //Unlikely.
					var/datum/mind/another_survivor = pick(current_survivors - survivor) // We don't want them to be picked twice.
					current_survivors -= another_survivor
					if(!istype(another_survivor)) continue//If somehow this thing screwed up, we're going to run another pass.
					story = pick(survivor_multi_story)
					survivor_multi_story -= story
					story = replacetext(story, "{name}", "[random_name]")
					spawn(6)
						var/temp_story = "<b>Your story thus far</b>: " + replacetext(story, "{surv}", "[another_survivor.current.real_name]")
						survivor.current <<  temp_story
						survivor.memory += temp_story //Add it to their memories.
						temp_story = "<b>Your story thus far</b>: " + replacetext(story, "{surv}", "[survivor.current.real_name]")
						another_survivor.current << temp_story
						another_survivor.memory += temp_story
			else
				if(survivor_story.len) //Shouldn't happen, but technically possible.
					story = pick(survivor_story)
					survivor_story -= story
					spawn(6)
						var/temp_story = "<b>Your story thus far</b>: " + replacetext(story, "{name}", "[random_name]")
						survivor.current << temp_story
						survivor.memory += temp_story
		current_survivors -= survivor
	return 1

//===================================================\\

			//MARINE GEAR INITIATLIZE\\

//===================================================\\

//We do NOT want to initilialize the gear before everyone is properly spawned in
/datum/game_mode/proc/initialize_post_marine_gear_list()

	//We take the number of marine players, deduced from other lists, and then get a scale multiplier from it, to be used in arbitrary manners to distribute equipment
	//This might count players who ready up but get kicked back to the lobby
	var/marine_pop_size = 0

	for(var/mob/M in player_list)
		if(M.stat != DEAD && M.mind && !M.mind.special_role)
			marine_pop_size++

	var/scale = max(marine_pop_size / MARINE_GEAR_SCALING_NORMAL, 1) //This gives a decimal value representing a scaling multiplier. Cannot go below 1

	//Set up attachment vendor contents related to Marine count
	for(var/obj/machinery/vending/attachments/A in attachment_vendors)
		A.populate_product_list(scale)

	for(var/obj/machinery/vending/marine/cargo_ammo/CA in cargo_ammo_vendors)
		CA.populate_product_list(scale)

	for(var/obj/machinery/vending/marine/cargo_guns/CG in cargo_guns_vendors)
		CG.populate_product_list(scale)


	for(var/obj/machinery/vending/marine/M in marine_vendors)
		M.populate_product_list(scale)

		var/products2[]
		//if(istype(src, /datum/game_mode/ice_colony)) //Literally, we are in gamemode code
		if(map_tag == MAP_ICE_COLONY)
			products2 = list(
				/obj/item/clothing/mask/rebreather/scarf = round(scale * 30),
			)
		M.build_inventory(products2)

	//Scale the amount of cargo points through a direct multiplier
	supply_controller.points = round(supply_controller.points * scale)
