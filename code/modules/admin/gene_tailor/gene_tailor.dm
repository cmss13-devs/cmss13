GLOBAL_LIST_INIT(gt_evolutions, list(
	"Alien Tier 0" = list(
	list(
	name = "Larva",
	key = /mob/living/carbon/Xenomorph/Larva
	),
	),
	"Alien Tier 1" = list(
	list(
	name = XENO_CASTE_RUNNER,
	key = /mob/living/carbon/Xenomorph/Runner
	),
	list(
	name = XENO_CASTE_DRONE,
	key = /mob/living/carbon/Xenomorph/Drone
	),
	list(
	name = XENO_CASTE_SENTINEL,
	key = /mob/living/carbon/Xenomorph/Sentinel
	),
	list(
	name = XENO_CASTE_DEFENDER,
	key = /mob/living/carbon/Xenomorph/Defender
	)
	),

	"Alien Tier 2" = list(
	list(
	name = XENO_CASTE_LURKER,
	key = /mob/living/carbon/Xenomorph/Lurker
	),
	list(
	name = XENO_CASTE_WARRIOR,
	key = /mob/living/carbon/Xenomorph/Warrior
	),
	list(
	name = XENO_CASTE_SPITTER,
	key = /mob/living/carbon/Xenomorph/Spitter
	),
	list(
	name = XENO_CASTE_BURROWER,
	key = /mob/living/carbon/Xenomorph/Burrower
	),
	list(
	name = XENO_CASTE_HIVELORD,
	key = /mob/living/carbon/Xenomorph/Hivelord
	),
	list(
	name = XENO_CASTE_CARRIER,
	key = /mob/living/carbon/Xenomorph/Carrier
	)
	),

	"Alien Tier 3" = list(
	list(
	name = XENO_CASTE_RAVAGER,
	key = /mob/living/carbon/Xenomorph/Ravager
	),
	list(
	name = XENO_CASTE_PRAETORIAN,
	key = /mob/living/carbon/Xenomorph/Praetorian
	),
	list(
	name = XENO_CASTE_BOILER,
	key = /mob/living/carbon/Xenomorph/Boiler
	),
	list(
	name = XENO_CASTE_CRUSHER,
	key = /mob/living/carbon/Xenomorph/Crusher
	)
	),

	"Alien Tier 4" = list(
	list(
	name = XENO_CASTE_QUEEN+" (Young)",
	key = /mob/living/carbon/Xenomorph/Queen
	),
	list(
	name = XENO_CASTE_QUEEN+" (Mature)",
	key = /mob/living/carbon/Xenomorph/Queen/combat_ready
	),
	list(
	name = XENO_CASTE_PREDALIEN,
	key = /mob/living/carbon/Xenomorph/Predalien
	)
	)
))

/datum/gene_tailor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GeneTailor", "Gene Tailor")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/gene_tailor/ui_data(mob/user)
	var/list/data = list()
	return data

/datum/gene_tailor/ui_static_data(mob/user)
	. = ..()
	.["glob_gt_evolutions"] = GLOB.gt_evolutions
	var/mob/living/carbon/Xenomorph/Runner/stat_stick = new
	var/list/xeno_stats = list()
	var/list/caste_stats = list()

	for(var/var_name in type2listofvars(stat_stick.parent_type))
		xeno_stats[var_name] = stat_stick.vars[var_name]
	for(var/var_name in type2listofvars(stat_stick.caste.parent_type))
		caste_stats[var_name] =  stat_stick.caste.vars[var_name]
	.["xeno_stats"] = xeno_stats
	.["caste_stats"] = caste_stats
	qdel(stat_stick)

/datum/gene_tailor/ui_state(mob/user)
	return GLOB.admin_state

/datum/gene_tailor/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("set_type")
			//BOGUS

