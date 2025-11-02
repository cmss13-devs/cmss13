// Handled by basic version
/datum/action/xeno_action/onclick/toggle_long_range/boiler

// Not used
// /datum/action/xeno_action/activable/acid_lance

/datum/action/xeno_action/onclick/shift_spits/boiler
	desc = "Переключить вид газа."

/datum/action/xeno_action/onclick/shift_spits/boiler/use_ability(atom/affected_atom)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/action/xeno_action/activable/tail_stab/tail = get_action(xeno, /datum/action/xeno_action/activable/tail_stab)
	tail.update_desc()

// Handled by basic version
/datum/action/xeno_action/activable/spray_acid/boiler

/datum/action/xeno_action/activable/xeno_spit/bombard
	desc = "Дальнобойный плевок, который взрывается по области. При прямом попадании наносит дополнительные эффекты.\
		<br>После плевка накладывается перезарядка на Acid Shroud на %COOLDOWN_DEBUFF%"

/datum/action/xeno_action/activable/xeno_spit/bombard/apply_replaces_in_desc()
	. = ..()
	replace_in_desc("%COOLDOWN_DEBUFF%", cooldown_duration / 10, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/acid_shroud
	desc = "Начать зарядку выплескивания газа выбранного плевка вокруг себя на расстоянии %DISTANCE% через %WINDUP%\
		<br>После использования накладывается перезарядка на все способности на %COOLDOWN_DEBUFF%"

/datum/action/xeno_action/onclick/acid_shroud/apply_replaces_in_desc()
	replace_in_desc("%COOLDOWN_DEBUFF%", cooldown_duration / 10, DESCRIPTION_REPLACEMENT_TIME)
	var/mob/living/carbon/xenomorph/xeno = owner
	replace_in_desc("%WINDUP%", xeno.ammo.spit_windup/65, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DISTANCE%", 1, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/activable/boiler_trap
	desc = "Создаёт линию ловушек размером 1x5. При активации не даёт передвигаться носителю %ROOT_TIME% (%ROOT_TIME_EMP% при усиленных ловушках).\
		<br>Создание усиленных ловушек усилит нашу следующую Acid Mine.\
		<br>Чтобы создать усиленную ловушку, нужно попасть по обездвиженному ловушкой с помощью Acid Shotgun, или успешно попасть с помощью %EMPOWER_MAX_CHARGES% снарядов из Acid Shotgun.\
		<br>Ловушки живут %LIFE_TIME%"

/datum/action/xeno_action/activable/boiler_trap/apply_replaces_in_desc()
	replace_in_desc("%ROOT_TIME%", /obj/effect/alien/resin/boilertrap::root_duration / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%ROOT_TIME_EMP%", /obj/effect/alien/resin/boilertrap/empowered::root_duration / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%EMPOWER_MAX_CHARGES%", empower_charge_max)
	replace_in_desc("%LIFE_TIME%", trap_ttl / 10, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/acid_mine
	desc = "Создаёт область мин размером 3x3, которая взрывается через %DETONATION_DELAY%\
		<br>Наносит %DAMAGE% урона при взрыве.\
		<br>Усиленный взрыв создаёт кислоту на носителях с периодическим уроном (всего %DAMAGE_ACID%).\
		<br>Наносит на %DAMAGE_TRAP%% больше урона по тем, кто находися в ловушке из Deploy Trap.\
		<br>Каждое успешное попадание по носителю уменьшает текущую перезарядку Deploy Trap на %COOLDOWN_REDUCTION%"

/datum/action/xeno_action/activable/acid_mine/apply_replaces_in_desc()
	replace_in_desc("%DETONATION_DELAY%", delay / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DAMAGE%", damage)
	replace_in_desc("%DAMAGE_TRAP%", 45)
	replace_in_desc("%DAMAGE_ACID%", /datum/effects/acid::damage_in_total_human)
	replace_in_desc("%COOLDOWN_REDUCTION%", 4, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/acid_shotgun
	desc = "Выстрелить дробовиком из кислоты. Каждый снаряд замедляет цель (%SLOWDOWN_TIME%)\
		<br>Носитель, застрявший в ловушке Deploy Trap, получает на %TRAPPED_BONUS_DAMAGE% от каждого снаряда."

/datum/action/xeno_action/activable/acid_shotgun/apply_replaces_in_desc()
	replace_in_desc("%SLOWDOWN_TIME%", convert_effect_time(2, SLOW), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%TRAPPED_BONUS_DAMAGE%", /datum/behavior_delegate/boiler_trapper::bonus_damage_shotgun_trapped)
	var/datum/ammo/xeno/spit = GLOB.ammo_list[ammo_type]
	desc += "[spit.get_description()]"

// Handled by basic version
/datum/action/xeno_action/onclick/toggle_long_range/trapper

/datum/action/xeno_action/activable/tail_stab/boiler

/datum/action/xeno_action/activable/tail_stab/boiler/apply_replaces_in_desc()
	. = ..()
	desc += "<br>Вводит химикаты взависимости от выбранного плевка."
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas/acid])
		desc += "<br>Сейчас: <b>6</b> ед. [/datum/reagent/toxin/molecular_acid::name] (всего <b>90</b> урона)."
	else if(xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas])
		desc += "<br>Сейчас: <b>20</b> стаков нейротоксина."
