/datum/caste_datum/predalien
	caste_type = XENO_CASTE_PREDALIEN
	display_name = "Abomination"

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_5
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_9
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	evolution_allowed = FALSE
	minimum_evolve_time = 0

	tackle_min = 3
	tackle_max = 6
	tacklestrength_min = 6
	tacklestrength_max = 10

	is_intelligent = TRUE
	tier = 1
	attack_delay = -2
	can_be_queen_healed = FALSE

	behavior_delegate_type = /datum/behavior_delegate/predalien_base

	minimap_icon = "predalien"

/mob/living/carbon/xenomorph/predalien
	AUTOWIKI_SKIP(TRUE)

	caste_type = XENO_CASTE_PREDALIEN
	name = "Abomination" //snowflake name
	desc = "A strange looking creature with fleshy strands on its head. It appears like a mixture of armor and flesh, smooth, but well carapaced."
	icon = 'icons/mob/xenos/castes/tier_4/predalien.dmi'
	icon_xeno = 'icons/mob/xenos/castes/tier_4/predalien.dmi'
	icon_xenonid = 'icons/mob/xenos/castes/tier_4/predalien.dmi'
	icon_state = "Predalien Walking"
	speaking_noise = 'sound/voice/predalien_click.ogg'
	plasma_types = list(PLASMA_CATECHOLAMINE)
	faction = FACTION_PREDALIEN
	claw_type = CLAW_TYPE_VERY_SHARP
	wall_smash = TRUE
	hardcore = FALSE
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 1
	organ_value = 20000
	age = XENO_NO_AGE //Predaliens are already in their ultimate form, they don't get even better
	show_age_prefix = FALSE
	small_explosives_stun = FALSE

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/feralrush,
		/datum/action/xeno_action/onclick/predalien_roar,
		/datum/action/xeno_action/activable/feral_smash,
		/datum/action/xeno_action/activable/feralfrenzy,
		/datum/action/xeno_action/onclick/toggle_gut_targeting,
		/datum/action/xeno_action/onclick/tacmap,
	)

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Predalien_1","Predalien_2","Predalien_3")
	weed_food_states_flipped = list("Predalien_1","Predalien_2","Predalien_3")
	var/smashing = FALSE
	/// If the pred alert/player notif should happen when the predalien spawns
	var/should_announce_spawn = TRUE



/mob/living/carbon/xenomorph/predalien/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	if(should_announce_spawn)
		addtimer(CALLBACK(src, PROC_REF(announce_spawn)), 3 SECONDS)
		hunter_data.dishonored = TRUE
		hunter_data.dishonored_reason = "An abomination upon the honor of us all!"
		hunter_data.dishonored_set = src
		hud_set_hunter()

	AddComponent(/datum/component/footstep, 4, 25, 11, 2, "alien_footstep_medium")

/mob/living/carbon/xenomorph/predalien/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, gibbed = TRUE)

/mob/living/carbon/xenomorph/predalien/proc/announce_spawn()
	if(!loc)
		return FALSE

	yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!\n\nAn abomination has been detected at [get_area_name(loc)]. It is a stain upon our purity and is unfit for life. Exterminate it immediately.\n\nHeavy Armory unlocked."))
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_YAUTJA_ARMORY_OPENED)

	to_chat(src, {"
<span class='role_body'>|______________________|</span>
<span class='role_header'>You are a yautja-alien hybrid!</span>
<span class='role_body'>You are a xenomorph born from the body of your natural enemy, you are considered an abomination to all of the yautja race and they will do WHATEVER it takes to kill you.
However, being born from one you also harbor their intelligence and strength. You are built to be able to take them on but that does not mean you are invincible. Stay with your hive and overwhelm them with your numbers. Your sisters have sacrificed a lot for you; Do not just wander off and die.
You must still listen to the queen.
</span>
<span class='role_body'>|______________________|</span>
"})
	emote("roar")

/mob/living/carbon/xenomorph/predalien/get_organ_icon()
	return "heart_t3"


/mob/living/carbon/xenomorph/predalien/resist_fire()
	..()
	SetKnockDown(0.1 SECONDS)

/mob/living/carbon/xenomorph/predalien/get_examine_text(mob/user)
	. = ..()
	var/datum/behavior_delegate/predalien_base/predalienkills = behavior_delegate
	. += "It has [predalienkills.kills] kills to its name!"

/mob/living/carbon/xenomorph/predalien/tutorial
	AUTOWIKI_SKIP(TRUE)

	should_announce_spawn = FALSE

/mob/living/carbon/xenomorph/predalien/tutorial/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, gibbed = TRUE)

/mob/living/carbon/xenomorph/predalien/noannounce /// To not alert preds
	should_announce_spawn = FALSE

/datum/behavior_delegate/predalien_base
	name = "Base Predalien Behavior Delegate"

	var/kills = 0
	var/max_kills = 10

/datum/behavior_delegate/predalien_base/append_to_stat()
	. = list()
	. += "Kills: [kills]/[max_kills]"

/datum/behavior_delegate/predalien_base/on_kill_mob(mob/M)
	. = ..()

	kills = min(kills + 1, max_kills)

/datum/behavior_delegate/predalien_base/melee_attack_modify_damage(original_damage, mob/living/carbon/attacked_mob)
	if(ishuman(attacked_mob))
		var/mob/living/carbon/human/attacked_human = attacked_mob
		if(isspeciesyautja(attacked_human))
			original_damage *= 1.5

	return original_damage + kills * 2.5
