// These may have some say.dm bugs regarding understanding common,
// might be worth adapting the bugs into a feature and using these
// subtypes as a basis for non-common-speaking alien foreigners. ~ Z

/mob/living/carbon/human/dummy
	var/in_use = FALSE

/mob/living/carbon/human/dummy/proc/wipe_state()
	for(var/anything in contents)
		qdel(anything)
	overlays.Cut()

/mob/living/carbon/human/dummy/Initialize(mapload)
	. = ..()
	GLOB.human_mob_list -= src
	GLOB.alive_human_list -= src
	SShuman.processable_human_list -= src
	GLOB.mob_list -= src
	GLOB.dead_mob_list -= src
	GLOB.alive_mob_list -= src

	set_species()
	change_real_name(src, "Test Dummy")
	status_flags = GODMODE|CANPUSH
	prepare_huds()
	create_hud()

//Inefficient pooling/caching way.
GLOBAL_LIST_EMPTY(human_dummy_list)
GLOBAL_LIST_EMPTY(dummy_mob_list)

/proc/generate_or_wait_for_human_dummy(slotkey)
	if(!slotkey)
		return new /mob/living/carbon/human/dummy
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		UNTIL(!D.in_use)
	if(QDELETED(D))
		D = new
		GLOB.human_dummy_list[slotkey] = D
		GLOB.dummy_mob_list += D
	D.in_use = TRUE
	return D

/proc/unset_busy_human_dummy(slotnumber)
	if(!slotnumber)
		return
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotnumber]
	if(!QDELETED(D))
		D.wipe_state()
		D.in_use = FALSE

/mob/living/carbon/human/dummy/med_hud_set_health()
	return

/mob/living/carbon/human/dummy/med_hud_set_armor()
	return

/mob/living/carbon/human/dummy/med_hud_set_status()
	return

/mob/living/carbon/human/dummy/sec_hud_set_ID()
	return

/mob/living/carbon/human/dummy/sec_hud_set_security_status()
	return

/mob/living/carbon/human/dummy/hud_set_squad()
	return

/mob/living/carbon/human/dummy/remove_from_all_mob_huds()
	return

/mob/living/carbon/human/dummy/add_to_all_mob_huds()
	return

/mob/living/carbon/human/dummy/tutorial // Effectively an even more disabled dummy

/mob/living/carbon/human/dummy/tutorial/Initialize(mapload)
	. = ..()
	status_flags = GODMODE
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
	anchored = TRUE

// Professor Dummy, used by CMOs and SEAs to teach new nurses/doctors
/mob/living/carbon/human/dummy/professor_dummy/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_LANDED, PROC_REF(destroy_upon_hijack))

/mob/living/carbon/human/dummy/professor_dummy/proc/destroy_upon_hijack()
	SIGNAL_HANDLER

	visible_message(SPAN_WARNING("The [src] suddenly disintegrates!"))
	dust(create_cause_data("hijack autodelete"))

/mob/living/carbon/human/dummy/professor_dummy/Destroy()
	UnregisterSignal(src, COMSIG_GLOB_HIJACK_LANDED)
	return ..()
