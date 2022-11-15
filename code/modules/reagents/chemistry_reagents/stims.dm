
/datum/reagent/stimulant
	reagent_state = LIQUID
	custom_metabolism = AMOUNT_PER_TIME(1, 1 MINUTES) // Consumes 1 unit per minute.
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_NONE
	flags = REAGENT_SCANNABLE | REAGENT_TYPE_STIMULANT
	var/jitter_speed = 0.3 SECONDS
	var/jitter_per_amount = 2
	var/jitter = 2

/datum/reagent/stimulant/on_mob_life(mob/living/M, alien, delta_time)
	. = ..()
	// Stimulants drain faster for each stimulant in the drug.
	// Having 2 stimulants means the duration will be 2x shorter, having 3 will be 3x shorter, etc
	if(holder)
		for(var/i in holder.reagent_list)
			if(i == src)
				continue

			var/datum/reagent/R = i
			if(R.flags & REAGENT_TYPE_STIMULANT)
				holder.remove_reagent(R, custom_metabolism)

	// We multiply delta_time by 1.5 so that it looks like it is consistent.
	var/time_per_animate = (jitter_speed/(jitter_per_amount + 2))

	animate(M, pixel_x = rand(-jitter, jitter), pixel_y = rand(-jitter, jitter), time = time_per_animate, flags=ANIMATION_END_NOW)
	for(var/i in 1 to jitter_per_amount)
		animate(pixel_x = rand(-jitter, jitter), pixel_y = rand(-jitter, jitter), time = time_per_animate)
	animate(pixel_x = 0, pixel_y = 0, time = time_per_animate)

/datum/reagent/stimulant/speed_stimulant
	name = "Speed Stimulant"
	id = "speed_stimulant"
	description = "A highly experimental performance enhancement stimulant. It is not addictive."
	color = "#ffff00"
	properties = list(
		PROPERTY_MUSCLESTIMULATING = 40,
		PROPERTY_PAINKILLING = 3
	)

/datum/reagent/stimulant/brain_stimulant
	name = "Brain Stimulant"
	id = "brain_stimulant"
	description = "A highly experimental CNS stimulant."
	color = "#a800ff"
	properties = list(
		PROPERTY_NERVESTIMULATING = 30,
		PROPERTY_PAINKILLING = 6,
		PROPERTY_NEUROSHIELDING = 1
	)

/datum/reagent/stimulant/redemption_stimulant
	name = "Redemption Stimulant"
	id = "redemption_stimulant"
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	description = {"\
		A highly experimental bone, organ and muscle stimulant.\
		Increases the durability of skin and bones as well as nullifying any pain.\
		Pain is impossible to feel whilst this drug is in your system.\
		During the metabolism of this drug, dysfunctional organs will work normally."}
	color = "#00ffa8"
	properties = list(
		PROPERTY_NERVESTIMULATING = 2,
		PROPERTY_MUSCLESTIMULATING = 2,
		PROPERTY_PAINKILLING = 100,
		PROPERTY_BONEMENDING = 100,
		PROPERTY_ORGAN_HEALING = 100,
		PROPERTY_HYPERDENSIFICATING = 1,
		PROPERTY_ORGANSTABILIZE = 1,
	)

//*****************************************************************************************************/
//*****************************************Xeno stims**************************************************/
//*****************************************************************************************************/

/datum/reagent/stimulant/purple_plasma_stim
	name = "Purple Plasma Stim"
	id = "purple_plasma_stim"
	description = "An experimental xeno-stim taken from the Drone strains. It simulates the properties of xeno resin by gently soothing and repairing damage suffered."
	color = "#a65d7f"
	properties = list(
		PROPERTY_MUSCLESTIMULATING = 5,
		PROPERTY_PAINKILLING = 5, //Tramadol
		PROPERTY_REPAIRING = 2,
		PROPERTY_ANTITOXIC = 2, //Dylovane
		PROPERTY_ANTICORROSIVE = 2, //Kelotane
		PROPERTY_NEOGENETIC = 2, //Bicaridine
		PROPERTY_HEMOGENIC = 2,
	)

/datum/reagent/stimulant/pheromone_plasma_stim
	name = "Pheromone Plasma Stim"
	id = "pheromone_plasma_stim"
	description = "An experimental xeno-stim taken from the strong pheromone-producing castes. It simulates the properties of xeno pheromones."
	color = "#a2e7d6"
	properties = list(
		PROPERTY_MUSCLESTIMULATING = 5,
		PROPERTY_PAINKILLING = 8,
		PROPERTY_ANTITOXIC = 5,
		PROPERTY_ANTICORROSIVE = 5,
		PROPERTY_NEOGENETIC = 5,
		PROPERTY_HEMOGENIC = 2,
		PROPERTY_HYPERDENSIFICATING = 1,
	)

/datum/reagent/stimulant/chitin_plasma_stim
	name = "Chitin Plasma Stim"
	id = "chitin_plasma_stim"
	description = "An experimental xeno-stim taken from the Defender strains. It heals broken bones and prevents new internal damage from forming."
	color = "#6d7694"
	properties = list(
		PROPERTY_BONEMENDING = 5,
		PROPERTY_HYPERDENSIFICATING = 1,
		PROPERTY_ORGANSTABILIZE = 1,
	)

/datum/reagent/stimulant/catecholamine_plasma_stim
	name = "Catecholamine Plasma Stim"
	id = "catecholamine_plasma_stim"
	description = "An experimental xeno-stim taken from the Runner strains. It speeds up user's reflexes."
	color = "#cf7551"
	properties = list(
		PROPERTY_MUSCLESTIMULATING = 20,
		PROPERTY_NERVESTIMULATING = 10,
	)

/datum/reagent/stimulant/egg_plasma_stim
	name = "Egg Plasma Stim"
	id = "egg_plasma_stim"
	description = "An experimental xeno-stim taken from the eggs. It repairs user's organs and stops further organ damage."
	color = "#c3c371"
	properties = list(
		PROPERTY_ORGAN_HEALING = 1,
		PROPERTY_ORGANSTABILIZE = 1,
	)

/datum/reagent/stimulant/neurotoxin_plasma_stim
	name = "Neurotoxin Plasma Stim"
	id = "neurotoxin_plasma_stim"
	description = "An experimental xeno-stim taken from the Sentinel strains. It speeds up and regenerates neural pathways in the brain and eyes."
	color = "#ba8216"
	properties = list(
		PROPERTY_NERVESTIMULATING = 20,
		PROPERTY_NEUROPEUTIC = 1,
		PROPERTY_OCULOPEUTIC = 1,
		PROPERTY_NEUROSHIELDING = 1,
	)

/datum/reagent/stimulant/royal_plasma_stim
	name = "Royal Plasma Stim"
	id = "royal_plasma_stim"
	description = "An experimental xeno-stim taken from the Queen's blood. It is very potent and makes its users feel invincible."
	color = "#ffeb9c"
	properties = list(
		PROPERTY_NERVESTIMULATING = 10,
		PROPERTY_MUSCLESTIMULATING = 10,
		PROPERTY_PAINKILLING = 100,
		PROPERTY_BONEMENDING = 10,
		PROPERTY_ORGAN_HEALING = 10,
		PROPERTY_HYPERDENSIFICATING = 1,
		PROPERTY_ORGANSTABILIZE = 1,
	)
