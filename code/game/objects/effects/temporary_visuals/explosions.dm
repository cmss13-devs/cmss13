/particles/explosion_smoke
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke3_pix"
	width = 1000
	height = 1000
	count = 75
	spawning = 75
	gradient = list("#FA9632", "#C3630C", "#333333", "#808080", "#FFFFFF")
	lifespan = 20
	fade = 60
	color = generator(GEN_NUM, 0, 0.25)
	color_change = generator(GEN_NUM, 0.04, 0.05)
	velocity = generator(GEN_CIRCLE, 15, 15)
	drift = generator(GEN_CIRCLE, 0, 1, NORMAL_RAND)
	spin = generator(GEN_NUM, -20, 20)
	friction = generator(GEN_NUM, 0.1, 0.5)
	gravity = list(1, 2)
	scale = 0.25
	grow = 0.05

/particles/explosion_smoke/deva
	scale = 0.5
	velocity = generator(GEN_CIRCLE, 23, 23)

/particles/explosion_smoke/small
	count = 25
	spawning = 25
	scale = 0.25
	velocity = generator(GEN_CIRCLE, 10, 10)

/particles/explosion_water
	icon = 'icons/effects/96x96.dmi'
	icon_state = list("smoke4_pix" = 1, "smoke5_pix" = 1)
	width = 1000
	height = 1000
	count = 75
	spawning = 75
	lifespan = 20
	fade = 80
	velocity = generator(GEN_CIRCLE, 15, 15)
	drift = generator(GEN_CIRCLE, 0, 1, NORMAL_RAND)
	spin = generator(GEN_NUM, -20, 20)
	friction = generator(GEN_NUM, 0.1, 0.5)
	gravity = list(1, 2)
	scale = 0.15
	grow = 0.02

/particles/smoke_wave
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = list("impact", "impact_2", "impact_3")
	width = 750
	height = 750
	count = 70
	spawning = 70
	lifespan = 15
	fade = 70
	gradient = list("#808080")
	color = generator(GEN_NUM, 0, 0.25)
	color_change = generator(GEN_NUM, 0.08, 0.07)
	velocity = generator(GEN_CIRCLE, 25, 25)
	rotation = generator(GEN_NUM, -45, 45)
	scale = 2.2
	grow = 0.1
	friction = 0.05

/particles/smoke_wave/small
	count = 30
	spawning = 30
	scale = 0.1

/particles/wave_water
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke5_pix"
	width = 750
	height = 750
	count = 75
	spawning = 75
	lifespan = 15
	fade = 25
	color_change = generator(GEN_NUM, 0.08, 0.07)
	velocity = generator(GEN_CIRCLE, 25, 25)
	rotation = generator(GEN_NUM, -45, 45)
	scale = 0.45
	grow = 0.05
	friction = 0.05

/particles/dirt_kickup
	icon = 'icons/effects/96x157.dmi'
	icon_state = "smoke"
	width = 500
	height = 500
	count = 40
	spawning = 40
	lifespan = 15
	fade = 10
	scale = generator(GEN_NUM, 0.18, 0.15)
	position = generator(GEN_SPHERE, 150, 150)

/particles/water_splash
	icon = 'icons/effects/96x157.dmi'
	icon_state = "smoke2"
	width = 500
	height = 500
	count = 50
	spawning = 50
	lifespan = 15
	fade = 10
	scale = generator(GEN_NUM, 0.18, 0.15)
	position = generator(GEN_SPHERE, 150, 150)

/particles/dirt_kickup_large
	icon = 'icons/effects/96x157.dmi'
	icon_state = "smoke"
	width = 750
	height = 750
	gradient = list("#FA9632", "#C3630C", "#333333", "#808080", "#FFFFFF")
	count = 3
	spawning = 3
	lifespan = 20
	fade = 10
	fadein = 3
	scale = generator(GEN_NUM, 0.5, 1)
	position = generator(GEN_BOX, list(-12, 32), list(12, 48), NORMAL_RAND)
	color = generator(GEN_NUM, 0, 0.25)
	color_change = generator(GEN_NUM, 0.04, 0.05)
	velocity = list(0, 12)
	grow = list(0, 0.025)
	gravity = list(0, -1)

/particles/dirt_kickup_large/deva
	velocity = list(0, 25)
	scale = generator(GEN_NUM, 1, 1.25)
	grow = list(0, 0.03)
	gravity = list(0, -2)
	fade = 10

/particles/water_splash_large
	icon = 'icons/effects/96x157.dmi'
	icon_state = "smoke2"
	width = 750
	height = 750
	count = 3
	spawning = 3
	lifespan = 20
	fade = 10
	fadein = 3
	scale = generator(GEN_NUM, 1, 1.25)
	position = generator(GEN_BOX, list(-12, 32), list(12, 48), NORMAL_RAND)
	velocity = list(0, 12)
	grow = list(0, 0.05)
	gravity = list(0, -1)

