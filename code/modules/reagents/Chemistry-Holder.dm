/datum/reagents
	var/list/datum/reagent/reagent_list = new/list()
	var/total_volume = 0
	var/maximum_volume = 100
	var/atom/my_atom = null
	var/trigger_volatiles = FALSE
	var/allow_star_shape = TRUE
	var/exploded = FALSE
	var/datum/weakref/source_mob

	var/locked = FALSE

	var/max_ex_power = 175
	var/base_ex_falloff = 75
	var/max_ex_shards = 32
	var/max_fire_rad = 5
	var/max_fire_int = 20
	var/max_fire_dur = 24
	var/min_fire_rad = 1
	var/min_fire_int = 3
	var/min_fire_dur = 3

	var/fire_penetrating = FALSE

/datum/reagents/New(maximum=100)
	maximum_volume = maximum

#ifdef UNIT_TESTS
	if(!GLOB.chemical_reagents_list || !GLOB.chemical_reactions_filtered_list || !GLOB.chemical_properties_list)
		CRASH("Chemistry reagents are not set up!")
#endif

/datum/reagents/Destroy()
	QDEL_NULL_LIST(reagent_list)
	my_atom = null
	return ..()

/datum/reagents/proc/remove_any(amount=1)
	var/total_transfered = 0
	var/current_list_element = 1

	current_list_element = rand(1,length(reagent_list))

	while(total_transfered != amount)
		if(total_transfered >= amount)
			break
		if(total_volume <= 0 || !length(reagent_list))
			break

		if(current_list_element > length(reagent_list))
			current_list_element = 1
		var/datum/reagent/current_reagent = reagent_list[current_list_element]

		remove_reagent(current_reagent.id, 1)

		current_list_element++
		total_transfered++
		update_total()

	handle_reactions()
	return total_transfered

///This proc is one that removes all reagents from the targeted datum other than the designated ignored reagent
/datum/reagents/proc/remove_any_but(reagent_to_ignore, amount=1)
	var/total_transfered = 0
	var/current_list_element = 1

	current_list_element = rand(1, length(reagent_list))

	while(total_transfered != amount)
		if(total_transfered >= amount)
			break
		if(total_volume <= 0 || !length(reagent_list))
			break

		if(current_list_element > length(reagent_list))
			current_list_element = 1
		var/datum/reagent/current_reagent = reagent_list[current_list_element]

		if(current_reagent.id == reagent_to_ignore)
			if(length(reagent_list) == 1)
				break //if the reagent to be avoided is the only one in the list, we're done here.
			if(current_list_element == 1)
				current_reagent = reagent_list[current_list_element + 1] //if the selected reagent was number 1, we don't want it trying to draw id.0, so we add 1
			else
				current_reagent = reagent_list[current_list_element - 1] //same for if it was the last one in the list

		remove_reagent(current_reagent.id, 1)

		current_list_element++
		total_transfered++
		update_total()

	handle_reactions()
	return total_transfered


/datum/reagents/proc/get_master_reagent()
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			. = A


/datum/reagents/proc/get_master_reagent_name()
	var/the_name = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_name = A.name

	return the_name

/datum/reagents/proc/get_master_reagent_id()
	var/the_id = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_id = A.id

	return the_id

/// Transfers to the reagents datum of an object
/datum/reagents/proc/trans_to(atom/target, amount=1, multiplier=1, preserve_data=1, reaction = TRUE)
	var/datum/reagents/R = target?.reagents
	if(R && !locked && !R.locked && total_volume > 0)
		return trans_to_datum(R, amount, multiplier, preserve_data, reaction)

/// Transfers to a reagent datum
/datum/reagents/proc/trans_to_datum(datum/reagents/target, amount=1, multiplier=1, preserve_data=1, reaction = TRUE)//if preserve_data=0, the reagents data will be lost. Usefull if you use data for some strange stuff and don't want it to be transferred.
	amount = min(min(amount, total_volume), target.maximum_volume-target.total_volume)
	var/part = amount / total_volume
	for(var/datum/reagent/current_reagent in reagent_list)
		var/list/trans_data
		var/current_reagent_transfer = current_reagent.volume * part
		if(preserve_data)
			trans_data = copy_data(current_reagent)
		target.add_reagent(current_reagent.id, (current_reagent_transfer * multiplier), trans_data, safety = 1) //safety checks on these so all chemicals are transferred
		remove_reagent(current_reagent.id, current_reagent_transfer, safety = 1) // to the target container before handling reactions
	update_total()
	target.update_total()
	if(reaction)
		target.handle_reactions()
		handle_reactions()
	return amount

