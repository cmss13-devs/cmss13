/datum/autowiki/guns
	page = "Template:Autowiki/Content/GunData"


/datum/autowiki/guns/generate()
	var/output = ""

	var/list/gun_to_ammo = list()

	for(var/obj/item/ammo_magazine/typepath as anything in subtypesof(/obj/item/ammo_magazine) - typesof(/obj/item/ammo_magazine/internal))
		if(isnull(initial(typepath.icon_state)))
			continue // Skip mags with no icon_state (e.g. base types)
		LAZYADD(gun_to_ammo[initial(typepath.gun_type)], typepath)

	for(var/typepath in sort_list(subtypesof(/obj/item/weapon/gun), GLOBAL_PROC_REF(cmp_typepaths_asc)))
		var/obj/item/weapon/gun/generating_gun = typepath
		if(isnull(initial(generating_gun.icon_state)))
			continue // Skip guns with no icon_state (e.g. base types)

		generating_gun = new typepath()
		var/filename = SANITIZE_FILENAME(escape_value(format_text(generating_gun.name)))
		var/list/gun_data = generating_gun.ui_data()

		var/list/valid_mag_types = list()
		for(var/path in gun_to_ammo)
			if(!istype(generating_gun, path))
				continue

			valid_mag_types += gun_to_ammo[path]

		var/ammo = ""
		var/damage_table = ""
		for(var/ammo_typepath in valid_mag_types)
			var/obj/item/ammo_magazine/generating_mag = new ammo_typepath()

			var/ammo_filename = SANITIZE_FILENAME(escape_value(format_text(generating_mag.name)))

			if(!fexists("data/autowiki_files/[ammo_filename].png"))
				upload_icon(getFlatIcon(generating_mag, no_anim = TRUE), ammo_filename)

			var/datum/ammo/current_ammo = GLOB.ammo_list[generating_mag.default_ammo]

			ammo += include_template("Autowiki/AmmoMagazine", list(
				"icon" = escape_value(ammo_filename),
				"name" = escape_value(generating_mag.name),
				"capacity" = escape_value(generating_mag.max_rounds),
				"damage" = escape_value(current_ammo.damage),
				"max_range" = escape_value(current_ammo.max_range),
				"fall_off" = escape_value(current_ammo.damage_falloff),
				"penetration" = escape_value(current_ammo.penetration),
				"punch" = escape_value(current_ammo.pen_armor_punch),
			))

			generating_gun.current_mag = generating_mag

			var/list/gun_ammo_data = generating_gun.ui_data()
			var/list/armor_data = list()

			var/iterator = 1
			for(var/header in gun_ammo_data["damage_armor_profile_headers"])
				var/damage = gun_ammo_data["damage_armor_profile_marine"][iterator]
				armor_data["armor-[header]"] = damage
				iterator++

			var/list/damage = list("ammo_name" = escape_value(generating_mag.name))
			damage += armor_data

			damage_table += include_template("Autowiki/DamageVersusArmorRow", damage)

			qdel(generating_mag)

		gun_data["ammo_types"] = ammo
		gun_data["damage_table"] = damage_table

		var/list/attachments_by_slot = list()
		for(var/obj/item/attachable/attachment_typepath as anything in generating_gun.attachable_allowed)
			if(isnull(initial(attachment_typepath.icon_state)))
				continue // Skip attachments with no icon_state (e.g. base types)
			LAZYADD(attachments_by_slot[capitalize(initial(attachment_typepath.slot))], attachment_typepath)

		var/attachments = ""
		for(var/slot in attachments_by_slot)
			var/list/attachments_in_slot = ""

			for(var/attachment_typepath in attachments_by_slot[slot])
				var/obj/item/attachable/generating_attachment = new attachment_typepath()

				var/attachment_filename = SANITIZE_FILENAME(escape_value(format_text(generating_attachment.name)))

				if(!fexists("data/autowiki_files/[attachment_filename].png"))
					upload_icon(getFlatIcon(generating_attachment, no_anim = TRUE), attachment_filename)

				attachments_in_slot += include_template("Autowiki/AvailableAttachment", list(
					"icon" = escape_value(attachment_filename),
					"name" = escape_value(generating_attachment.name),
				))

				qdel(generating_attachment)

			attachments += include_template("Autowiki/AttachmentsBySlot", list(
				"slot" = escape_value(slot),
				"attachments" = attachments_in_slot,
			))
		gun_data["attachments"] = attachments

		var/icon/generated_icon = getFlatIcon(generating_gun, no_anim = TRUE)
		if(generated_icon)
			upload_icon(generated_icon, filename)
			gun_data["icon"] = filename

		output += include_template("Autowiki/Gun", gun_data)

		qdel(generating_gun)

	return output

/datum/autowiki/guns/proc/wiki_sanitize_assoc(list/sanitizing_list)
	var/list/sanitized = list()

	for(var/key in sanitizing_list)
		var/value = sanitizing_list[key]

		sanitized[escape_value(key)] = escape_value(value)

	return sanitized
