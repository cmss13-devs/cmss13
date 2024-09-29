/datum/caste_datum/hellhound
	caste_type = XENO_CASTE_HELLHOUND
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	tier = 0
	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_4
	plasma_gain = XENO_PLASMA_GAIN_TIER_4
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_3
	max_health = XENO_HEALTH_TIER_7
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_HELLHOUND
	attack_delay = -2
	behavior_delegate_type = /datum/behavior_delegate/hellhound_base

	minimum_evolve_time = 0

	tackle_min = 4
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 4

	heal_resting = 2.5
	heal_standing = 1.25
	heal_knocked_out = 1.25
	innate_healing = TRUE

	minimap_icon = "hellhound"

/mob/living/carbon/xenomorph/hellhound
	AUTOWIKI_SKIP(TRUE)

	caste_type = XENO_CASTE_HELLHOUND
	name = XENO_CASTE_HELLHOUND
	desc = "A disgusting beast from hell, it has four menacing spikes growing from its head."
	icon = 'icons/mob/xenos/hellhound.dmi'
	icon_state = "Hellhound Walking"
	icon_size = 32
	layer = MOB_LAYER
	plasma_types = list(PLASMA_CHITIN)
	tier = 0
	acid_blood_damage = 0
	pull_speed = -0.5
	viewsize = 9

	speaking_key = "h"
	speaking_noise = "hiss_talk"
	langchat_color = "#9c7463"

	slash_verb = "rend"
	slashes_verb = "rends"
	slash_sound = 'sound/weapons/bite.ogg'

	mob_size = MOB_SIZE_XENO_SMALL

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)

	icon_xeno = 'icons/mob/xenos/hellhound.dmi'
	icon_xenonid = 'icons/mob/xenos/hellhound.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds.dmi'
	weed_food_states = list("Hellhound_1","Hellhound_2","Hellhound_3")
	weed_food_states_flipped = list("Hellhound_1","Hellhound_2","Hellhound_3")

/mob/living/carbon/xenomorph/hellhound/Initialize(mapload, mob/living/carbon/xenomorph/oldXeno, h_number)
	. = ..(mapload, oldXeno, h_number || XENO_HIVE_YAUTJA)

	set_languages(list(LANGUAGE_HELLHOUND, LANGUAGE_YAUTJA))

	GLOB.living_xeno_list -= src
	GLOB.xeno_mob_list -= src
	SSmob.living_misc_mobs += src
	GLOB.hellhound_list += src

/mob/living/carbon/xenomorph/hellhound/prepare_huds()
	..()
	var/image/health_holder = hud_list[HEALTH_HUD_XENO]
	health_holder.pixel_x = -12
	var/image/status_holder = hud_list[XENO_STATUS_HUD]
	status_holder.pixel_x = -10
	var/image/banished_holder = hud_list[XENO_BANISHED_HUD]
	banished_holder.pixel_x = -12
	banished_holder.pixel_y = -6

/mob/living/carbon/xenomorph/hellhound/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER

/mob/living/carbon/xenomorph/hellhound/Login()
	. = ..()
	if(SSticker.mode) SSticker.mode.xenomorphs -= mind
	to_chat(src, "<span style='font-weight: bold; color: red;'>Attention!! You are playing as a hellhound. You can get server banned if you are shitty so listen up!</span>")
	to_chat(src, "<span style='color: red;'>You MUST listen to and obey the Predator's commands at all times. Die if they demand it. Not following them is unthinkable to a hellhound.</span>")
	to_chat(src, "<span style='color: red;'>You are not here to go hog wild rambo. You're here to be part of something rare, a Predator hunt.</span>")
	to_chat(src, "<span style='color: red;'>The Predator players must follow a strict code of role-play and you are expected to as well.</span>")
	to_chat(src, "<span style='color: red;'>The Predators cannot understand your speech. They can only give you orders and expect you to follow them.</span>")
	to_chat(src, "<span style='color: red;'>Hellhounds are fiercely protective of their masters and will never leave their side if under attack.</span>")
	to_chat(src, "<span style='color: red;'>Note that ANY Predator can give you orders. If they conflict, follow the latest one. If they dislike your performance they can ask for another ghost and everyone will mock you. So do a good job!</span>")

/mob/living/carbon/xenomorph/hellhound/death(cause, gibbed)
	. = ..(cause, gibbed, "lets out a horrible roar as it collapses and stops moving...")
	if(!.)
		return
	emote("roar")
	GLOB.hellhound_list -= src
	SSmob.living_misc_mobs -= src

/mob/living/carbon/xenomorph/hellhound/rejuvenate()
	..()
	GLOB.living_xeno_list -= src
	GLOB.hellhound_list |= src
	SSmob.living_misc_mobs |= src

/mob/living/carbon/xenomorph/hellhound/Destroy()
	GLOB.hellhound_list -= src
	SSmob.living_misc_mobs -= src
	return ..()

/mob/living/carbon/xenomorph/hellhound/handle_blood_splatter(splatter_dir)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter/hellhound(loc, splatter_dir)

/datum/behavior_delegate/hellhound_base
	name = "Base Hellhound Behavior Delegate"

/datum/behavior_delegate/hellhound_base/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/onclick/xenohide/hide = get_action(bound_xeno, /datum/action/xeno_action/onclick/xenohide)
	if(hide)
		hide.post_attack()
