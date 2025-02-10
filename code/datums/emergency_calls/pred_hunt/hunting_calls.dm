//Predator Hunting Ground ERTs


/datum/emergency_call/pred
	name = "template"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress/hunt_spawner
	shuttle_id = ""
	var/hunt_name
	var/message = "You are still expected to uphold the RP of the standard as this character!"

/datum/emergency_call/pred/mixed
	name = "Hunting Grounds - Multi Faction - Small"
	hunt_name = "Multi Faction (small)"
	mob_max = 4
	mob_min = 1
	max_clf = 1
	max_upp = 1
	max_royal_marines = 1

/datum/emergency_call/pred/mixed/spawn_candidates(quiet_launch, announce_incoming, override_spawn_loc)
	. = ..()
	if(mob_min > length(members))
		message_all_yautja("Not enough humans in storage for the hunt to start.")
	else
		message_all_yautja("Released [length(members)] humans from storage, let the hunt commence!")

/datum/emergency_call/pred/mixed/create_member(datum/mind/player, turf/override_spawn_loc)
	set waitfor = 0
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return

	var/mob/living/carbon/human/hunted = new(spawn_loc)

	if(player)
		player.transfer_to(hunted, TRUE)
	else
		hunted.create_hud()

	if(mercs < max_mercs && HAS_FLAG(hunted.client.prefs.toggles_ert_pred, PLAY_MERC))
		mercs++
		var/list/hunted_types = list(/datum/equipment_preset/other/freelancer/leader/hunted, /datum/equipment_preset/other/freelancer/standard/hunted)
		var/hunted_type = pick(hunted_types)
		arm_equipment(hunted, hunted_type , TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("No one is more professional than I. Unlike other mercenaries, your group was registered as a legitimate business that dealt in violence. Working for various high profile clients, information classified to the public circulated somewhat freely in your circle - stories you dismissed as anecdotal or hearsay. The last job you took proved particularly hazardous and truthful: as you were clearing local fauna around a dig site, a massive man-shaped shimmering thing lunged at you and knocked you out in one blow. Groggily opening your eyes, you try to make sense of your surroundings, and get up."))
	else if(upp < max_upp && HAS_FLAG(hunted.client.prefs.toggles_ert_pred, PLAY_UPP))
		upp++
		var/list/hunted_types = list(/datum/equipment_preset/upp/soldier/hunted, /datum/equipment_preset/upp/leader/hunted, /datum/equipment_preset/upp/machinegunner/hunted, /datum/equipment_preset/upp/sapper/hunted)
		var/hunted_type = pick(hunted_types)
		arm_equipment(hunted, hunted_type , TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("Life was alright. Previously relocated from your noisier post on the frontier, you were now stationed just on the outer veil of Union territory. Combat patrols and sawdust rations turned into boring guard shifts and proper food, making your peacekeeping duty a much envied task. Then, your life came crumbling down. An unknown alien surprised you and the rest of your garrison, slaughtering effectively everyone. Just as you were about to escape, it caught you in a trap, and dragged you into the darkness. Now awake in a completely different place, still sore from the confrontation, you wonder what you'd have to do to get back home safe and sound."))
	else if(royal_marines < max_royal_marines && HAS_FLAG(hunted.client.prefs.toggles_ert_pred, PLAY_TWE))
		royal_marines++
		var/list/hunted_types = list(/datum/equipment_preset/twe/royal_marine/standard/hunted, /datum/equipment_preset/twe/royal_marine/team_leader/hunted, /datum/equipment_preset/twe/royal_marine/lieuteant/hunted)
		var/hunted_type = pick(hunted_types)
		arm_equipment(hunted, hunted_type , TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("You were starting to get sick and tired of these Australians. Posted and wrangled around Oceania, you had spent the last half decade from refugee camp to metropolis, making sure order was maintained most of the time and partaking in a riot action now and then. You were ready to give about anything for your job to be more interesting, and like a monkey's paw, the wish came true. One night, your barracks got blown up before your very eyes while on guard duty, and to your dismay, it was not a terrorist. You attempted to gun the monster down, but failed, your friends torn apart before your very eyes. Being the last one alive, the thing takes you with it, shackles you, and throws you into a cell. You black out again, and wake up here, wherever you are. At least you hope things will be more interesting now, or so you tell yourself."))
	else if(clf < max_clf && HAS_FLAG(hunted.client.prefs.toggles_ert_pred, PLAY_CLF))
		clf++
		var/list/hunted_types = list(/datum/equipment_preset/clf/soldier/hunted, /datum/equipment_preset/clf/leader/hunted, /datum/equipment_preset/clf/engineer/hunted)
		var/hunted_type = pick(hunted_types)
		arm_equipment(hunted, hunted_type , TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("Your whole life was a struggle. Fighting tooth and nail for the independence of your colony from one master to the next, with not much change, your home ended up crushed under the boot of the oppressor. Filled with rage, you traveled with your cell of freedom fighters from one system to the next, wreaking havoc and mayhem, which eventually makes you notorious for your brutal executions of government officials and military. While on a raid gone wrong, your comrades get slaughtered by a marine squad, and as you scamper to get away, something else catches you off guard. KO'd and taken away, you wake up in conditions not much different from your previous ones, determined to get revenge against your oppressor once more."))
	else
		var/list/hunted_types = list(/datum/equipment_preset/uscm/hunted/rifleman,/datum/equipment_preset/uscm/hunted/tl, /datum/equipment_preset/uscm/hunted/sg,)
		var/hunted_type = pick(hunted_types)
		arm_equipment(hunted, hunted_type , TRUE, TRUE)
		to_chat(hunted, SPAN_BOLD("You dreamt of becoming the ultimate badass ever since you were a kid. Nukes, knives, sharp sticks - and the corps was for you, enlisting into the marines as soon as you could join. There were little regrets from you, happily gunning down anything, anytime, and anywhere you were told to go... until now. During a jungle patrol, your entire squad was torn to shreds by a single cloaker - something you previously figured was made up just to scare chickenshit privates. Riddling the freak with bullet holes, it finally catches you off guard, and after that it's all hazy. Waking up, you realize you're still alive... and that it left you with your weapon. Big mistake. You get up."))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), hunted.client, 'sound/misc/hunt_begin.ogg'), 10 SECONDS)
	show_blurb(hunted, 15, message, null, "center", "center", COLOR_RED, null, null, 1)

