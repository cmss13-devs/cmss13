//prop items
/obj/item/XenoBio
	name = "An unidentified Alien Organ"
	desc = "Looking at it makes you want to vomit"
	icon = 'icons/obj/items/Marine_Research.dmi'
	icon_state = "biomass"
	black_market_value = 50
	//For all of them for now, until we have specific organs/more techs

/obj/item/XenoBio/Resin
	name = "Alien Resin"
	desc = "A piece of alien Resin"
	icon_state = "biomass"


/obj/item/XenoBio/Chitin
	name = "Alien Chitin"
	desc = "A chunk of alien Chitin"
	icon_state = "chitin-chunk"


/obj/item/XenoBio/Blood
	name = "Alien Blood"
	desc = "A sample of alien Blood"
	icon_state = "blood-vial"

//prop items end



//previously file holding left over stuff that never got finished from 8 years ago, it was boring though, so we change that.
/obj/item/research_upgrades
	name = "Research upgrade"
	desc = "Somehow you got this, you shouldnt be able to, consider yourself special."
	icon = 'icons/obj/items/disk.dmi'
	icon_state = "datadisk1"
	var/value = 0 //technology stored on this disk, goes through one to whatever levels of upgrades there are,
	var/price = 1000 // initial price, multiplied by * price_increase at final checkout if there are better version
	var/price_increase

/obj/item/research_upgrades/proc/get_upgrade_desc(val) //we have to differ them SOMEHOW, so we do that, called if there are more versions of upgrades than one, basically a copypaste of examine text
	return "This technology contains unknown data and forever will be..."

/obj/item/research_upgrades/autodoc
	name = "Research upgrade (AutoDoc)"
	desc = "Research upgrade for AutoDoc, insert it in the recepticle located underneath certified AutoDoc Pod"
	value = AUTODOC_UPGRADE_LARVA
	price = 3000
	//starting at internal bleeding repair, 2 for bone repair, 3 for organ repair/etc, and 4 for larva removal. They are not exclusive, that means if you get level 4, you still dont have level 2 and 3 & 1.
	//set to final upgrade to show the amount of upgrades

/obj/item/research_upgrades/autodoc/get_examine_text(mob/user)
	. = ..()
	switch(value)

		if(AUTODOC_UPGRADE_IB)
			. += "Labeling indicates that this disk contains data and statictics for stopping internal bleedings."
		if(AUTODOC_UPGRADE_BONEBREAK)
			. += "Labeling indicates that this disk contains data and statictics for fixating and mending broken bones."
		if(AUTODOC_UPGRADE_ORGAN)
			. += "Labeling indicates that this disk contains data and statictics for treating damaged organs."
		if(AUTODOC_UPGRADE_LARVA)
			. += "Labeling indicates that this disk contains data and statictics for extracting unknown parasites."

/obj/item/research_upgrades/autodoc/get_upgrade_desc(val)
	switch(val)

		if(AUTODOC_UPGRADE_IB)
			. += "Labeling indicates that this disk contains data and statictics for stopping internal bleedings."
		if(AUTODOC_UPGRADE_BONEBREAK)
			. += "Labeling indicates that this disk contains data and statictics for fixating and mending broken bones."
		if(AUTODOC_UPGRADE_ORGAN)
			. += "Labeling indicates that this disk contains data and statictics for treating damaged organs."
		if(AUTODOC_UPGRADE_LARVA)
			. += "Labeling indicates that this disk contains data and statictics for extracting unknown parasites."
	return