/// Transfers to object as ingestion
/datum/reagents/proc/trans_to_ingest(atom/movable/target, amount=1, multiplier=1, preserve_data=1) //For items ingested. A delay is added between ingestion and addition of the reagents
	if(!target?.reagents || total_volume <= 0)
		return

	var/datum/reagents/vessel/V = new(1000) //temporary holder
	var/datum/reagents/R = target.reagents
	amount = min(min(amount, total_volume), R.maximum_volume - R.total_volume)
	trans_to_datum(V, amount, reaction = FALSE)
	if(issynth(target))
		return
	to_chat(target, SPAN_NOTICE("You taste [pick(V.reagent_list)]."))

	for(var/datum/reagent/RG in V.reagent_list) // If it can't be ingested, remove it.
		if(RG.flags & REAGENT_NOT_INGESTIBLE)
			V.del_reagent(RG.id)

	addtimer(CALLBACK(V, TYPE_PROC_REF(/datum/reagents/vessel, inject_vessel), target, INGEST, TRUE, 0.5 SECONDS), 9.5 SECONDS)
	return amount

///You can search for specific reagents using the specific reagents arg.
/datum/reagents/proc/set_source_mob(new_source_mob, specific_reagent)
	for(var/datum/reagent/R in reagent_list)
		if(specific_reagent)
			if(istype(R, specific_reagent))
				R.last_source_mob = WEAKREF(new_source_mob)
				if(R.data_properties)
					R.data_properties["last_source_mob"] = R.last_source_mob
				return
			continue
		R.last_source_mob = WEAKREF(new_source_mob)
		if(R.data_properties)
			R.data_properties["last_source_mob"] = R.last_source_mob

/datum/reagents/proc/copy_to(obj/target, amount=1, multiplier=1, preserve_data=1, safety = 0)
	if(!target)
		return
	if(!target.reagents || total_volume<=0)
		return
	var/datum/reagents/R = target.reagents
	amount = min(min(amount, total_volume), R.maximum_volume-R.total_volume)
	var/part = amount / total_volume
	var/trans_data = null
	for(var/datum/reagent/current_reagent in reagent_list)
		var/current_reagent_transfer = current_reagent.volume * part
		if(preserve_data)
			trans_data = copy_data(current_reagent)
		R.add_reagent(current_reagent.id, (current_reagent_transfer * multiplier), trans_data, safety = 1) //safety check so all chemicals are transferred before reacting

	update_total()
	R.update_total()
	if(!safety)
		R.handle_reactions()
		handle_reactions()
	return amount

/datum/reagents/proc/trans_id_to(obj/target, reagent, amount=1, preserve_data=1)//Not sure why this proc didn't exist before. It does now! /N
	if(!target)
		return
	if(!target.reagents || total_volume<=0 || !get_reagent_amount(reagent))
		return

	var/datum/reagents/R = target.reagents
	if(get_reagent_amount(reagent)<amount)
		amount = get_reagent_amount(reagent)
	amount = min(amount, R.maximum_volume-R.total_volume)
	var/trans_data = null
	for(var/datum/reagent/current_reagent in reagent_list)
		if(current_reagent.id == reagent)
			if(preserve_data)
				trans_data = copy_data(current_reagent)
			R.add_reagent(current_reagent.id, amount, trans_data)
			remove_reagent(current_reagent.id, amount, 1)
			break

	update_total()
	R.update_total()
	R.handle_reactions()
	//handle_reactions() Don't need to handle reactions on the source since you're (presumably isolating and) transferring a specific reagent.
	return amount

