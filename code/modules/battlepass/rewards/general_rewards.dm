/datum/battlepass_reward/general


/datum/battlepass_reward/general/particle
	category = REWARD_CATEGORY_PARTICLE
	var/particle_path

/datum/battlepass_reward/general/particle/on_claim(mob/target_mob)
	target_mob.particle_holder = new(target_mob, particle_path)


/datum/battlepass_reward/general/particle/droplets
	name = "Water Particles"
	// add icon later
	particle_path = /particles/droplets

/datum/battlepass_reward/general/particle/acid
	name = "Acid Particles"
	// add icon later
	particle_path = /particles/acid

/datum/battlepass_reward/general/particle/music
	name = "Musical Particles"
	// add icon later
	particle_path = /particles/musical_notes

/datum/battlepass_reward/general/particle/slime
	name = "Slime Particles"
	// add icon later
	particle_path = /particles/slime

/datum/battlepass_reward/general/particle/slime_rainbow
	name = "Rainbow Slime Particles"
	// add icon later
	particle_path = /particles/slime/rainbow

/datum/battlepass_reward/general/particle/pollen
	name = "Pollen Particles"
	// add icon later
	particle_path = /particles/pollen
