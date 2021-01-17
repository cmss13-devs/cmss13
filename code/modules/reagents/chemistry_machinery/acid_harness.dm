//------------------ACID DEFINES--------------------//
#define ACID_LOGIC_OR								"OR"
#define ACID_LOGIC_AND								"AND"
//Damage types
#define ACID_SCAN_DAMAGE_BRUTE						1
#define ACID_SCAN_DAMAGE_BURN						2
#define ACID_SCAN_DAMAGE_TOXIN						4
#define ACID_SCAN_DAMAGE_OXYGEN						8
#define ACID_SCAN_DAMAGE_CLONE						16
#define ACID_SCAN_DAMAGE_HEART						32
#define ACID_SCAN_DAMAGE_LIVER						64
#define ACID_SCAN_DAMAGE_LUNGS						128
#define ACID_SCAN_DAMAGE_KIDNEYS					256
#define ACID_SCAN_DAMAGE_BRAIN						512

//Conditions
#define ACID_SCAN_CONDITION_VITALS					1
#define ACID_SCAN_CONDITION_BLEEDING				2
#define ACID_SCAN_CONDITION_BLEEDING_INTERNAL		4
#define ACID_SCAN_CONDITION_BLOODLOSS_HIGH			8
#define ACID_SCAN_CONDITION_FRACTURE				16
#define ACID_SCAN_CONDITION_SPLINT					32
#define ACID_SCAN_CONDITION_ORGAN_DAMAGED			64
#define ACID_SCAN_CONDITION_ORGAN_FAILURE			128
#define ACID_SCAN_CONDITION_DEATH	 				256
#define ACID_SCAN_CONDITION_DEFIB					512
#define ACID_SCAN_CONDITION_CONCUSSION				1024
#define ACID_SCAN_CONDITION_INTOXICATION			2048
#define ACID_SCAN_CONDITION_FOREIGN_OBJECT			4096

//Vitals status
#define ACID_VITALS_OPTIMAL							1
#define ACID_VITALS_NOMINAL							2
#define ACID_VITALS_DROPPING						4
#define ACID_VITALS_LOW								8
#define ACID_VITALS_CRITICAL						16
#define ACID_VITALS_EMERGENCY						32
#define ACID_VITALS_DEAD							64

/obj/item/clothing/accessory/storage/black_vest/acid_harness
	name = "A.C.I.D. Harness"
	desc = "Automated Chemical Integrated Delivery Harness, or really just a franken webbing made by a researcher with poor tailoring skills."
	icon_state = "vest_acid_black"
	slots = 2
	var/obj/item/reagent_container/glass/beaker/vial/vial
	var/obj/item/cell/battery
	var/obj/structure/machinery/acid_core/acid_core

/obj/item/clothing/accessory/storage/black_vest/acid_harness/brown
	icon_state = "vest_acid_brown"

/obj/item/clothing/accessory/storage/black_vest/acid_harness/Initialize()
	. = ..()
	acid_core = new /obj/structure/machinery/acid_core(src)
	acid_core.acid_harness = src
	if(loc && loc.loc && ishuman(loc.loc))
		acid_core.user = loc.loc

/obj/item/clothing/accessory/storage/black_vest/acid_harness/attackby(obj/item/B, mob/living/user)
	if(ismultitool(B))
		ui_interact(user)
		return
	. = ..()

/obj/item/clothing/accessory/storage/black_vest/acid_harness/Destroy()
	QDEL_NULL(vial)
	QDEL_NULL(battery)
	QDEL_NULL(acid_core)
	. = ..()

/obj/item/clothing/accessory/storage/black_vest/acid_harness/equipped(mob/user, slot)
	acid_core.user = user
	. = ..()

/obj/item/clothing/accessory/storage/black_vest/acid_harness/on_removed(mob/living/user, obj/item/clothing/C)
	acid_core.user = null
	. = ..()

