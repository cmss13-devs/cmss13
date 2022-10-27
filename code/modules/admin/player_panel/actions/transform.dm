GLOBAL_LIST_INIT(pp_transformables, list(
  "Humanoid" = list(
	list(
	  name = "Human",
	  key = /mob/living/carbon/human,
	  color = "green"
	),
	list(
	  name = "Farwa",
	  key = /mob/living/carbon/human/farwa,
	  color = "green"
	),
	list(
	  name = "Monkey",
	  key = /mob/living/carbon/human/monkey,
	  color = "green"
	),
	list(
	  name = "Neaera",
	  key = /mob/living/carbon/human/neaera,
	  color = "green"
	),
	list(
	  name = "Yiren",
	  key = /mob/living/carbon/human/yiren,
	  color = "green"
	)
  ),
  "Alien Tier 0" = list(
	list(
	  name = "Larva",
	  key = /mob/living/carbon/Xenomorph/Larva,
	  color = "purple"
	),
	list(
	  name = "Facehugger",
	  key = /mob/living/carbon/Xenomorph/Facehugger,
	  color = "purple"
	)
  ),
  "Alien Tier 1" = list(
	list(
	  name = XENO_CASTE_RUNNER,
	  key = /mob/living/carbon/Xenomorph/Runner,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_DRONE,
	  key = /mob/living/carbon/Xenomorph/Drone,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_SENTINEL,
	  key = /mob/living/carbon/Xenomorph/Sentinel,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_DEFENDER,
	  key = /mob/living/carbon/Xenomorph/Defender,
	  color = "purple"
	)
  ),
  "Alien Tier 2" = list(
	list(
	  name = XENO_CASTE_LURKER,
	  key = /mob/living/carbon/Xenomorph/Lurker,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_WARRIOR,
	  key = /mob/living/carbon/Xenomorph/Warrior,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_SPITTER,
	  key = /mob/living/carbon/Xenomorph/Spitter,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_BURROWER,
	  key = /mob/living/carbon/Xenomorph/Burrower,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_HIVELORD,
	  key = /mob/living/carbon/Xenomorph/Hivelord,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_CARRIER,
	  key = /mob/living/carbon/Xenomorph/Carrier,
	  color = "purple"
	)
  ),
  "Alien Tier 3" = list(
	list(
	  name = XENO_CASTE_RAVAGER,
	  key = /mob/living/carbon/Xenomorph/Ravager,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_PRAETORIAN,
	  key = /mob/living/carbon/Xenomorph/Praetorian,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_BOILER,
	  key = /mob/living/carbon/Xenomorph/Boiler,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_CRUSHER,
	  key = /mob/living/carbon/Xenomorph/Crusher,
	  color = "purple"
	)
  ),
  "Alien Tier 4" = list(
	list(
	  name = XENO_CASTE_QUEEN+" (Young)",
	  key = /mob/living/carbon/Xenomorph/Queen,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_QUEEN+" (Mature)",
	  key = /mob/living/carbon/Xenomorph/Queen/combat_ready,
	  color = "purple"
	),
	list(
	  name = XENO_CASTE_PREDALIEN,
	  key = /mob/living/carbon/Xenomorph/Predalien,
	  color = "purple"
	)
  ),
  "Miscellaneous" = list(
	list(
	  name = "Cat",
	  key = /mob/living/simple_animal/cat,
	  color = "orange"
	),
	list(
	  name = "Crab",
	  key = /mob/living/simple_animal/crab,
	  color = "orange"
	),
	list(
	  name = "Corgi",
	  key = /mob/living/simple_animal/corgi,
	  color = "orange"
	),
	list(
	  name = XENO_CASTE_HELLHOUND,
	  key = /mob/living/carbon/Xenomorph/Hellhound,
	  color = "orange"
	)
  )
))

/datum/player_action/transform
	action_tag = "mob_transform"
	name = "Transform"
	permissions_required = R_SPAWN

/datum/player_action/transform/act(var/client/user, var/mob/target, var/list/params)
	var/type = text2path(params["key"])

	if(!ispath(type))
		return

	var/mob/M = new type(target.loc)

	if(!target.mind)
		target.mind_initialize()

	target.mind.transfer_to(M, TRUE)

	if(isXeno(M))
		var/mob/living/carbon/Xenomorph/newXeno = M
		if(isXeno(target))
			var/mob/living/carbon/Xenomorph/X = target
			newXeno.set_hive_and_update(X.hivenumber)


	QDEL_IN(target, 0.3 SECONDS)
	addtimer(CALLBACK(M.mob_panel, /datum.proc/tgui_interact, user.mob), 1 SECONDS)

	message_staff("[key_name_admin(user)] has transformed [key_name_admin(target)] into mob type [type]")
	return TRUE
