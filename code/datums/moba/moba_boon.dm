/datum/moba_boon
	var/name
	var/desc

/datum/moba_boon/New(datum/moba_controller/controller)
	. = ..()

/datum/moba_boon/proc/on_friendly_spawn(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	return


/datum/moba_boon/megacarp
	name = "Megacarp Scale"
	desc = "Players gain +N% AD and +N% AP. Additionally, carps will reinforce the team's minion waves for N minutes after being claimed."


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

/datum/moba_boon/hivebot/on_friendly_spawn(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	ADD_TRAIT(xeno, TRAIT_MOBA_STRUCTURESHRED, TRAIT_SOURCE_INHERENT)
