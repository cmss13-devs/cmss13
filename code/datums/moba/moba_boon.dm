/datum/moba_boon
	var/name
	var/desc

/datum/moba_boon/New(datum/moba_controller/controller)
	. = ..()

/datum/moba_boon/proc/on_grant(datum/moba_controller/controller, datum/hive_status/claimed_hive)
	return

/datum/moba_boon/proc/on_friendly_spawn(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/player_comp)
	return

/datum/moba_boon/proc/announce_boon(datum/moba_controller/controller, killing_hivenum)
	controller.message_team1("The [killing_hivenum == XENO_HIVE_MOBA_LEFT ? "Left Hive" : "Right Hive"] has claimed the [name]. [desc]")
	controller.message_team2("The [killing_hivenum == XENO_HIVE_MOBA_LEFT ? "Left Hive" : "Right Hive"] has claimed the [name]. [desc]")

/datum/moba_boon/megacarp
	name = "Megacarp Scale"
	desc = "All affected players gain +10% armor and acid armor."

/datum/moba_boon/megacarp/on_friendly_spawn(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/player_comp)
	player_comp.armor_multiplier += 0.1


/datum/moba_boon/hivebot
	name = "Hivebot Blade"

/datum/moba_boon/hivebot/New(datum/moba_controller/controller)
	. = ..()
	desc = "Affected players and minions deal [MOBA_HIVEBOT_BOON_TRUE_DAMAGE] bonus true damage to structures."
	RegisterSignal(controller, COMSIG_MOBA_MINION_SPAWNED, PROC_REF(on_minion_spawn))

/datum/moba_boon/hivebot/proc/on_minion_spawn(datum/moba_controller/source, mob/living/minion)
	SIGNAL_HANDLER

	ADD_TRAIT(minion, TRAIT_MOBA_STRUCTURESHRED, TRAIT_SOURCE_INHERENT)

/datum/moba_boon/hivebot/on_friendly_spawn(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/player_comp)
	ADD_TRAIT(xeno, TRAIT_MOBA_STRUCTURESHRED, TRAIT_SOURCE_INHERENT)


/datum/moba_boon/reaper
	name = "Reaper's Call"

/datum/moba_boon/reaper/New(datum/moba_controller/controller)
	. = ..()
	desc = "A claiming player reducing an enemy's health to [MOBA_REAPER_BOON_EXECUTE_THRESHOLD * 100]% health executes them. This effect lasts [(MOBA_REAPER_BOON_DURATION * 0.1) / 60] minutes or until death."

/datum/moba_boon/reaper/on_grant(datum/moba_controller/controller, datum/hive_status/claimed_hive)
	. = ..()
	for(var/datum/moba_player/player as anything in controller.players)
		if(player.get_tied_xeno()?.hivenumber != claimed_hive.hivenumber)
			continue

		player.get_tied_xeno().apply_status_effect(/datum/status_effect/reapers_call)
