/datum/tutorial/marine/medical_basic
	name = "Морпех - Медицина (Базовое)"
	desc = "Обучись как лечиться от частых повреждений на поле боя."
	tutorial_id = "marine_medical_1"
	tutorial_template = /datum/map_template/tutorial/s7x7

// START OF SCRIPTING

/datum/tutorial/marine/medical_basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("Это обучение научит тебя лечить самого себя на поле боя.")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/brute_tutorial()
	message_to_player("Первый вид повреждений это <b>травма (brute)</b>, он очень распространён. Ты его получаешь когда тебя бьют, стреляют, или режут.")
	var/mob/living/living_mob = tutorial_mob
	living_mob.adjustBruteLoss(10)
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_2)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/brute_tutorial_2()
	message_to_player("Тебе плохо... Ты можешь осмотреть свои <b>травмы</b> или <b>ожоги</b> с помощью нажатия на себя в настрое помощи.")
	update_objective("Нажми на себя пустой рукой с настроем помощи.")
	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_health_examine))

/datum/tutorial/marine/medical_basic/proc/on_health_examine(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob != tutorial_mob)
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	message_to_player("Хорошо. Сейчас ты видишь что у тебя много <b>травм</b>. <b>Бикаридин (Бик)</b> используется что бы восстановится от травм. Возьми <b>автоинжектор EZ бикаридина</b> со стола и нажми им на себя.")
	update_objective("Нажми на себя автоинжектором бикаридина.")
	var/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use/brute_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(brute_injector)
	add_highlight(brute_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_brute_inject))

/datum/tutorial/marine/medical_basic/proc/on_brute_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use, brute_injector)
	remove_highlight(brute_injector)
	message_to_player("Вся медицина требует времени что бы вылечить тебя. Следующий тип повреждений это <b>ожоги</b>. Они появляются когда в тебя плюют кислотой или жарят огнемётом.")
	update_objective("")
	var/mob/living/living_mob = tutorial_mob
	living_mob.adjustFireLoss(10)
	addtimer(CALLBACK(src, PROC_REF(burn_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/burn_tutorial()
	message_to_player("<b>Келотан</b> используется что бы вылечить ожоги со временем. Введи себе <b>автоинжектор EZ келотана</b> со стола.")
	update_objective("Нажми на себя автоинжектором келотана.")
	var/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use/burn_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(burn_injector)
	add_highlight(burn_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_burn_inject))


/datum/tutorial/marine/medical_basic/proc/on_burn_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use, burn_injector)
	remove_highlight(burn_injector)
	message_to_player("Хорошо. Теперь, когда ты получил достаточно повреждений, ты будешь чувствовать <b>боль</b>. Боль замедляет тебя и ты упадёшь в болевой шок если оставишь её без обезболивающего.")
	update_objective("")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.apply_pain(PAIN_CHESTBURST_STRONG)
	addtimer(CALLBACK(src, PROC_REF(pain_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/pain_tutorial()
	message_to_player("<b>Трамадол</b> позволяет заглушить боль. Введи себе <b>автоинжектор EZ трамадола</b>.")
	update_objective("Нажми на себя автоинжектором трамадола.")
	var/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use/pain_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(pain_injector)
	add_highlight(pain_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_pain_inject))

/datum/tutorial/marine/medical_basic/proc/on_pain_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use, pain_injector)
	remove_highlight(pain_injector)
	message_to_player("Good. Keep in mind that you can overdose on chemicals, so don't inject yourself with the same chemical too much too often. In the field, injectors have 3 uses.")
	update_objective("Don't overdose! Generally, 3 injections of a chemical will overdose you.")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.apply_pain(-PAIN_CHESTBURST_STRONG) // just to make sure
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/bleed_tutorial()
	message_to_player("Иногда получая повреждения ты будешь <b>кровоточить</b>. Если ты истечёшь, ты будешь получать <b>кислородный (окси)</b> повреждения, и рано или поздно, приведёт тебя к смерти.")
	update_objective("")
	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	mob_chest.add_bleeding(damage_amount = 15)
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial_2)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/bleed_tutorial_2()
	message_to_player("Кровоточащие раны закрываются со временем, или ты можешь закрыть их быстрее с помощью <b>бинта</b>. Возьми бинт, у тебя кровоточит <b>торс</b>, выбери его и нажми на себя.")
	update_objective("Замотай бинтом свой торс.")
	var/obj/item/stack/medical/bruise_pack/two/bandage = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(bandage)
	add_highlight(bandage)
	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	RegisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING, PROC_REF(on_chest_bleed_stop))

/datum/tutorial/marine/medical_basic/proc/on_chest_bleed_stop(datum/source, external, internal)
	SIGNAL_HANDLER

	// If you exit on this step, your limbs get deleted, which stops the bleeding, which progresses the tutorial despite it ending
	if(!tutorial_mob || QDELETED(src))
		return

	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	UnregisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/bruise_pack/two, bandage)
	remove_from_tracking_atoms(bandage)
	remove_highlight(bandage)
	qdel(bandage)

	message_to_player("Хорошо. Иногда, когда в тебя попадает пуля или осколки костей, ты получаешь <b>шрапнель</b>, она наносит повреждения если двигаться с ней. Возьми <b>нож</b> и нажми на себя в настрое помощи.")
	update_objective("Выдерни из себя шрапнель с помощью ножа, нажатием на себя с настроем помощи.")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.feels_pain = FALSE

	var/obj/item/attachable/bayonet/knife = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(knife)
	add_highlight(knife)

	var/obj/item/shard/shrapnel/tutorial/shrapnel = new
	shrapnel.on_embed(tutorial_mob, mob_chest, TRUE)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_SHRAPNEL_REMOVED, PROC_REF(on_shrapnel_removed))

/datum/tutorial/marine/medical_basic/proc/on_shrapnel_removed()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_SHRAPNEL_REMOVED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/attachable/bayonet, knife)
	remove_highlight(knife)
	message_to_player("Отлично. Это был конец обучения медицине. Тебя скоро отправит в лобби.")
	update_objective("Обучение завершено.")
	tutorial_end_in(5 SECONDS)

// END OF SCRIPTING
// START OF SCRIPT HELPERS

// END OF SCRIPT HELPERS

/datum/tutorial/marine/medical_basic/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)


/datum/tutorial/marine/medical_basic/init_map()
	new /obj/structure/surface/table/almayer(loc_from_corner(0, 4))
