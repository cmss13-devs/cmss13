// Defines for water/potassium
#define MAXEXPOWER 		300
#define MAXEXSHARDS 	128

// Defines for napalm
#define MINRADIUS 		1
#define MAXRADIUS 		5
#define MININTENSITY	5
#define MAXINTENSITY	40
#define MINDURATION		3
#define MAXDURATION		40

/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	id = "explosion_potassium"
	result = null
	required_reagents = list("water" = 1, "potassium" = 1)
	result_amount = 1

/datum/chemical_reaction/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/atom/location = holder.my_atom.loc
	var/turf/sourceturf = get_turf(holder.my_atom)
	var/exfalloff
	var/expower
	var/shards = 4 // Because explosions are messy
	var/shard_type = /datum/ammo/bullet/shrapnel
	var/source_mob

	if(ishuman(holder.my_atom))
		var/mob/living/carbon/human/H = holder.my_atom
		source_mob = H
		msg_admin_niche("WARNING: Pill-based potassium-water explosion attempted in containing mob [H.name] ([H.ckey]) in area [sourceturf.loc] at ([H.loc.x],[H.loc.y],[H.loc.z]) (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[H.loc.x];Y=[H.loc.y];Z=[H.loc.z]'>JMP</a>)")
		holder.exploded = TRUE
		return

	if(sourceturf.chemexploded)
		return // Has recently exploded, so no explosion this time. Prevents instagib satchel charges.

	if(holder.my_atom && location) //It exists outside of null space.
		expower = created_volume*2 //60u slightly better than HEDP, 120u worse than holy hand grenade

		for(var/datum/reagent/R in holder.reagent_list) // if you want to do extra stuff when other chems are present, do it here
			if(R.id == "iron")
				shards += round(R.volume)
			if(R.id == "phoron" && R.volume >= 10)
				shard_type = /datum/ammo/bullet/shrapnel/incendiary

		// some upper limits
		if(shards > MAXEXSHARDS)
			shards = MAXEXSHARDS
		if(istype(shard_type, /datum/ammo/bullet/shrapnel/incendiary) && shards > MAXEXSHARDS / 4) // less max incendiary shards
			shards = MAXEXSHARDS / 4
		if(expower > MAXEXPOWER)
			expower = MAXEXPOWER
		exfalloff = expower/6
		if(exfalloff < 15) exfalloff = 15

		msg_admin_niche("Potassium + Water explosion in [sourceturf.loc.name] at ([sourceturf.x],[sourceturf.y],[sourceturf.z]) (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[sourceturf.x];Y=[sourceturf.y];Z=[sourceturf.z]'>JMP</a>)")
		create_shrapnel(location, shards, , ,shard_type, "chemical reaction", source_mob)
		sleep(2) // So mobs aren't knocked down before getting hit by shrapnel
		cell_explosion(location, expower, exfalloff, null, "chemical reaction", source_mob)

		sourceturf.chemexploded = TRUE // to prevent grenade stacking
		spawn(20)
			sourceturf.chemexploded = FALSE
		holder.exploded = TRUE // clears reagents after all reactions processed

	return

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	result = null
	required_reagents = list("uranium" = 1, "iron" = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

	on_reaction(var/datum/reagents/holder, var/created_volume)
		var/location = get_turf(holder.my_atom)
		// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
		// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
		empulse(location, round(created_volume / 24), round(created_volume / 14), 1)
		holder.clear_reagents()


/datum/chemical_reaction/hptoxin
	name = "Toxin"
	id = "hptoxin"
	result = "hptoxin"
	required_reagents = list("hyperzine" = 1, "peridaxon" = 1)
	result_amount = 2

/datum/chemical_reaction/pttoxin
	name = "Toxin"
	id = "pttoxin"
	result = "pttoxin"
	required_reagents = list("paracetamol" = 1, "tramadol" = 1)
	result_amount = 2

/datum/chemical_reaction/sdtoxin
	name = "Toxin"
	id = "sdtoxin"
	result = "sdtoxin"
	required_reagents = list("synaptizine" = 1, "anti_toxin" = 1)
	result_amount = 2


/datum/chemical_reaction/stoxin
	name = "Soporific"
	id = "stoxin"
	result = "stoxin"
	required_reagents = list("sugar" = 4, "chloralhydrate" = 1)
	result_amount = 5

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	result = "mutagen"
	required_reagents = list("radium" = 1, "phosphorus" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/sacid
	name = "Sulfuric acid"
	id = "sacid"
	result = "sacid"
	required_reagents = list("hydrogen" = 2, "sulfur" = 1, "oxygen" = 4)
	result_amount = 1

/datum/chemical_reaction/ethanol
	name = "Ethanol"
	id = "ethanol"
	result = "ethanol"
	required_reagents = list("hydrogen" = 6, "carbon" = 2, "oxygen" = 1)
	result_amount = 1

/datum/chemical_reaction/water //I can't believe we never had this.
	name = "Water"
	id = "water"
	result = "water"
	required_reagents = list("hydrogen" = 2, "oxygen" = 1)
	result_amount = 1


/datum/chemical_reaction/thermite
	name = "Thermite"
	id = "thermite"
	result = "thermite"
	required_reagents = list("aluminum" = 1, "iron" = 1, "oxygen" = 1)
	result_amount = 3


/datum/chemical_reaction/lexorin
	name = "Lexorin"
	id = "lexorin"
	result = "lexorin"
	required_reagents = list("phoron" = 1, "hydrogen" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = "space_drugs"
	result = "space_drugs"
	required_reagents = list("mercury" = 1, "sugar" = 1, "lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	id = "pacid"
	result = "pacid"
	required_reagents = list("sacid" = 1, "chlorine" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = "impedrezene"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	result = "cryptobiolin"
	required_reagents = list("potassium" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = "glycerol"
	required_reagents = list("cornoil" = 3, "sacid" = 1)
	result_amount = 1

/datum/chemical_reaction/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	result = "nitroglycerin"
	required_reagents = list("glycerol" = 1, "pacid" = 1, "sacid" = 1)
	result_amount = 2

	on_reaction(var/datum/reagents/holder, var/created_volume)
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)
		e.holder_damage(holder.my_atom)
		if(isliving(holder.my_atom))
			e.amount *= 0.5
			var/mob/living/L = holder.my_atom
			if(L.stat!=DEAD)
				e.amount *= 0.5
		e.start()

		holder.clear_reagents()


/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	id = "flash_powder"
	result = null
	required_reagents = list("aluminum" = 1, "potassium" = 1, "sulfur" = 1 )
	result_amount = null

	on_reaction(var/datum/reagents/holder, var/created_volume)
		var/location = get_turf(holder.my_atom)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, location)
		s.start()
		for(var/mob/living/carbon/M in viewers(world.view, location))
			switch(get_dist(M, location))
				if(0 to 3)
					if(M.flash_eyes())
						M.KnockDown(15)

				if(4 to 5)
					if(M.flash_eyes())
						M.Stun(5)


/datum/chemical_reaction/chemfire
	name = "Thermite"
	id = "thermite"
	result = null
	required_reagents = list("aluminum" = 1, "phoron" = 1, "sacid" = 1 )
	result_amount = 1

/datum/chemical_reaction/chemfire/on_reaction(var/datum/reagents/holder, var/created_volume, var/mob/user)
	var/flameshape = FLAMESHAPE_DEFAULT
	var/radius = 0
	var/intensity = 0
	var/duration = 0
	var/location = get_turf(holder.my_atom)
	var/firecolor = "red"
	var/datum/effect_system/smoke_spread/phosphorus/smoke = new /datum/effect_system/smoke_spread/phosphorus
	var/supplemented = 0 // for determining firecolor. Intensifying chems add, moderating chems remove. Net positive = blue, net negative = green.
	if(!location)
		return

	radius = max(created_volume/12, 3)
	intensity = max(created_volume/2.5, 30)
	duration = max(created_volume, 20)

	for(var/datum/reagent/R in holder.reagent_list)
		if(R.chemfiresupp)
			supplemented += R.intensitymod * R.volume
			intensity += R.intensitymod * R.volume
			duration += R.durationmod * R.volume
			radius += R.radiusmod * R.volume
			holder.del_reagent(R.id)


	// only integers please
	radius = round(radius)
	intensity = round(intensity)
	duration = round(duration)

	// some upper and lower limits
	if(radius <= MINRADIUS)
		radius = MINRADIUS
	if(radius >= MAXRADIUS)
		radius = MAXRADIUS
	if(intensity <= MININTENSITY)
		intensity = MININTENSITY
	if(intensity >= MAXINTENSITY)
		intensity = MAXINTENSITY
	if(duration <= MINDURATION)
		duration = MINDURATION
	if(duration >= MAXDURATION)
		duration = MAXDURATION

	// color
	if(supplemented > 0 && intensity > 30)
		firecolor = "blue"
		flameshape = FLAMESHAPE_STAR

	if(supplemented < 0 && intensity < 15)
		firecolor = "green"
		flameshape = FLAMESHAPE_IRREGULAR
		radius += 2 //  to make up for tiles lost to irregular shape

	smoke.set_up(max(radius - 1, 1), 0, location, null, 6)
	smoke.start()
	smoke = null

	new /obj/flamer_fire(location, "[initial(name)] fire", user, duration, intensity, firecolor, radius, FALSE, flameshape)
	sleep(5)
	playsound(location, 'sound/weapons/gun_flamethrower1.ogg', 25, 1)

// Chemfire supplement chemicals.
/datum/chemical_reaction/chlorinetrifluoride
	name = "Chlorine Trifluoride"
	id = "chlorine trifluoride"
	result = "chlorine trifluoride"
	required_reagents = list("fluorine" = 3, "chlorine" = 1)
	result_amount = 1

/datum/chemical_reaction/methane
	name = "Methane"
	id = "methane"
	result = "methane"
	required_reagents = list("hydrogen" = 4,"carbon" = 1)
	result_amount = 1

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
	result_amount = 0.4
	secondary = 1

	on_reaction(var/datum/reagents/holder, var/created_volume)
		var/location = get_turf(holder.my_atom)
		var/datum/effect_system/smoke_spread/chem/S = new /datum/effect_system/smoke_spread/chem
		S.attach(location)
		S.set_up(holder, created_volume, 0, location)
		playsound(location, 'sound/effects/smoke.ogg', 25, 1)
		INVOKE_ASYNC(S, /datum/effect_system/smoke_spread/chem.proc/start)
		holder.clear_reagents()


/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	result = "chloralhydrate"
	required_reagents = list("chlorine" = 3, "ethanol" = 1, "water" = 1)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	result = "potassium_chloride"
	required_reagents = list("sodiumchloride" = 1, "potassium" = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	result = "potassium_chlorophoride"
	required_reagents = list("potassium_chloride" = 1, "phoron" = 1, "chloralhydrate" = 1)
	result_amount = 4

/datum/chemical_reaction/stoxin
	name = "Soporific"
	id = "stoxin"
	result = "stoxin"
	required_reagents = list( "sugar" = 4, "chloralhydrate" = 1)
	result_amount = 5

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	result = "zombiepowder"
	required_reagents = list("carpotoxin" = 5, "stoxin" = 5, "copper" = 5)
	result_amount = 2

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	id = "rezadone"
	result = "rezadone"
	required_reagents = list("carpotoxin" = 1, "cryptobiolin" = 1, "copper" = 1)
	result_amount = 3

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	result = "mindbreaker"
	required_reagents = list("silicon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
	result_amount = 3

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	id = "Lipozine"
	result = "lipozine"
	required_reagents = list("sodiumchloride" = 1, "ethanol" = 1, "radium" = 1)
	result_amount = 3

/datum/chemical_reaction/phoronsolidification
	name = "Solid Phoron"
	id = "solidphoron"
	result = null
	required_reagents = list("iron" = 5, "frostoil" = 5, "phoron" = 20)
	result_amount = 1
	on_reaction(var/datum/reagents/holder, var/created_volume)
		var/location = get_turf(holder.my_atom)
		new /obj/item/stack/sheet/mineral/phoron(location)
		return

/datum/chemical_reaction/plastication
	name = "Plastic"
	id = "solidplastic"
	result = null
	required_reagents = list("pacid" = 10, "plasticide" = 20)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		new /obj/item/stack/sheet/mineral/plastic(get_turf(holder.my_atom),10)
		return

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	result = "virusfood"
	required_reagents = list("water" = 1, "milk" = 1, "oxygen" = 1)
	result_amount = 3


///////////////////////////////////////////////////////////////////////////////////

// foam and foam precursor

/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	result = "fluorosurfactant"
	required_reagents = list("fluorine" = 2, "carbon" = 2, "sacid" = 1)
	result_amount = 5


/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	result = null
	required_reagents = list("fluorosurfactant" = 1, "water" = 1)
	result_amount = 2

	on_reaction(var/datum/reagents/holder, var/created_volume)

		var/location = get_turf(holder.my_atom)
		for(var/mob/M in viewers(5, location))
			to_chat(M, SPAN_WARNING("The solution violently bubbles!"))

		location = get_turf(holder.my_atom)

		for(var/mob/M in viewers(5, location))
			to_chat(M, SPAN_WARNING("The solution spews out foam!"))
		//for(var/datum/reagent/R in holder.reagent_list)

		var/datum/effect_system/foam_spread/s = new()
		s.set_up(created_volume, location, holder, 0)
		s.start()
		holder.clear_reagents()


/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	result = null
	required_reagents = list("aluminum" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5

	on_reaction(var/datum/reagents/holder, var/created_volume)

		var/location = get_turf(holder.my_atom)

		for(var/mob/M in viewers(5, location))
			to_chat(M, SPAN_WARNING("The solution spews out a metalic foam!"))

		var/datum/effect_system/foam_spread/s = new()
		s.set_up(created_volume, location, holder, 1)
		s.start()


/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	result = null
	required_reagents = list("iron" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5

	on_reaction(var/datum/reagents/holder, var/created_volume)

		var/location = get_turf(holder.my_atom)

		for(var/mob/M in viewers(5, location))
			to_chat(M, SPAN_WARNING("The solution spews out a metalic foam!"))

		var/datum/effect_system/foam_spread/s = new()
		s.set_up(created_volume, location, holder, 2)
		s.start()


/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = "foaming_agent"
	required_reagents = list("lithium" = 1, "hydrogen" = 1)
	result_amount = 1

/datum/chemical_reaction/ammonia
	name = "Ammonia"
	id = "ammonia"
	result = "ammonia"
	required_reagents = list("hydrogen" = 3, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = "diethylamine"
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = "cleaner"
	required_reagents = list("ammonia" = 1, "water" = 1, "sodiumchloride" = 1)
	result_amount = 2

/datum/chemical_reaction/dinitroaniline
	name = "Dinitroaniline"
	id = "dinitroaniline"
	result = "dinitroaniline"
	required_reagents = list("ammonia" = 1, "sacid" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = "plantbgone"
	required_reagents = list("water" = 4, "toxin" = 1)
	result_amount = 5

// Muscle relaxant
/datum/chemical_reaction/suxamorycin
	name = "Suxamorycin"
	id = "suxamorycin"
	result = "suxamorycin"
	required_reagents = list("chloralhydrate" = 1, "oxygen" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/royalplasma
	name = "Royal plasma"
	id = "royalplasma"
	result = "royalplasma"
	required_reagents = list("eggplasma" = 1, "xenobloodroyal" = 1)
	result_amount = 2

/datum/chemical_reaction/antineurotoxin
	name = "Anti-Neurotoxin"
	id = "antineurotoxin"
	result = "antineurotoxin"
	required_reagents = list("neurotoxinplasma" = 1, "anti_toxin" = 1)
	result_amount = 1

/datum/chemical_reaction/eggplasma
	name = "Egg plasma"
	id = "eggplasma"
	result = "eggplasma"
	required_reagents = list("blood" = 10, "eggplasma" = 1)
	result_amount = 2

#undef MAXEXPOWER
#undef MAXEXSHARDS
#undef MINRADIUS
#undef MAXRADIUS
#undef MININTENSITY
#undef MAXINTENSITY
#undef MINDURATION
#undef MAXDURATION