/datum/moba_boon
	var/name
	var/desc

/datum/moba_boon/New(datum/moba_controller/controller)
	. = ..()

/datum/moba_boon/proc/on_grant(datum/moba_controller/controller, datum/hive_status/claimed_hive)
	return

/datum/moba_boon/proc/on_friendly_spawn(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/player_comp)
	return


/datum/moba_boon/megacarp
	name = "Megacarp Scale"
	desc = "Players gain +10% armor and acid armor."

/datum/moba_boon/megacarp/on_friendly_spawn(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/player_comp)
	player_comp.armor_multiplier += 0.1

/datum/moba_boon/hivebot
	name = "Hivebot Blade"
	desc = "Players and minions deal N bonus true damage to structures."

/datum/moba_boon/hivebot/New(datum/moba_controller/controller)
	. = ..()
	desc = "Players and minions deal [MOBA_HIVEBOT_BOON_TRUE_DAMAGE] bonus true damage to structures."
	RegisterSignal(controller, COMSIG_MOBA_MINION_SPAWNED, PROC_REF(on_minion_spawn))

/datum/moba_boon/hivebot/proc/on_minion_spawn(datum/moba_controller/source, mob/living/minion)
	SIGNAL_HANDLER

	ADD_TRAIT(minion, TRAIT_MOBA_STRUCTURESHRED, TRAIT_SOURCE_INHERENT)

/datum/moba_boon/hivebot/on_friendly_spawn(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/player_comp)
	ADD_TRAIT(xeno, TRAIT_MOBA_STRUCTURESHRED, TRAIT_SOURCE_INHERENT)


/datum/moba_boon/reaper
	name = "Reaper's Call"
	desc = "Reducing an enemy to N% health executes them for the next N minutes.."

/datum/moba_boon/reaper/New(datum/moba_controller/controller)
	. = ..()
	desc = "Players will execute enemies and deal []"

/datum/moba_boon/reaper/proc/on_minion_spawn(datum/moba_controller/source, mob/living/minion)
	SIGNAL_HANDLER

	ADD_TRAIT(minion, TRAIT_MOBA_STRUCTURESHRED, TRAIT_SOURCE_INHERENT)

/datum/moba_boon/reaper/proc/on_friendly_spawn(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/player_comp)
	ADD_TRAIT(xeno, TRAIT_MOBA_STRUCTURESHRED, TRAIT_SOURCE_INHERENT)