/datum/reagents/proc/metabolize(mob/M, alien, delta_time)
	for(var/datum/reagent/reagent in reagent_list)
		if(M && reagent && !QDELETED(reagent))
			reagent.on_mob_life(M, alien, delta_time)
	update_total()

/datum/reagents/proc/handle_reactions()
	if(!my_atom)
		return
	if(my_atom.flags_atom & NOREACT)
		return //Yup, no reactions here. No siree.

	var/reaction_occurred = FALSE
	do
		reaction_occurred = FALSE
		for(var/datum/reagent/reagent in reagent_list) // Usually a small list
			if(reagent.original_id) //Prevent synthesised chem variants from being mixed
				for(var/datum/reagent/current in reagent_list)
					if(current.id == reagent.id)
						continue
					else if(current.original_id == reagent.original_id || current.id == reagent.original_id)
						//Merge into the original
						reagent_list -= reagent
						current.volume += reagent.volume
						qdel(reagent)
						break
			for(var/datum/chemical_reaction/reaction in GLOB.chemical_reactions_filtered_list[reagent.id]) // Was a big list but now it should be smaller since we filtered it with our reagent id
				var/total_required_reagents = length(reaction.required_reagents)
				var/total_matching_reagents = 0
				var/total_required_catalysts = 0
				if(reaction.required_catalysts)
					total_required_catalysts = length(reaction.required_catalysts)
				var/total_matching_catalysts= 0
				var/matching_container = FALSE
				var/list/multipliers = new/list()

				for(var/required_reagent in reaction.required_reagents)
					if(!has_reagent(required_reagent, reaction.required_reagents[required_reagent]))
						break
					total_matching_reagents++
					multipliers += floor(get_reagent_amount(required_reagent) / reaction.required_reagents[required_reagent])
				for(var/catalyst in reaction.required_catalysts)
					if(catalyst == "silver" && istype(my_atom, /obj/item/reagent_container/glass/beaker/silver))
						total_matching_catalysts++
						continue
					if(!has_reagent(catalyst, reaction.required_catalysts[catalyst]))
						break
					total_matching_catalysts++

				if(isliving(my_atom) && !reaction.mob_react) //Makes it so some chemical reactions don't occur in mobs
					continue

				if(!reaction.required_container)
					matching_container = TRUE
				else if(ispath(my_atom.type, reaction.required_container))
					matching_container = TRUE

				if(total_matching_reagents == total_required_reagents && total_matching_catalysts == total_required_catalysts && matching_container)
					var/multiplier = min(multipliers)
					var/preserved_data = null
					for(var/required_reagent in reaction.required_reagents)
						if(!preserved_data)
							preserved_data = get_data(required_reagent)
						remove_reagent(required_reagent, (multiplier * reaction.required_reagents[required_reagent]), safety = TRUE)

					var/created_volume = reaction.result_amount*multiplier
					if(reaction.result)

						multiplier = max(multiplier, 1) //this shouldnt happen ...
						add_reagent(reaction.result, reaction.result_amount*multiplier)
						set_data(reaction.result, preserved_data)

						//add secondary products
						for(var/secondary_result in reaction.secondary_results)
							add_reagent(secondary_result, reaction.result_amount * reaction.secondary_results[secondary_result] * multiplier)

					var/list/seen = viewers(4, get_turf(my_atom))
					for(var/mob/M in seen)
						to_chat(M, SPAN_NOTICE("[icon2html(my_atom, M)] The solution begins to bubble."))

					playsound(get_turf(my_atom), 'sound/effects/bubbles.ogg', 15, 1)

					reaction.on_reaction(src, created_volume)
					reaction_occurred = TRUE
					break

	while(reaction_occurred)
	if(trigger_volatiles)
		handle_volatiles()
	if(exploded) //clear reagents only when everything has reacted
		clear_reagents()
		exploded = FALSE
	update_total()
	return FALSE

/datum/reagents/proc/isolate_reagent(reagent)
	for(var/datum/reagent/R in reagent_list)
		if(R.id != reagent)
			del_reagent(R.id)
			update_total()

