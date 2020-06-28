/obj/item/clothing/suit/storage/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_open"
	item_state = "labcoat" //Is this even used for anything?
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	allowed = list(
		/obj/item/device/analyzer,
		/obj/item/stack/medical,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/syringe,
		/obj/item/reagent_container/hypospray,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/paper,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

	verb/toggle()
		set name = "Toggle Labcoat Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.is_mob_restrained())
			return 0

		//Why???
		switch(icon_state)
			if("labcoat_open")
				src.icon_state = "labcoat"
				to_chat(usr, "You button up the labcoat.")
			if("labcoat")
				src.icon_state = "labcoat_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("red_labcoat_open")
				src.icon_state = "red_labcoat"
				to_chat(usr, "You button up the labcoat.")
			if("red_labcoat")
				src.icon_state = "red_labcoat_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("blue_labcoat_open")
				src.icon_state = "blue_labcoat"
				to_chat(usr, "You button up the labcoat.")
			if("blue_labcoat")
				src.icon_state = "blue_labcoat_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("purple_labcoat_open")
				src.icon_state = "purple_labcoat"
				to_chat(usr, "You button up the labcoat.")
			if("purple_labcoat")
				src.icon_state = "purple_labcoat_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("green_labcoat_open")
				src.icon_state = "green_labcoat"
				to_chat(usr, "You button up the labcoat.")
			if("green_labcoat")
				src.icon_state = "green_labcoat_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("orange_labcoat_open")
				src.icon_state = "orange_labcoat"
				to_chat(usr, "You button up the labcoat.")
			if("orange_labcoat")
				src.icon_state = "orange_labcoat_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("labcoat_cmo_open")
				src.icon_state = "labcoat_cmo"
				to_chat(usr, "You button up the labcoat.")
			if("labcoat_cmo")
				src.icon_state = "labcoat_cmo_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("labcoat_gen_open")
				src.icon_state = "labcoat_gen"
				to_chat(usr, "You button up the labcoat.")
			if("labcoat_gen")
				src.icon_state = "labcoat_gen_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("labcoat_chem_open")
				src.icon_state = "labcoat_chem"
				to_chat(usr, "You button up the labcoat.")
			if("labcoat_chem")
				src.icon_state = "labcoat_chem_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("labcoat_vir_open")
				src.icon_state = "labcoat_vir"
				to_chat(usr, "You button up the labcoat.")
			if("labcoat_vir")
				src.icon_state = "labcoat_vir_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("labcoat_tox_open")
				src.icon_state = "labcoat_tox"
				to_chat(usr, "You button up the labcoat.")
			if("labcoat_tox")
				src.icon_state = "labcoat_tox_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("labgreen_open")
				src.icon_state = "labgreen"
				to_chat(usr, "You button up the labcoat.")
			if("labgreen")
				src.icon_state = "labgreen_open"
				to_chat(usr, "You unbutton the labcoat.")
			if("sciencecoat_open")
				src.icon_state = "sciencecoat"
				to_chat(usr, "You button up the labcoat.")
			if("sciencecoat")
				src.icon_state = "sciencecoat_open"
				to_chat(usr, "You unbutton the labcoat.")
			else
				to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how silly you are.")
				return
		update_clothing_icon()	//so our overlays update

/obj/item/clothing/suit/storage/labcoat/red
	name = "red labcoat"
	desc = "A suit that protects against minor chemical spills. This one is red."
	icon_state = "red_labcoat_open"
	item_state = "red_labcoat"

/obj/item/clothing/suit/storage/labcoat/blue
	name = "blue labcoat"
	desc = "A suit that protects against minor chemical spills. This one is blue."
	icon_state = "blue_labcoat_open"
	item_state = "blue_labcoat"

/obj/item/clothing/suit/storage/labcoat/purple
	name = "purple labcoat"
	desc = "A suit that protects against minor chemical spills. This one is purple."
	icon_state = "purple_labcoat_open"
	item_state = "purple_labcoat"

/obj/item/clothing/suit/storage/labcoat/orange
	name = "orange labcoat"
	desc = "A suit that protects against minor chemical spills. This one is orange."
	icon_state = "orange_labcoat_open"
	item_state = "orange_labcoat"

/obj/item/clothing/suit/storage/labcoat/green
	name = "green labcoat"
	desc = "A suit that protects against minor chemical spills. This one is green."
	icon_state = "green_labcoat_open"
	item_state = "green_labcoat"

/obj/item/clothing/suit/storage/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo_open"
	item_state = "labcoat_cmo"

/obj/item/clothing/suit/storage/labcoat/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen_open"
	item_state = "labgreen"

/obj/item/clothing/suit/storage/labcoat/genetics
	name = "Geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen_open"

/obj/item/clothing/suit/storage/labcoat/chemist
	name = "Chemist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem_open"

/obj/item/clothing/suit/storage/labcoat/virologist
	name = "Virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir_open"
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/suit/storage/labcoat/science
	name = "Scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox_open"

/obj/item/clothing/suit/storage/labcoat/officer
	//name = "Medical officer's labcoat"
	icon_state = "labcoatg"
	item_state = "labcoatg"

/obj/item/clothing/suit/storage/labcoat/researcher
	name = "researcher's labcoat"
	desc = "A high quality labcoat, seemingly worn by scholars and researchers alike. It has a distinct leathery feel to it, and goads you towards adventure."
	icon_state = "sciencecoat_open"
	item_state = "sciencecoat_open"






/obj/item/clothing/suit/storage/snow_suit
	name = "snow suit"
	desc = "A standard snow suit. It can protect the wearer from extreme cold."
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_state = "snowsuit_alpha"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	blood_overlay_type = "armor"
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/snow_suit/doctor
	name = "doctor's snow suit"
	icon_state = "snowsuit_doctor"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/suit/storage/snow_suit/engineer
	name = "engineer's snow suit"
	icon_state = "snowsuit_engineer"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
