/mob/living/carbon/human
	light_system = MOVABLE_LIGHT
	rotate_on_lying = TRUE
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	//Hair color and style
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/h_style = "Crewcut"

	//Hair gradient color and style
	var/r_gradient = 0
	var/g_gradient = 0
	var/b_gradient = 0
	///Style used for the hair gradient.
	var/grad_style = "None"

	//Facial hair color and style
	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0
	var/f_style = "Shaved"

	//Eye color
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0

	var/skin_color = "Pale 2" // Skin color
	var/body_size = "Average" // Body Size
	var/body_type = "Lean" // Body Buffness

	//Skin color
	var/r_skin = 0
	var/g_skin = 0
	var/b_skin = 0

	var/lip_style = null //no lipstick by default- arguably misleading, as it could be used for general makeup

	var/age = 30 //Player's age (pure fluff)
	var/b_type = "A+" //Player's bloodtype

	var/underwear = "Boxers (Camo Conforming)" //Which underwear the player wants
	var/undershirt = "Undershirt (Tan)" //Which undershirt the player wants.
	var/backbag = 2 //Which backpack type the player has chosen. Satchel or Backpack.

	var/datum/species/species //Contains icon generation and language information, set during New().

	// General information
	var/origin = ""
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
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/voice

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/last_dam = -1 //Used for determining if we need to process all limbs or just some or even none.
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

	var/list/obj/limb/limbs = list()
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

	var/datum/squad/assigned_squad //the squad this human is assigned to
	var/assigned_fireteam = 0 //the fireteam this human is assigned to
	var/squad_status = null //var for squad info window. Can be null, "M.I.A" and "K.I.A"

	//moved from IDs to prevent some exploits and to make points more flexible
	var/marine_points = MARINE_TOTAL_BUY_POINTS
	var/marine_snowflake_points = MARINE_TOTAL_SNOWFLAKE_POINTS
	var/marine_buyable_categories = MARINE_CAN_BUY_ALL

	var/spawned_corpse = FALSE // For the corpse spawner
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
	hud_possible = list(HEALTH_HUD, STATUS_HUD, STATUS_HUD_OOC, STATUS_HUD_XENO_INFECTION, STATUS_HUD_XENO_CULTIST, ID_HUD, WANTED_HUD, ORDER_HUD, XENO_HOSTILE_ACID, XENO_HOSTILE_SLOW, XENO_HOSTILE_TAG, XENO_HOSTILE_FREEZE, XENO_EXECUTE, HUNTER_CLAN, HUNTER_HUD, FACTION_HUD, HOLOCARD_HUD)
	var/embedded_flag //To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/allow_gun_usage = TRUE
	var/melee_allowed = TRUE
	var/throw_allowed = TRUE
	var/has_used_pamphlet = FALSE //Has this person used a pamphlet?

	/// A list of all the shrapnel currently embedded in the human
	var/list/atom/movable/embedded_items = list()

	var/list/synthetic_HUD_toggled = list(FALSE,FALSE)

	var/default_lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

	//Taken from update_icons
	var/list/overlays_standing[TOTAL_LAYERS]
	var/hardcore = FALSE //If TRUE, removes the body upon unrevivable death (for WO)
	appearance_flags = KEEP_TOGETHER | TILE_BOUND
	throw_range = 4 // Humans can't be thrown that far

	var/datum/action/human_action/activable/selected_ability

	///list of weakrefs of recently dropped objects
	var/list/remembered_dropped_objects = list()

	/// associated list of body part zone -> currently active limb key
	var/list/icon_render_keys = list()

	/// static associated list of limb key -> image to avoid unnecessary overlay generation
	var/static/list/icon_render_image_cache = list()

	/// Stored image references associated with focus-fire.
	var/image/focused_fire_marker

/client/var/cached_human_playtime

/client/proc/get_total_human_playtime(skip_cache = FALSE)
	if(cached_human_playtime && !skip_cache)
		return cached_human_playtime

	var/total_marine_playtime = 0

	for(var/job in GLOB.RoleAuthority.roles_by_name)
		var/datum/job/J = GLOB.RoleAuthority.roles_by_name[job]
		if(istype(J, /datum/job/antag))
			continue

		total_marine_playtime += get_job_playtime(src, job)

	cached_human_playtime = total_marine_playtime

	return total_marine_playtime

/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "-----HUMAN-----")
	VV_DROPDOWN_OPTION(VV_HK_SET_SPECIES, "Set Species")
	VV_DROPDOWN_OPTION(VV_HK_ADD_ORGAN, "Add Organ")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_ORGAN, "Remove Organ")
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminspawncookie=\ref[src]'>Give Cookie</option>"

/mob/living/carbon/human/vv_do_topic(list/href_list)
	. = ..()

	if(href_list[VV_HK_SET_SPECIES])
		if(!check_rights(R_SPAWN))
			return

		var/new_species = tgui_input_list(usr, "Please choose a new species.","Species",GLOB.all_species)

		if(!new_species)
			return

		if(set_species(new_species))
			to_chat(usr, "Set species of [src] to [src.species].")
		else
			to_chat(usr, "Failed! Something went wrong.")


	if(href_list[VV_HK_EDIT_SKILL])
		if(!check_rights(R_VAREDIT))
			return

		if(!skills)
			skills = new /datum/skills/pfc(src)

		skills.tgui_interact(usr)

	if(href_list[VV_HK_ADD_ORGAN])
		if(!check_rights(R_SPAWN))
			return

		var/new_organ = tgui_input_list(usr, "Please choose an organ to add.","Organ",null, typesof(/datum/internal_organ)-/datum/internal_organ)

		if(!new_organ)
			return FALSE

		if(locate(new_organ) in internal_organs)
			to_chat(usr, "Mob already has that organ.")
			return

		var/datum/internal_organ/I = new new_organ(src)

		var/organ_slot = input(usr, "Which slot do you want the organ to go in ('default' for default)?")  as text|null

		if(!organ_slot)
			return

		if(organ_slot != "default")
			organ_slot = sanitize(copytext(organ_slot,1,MAX_MESSAGE_LEN))
		else
			if(I.removed_type)
				var/obj/item/organ/O = new I.removed_type()
				organ_slot = O.organ_tag
				qdel(O)
			else
				organ_slot = "unknown organ"

		if(internal_organs_by_name[organ_slot])
			to_chat(usr, "[src] already has an organ in that slot.")
			qdel(I)
			return

		internal_organs_by_name[organ_slot] = I
		to_chat(usr, "Added new [new_organ] to [src] as slot [organ_slot].")

	if(href_list[VV_HK_REMOVE_ORGAN])
		if(!check_rights(R_SPAWN))
			return

		var/rem_organ = tgui_input_list(usr, "Please choose an organ to remove.","Organ",null, internal_organs)

		if(!(locate(rem_organ) in internal_organs))
			to_chat(usr, "Mob does not have that organ.")
			return

		to_chat(usr, "Removed [rem_organ] from [src].")
		qdel(rem_organ)