/datum/emergency_call/pred/mixed/medium
	name = "Hunting Grounds - Multi Faction - Medium"
	hunt_name = "Multi Faction (group)"
	mob_max = 6
	mob_min = 2
	max_clf = 2
	max_upp = 2
	max_royal_marines = 1
	max_mercs = 1


/datum/emergency_call/pred/mixed/hard
	name = "Hunting Grounds - Multi Faction - Large"
	hunt_name = "Multi Faction (large)"
	mob_max = 8
	mob_min = 3
	max_clf = 2
	max_upp = 1
	max_royal_marines = 2
	max_mercs = 2

/datum/emergency_call/pred/mixed/harder
	name = "Hunting Grounds - Multi Faction - Larger"
	hunt_name = "Multi Faction (larger)"
	mob_max = 12
	mob_min = 4
	max_clf = 2
	max_upp = 2
	max_royal_marines = 3
	max_mercs = 2

/datum/emergency_call/pred/xeno
	name = "Hunting Grounds - Xenos - Small"
	hunt_name = "Serpents (small)"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress/hunt_spawner/xeno
	mob_max = 4
	mob_min = 1
	hostility = TRUE
	max_xeno_t3 = 1
	max_xeno_t2 = 1


/datum/emergency_call/pred/xeno/spawn_candidates(quiet_launch, announce_incoming, override_spawn_loc)
	. = ..()
	if(mob_min > length(members))
		message_all_yautja("Not enough serpents in storage for the hunt to start.")
	else
		message_all_yautja("Released [length(members)] serpents from storage, let the hunt commence!")

/datum/emergency_call/pred/xeno/create_member(datum/mind/player, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()
	var/mob/current_mob = player.current
	var/mob/living/carbon/xenomorph/new_xeno

	if(!istype(spawn_loc))
		return // Didn't find a usable spawn point.

	if(xeno_t3 < max_xeno_t3 && HAS_FLAG(current_mob.client.prefs.toggles_ert_pred, PLAY_XENO_T3))
		xeno_t3++
		var/list/xeno_types = list(/mob/living/carbon/xenomorph/praetorian, /mob/living/carbon/xenomorph/ravager)
		var/xeno_type = pick(xeno_types)
		new_xeno = new xeno_type(spawn_loc, null, XENO_HIVE_FERAL)
		player.transfer_to(new_xeno, TRUE)
		QDEL_NULL(current_mob)
		to_chat(new_xeno, SPAN_BOLD("You are a xeno"))
	else if(xeno_t2 < max_xeno_t2 && HAS_FLAG(current_mob.client.prefs.toggles_ert_pred, PLAY_XENO_T2))
		xeno_t2++
		var/list/xeno_types = list(/mob/living/carbon/xenomorph/lurker, /mob/living/carbon/xenomorph/warrior)
		var/xeno_type = pick(xeno_types)
		new_xeno = new xeno_type(spawn_loc, null, XENO_HIVE_FERAL)
		player.transfer_to(new_xeno, TRUE)
		QDEL_NULL(current_mob)
		to_chat(new_xeno, SPAN_BOLD("You are a xeno let loose on a strang "))
	else
		var/list/xeno_types = list(/mob/living/carbon/xenomorph/drone)
		var/xeno_type = pick(xeno_types)
		new_xeno = new xeno_type(spawn_loc, null, XENO_HIVE_FERAL)
		player.transfer_to(new_xeno, TRUE)
		to_chat(new_xeno, SPAN_BOLD("You are a xeno"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), new_xeno.client, 'sound/misc/hunt_begin.ogg'), 10 SECONDS)
	show_blurb(new_xeno, 15, message, null, "center", "center", COLOR_RED, null, null, 1)

/datum/emergency_call/pred/xeno/med
	name = "Hunting Grounds - Xenos - Medium"
	hunt_name = "Serpents (group)"
	mob_max = 6
	mob_min = 3
	hostility = TRUE
	max_xeno_t3 = 3
	max_xeno_t2 = 1

/datum/emergency_call/pred/xeno/hard
	name = "Hunting Grounds - Xenos - Large"
	hunt_name = "Serpents (large)"
	mob_max = 8
	mob_min = 4
	hostility = TRUE
	max_xeno_t3 = 3
	max_xeno_t2 = 3
