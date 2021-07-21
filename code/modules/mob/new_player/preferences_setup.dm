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
	underwear = rand(1,underwear_m.len)
	undershirt = rand(1,undershirt_t.len)
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
	if(preview_front)
		preview_front.vis_contents.Cut()
	qdel(preview_front)

	var/J = job_pref_to_gear_preset()
	if(isnull(preview_dummy))
		preview_dummy = new()
	clear_equipment()
	preview_dummy.set_species()
	copy_appearance_to(preview_dummy)
	preview_dummy.update_body()
	preview_dummy.update_hair()

	arm_equipment(preview_dummy, J, FALSE, FALSE)
	
	preview_front = new()
	owner.screen |= preview_front
	preview_front.icon_state = "blank"
	preview_front.vis_contents += preview_dummy
	preview_front.screen_loc = "preview:0,0"

datum/preferences/proc/job_pref_to_gear_preset()
	var/high_priority
	for(var/job in job_preference_list)
		if(job_preference_list[job] == 1)
			high_priority = job
	
	switch(high_priority)
		if(JOB_SQUAD_MARINE)
			return "USCM Cryo Private (Equipped)"
		if(JOB_SQUAD_ENGI)
			return "USCM Cryo Engineer (Equipped)"
		if(JOB_SQUAD_LEADER)
			return "USCM Cryo Squad Leader (Equipped)"
		if(JOB_SQUAD_MEDIC)
			return "USCM Cryo Medic (Equipped)"
		if(JOB_SQUAD_SPECIALIST)
			return "USCM Cryo Specialist (Equipped)"
		if(JOB_SQUAD_SMARTGUN)
			return "USCM Cryo Smartgunner (Equipped)"
		if(JOB_SQUAD_RTO)
			return "USCM Cryo RT Operator (Equipped)"
		if(JOB_CO)
			return "USCM Captain (CO)"
		if(JOB_SO)
			return "USCM Staff Officer (SO)"
		if(JOB_XO)
			return "USCM Executive Officer (XO)"
		if(JOB_PILOT)
			return "USCM Pilot Officer (PO)"
		if(JOB_CORPORATE_LIAISON)
			return "USCM Corporate Liaison (CL)"
		if(JOB_SYNTH)
			return "USCM Synthetic"
		if(JOB_POLICE)
			return "USCM Military Police (MP)"
		if(JOB_CHIEF_POLICE)
			return "USCM Chief MP (CMP)"
		if(JOB_WARDEN)
			return "USCM Military Warden (MW)"
		if(JOB_CREWMAN)
			return "USCM Vehicle Crewman (CRMN)"
		if(JOB_SEA)
			return "USCM Senior Enlisted Advisor (SEA)"
		if(JOB_CHIEF_ENGINEER)
			return "USCM Chief Engineer (CE)"
		if(JOB_ORDNANCE_TECH)
			return "USCM Ordnance Technician (OT)"
		if(JOB_MAINT_TECH)
			return "USCM Maintenance Technician (MT)"
		if(JOB_CHIEF_REQUISITION)
			return "USCM Requisitions Officer (RO)"
		if(JOB_CARGO_TECH)
			return "USCM Cargo Technician (CT)"
		if(JOB_CMO)
			return "USCM Chief Medical Officer (CMO)"
		if(JOB_DOCTOR)
			return "USCM Doctor"
		if(JOB_RESEARCHER)
			return "USCM Researcher"
		if(JOB_NURSE)
			return "USCM Nurse"
		if(JOB_MESS_SERGEANT)
			return "USCM Mess Sergeant (MS)"	

	return "USCM Cryo Private (Equipped)"

datum/preferences/proc/clear_equipment()
	for(var/obj/item/I in preview_dummy)
		qdel(I)