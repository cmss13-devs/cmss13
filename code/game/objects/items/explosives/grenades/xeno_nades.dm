// Praetorian Neurotoxin grenade.
/obj/item/explosive/grenade/xeno_neuro_grenade
	name = "neurotoxin ball"
	desc = "A small, pulsating ball of gas."
	icon_state = "neuro_nade"
	det_time = 30
	item_state = "neuro_nade"
	var/datum/effect_system/smoke_spread/xeno_extinguish_fire/smoke

	rebounds = FALSE

/obj/item/explosive/grenade/xeno_neuro_grenade/New()
		..()
		smoke = new /datum/effect_system/smoke_spread/xeno_extinguish_fire
		smoke.attach(src)

/obj/item/explosive/grenade/xeno_neuro_grenade/prime()
		playsound(loc, 'sound/effects/smoke.ogg', 25, 1, 4)
		smoke.set_up(2, 0, loc, null, 6, 10)
		smoke.start()
		smoke = null
		qdel(src)
