
/particles/debris
	icon = 'icons/effects/particles/generic_particles.dmi'
	width = 500
	height = 500
	count = 10
	spawning = 10
	lifespan = 0.7 SECONDS
	fade = 0.4 SECONDS
	drift = generator(GEN_CIRCLE, 0, 7)
	scale = 0.7
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.1, 0.15)
	spin = generator(GEN_NUM, -20, 20)

/particles/impact_smoke
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	width = 500
	height = 500
	count = 20
	spawning = 20
	lifespan = 0.7 SECONDS
	fade = 8 SECONDS
	grow = 0.1
	scale = 0.2
	spin = generator(GEN_NUM, -20, 20)
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.1, 0.5)

/datum/element/debris
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 1

	///Icon state of debris when impacted by a proj
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
	RegisterSignal(target, COMSIG_BULLET_PING_ACT, PROC_REF(register_for_impact), TRUE)

/datum/element/debris/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_BULLET_PING_ACT)

/datum/element/debris/proc/register_for_impact(obj/projectile/proj, datum/source)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(on_impact), source, proj)

/datum/element/debris/proc/on_impact(datum/source, obj/projectile/proj)
	if(!proj.ammo.ping)
		return
	var/angle = !isnull(proj.angle) ? proj.angle : round(Get_Angle(proj.starting, source), 1)
	var/x_component = sin(angle) * debris_velocity
	var/y_component = cos(angle) * debris_velocity
	var/x_component_smoke = sin(angle) * -15
	var/y_component_smoke = cos(angle) * -15
	var/obj/effect/abstract/particle_holder/debris_visuals
	var/obj/effect/abstract/particle_holder/smoke_visuals
	var/position_offset = rand(-6,6)
	smoke_visuals = new(source, /particles/impact_smoke)
	smoke_visuals.particles.position = list(position_offset, position_offset)
	smoke_visuals.particles.velocity = list(x_component_smoke, y_component_smoke)
	if(debris && !(proj.ammo.flags_ammo_behavior & AMMO_ENERGY && proj.ammo.flags_ammo_behavior & AMMO_XENO))
		debris_visuals = new(source, /particles/debris)
		debris_visuals.particles.position = generator(GEN_CIRCLE, position_offset, position_offset)
		debris_visuals.particles.velocity = list(x_component, y_component)
		debris_visuals.layer = FLY_LAYER
		debris_visuals.particles.icon_state = debris
		debris_visuals.particles.count = debris_amount
		debris_visuals.particles.spawning = debris_amount
		debris_visuals.particles.scale = debris_scale
	smoke_visuals.layer = FLY_LAYER
	if(proj.ammo.sound_bounce)
		playsound(source, proj.ammo.sound_bounce, 50, 1)
	addtimer(CALLBACK(src, PROC_REF(remove_ping), src, smoke_visuals, debris_visuals), 0.7 SECONDS)

/datum/element/debris/proc/remove_ping(hit, obj/effect/abstract/particle_holder/smoke_visuals, obj/effect/abstract/particle_holder/debris_visuals)
	QDEL_NULL(smoke_visuals)
	if(debris_visuals)
		QDEL_NULL(debris_visuals)
