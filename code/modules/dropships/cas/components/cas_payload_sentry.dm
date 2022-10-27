// legacy
// should be integrated differently to tie in to launch sequence

/datum/component/cas_payload_sentry
	var/contents_type

/datum/component/cas_payload_sentry/Initialize(contents_type = /obj/structure/machinery/defenses/sentry/launchable)
	src.contents_type = contents_type
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_IMPACT, .proc/land)

/datum/component/cas_payload_sentry/proc/land(datum/source, atom/target)
	var/datum/cas_firing_solution/P = parent
	var/obj/structure/droppod/equipment/sentry/droppod = new /obj/structure/droppod/equipment/sentry(target, contents_type, P.source_mob)
	droppod.drop_time = 5 SECONDS
	droppod.launch(target)
	qdel(src)
