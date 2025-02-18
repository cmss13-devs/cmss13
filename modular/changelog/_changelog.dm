/datum/modpack/changelog
	name = "Чейнджлог"
	desc = "Кастомизация чейнджлога BandaMarines."
	author = "Maxiemar, ROdenFL"

/datum/modpack/changelog/initialize()
	var/latest_changelog = file("[global.config.directory]/../html/changelogs/bandamarines/archive/" + time2text(world.timeofday, "YYYY-MM") + ".yml")
	GLOB.changelog_hash = fexists(latest_changelog) ? md5(latest_changelog) : 0 //for telling if the changelog has changed recently
