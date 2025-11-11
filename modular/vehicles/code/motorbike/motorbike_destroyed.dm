/obj/motorbike_destroyed
	name = "Уничтоженный мотоцикл"
	desc = "Рухлядь, которая когда-то ездила и которую можно починить."
	icon = 'modular/vehicles/icons/moto48x48.dmi'
	icon_state = "moto_ural_classic-destroyed"	// Для отображения на картах
	var/icon_base = "moto_ural"
	var/icon_skin = "classic"
	var/icon_tag_destroyed = "destroyed"
	var/obj/obj_to_create_when_finish = /obj/vehicle/motorbike

	health = 250	// Чтобы был шанс что оно переживет еще немного урона
	var/maxhealth = 1250 // Раздолбанное чинить сложнее
	drag_delay = 10	// Тяжело тащить груду хлама
	projectile_coverage = PROJECTILE_COVERAGE_LOW

	var/welder_health = 35	// Восстановление прочности за 1 топливо из сварки * умноженное на размер сварки (2 или 3)
	var/welder_time = 3 SECONDS	// Время требуемое для сварки
	var/wires_need = 80 // В стаке 30 Штук -	/obj/item/stack/cable_coil
	var/wires_stored = 0
	var/wires_add_time = 3 DECISECONDS	// Время требуемое для прикладывания 1 штучки (в 1 секунде 10 дец)
	var/metal_need = 25	// В стаке 50 Штук -	var/obj/item/stack/sheet/metal
	var/metal_stored = 0
	var/metal_add_time = 2 DECISECONDS		// Время требуемое для прикладывания 1 штучки (в 1 секунде 10 дец)
	var/welding_step = FALSE
	var/coil_step  = FALSE
	var/screw_need = TRUE
	var/screw_step = FALSE
	var/screw_time = 20 SECONDS

/obj/motorbike_destroyed/stroller
	name = "Раздолбанная коляска"
	desc = "Рухлядь, больше не способная покатать малышей."
	icon_state = "moto_ural_stroller_classic-destroyed"	// Для отображения на картах
	icon_base = "moto_ural_stroller"
	obj_to_create_when_finish = /obj/structure/bed/chair/stroller

	wires_need = 40
	metal_need = 40
	maxhealth = 2000

/obj/motorbike_destroyed/New(loc, skin)
	icon_skin = skin
	icon_state = "[icon_base]_[icon_skin]-[icon_tag_destroyed]"
	. = ..()

/obj/motorbike_destroyed/get_examine_text(mob/user)
	. = ..()
	if(!isxeno(user))
		var/spare_text = get_spare_text()
		if(spare_text)
			. += SPAN_NOTICE(spare_text)

