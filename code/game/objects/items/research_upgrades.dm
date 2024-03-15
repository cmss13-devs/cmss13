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
//changing to datums
/obj/item/research_upgrades
	name = "Research upgrade"
	desc = "Somehow you got this, you shouldnt be able to, consider yourself special."
	icon = 'icons/obj/items/disk.dmi'
	icon_state = "datadisk1" // doesnt HAVE to be a disk!
	///technology stored on this disk, goes through one to whatever levels of upgrades there are, set it to last upgrade in your line. 0 Excludes it from buying menu.
	///price of the upgrade, if a single disk could mean many upgrades, use list in sync with upgrades to set its prices
	var/value
/obj/item/research_upgrades/autodoc
	name = "Research Upgrade (AutoDoc)"
	desc = "Research upgrade for AutoDoc, Technology on this disk is used "
	value = UPGRADE_TIER_1


/obj/item/research_upgrades/autodoc/get_examine_text(mob/user)
	. = ..()
	switch(value)

		if(UPGRADE_TIER_1)
			. += "for stopping internal bleedings."
		if(UPGRADE_TIER_2)
			. += "for fixating and mending broken bones."
		if(UPGRADE_TIER_3)
			. += "for treating damaged organs."
		if(UPGRADE_TIER_4)
			. += "for extracting unknown parasites."

/obj/item/research_upgrades/sleeper
	name = "Research Upgrade (Sleeper)"
	desc = "Research upgrade for Sleeper system, Technology on this disk is used on a sleeper to allow wider spectrum of chemicals to be administered"


/obj/item/research_upgrades/credits
	name =	"Research Market (Credits)"
	desc =	"Research points disk for chemical synthesis, insert this into research computer in order to sell the data and acquire two points" //need to balance this out somehow. either nerf passive income or remove grants from groundside


/obj/item/research_upgrades/property
	name = "Research Market (Propety)"
	desc = "Research points disk for chemical synthesis, insert this into research computer in order to sell the data and acquire one random chemical property of your choice."

/obj/item/research_upgrades/packet
	name = "Research Packet"
	desc = " A plastic sealed opaque packet containing whatever research marvel the nerds upstairs were brewing, you shouldnt be able to see this!"
	//icon = ***
	//icon_state = ***
	///What packet contains
	var/list/could_contain = null
	///is the packet open
	var/is_opened = FALSE
	///How many times to spawn the could_contain item(s
	var/amount = 1
	///How does a packet use could_contain list, 3 types of behavior - _EXACT gives user exactly what is in could_contain, _RANDOM gives user a thing from could contain on random basis, and _VALUE makes it follow value var(spawns second thing in the list if value is two)
	var/behavior = PACKET_BEHAVIOR_EXACT





