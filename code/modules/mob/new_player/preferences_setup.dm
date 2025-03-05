//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/randomize_appearance(mob/living/carbon/human/H)
	if(H)
		if(H.gender == MALE)
			gender = MALE
		else
			gender = FEMALE

	skin_color = random_skin_color()
	body_type = random_body_type()
	body_size = random_body_size()

	h_style = random_hair_style(gender, species)
	f_style = random_facial_hair_style(gender, species)
	randomize_hair_color("hair")
	randomize_hair_color("facial")
	randomize_eyes_color()
	randomize_skin_color()
	underwear = gender == MALE ? pick(GLOB.underwear_m) : pick(GLOB.underwear_f)
	undershirt = gender == MALE ? pick(GLOB.undershirt_m) : pick(GLOB.undershirt_f)
	backbag = 2
	age = rand(AGE_MIN,AGE_MAX)
	if(H)
		copy_appearance_to(H,1)

/datum/preferences/proc/randomize_hair_color(target = "hair")
	if(prob (75) && target == "facial") // Chance to inherit hair color
		r_facial = r_hair
		g_facial = g_hair
		b_facial = b_hair
		return

	var/red
	var/green
	var/blue

	var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
	switch(col)
		if("blonde")
			red = 255
			green = 255
			blue = 0
		if("black")
			red = 0
			green = 0
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 51
		if("copper")
			red = 255
			green = 153
			blue = 0
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("wheat")
			red = 255
			green = 255
			blue = 153
		if("old")
			red = rand (100, 255)
			green = red
			blue = red
		if("punk")
			red = rand (0, 255)
			green = rand (0, 255)
			blue = rand (0, 255)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	switch(target)
		if("hair")
			r_hair = red
			g_hair = green
			b_hair = blue
		if("facial")
			r_facial = red
			g_facial = green
			b_facial = blue

/datum/preferences/proc/randomize_eyes_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_eyes = red
	g_eyes = green
	b_eyes = blue



/datum/preferences/proc/randomize_skin_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_skin = red
	g_skin = green
	b_skin = blue

/datum/preferences/proc/update_preview_icon(refresh_limb_status)
	if(!owner)
		return

	var/J = job_pref_to_gear_preset()
	if(isnull(preview_dummy))
		preview_dummy = new()

	preview_dummy.blocks_emissive = FALSE
	preview_dummy.update_emissive_block()

	clear_equipment()
	if(refresh_limb_status)
		for(var/obj/limb/L in preview_dummy.limbs)
			L.status = LIMB_ORGANIC
	preview_dummy.set_species()
	copy_appearance_to(preview_dummy)
	preview_dummy.update_body()
	preview_dummy.update_hair()
	for (var/datum/character_trait/character_trait as anything in preview_dummy.traits)
		character_trait.unapply_trait(preview_dummy)

	var/gear_to_preview = gear.Copy()
	var/loadout_to_preview = get_active_loadout()
	if(loadout_to_preview)
		gear_to_preview += loadout_to_preview

	for(var/gear_type in gear_to_preview)
		var/datum/gear/gear = GLOB.gear_datums_by_type[gear_type]
		gear.equip_to_user(preview_dummy, override_checks = TRUE, drop_instead_of_del = FALSE)

	arm_equipment(preview_dummy, J, FALSE, FALSE, owner, show_job_gear)

	// If the dummy was equipped with marine armor.
	var/jacket = preview_dummy.get_item_by_slot(WEAR_JACKET)
	if(istype(jacket, /obj/item/clothing/suit/storage/marine))
		var/obj/item/clothing/suit/storage/marine/armor = jacket
		// If the armor has different sprite variants.
		if(armor.armor_variation)
			// Set its `icon_state` to the style the player picked as their 'Preferred Armor'.
			armor.set_armor_style(preferred_armor)
			armor.update_icon(preview_dummy)

	if(isnull(preview_front))
		preview_front = new()
		preview_front.vis_contents += preview_dummy
		preview_front.screen_loc = "preview:0,0"
	preview_front.icon_state = bg_state
	owner.add_to_screen(preview_front)

	if(isnull(rotate_left))
		rotate_left = new(null, preview_dummy)
		rotate_left.screen_loc = "preview:-1:16,0"
	owner.add_to_screen(rotate_left)

	if(isnull(rotate_right))
		rotate_right = new(null, preview_dummy)
		rotate_right.screen_loc = "preview:1:-16,0"
	owner.add_to_screen(rotate_right)