// ==========================================
// ================= Сборка =================
/obj/motorbike_destroyed/attackby(obj/item/O as obj, mob/user as mob)
	// Ремонт корпуса
	if(user.action_busy)
		to_chat(user, SPAN_WARNING("Вы уже чем-то заняты!"))
		return
	var/mob/living/L = user
	if(iswelder(O))
		if(metal_stored < metal_need)
			to_chat(user, SPAN_WARNING("Сначала приложите листы металла, нужно еще [metal_need - metal_stored] листов!"))
			return FALSE
		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("[O] недостаточен для ремонта корпуса!"))
			return FALSE
		var/obj/item/tool/weldingtool/WT = O
		if(health >= maxhealth)
			to_chat(user, SPAN_NOTICE("Корпус [src.name] в починке не нуждается!"))
			return TRUE
		if(WT.remove_fuel(1, user))
			if(!do_after(user, welder_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_BUILD))
				to_chat(user, SPAN_NOTICE("Вы прервали сварку корпуса [src.name] с помощью [O]."))
				return FALSE
			if(!src || !WT.isOn())
				to_chat(user, SPAN_NOTICE("Сварка корпуса [src.name] прервана из-за непригодных обстоятельств."))
				return FALSE
			var/procent = round((health / maxhealth) * 100)
			to_chat(user, SPAN_NOTICE("Вы сварили корпус [src.name] с помощью [O]. Сварено на [procent]%"))
			health = min(health + welder_health * WT.w_class, maxhealth)
			playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("В [O] не хватает топлива!"))
		if(health >= maxhealth)
			welding_step = TRUE
		return TRUE

	else if(istype(O, /obj/item/stack/sheet/metal))
		if(metal_stored >= metal_need)
			to_chat(user, SPAN_NOTICE("На [src] наложено достаточно листов металла!"))
			return
		if(!do_after(user, metal_add_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("Вы прервали наложение листов металлов на [src.name]."))
			return FALSE
		var/obj/item/stack/sheet/metal/M = O
		var/sheets_to_add = min(M.amount, metal_need - metal_stored)
		metal_stored += sheets_to_add
		M.use(sheets_to_add)
		metal_stored = min(metal_stored, metal_need)
		to_chat(user, SPAN_NOTICE("Вы приложили [sheets_to_add] [O] к [src]. \
			[metal_stored < metal_need ? "Осталось еще [metal_need - metal_stored]": ""]"))
		L.animation_attack_on(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
		return TRUE

	else if(iswire(O))
		if(wires_stored >= wires_need)
			to_chat(user, SPAN_NOTICE("На [src] наложено достаточно кабеля!"))
			return
		if(!do_after(user, wires_add_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("Вы прервали наложение листов металлов на [src.name]."))
			return FALSE
		var/obj/item/stack/cable_coil/C = O
		var/cables_to_add = min(C.amount, wires_need - wires_stored)
		wires_stored += cables_to_add
		C.use(cables_to_add)
		wires_stored = min(wires_stored, wires_need)
		to_chat(user, SPAN_NOTICE("Вы приложили [cables_to_add] [O] к [src]. \
			[wires_stored < wires_need ? "Осталось еще [wires_need - wires_stored]": ""]"))
		L.animation_attack_on(src)
		playsound(src.loc, 'sound/items/air_release.ogg', 25, 1)
		if(wires_stored >= wires_need)
			coil_step = TRUE
		return TRUE

	else if(screw_need && !screw_step && HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		if(!welding_step)
			to_chat(user, SPAN_WARNING("Сначала приварите металл к корпусу"))
			return
		if(!coil_step)
			to_chat(user, SPAN_WARNING("Сначала присоедините новые провода"))
			return
		to_chat(user, SPAN_WARNING("Вы вкручиваете винты у [src]. Ожидайте."))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
		L.animation_attack_on(src)
		if(!do_after(user, screw_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return FALSE
		to_chat(user, SPAN_NOTICE("Вы вкрутили винты у [src]."))
		playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, 1)
		screw_step = TRUE
		L.animation_attack_on(src)
		finish()
		return TRUE

	var/spare_text = get_spare_text()
	if(spare_text)
		to_chat(user, SPAN_NOTICE(spare_text))
	else
		L.animation_attack_on(src)
		finish()

	. = ..()

/obj/motorbike_destroyed/proc/get_spare_text()
	var/list/required = list("")
	if(metal_stored < metal_need)
		required += "Необходимо приложить [metal_need - metal_stored] листов металла"
	if(wires_stored < wires_need)
		required += "Необходимо приложить [wires_need - wires_stored] кабелей"
	if(health < maxhealth)
		required += "Необходимо сварить приложенные листы металла."
	if(screw_need && !screw_step)
		required += "Винты корпуса необходимо заключительно закрутить."
	if(length(required))
		return "Корпус [src.name] требует: [english_list(required, and_text = "\n\t", comma_text = "\n\t", nothing_text = FALSE)]"
	return FALSE

/obj/motorbike_destroyed/proc/finish()
	playsound(src.loc, 'sound/items/rped.ogg', 25, 1)
	new obj_to_create_when_finish(loc, icon_skin, FALSE)
	qdel(src)

// ==========================================
// ================== Урон ==================

// Главный чекер урона у vehicle, повторяем здесь же
/obj/motorbike_destroyed/proc/healthcheck(damage = 0)
	if(health - damage <= 0)
		explode()

/obj/motorbike_destroyed/update_health(damage = 0)
	healthcheck(damage)
	. = ..()

/obj/motorbike_destroyed/deconstruct(disassembled)
	healthcheck()
	. = ..()

/obj/motorbike_destroyed/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		return
	health -= M.melee_damage_upper
	src.visible_message(SPAN_DANGER("<B>[M] [M.attacktext] [src]!</B>"))
	M.attack_log += text("\[[time_stamp()]\] <font color='red'>рвет [src.name]</font>")
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	healthcheck()

/obj/motorbike_destroyed/bullet_act(obj/projectile/P)
	var/damage = P.damage
	health -= damage
	..()
	healthcheck()
	return TRUE

/obj/motorbike_destroyed/ex_act(severity)
	health -= severity*0.05
	health -= severity*0.1
	healthcheck()
	return

// Окончательное уничтожение. Увы.
/obj/motorbike_destroyed/proc/explode()
	src.visible_message(SPAN_DANGER("<B>[src] распался на части!</B>"), null, null, 1)
	var/turf/Tsec = get_turf(src)

	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)
	new /obj/item/hardpoint/locomotion/van_wheels(Tsec)
	new /obj/item/stack/sheet/metal/large_stack(Tsec)
	new /obj/item/stack/cable_coil/random(Tsec)
	new /obj/item/stack/cable_coil/random(Tsec)
	new /obj/item/stack/cable_coil/random(Tsec)

	new /obj/effect/spawner/gibspawner/robot(Tsec)
	new /obj/effect/decal/cleanable/blood/oil(src.loc)

	qdel(src)
