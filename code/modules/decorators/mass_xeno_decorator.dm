/datum/decorator/manual/mass_xeno_decorator
	var/icon/icon_48x48
	var/icon/icon_64x64
	var/icon/icon_hugger
	var/icon/icon_larva
	var/icon/icon_ovipositor

/datum/decorator/manual/mass_xeno_decorator/get_decor_types()
	return typesof(/mob/living/carbon/Xenomorph) + typesof(/obj/item/clothing/mask/facehugger)

/datum/decorator/manual/mass_xeno_decorator/decorate(var/atom/object)
	var/obj/item/clothing/mask/facehugger/hugger = object
	var/mob/living/carbon/Xenomorph/xeno = object
	var/mob/living/carbon/Xenomorph/Larva/larva = object
	var/mob/living/carbon/Xenomorph/Queen/queen = object

	if(istype(queen))
		if(icon_64x64)
			queen.icon = icon_64x64
		if(icon_ovipositor)
			queen.icon = icon_ovipositor
		return

	if(istype(larva) && icon_larva)
		larva.icon = icon_larva
		return

	if(istype(xeno))
		if(xeno.icon_size == 48 && icon_48x48)
			xeno.icon = icon_48x48
		if(xeno.icon_size == 64 && icon_64x64)
			xeno.icon = icon_64x64
		return

	if(istype(hugger) && icon_hugger)
		hugger.icon = icon_hugger