/obj/item/clothing/accessory/storage/black_vest/acid_harness/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = TRUE)
	var/list/data = list(
		"inject_amount" = acid_core.inject_amount,
		"inject_damage_threshold" = acid_core.inject_damage_threshold,
		"inject_logic" = acid_core.inject_logic,
		"config" = list(
			"Damage" = list(
				"Brute" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_BRUTE),ACID_SCAN_DAMAGE_BRUTE),
				"Burn" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_BURN),ACID_SCAN_DAMAGE_BURN),
				"Toxin" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_TOXIN),ACID_SCAN_DAMAGE_TOXIN),
				"Oxygen" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_OXYGEN),ACID_SCAN_DAMAGE_OXYGEN),
				"Genetic" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_CLONE),ACID_SCAN_DAMAGE_CLONE),
				"Heart" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_HEART),ACID_SCAN_DAMAGE_HEART),
				"Liver" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_LIVER),ACID_SCAN_DAMAGE_LIVER),
				"Lungs" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_LUNGS),ACID_SCAN_DAMAGE_LUNGS),
				"Kidneys" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_KIDNEYS),ACID_SCAN_DAMAGE_KIDNEYS),
				"Brain" = list(check_bitflag(acid_core.inject_damage_types, ACID_SCAN_DAMAGE_BRAIN),ACID_SCAN_DAMAGE_BRAIN)
			),
			"Conditions" = list(
				"Vitals Level" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_VITALS),ACID_SCAN_CONDITION_VITALS),
				"Bleeding" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_BLEEDING),ACID_SCAN_CONDITION_BLEEDING),
				"Internal" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_BLEEDING_INTERNAL),ACID_SCAN_CONDITION_BLEEDING_INTERNAL),
				"Bloodloss" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_BLOODLOSS_HIGH),ACID_SCAN_CONDITION_BLOODLOSS_HIGH),
				"Fracture" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_FRACTURE),ACID_SCAN_CONDITION_FRACTURE),
				"Splinted" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_SPLINT),ACID_SCAN_CONDITION_SPLINT),
				"Organ Damage" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_ORGAN_DAMAGED),ACID_SCAN_CONDITION_ORGAN_DAMAGED),
				"Organ Failure" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_ORGAN_FAILURE),ACID_SCAN_CONDITION_ORGAN_FAILURE),
				"Death" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_DEATH),ACID_SCAN_CONDITION_DEATH),
				"Defibrillation" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_DEFIB),ACID_SCAN_CONDITION_DEFIB),
				"Concussion" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_CONCUSSION),ACID_SCAN_CONDITION_CONCUSSION),
				"Intoxication" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_INTOXICATION),ACID_SCAN_CONDITION_INTOXICATION),
				"Foreign Object" = list(check_bitflag(acid_core.inject_conditions, ACID_SCAN_CONDITION_FOREIGN_OBJECT),ACID_SCAN_CONDITION_FOREIGN_OBJECT)
			),
			"Vitals" = list(
				"Optimal" = list(check_bitflag(acid_core.inject_vitals, ACID_VITALS_OPTIMAL),ACID_VITALS_OPTIMAL),
				"Nominal" = list(check_bitflag(acid_core.inject_vitals, ACID_VITALS_NOMINAL),ACID_VITALS_NOMINAL),
				"Low" = list(check_bitflag(acid_core.inject_vitals, ACID_VITALS_DROPPING),ACID_VITALS_DROPPING),
				"Very low" = list(check_bitflag(acid_core.inject_vitals, ACID_VITALS_LOW),ACID_VITALS_LOW),
				"Critical" = list(check_bitflag(acid_core.inject_vitals, ACID_VITALS_CRITICAL),ACID_VITALS_CRITICAL),
				"Emergency" = list(check_bitflag(acid_core.inject_vitals, ACID_VITALS_EMERGENCY),ACID_VITALS_EMERGENCY)
			)
		)
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "acid_core_config.tmpl", "A.C.I.D. CORE CONFIG", 460, 760)
		ui.set_initial_data(data)
		ui.open()


