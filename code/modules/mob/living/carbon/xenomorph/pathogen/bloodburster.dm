/datum/caste_datum/pathogen/bloodburster
	caste_type = PATHOGEN_CREATURE_BURSTER
	caste_desc = "A tiny sharp-clawed terror that just tore its way out of a living host."
	tier = 0
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = 0
	plasma_gain = XENO_PLASMA_GAIN_TIER_1
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_1
	armor_deflection = XENO_NO_ARMOR
	max_health = XENO_HEALTH_TIER_1
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_10
	attack_delay = -4

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/bloodburster
	evolves_to = list(PATHOGEN_CREATURE_SPRINTER)
	deevolves_to = list()

	tackle_min = 4
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 4

	heal_resting = 0.75

	minimap_icon = "bloodburster"

/mob/living/carbon/xenomorph/bloodburster
	caste_type = PATHOGEN_CREATURE_BURSTER
	name = PATHOGEN_CREATURE_BURSTER
	desc = "What the hell is THAT..."
	icon = 'icons/mob/pathogen/bloodburster.dmi'
	icon_state = "Bloody Bloodburster"
	icon_size = 32
	layer = MOB_LAYER
	plasma_types = list()
	tier = 0
	base_pixel_x = 0
	base_pixel_y = -20
	pull_speed = -0.5
	viewsize = 9
	organ_value = 5000

	mob_size = MOB_SIZE_XENO_VERY_SMALL

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/activable/pounce/runner, // Macro 1
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_SHARP

	icon_xeno = 'icons/mob/pathogen/bloodburster.dmi'
	icon_xenonid = 'icons/mob/pathogen/bloodburster.dmi'
	need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_64x64.dmi'
	weed_food_states = list("Runner_1","Runner_2","Runner_3")
	weed_food_states_flipped = list("Runner_1","Runner_2","Runner_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"
	acid_blood_damage = 0
	bubble_icon = "pathogen"

	var/bloody_state = LARVA_STATE_BLOODY

/mob/living/carbon/xenomorph/bloodburster/Life()
	// Check if no longer bloody or mature
	if(bloody_state == LARVA_STATE_BLOODY && evolution_stored >= evolution_threshold / 2)
		bloody_state = LARVA_STATE_NORMAL
		generate_name()
	else if(bloody_state == LARVA_STATE_NORMAL && evolution_stored >= evolution_threshold)
		bloody_state = LARVA_STATE_MATURE
		generate_name()
	return ..()

/mob/living/carbon/xenomorph/bloodburster/generate_name()
	if(!nicknumber)
		generate_and_set_nicknumber()

	var/progress = "" //Naming convention, three different names
	var/name_prefix = "" // Prefix for hive

	if(hive)
		name_prefix = hive.prefix
		color = hive.color

	if(bloody_state == LARVA_STATE_MATURE)
		progress = "Mature "
	else if(bloody_state == LARVA_STATE_BLOODY)
		progress = "Fresh "

	var/name_client_prefix = ""
	var/name_client_postfix = ""
	if(client)
		name_client_prefix = "[(client.xeno_prefix||client.xeno_postfix) ? client.xeno_prefix : "XX"]-"
		name_client_postfix = client.xeno_postfix ? ("-"+client.xeno_postfix) : ""
		age_xeno()
	full_designation = "[name_client_prefix][nicknumber][name_client_postfix]"

	name = "[name_prefix][progress]Bloodburster ([full_designation])"

	//Update linked data so they show up properly
	change_real_name(src, name)
	//Update the hive status UI
	if(hive)
		var/datum/hive_status/hive_status = hive
		hive_status.hive_ui.update_xeno_info()

/mob/living/carbon/xenomorph/bloodburster/update_icons()
	var/state = "" //Icon convention, two different sprite sets

	if(bloody_state == LARVA_STATE_BLOODY)
		state = "Bloody "

	if(stat == DEAD)
		icon_state = "[state]Bloodburster Dead"
	else if(handcuffed || legcuffed)
		icon_state = "[state]Bloodburster Cuff"

	else if(body_position == LYING_DOWN)
		if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
			icon_state = "[state]Bloodburster Sleeping"
		else
			icon_state = "[state]Bloodburster Stunned"
	else
		icon_state = "[state]Bloodburster"

/datum/behavior_delegate/pathogen_base/bloodburster
	name = "Base Bloodburster Behavior Delegate"

/datum/behavior_delegate/pathogen_base/bloodburster/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/onclick/xenohide/hide = get_action(bound_xeno, /datum/action/xeno_action/onclick/xenohide)
	if(hide)
		hide.post_attack()

/mob/living/carbon/xenomorph/bloodburster/initialize_pass_flags(datum/pass_flags_container/pass_flags)
	..()
	if (pass_flags)
		pass_flags.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		pass_flags.flags_can_pass_all = PASS_ALL^PASS_OVER_THROW_ITEM

/mob/living/carbon/xenomorph/bloodburster/alter_ghost(mob/dead/observer/ghost)
	ghost.icon_state = PATHOGEN_CREATURE_BURSTER

/mob/living/carbon/xenomorph/bloodburster/cause_unbearable_pain(mob/living/carbon/victim)
	if(loc != victim)
		return
	victim.emote("scream")
	if(prob(50)) //dont want them passing out too quick D:
		victim.pain.apply_pain(PAIN_CHESTBURST_STRONG)  //ow that really hurts larvie!
	var/message = SPAN_HIGHDANGER( pick("IT'S IN YOUR INSIDES!", "IT'S GNAWING YOU!", "MAKE IT STOP!", "YOU ARE GOING TO DIE!", "IT'S TEARING YOU APART!"))
	to_chat(victim, message)
	addtimer(CALLBACK(src, PROC_REF(cause_unbearable_pain), victim), rand(1, 3) SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT)



/mob/living/carbon/xenomorph/bloodburster/chest_burst(mob/living/carbon/victim)
	set waitfor = 0
	if(victim.chestburst || loc != victim)
		return
	victim.mob_flags |= BLOOD_BURSTING
	victim.chestburst = TRUE
	to_chat(src, SPAN_DANGER("We start bursting out of [victim]'s body!"))
	if(!HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
		victim.apply_effect(20, DAZE)
	victim.visible_message(SPAN_DANGER("\The [victim] starts shaking uncontrollably!"),
						SPAN_DANGER("You feel something ripping up your insides!"))
	victim.make_jittery(300)
	sleep(30)
	if(!victim || !victim.loc)
		return//host could've been deleted, or we could've been removed from host.
	if(loc != victim)
		victim.chestburst = 0
		return
	if(ishuman(victim) || isyautja(victim))
		victim.emote("burstscream")
	sleep(25) //Sound delay
	victim.update_burst()
	sleep(10) //Sprite delay
	if(!victim || !victim.loc)
		return
	if(loc != victim)
		victim.chestburst = 0 //if a doc removes the larva during the sleep(10), we must remove the 'bursting' overlay on the human
		victim.update_burst()
		return

	var/burstcount = 0

	victim.spawn_gibs()

	for(var/mob/living/carbon/xenomorph/bloodburster/burster_embryo in victim)
		var/datum/hive_status/hive = GLOB.hive_datum[burster_embryo.hivenumber]
		burster_embryo.forceMove(get_turf(victim)) //moved to the turf directly so we don't get stuck inside a cryopod or another mob container.
		burster_embryo.grant_spawn_protection(1 SECONDS)
		playsound(burster_embryo, pick('sound/voice/alien_chestburst.ogg','sound/voice/alien_chestburst2.ogg'), 25)

		if(burster_embryo.client)
			burster_embryo.set_lighting_alpha_from_prefs(burster_embryo.client)

		burster_embryo.attack_log += "\[[time_stamp()]\]<font color='red'> bloodbursted from [key_name(victim)] in [get_area_name(burster_embryo)] at X[victim.x], Y[victim.y], Z[victim.z]</font>"
		victim.attack_log += "\[[time_stamp()]\]<font color='orange'> Was bloodbursted in [get_area_name(burster_embryo)] at X[victim.x], Y[victim.y], Z[victim.z]. The larva was [key_name(burster_embryo)].</font>"

		if(burstcount)
			step(burster_embryo, pick(GLOB.cardinals))

		if(GLOB.round_statistics && (ishuman(victim)) && (SSticker.current_state == GAME_STATE_PLAYING) && (ROUND_TIME > 1 MINUTES))
			GLOB.round_statistics.total_larva_burst++
		GLOB.larva_burst_by_hive[hive] = (GLOB.larva_burst_by_hive[hive] || 0) + 1
		burstcount++

		if(!victim.first_xeno)
			if(hive.hive_orders)
				to_chat(burster_embryo, SPAN_XENOHIGHDANGER("The Spore's will overwhelms our instincts..."))
				to_chat(burster_embryo, SPAN_XENOHIGHDANGER("\"[hive.hive_orders]\""))
			log_attack("[key_name(victim)] bloodburst in [get_area_name(burster_embryo)] at X[victim.x], Y[victim.y], Z[victim.z]. The bloodburster was [key_name(burster_embryo)].") //this is so that admins are not spammed with los logs

	for(var/obj/item/alien_embryo/AE in victim)
		qdel(AE)

	var/datum/cause_data/cause = create_cause_data("bloodbursting", src)
	if(burstcount >= 4)
		victim.gib(cause)
	else
		if(ishuman(victim))
			var/mob/living/carbon/human/victim_human = victim
			victim_human.last_damage_data = cause
			var/datum/internal_organ/O
			var/i
			for(i in list("heart","lungs")) //This removes (and later garbage collects) both organs. No heart means instant death.
				O = victim_human.internal_organs_by_name[i]
				victim_human.internal_organs_by_name -= i
				victim_human.internal_organs -= O
		victim.death(cause) // Certain species were still surviving bursting (predators), DEFINITELY kill them this time.
		victim.chestburst = 3
		victim.update_burst()

/obj/item/alien_embryo/bloodburster
	icon = 'icons/mob/pathogen/bloodburster.dmi'
	flags_embryo = FLAG_EMBRYO_PATHOGEN
	hivenumber = XENO_HIVE_PATHOGEN
