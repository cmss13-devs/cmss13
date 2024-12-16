//-----------------------------------------
//HEAVY IMPACT
//-----------------------------------------

/obj/effect/heavy_impact
	icon = 'icons/effects/heavyimpact.dmi'
	icon_state = "heavyimpact"
	var/duration = 1.3 SECONDS

/obj/effect/heavy_impact/Initialize(mapload)
	. = ..()
	flick("heavyimpact", src)
	AddElement(/datum/element/temporary, duration)
