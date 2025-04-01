// Allows for a trait to be extracted from a seed packet, destroying that seed.
/obj/structure/machinery/botany/extractor
	name = "lysis-isolation centrifuge"
	icon_state = "traitcopier"

	var/datum/seed/genetics // Currently scanned seed genetic structure.
	var/degradation = 0     // Increments with each scan, stops allowing gene mods after a certain point.

/obj/structure/machinery/botany/extractor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BotanyExtractor", name)
		ui.open()

/obj/structure/machinery/botany/extractor/ui_data(mob/user)
	var/list/data = list()
	var/list/geneMasks = list()

	for(var/gene_tag in GLOB.gene_tag_masks)
		var/list/genedata = list(list(
			"tag" = gene_tag,
			"mask" = GLOB.gene_tag_masks[gene_tag]
		))
		geneMasks += genedata

	data["geneMasks"] = geneMasks
	data["degradation"] = degradation
	data["disk"] = loaded_disk

	if(seed)
		data["seed"] = "[seed.name]"
	else
		data["seed"] = FALSE

	if(genetics)
		data["hasGenetics"] = TRUE
		data["sourceName"] = genetics.display_name
		if(!genetics.roundstart)
			data["sourceName"] += " (variety #[genetics.uid])"
	else
		data["hasGenetics"] = FALSE
		data["sourceName"] = FALSE

	return data

/obj/structure/machinery/botany/extractor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
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

		if("scan_genome")
			if(!seed)
				return FALSE

			if(seed && seed.seed)
				genetics = seed.seed
				degradation = 0

			QDEL_NULL(seed)
			. = TRUE
		if("get_gene")
			if(!genetics || !loaded_disk)
				return FALSE

			var/datum/plantgene/P = genetics.get_gene(params["gene"])
			if(!P)
				return FALSE

			degradation += rand(20,60)
			if(degradation >= 100)
				fail_task()
				QDEL_NULL(genetics)
				degradation = 0
				return TRUE

			loaded_disk.genes += P

			loaded_disk.genesource = "[genetics.display_name]"
			if(!genetics.roundstart)
				loaded_disk.genesource += " (variety #[genetics.uid])"

			loaded_disk.name += " ([GLOB.gene_tag_masks[params["gene"]]], #[genetics.uid])"
			loaded_disk.desc += " The label reads \'gene [GLOB.gene_tag_masks[params["gene"]]], sampled from [genetics.display_name]\'."
			playsound(loc, 'sound/machines/fax.ogg', 15, 1)
			eject_disk()

			. = TRUE
		if("clear_buffer")
			if(!genetics)
				return
			genetics = null
			degradation = 0
			. = TRUE

