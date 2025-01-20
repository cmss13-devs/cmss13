/datum/xeno_strain/trapper
	name = BOILER_TRAPPER
	description = "You trade some health and your ability to bombard, use neurotoxin gas, and dump acid in exchange for the ability to strongly damage a target area, ensnare targets within said area, and gain improved capacity for close-range combat. Deploy Traps places a line of traps that will root targets for 2 seconds, and successfully catching targets will provide bonuses to your other two abilities for 4 seconds. Use Acid Mortar to trigger a powerful delayed AOE where you're aiming, with the trigger delay being decreased after trapping people and dealing increased damage against barricades. When in close combat with hostiles, use Acid Shotgun to deal high damage, dealing even more after trapping someone."
	flavor_description = "The battlefield is my canvas, this one, my painter. Melt them where they stand."

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit/bombard,
		/datum/action/xeno_action/onclick/shift_spits/boiler,
		/datum/action/xeno_action/activable/spray_acid/boiler,
		/datum/action/xeno_action/onclick/acid_shroud,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/boiler_trap,
		/datum/action/xeno_action/activable/acid_mortar,
		/datum/action/xeno_action/activable/acid_shotgun,
	)

	behavior_delegate_type = /datum/behavior_delegate/boiler_trapper

/datum/xeno_strain/trapper/apply_strain(mob/living/carbon/xenomorph/boiler/boiler)
	if(!istype(boiler))
		return FALSE

	if(boiler.is_zoomed)
		boiler.zoom_out()

	boiler.plasma_types -= PLASMA_NEUROTOXIN
	boiler.health_modifier -= XENO_HEALTH_MOD_MED

	boiler.recalculate_everything()

/datum/behavior_delegate/boiler_trapper
	name = "Boiler Trapper Behavior Delegate"

	var/successful_trap = FALSE

/datum/behavior_delegate/boiler_trapper/proc/success_trap_buff()
	successful_trap = TRUE
	addtimer(CALLBACK(src, PROC_REF(success_trap_buff_remove)), 4 SECONDS)

/datum/behavior_delegate/boiler_trapper/proc/success_trap_buff_remove()
	to_chat(bound_xeno, SPAN_XENONOTICE("We feel out tactical advantage over our foes fade."))
	successful_trap = FALSE

/datum/behavior_delegate/boiler_trapper/append_to_stat()
	. = list()
	. += "If 1, buff is active: [successful_trap]"