/obj/item/clothing/accessory/storage/black_vest/acid_harness/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained())
		return
	if(href_list["inject_amount"])
		acid_core.inject_amount = input("Set inject amount:","[src]") as num
		if(acid_core.inject_amount < 1)
			acid_core.inject_amount = 1
	else if(href_list["inject_damage_threshold"])
		acid_core.inject_damage_threshold = input("Set damage threshold:","[src]") as num
	else if(href_list["inject_logic"])
		if(acid_core.inject_logic == ACID_LOGIC_OR)
			acid_core.inject_logic = ACID_LOGIC_AND
		else
			acid_core.inject_logic = ACID_LOGIC_OR
	else if(href_list["config_type"])
		var/flag_value = text2num(href_list["config_value"])
		switch(href_list["config_type"])
			if("Damage")
				if(acid_core.inject_damage_types & flag_value)
					acid_core.inject_damage_types &= ~flag_value
				else
					acid_core.inject_damage_types |= flag_value
			if("Conditions")
				if(acid_core.inject_conditions & flag_value)
					acid_core.inject_conditions &= ~flag_value
				else
					acid_core.inject_conditions |= flag_value
			if("Vitals")
				if(acid_core.inject_vitals & flag_value)
					acid_core.inject_vitals &= ~flag_value
				else
					acid_core.inject_vitals |= flag_value


	nanomanager.update_uis(src) // update all UIs attached to src
	add_fingerprint(user)


/obj/structure/machinery/acid_core
	name = "A.C.I.D. CORE"
	use_power = FALSE
	var/obj/item/clothing/accessory/storage/black_vest/acid_harness/acid_harness
	var/mob/living/carbon/human/user

	var/inject_amount = 5
	var/inject_damage_threshold = 20 			//How much damage before we inject?
	var/inject_logic = ACID_LOGIC_OR
	var/inject_damage_types 					//We inject if damage is above the threshold
	var/inject_conditions 						//We inject if the any of the conditions are TRUE
	var/inject_vitals							//The vitals statuses that we set the vitals status condition to true under

	var/last_damage_scan 						//So we can tell if there's new damage since the last scan.
	var/last_condition_scan 					//So we can tell if there's a new condition since the last scan.
	var/last_vitals_scan = ACID_VITALS_OPTIMAL 	//We need to know the last scan to tell if we are improving or not
	var/vitals_improving = TRUE 				//We don't need to inject if we're still improving

	//Current status
	var/boot_status = FALSE
	var/battery_level = FALSE
	var/rechecking = FALSE

/obj/structure/machinery/acid_core/Initialize(mapload, ...)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/acid_core/LateInitialize()
	. = ..()
	start_processing()

/obj/structure/machinery/acid_core/proc/boot_sequence()
	if(!user || !acid_harness.battery)
		return
	var/text = SPAN_HELPFUL("A.C.I.D. states: ")
	switch(boot_status)
		if(0)
			if(acid_harness.battery.charge <= 100)
				to_chat(user, SPAN_HELPFUL("A.C.I.D. states: ") + SPAN_WARNING("Insufficient power, booting sequence aborted."))
				return
			text += SPAN_NOTICE("Welcome, to the Automated Chemical Integrated Delivery harness.")
		if(1)
			text += SPAN_NOTICE("Core systems, initialized.")
		if(2)
			text += SPAN_NOTICE("Communication interface, online.")
			playsound_client(user.client, 'sound/handling/toggle_nv1.ogg', null, ITEM_EQUIP_VOLUME)
		if(3)
			text += SPAN_NOTICE("Vital signs monitoring, activated.")
			playsound_client(user.client, 'sound/items/detector_turn_on.ogg', null, ITEM_EQUIP_VOLUME)
		if(4)
			text += SPAN_NOTICE("Automated medical systems, engaged.")
			playsound_client(user.client, 'sound/items/healthanalyzer.ogg', null, ITEM_EQUIP_VOLUME)
		if(5)
			text += SPAN_NOTICE("Bootup sequence finalized. Have a very healthy operation.")
		else
			return
	to_chat(user, text)
	boot_status++