/datum/reagents/proc/del_reagent(reagent)
	for(var/datum/reagent/R in reagent_list)
		if(R.id == reagent)
			R.on_delete()
			reagent_list -= R
			qdel(R)
			update_total()
			my_atom?.on_reagent_change()
			return FALSE
	return TRUE

// Returns FALSE if the reagent is getting deleted
/datum/reagents/proc/update_total()
	total_volume = 0
	for(var/datum/reagent/R in reagent_list)
		if(R.volume < 0.1)
			R.deleted = TRUE
			del_reagent(R.id)
		else
			total_volume += R.volume

	return FALSE

/datum/reagents/proc/clear_reagents()
	for(var/datum/reagent/R in reagent_list)
		del_reagent(R.id)
	return FALSE

/datum/reagents/proc/reaction(atom/A, method=TOUCH, volume_modifier=0, permeable_in_mobs=TRUE)
	if(method != TOUCH && method != INGEST)
		return
	for(var/datum/reagent/R in reagent_list)
		if(ismob(A))
			R.reaction_mob(A, method, R.volume + volume_modifier, permeable_in_mobs)
		else if(isturf(A))
			R.reaction_turf(A, R.volume + volume_modifier)
		else if(isobj(A))
			R.reaction_obj(A, R.volume + volume_modifier)

/datum/reagents/proc/add_reagent(reagent, amount, list/data, safety = 0)
	if(!reagent || !isnum(amount))
		return TRUE

	update_total()
	if(total_volume + amount > maximum_volume)
		amount = maximum_volume - total_volume //Doesnt fit in. Make it disappear. Shouldnt happen. Will happen.

	var/new_data = list("blood_type" = null, "blood_color" = "#A10808", "viruses" = null, "resistances" = null, "last_source_mob" = null)
	if(data)
		for(var/index in data)
			new_data[index] = data[index]

	for(var/datum/reagent/R in reagent_list)
		if(R.id == reagent)
			R.volume += amount
			R.last_source_mob = new_data["last_source_mob"]
			update_total()

			if(my_atom)
				my_atom.on_reagent_change()
				for(var/datum/chem_property/P in R.properties)
					P.reagent_added(my_atom, R, R.volume)

			// mix dem viruses
			if(R.data_properties && data)
				if(R.data_properties["viruses"] || new_data["viruses"])

					var/list/mix1 = R.data_properties["viruses"]
					var/list/mix2 = new_data["viruses"]

					// Stop issues with the list changing during mixing.
					var/list/to_mix = list()

					for(var/datum/disease/advance/AD in mix1)
						to_mix += AD
					for(var/datum/disease/advance/AD in mix2)
						to_mix += AD

					var/datum/disease/advance/AD = Advance_Mix(to_mix)
					if(AD)
						var/list/preserve = list(AD)
						for(var/D in R.data_properties["viruses"])
							if(!istype(D, /datum/disease/advance))
								preserve += D
						R.data_properties["viruses"] = preserve

			if(!safety)
				handle_reactions()
			return FALSE

	var/datum/reagent/D = GLOB.chemical_reagents_list[reagent]
	if(D)
		if(!istype(D, /datum/reagent))
			CRASH("Not REAGENT - [reagent] - GLOB.chemical_reagents_list[reagent]")

		var/datum/reagent/R = new D.type()
		if(D.type == /datum/reagent/generated)
			R.make_alike(D)
		R.holder = src
		R.volume = amount
		SetViruses(R, new_data) // Includes setting data
		reagent_list += R

		if(my_atom)
			for(var/datum/chem_property/P in D.properties)
				P.reagent_added(my_atom, D, amount)

		update_total()
		my_atom?.on_reagent_change()
		if(!safety)
			handle_reactions()
		return FALSE
	else
		warning("[my_atom] attempted to add a reagent called '[reagent]' which doesn't exist. ([usr])")

	if(!safety)
		handle_reactions()

	return TRUE

/datum/reagents/proc/remove_reagent(reagent, amount, safety = 0)//Added a safety check for the trans_id_to
	if(!isnum(amount))
		return TRUE

	for(var/datum/reagent/R in reagent_list)
		if(R.id == reagent)
			R.volume -= amount
			update_total()
			if(!safety)//So it does not handle reactions when it need not to
				handle_reactions()
			my_atom?.on_reagent_change()
			return FALSE

	return TRUE

