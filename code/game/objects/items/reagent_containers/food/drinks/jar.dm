

///jar

/obj/item/reagent_container/food/drinks/jar
	name = "empty jar"
	desc = "A jar. You're not sure what it's supposed to hold."
	icon_state = "jar"
	item_state = "beaker"
	center_of_mass = "x=15;y=8"

/obj/item/reagent_container/food/drinks/jar/on_reagent_change()
	if(length(reagents.reagent_list) > 0)
		icon_state ="jar_what"
		name = "jar of something"
		desc = "You can't really tell what this is."
	else
		icon_state = "jar"
		name = "empty jar"
		desc = "A jar. You're not sure what it's supposed to hold."
