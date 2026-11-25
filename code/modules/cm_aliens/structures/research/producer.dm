/obj/effect/alien/resin/chem_producer
	name = "resin gland"
	icon = 'icons/mob/xenos/fruits.dmi'
	icon_state = null
	desc = "A weird-looking pulsating node that produces chemicals"
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	health = 50
	layer = RESIN_STRUCTURE_LAYER
	plane = FLOOR_PLANE

	// Production stats
	/// Which chem does this produce?
	var/list/producing_chems = list()
	/// How much is produced every XENO_BOTANY_RATE?
	var/production_amt = 5

/obj/effect/alien/resin/chem_producer/Initialize(mapload, mob/builder)
	. = ..()
	// Buffer for about 4 ticks.
	create_reagents(production_amt * length(producing_chems) * 4)
	START_PROCESSING(SSxeno_botany, src)

/obj/effect/alien/resin/chem_producer/process(delta_time)
	var/turf/current_turf = get_turf(src)
	if(!current_turf.weeds)
		return

	var/max_per_reagent = reagents.maximum_volume / length(producing_chems)
	for(var/chem in producing_chems)
		var/reagent_amt = reagents.get_reagent_amount(chem)
		// Conservative, so that reagents don't end up overflowing and having weird floating point values
		// because they all didn't fit into the volume
		if(reagent_amt + production_amt > max_per_reagent)
			continue
		reagents.add_reagent(chem, production_amt, safety = TRUE)


/obj/effect/alien/resin/chem_producer/Destroy(force)
	STOP_PROCESSING(SSxeno_botany, src)
	return ..()

/obj/effect/alien/resin/chem_producer/basic
	name = "basic gland"
	desc = "A weird-looking pulsating node that produces all basic xenobiology reagents, at slower speeds."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "static_costnode"

	producing_chems = list(PLASMA_PURPLE, PLASMA_CATECHOLAMINE, PLASMA_CHITIN, PLASMA_NEUROTOXIN)
	production_amt = 1

/obj/effect/alien/resin/chem_producer/advanced
	name = "advanced gland"
	desc = "A weird-looking pulsating node that produces all advanced xenobiology reagents, at slower speeds."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "static_constructnode"

	producing_chems = list(PLASMA_NUTRIENT, PLASMA_REINFORCED_CHITIN, PLASMA_ADRENALINE, PLASMA_ACIDIC)
	production_amt = 1

/obj/effect/alien/resin/chem_producer/plasma
	name = "plasma gland"
	desc = "A weird-looking pulsating node that produces purple plasma"
	icon_state = "fruit_plasma_immature"

	producing_chems = list(PLASMA_PURPLE)
	production_amt = 10

/obj/effect/alien/resin/chem_producer/nutrient
	name = "nutrient gland"
	desc = "A weird-looking pulsating node that produces nutrient plasma"
	icon_state = "fruit_plasma"

	producing_chems = list(PLASMA_NUTRIENT)
	production_amt = 10

/obj/effect/alien/resin/chem_producer/chitin
	name = "chitin gland"
	desc = "A weird-looking pulsating node that produces chitin"
	icon_state = "fruit_spore_immature"

	producing_chems = list(PLASMA_CHITIN)
	production_amt = 10

/obj/effect/alien/resin/chem_producer/reinforced_chitin
	name = "reinforced chitin gland"
	desc = "A weird-looking pulsating node that produces reinforced chitin plasma"
	icon_state = "fruit_spore"

	producing_chems = list(PLASMA_REINFORCED_CHITIN)
	production_amt = 10

/obj/effect/alien/resin/chem_producer/neurotoxin
	name = "neurotoxin gland"
	desc = "A weird-looking pulsating node that produces neurotoxin plasma"
	icon_state = "fruit_greater_immature"

	producing_chems = list(PLASMA_NEUROTOXIN)
	production_amt = 10

/obj/effect/alien/resin/chem_producer/acid
	name = "acid gland"
	desc = "A weird-looking pulsating node that produces acidic plasma"
	icon_state = "fruit_greater"

	producing_chems = list(PLASMA_ACIDIC)
	production_amt = 10

/obj/effect/alien/resin/chem_producer/catecholamine
	name = "catecholamine gland"
	desc = "A weird-looking pulsating node that produces catecholamine plasma"
	icon_state = "fruit_speed_immature"

	producing_chems = list(PLASMA_CATECHOLAMINE)
	production_amt = 10

/obj/effect/alien/resin/chem_producer/adrenal
	name = "adrenal gland"
	desc = "A weird-looking pulsating node that produces adrenal plasma"
	icon_state = "fruit_speed"

	producing_chems = list(PLASMA_ADRENALINE)
	production_amt = 10

/obj/effect/alien/resin/chem_producer/royal
	name = "royal gland"
	desc = "A weird-looking pulsating node that produces royal plasma"
	icon = 'icons/mob/xenos/structures64x64.dmi'
	icon_state = "collector_gather"
	plane = GAME_PLANE
	pixel_x = -16
	pixel_y = -16

	producing_chems = list(PLASMA_ROYAL)
	production_amt = 5
