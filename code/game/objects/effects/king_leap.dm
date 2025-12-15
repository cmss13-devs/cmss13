//-----------------------------------------
//KING LEAP
//-----------------------------------------

#define LEAP_HEIGHT 210 //how high up leaps go, in pixels

/obj/effect/king_leap
	icon = 'icons/mob/xenos/castes/tier_4/king.dmi'
	icon_state = "Normal King Charging"
	layer = 4.7
	plane = -4
	pixel_x = -32
	var/duration = 10

/obj/effect/king_leap/Initialize(mapload, negative, dir)
	. = ..()
	setDir(dir)
	INVOKE_ASYNC(src, PROC_REF(flight), negative)
	AddElement(/datum/element/temporary, duration)

/obj/effect/king_leap/proc/flight(negative)
	if(negative)
		animate(src, pixel_x = -LEAP_HEIGHT*0.1, pixel_z = LEAP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	else
		animate(src, pixel_x = LEAP_HEIGHT*0.1, pixel_z = LEAP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	sleep(0.3 SECONDS)
	icon_state = "Normal King Charging"
	if(negative)
		animate(src, pixel_x = -LEAP_HEIGHT, pixel_z = LEAP_HEIGHT, time = 7)
	else
		animate(src, pixel_x = LEAP_HEIGHT, pixel_z = LEAP_HEIGHT, time = 7)

/obj/effect/king_leap/end
	pixel_x = LEAP_HEIGHT
	pixel_z = LEAP_HEIGHT
	duration = 10

/obj/effect/king_leap/end/flight(negative)
	if(negative)
		pixel_x = -LEAP_HEIGHT
		animate(src, pixel_x = -16, pixel_z = 0, time = 5)
	else
		animate(src, pixel_x = -16, pixel_z = 0, time = 5)

/obj/effect/xenomorph/xeno_telegraph/king_attack_template
	icon = 'icons/effects/96x96.dmi'
	icon_state = "landing2"
	layer = BELOW_MOB_LAYER

/obj/effect/xenomorph/xeno_telegraph/king_attack_template/yellow
	icon_state = "xenolandingyellow"
