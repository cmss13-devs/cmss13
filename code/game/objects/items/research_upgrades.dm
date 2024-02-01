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
	///technology stored on this disk, goes through one to whatever levels of upgrades there are. 0 Excludes it from buying menu.
	var/value = ITEM_EXCLUDE_BUY
	///price of the upgrade, if a signle disk could mean many upgrades, use list in sync with upgrades to set its prices
	var/list/price = list(1000)

/obj/item/research_upgrades/proc/get_upgrade_desc(val, short = TRUE) //needed for those special cases like one below. only needed in cases where single disk can be many upgrades, otherwise use desc and name.
	return
/obj/item/research_upgrades/autodoc
	name = "Research Upgrade (AutoDoc)"
	desc = "Research upgrade for AutoDoc, Technology on this disk is used "
	value = UPGRADE_TIER_4
	price = list(3000, 5000, 8000, 10000)
	//starting at internal bleeding repair, 2 for bone repair, 3 for organ repair/etc, and 4 for larva removal. They are not exclusive, that means if you get level 4, you still dont have level 2 and 3 & 1.
	//set to final upgrade to show the amount of upgrades

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

/obj/item/research_upgrades/autodoc/get_upgrade_desc(val, short = TRUE)
	if(short)
		switch(val)
			if(UPGRADE_TIER_1)
				. += "(Internal Bleedings)"
			if(UPGRADE_TIER_2)
				. += "(Broken Bones)"
			if(UPGRADE_TIER_3)
				. += "(Organ Treating)"
			if(UPGRADE_TIER_4)
				. += "(Unknown Parasites)"
	else
		switch(val)
			if(UPGRADE_TIER_1)
				. += "for stopping internal bleedings."
			if(UPGRADE_TIER_2)
				. += "for fixating and mending broken bones."
			if (UPGRADE_TIER_3)
				. += "for treating damaged organs"
			if (UPGRADE_TIER_4)
				. += "for extracting unknown parasites"
	return

/obj/item/research_upgrades/sleeper
	name = "Research Upgrade (Sleeper)"
	desc = "Research upgrade for Sleeper system, Technology on this disk is used on a sleeper to allow wider spectrum of chemicals to be administered"
	value = UPGRADE_TIER_1
	price = list(4000)

/obj/item/research_upgrades/sleeper/get_upgrade_desc(val, short = TRUE)
	return

/obj/item/research_upgrades/credits
	name =	"Research Market (Credits)"
	desc =	"Research points disk for chemical synthesis, insert this into research computer in order to sell the data and acquire two points" //need to balance this out somehow. either nerf passive income or remove grants from groundside
	value = UPGRADE_TIER_1
	price = list(1000)

/obj/item/research_upgrades/property
	name = "Research Market (Propety)"
	desc = "Research points disk for chemical synthesis, insert this into research computer in order to sell the data and acquire one random chemical property of your choice."
	value = UPGRADE_TIER_3
	price = list(2000, 4000, 8000)

/obj/item/research_upgrades/property/get_upgrade_desc(val, short = TRUE)
	switch(val)
		if(UPGRADE_TIER_1)
			. += "(Uncommon)"
		if(UPGRADE_TIER_2)
			. += "(Rare)"
		if(UPGRADE_TIER_3)
			. += "(Legendary)"
	return
/obj/item/research_upgrades/packet
	name = "Research Packet"
	desc = " A plastic sealed opaque packet containing whatever research marvel the nerds upstairs were brewing, you shouldnt be able to see this!"
	value = ITEM_EXCLUDE_BUY
	//icon = ***
	//icon_state = ***
	price = list(1000)
	///What packet contains
	var/list/could_contain = null
	///is the packet open
	var/is_opened = FALSE
	///How many times to spawn the could_contain item(s
	var/amount = 1
	///How does a packet use could_contain list, 3 types of behavior - _EXACT gives user exactly what is in could_contain, _RANDOM gives user a thing from could contain on random basis, and _VALUE makes it follow value var(spawns second thing in the list if value is two)
	var/behavior = PACKET_BEHAVIOR_EXACT

/obj/item/research_upgrades/packet/attack_self(mob/user)
	. = ..()
	playsound(src, "rip", 15, TRUE, 6)
	if(isnull(could_contain) && !is_opened)
		to_chat(user, SPAN_WARNING("The packet was empty, so you throw it out."))
		qdel(src)
		return
	if(!is_opened)
		for(var/iteration in 1 to amount)
			switch(behavior)
				if(PACKET_BEHAVIOR_RANDOM)
					var/thing_to_spawn = pick(could_contain)
					var/obj/item/spawn_item = new thing_to_spawn
					spawn_item.forceMove(get_turf(user))
				if(PACKET_BEHAVIOR_EXACT)
					for(var/newthing in could_contain)
						var/obj/item/spawn_item = new newthing
						spawn_item.forceMove(get_turf(user))
				if(PACKET_BEHAVIOR_VALUE)
					var/thing_to_spawn = could_contain[value]
					var/obj/item/spawn_item = new thing_to_spawn
					spawn_item.forceMove(get_turf(user))
		is_opened = TRUE
		//icon_state = x
		desc += "This one seems to be already opened"
	return


/obj/item/research_upgrades/packet/attachment
	name = "Research Packet (Attachment)"
	desc = "An opaque sealed packet containing one random experimental gun attachment"
	price = list(2000)
	value = UPGRADE_TIER_1
	could_contain = list()//need to add actual attachments(sprites ;-;) too, so many shit todo holy shit.
	//also, no idea what kinda of attachments were looking at in future

/obj/item/research_upgrades/packet/armor_buff
	name = "Research Packet (Armor)"
	desc = "An opaque sealed packet containing one armor reinforcment compatible with M3 Marine armor."
	price = list(2000, 4000, 8000)
	value = UPGRADE_TIER_3
	behavior = PACKET_BEHAVIOR_VALUE
	could_contain = list() //omygod