/obj/structure/machinery/acid_core/proc/voice(var/voiceline, var/report_vitals = FALSE)
	if(!user)
		return
	var/text = SPAN_HELPFUL("A.C.I.D. states: ")
	if(report_vitals)
		switch(voiceline)
			if(ACID_VITALS_OPTIMAL)
				text += SPAN_NOTICE("Vital signs are in optimal condition.")
			if(ACID_VITALS_NOMINAL)
				text += SPAN_NOTICE("Vital signs nominal.")
			if(ACID_VITALS_DROPPING)
				text += SPAN_WARNING("Vital signs dropping. Medical attention is adviced.")
			if(ACID_VITALS_LOW)
				text += SPAN_WARNING("Vital signs low. Seek medical attention.")
			if(ACID_VITALS_CRITICAL)
				text += SPAN_DANGER("Warning: Vitals signs critical. Seek medical attention immediately.")
			if(ACID_VITALS_EMERGENCY)
				text += SPAN_HIGHDANGER("EMERGENCY. USER. DEATH. IMMINENT.")
	else
		switch(voiceline)
			if(ACID_SCAN_CONDITION_BLEEDING)
				text += SPAN_WARNING("Warning: Blood loss detected.")
			if(ACID_SCAN_CONDITION_BLEEDING_INTERNAL)
				text += SPAN_DANGER("Warning: Internal bleeding detected.")
			if(ACID_SCAN_CONDITION_BLOODLOSS_HIGH)
				text += SPAN_DANGER("Warning: Extreme blood loss detected.")
			if(ACID_SCAN_CONDITION_FRACTURE)
				text += SPAN_WARNING("Warning: Major fracture detected.")
			if(ACID_SCAN_CONDITION_ORGAN_DAMAGED)
				text += SPAN_DANGER("Warning: Organ damage detected.")
			if(ACID_SCAN_CONDITION_ORGAN_FAILURE)
				text += SPAN_DANGER("Warning: Organ failure imminent.")
			else
				text += SPAN_NOTICE(voiceline)
	to_chat(user, text)

/obj/structure/machinery/acid_core/process()
	if(!check_user() || !check_inventory() || acid_harness.battery.charge <= 0)
		boot_status = FALSE
		battery_level = FALSE
		return
	check_battery(acid_harness.battery)
	if(boot_status < 6)
		addtimer(CALLBACK(src, .proc/boot_sequence, boot_status), 2 SECONDS)
		return
	scan()

/obj/structure/machinery/acid_core/proc/check_user()
	if(acid_harness.loc && acid_harness.loc.loc && ishuman(acid_harness.loc.loc))
		user = acid_harness.loc.loc
		return TRUE
	user = null
	return FALSE

/obj/structure/machinery/acid_core/proc/check_inventory()
	acid_harness.battery = null
	acid_harness.vial = null
	for(var/item in acid_harness.hold.contents)
		if(istype(item, /obj/item/reagent_container/glass/beaker/vial))
			acid_harness.vial = item
		else if(istype(item, /obj/item/cell))
			acid_harness.battery = item
	if(acid_harness.battery)
		return TRUE
	return FALSE

/obj/structure/machinery/acid_core/proc/check_battery(var/obj/item/cell/battery)
	battery.charge = max(battery.charge - 10, 0)
	var/charge = battery.charge / battery.maxcharge * 100
	if(charge + 20 < battery_level || charge > battery_level)
		battery_level = charge
		voice("Energy is at, [charge]%.")

/obj/structure/machinery/acid_core/proc/recheck_conditions()
	rechecking = TRUE