/datum/reagents/proc/has_reagent(reagent, amount = -1)
	for(var/datum/reagent/R in reagent_list)
		if(R.id == reagent)
			if(!amount)
				return R
			else
				if(R.volume >= amount)
					return R
				else
					return FALSE
	return FALSE

/datum/reagents/proc/get_reagent_amount(reagent)
	for(var/datum/reagent/R in reagent_list)
		if(R.id == reagent)
			return R.volume
	return 0

/datum/reagents/proc/get_reagents()
	var/res = ""
	for(var/datum/reagent/A in reagent_list)
		if(res != "")
			res += ","
		res += A.name

	return res

/datum/reagents/proc/remove_all_type(reagent_type, amount, strict = 0, safety = 1) // Removes all reagent of X type. @strict set to 1 determines whether the childs of the type are included.
	if(!isnum(amount))
		return TRUE

	var/has_removed_reagent = FALSE

	for(var/datum/reagent/R in reagent_list)
		var/matches = FALSE
		// Switch between how we check the reagent type
		if(strict)
			if(R.type == reagent_type)
				matches = TRUE
		else
			if(istype(R, reagent_type))
				matches = TRUE
		// We found a match, proceed to remove the reagent. Keep looping, we might find other reagents of the same type.
		if(matches)
			// Have our other proc handle removement
			has_removed_reagent = remove_reagent(R.id, amount, safety)

	return has_removed_reagent

//two helper functions to preserve data across reactions (needed for xenoarch)
/datum/reagents/proc/get_data(reagent_id)
	for(var/datum/reagent/D in reagent_list)
		if(D.id == reagent_id)
			return D.data_properties

/datum/reagents/proc/set_data(reagent_id, new_data)
	for(var/datum/reagent/D in reagent_list)
		if(D.id == reagent_id)
			D.data_properties = new_data

/datum/reagents/proc/copy_data(datum/reagent/current_reagent)
	if(!current_reagent || !current_reagent.data_properties)
		return null
	if(!istype(current_reagent.data_properties, /list))
		return current_reagent.data_properties

	var/list/trans_data = current_reagent.data_properties.Copy()

	return trans_data

/datum/reagents/proc/replace_with(list/replacing, result, amount)
	for(var/id in replacing)
		if(get_reagent_amount(id) < replacing[id])
			return FALSE
	for(var/id in replacing)
		remove_reagent(id, replacing[id], TRUE)
	add_reagent(result, amount)
	return TRUE

//*****************************************************************************************************/
//**************************************Explosions and Fire********************************************/
//*****************************************************************************************************/

/datum/reagents/proc/handle_volatiles()
	if(isliving(my_atom))
		return
	var/turf/sourceturf = get_turf(my_atom)
	//For explosion
	var/ex_power = 0
	var/ex_falloff = base_ex_falloff
	var/ex_falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR
	var/dir = null
	var/shrapnel_spread = 360
	//For chemical fire
	var/radius = 0
	var/intensity = 0
	var/duration = 0
	var/supplemented = 0 //for determining fire shape. Intensifying chems add, moderating chems remove.
	var/smokerad = 0
	var/fire_penetrating = FALSE
	var/hit_angle

	var/list/supplements = list()
	for(var/datum/reagent/R in reagent_list)
		if(R.explosive)
			//Calculate explosive power
			ex_power += R.volume*R.power
			//Calculate falloff
			ex_falloff += R.volume*R.falloff_modifier
		if(R.chemfiresupp)
			supplements += R
			supplemented += R.intensitymod * R.volume
			intensity += R.intensitymod * R.volume
			duration += R.durationmod * R.volume
			radius += R.radiusmod * R.volume
			if(R.fire_penetrating && R.volume >= CHEM_FIRE_PENETRATION_THRESHOLD)
				fire_penetrating = TRUE
		if(R.id == "phosphorus")
			smokerad = min(R.volume / CHEM_FIRE_PHOSPHORUS_PER_RADIUS, max_fire_rad - 1)
	if(istype(my_atom, /obj/item/explosive))
		var/obj/item/explosive/E = my_atom
		ex_falloff_shape = E.falloff_mode
		shrapnel_spread = E.shrapnel_spread
		hit_angle = E.hit_angle
		if(E.use_dir)
			if(E.last_move_dir) // Higher precision for grenade and what not.
				dir = E.last_move_dir
			else
				dir = E.dir

	//only integers please
	radius = floor(radius)
	intensity = floor(intensity)
	duration = floor(duration)
	if(ex_power > 0)
		explode(sourceturf, ex_power, ex_falloff, ex_falloff_shape, dir, shrapnel_spread, hit_angle)
	if(intensity > 0)
		var/firecolor = mix_burn_colors(supplements)
		combust(sourceturf, radius, intensity, duration, supplemented, firecolor, smokerad, fire_penetrating) // TODO: Implement directional flames
	if(exploded && sourceturf)
		sourceturf.chemexploded = TRUE // to prevent grenade stacking
		addtimer(CALLBACK(sourceturf, TYPE_PROC_REF(/turf, reset_chemexploded)), 2 SECONDS)
	trigger_volatiles = FALSE
	return exploded

