/datum/autowiki/supply_packs
	generate_multiple = TRUE
	page = "Template:Autowiki/Content/SupplyPacks"


/datum/autowiki/supply_packs/generate_multiple()

	var/output = list()

	//Gets the subtypes of all supply_packs
	for(var/typepath in subtypesof(/datum/supply_packs))
		var/datum/supply_packs/my_pack = GLOB.supply_packs_datums[typepath]


		var/list/contents = list()
		for(var/obj/contents_type as anything in my_pack.contains)
			//So long as there is something in the contaienr it will add it to the list
			if(!length(my_pack.contains))
				return
			contents += contents_type::name

		var/obj/structure/closet/crate/container_typepath = my_pack.containertype
		var/container_filename = container_typepath ? SANITIZE_FILENAME(escape_value(format_text("[container_typepath::icon]-[container_typepath::icon_state]"))) : null
		if(container_filename && !fexists("data/autowiki_files/[container_filename].png"))
			var/obj/structure/closet/crate/generating_crate = new my_pack.containertype
			upload_icon(getFlatIcon(generating_crate, no_anim = TRUE), container_filename)

		var/page_name = SANITIZE_FILENAME(replacetext(strip_improper(my_pack.name), " ", "_"))
		var/to_add = list(title = "Template:Autowiki/Content/SupplyPack/[page_name]", text = include_template("Autowiki/SupplyPack",list(
			"icon" = container_filename,
			"name" = my_pack.name,
			"cost" = my_pack.cost,
			"contents" = contents.Join(", ")
			)
		))
		output += list(to_add)

	return output
