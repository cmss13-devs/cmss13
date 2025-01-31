//prop items
/obj/item/oldresearch
	name = "Alien Organ"
	desc = "Looking at it makes you want to vomit"
	icon = 'icons/obj/items/Marine_Research.dmi'
	icon_state = "biomass"
	black_market_value = 50
	//For all of them for now, until we have specific organs/more techs

/obj/item/oldresearch/Resin
	name = "Alien Resin"
	desc = "A piece of alien Resin"
	icon_state = "biomass"


/obj/item/oldresearch/Chitin
	name = "Chunk of Chitin"
	desc = "A chunk of alien Chitin"
	icon_state = "chitin-chunk"


/obj/item/oldresearch/Blood
	name = "Blood Vial"
	desc = "A sample of alien Blood"
	icon_state = "blood-vial"

//prop items end

//previously file holding left over stuff that never got finished from 8 years ago, it was boring though, so we change that.
/obj/item/research_upgrades
	name = "Research upgrade"
	desc = "Somehow you got this, you shouldnt be able to, consider yourself special."
	icon = 'icons/obj/items/disk.dmi'
	w_class = SIZE_TINY
	icon_state = "datadisk1" // doesnt HAVE to be a disk!
	ground_offset_x = 8
	ground_offset_y = 8
	///technology stored on this disk, goes through one to whatever levels of upgrades there are.
	var/value

/obj/item/research_upgrades/autodoc
	name = "Research Upgrade (AutoDoc)"
	value = RESEARCH_UPGRADE_TIER_1


/obj/item/research_upgrades/autodoc/Initialize(mapload, value)
	. = ..()
	src.value = value
	desc = "Research upgrade for an AutoDoc. The technology on this disk is used [get_upgrade_text()]. Insert it in an AutoDoc to use it."

/obj/item/research_upgrades/autodoc/proc/get_upgrade_text()
	switch(value)
		if(RESEARCH_UPGRADE_TIER_1)
			return "for stitching up internal bleedings"
		if(RESEARCH_UPGRADE_TIER_2)
			return "for fixing broken bones"
		if(RESEARCH_UPGRADE_TIER_3)
			return "for treating internal organ damage"
		if(RESEARCH_UPGRADE_TIER_4)
			return "for extracting unknown parasites"

/obj/item/research_upgrades/sleeper
	name = "Research Upgrade (Sleeper)"
	desc = "Research upgrade for a sleeper system. The technology on this disk is used on a sleeper to allow a wider spectrum of chemicals to be administered."

/obj/item/research_upgrades/grinderspeed
	name = "Research Upgrade (Grinder)"
	desc = "Research upgrade for Reagent grinder, technology on this disk makes storing and grinding procedures more effective, increasing both speed and product capacity of the grinder."

/obj/item/research_upgrades/autoharvest
	name = "Research Upgrade (Botany)"
	desc = "Research upgrade for a hydroponics system. The technology on this disk is used on a hydroponics tray to automatically shake the plant once the product is ready to harvest."

/obj/item/research_upgrades/reroll
	name = "Research Market (Reroll)"
	desc = "Research disk containing all the bits of data the analyzer could salvage, insert this into a research computer in order to sell the data and immediately reroll contracts."