/datum/reagents/proc/explode(turf/sourceturf, ex_power, ex_falloff, ex_falloff_shape, dir, shrapnel_angle, hit_angle)
	if(!sourceturf)
		return
	if(sourceturf.chemexploded)
		return // Has recently exploded, so no explosion this time. Prevents instagib satchel charges.

	var/shards = EXPLOSION_BASE_SHARDS // Because explosions are messy
	var/shard_type = /datum/ammo/bullet/shrapnel
	var/atom/source_atom = source_mob?.resolve()

	if(ishuman(my_atom))
		var/mob/living/carbon/human/H = my_atom
		var/source_mob_name = "unknown"
		if(source_atom)
			source_mob_name = "[source_atom]"
		msg_admin_niche("WARNING: Ingestion based explosion attempted in containing mob [key_name(H)] made by [key_name(source_mob_name)] in area [sourceturf.loc] at ([H.loc.x],[H.loc.y],[H.loc.z]) [ADMIN_JMP(H.loc)]")
		exploded = TRUE
		return

	if(my_atom) //It exists outside of null space.
		for(var/datum/reagent/reagent in reagent_list) // if you want to do extra stuff when other chems are present, do it here
			if(reagent.id == "iron")
				shards += floor(reagent.volume)
			else if(reagent.id == "phoron" && reagent.volume >= EXPLOSION_PHORON_THRESHOLD)
				shard_type = /datum/ammo/bullet/shrapnel/incendiary
			else if(reagent.id == "sulphuric acid" && reagent.volume >= EXPLOSION_ACID_THRESHOLD)
				shard_type = /datum/ammo/bullet/shrapnel/hornet_rounds
			else if(reagent.id == "neurotoxinplasma" && reagent.volume >= EXPLOSION_NEURO_THRESHOLD)
				shard_type = /datum/ammo/bullet/shrapnel/neuro

		// some upper limits
		if(shards > max_ex_shards)
			shards = max_ex_shards
		if(ispath(shard_type, /datum/ammo/bullet/shrapnel/incendiary) && shards > max_ex_shards / INCENDIARY_SHARDS_MAX_REDUCTION) // less max incendiary shards
			shards = max_ex_shards / INCENDIARY_SHARDS_MAX_REDUCTION
		else if(ispath(shard_type, /datum/ammo/bullet/shrapnel/hornet_rounds) && shards > max_ex_shards / HORNET_SHARDS_MAX_REDUCTION)
			shards = max_ex_shards / HORNET_SHARDS_MAX_REDUCTION
		else if(ispath(shard_type, /datum/ammo/bullet/shrapnel/neuro) && shards > max_ex_shards / NEURO_SHARDS_MAX_REDUCTION)
			shards = max_ex_shards / NEURO_SHARDS_MAX_REDUCTION
		if(ex_power > max_ex_power)
			ex_power = max_ex_power
		if(ex_falloff < EXPLOSION_MIN_FALLOFF)
			ex_falloff = EXPLOSION_MIN_FALLOFF

		//Note: No need to log here as that is done in cell_explosion()
		var/datum/cause_data/cause_data = create_cause_data("chemical explosion", source_atom)
		create_shrapnel(sourceturf, shards, isnum(hit_angle) ? hit_angle : dir, shrapnel_angle, shard_type, cause_data, FALSE, 0.15, isnum(hit_angle))
		if((istype(my_atom, /obj/item/explosive/plastic) || istype(my_atom, /obj/item/explosive/grenade)) && (ismob(my_atom.loc) || isStructure(my_atom.loc)))
			addtimer(CALLBACK(my_atom.loc, TYPE_PROC_REF(/atom, ex_act), ex_power), 0.2 SECONDS)
			ex_power = ex_power / 2
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), sourceturf, ex_power, ex_falloff, ex_falloff_shape, dir, cause_data), 0.2 SECONDS)

		exploded = TRUE // clears reagents after all reactions processed

	return exploded

