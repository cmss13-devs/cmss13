/datum/caste_datum/pathogen/aberration
	caste_type = PATHOGEN_CREATURE_ABERRATION
	tier = 1

	melee_damage_lower = XENO_DAMAGE_TIER_5 //Stats TBC
	melee_damage_upper = XENO_DAMAGE_TIER_6
	melee_vehicle_damage = XENO_DAMAGE_TIER_7
	max_health = XENO_HEALTH_TIER_12
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_8

	attack_delay = -2

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/aberration

	deevolves_to = list()
	evolves_to = list()

	heal_resting = 1.6
	is_intelligent = TRUE

	minimap_icon = "aberration"
	evolution_allowed = FALSE
	royal_caste = TRUE

/mob/living/carbon/xenomorph/aberration
	caste_type = PATHOGEN_CREATURE_ABERRATION
	name = PATHOGEN_CREATURE_ABERRATION
	desc = "If you believe in a god, now would be a good time for prayer..."
	icon_size = 64
	icon_state = "Aberration Walking"
	plasma_types = list()
	pixel_x = -16
	old_x = -16
	tier = 1
	organ_value = 30000
	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough/pathogen,
		/datum/action/xeno_action/onclick/xeno_resting/pathogen,
		/datum/action/xeno_action/onclick/release_haul/pathogen,
		/datum/action/xeno_action/watch_xeno/pathogen,
		/datum/action/xeno_action/activable/tail_stab/pathogen/tier3,
		/datum/action/xeno_action/onclick/feralrush, // Macro 1
		/datum/action/xeno_action/onclick/predalien_roar/aberration, //Macro 2
		/datum/action/xeno_action/activable/feral_smash, //Macro 3
		/datum/action/xeno_action/activable/feralfrenzy, //Macro 4
		/datum/action/xeno_action/onclick/toggle_gut_targeting, //Macro 5
	)
	claw_type = CLAW_TYPE_VERY_SHARP

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 45

	icon_xeno = 'icons/mob/pathogen/aberration.dmi'
	icon_xenonid = 'icons/mob/pathogen/aberration.dmi'

	skull = /obj/item/skull/abomination/aberration
	pelt = /obj/item/pelt/abomination/aberration

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_64x64.dmi'
	weed_food_states = list("Aberration_1","Aberration_2","Aberration_3")
	weed_food_states_flipped = list("Aberration_1","Aberration_2","Aberration_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"

	mob_size = MOB_SIZE_BIG
	acid_blood_damage = 0
	bubble_icon = "pathogenroyal"
	fire_immunity = FIRE_VULNERABILITY

	/// If the pred alert/player notif should happen when the Aberration spawns
	var/should_announce_spawn = TRUE

/mob/living/carbon/xenomorph/aberration/noannounce /// To not alert preds
	AUTOWIKI_SKIP(TRUE)
	should_announce_spawn = FALSE

/mob/living/carbon/xenomorph/aberration/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	make_pathogen_speaker()
	if(should_announce_spawn)
		addtimer(CALLBACK(src, PROC_REF(announce_spawn)), 3 SECONDS)
		hunter_data.dishonored = TRUE
		hunter_data.dishonored_reason = "An aberration upon the honor of us all!"
		hunter_data.dishonored_set = src
		hud_set_hunter()

	AddComponent(/datum/component/footstep, 4, 25, 11, 2, "alien_footstep_medium")

/mob/living/carbon/xenomorph/aberration/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, gibbed = TRUE)

/mob/living/carbon/xenomorph/aberration/proc/announce_spawn()
	if(!loc)
		return FALSE

	elder_overseer_message("An aberration has been detected at [get_area_name(loc)]. Exterminate it immediately. Heavy Armory unlocked.")
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_YAUTJA_ARMORY_OPENED)

	to_chat(src, {"
<span class='role_body'>|______________________|</span>
<span class='role_header'>You are a Yautja-Pathogen hybrid!</span>
<span class='role_body'>You are a Pathogen creature born from the body of your natural enemy, you are considered an aberration to all of the Yautja race and they will do WHATEVER it takes to kill you.
However, being born from one you also harbor their intelligence and strength. You are built to be able to take them on but that does not mean you are invincible. Stay with your confluence and overwhelm them with your numbers. Your sisters have sacrificed a lot for you; Do not just wander off and die.
You must still listen to the Overmind.
</span>
<span class='role_body'>|______________________|</span>
"})
	emote("roar")


/datum/behavior_delegate/pathogen_base/aberration
	name = "Base Aberration Behavior Delegate"

	var/kills = 0
	var/max_kills = 10

/datum/behavior_delegate/pathogen_base/aberration/append_to_stat()
	. = list()
	. += "Kills: [kills]/[max_kills]"

/datum/behavior_delegate/pathogen_base/aberration/on_kill_mob(mob/M)
	. = ..()

	kills = min(kills + 1, max_kills)

/datum/behavior_delegate/pathogen_base/aberration/melee_attack_modify_damage(original_damage, mob/living/carbon/attacked_mob)
	if(ishuman(attacked_mob))
		var/mob/living/carbon/human/attacked_human = attacked_mob
		if(isspeciesyautja(attacked_human))
			original_damage *= 1.5

	return original_damage + kills * 2.5

/datum/action/xeno_action/onclick/predalien_roar/aberration
	button_icon_state = "template_pathogen"
	icon_file = 'icons/mob/hud/actions_pathogen.dmi'
	predalien_roar = list('sound/pathogen_creatures/pathogen_roar2.ogg')
