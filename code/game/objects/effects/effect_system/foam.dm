// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall

//foam effect

#define FOAM_NOT_METAL 0 // 0=foam, 1=metalfoam, 2=ironfoam
#define FOAM_METAL_TYPE_ALUMINIUM 1
#define FOAM_METAL_TYPE_IRON 2

/obj/effect/particle_effect/foam
	name = "foam"
	icon_state = "foam"
	opacity = FALSE
	anchored = TRUE
	density = FALSE
	layer = BELOW_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/amount = 3
	var/expand = 1
	animate_movement = 0
	var/metal = FOAM_NOT_METAL
	var/time_to_solidify = 4 SECONDS


/obj/effect/particle_effect/foam/Initialize(mapload, ismetal=0)
	. = ..()
	icon_state = "[ismetal ? "m":""]foam"
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 25, 1, 5)
	addtimer(CALLBACK(src, PROC_REF(foam_react)), 3 + metal*3)
	addtimer(CALLBACK(src, PROC_REF(foam_metal_final_react)), time_to_solidify)

/obj/effect/particle_effect/foam/proc/foam_react()
	process()
	checkReagents()

/obj/effect/particle_effect/foam/proc/foam_metal_final_react()
	var/foamed_metal_type
	switch(metal)
		if(FOAM_METAL_TYPE_ALUMINIUM)
			foamed_metal_type = /obj/structure/foamed_metal
		if(FOAM_METAL_TYPE_IRON)
			foamed_metal_type = /obj/structure/foamed_metal/iron
	if(foamed_metal_type)
		new foamed_metal_type(src.loc)

	flick("[icon_state]-disolve", src)
	QDEL_IN(src, 5)

// transfer any reagents to the floor
/obj/effect/particle_effect/foam/proc/checkReagents()
	if(!metal && reagents)
		for(var/atom/A in src.loc.contents)
			if(A == src)
				continue
			reagents.reaction(A, 1, 1)

/obj/effect/particle_effect/foam/process()
	if(--amount < 0)
		return


	for(var/direction in GLOB.cardinals)


		var/turf/T = get_step(src,direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/particle_effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T, metal)
		F.amount = amount
		if(!metal)
			F.create_reagents(10)
			if (reagents)
				for(var/datum/reagent/R in reagents.reagent_list)
					F.reagents.add_reagent(R.id, 1, safety = 1) //added safety check since reagents in the foam have already had a chance to react

// foam disolves when heated
// except metal foams
/obj/effect/particle_effect/foam/fire_act(exposed_temperature, exposed_volume)
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("[icon_state]-disolve", src)

		QDEL_IN(src, 5)


/obj/effect/particle_effect/foam/Crossed(atom/movable/AM)
	if(metal)
		return
	if (iscarbon(AM))
		var/mob/living/carbon/C = AM
		C.slip("foam", 5, 2)


/obj/effect/particle_effect/foam/metal
	name = "metal foam"
	metal = 1

//datum effect system

/datum/effect_system/foam_spread
	var/amount = 5 // the size of the foam spread.
	var/list/carried_reagents // the IDs of reagents present when the foam was mixed
	var/metal = FOAM_NOT_METAL

/datum/effect_system/foam_spread/set_up(amt=5, loca, datum/reagents/carry = null, metal_foam = FOAM_NOT_METAL)
	amount = round(sqrt(amt / 3), 1)
	if(istype(loca, /turf))
		location = loca
	else
		location = get_turf(loca)

	carried_reagents = list()
	metal = metal_foam


		// bit of a hack here. Foam carries along any reagent also present in the glass it is mixed
		// with (defaults to water if none is present). Rather than actually transfer the reagents,
		// this makes a list of the reagent ids and spawns 1 unit of that reagent when the foam disolves.


	if(carry && !metal)
		for(var/datum/reagent/R in carry.reagent_list)
			carried_reagents += R.id

