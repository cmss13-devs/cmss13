GLOBAL_LIST_INIT(battlepass_icons_list, list(
	'icons/obj/items/items.dmi' = list(
		"coin_copper", "coin_silver", "coin_gold",
		"coin_diamond", "coin_platinum", "coin_mythril",
		"visa", "broadcastingcamera"
	),
	'core_ru/icons/custom/items/guns.dmi' = list(
		"mk221_gold", "m4ra_gold", "m37_gold", "m41a_gold",
		"m41amk1_gold",  "m39_gold",  "m46c_gold"
	),
	'core_ru/icons/custom/mob/xenos/queen.dmi' = list(
		"queen_socks"
	),
	'core_ru/icons/custom/mob/xenos/predalien.dmi' = list(
		"predalien_socks"
	),
	'core_ru/icons/custom/mob/xenos/boiler.dmi' = list(
		"boiler_socks"
	),
	'core_ru/icons/custom/mob/xenos/praetorian.dmi' = list(
		"praetorian_socks"
	),
	'core_ru/icons/custom/mob/xenos/ravager.dmi' = list(
		"ravager_socks"
	),
	'core_ru/icons/custom/mob/xenos/crusher.dmi' = list(
		"crusher_socks"
	),
	'core_ru/icons/custom/mob/xenos/hivelord.dmi' = list(
		"hivelord_socks"
	),
	'core_ru/icons/custom/mob/xenos/warrior.dmi' = list(
		"warrior_socks"
	),
	'core_ru/icons/custom/mob/xenos/carrier.dmi' = list(
		"carrier_socks"
	),
	'core_ru/icons/custom/mob/xenos/burrower.dmi' = list(
		"burrower_socks"
	),
	'core_ru/icons/custom/mob/xenos/spitter.dmi' = list(
		"spitter_socks"
	),
	'core_ru/icons/custom/mob/xenos/lurker.dmi' = list(
		"lurker_socks"
	),
	'core_ru/icons/custom/mob/xenos/drone.dmi' = list(
		"drone_socks"
	),
	'core_ru/icons/custom/mob/xenos/defender.dmi' = list(
		"defender_socks"
	),
	'core_ru/icons/custom/mob/xenos/sentinel.dmi' = list(
		"sentinel_socks"
	),
	'core_ru/icons/custom/mob/xenos/runner.dmi' = list(
		"runner_socks"
	),
	'core_ru/icons/custom/mob/xenos/predalien_larva.dmi' = list(
		"larva_predalien_socks"
	),
	'core_ru/icons/custom/mob/xenos/larva.dmi' = list(
		"larva_socks"
	),
	'core_ru/icons/custom/mob/xenos/lesser_drone.dmi' = list(
		"lesser_drone_socks"
	),
	'core_ru/icons/custom/mob/xenos/facehugger.dmi' = list(
		"facehugger_socks"
	)
))

/datum/asset/spritesheet/battlepass
	name = "battlepass"

/datum/asset/spritesheet/battlepass/register()
	for(var/icon_dir in GLOB.battlepass_icons_list)
		for(var/icon_state in GLOB.battlepass_icons_list[icon_dir])
			var/icon/sprite = icon(icon_dir, icon_state)
			sprite.Scale(96, 96)
			Insert(icon_state, sprite)
	return ..()
