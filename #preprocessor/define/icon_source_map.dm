var/global/list/icon_source_files = list()
var/global/list/icon_source_master = list(
	"lobby_art" = "icons/lobby/title.dmi",
	"alien_embryo" = "icons/mob/hostiles/larva.dmi",
	"alien_hunter_embryo" = "icons/mob/xenos_old/1x1_Xenos.dmi",
	"alien_boiler" = "icons/mob/hostiles/boiler.dmi",
	"alien_burrower" = "icons/mob/hostiles/burrower.dmi",
	"alien_carrier" = "icons/mob/hostiles/carrier.dmi",
	"alien_crusher" = "icons/mob/hostiles/crusher.dmi",
	"alien_defender" = "icons/mob/hostiles/defender.dmi",
	"alien_drone" = "icons/mob/hostiles/drone.dmi",
	"alien_hivelord" = "icons/mob/hostiles/hivelord.dmi",
	"alien_lurker" = "icons/mob/hostiles/lurker.dmi",
	"alien_praetorian" = "icons/mob/hostiles/praetorian.dmi",
	"alien_predalien" = "icons/mob/hostiles/predalien.dmi",
	"alien_queen_standing" = "icons/mob/hostiles/queen.dmi",
	"alien_queen_ovipositor" = "icons/mob/hostiles/Ovipositor.dmi",
	"alien_ravager" = "icons/mob/hostiles/ravager.dmi",
	"alien_runner" = "icons/mob/hostiles/runner.dmi",
	"alien_sentinel" = "icons/mob/hostiles/sentinel.dmi",
	"alien_spitter" = "icons/mob/hostiles/spitter.dmi",
	"alien_warrior" = "icons/mob/hostiles/warrior.dmi",
	"alien_structures" = "icons/mob/hostiles/structures.dmi",
	"alien_structures_64x64" = "icons/mob/hostiles/structures64x64.dmi",
	"alien_structures_48x48" = "icons/mob/hostiles/structures48x48.dmi",
	"alien_overlay_64x64" = "icons/mob/hostiles/overlay_effects64x64.dmi",
	"alien_effects" = "icons/mob/hostiles/Effects.dmi",
	"alien_weeds" = "icons/mob/hostiles/weeds.dmi",
	"alien_gib_48x48" = "icons/mob/xenos_old/xenomorph_48x48.dmi",
	"alien_gib_64x64" = "icons/mob/xenos_old/xenomorph_64x64.dmi",
	"species_hunter" = "icons/mob/humans/species/r_predator.dmi",
)

/proc/get_icon_from_source(source_name)
	var/icon/I = null
	if(!icon_source_files[source_name])
		icon_source_files[source_name] = file(icon_source_master[source_name])
	I = icon_source_files[source_name]
	return I