/datum/reagents/proc/combust(turf/sourceturf, radius, intensity, duration, supplemented, firecolor, smokerad, fire_penetrating)
	if(!sourceturf)
		return
	if(sourceturf.chemexploded)
		return // Has recently exploded, so no explosion this time. Prevents instagib satchel charges.

	var/flameshape = FLAMESHAPE_DEFAULT

	// some upper and lower limits
	if(radius <= min_fire_rad)
		radius = min_fire_rad
	else if(radius >= max_fire_rad)
		radius = max_fire_rad
	if(intensity <= min_fire_int)
		intensity = min_fire_int
	else if(intensity >= max_fire_int)
		intensity = max_fire_int
	if(duration <= min_fire_dur)
		duration = min_fire_dur
	else if(duration >= max_fire_dur)
		duration = max_fire_dur

	// shape
	if(supplemented > 0 && intensity > CHEM_FIRE_STAR_THRESHOLD && allow_star_shape)
		flameshape = FLAMESHAPE_STAR

	if(supplemented < 0 && intensity < CHEM_FIRE_IRREGULAR_THRESHOLD)
		flameshape = FLAMESHAPE_IRREGULAR
		radius += 2 //  to make up for tiles lost to irregular shape

	// smoke
	if(smokerad)
		var/datum/effect_system/smoke_spread/phosphorus/smoke = new /datum/effect_system/smoke_spread/phosphorus
		smoke.set_up(max(smokerad, 1), 0, sourceturf, null, 6)
		smoke.start(intensity, max_fire_int)
		smoke = null

	exploded = TRUE // clears reagents after all reactions processed

	msg_admin_attack("Chemical fire with Intensity: [intensity], Duration: [duration], Radius: [radius], Flameshape: [flameshape] in [sourceturf.loc.name] ([sourceturf.x],[sourceturf.y],[sourceturf.z]).", sourceturf.x, sourceturf.y, sourceturf.z)

	var/datum/reagent/R = new()
	R.durationfire = duration
	R.intensityfire = intensity
	R.rangefire = radius

	R.burncolor = firecolor
	R.color = firecolor

	R.fire_penetrating = fire_penetrating

	new /obj/flamer_fire(sourceturf, create_cause_data("chemical fire", source_mob?.resolve()), R, radius, FALSE, flameshape)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), sourceturf, 'sound/weapons/gun_flamethrower1.ogg', 25, 1), 0.5 SECONDS)

/// Checks if any of the reagents contained within are harmful
/datum/reagents/proc/contains_harmful_substances()
	for(var/datum/reagent/reagent as anything in reagent_list)
		for(var/datum/chem_property/property as anything in reagent.properties)
			if(property.can_cause_harm())
				return TRUE

/turf/proc/reset_chemexploded()
	chemexploded = FALSE

//*****************************************************************************************************/

// Convenience proc to create a reagents holder for an atom
// Max vol is maximum volume of holder
/atom/proc/create_reagents(max_vol)
	QDEL_NULL(reagents)
	reagents = new/datum/reagents(max_vol)
	reagents.my_atom = src
