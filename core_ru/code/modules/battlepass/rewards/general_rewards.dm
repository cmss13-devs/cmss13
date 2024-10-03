/datum/battlepass_reward/general
	lifeform_type = "All"


/datum/battlepass_reward/general/particle
	var/particle_path

/datum/battlepass_reward/general/particle/on_claim(mob/target_mob)
	var/particles/new_particle = new particle_path()
	new_particle.resize_pos(target_mob)
	target_mob.particle_holder = new(target_mob, new_particle)
	if(target_mob.icon_size == 48)
		target_mob.particle_holder.pixel_x = 16
	else if(target_mob.icon_size == 64)
		target_mob.particle_holder.pixel_x = 16
		target_mob.particle_holder.pixel_y = 16
	return TRUE


/datum/battlepass_reward/general/particle/droplets
	name = "Water Particles"
	icon_state = "droplets"
	particle_path = /particles/droplets

/datum/battlepass_reward/general/particle/acid
	name = "Acid Particles"
	icon_state = "acid"
	particle_path = /particles/acid

/datum/battlepass_reward/general/particle/music
	name = "Musical Particles"
	icon_state = "notes"
	particle_path = /particles/musical_notes

/datum/battlepass_reward/general/particle/slime
	name = "Slime Particles"
	icon_state = "slime"
	particle_path = /particles/slime

/datum/battlepass_reward/general/particle/slime_rainbow
	name = "Rbw. Slime Particles"
	icon_state = "rainbow_slime"
	particle_path = /particles/slime/rainbow

/datum/battlepass_reward/general/particle/pollen
	name = "Pollen Particles"
	icon_state = "pollen"
	particle_path = /particles/pollen