/datum/effect_system/foam_spread/start()
	set waitfor = 0
	var/obj/effect/particle_effect/foam/F = locate() in location
	if(F)
		F.amount += amount
		return

	F = new(src.location, metal)
	F.amount = amount

	if(!metal) // don't carry other chemicals if a metal foam
		F.create_reagents(10)

		if(carried_reagents)
			for(var/id in carried_reagents)
				F.reagents.add_reagent(id, 1, null, 1) //makes a safety call because all reagents should have already reacted anyway
		else
			F.reagents.add_reagent("water", 1, safety = 1)




// wall formed by metal foams
// dense and opaque, but easy to break

#define FOAMED_METAL_FIRE_ACT_DMG 50
#define FOAMED_METAL_XENO_SLASH 1.75
#define FOAMED_METAL_ITEM_MELEE 2
#define FOAMED_METAL_BULLET_DMG 2
#define FOAMED_METAL_EXPLOSION_DMG 1

/obj/structure/foamed_metal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = TRUE
	opacity = TRUE // changed in New()
	anchored = TRUE
	name = "foamed metal"
	desc = "A lightweight foamed metal wall."
	health = 45

/obj/structure/foamed_metal/iron
	icon_state = "ironfoam"
	health = 70
	name = "foamed iron"
	desc = "A slightly stronger lightweight foamed iron wall."

/obj/structure/foamed_metal/proc/take_damage(damage)
	health -= damage
	playsound(src,'sound/weapons/Genhit.ogg', 25, 1)
	if(health <= 0)
		visible_message(SPAN_WARNING("[src] crumbles into pieces!"))
		playsound(src, 'sound/effects/meteorimpact.ogg', 25, 1)
		qdel(src)

/obj/structure/foamed_metal/ex_act(severity)
	take_damage(severity * FOAMED_METAL_EXPLOSION_DMG)

/obj/structure/foamed_metal/bullet_act(obj/projectile/P)
	if(P.ammo.damage_type == HALLOSS || P.ammo.damage_type == TOX || P.ammo.damage_type == CLONE || P.damage == 0)
		return

	bullet_ping(P)
	take_damage(P.ammo.damage * FOAMED_METAL_BULLET_DMG)


/obj/structure/foamed_metal/fire_act()
	take_damage(FOAMED_METAL_FIRE_ACT_DMG)

/obj/structure/foamed_metal/attackby(obj/item/I, mob/user)
	if(I.force)
		to_chat(user, SPAN_NOTICE("You [I.sharp ? "hack" : "smash" ] off a chunk of the foamed metal with \the [I]."))
		if(I.sharp)
			take_damage(I.force * I.sharp * FOAMED_METAL_ITEM_MELEE) //human advantage, sharper items do more damage
		else
			take_damage(I.force * FOAMED_METAL_ITEM_MELEE) //blunt items can damage it still
		return (ATTACKBY_HINT_NO_AFTERATTACK|ATTACKBY_HINT_UPDATE_NEXT_MOVE)

	return FALSE

/obj/structure/foamed_metal/attack_alien(mob/living/carbon/xenomorph/X, dam_bonus)
	var/damage = ((floor((X.melee_damage_lower+X.melee_damage_upper)/2)) + dam_bonus)

	//Frenzy bonus
	if(X.frenzy_aura > 0)
		damage += (X.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)

	X.animation_attack_on(src)

	X.visible_message(SPAN_DANGER("\The [X] slashes [src]!"),
	SPAN_DANGER("You slash [src]!"))

	take_damage(damage * FOAMED_METAL_XENO_SLASH)

	return XENO_ATTACK_ACTION

#undef FOAMED_METAL_FIRE_ACT_DMG
#undef FOAMED_METAL_XENO_SLASH
#undef FOAMED_METAL_ITEM_MELEE
#undef FOAMED_METAL_BULLET_DMG
#undef FOAMED_METAL_EXPLOSION_DMG