/obj/structure/machinery/acid_core/proc/scan()
	var/damage_scan = FALSE
	var/condition_scan = FALSE
	var/vitals_scan = FALSE

	//Scan damage types
	var/damage_brute = user.getBruteLoss()
	var/damage_burn = user.getFireLoss()
	var/damage_toxin = user.getToxLoss()
	var/damage_oxygen = user.getOxyLoss()
	var/damage_clone = user.getCloneLoss()

	if(inject_damage_types & ACID_SCAN_DAMAGE_BRUTE && damage_brute > inject_damage_threshold)
		damage_scan |= ACID_SCAN_DAMAGE_BRUTE
	if(inject_damage_types & ACID_SCAN_DAMAGE_BURN && damage_burn > inject_damage_threshold)
		damage_scan |= ACID_SCAN_DAMAGE_BURN
	if(inject_damage_types & ACID_SCAN_DAMAGE_TOXIN && damage_toxin > inject_damage_threshold)
		damage_scan |= ACID_SCAN_DAMAGE_TOXIN
	if(inject_damage_types & ACID_SCAN_DAMAGE_OXYGEN && damage_oxygen > inject_damage_threshold)
		damage_scan |= ACID_SCAN_DAMAGE_OXYGEN
	if(inject_damage_types & ACID_SCAN_DAMAGE_CLONE && damage_clone > inject_damage_threshold)
		damage_scan |= ACID_SCAN_DAMAGE_CLONE

	var/health = user.maxHealth - damage_brute - damage_burn - damage_toxin - damage_oxygen - damage_clone

	//Organ damage
	var/datum/internal_organ/heart/H = user.internal_organs_by_name["heart"]
	var/datum/internal_organ/liver/L = user.internal_organs_by_name["liver"]
	var/datum/internal_organ/lungs/U = user.internal_organs_by_name["lungs"]
	var/datum/internal_organ/kidneys/K = user.internal_organs_by_name["kidneys"]
	var/datum/internal_organ/brain/B = user.internal_organs_by_name["brain"]

	if(H)
		health -= H.damage
		if(inject_damage_types & ACID_SCAN_DAMAGE_HEART && H.damage > inject_damage_threshold)
			damage_scan |= ACID_SCAN_DAMAGE_HEART
	if(L)
		health -= L.damage
		if(inject_damage_types & ACID_SCAN_DAMAGE_LIVER && L.damage > inject_damage_threshold)
			damage_scan |= ACID_SCAN_DAMAGE_LIVER
	if(U)
		health -= U.damage
		if(inject_damage_types & ACID_SCAN_DAMAGE_LUNGS && U.damage > inject_damage_threshold)
			damage_scan |= ACID_SCAN_DAMAGE_LUNGS
	if(K)
		health -= K.damage
		if(inject_damage_types & ACID_SCAN_DAMAGE_KIDNEYS && K.damage > inject_damage_threshold)
			damage_scan |= ACID_SCAN_DAMAGE_KIDNEYS
	if(B)
		health -= B.damage
		if(inject_damage_types & ACID_SCAN_DAMAGE_BRAIN && B.damage > inject_damage_threshold)
			damage_scan |= ACID_SCAN_DAMAGE_BRAIN

	//Vitals status
	if(user.stat == DEAD)
		vitals_scan = ACID_VITALS_DEAD
	else
		health = health / user.maxHealth * 100 //% for simplicity
		switch(health)
			if(100 to INFINITY)
				vitals_scan |= ACID_VITALS_OPTIMAL
			if(80 to 100)
				vitals_scan |= ACID_VITALS_NOMINAL
			if(40 to 80)
				vitals_scan |= ACID_VITALS_DROPPING
			if(10 to 40)
				vitals_scan |= ACID_VITALS_LOW
			if(-10 to 10)
				vitals_scan |= ACID_VITALS_CRITICAL
			else
				vitals_scan |= ACID_VITALS_EMERGENCY
		if(inject_conditions & ACID_SCAN_CONDITION_VITALS && vitals_scan > inject_vitals)
			condition_scan |= ACID_SCAN_CONDITION_VITALS

	//Conditions
	if(inject_conditions & ACID_SCAN_CONDITION_BLEEDING && user.is_bleeding())
		condition_scan |= ACID_SCAN_CONDITION_BLEEDING
		if(!(last_condition_scan & ACID_SCAN_CONDITION_BLEEDING))
			voice(ACID_SCAN_CONDITION_BLEEDING)
	if(inject_conditions & ACID_SCAN_CONDITION_BLEEDING_INTERNAL && user.is_bleeding_internal())
		condition_scan |= ACID_SCAN_CONDITION_BLEEDING_INTERNAL
		if(!(last_condition_scan & ACID_SCAN_CONDITION_BLEEDING_INTERNAL))
			voice(ACID_SCAN_CONDITION_BLEEDING_INTERNAL)
	if(inject_conditions & ACID_SCAN_CONDITION_BLOODLOSS_HIGH && user.blood_volume < BLOOD_VOLUME_OKAY)
		condition_scan |= ACID_SCAN_CONDITION_BLOODLOSS_HIGH
		if(!(last_condition_scan & ACID_SCAN_CONDITION_BLOODLOSS_HIGH))
			voice(ACID_SCAN_CONDITION_BLOODLOSS_HIGH)
	if(inject_conditions & ACID_SCAN_CONDITION_FRACTURE && user.has_broken_limbs())
		condition_scan |= ACID_SCAN_CONDITION_FRACTURE
		if(!(last_condition_scan & ACID_SCAN_CONDITION_FRACTURE))
			voice(ACID_SCAN_CONDITION_FRACTURE)
	if(inject_conditions & ACID_SCAN_CONDITION_SPLINT && user.has_splinted_limbs())
		condition_scan |= ACID_SCAN_CONDITION_SPLINT
	if(inject_conditions & ACID_SCAN_CONDITION_FOREIGN_OBJECT && user.has_foreign_object())
		condition_scan |= ACID_SCAN_CONDITION_FOREIGN_OBJECT

	for(var/datum/internal_organ/O in user.internal_organs)
		if(O.damage > O.min_bruised_damage)
			condition_scan |= ACID_SCAN_CONDITION_ORGAN_DAMAGED
			if(!(last_condition_scan & ACID_SCAN_CONDITION_ORGAN_DAMAGED))
				voice(ACID_SCAN_CONDITION_ORGAN_DAMAGED)
		if(O.damage > O.min_broken_damage)
			condition_scan |= ACID_SCAN_CONDITION_ORGAN_FAILURE
			if(!(last_condition_scan & ACID_SCAN_CONDITION_ORGAN_FAILURE))
				voice(ACID_SCAN_CONDITION_ORGAN_FAILURE)
			break

	if(inject_conditions & ACID_SCAN_CONDITION_DEATH && vitals_scan & ACID_VITALS_DEAD)
		condition_scan |= ACID_SCAN_CONDITION_DEATH
	else if(inject_conditions & ACID_SCAN_CONDITION_DEFIB && vitals_scan < ACID_VITALS_DEAD && last_vitals_scan & ACID_SCAN_CONDITION_DEATH)
		condition_scan |= ACID_SCAN_CONDITION_DEFIB //If we were previously dead and are now alive, we assume we got defibbed

	if(inject_conditions & ACID_SCAN_CONDITION_CONCUSSION && (user.knocked_down || user.knocked_out))
		condition_scan |= ACID_SCAN_CONDITION_CONCUSSION

	if(inject_conditions & ACID_SCAN_CONDITION_INTOXICATION && (user.dazed || user.slowed || user.confused || user.drowsyness || user.dizziness || user.druggy))
		condition_scan |= ACID_SCAN_CONDITION_INTOXICATION

	//Compare
	if(vitals_scan != last_vitals_scan)
		voice(vitals_scan, TRUE)
	if(rechecking)
		last_damage_scan = FALSE
		last_condition_scan = FALSE
		last_vitals_scan = FALSE
		rechecking = FALSE
	compare_scans(damage_scan, condition_scan)
	last_damage_scan = damage_scan
	last_condition_scan = condition_scan
	last_vitals_scan = vitals_scan

