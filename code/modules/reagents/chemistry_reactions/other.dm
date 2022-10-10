/datum/chemical_reaction/explosive
	name = "potassium hydroxide"
	id = "potassium_hydroxide"
	result = "potassium_hydroxide"
	required_reagents = list("water" = 1, "potassium" = 1)
	result_amount = 1
	var/sensitivity_threshold = 0

/datum/chemical_reaction/explosive/on_reaction(var/datum/reagents/holder, var/created_volume)
	if(created_volume > sensitivity_threshold)
		holder.trigger_volatiles = TRUE
	return

/datum/chemical_reaction/explosive/anfo
	name = "anfo"
	id = "anfo"
	result = "anfo"
	required_reagents = list("ammonium_nitrate" = 2, "fuel" = 1)
	result_amount = 2
	sensitivity_threshold = 60.001

/datum/chemical_reaction/explosive/nitroglycerin
	name = "nitroglycerin"
	id = "nitroglycerin"
	result = "nitroglycerin"
	required_reagents = list("glycerol" = 1, "pacid" = 1, "sulphuric acid" = 1)
	result_amount = 2
	sensitivity_threshold = 5.001

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


/datum/chemical_reaction/pttoxin
	name = "Toxin"
	id = "pttoxin"
	result = "pttoxin"
	required_reagents = list("paracetamol" = 1, "tramadol" = 1)
	result_amount = 2

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	result = "mutagen"
	required_reagents = list("radium" = 1, "phosphorus" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/stoxin
	name = "Soporific"
	id = "stoxin"
	result = "stoxin"
	required_reagents = list("sugar" = 4, "chloralhydrate" = 1)
	result_amount = 5

/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	result = "chloralhydrate"
	required_reagents = list("chlorine" = 3, "ethanol" = 1, "water" = 1)
	result_amount = 1

/datum/chemical_reaction/sacid
	name = "Sulfuric acid"
	id = "sulphuric acid"
	result = "sulphuric acid"
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
	required_reagents = list("sulphuric acid" = 1, "chlorine" = 1, "potassium" = 1)
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
	required_reagents = list("cornoil" = 3, "sulphuric acid" = 1)
	result_amount = 1

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	id = "flash_powder"
	result = null
	required_reagents = list("aluminum" = 1, "potassium" = 1, "sulfur" = 1 )
	result_amount = 3

	on_reaction(var/datum/reagents/holder, var/created_volume)
		var/location = get_turf(holder.my_atom)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, location)
		s.start()
		new /obj/item/device/flashlight/flare/on/illumination/chemical(location, created_volume)

/datum/chemical_reaction/chemfire
	name = "Napalm"
	id = "napalm"
	result = "napalm"
	required_reagents = list("aluminum" = 1, "phoron" = 1, "sulphuric acid" = 1 )
	result_amount = 1

/datum/chemical_reaction/chemfire/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.trigger_volatiles = TRUE
	return

// Chemfire supplement chemicals.
/datum/chemical_reaction/chlorinetrifluoride
	name = "Chlorine Trifluoride"
	id = "chlorine trifluoride"
	result = "chlorine trifluoride"
	required_reagents = list("fluorine" = 3, "chlorine" = 1)
	result_amount = 1

/datum/chemical_reaction/chlorinetrifluoride/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.trigger_volatiles = TRUE
	return

/datum/chemical_reaction/methane
	name = "Methane"
	id = "methane"
	result = "methane"
	required_reagents = list("hydrogen" = 4,"carbon" = 1)
	result_amount = 1

//Explosive components
/datum/chemical_reaction/formaldehyde
	name = "Formaldehyde"
	id = "formaldehyde"
	result = "formaldehyde"
	required_reagents = list("methane" = 1, "oxygen" = 1, "phoron" = 1)
	required_catalysts = list("silver" = 5)
	result_amount = 3

/datum/chemical_reaction/paraformaldehyde
	name = "Paraformaldehyde"
	id = "paraformaldehyde"
	result = "paraformaldehyde"
	required_reagents = list("formaldehyde" = 1, "frostoil" = 1)
	result_amount = 1

/datum/chemical_reaction/hexamine
	name = "Hexamine"
	id = "hexamine"
	result = "hexamine"
	required_reagents = list("ammonia" = 2, "formaldehyde" = 3)
	result_amount = 3

/datum/chemical_reaction/ammoniumnitrate
	name = "Ammonium Nitrate"
	id = "ammonium_nitrate"
	result = "ammonium_nitrate"
	required_reagents = list("ammonia" = 1, "pacid" = 1)
	result_amount = 2

/datum/chemical_reaction/octogen
	name = "Octogen"
	id = "octogen"
	result = "octogen"
	required_reagents = list("hexamine" = 1, "pacid" = 1, "paraformaldehyde" = 1, "ammonium_nitrate" = 1,)
	result_amount = 2

/datum/chemical_reaction/cyclonite
	name = "Cyclonite"
	id = "cyclonite"
	result = "cyclonite"
	required_reagents = list("hexamine" = 1, "pacid" = 1)
	result_amount = 1

/datum/chemical_reaction/ammoniumnitrate
	name = "Ammonium Nitrate"
	id = "ammonium_nitrate"
	result = "ammonium_nitrate"
	required_reagents = list("ammonia" = 1, "pacid" = 1)
	result_amount = 2

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
	result_amount = 0.4
	secondary = 1
	mob_react = FALSE

	on_reaction(var/datum/reagents/holder, var/created_volume)
		var/location = get_turf(holder.my_atom)
		var/datum/effect_system/smoke_spread/chem/S = new /datum/effect_system/smoke_spread/chem
		S.attach(location)
		S.set_up(holder, created_volume, 0, location)
		playsound(location, 'sound/effects/smoke.ogg', 25, 1)
		INVOKE_ASYNC(S, /datum/effect_system/smoke_spread/chem.proc/start)
		holder.clear_reagents()

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
	id = "lipozine"
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
	required_reagents = list("fluorine" = 2, "carbon" = 2, "sulphuric acid" = 1)
	result_amount = 5


/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	result = null
	required_reagents = list("fluorosurfactant" = 1, "water" = 1)
	result_amount = 2

	on_reaction(var/datum/reagents/holder, var/created_volume)

		var/location = get_turf(holder.my_atom)
		for(var/mob/M as anything in viewers(5, location))
			to_chat(M, SPAN_WARNING("The solution violently bubbles!"))

		location = get_turf(holder.my_atom)

		for(var/mob/M as anything in viewers(5, location))
			to_chat(M, SPAN_WARNING("The solution spews out foam!"))
		//for(var/datum/reagent/R in holder.reagent_list)

		var/datum/effect_system/foam_spread/s = new()
		s.set_up(created_volume, location, holder, 0)
		s.start()
		holder.clear_reagents()


/datum/chemical_reaction/metal_foam
	name = "Metal Foam"
	id = "metal_foam"
	result = null
	required_reagents = list("aluminum" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5

	on_reaction(var/datum/reagents/holder, var/created_volume)

		var/location = get_turf(holder.my_atom)

		for(var/mob/M as anything in viewers(5, location))
			to_chat(M, SPAN_WARNING("The solution spews out a metallic shiny foam!"))

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

		for(var/mob/M as anything in viewers(5, location))
			to_chat(M, SPAN_WARNING("The solution spews out a metallic dull foam!"))

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
	required_reagents = list("ammonia" = 1, "sulphuric acid" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = "plantbgone"
	required_reagents = list("water" = 4, "toxin" = 1)
	result_amount = 5

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