/// Returns the role that is selected on High
/datum/preferences/proc/get_high_priority_job()
	for(var/job in job_preference_list)
		if(job_preference_list[job] == 1)
			return job

	return JOB_SQUAD_MARINE

/datum/preferences/proc/job_pref_to_gear_preset()
	var/high_priority = get_high_priority_job()

	switch(high_priority)
		// USCM JOBS
		if(JOB_SQUAD_MARINE)
			return /datum/equipment_preset/uscm/private_equipped
		if(JOB_SQUAD_ENGI)
			return /datum/equipment_preset/uscm/engineer_equipped
		if(JOB_SQUAD_LEADER)
			return /datum/equipment_preset/uscm/leader_equipped
		if(JOB_SQUAD_MEDIC)
			return /datum/equipment_preset/uscm/medic_equipped
		if(JOB_SQUAD_SPECIALIST)
			return /datum/equipment_preset/uscm/specialist_equipped
		if(JOB_SQUAD_SMARTGUN)
			return /datum/equipment_preset/uscm/smartgunner_equipped
		if(JOB_SQUAD_TEAM_LEADER)
			return /datum/equipment_preset/uscm/tl_equipped
		if(JOB_CO)
			var/datum/job/J = GLOB.RoleAuthority.roles_by_name[JOB_CO]
			return J.gear_preset_whitelist["[JOB_CO][J.get_whitelist_status(owner)]"]
		if(JOB_SO)
			return /datum/equipment_preset/uscm_ship/so
		if(JOB_XO)
			return /datum/equipment_preset/uscm_ship/xo
		if(JOB_AUXILIARY_OFFICER)
			return /datum/equipment_preset/uscm_ship/auxiliary_officer
		if(JOB_INTEL)
			return /datum/equipment_preset/uscm/intel/full
		if(JOB_CAS_PILOT)
			return /datum/equipment_preset/uscm_ship/gp/full
		if(JOB_TANK_CREW)
			return /datum/equipment_preset/uscm/tank/full
		if(JOB_DROPSHIP_PILOT)
			return /datum/equipment_preset/uscm_ship/dp/full
		if(JOB_DROPSHIP_CREW_CHIEF)
			return /datum/equipment_preset/uscm_ship/dcc/full
		if(JOB_CORPORATE_LIAISON)
			return /datum/equipment_preset/uscm_ship/liaison
		if(JOB_COMBAT_REPORTER)
			return /datum/equipment_preset/uscm_ship/reporter
		if(JOB_SYNTH)
			var/datum/job/J = GLOB.RoleAuthority.roles_by_name[JOB_SYNTH]
			return J.gear_preset_whitelist["[JOB_SYNTH][J.get_whitelist_status(owner)]"]
		if(JOB_WORKING_JOE)
			return /datum/equipment_preset/synth/working_joe
		if(JOB_POLICE)
			return /datum/equipment_preset/uscm_ship/uscm_police/mp
		if(JOB_CHIEF_POLICE)
			return /datum/equipment_preset/uscm_ship/uscm_police/cmp
		if(JOB_WARDEN)
			return /datum/equipment_preset/uscm_ship/uscm_police/warden
		if(JOB_SEA)
			return /datum/equipment_preset/uscm_ship/sea
		if(JOB_CHIEF_ENGINEER)
			return /datum/equipment_preset/uscm_ship/chief_engineer
		if(JOB_ORDNANCE_TECH)
			return /datum/equipment_preset/uscm_ship/ordn
		if(JOB_MAINT_TECH)
			return /datum/equipment_preset/uscm_ship/maint
		if(JOB_CHIEF_REQUISITION)
			return /datum/equipment_preset/uscm_ship/qm
		if(JOB_CARGO_TECH)
			return /datum/equipment_preset/uscm_ship/cargo
		if(JOB_CMO)
			return /datum/equipment_preset/uscm_ship/uscm_medical/cmo
		if(JOB_DOCTOR)
			return /datum/equipment_preset/uscm_ship/uscm_medical/doctor
		if(JOB_FIELD_DOCTOR)
			return /datum/equipment_preset/uscm_ship/uscm_medical/field_doctor
		if(JOB_RESEARCHER)
			return /datum/equipment_preset/uscm_ship/uscm_medical/researcher
		if(JOB_NURSE)
			return /datum/equipment_preset/uscm_ship/uscm_medical/nurse
		if(JOB_MESS_SERGEANT)
			return /datum/equipment_preset/uscm_ship/chef
		// UPP JOBS
		if(JOB_UPP)
			return /datum/equipment_preset/upp/soldier/dressed
		if(JOB_UPP_ENGI)
			return /datum/equipment_preset/upp/sapper/dressed
		if(JOB_UPP_MEDIC)
			return /datum/equipment_preset/upp/medic/dressed
		if(JOB_UPP_SPECIALIST)
			return /datum/equipment_preset/upp/specialist/dressed
		if(JOB_UPP_LEADER)
			return /datum/equipment_preset/upp/leader/dressed
		if(JOB_UPP_POLICE)
			return /datum/equipment_preset/upp/military_police/dressed
		if(JOB_UPP_LT_OFFICER)
			return /datum/equipment_preset/upp/officer/dressed
		if(JOB_UPP_SUPPLY)
			return /datum/equipment_preset/upp/supply/dressed
		if(JOB_UPP_LT_DOKTOR)
			return /datum/equipment_preset/upp/doctor/dressed
		if(JOB_UPP_SRLT_OFFICER)
			return /datum/equipment_preset/upp/officer/senior/dressed
		if(JOB_UPP_KPT_OFFICER)
			return /datum/equipment_preset/upp/officer/kapitan/dressed
		if(JOB_UPP_CO_OFFICER)
			return /datum/equipment_preset/upp/officer/major/dressed
		if(JOB_UPP_COMMISSAR)
			return /datum/equipment_preset/upp/commissar/dressed
		if(JOB_UPP_SUPPORT_SYNTH)
			return /datum/equipment_preset/upp/synth/dressed
		if(JOB_UPP_JOE)
			return /datum/equipment_preset/synth/working_joe/upp
		if(JOB_UPP_PILOT)
			return /datum/equipment_preset/upp/pilot
		// MISC-JOBS
		if(JOB_SURVIVOR)
			var/list/survivor_types = pref_special_job_options[JOB_SURVIVOR] != ANY_SURVIVOR && length(SSmapping.configs[GROUND_MAP].survivor_types_by_variant[pref_special_job_options[JOB_SURVIVOR]]) ? SSmapping.configs[GROUND_MAP].survivor_types_by_variant[pref_special_job_options[JOB_SURVIVOR]] : SSmapping.configs[GROUND_MAP].survivor_types
			if(length(survivor_types))
				return pick(survivor_types)
			return /datum/equipment_preset/survivor
		if(JOB_SYNTH_SURVIVOR)
			var/list/survivor_types = pref_special_job_options[JOB_SURVIVOR] != ANY_SURVIVOR && length(SSmapping.configs[GROUND_MAP].synth_survivor_types_by_variant[pref_special_job_options[JOB_SURVIVOR]]) ? SSmapping.configs[GROUND_MAP].synth_survivor_types_by_variant[pref_special_job_options[JOB_SURVIVOR]] : SSmapping.configs[GROUND_MAP].synth_survivor_types
			if(length(survivor_types))
				return pick(survivor_types)
			return /datum/equipment_preset/synth/survivor
		if(JOB_CO_SURVIVOR)
			if(length(SSmapping.configs[GROUND_MAP].CO_survivor_types))
				return pick(SSmapping.configs[GROUND_MAP].CO_survivor_types)
			return /datum/equipment_preset/uscm_co
		if(JOB_PREDATOR)
			var/datum/job/J = GLOB.RoleAuthority.roles_by_name[JOB_PREDATOR]
			return J.gear_preset_whitelist["[JOB_PREDATOR][J.get_whitelist_status(owner)]"]

	return /datum/equipment_preset/uscm/private_equipped

/datum/preferences/proc/clear_equipment()
	for(var/obj/item/I in preview_dummy)
		qdel(I)
