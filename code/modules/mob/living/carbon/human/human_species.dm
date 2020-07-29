// These may have some say.dm bugs regarding understanding common,
// might be worth adapting the bugs into a feature and using these
// subtypes as a basis for non-common-speaking alien foreigners. ~ Z

/mob/living/carbon/human/dummy/Initialize(var/new_loc)
	set_species()
	change_real_name(src, "Test Dummy")
	status_flags = GODMODE|CANPUSH
	prepare_huds()
	create_hud()

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
