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
	max_health = XENO_HEALTH_TIER_6
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_HELLHOUND
	attack_delay = -2
	behavior_delegate_type = /datum/behavior_delegate/hellhound_base

	minimum_evolve_time = 0
	evolution_allowed = FALSE

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
	desc = "A disgusting beast from hell, it's covered in menacing spikes.. and dear god that face.. only its houndmaster could love."
	icon = 'icons/mob/humans/onmob/hunter/hellhound.dmi'
	icon_state = "Hellhound Walking"
	icon_size = 32
	pixel_x = -16
	old_x = -16
	layer = MOB_LAYER
	plasma_types = list(PLASMA_CHITIN)
	tier = 0
	acid_blood_damage = 0
	pull_speed = -0.5
	viewsize = 9
	show_age_prefix = FALSE
	age = XENO_NO_AGE

	speaking_key = "h"
	speaking_noise = "hiss_talk"
	langchat_color = "#9c7463"

	slash_verb = "bite"
	slashes_verb = "rips"
	slash_sound = 'sound/weapons/bite.ogg'
	organ_value = 1500
	mob_size = MOB_SIZE_XENO_SMALL

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/activable/pounce/gorge,
		/datum/action/xeno_action/onclick/sense_owner,
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	icon_xeno = 'icons/mob/humans/onmob/hunter/hellhound.dmi'
	icon_xenonid = 'icons/mob/humans/onmob/hunter/hellhound.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds.dmi'
	weed_food_states = list("Hellhound_1","Hellhound_2","Hellhound_3")
	weed_food_states_flipped = list("Hellhound_1","Hellhound_2","Hellhound_3")

/mob/living/carbon/xenomorph/hellhound/Initialize(mapload, mob/living/carbon/xenomorph/oldXeno, h_number)
	. = ..(mapload, oldXeno, h_number || XENO_HIVE_YAUTJA)

	set_languages(list(LANGUAGE_HELLHOUND, LANGUAGE_YAUTJA))

	GLOB.xeno_mob_list -= src
	SSmob.living_misc_mobs += src
	GLOB.hellhound_list += src
	RegisterSignal(src, COMSIG_MOB_WEED_SLOWDOWN, PROC_REF(handle_weed_slowdown))

/mob/living/carbon/xenomorph/hellhound/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER

/mob/living/carbon/xenomorph/hellhound/Login()
	. = ..()
	if(SSticker.mode) SSticker.mode.xenomorphs -= mind
	to_chat(src, SPAN_RED("Attention!! You are playing as a hellhound. This is a roleplay role which means you must maintain a high degree of roleplay or you risk getting job banned. LISTEN TO THE YAUTJA THAT CALLED YOU. Their order takes priority. If you dont, you will be ghosted and replaced and potentially punished if you are breaking the rules. If the yautja who called you dies, try to listen to other yautja or otherwise ask for one to give you a fight that will surely end in your demise. You are loyal to yautja above all else, do not act without their permission and do not disturb the round too much!"))

/mob/living/carbon/xenomorph/hellhound/death(cause, gibbed)
	. = ..(cause, gibbed, "lets out a horrible roar as it collapses and stops moving...")
	if(!.)
		return
	emote("roar")
	GLOB.hellhound_list -= src
	SSmob.living_misc_mobs -= src
	UnregisterSignal(src, COMSIG_MOB_WEED_SLOWDOWN, PROC_REF(handle_weed_slowdown))

/mob/living/carbon/xenomorph/hellhound/get_organ_icon()
	return "heart_t3"

/mob/living/carbon/xenomorph/hellhound/rejuvenate()
	..()
	GLOB.hellhound_list |= src
	SSmob.living_misc_mobs |= src

/mob/living/carbon/xenomorph/hellhound/Destroy()
	GLOB.hellhound_list -= src
	SSmob.living_misc_mobs -= src
	return ..()

/mob/living/carbon/xenomorph/hellhound/resist_fire()
	..()
	SetKnockDown(0.5 SECONDS) // faster because theyre already slow as hell

/mob/living/carbon/xenomorph/hellhound/proc/handle_weed_slowdown(mob/user, list/slowdata)
	SIGNAL_HANDLER
	slowdata["movement_slowdown"] *= 0

/mob/living/carbon/xenomorph/hellhound/handle_blood_splatter(splatter_dir)
	new /obj/effect/bloodsplatter/hellhound(loc, splatter_dir)

/datum/behavior_delegate/hellhound_base
	name = "Base Hellhound Behavior Delegate"
	var/mob/pred_owner = ""

/datum/behavior_delegate/hellhound_base/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/onclick/xenohide/hide = get_action(bound_xeno, /datum/action/xeno_action/onclick/xenohide)
	if(hide)
		hide.post_attack()

/datum/behavior_delegate/hellhound_base/append_to_stat()
	if(!pred_owner)
		. += "You have no owner, try to listen to any other yautja..."
	else
		. += "Your owner is [pred_owner.real_name]"

/mob/living/carbon/xenomorph/hellhound/get_examine_text(mob/user)
	. = ..()
	var/datum/behavior_delegate/hellhound_base/owner = behavior_delegate
	if(ishuman_strict(user))
		. += "You can barely make out the symbols but it reads out ⵍⴻⴱⵔⵓ" // those who know
	else if(isyautja(user))
		if(!owner.pred_owner)
			. += "It's not owned by anyone."
			return
		. += "Its owner is [owner.pred_owner.real_name]!"

/datum/action/xeno_action/activable/pounce/gorge/additional_effects(mob/living/target_living)
	var/mob/living/carbon = target_living
	var/mob/living/carbon/xenomorph/hellhound/hellhound_gorger = owner

	hellhound_gorger.visible_message(SPAN_XENODANGER("[hellhound_gorger] gorges at [carbon] with it's spikes."))
	carbon.apply_armoured_damage(gorge_damage, BRUTE)
	playsound(hellhound_gorger, "giant_lizard_growl", 30)
	playsound(carbon, "alien_bite", 30)

/datum/action/xeno_action/onclick/sense_owner/use_ability(atom/layer)
	var/mob/living/carbon/xenomorph/hellhound/xeno = owner
	var/datum/behavior_delegate/hellhound_base/hound_owner = xeno.behavior_delegate
	var/direction = -3
	var/dist = get_dist(xeno, hound_owner.pred_owner)

	direction = Get_Compass_Dir(xeno, hound_owner.pred_owner)

	if(!hound_owner.pred_owner)
		to_chat(xeno, SPAN_XENOWARNING("You do not have an owner."))
		return

	if(hound_owner.pred_owner.z != xeno.z)
		to_chat(xeno, SPAN_XENOWARNING("You do not sense your owner in this place."))
		return

	for(var/mob/living/carbon/viewer in orange(xeno, 5))
		to_chat(viewer, SPAN_WARNING("[xeno] sniffs the ground in a hurry."))
		to_chat(xeno, SPAN_XENOWARNING("You sniff the ground in a hurry to find where your master is."))
		to_chat(xeno, SPAN_XENOWARNING("Your owner is [dist] meters to the [dir2text(direction)]"))

	apply_cooldown()
	..()
