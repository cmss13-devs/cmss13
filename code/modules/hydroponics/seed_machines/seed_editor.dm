// Fires an extracted trait into another packet of seeds with a chance
// of destroying it based on the size/complexity of the plasmid.
/obj/structure/machinery/botany/editor
	name = "bioballistic delivery system"
	icon_state = "traitgun"
	disk_needs_genes = TRUE

/obj/structure/machinery/botany/editor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BotanyEditor", name)
		ui.open()

/obj/structure/machinery/botany/editor/ui_data(mob/user)
	var/list/data = list()
	var/list/locus = list()

	data["disk"] = loaded_disk

	if(loaded_disk && length(loaded_disk.genes))
		data["sourceName"] = loaded_disk.genesource

		for(var/datum/plantgene/P in loaded_disk.genes)
			locus.Add("[GLOB.gene_tag_masks[P.genetype]]")

		data["locus"] = locus
	else
		data["sourceName"] = FALSE
		data["locus"] = FALSE

	if(seed)
		data["seed"] = "[seed.name]"
		data["degradation"] = seed.modified
	else
		data["seed"] = FALSE
		data["degradation"] = FALSE

	return data

/obj/structure/machinery/botany/editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		// base botany machine
		if("eject_packet")
			eject_seed()
			. = TRUE

		if("eject_disk")
			eject_disk()
			. = TRUE

		if("apply_gene")
			if(!loaded_disk || !seed)
				return

			if(!isnull(GLOB.seed_types[seed.seed.name]))
				seed.seed = seed.seed.diverge(1)
				seed.seed_type = seed.seed.name
				seed.update_seed()

			if(prob(seed.modified))
				fail_task()
				seed.modified = 101
				return TRUE

			for(var/datum/plantgene/gene in loaded_disk.genes)
				seed.seed.apply_gene(gene)
				seed.modified += rand(5,10)
				playsound(loc, 'sound/machines/fax.ogg', 15, 1)
			. = TRUE
