/datum/component/cas_warhead_pyrotechnics
	var/particles_count
	var/smoke_count

/datum/component/cas_warhead_pyrotechnics/Initialize(particles_count = 4, smoke_count = 1)
	src.particles_count = particles_count
	src.smoke_count = smoke_count
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_IMPACT, .proc/boom)

/datum/component/cas_warhead_pyrotechnics/proc/boom(source, atom/target)
	SIGNAL_HANDLER
	if(particles_count)
		var/datum/effect_system/expl_particles/particles = new
		particles.set_up(particles_count, 0, target)
		particles.start()
	if(smoke_count)
		addtimer(CALLBACK(src, .proc/delayed_smoke, target), 0.5 SECONDS)
	else
		qdel(src)

/datum/component/cas_warhead_pyrotechnics/proc/delayed_smoke(var/turf/target)
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(smoke_count, 0, target,null)
	S.start()
	qdel(src)
