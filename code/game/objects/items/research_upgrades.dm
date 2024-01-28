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
	var/list/price = list(1000) // initial price, multiplied by * price_increase at final checkout if there are better version

/obj/item/research_upgrades/proc/get_upgrade_desc(val, short = TRUE) //needed for those special cases like one below. only needed in cases where single disk can be many upgrades, otherwise use desc and name.
	return "ERROR"

/obj/item/research_upgrades/autodoc
	name = "Research upgrade "
	desc = "Research upgrade for AutoDoc, Technology on this disk is used "
	value = AUTODOC_UPGRADE_LARVA
	price = list(3000, 5000, 8000, 10000)
	//starting at internal bleeding repair, 2 for bone repair, 3 for organ repair/etc, and 4 for larva removal. They are not exclusive, that means if you get level 4, you still dont have level 2 and 3 & 1.
	//set to final upgrade to show the amount of upgrades

/obj/item/research_upgrades/autodoc/get_examine_text(mob/user)
	. = ..()
	switch(value)

		if(AUTODOC_UPGRADE_IB)
			. += "for stopping internal bleedings."
		if(AUTODOC_UPGRADE_BONEBREAK)
			. += "for fixating and mending broken bones."
		if(AUTODOC_UPGRADE_ORGAN)
			. += "for treating damaged organs."
		if(AUTODOC_UPGRADE_LARVA)
			. += "for extracting unknown parasites."

/obj/item/research_upgrades/autodoc/get_upgrade_desc(val, short = TRUE)
	if(short)
		switch(val)
			if(AUTODOC_UPGRADE_IB)
				. += "(Internal Bleedings)"
			if(AUTODOC_UPGRADE_BONEBREAK)
				. += "(Broken Bones)"
			if(AUTODOC_UPGRADE_ORGAN)
				. += "(Organ Treating)"
			if(AUTODOC_UPGRADE_LARVA)
				. += "(Unknown Parasites)"
	else
		switch(val)
			if(AUTODOC_UPGRADE_IB)
				. += "for stopping internal bleedings."
			if(AUTODOC_UPGRADE_BONEBREAK)
				. += "for fixating and mending broken bones."
			if (AUTODOC_UPGRADE_ORGAN)
				. += "for treating damaged organs"
			if (AUTODOC_UPGRADE_LARVA)
				. += "for extracting unknown parasites"
	return

/obj/item/research_upgrades/sleeper
	name = "Research upgrade (Sleeper)"
	desc = "Research upgrade for Sleeper system, Technology on this disk is used on a sleeper to allow wider spectrum of chemicals to be administered "
	value = 1
	price = list(4000)

/obj/item/research_upgrades/sleeper/get_upgrade_desc(val, short = TRUE)
	return