/obj/structure/machinery/acid_core/proc/compare_scans(var/damage_scan = 0, var/condition_scan = 0)
	if(inject_logic == ACID_LOGIC_OR) //OR logic
		if(~last_damage_scan & damage_scan || ~last_condition_scan & condition_scan) //If there's a new bit flagged, vitals has worsened
			inject()
	else if(damage_scan == inject_damage_types && condition_scan == inject_conditions) //AND logic
		inject()

/obj/structure/machinery/acid_core/proc/inject()
	if(!acid_harness.vial || !acid_harness.vial.reagents)
		voice("Warning: Medicinal capsule missing.")
		return
	for(var/datum/reagent/R in acid_harness.vial.reagents.reagent_list)
		if(user.reagents.get_reagent_amount(R.id) + inject_amount > R.overdose) //Don't overdose our boi
			voice("Notice: Injection trigger cancelled to avoid overdose.")
			addtimer(CALLBACK(src, .proc/recheck_conditions), 20 SECONDS * inject_amount)
			return
	if(acid_harness.vial.reagents.trans_to(user, inject_amount))
		playsound_client(user.client, 'sound/items/hypospray.ogg', null, ITEM_EQUIP_VOLUME)
		voice("Medicine administered. [acid_harness.vial.reagents.total_volume] units remaining.")
		addtimer(CALLBACK(src, .proc/recheck_conditions), 20 SECONDS * inject_amount)
	if(!acid_harness.vial.reagents.total_volume)
		voice("Warning: Medicinal capsule is empty, resupply required.")
