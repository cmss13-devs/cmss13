/datum/action/xeno_action/activable/pounce/charge

/datum/action/xeno_action/activable/pounce/charge/apply_replaces_in_desc()
	. = ..()
	desc += "<br><br>Если вы усилены, вы оглушите цель (%EMP_STUN%), нанесёте ей %EMP_DAMAGE% урона и откинете на %EMP_FLING%"
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/ravager_base/behavior = xeno.behavior_delegate
	if(!istype(behavior))
		return
	replace_in_desc("%EMP_STUN%", convert_effect_time(behavior.knockdown_amount, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%EMP_DAMAGE%", round((xeno.melee_damage_lower + xeno.melee_damage_upper) / 2, 1))
	replace_in_desc("%EMP_FLING%", behavior.fling_distance, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/onclick/empower
	desc = "При активации вы получаете щит размером %INITIAL_SHIELD%.\
		<br>Используйте повторно в течении %TIME%, чтобы получить %SHIELD_PER% щита за каждого противника в радиусе %RANGE% (максимум %MAX% противников).\
		<br>Если было %SUPER_EMPOWER% противников в радиусе, вы будете усилены."

/datum/action/xeno_action/onclick/empower/apply_replaces_in_desc()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/ravager_base/behavior = xeno.behavior_delegate
	if(!istype(behavior))
		return
	replace_in_desc("%RANGE%", empower_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%MAX%", max_targets)
	replace_in_desc("%SHIELD_PER%", shield_per_human)
	replace_in_desc("%TIME%", time_until_timeout / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%INITIAL_SHIELD%", initial_activation_shield)
	replace_in_desc("%SUPER_EMPOWER%", behavior.super_empower_threshold)

/datum/action/xeno_action/activable/scissor_cut
	desc = "Создаёт линию размером %RANGE%, наносящую %DAMAGE% урона всем целям внутри.\
		<br><br>Если вы усилены, вы также замедлите цели (%SLOW%)."

/datum/action/xeno_action/activable/scissor_cut/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", 4, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%DAMAGE%", damage)
	replace_in_desc("%SLOW%", superslow_duration / 10, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/apprehend
	desc = "На %DURATION% ускоряет вас, и ваша следующая атака замедлит цель (%SLOW%)."

/datum/action/xeno_action/onclick/apprehend/apply_replaces_in_desc()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/ravager_berserker/behavior = xeno.behavior_delegate
	if(!istype(behavior))
		return
	replace_in_desc("%DURATION%", buff_duration / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%SLOW%", convert_effect_time(behavior.slash_slow_duration, SLOW), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/clothesline
	desc = "Наносит противнику %DAMAGE% урона, лечит вас на %BASE_HEAL% если вы не горите, и отталкивает цель на %FLING%\
		<br><br>Если у вас было 2 единицы ярости, вы потратите ярость, получите ещё %ADDITIONAL_HEAL% здоровья, оттолкнёте на %FLING_EMP%, а также дезориентируете цель (%DAZE%)."

/datum/action/xeno_action/activable/clothesline/apply_replaces_in_desc()
	replace_in_desc("%BASE_HEAL%", base_heal)
	replace_in_desc("%ADDITIONAL_HEAL%", additional_healing_enraged)
	replace_in_desc("%DAMAGE%", damage)
	replace_in_desc("%FLING%", fling_dist_base - 1, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%FLING_EMP%", fling_dist_base, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%DAZE%", convert_effect_time(daze_amount, DAZE), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/eviscerate
	desc = "Использует всю ярость, чтобы нанести удар всем вокруг после задержки. Характеристики зависят от количества ярости.\
		<br>Урон: 5-70;\
		<br>Дальность: 1 кл., 2 кл. при 4 ярости;\
		<br>Задержка: 2 сек. - 1 сек."

/datum/action/xeno_action/onclick/spike_shield
	desc = "Создаёт щит размером %SHIELD% на %DURATION%, способный создавать %SHRAPNEL% ед. шрапнели при получении урона."

/datum/action/xeno_action/onclick/spike_shield/apply_replaces_in_desc()
	replace_in_desc("%DURATION%", shield_duration / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%SHIELD%", shield_amount)
	replace_in_desc("%SHRAPNEL%", shield_shrapnel_amount)
	var/datum/ammo/xeno/spit = GLOB.ammo_list[/datum/ammo/xeno/bone_chips/spread/short_range]
	desc += "[spit.get_description()]"

/datum/action/xeno_action/activable/rav_spikes
	desc = "Создаёт залп шрапнели веером перед вами."

/datum/action/xeno_action/activable/rav_spikes/apply_replaces_in_desc()
	var/datum/ammo/xeno/spit = GLOB.ammo_list[ammo_type]
	desc += "[spit.get_description()]"

/datum/action/xeno_action/onclick/spike_shed
	desc = "Создаёт залп шрапнели вокруг вас."

/datum/action/xeno_action/onclick/spike_shed/apply_replaces_in_desc()
	var/datum/ammo/xeno/spit = GLOB.ammo_list[ammo_type]
	desc += "[spit.get_description()]"
