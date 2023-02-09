/client/proc/tag_datum(datum/target_datum)
	if(!admin_holder || QDELETED(target_datum))
		return
	admin_holder.add_tagged_datum(target_datum)

/client/proc/toggle_tag_datum(datum/target_datum)
	if(!admin_holder || !target_datum)
		return

	if(LAZYFIND(admin_holder.tagged_datums, target_datum))
		admin_holder.remove_tagged_datum(target_datum)
	else
		admin_holder.add_tagged_datum(target_datum)

/client/proc/tag_datum_mapview(datum/target_datum as mob|obj|turf|area in view(view))
	set category = "Debug"
	set name = "Tag Datum"
	tag_datum(target_datum)
