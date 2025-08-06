/obj/item/paper/prefab/carbon/wey_yu/reset_key_instructions
	document_title = "Инструкция по использованию ключа-перезапуска \"R-key M22\""
	document_category = PAPER_CATEGORY_WEYYU_HC
	doc_datum_type = /datum/prefab_document/wey_yu/reset_key_instructions

/obj/item/paper/prefab/carbon/wey_yu/reset_key_instructions/Initialize(mapload, ...)
	. = ..()
	icon_state = "paper_wy_words"

/obj/structure/safe/cl_office/Initialize()
	. = ..()
	new /obj/item/device/defibrillator/synthetic/noskill/wy_special(src)
	new /obj/item/paper/prefab/carbon/wey_yu/reset_key_instructions(src)
