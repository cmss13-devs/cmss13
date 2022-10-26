/datum/cas_effect/ordnance/explosion
	var/exp_power = 300
	var/exp_falloff = 40
	var/exp_falloff_type = EXPLOSION_FALLOFF_SHAPE_LINEAR

/datum/cas_effect/ordnance/incendiary
	var/fire_range = 0
	var/fire_level = 0
	var/fire_burn = 0
	var/fire_color = null

/datum/cas_effect/ordnance/particle
	var/particle_count = 4

/datum/cas_effect/ordnance/smoke
	var/smoke_radius = 1

/datum/cas_effect/ordnance/debris
/datum/cas_effect/ordnance/debris/fire()
	target.ceiling_debris_check(3)


		cell_explosion(target, exp_power, exp_falloff, exp_falloff_type, null, create_cause_data(name, source_mob))
	if(fire_range)
		fire_spread(target, create_cause_data(name, source_mob), fire_range, fire_level, fire_burn, fire_color)




		var/datum/effect_system/expl_particles/P = new/datum/effect_system/expl_particles()
		P.set_up(4, 0, impact)
		P.start()
		spawn(5)
			var/datum/effect_system/smoke_spread/S = new/datum/effect_system/smoke_spread()
			S.set_up(1,0,impact,null)
			S.start()
