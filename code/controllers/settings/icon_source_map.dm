var/global/list/icon_source_files = list()
var/global/list/icon_source_master = list(
	"lobby_art" = "icons/lobby/title.dmi",
	"alien_embryo" = "icons/mob/xenos/larva.dmi",
	"alien_boiler" = "icons/mob/xenos/boiler.dmi",
	"alien_burrower" = "icons/mob/xenos/burrower.dmi",
	"alien_carrier" = "icons/mob/xenos/carrier.dmi",
	"alien_crusher" = "icons/mob/xenos/crusher.dmi",
	"alien_defender" = "icons/mob/xenos/defender.dmi",
	"alien_drone" = "icons/mob/xenos/drone.dmi",
	"alien_hivelord" = "icons/mob/xenos/hivelord.dmi",
	"alien_lurker" = "icons/mob/xenos/lurker.dmi",
	"alien_praetorian" = "icons/mob/xenos/praetorian.dmi",
	"alien_predalien" = "icons/mob/xenos/predalien.dmi",
	"alien_queen_standing" = "icons/mob/xenos/queen.dmi",
	"alien_queen_ovipositor" = "icons/mob/xenos/Ovipositor.dmi",
	"alien_ravager" = "icons/mob/xenos/ravager.dmi",
	"alien_runner" = "icons/mob/xenos/runner.dmi",
	"alien_sentinel" = "icons/mob/xenos/sentinel.dmi",
	"alien_spitter" = "icons/mob/xenos/spitter.dmi",
	"alien_warrior" = "icons/mob/xenos/warrior.dmi",
	"alien_structures" = "icons/mob/xenos/structures.dmi",
	"alien_overlay_64x64" = "icons/mob/xenos/overlay_effects64x64.dmi",
	"alien_effects" = "icons/mob/xenos/Effects.dmi",
	"alien_weeds" = "icons/mob/xenos/weeds.dmi",
	"species_hunter" = "icons/mob/humans/species/r_predator.dmi",
)

/proc/get_icon_from_source(source_name)
	var/icon/I = null
	if(!icon_source_files[source_name])
		icon_source_files[source_name] = file(icon_source_master[source_name])
	I = icon_source_files[source_name]
	return I