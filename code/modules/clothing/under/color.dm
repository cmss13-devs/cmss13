
/obj/item/clothing/under/color
	flags_jumpsuit = FALSE
	icon = 'icons/obj/items/clothing/uniforms/jumpsuits.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/jumpsuits.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/uniforms_righthand.dmi',
	)

/obj/item/clothing/under/color/black
	name = "black jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	worn_state = "black"

/obj/item/clothing/under/color/blue
	name = "blue jumpsuit"
	icon_state = "blue"
	item_state = "b_suit"
	worn_state = "blue"

/obj/item/clothing/under/color/green
	name = "green jumpsuit"
	icon_state = "green"
	item_state = "g_suit"
	worn_state = "green"

/obj/item/clothing/under/color/grey
	name = "grey jumpsuit"
	icon_state = "grey"
	item_state = "gy_suit"
	worn_state = "grey"

/obj/item/clothing/under/color/orange
	name = "orange jumpsuit"
	desc = "It's standardised prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position."
	icon_state = "orange"
	item_state = "o_suit"
	worn_state = "orange"
	has_sensor = UNIFORM_FORCED_SENSORS
	sensor_mode = SENSOR_MODE_LOCATION

/obj/item/clothing/under/color/white
	name = "white jumpsuit"
	icon_state = "white"
	item_state = "w_suit"
	worn_state = "white"

/obj/item/clothing/under/color/yellow
	name = "yellow jumpsuit"
	icon_state = "yellow"
	item_state = "y_suit"
	worn_state = "yellow"

/obj/item/clothing/under/color/lightbrown
	name = "lightbrown jumpsuit"
	desc = "lightbrown"
	icon_state = "lightbrown"
	worn_state = "lightbrown"

/obj/item/clothing/under/color/brown
	name = "brown jumpsuit"
	desc = "brown"
	icon_state = "brown"
	worn_state = "brown"

/obj/item/clothing/under/color/lightred
	name = "lightred jumpsuit"
	desc = "lightred"
	icon_state = "lightred"
	worn_state = "lightred"

/obj/item/clothing/under/color/darkred
	name = "darkred jumpsuit"
	desc = "darkred"
	icon_state = "darkred"
	worn_state = "darkred"

/obj/item/clothing/under/color/white/alt
	name = "white jumpsuit"
	icon_state = "white_alt"
	item_state = "w_suit"
	worn_state = "white_alt"

/obj/item/clothing/under/color/escaped_prisoner_colony
	name = "battle-worn prisoner jumpsuit"
	desc = "A torn prison jumpsuit caked with dried blood and grime. Makeshift bandages wrap around the left arm and leg—soaked and dirty, barely holding together. The fabric is ripped at the seams and scorched in places, but the suit sensors still blink stubbornly, stuck on 'Fully On.'"
	icon_state = "escaped_prisoner"
	item_state = "escaped_prisoner"
	worn_state = "escaped_prisoner"
	has_sensor = UNIFORM_FORCED_SENSORS
	sensor_mode = SENSOR_MODE_LOCATION
