/mob/living/carbon/human
	//Hair colour and style
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/h_style = "Crewcut"

	//Facial hair colour and style
	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0
	var/f_style = "Shaved"

	//Eye colour
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0

	var/ethnicity = "Western"	// Ethnicity
	var/body_type = "Mesomorphic (Average)" // Body Type

	//Skin colour
	var/r_skin = 0
	var/g_skin = 0
	var/b_skin = 0

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup

	var/age = 30		//Player's age (pure fluff)
	var/b_type = "A+"	//Player's bloodtype

	var/underwear = "Boxers (Camo Conforming)"	//Which underwear the player wants
	var/undershirt = "Undershirt"	//Which undershirt the player wants.
	var/backbag = 2		//Which backpack type the player has chosen. Satchel or Backpack.

	var/datum/species/species //Contains icon generation and language information, set during New().

	// General information
	var/home_system = ""
	var/citizenship = ""
	var/personal_faction = ""
	var/religion = ""

	//Equipment slots
	var/obj/item/clothing/suit/wear_suit = null
	var/obj/item/clothing/under/w_uniform = null
	var/obj/item/clothing/shoes/shoes = null
	var/obj/item/belt = null
	var/obj/item/clothing/gloves/gloves = null
	var/obj/item/clothing/glasses/glasses = null
	var/obj/item/head = null
	var/obj/item/wear_l_ear = null
	var/obj/item/wear_r_ear = null
	var/obj/item/card/id/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/icon/stand_icon = null

	var/voice

	var/speech_problem_flag = 0

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.

	var/last_dam = -1	//Used for determining if we need to process all limbs or just some or even none.
	var/list/limbs_to_process = list()// limbs we check until they are good.

	var/list/flavor_texts = list()
	var/recently_nested = FALSE

	// modifier modifiers
	var/list/brute_mod_override
	var/list/burn_mod_override

	//Life variables
	var/oxygen_alert = 0
	var/fire_alert = 0
	var/prev_gender = null // Debug for plural genders
	var/revive_grace_period = 5 MINUTES //5 minutes
	var/undefibbable = FALSE //whether the human is dead and past the defibbrillation period.

	var/holo_card_color = "" //which color type of holocard is printed on us

	var/list/limbs = list()
	var/list/internal_organs_by_name = list() // so internal organs have less ickiness too

	var/chem_effect_flags = 0
	var/chem_effect_reset_time = 8

	var/command_aura_available = TRUE // Whether or not you can issue an order

	var/mobility_aura_count = 0 //Used to track how many auras are affecting the human
	var/protection_aura_count = 0
	var/marksman_aura_count = 0
	var/mobility_aura = 0
	var/protection_aura = 0
	var/marksman_aura = 0

	var/FF_hit_evade = 15
	///used to determine if precise taser will shoot. Security code is so convoluted it's the easiest way, sorry.
	var/criminal = FALSE

	var/is_important = FALSE

	var/temporary_slowdown = 0 //Stacking slowdown caused from effects, currently used by neurotoxin gas
	var/shield_slowdown = 0 // Slowdown from readying shields

	var/datum/equipment_preset/assigned_equipment_preset
	var/rank_fallback

	var/datum/squad/assigned_squad	//the squad this human is assigned to
	var/assigned_fireteam = 0		//the fireteam this human is assigned to
	var/squad_status = null			//var for squad info window. Can be null, "M.I.A" and "K.I.A"

	//moved from IDs to prevent some exploits and to make points more flexible
	var/marine_points = MARINE_TOTAL_BUY_POINTS
	var/marine_snowflake_points = MARINE_TOTAL_SNOWFLAKE_POINTS
	var/marine_buy_flags = MARINE_CAN_BUY_ALL

	var/spawned_corpse = FALSE		// For the corpse spawner
	//taken from blood.dm
	var/hands_blood_color = "" //color of the blood on our hands if there's any.
	var/hands_blood_amt = 0
	var/feet_blood_color = "" //color of the blood on our feet if there's any
	var/feet_blood_amt = 0
	/// The number of bloody foot steps left to make
	var/bloody_footsteps = 0

	//taken from random files
	var/last_chew = 0

	//taken from human.dm
	hud_possible = list(HEALTH_HUD,STATUS_HUD, STATUS_HUD_OOC, STATUS_HUD_XENO_INFECTION, STATUS_HUD_XENO_CULTIST, ID_HUD, WANTED_HUD, ORDER_HUD, XENO_HOSTILE_ACID, XENO_HOSTILE_SLOW, XENO_HOSTILE_TAG, XENO_HOSTILE_FREEZE, HUNTER_CLAN, HUNTER_HUD, FACTION_HUD)
	var/embedded_flag	  				//To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/allow_gun_usage = TRUE
	var/melee_allowed = TRUE
	var/has_used_pamphlet = FALSE 		//Has this person used a pamphlet?
	var/list/embedded_items = list() 	//A list of all the shrapnel currently embedded in the human

	var/list/synthetic_HUD_toggled = list(FALSE,FALSE)

	var/default_lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

	//Taken from update_icons
	var/list/overlays_standing[TOTAL_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed
	var/hardcore = FALSE //If TRUE, removes the body upon unrevivable death (for WO)
	appearance_flags = KEEP_TOGETHER | TILE_BOUND
	throw_range = 4 // Humans can't be thrown that far

	var/datum/action/human_action/activable/selected_ability

/client/var/cached_human_playtime

/client/proc/get_total_human_playtime(var/skip_cache = FALSE)
	if(cached_human_playtime && !skip_cache)
		return cached_human_playtime

	var/total_marine_playtime = 0

	for(var/job in RoleAuthority.roles_by_name)
		var/datum/job/J = RoleAuthority.roles_by_name[job]
		if(istype(J, /datum/job/antag))
			continue

		total_marine_playtime += get_job_playtime(src, job)

	cached_human_playtime = total_marine_playtime

	return total_marine_playtime
