SUBSYSTEM_DEF(thunderdome)
	name = "Thunderdome"
	wait = 1 SECONDS
	flags = SS_NO_INIT

	var/list/datum/thunderdome_clean/to_clean = list()

	var/list/immune_areas = list(
		/area/tdome/tdomeobserve
	)

/datum/controller/subsystem/thunderdome/fire(resumed)
	var/static/list/mob_typecache = typecacheof(/mob)

	for(var/datum/thunderdome_clean/clean_packet as anything in to_clean)

		for(var/turf/turf as anything in clean_packet.turfs_to_clean)
			if(clean_packet.no_mobs || (turf.loc.type in immune_areas))
				turf.empty(turf_type = null, ignore_typecache = mob_typecache)
			else
				turf.empty(turf_type = null)

			clean_packet.turfs_to_clean -= turf

			if(!length(clean_packet.turfs_to_clean))
				var/datum/map_template/thunderdome_template = SSmapping.map_templates[clean_packet.thunderdome.get_map_name()]
				thunderdome_template.load(clean_packet.thunderdome.get_spawn_turf())

				to_clean -= clean_packet
				qdel(clean_packet)

			if(MC_TICK_CHECK)
				return

/// Schedule a thunderdome for cleaning. Will replace the original thunderdome map after cleaning it.
/datum/controller/subsystem/thunderdome/proc/schedule_cleaning(datum/personal_thunderdome/thunderdome, no_mobs)
	to_clean += new /datum/thunderdome_clean(
		thunderdome.get_all_turfs(),
		thunderdome,
		no_mobs
	)

/datum/thunderdome_clean
	/// The list of turfs that we're cleaning up. Removed over time.
	var/list/turf/turfs_to_clean

	/// The thunderdome that we're going to place back down after cleaning.
	var/datum/personal_thunderdome/thunderdome

	/// If all mobs should be excluded by the cleaning or not.
	var/no_mobs = TRUE

/datum/thunderdome_clean/New(turfs_to_clean, thunderdome, no_mobs)
	src.turfs_to_clean = turfs_to_clean
	src.thunderdome = thunderdome
	src.no_mobs = no_mobs
