/particles/debris
	icon = 'icons/effects/particles/generic_particles.dmi'
	width = 500
	height = 500
	count = 2
	spawning = 2
	lifespan = 0.4 SECONDS
	fade = 0.4 SECONDS
	drift = generator(GEN_CIRCLE, 0, 7)
	scale = 0.7
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.1, 0.15)
	spin = generator(GEN_NUM, -20, 20)
	rotation = generator(GEN_NUM, 0, 360)

/particles/impact_large
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = list("impact" = 1, "impact_2" = 1, "impact_3" = 1)
	color = "#646464"
	width = 500
	height = 500
	count = 3
	spawning = 3
	lifespan = 0.4 SECONDS
	fade = 0.65 SECONDS
	position = generator(GEN_CIRCLE, 3, 3)
	scale = 0.75
	grow = -0.15
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.65, 0.8, UNIFORM_RAND)
	rotation = generator(GEN_NUM, -20, 20)
	drift = generator(GEN_CIRCLE, 8, 8)
	spin = generator(GEN_NUM, -20, 20)

/particles/impact_smoke
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = list("smoke" = 1, "smoke_2" = 1)
	width = 500
	height = 500
	count = 5
	spawning = 5
	lifespan = 0.4 SECONDS
	fade = 0.35 SECONDS
	grow = 0.07
	drift = generator(GEN_CIRCLE, 5, 5)
	scale = 0.4
	position = generator(GEN_CIRCLE, 6, 6)
	spin = generator(GEN_NUM, -20, 20)
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.6, 0.4, UNIFORM_RAND)

/datum/element/debris
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

	///Icon state of debris when impacted by a projectile
	var/debris = null
	///Velocity of debris particles
	var/debris_velocity = -15
	///Amount of debris particles
	var/debris_amount = 8
	///Scale of particle debris
	var/debris_scale = 0.7

/datum/element/debris/Attach(datum/target, _debris_icon_state, _debris_velocity = -15, _debris_amount = 8, _debris_scale = 0.7)
	. = ..()
	debris = _debris_icon_state
	debris_velocity = _debris_velocity
	debris_amount = _debris_amount
	debris_scale = _debris_scale
	RegisterSignal(target, COMSIG_ATOM_BULLET_ACT, PROC_REF(register_for_impact), TRUE) //override because the element gets overriden

/datum/element/debris/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_ATOM_BULLET_ACT)

/datum/element/debris/proc/register_for_impact(datum/source, obj/projectile/proj)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(on_impact), source, proj)

/datum/element/debris/proc/on_impact(datum/source, obj/projectile/P)
	if(!P.ammo.ping)
		return
	var/angle = !isnull(P.angle) ? P.angle : round(Get_Angle(P.starting, source), 1)

	var/x_component = sin(angle) * debris_velocity
	var/y_component = cos(angle) * debris_velocity
	var/x_component_smoke = sin(angle) * -30
	var/y_component_smoke = cos(angle) * -30
	var/x_component_large = sin(angle) * -20
	var/y_component_large = cos(angle) * -20

	var/obj/effect/abstract/particle_holder/debris_visuals
	var/obj/effect/abstract/particle_holder/smoke_visuals
	var/obj/effect/abstract/particle_holder/large_impact_visuals
	var/position_offset = rand(-6,6)

	smoke_visuals = new(source, /particles/impact_smoke)
	smoke_visuals.particles.position = list(position_offset, position_offset)
	smoke_visuals.particles.velocity = list(x_component_smoke, y_component_smoke)

	large_impact_visuals = new(source, /particles/impact_large)
	large_impact_visuals.particles.position = list(position_offset, position_offset)
	large_impact_visuals.particles.velocity = list(x_component_large, y_component_large)

	if(debris && !(P.ammo.flags_ammo_behavior & AMMO_ENERGY || P.ammo.flags_ammo_behavior & AMMO_XENO))
		debris_visuals = new(source, /particles/debris)
		debris_visuals.particles.position = generator(GEN_CIRCLE, position_offset, position_offset)
		debris_visuals.particles.velocity = list(x_component, y_component)
		switch(debris)
			if(DEBRIS_SPARKS)
				debris_visuals.particles.rotation = angle
		debris_visuals.layer = ABOVE_MOB_LAYER + 0.03
		debris_visuals.particles.icon_state = debris
		debris_visuals.particles.count = debris_amount
		debris_visuals.particles.spawning = debris_amount
		debris_visuals.particles.scale = debris_scale

	smoke_visuals.layer = ABOVE_MOB_LAYER + 0.01
	large_impact_visuals.layer = ABOVE_MOB_LAYER + 0.02
	QDEL_IN(smoke_visuals, 0.4 SECONDS)
	QDEL_IN(large_impact_visuals, 0.4 SECONDS)
	QDEL_IN(debris_visuals, 0.4 SECONDS)
