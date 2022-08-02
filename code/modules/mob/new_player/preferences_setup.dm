//The mob should have a gender you want before running this proc. Will run fine without H
datum/preferences/proc/randomize_appearance(var/mob/living/carbon/human/H)
	if(H)
		if(H.gender == MALE)
			gender = MALE
		else
			gender = FEMALE

	ethnicity = random_ethnicity()
	body_type = random_body_type()

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

datum/preferences/proc/randomize_hair_color(var/target = "hair")
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

datum/preferences/proc/randomize_eyes_color()
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



datum/preferences/proc/randomize_skin_color()
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

/datum/preferences/proc/update_preview_icon()
	if(!owner)
		return

	var/J = job_pref_to_gear_preset()
	if(isnull(preview_dummy))
		preview_dummy = new()
	clear_equipment()
	preview_dummy.set_species()
	copy_appearance_to(preview_dummy)
	preview_dummy.update_body()
	preview_dummy.update_hair()

	arm_equipment(preview_dummy, J, FALSE, FALSE, owner, show_job_gear)

	if(isnull(preview_front))
		preview_front = new()
		owner.screen |= preview_front
		preview_front.vis_contents += preview_dummy
		preview_front.screen_loc = "preview:0,0"
	preview_front.icon_state = bg_state

	if(isnull(rotate_left))
		rotate_left = new(null, preview_dummy)
		owner.screen |= rotate_left
		rotate_left.screen_loc = "preview:-1:16,0"

	if(isnull(rotate_right))
		rotate_right = new(null, preview_dummy)
		owner.screen |= rotate_right
		rotate_right.screen_loc = "preview:1:-16,0"

/datum/preferences/proc/job_pref_to_gear_preset()
	var/high_priority
	for(var/job in job_preference_list)
		if(job_preference_list[job] == 1)
			high_priority = job

	switch(high_priority)
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
		if(JOB_SQUAD_RTO)
			return /datum/equipment_preset/uscm/rto_equipped
		if(JOB_CO)
			if(length(RoleAuthority.roles_whitelist))
				var/datum/job/J = RoleAuthority.roles_by_name[JOB_CO]
				return J.gear_preset_whitelist["[JOB_CO][J.get_whitelist_status(RoleAuthority.roles_whitelist, owner)]"]
			return /datum/equipment_preset/uscm_ship/commander
		if(JOB_SO)
			return /datum/equipment_preset/uscm_ship/so
		if(JOB_XO)
			return /datum/equipment_preset/uscm_ship/xo
		if(JOB_INTEL)
			return /datum/equipment_preset/uscm/intel/full
		if(JOB_PILOT)
			return /datum/equipment_preset/uscm_ship/po/full
		if(JOB_DROPSHIP_CREW_CHIEF)
			return /datum/equipment_preset/uscm_ship/dcc/full
		if(JOB_CORPORATE_LIAISON)
			return /datum/equipment_preset/uscm_ship/liaison
		if(JOB_SYNTH)
			if(length(RoleAuthority.roles_whitelist))
				var/datum/job/J = RoleAuthority.roles_by_name[JOB_SYNTH]
				return J.gear_preset_whitelist["[JOB_SYNTH][J.get_whitelist_status(RoleAuthority.roles_whitelist, owner)]"]
			return /datum/equipment_preset/synth/uscm
		if(JOB_WORKING_JOE)
			return /datum/equipment_preset/synth/working_joe
		if(JOB_POLICE_CADET)
			return /datum/equipment_preset/uscm_ship/uscm_police/mp_cadet
		if(JOB_POLICE)
			return /datum/equipment_preset/uscm_ship/uscm_police/mp
		if(JOB_CHIEF_POLICE)
			return /datum/equipment_preset/uscm_ship/uscm_police/cmp
		if(JOB_WARDEN)
			return /datum/equipment_preset/uscm_ship/uscm_police/warden
		if(JOB_CREWMAN)
			return /datum/equipment_preset/uscm/tank/full
		if(JOB_SEA)
			return /datum/equipment_preset/uscm_ship/sea
		if(JOB_CHIEF_ENGINEER)
			return /datum/equipment_preset/uscm_ship/chief_engineer
		if(JOB_ORDNANCE_TECH)
			return /datum/equipment_preset/uscm_ship/ordn
		if(JOB_MAINT_TECH)
			return /datum/equipment_preset/uscm_ship/maint
		if(JOB_CHIEF_REQUISITION)
			return /datum/equipment_preset/uscm_ship/ro
		if(JOB_CARGO_TECH)
			return /datum/equipment_preset/uscm_ship/cargo
		if(JOB_CMO)
			return /datum/equipment_preset/uscm_ship/uscm_medical/cmo
		if(JOB_DOCTOR)
			return /datum/equipment_preset/uscm_ship/uscm_medical/doctor
		if(JOB_RESEARCHER)
			return /datum/equipment_preset/uscm_ship/uscm_medical/researcher
		if(JOB_NURSE)
			return /datum/equipment_preset/uscm_ship/uscm_medical/nurse
		if(JOB_MESS_SERGEANT)
			return /datum/equipment_preset/uscm_ship/chef
		if(JOB_SURVIVOR)
			if(length(SSmapping.configs[GROUND_MAP].survivor_types))
				return pick(SSmapping.configs[GROUND_MAP].survivor_types)
			return /datum/equipment_preset/survivor
		if(JOB_SYNTH_SURVIVOR)
			return /datum/equipment_preset/synth/survivor
		if(JOB_PREDATOR)
			if(length(RoleAuthority.roles_whitelist))
				var/datum/job/J = RoleAuthority.roles_by_name[JOB_PREDATOR]
				return J.gear_preset_whitelist["[JOB_PREDATOR][J.get_whitelist_status(RoleAuthority.roles_whitelist, owner)]"]
			return /datum/equipment_preset/yautja/blooded

	return /datum/equipment_preset/uscm/private_equipped

/datum/preferences/proc/clear_equipment()
	for(var/obj/item/I in preview_dummy)
		qdel(I)