/particles/falling_debris
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = "rock"
	width = 750
	height = 750
	count = 75
	spawning = 75
	lifespan = 20
	fade = 5
	position = generator(GEN_SPHERE, 16, 16)
	velocity = list(0, 26)
	scale = generator(GEN_NUM, 1, 2)
	gravity = list(0, -3)
	friction = 0.02
	drift = generator(GEN_CIRCLE, 0, 1.5)

/particles/falling_debris/small
	count = 40
	spawning = 40

/particles/water_falling
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = "cross"
	width = 750
	height = 750
	count = 75
	spawning = 75
	lifespan = 20
	fade = 5
	position = generator(GEN_SPHERE, 16, 16)
	velocity = list(0, 26)
	scale = generator(GEN_NUM, 1, 2)
	gravity = list(0, -3)
	friction = 0.02
	drift = generator(GEN_CIRCLE, 0, 1.5)

/particles/sparks_outwards
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "shrapnel_bright2"
	width = 750
	height = 750
	count = 10
	spawning = 5
	lifespan = 0.6 SECONDS
	fadein = 0.2 SECONDS
	velocity = generator("square", 32 * 0.85, 32 * 1.15)
	rotation = generator("num", 0, 359)

/particles/water_outwards
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = "cross"
	width = 750
	height = 750
	count = 40
	spawning = 20
	lifespan = 15
	fade = 15
	position = generator(GEN_SPHERE, 8, 8)
	velocity = generator(GEN_CIRCLE, 30, 30)
	scale = 1.25
	friction = 0.1

/obj/effect/temp_visual/explosion
	name = "boom"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	light_system = STATIC_LIGHT
	layer = ABOVE_MOB_LAYER
	duration = 25
	///smoke wave particle holder
	var/obj/effect/abstract/particle_holder/smoke_wave
	///debris dirt kickup particle holder
	var/obj/effect/abstract/particle_holder/dirt_kickup
	///sparks particle holder
	var/obj/effect/abstract/particle_holder/sparks
	///large dirt kickup particle holder
	var/obj/effect/abstract/particle_holder/large_kickup

/obj/effect/temp_visual/explosion/Initialize(mapload, radius, color, small = FALSE, large = FALSE)
	. = ..()
	set_light(radius, radius, color)
	generate_particles(radius, small, large)
	var/turf/turf_type = get_turf(src)
	if(!turf_type.can_bloody)
		icon_state = null
		return
	var/image/I = image(icon, src, icon_state, 10, -32, -32)
	var/matrix/rotate = matrix()
	rotate.Turn(rand(0, 359))
	I.transform = rotate
	overlays += I //we use an overlay so the explosion and light source are both in the correct location plus so the particles don't rotate with the explosion
	icon_state = null

///Generate the particles
/obj/effect/temp_visual/explosion/proc/generate_particles(radius, power)
	if(power <= EXPLOSION_THRESHOLD_LOW)
		smoke_wave = new(src, /particles/smoke_wave/small)
	else
		smoke_wave = new(src, /particles/smoke_wave)

	dirt_kickup = new(src, /particles/dirt_kickup)
	sparks = new(src, /particles/sparks_outwards)

	if(power > EXPLOSION_THRESHOLD_HIGH)
		smoke_wave.particles.velocity = generator(GEN_CIRCLE, 6 * radius, 6 * radius)
	else if(power <= EXPLOSION_THRESHOLD_LOW)
		smoke_wave.particles.velocity = generator(GEN_CIRCLE, 3 * radius, 3 * radius)
	else
		smoke_wave.particles.velocity = generator(GEN_CIRCLE, 5 * radius, 5 * radius)
	sparks.particles.velocity = generator(GEN_CIRCLE, 8 * radius, 8 * radius)
	addtimer(CALLBACK(src, PROC_REF(set_count_short)), 5)
	addtimer(CALLBACK(src, PROC_REF(set_count_long)), 10)

/obj/effect/temp_visual/explosion/proc/set_count_short()
	smoke_wave.particles.count = 0
	sparks.particles.count = 0
	sparks.particles.spawning = 0

/obj/effect/temp_visual/explosion/proc/set_count_long()
	dirt_kickup.particles.count = 0

/obj/effect/temp_visual/explosion/Destroy()
	QDEL_NULL(smoke_wave)
	QDEL_NULL(sparks)
	QDEL_NULL(large_kickup)
	QDEL_NULL(dirt_kickup)
	return ..()
