// Мотоцикл с коляской
/obj/vehicle/motorbike/full
	create_stroller = TRUE

// ==========================================
// ============== Camo skin ===============

// Камуфлирование под текущую карту

/obj/vehicle/motorbike/camo
	need_camo = TRUE

/obj/structure/bed/chair/stroller/camo
	need_camo = TRUE

/obj/vehicle/motorbike/camo/full
	create_stroller = TRUE

// Функции выбора скина
/obj/vehicle/motorbike/proc/select_gamemode_skin()
	if(flags_atom & NO_GAMEMODE_SKIN)
		return
	var/skin = SSmapping.configs[GROUND_MAP].camouflage_type
	switch(skin)
		if("snow")
			icon_skin = skin
		if("desert")
			icon_skin = skin
		if("classic")
			icon_skin = skin
		if("urban")
			icon_skin = skin

/obj/structure/bed/chair/stroller/proc/select_gamemode_skin()
	if(flags_atom & NO_GAMEMODE_SKIN)
		return
	var/skin = SSmapping.configs[GROUND_MAP].camouflage_type
	switch(skin)
		if("snow")
			icon_skin = skin
		if("desert")
			icon_skin = skin
		if("classic")
			icon_skin = skin
		if("urban")
			icon_skin = skin

// ==========================================
// ============== Desert skin ===============

/obj/vehicle/motorbike/desert
	icon_state = "moto_ural_desert"
	icon_skin = "desert"

/obj/structure/bed/chair/stroller/desert
	icon_state = "moto_ural_stroller_desert"
	icon_skin = "desert"

/obj/vehicle/motorbike/desert/full
	create_stroller = TRUE


// ==========================================
// =============== Snow skin ================

/obj/vehicle/motorbike/snow
	icon_state = "moto_ural_snow"
	icon_skin = "snow"

/obj/structure/bed/chair/stroller/snow
	icon_state = "moto_ural_stroller_snow"
	icon_skin = "snow"

/obj/vehicle/motorbike/snow/full
	create_stroller = TRUE


// ==========================================
// =============== Urban skin ===============

/obj/vehicle/motorbike/urban
	icon_state = "moto_ural_urban"
	icon_skin = "urban"

/obj/structure/bed/chair/stroller/urban
	icon_state = "moto_ural_stroller_urban"
	icon_skin = "urban"

/obj/vehicle/motorbike/urban/full
	create_stroller = TRUE


// ==========================================
// ================== Debug =================
// Машинка для тестов
/obj/vehicle/motorbike/debug
	name = "Мотоцикл главного инженера"
	desc = "Это модифицированный и улучшенный мотоцикл главного инженера для проверки... ВСЕГО. И черт возьми, он не разрушаем."
	health = 1000000
	maxhealth = 1000000
	icon_state = "moto_ural_urban"
	icon_skin = "urban"
	required_skill = SKILL_VEHICLE_DEFAULT
	wrench_time = 5
	welder_health = 200

/obj/vehicle/motorbike/debug/full
	create_stroller = TRUE


/obj/vehicle/motorbike/debug/New(loc, skin)
	create_stroller = FALSE
	. = ..(loc, skin)
	create_stroller = initial(create_stroller)
	if(create_stroller)
		stroller = new /obj/structure/bed/chair/stroller/debug(src, icon_skin)
		update_stroller(TRUE)
		update_connect_params()
	update_overlay()

/obj/structure/bed/chair/stroller/debug
	name = "Коляска главного инженера"
	desc = "Эта коляска сделана из пластитаниума. Разве такой материал вообще существует?"
	health = 1000000
	maxhealth = 1000000
	icon_state = "moto_ural_stroller_urban"
	icon_skin = "urban"
	buckle_time = 0.5 SECONDS
	mounted_time_to_disassembly = 0.5 SECONDS
	mounted_time_to_assembly = 0.5 SECONDS
	welder_health = 200
