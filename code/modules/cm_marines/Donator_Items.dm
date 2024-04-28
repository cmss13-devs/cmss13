// SS13 DONATOR CUSTOM ITEM STORAGE ZONE OF MAGICAL HAPPINESS APOPHIS - LAST UPDATE - 14JUN2016

//#######################################################\\
//###################### TEMPLATES ######################\\
//#######################################################\\

//HEAD TEMPLATE (for Helmets/Hats/Berets)  ONLY TAKE NAME, DESC, ICON_STATE, AND ITEM_STATE.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/head/helmet/marine/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
	//DON'T GRAB STUFF BETWEEN THIS LINE
	icon = 'icons/obj/items/clothing/hats.dmi'
	icon_override = 'icons/mob/humans/onmob/head_0.dmi'
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE|NO_SNOW_TYPE
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/fluff/verb/toggle_squad_markings()
	set src in usr
	if(!ishuman(usr)) return

	if(usr.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(usr, SPAN_WARNING("Not right now!"))
		return

	to_chat(usr, SPAN_NOTICE("You [flags_marine_helmet & HELMET_SQUAD_OVERLAY? "hide" : "show"] the squad markings."))
	flags_marine_helmet ^= HELMET_SQUAD_OVERLAY
	usr.update_inv_head()

/obj/item/clothing/head/helmet/marine/fluff/verb/toggle_garb_overlay()
	set src in usr
	if(!ishuman(usr)) return

	if(usr.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(usr, SPAN_WARNING("Not right now!"))
		return

	to_chat(usr, SPAN_NOTICE("You [flags_marine_helmet & HELMET_GARB_OVERLAY? "hide" : "show"] the helmet garb."))
	flags_marine_helmet ^= HELMET_GARB_OVERLAY
	update_icon()

	//AND THIS LINE
//END HEAD TEMPLATE

//MASK TEMPLATE (for masks)  ONLY TAKE NAME, DESC, ICON_STATE, ITEM_STATE,  AND ITEM_COLOR.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/mask/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
	//DON'T GRAB STUFF BETWEEN THIS LINE
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	//AND THIS LINE

//END MASK TEMPLATE

//SUIT TEMPLATE (for armor/exosuit)  ONLY TAKE NAME, DESC, ICON_STATE, AND ITEM_STATE.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/suit/storage/marine/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE|NO_SNOW_TYPE
	//DON'T GRAB STUFF BETWEEN THIS LINE
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_override = 'icons/mob/humans/onmob/suit_0.dmi'  //Don't fuck with this in the future please.
	flags_inventory = BLOCKSHARPOBJ
	flags_marine_armor = NO_FLAGS

//LIGHT SUIT TEMPLATE (for armor/exosuit)  ONLY TAKE NAME, DESC, ICON_STATE, AND ITEM_STATE.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/suit/storage/marine/light/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE|NO_SNOW_TYPE
	//DON'T GRAB STUFF BETWEEN THIS LINE
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_override = 'icons/mob/humans/onmob/suit_0.dmi'  //Don't fuck with this in the future please.
	flags_inventory = BLOCKSHARPOBJ
	flags_marine_armor = NO_FLAGS

/obj/item/clothing/suit/storage/marine/fluff/verb/toggle_squad_markings()
	set src in usr
	if(!ishuman(usr)) return

	if(usr.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(usr, SPAN_WARNING("Not right now!"))
		return

	to_chat(usr, SPAN_NOTICE("You [flags_marine_armor & ARMOR_SQUAD_OVERLAY? "hide" : "show"] the squad markings."))
	flags_marine_armor ^= ARMOR_SQUAD_OVERLAY
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/storage/marine/fluff/verb/toggle_shoulder_lamp()
	set src in usr
	if(!ishuman(usr)) return

	if(usr.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(usr, SPAN_WARNING("Not right now!"))
		return

	to_chat(usr, SPAN_NOTICE("You [flags_marine_armor & ARMOR_LAMP_OVERLAY? "hide" : "show"] the shoulder lamp."))
	flags_marine_armor ^= ARMOR_LAMP_OVERLAY
	update_icon(usr)


	//AND THIS LINE
//END SUIT TEMPLATE

//FEET TEMPLATE (for shoes)  ONLY TAKE NAME, DESC, ICON_STATE, ITEM_STATE,  AND ITEM_COLOR.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/shoes/marine/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
//END FEET TEMPLATE

/obj/item/storage/backpack/marine/fluff
	xeno_types = null

/obj/item/storage/backpack/marine/satchel/fluff
	xeno_types = null

/obj/item/clothing/gloves/marine/fluff   //MARINE GLOVES TEMPLATE
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null

/obj/item/clothing/glasses/fluff
	flags_inventory = COVEREYES


//#######################################################\\
//#################### GENERIC SET(S) ###################\\
//#######################################################\\

/obj/item/clothing/head/helmet/marine/fluff/standard_helmet //GENERIC DONOR
	name = "Omega Team Helmet"
	desc = "Helmet worn by Omega Team.  DONOR ITEM"
	icon_state = "standard_helmet"
	item_state = "standard_helmet"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/suit/storage/marine/fluff/standard_armor //GENERIC DONOR
	name = "Omega Team Armor"
	desc = "Armor worn by the Omega Team.  DONOR ITEM"
	icon_state = "standard_armor"
	item_state = "standard_armor"

/obj/item/clothing/under/marine/fluff/standard_jumpsuit //GENERIC DONOR
	name = "Omega Team Uniform"
	desc = "Uniform worn by Omega Team.  DONOR ITEM"
	icon_state = "standard_jumpsuit"
	worn_state = "standard_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/turtleneck //GENERIC DONOR
	name = "Black Ops Turtleneck"
	desc = "A $900 black turtleneck woven from only the purest Azerbaijani cashmere wool.  DONOR ITEM"
	icon_state = "syndicate"
	item_state = "bl_suit"
	worn_state = "syndicate"
	flags_jumpsuit = FALSE


/obj/item/clothing/mask/fluff/balaclava //GENERIC DONOR
	name = "Balaclava"
	desc = "A black Balaclava used for hiding your face.  DISCLAIMER: May not actually hide your face... DONOR ITEM"
	item_state = "balaclava"
	icon_state = "balaclava"
	flags_inventory = COVERMOUTH|ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR

/obj/item/clothing/glasses/fluff/eyepatch //GENERIC DONOR
	name = "An Eyepatch"
	desc = "Badass +10.  Donor Item"
	icon_state = "eyepatch"
	item_state = "eyepatch"

//  EXO-SUITS/ARMORS COSMETICS  ////////////////////////////////////////////////

/obj/item/clothing/suit/storage/marine/fluff/santa //CKEY=tophatpenguin
	name = "Santa's suit"
	desc = "Festive!  DONOR ITEM"
	icon_state = "santa"
	item_state = "santa"

/obj/item/clothing/suit/storage/marine/fluff/commandercookies //CKEY=commandercookies
	name = "marine armor w/ ammo"
	desc = "A marine combat vest with ammunition on it.  DONOR ITEM"
	icon_state = "bulletproofammo"
	item_state = "bulletproofammo"

/obj/item/clothing/suit/storage/marine/fluff/cia
	name = "CIA jacket"
	desc = "An armored jacket with CIA on the back.  DONOR ITEM"
	icon_state = "cia"
	item_state = "cia"

/obj/item/clothing/suit/storage/marine/fluff/obey //CKEY=obeystylez (UNIQUE)
	name = "Black Ops Ablative Armor Vest"
	desc = "Some fancy looking armor.  DONOR ITEM"
	icon_state = "armor_reflec"
	item_state = "armor_reflec"

/obj/item/clothing/suit/storage/marine/fluff/sas_juggernaut //CKEY=sasoperative (UNIQUE)
	name = "juggernaut armor"
	desc = "Some fancy looking armor. DONOR ITEM"
	icon_state = "skinnerarmor"
	item_state = "skinnerarmor"

/obj/item/clothing/suit/storage/marine/fluff/penguin //CKEY=tophatpenguin
	name = "Trenchcoat"
	desc = "An 18th-century trenchcoat. Someone who wears this means serious business.  DONOR ITEM"
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/storage/marine/fluff/wright //CKEY=wrightthewrong
	name = "Swat Armor"
	desc = "Some fancy looking armor. DONOR ITEM"
	icon_state = "deathsquad"
	item_state = "swat_suit"

/obj/item/clothing/suit/storage/marine/fluff/tyran //CKEY=tyran68
	name = "Swat Armor"
	desc = "Some fancy looking armor. DONOR ITEM"
	icon_state = "deathsquad"
	item_state = "swat_suit"

/obj/item/clothing/suit/storage/marine/fluff/tristan //CKEY=tristan63
	name = "M3X Pattern Armor"
	desc = "A set of experimental M3 pattern armor, modernized to include form fitting ceramic plates for better protection against projectiles. Unfortunately the plates appear to be broken beyond repair, leaving only the base M3 protection.  DONOR ITEM"
	icon_state = "tristan_armor"
	item_state = "tristan_armor"

/obj/item/clothing/suit/storage/marine/fluff/sas_legion //CKEY=sasoperative (UNIQUE)
	name = "Legion Armor"
	desc = "This armor was custom-made to resemble the small growing Legion within the galaxy started by one man slowly making its way to becoming a larger Corporation.  DONOR ITEM."
	item_state = "ncrjacket"
	icon_state = "ncrjacket"

/obj/item/clothing/suit/storage/marine/fluff/feodrich //CKEY=feodrich (UNIQUE)
	name = "Doom Armor"
	desc = "A uniform, of a famous Earth warrior... Donor Item"
	item_state = "doom_armor"
	icon_state = "doom_armor"

/obj/item/clothing/suit/storage/marine/fluff/totalanarchy //CKEY=totalanarchy
	name = "Leo's Armor"
	desc = "Used Mercenary armor.  DONOR ITEM."
	item_state = "merc_armor"
	icon_state = "merc_armor"

/obj/item/clothing/suit/storage/marine/fluff/sadokist2 //CKEY=sadokist
	name = "Heavy Security Hardsuit"
	desc = "Heavily armored security hardsuit.  DONOR ITEM"
	icon_state = "rig-secTG"
	item_state = "rig-secTG"

/obj/item/clothing/suit/storage/marine/fluff/vintage //CKEY=vintagepalmer
	name = "Vintage armor with ripples."
	desc = "A vintage DONOR ITEM"
	icon_state = "bulletproof"
	item_state = "bulletproof"

/obj/item/clothing/suit/storage/marine/fluff/john56 //CKEY=johnkilla56
	name = "A red trenchcoat"
	desc = "A special trenchcoat made famous for instilling fear into greytide everywhere. DONOR ITEM"
	icon_state = "hos"
	item_state = "hos"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/storage/marine/light/fluff/biolock //CKEY=biolock
	name = "M3-L Custom"
	desc = "A lighter, cut down version of the standard M3 pattern armor. This armor looks to have heavy modifications and a custom paint-job.  DONOR ITEM."
	item_state = "bio_armor"
	icon_state = "bio_armor"

/obj/item/clothing/suit/storage/marine/fluff/sas_elite //CKEY=sasoperative (UNIQUE)
	name = "Elite Combat Armor"
	desc = "A combat armor with blood stains on it from previous battles.  UNIQUE DONOR ITEM"
	icon_state = "hecuarmor_u"
	item_state = "hecuarmor_u"

/obj/item/clothing/suit/storage/marine/fluff/limo //CKEY=limodish (UNIQUE)
	name = "Blood-Red Hardsuit"
	desc = "Looks like a hardsuit.  Unique DONOR ITEM"
	icon_state = "syndicate"
	item_state = "syndicate"

/obj/item/clothing/suit/storage/marine/fluff/Zynax //CKEY=zynax
	name = "Gorka Vest"
	desc = "Russian Camo Vest.  Unique DONOR ITEM"
	icon_state = "gorkavest_u"
	item_state = "gorkavest_u"

/obj/item/clothing/suit/storage/marine/fluff/bwoincognito //CKEY=bwoincognito
	name = "Fallout Jacket"
	desc = "The Jacket of an ancient wastelander...  Unique DONOR ITEM"
	icon_state = "riotjacket_u"
	item_state = "riotjacket_u"

/obj/item/clothing/suit/storage/marine/fluff/adjective
	name = "HOS Trenchcoat"
	desc = "A trenchcoat of authority.  DONOR ITEM"
	icon_state = "jensencoat"
	item_state = "jensencoat"

/obj/item/clothing/suit/storage/marine/fluff/fickmacher //CKEY=fickmacher (UNIQUE)
	name = "Selena's Trenchcoat"
	desc = "A trenchcoat of authority.  DONOR ITEM"
	icon_state = "jensencoat"
	item_state = "jensencoat"

/obj/item/clothing/suit/storage/marine/fluff/juninho
	name = "Ablative Armor"
	desc = "A fairly advanced set of armor.  DONOR ITEM"
	icon_state = "armor_reflec"
	item_state = "armor_reflec"

/obj/item/clothing/suit/storage/marine/fluff/mitii
	name = "Mya's Trenchcoat"
	desc = "A trenchcoat of authority.  DONOR ITEM"
	icon_state = "hos"
	item_state = "hos"

/obj/item/clothing/suit/storage/marine/fluff/gromi
	name = "Hawkeye's Jacket"
	desc = "A jacket worn by a famous battlefield doctor.  UNIQUE DONOR ITEM"
	icon_state = "hawkeye_jacket_u"
	item_state = "hawkeye_jacket_u"

/obj/item/clothing/suit/storage/marine/fluff/chimera //CKEY=theultimatechimera
	name = "Brett's Trenchcoat"
	desc = "A trenchcoat of authority.  DONOR ITEM"
	icon_state = "hos"
	item_state = "hos"

/obj/item/clothing/suit/storage/marine/fluff/devilzhand
	name = "Tank's Trenchcoat"
	desc = "A trenchcoat of authority.  DONOR ITEM"
	icon_state = "jensencoat"
	item_state = "jensencoat"


/obj/item/clothing/suit/storage/marine/fluff/feweh //CKEY=feweh
	name = "Pink's Ablative Armor Vest"
	desc = "The fanciest bullet proof vest you've ever seen.  DONOR ITEM"
	icon_state = "armor_reflec"
	item_state = "armor_reflec"

/obj/item/clothing/suit/storage/marine/fluff/crazyh206
	name = "Templar Armor"
	desc = "Some strange holy armor you don't recognize...  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = "templar"
	item_state = "templar"

/obj/item/clothing/suit/storage/marine/fluff/tranquill
	name = "Jesse Pinkman's Han Solo Outfit"
	desc = "Used clothes from a famous smuggler.  UNIQUE DONOR ITEM"
	item_state = "solo_jumpsuit_u"
	icon_state = "solo_jumpsuit_u"

/obj/item/clothing/suit/storage/marine/fluff/oneonethreeeight //CKEY=oneonethreeeight
	name = "Camouflage Armor"
	desc = "Woodland Camouflage Armor.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = "camo_armor"
	item_state = "camo_armor"

/obj/item/clothing/suit/storage/marine/fluff/dino //CKEY=dinobubba7
	name = "Sneaking Suit"
	desc = "An old suit, used by a famous spy.  Smells like cigarettes...  DONOR ITEM"
	icon_state = "snakesuit"
	item_state = "snakesuit"

/obj/item/clothing/suit/storage/marine/fluff/fickmacher2 //CKEY=fickmacher (UNIQUE)
	name = "Corporal Hart's Armor"
	desc = "It looks like the left arm is Robotic, wait what?  DONOR ITEM"
	icon_state = "hartarmor"
	item_state = "hartarmor"

/obj/item/clothing/suit/storage/marine/fluff/paradox //CKEY=paradox1i7
	name = "Templar Armor"
	desc = "Ancient holy armor of heroes long passed...  DONOR ITEM"
	icon_state = "templar2"
	item_state = "templar2"

/obj/item/clothing/suit/storage/marine/fluff/chris1464 //CKEY=chris1464
	name = "Mercenary Armor"
	desc = "Armor from an old Mercenary Company, you hope it still holds up...  DONOR ITEM"
	icon_state = "merc_vest"
	item_state = "merc_vest"

/obj/item/clothing/suit/storage/marine/fluff/radical
	name = "Bounty Hunter Armor"
	desc = "Armor from an ancient Bounty Hunter.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = "boba_armor"
	item_state = "boba_armor"

/obj/item/clothing/suit/storage/marine/fluff/stobarico //CKEY=stobarico (UNIQUE)
	name = "British Admiral Uniform"
	desc = "An ancient uniform of an Admiral.  DONOR ITEM"
	icon_state = "lordadmiral"
	item_state = "lordadmiral"

/obj/item/clothing/suit/storage/marine/fluff/starscream //CKEY=starscream123 (NOT UNIQUE)
	name = "Kardar Hussein's Armor"
	desc = "Slightly worn and torn.  DONOR ITEM"
	icon_state = "merc_armor"
	item_state = "merc_armor"

/obj/item/clothing/suit/storage/marine/fluff/steelpoint //CKEY=steelpoint (UNIQUE)
	name = "M4-X Armor"
	desc = "A next generation body armor system intended for Marines fighting against xenomorphs, the system is coated in a unique acid resistant polymer coating, as well as enhanced ballistics protection. This prototype version lacks those two features. DONOR ITEM"
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE
	icon_state = "steelpoint_armor"
	item_state = "steelpoint_armor"

/obj/item/clothing/suit/storage/marine/fluff/valentine //CKEY=markvalentine
	name = "Shocky's Armor"
	desc = "Shockingly good armor.   DONOR ITEM"
	icon_state = "ertarmor_sec"
	item_state = "ertarmor_sec"


/obj/item/clothing/suit/storage/marine/fluff/nickiskool //CKEY=nickiskool
	name = "Starlord's Jacket"
	desc = "Who?  DONOR ITEM"
	icon_state = "star_jacket"
	item_state = "star_jacker"

/obj/item/clothing/suit/storage/marine/fluff/sadokist //CKEY=sadokist
	name = "T15 spec ops armor"
	desc = "A suit of tightly woven armor crafted for a special forces operator, meant to be flexible and protective against small arms fire. Seems to be custom fit for a very specific user, as the collar has the name 'Tanya' stamped on it.  DONOR ITEM"
	icon_state = "sadokist_armor"
	item_state = "sadokist_armor"

/obj/item/clothing/suit/storage/marine/fluff/fairedan //CKEY=fairedan (UNIQUE)
	name = "Freighter Crew Flight Jacket"
	desc = "Standard Issue Jacket for crew that serve on Lockmart CM-88B Bison starfreighters.  It has the number 1809246 on the inside tag...  DONOR ITEM"
	icon_state = "Fairedan_vest"
	item_state = "Fairedan_vest"

/obj/item/clothing/suit/storage/marine/fluff/jackmcintyre //CKEY=jackmcintyre (UNIQUE)
	name = "Exo-Suit Jackert"
	desc = "Some sort of strange Exo-suit jacket.  It has the letters USCM stamped over a faded word that appears to be ATLAS...  UNIQUE DONOR ITEM"
	icon_state = "Adam_jacket_u"
	item_state = "Adam_jacket_u"

/obj/item/clothing/suit/storage/marine/fluff/commissar //used by both ckeys 'hycinth' and 'technokat' (UNIQUE)
	name = "Omega Commissar Armor"
	desc = "Armor worn by the feared and respected Comissars of Omega Team.  UNIQUE DONOR ITEM"
	icon_state = "commisar_armor_u"
	item_state = "commisar_armor_u"

/obj/item/clothing/suit/storage/marine/fluff/medicae_armor //CKEY=graciegrace0 (UNIQUE)
	name = "Omega Medicae Armor"
	desc = "Armor worn by the Omega Team Medical Corps.  UNIQUE DONOR ITEM"
	icon_state = "medicae_armor_u"
	item_state = "medicae_armor_u"

/obj/item/clothing/suit/storage/marine/fluff/Sanctum_heavy
	name = "Sanctum Founder Armor"
	desc = "Personal Armor of the Founder of Sanctum Team. It looks more like a Exosuit.  Unique DONOR ITEM" //Add UNIQUE if Unique
	icon_state = "Sanctum_Heavy_u"
	item_state = "Sanctum_Heavy_u"

/obj/item/clothing/suit/storage/marine/fluff/Sanctum_medium
	name = "Sanctum Standard Armor"
	desc = "The Standard Issue Armor for Sanctum Operatives  Unique DONOR ITEM"
	icon_state = "Sanctum_Medium_u"
	item_state = "Sanctum_Medium_u"

/obj/item/clothing/suit/storage/marine/fluff/dudewithatude
	name = "Rainbow Coat"
	desc = "Powered by the magic of FRIENDSHIP. (Can be toggled opened or closed)  UNIQUE DONOR ITEM"
	icon_state = "AlexLermire_u"
	item_state = "AlexLermire_u"
	var/open = FALSE

/obj/item/clothing/suit/storage/marine/fluff/dudewithatude/verb/verb_toggleopen()
	set src in usr
	set category = "Object"
	set name = "Toggle Open"
	if(!open)
		icon_state = "AlexLermire_on_u"
		item_state = "AlexLermire_on_u"
		open = TRUE
	else
		open = FALSE
		icon_state = "AlexLermire_u"
		item_state = "AlexLermire_u"
	update_icon()
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/storage/marine/fluff/titus
	name = "ODST Armor"
	desc = "Strange looking armor with faded ODST lettering...  UNIQUE DONOR ITEM"
	icon_state = "leviathan13_u"
	item_state = "leviathan13_u"

/obj/item/clothing/suit/storage/marine/fluff/trblackdragon //CKEY=trblackdragon
	name = "Strange Looking Armor"
	desc = "Looks like it's from another time and place...  UNIQUE DONOR ITEM"
	icon_state = "TR-Donor_u"
	item_state = "TR-Donor_u"

/obj/item/clothing/suit/storage/marine/fluff/zegara //CKEY=zegara
	name = "Black and Pink armor"
	desc = "Shiny black armor with pink accents...  UNIQUE DONOR ITEM"
	icon_state = "zegara_armor_u"
	item_state = "zegara_armor_u"

/obj/item/clothing/suit/storage/marine/fluff/eonoc
	name = "Browncoat"
	desc = "You can't take the sky from me...  DONOR ITEM"
	icon_state = "Eonoc_coat"
	item_state = "Eonoc_coat"
	var/open = FALSE

/obj/item/clothing/suit/storage/marine/fluff/eonoc/verb/verb_toggleopen()
	set src in usr
	set category = "Object"
	set name = "Toggle Open"
	if(!open)
		icon_state = "Eonoc_coat_o"
		item_state = "Eonoc_coat_o"
		open = TRUE
	else
		open = FALSE
		icon_state = "Eonoc_coat"
		item_state = "Eonoc_coat"
	update_icon()
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/storage/marine/fluff/kaila
	name = "Custom Engineering Armor"
	desc = "Custom paint job on a set of engineering armor.  DONOR ITEM"
	icon_state = "kailas_armor"
	item_state = "kailas_armor"

/obj/item/clothing/suit/storage/marine/fluff/fridrich
	name = "Solid Black Labcoat"
	desc = "Very stylish. DONOR ITEM"
	icon_state = "Reznoriam"
	item_state = "Reznoriam"

/obj/item/clothing/suit/storage/marine/fluff/lostmixup
	name = "peace walker battle dress"
	desc = "A uniform from an ancient hero.  Has the name Snake written on a tag in the back...  UNIQUE DONOR ITEM."
	icon_state = "lostmixup_u"
	item_state = "lostmixup_u"

/obj/item/clothing/suit/storage/marine/fluff/laser243
	name = "faded ranger armor"
	desc = "Looks like it was assembled out of several types of armor and cloth, probably somewhere post-apocalyptic...  DONOR ITEM."
	icon_state = "laser243"
	item_state = "laser243"

/obj/item/clothing/suit/storage/marine/fluff/killaninja12
	name = "space cowboy armor"
	desc = "Some people call you the space cowboy, some people call you the gangster of love...  UNIQUE DONOR ITEM."
	icon_state = "killaninja12_u"
	item_state = "killaninja12_u"

/obj/item/clothing/suit/storage/marine/fluff/forwardslashn
	name = "prototype ballistric armor"
	desc = "A prototyped version of fancy ballistic armor.  UNIQUE DONOR ITEM."
	icon_state = "forwardslashn_u"
	item_state = "forwardslashn_u"




// HELMETS/HATS/BERETS COSMETICS  ////////////////////////////////////////////////
/obj/item/clothing/head/helmet/marine/fluff/santahat //CKEY=tophatpenguin
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santa_hat_red"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/sas_juggernaut //CKEY=sasoperative (UNIQUE)
	name = "juggernaut helmet"
	icon_state = "skinnerhelmet"
	desc = "A red helmet, for pairing with JuggerNaut Armor. DONOR ITEM"

/obj/item/clothing/head/helmet/marine/fluff/tristan //CKEY=tristan63
	name = "Fancy Helmet"
	desc = "That's not red paint. That's real blood. DONOR ITEM"
	icon_state = "syndicate"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/penguin //CKEY=tophatpenguin
	name = "Top Penguin Hat"
	icon_state = "petehat"
	desc = "A hat for a penguin, maybe even the TOP Penguin... DONOR ITEM"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/feodrich //CKEY=feodrich (UNIQUE)
	name = "Doom Helmet"
	icon_state = "doom_helmet"
	desc = "A Helmet, of a famous Earth warrior... Donor Item"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/sadokist //CKEY=sadokist
	name = "Tanya's Beret"
	desc = "A bright red beret, owned by Tanya Edenia."
	icon_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/robin //CKEY=robin63
	name = "Robin Low's Beret"
	desc = "A bright red beret, owned by Robin Low."
	icon_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/vintage //CKEY=vintagepalmer
	name = "Vintage Pimp Hat"
	icon_state = "petehat"
	desc = "A pimp hat, for the classic pimp. DONOR ITEM"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/john56 //CKEY=johnkilla56
	name = "Priest hood"
	icon_state = "chaplain_hood"
	desc = "Thought I walk through the valley in the shadow of death... Donor Item"

/obj/item/clothing/head/helmet/marine/fluff/biolock //CKEY=biolock
	name = "M10-Custom"
	desc = "A custom M10 Pattern Helmet. The inside of the helmet has smaller, slicker pads. There is a built-in camera on the right side. DONOR ITEM"
	icon_state = "bio_helmet"
	item_state = "bio_helmet"

/obj/item/clothing/head/helmet/marine/fluff/haveatya //CKEY=haveatya
	name = "Pararescue Beret"
	desc = "A Pararescue Beret, issued only to the very best.  DONOR ITEM"
	icon_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/sas_elite //CKEY=sasoperative (UNIQUE)
	name = "Elite Combat Helmet"
	icon_state = "hecuhelm_u"
	desc = "A combat helmet, bearing the scars of many battles. UNIQUE DONOR ITEM"

/obj/item/clothing/head/helmet/marine/fluff/officialjake
	name = "Timothy's Beret"
	desc = "A fancy red beret owned by Timothy Seidner.  DONOR ITEM"
	icon_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/ningajai
	name = "Anthony's helmet"
	desc = "COG helmet owned by Anthony Carmine"
	icon_state = "anthonycarmine"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/goldshieldberet
	name = "beret"
	desc = "A military black beret with a gold shield."
	icon_state = "gberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/goldtrimberet
	name = "beret"
	desc = "A maroon beret with gold trim"
	icon_state = "gtberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/commandercookies //CKEY=commandercookies
	name = "Elliots Beret"
	desc = "A dark maroon beret"
	icon_state = "eberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/juniho
	name = "Sheet's Hat"
	desc = "A hat, very closely affiliated with accusations of people being bad at security...  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = "detective"
	item_state = "detective"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/limo //CKEY=limodish (UNIQUE)
	name = "Blood Red Hardsuit"
	desc = "It looks like a costume hardsuit helmet.  DONOR ITEM"
	icon_state = "syndicate"
	item_state = "syndicate"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/devilzhand
	name = "MICH Helmet"
	desc = "A fancy combat helmet.  DONOR ITEM"
	icon_state = "mich"
	item_state = "mich"

/obj/item/clothing/head/helmet/marine/fluff/bark
	name = "Judge Helmet"
	desc = "I AM THE LAW.  UNIQUE DONOR ITEM"
	icon_state = "judgehelm_u"
	item_state = "judgehelm_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES

/obj/item/clothing/head/helmet/marine/fluff/bwoincognito //CKEY=bwoincognito
	name = "Fallout Helmet"
	desc = "A helmet from an ancient wastelander...  UNIQUE DONOR ITEM"
	icon_state = "riothelm_u"
	item_state = "riothelm_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/mitii
	name = "Mya's Beret"
	desc = "A red beret with a shiny Security badge.  DONOR ITEM"
	icon_state = "beret_badge"
	item_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/fickmacher //CKEY=fickmacher (UNIQUE)
	name = "Selena's hat"
	desc = "A fancy beret.  DONOR ITEM"
	icon_state = "hosberet"
	item_state = "hosberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/eastgerman
	name = "Melyvn's hat"
	desc = "A fancy beret.  DONOR ITEM"
	icon_state = "hosberet"
	item_state = "hosberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/chimera //CKEY=theultimatechimera
	name = "Brett's hat"
	desc = "A fancy beret.  DONOR ITEM"
	icon_state = "hosberet"
	item_state = "hosberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/lostmixup
	name = "Infinite Ammo Bandanna"
	desc = "Disclaimer: Probably doesn't provide infinite ammo.  UNIQUE DONOR ITEM"
	icon_state = "headband_u"
	item_state = "headband_u"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/totalanarchy //CKEY=totalanarchy
	name = "Leo's Helm"
	desc = "An old mercenary helmet.  DONOR ITEM"
	icon_state = "merc_helm"
	item_state = "merc_helm"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDELOWHAIR

/obj/item/clothing/head/helmet/marine/fluff/oneonethreeeight //CKEY=oneonethreeeight
	name = "Camouflage Helmet"
	desc = "Woodland Camouflage helmet.  DONOR ITEM"
	icon_state = "camo_helm"
	item_state = "camo_helm"

/obj/item/clothing/head/helmet/marine/fluff/dino //CKEY=dinobubba7
	name = "Snake's Bandana"
	desc = "Property of The Boss.  DONOR ITEM"
	icon_state = "snakeheadband"
	item_state = "snakeheadband"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/paradox //CKEY=paradox1i7
	name = "Templar Helmet"
	desc = "The helm of a once powerful order.  DONOR ITEM"
	icon_state = "templar_helm"
	item_state = "templar_helm"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/deejay
	name = "Rooks's Beret"
	desc = "A fancy red beret owned by Juan 'Rook' Garcia.  DONOR ITEM"
	icon_state = "beret_badge"
	item_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/chris1464 //CKEY=chris1464
	name = "Merc Beret"
	desc = "Beret from a Mercenary Company.  DONOR ITEM"
	icon_state = "cargosoft"
	item_state = "cargosoft"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/radical
	name = "Bounty Hunter Helmet"
	desc = "A helmet from an ancient bounty hunter.  DONOR ITEM"
	icon_state = "boba_helmet"
	item_state = "boba_helmet"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/whiteblood17 //CKEY=whiteblood17
	name = "Black Ops Helmet"
	desc = "You're not authorized to look at it.  DONOR ITEM"
	icon_state = "syndicate-helm-black"
	item_state = "syndicate-helm-black"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/leondark //CKEY=leondark16
	name = "Hunter's USCM Cap"
	desc = "A well-worn cap with the name 'Barrientos' written on the inside.  DONOR ITEM"
	icon_state = "USCM_cap"
	item_state = "USCM_cap"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/starscream //CKEY=starscream123 (UNIQUE)
	name = "Kardar Hussein's Helmet"
	desc = "Slightly worn and torn.  DONOR ITEM"
	icon_state = "asset_protect"
	item_state = "asset_protect"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/trblackdragon //CKEY=trblackdragon
	name = "Spartan Helmet"
	desc = "SPARTANS, WHAT IS YOUR PROFESSION?  DONOR ITEM"
	icon_state = "blackdragon_helmet_u" //UNIQUE
	item_state = "blackdragon_helmet_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/steelpoint //CKEY=steelpoint (UNIQUE)
	name = "M4-X Helmet"
	desc = "A next generation combat helmet intended to be paired with the M4-X armor. The full faced helmet provides complete light ballistic-resistant protection alongside enchanced acid resistance. This prototype version lacks those features. DONOR ITEM"
	icon_state = "steelpoint_helmet"
	item_state = "steelpoint_helmet"
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/valentine //CKEY=markvalentine
	name = "Shocky's Helmet"
	desc = "Shockingly good helmet.  DONOR ITEM"
	icon_state = "syndicate-helm-black"
	item_state = "syndicate-helm-black"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/jdobbin49 //CKEY=jdobbin49
	name = "Phillip's Beret"
	desc = "Beret owned by Phillip Greenwall.  DONOR ITEM"
	icon_state = "berettan"
	item_state = "berettan"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/nickiskool //CKEY=nickiskool
	name = "Starlord Mask"
	desc = "Just in case someone might recognize you...  DONOR ITEM"
	icon_state = "star_mask"
	item_state = "star_mask"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/bibblesless
	name = "Yellow ERT Helmet"
	desc = "Standard Emergency Helmet, yellow variety....  DONOR ITEM"
	icon_state = "rig0-ert_engineer"
	item_state = "rig0-ert_engineer"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/fernkiller
	name = "White ERT Helmet"
	desc = "Standard Emergency Helmet, white variety....  DONOR ITEM"
	icon_state = "rig0-ert_medical"
	item_state = "rig0-ert_medical"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/jackmcintyre //CKEY=jackmcintyre (UNIQUE)
	name = "USCM Ball Cap"
	desc = "USCM Cold Weather Ball Cap...  DONOR ITEM"
	icon_state = "Adam_hat"
	item_state = "Adam_hat"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/commissar //used by both ckeys 'hycinth' and 'technokat' (UNIQUE)
	name = "Omega Commissar Helmet"
	desc = "Helmet worn by the Comissars of Omega Team.  UNIQUE DONOR ITEM"
	icon_state = "commissar_helmet_u"
	item_state = "commissar_helmet_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/medicae_helmet //CKEY=graciegrace0 (UNIQUE)
	name = "Omega Medicae Helmet"
	desc = "Helmet worn by the Medical Corps of Omega Team.  UNIQUE DONOR ITEM"
	icon_state = "medicae_helmet_u"
	item_state = "medicae_helmett_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/Sanctum_helmet
	name = "Sanctum Combat Helmet"
	desc = " The Standard Issue helmet of Sanctum Team.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = "Sanctum_Helm_u"
	item_state = "Sanctum_Helm_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/dingledangle
	name = "Rusty's Cap"
	desc = "A little old and shabby. The color has slightly faded over time.  DONOR ITEM"
	icon_state = "bluesoft"
	item_state = "bluesoft"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/titus
	name = "ODST helmet"
	desc = "An old helmet, with faded ODST lettering.  UNIQUE DONOR ITEM"
	icon_state = "leviathan13_helm_u"
	item_state = "leviathan13_helm_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/kaila
	name = "Custom Engineering Snow Helmet"
	desc = "A custom paint job done on an engineering helmet.  DONOR ITEM"
	icon_state = "kailas_helmet"
	item_state = "kailas_helmet"

/obj/item/clothing/head/helmet/marine/fluff/edgelord
	name = "Operator Cap"
	desc = "A sturdy brown USCM cap with an attached radio headset. This one has the name 'Mann' printed on the back.  DONOR ITEM"
	icon_state = "edgelord_cap"
	item_state = "edgelord_cap"

/obj/item/clothing/head/helmet/marine/fluff/laser243
	name = "faded ranger helmet"
	desc = "Engraved in the back is the year 2033.  DONOR ITEM"
	icon_state = "laser243"
	item_state = "laser243"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/killaninja12
	name = "space cowboy hat"
	desc = "the name 'Maurice' is written inside the hat...  UNIQUE DONOR ITEM"
	icon_state = "killaninja12_u"
	item_state = "killaninja12_u"


// UNIFORM/JUMPSUIT COSMETICS  ////////////////////////////////////////////////

//UNIFORM TEMPLATE (for uniforms/jumpsuits)  ONLY TAKE NAME, DESC, ICON_STATE, ITEM_STATE,  AND ITEM_COLOR.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/under/marine/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	flags_atom = FPRINT|NO_NAME_OVERRIDE|NO_SNOW_TYPE
	icon_state = null
	item_state = null
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/uniform_1.dmi',
	)

//END UNIFORM TEMPLATE

/obj/item/clothing/under/marine/fluff/marinemedic //UNUSED
	name = "Marine Medic jumpsuit"
	desc = "A standard quilted Colonial Marine jumpsuit. Weaved with armored plates to protect against low-caliber rounds and light impacts. Has medical markings. "
	icon_state = "marine_medic"
	worn_state = "marine_medic"

/obj/item/clothing/under/marine/fluff/marineengineer //UNUSED
	name = "Marine Technician jumpsuit"
	desc = "A standard quilted Colonial Marine jumpsuit. Weaved with armored plates to protect against low-caliber rounds and light impacts. Has engineer markings. "
	icon_state = "marine_engineer"
	worn_state = "marine_engineer"

/obj/item/clothing/under/marine/fluff/tristan //CKEY=tristan63
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	name = "captain's jumpsuit"
	icon_state = "camojump"
	worn_state = "camojump"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/sas_legion //CKEY=sasoperative (UNIQUE)
	name = "Legion Suit"
	desc = "This armor was custom-made to resemble the small growing Legion within the galaxy started by one man slowly making its way to becoming a larger Corporation.  DONOR ITEM."
	icon_state = "ncr_uni"
	worn_state = "ncr_uni"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/feodrich //CKEY=feodrich (UNIQUE)
	name = "Doom Uniform"
	desc = "A uniform, of a famous Earth warrior... Donor Item"
	icon_state = "doom_suit"
	worn_state = "doom_suit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/totalanarchy //CKEY=totalanarchy
	name = "Mercenary Jumpsuit Suit"
	desc = "A uniform from a band of mercenaries...  DONOR ITEM."
	icon_state = "merc_jumpsuit"
	worn_state = "merc_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/john56 //CKEY=johnkilla56
	name = "Pink Pride Jumpsuit"
	desc = "A jumpsuit for showing your pride in pink... Donor Item"
	icon_state = "pink"
	worn_state = "pink"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/sas_elite //CKEY=sasoperative (UNIQUE)
	name = "Black Fatigues"
	desc = "Black camo Fatigues usually used on Night Operations.  UNIQUE DONOR ITEM."
	icon_state = "hecu_u"
	worn_state = "hecu_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/leeeverett //CKEY=theflagbearer (UNIQUE)
	name = "Rugged Outfit"
	desc = "It's covered in blood and smells terrible. Who died in this?"
	icon_state = "rugged"
	worn_state = "rugged"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/vintage //CKEY=vintagepalmer
	name = "Vintage Pink Jumpsuit"
	desc = "A jumpsuit that was either once red, or once white and washed with a load of colors... Donor Item"
	icon_state = "pink"
	worn_state = "pink"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/wooki //CKEY=tophatpenguin (UNIQUE)
	name = "Fancy Uniform"
	desc = "Wooki's fancy blue suit.  UNIQUE DONOR ITEM"
	icon_state = "wooki_u"
	worn_state = "wooki_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/Zynax //CKEY=zynax
	name = "Gorka Suit"
	desc = "Russian Gamo.   DONOR ITEM"
	icon_state = "gorkasuit"
	worn_state = "gorkasuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/bwoincognito //CKEY=bwoincognito
	name = "Fallout Suit"
	desc = "A suit from an ancient group of wastelanders...   UNIQUE DONOR ITEM"
	icon_state = "riot_u"
	worn_state = "riot_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/juninho
	name = "Corporate Security Uniform"
	desc = "A security jumpsuit, worthy of a Corporate Head of Security.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = "hos_corporate"
	worn_state = "hos_corporate"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/fickmacher //CKEY=fickmacher (UNIQUE)
	name = "Selena's Tactical Suit"
	desc = "A strange looking black jumpsuit.  DONOR ITEM"
	icon_state = "robotics"
	worn_state = "robotics"

/obj/item/clothing/under/marine/fluff/gromi
	name = "Hawkeye's Clothes"
	desc = "A uniform worn by a legendary battlefield surgeon.  UNIQUE DONOR ITEM"
	icon_state = "hawkeye_jumpsuit_u"
	worn_state = "hawkeye_jumpsuit_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/feweh //CKEY=feweh
	name = "Pink Fatigues"
	desc = "For fighting breast cancer.  With bullets. Donor Item"
	icon_state = "pink2"
	worn_state = "pink2"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/oneonethreeeight //CKEY=oneonethreeeight
	name = "Camouflage Jumpsuit"
	desc = "Woodland Camouflage Jumpsuit.  DONOR ITEM"
	icon_state = "camo_jumpsuit"
	worn_state = "camo_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/fickmacher2 //CKEY=fickmacher (UNIQUE)
	name = "Hart's Suit"
	desc = "It looks like the Right Arm is robotic.  DONOR ITEM"
	icon_state = "hart_jumpsuit"
	worn_state = "hart_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/paradox //CKEY=paradox1i7
	name = "Templar Jumpsuit"
	desc = "The interface components, for Templar Armor.  DONOR ITEM"
	icon_state = "templar_jumpsuit"
	worn_state = "templar_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/chris1464 //CKEY=chris1464
	name = "Merc Jumpsuit"
	desc = "Jumpsuit from a super shady mercenary company.  DONOR ITEM"
	icon_state = "merc_jumpsuit"
	worn_state = "merc_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/radical
	name = "Bounty Hunter Jumpsuit"
	desc = "Undergarments of an ancient bounty hunter.  DONOR ITEM"
	icon_state = "boba_jumpsuit"
	worn_state = "boba_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/jackmcintyre_alt //CKEY=jackmcintyre
	name = "Dress Uniform"
	desc = "A Dress uniform, worn by standard marines. DONOR ITEM"
	icon_state = "BO_jumpsuit"
	worn_state = "BO_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/starscream //CKEY=starscream123 (UNIQUE)
	name = "Kardar Hussein's Jumpsuit"
	desc = "Slightly worn and torn.  DONOR ITEM"
	icon_state = "merc_jumpsuit2"
	worn_state = "merc_jumpsuit2"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/allan1234
	name = "Commander Jumpsuit"
	desc = "Jumpsuit worn by a space commander...  DONOR ITEM"
	icon_state = "henrick_jumpsuit"
	worn_state = "henrick_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/steelpoint //CKEY=steelpoint (UNIQUE)
	name = "M4-X Jumpsuit"
	desc = "Jumpsuit issued alongside the M4-X armor. Considered outdated compared to the more modern armor system.  DONOR ITEM"
	icon_state = "steelpoint_jumpsuit"
	worn_state = "steelpoint_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/valentine //CKEY=markvalentine
	name = "Shocky's Jumpsuit"
	desc = "Shockingly good Jumpsuit.  DONOR ITEM"
	icon_state = "jensen"
	worn_state = "jensen"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/arach
	name = "Zero Suit"
	desc = "A jumpsuit worn under futuristic armor.  DONOR ITEM"
	icon_state = "samus_jumpsuit"
	worn_state = "samus_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/nickiskool //CKEY=nickiskool
	name = "Starlords Jumpsuit"
	desc = "Designed to show off your manly muscles for all the ladies.  DONOR ITEM"
	icon_state = "star_jumpsuit"
	worn_state = "star_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/jackmcintyre //CKEY=jackmcintyre (UNIQUE)
	name = "White shirt and black Pants"
	desc = "Perfect for formal dress, or going to a combat zone in Style.  UNIQUE DONOR ITEM"
	icon_state = "Adam_jumpsuit_u"
	worn_state = "Adam_jumpsuit_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/fairedan //CKEY=fairedan (UNIQUE)
	name = "Starfreighter Jumpsuit"
	desc = "Standard Issue Jumpsuit for crew that serve on Lockmart CM-88B Bison starfreighters.  It has the number 1809246 on the inside tag....  DONOR ITEM"
	icon_state = "Fairedan_jumpsuit"
	worn_state = "Fairedan_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/commissar //used by both ckeys 'hycinth' and 'technokat' (UNIQUE)
	name = "Omega Commissar Uniform"
	desc = "Uniform worn by the Comissars of Omega Team.  UNIQUE DONOR ITEM"
	icon_state = "commisar_jumpsuit_u"
	worn_state = "commisar_jumpsuit_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/medicae_jumpsuit //CKEY=graciegrace0 (UNIQUE)
	name = "Omega Medicae Uniform"
	desc = "Uniform work by the Medical Corps of Omega Team.  UNIQUE DONOR ITEM"
	icon_state = "medicae_jumpsuit_u"
	worn_state = "medicae_jumpsuit_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/sanctum_uniform //NO USER
	name = "Sanctum Fatigues"
	desc = "Fatigues with Kevlar fibers for a bit more protection than most clothing.  UNIQUE DONOR ITEM"
	icon_state = "Sanctum_u"
	worn_state = "Sanctum_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/sailordave //CKEY=sailordave
	name = "Eden USCM uniform"
	desc = "An older model USCM uniform.  UNIQUE DONOR ITEM"
	icon_state = "syndicate"
	worn_state = "syndicate"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/whiteblood17 //CKEY=whiteblood17
	name = "Black Ops uniform"
	desc = "Way above your pay grade...  DONOR ITEM"
	icon_state = "jensen"
	worn_state = "jensen"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/mileswolfe //CKEY=mileswolfe
	name = "tiger striped combat fatigues"
	desc = "Combat Fatigues that appear to have tiger stripes on them.  UNIQUE DONOR ITEM"
	icon_state = "mileswolfe_u"
	worn_state = "mileswolfe_u"
	flags_jumpsuit = FALSE


// MASK COSMETICS  ////////////////////////////////////////////////

/obj/item/clothing/mask/fluff/john56 //CKEY=johnkilla56
	name = "Revan Mask"
	desc = "A mask from a famous sith... Wait what?  DONOR ITEM."
	item_state = "revanmask"
	icon_state = "revanmask"


/obj/item/clothing/mask/fluff/sas_legion //CKEY=sasoperative (UNIQUE)
	name = "Legion Mask"
	desc = "This armor was custom-made to resemble the small growing Legion within the galaxy started by one man slowly making its way to becoming a larger Corporation.  DONOR ITEM."
	icon_override = 'icons/mob/humans/onmob/mask.dmi'
	item_state = "officer_mask"
	icon_state = "officer_mask"
	flags_inventory = COVERMOUTH|ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR

/obj/item/clothing/mask/fluff/totalanarchy //CKEY=totalanarchy
	name = "PMC Mask"
	desc = "A white colored PMC Mask.  DONOR ITEM."
	icon_override = 'icons/mob/humans/onmob/mask.dmi'
	item_state = "pmc_mask"
	icon_state = "pmc_mask"
	flags_inventory = COVERMOUTH|ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR

/obj/item/clothing/mask/fluff/sas_elite //CKEY=sasoperative (UNIQUE)
	name = "Compact Gas Mask"
	desc = "A compact Gas Mask with a pure red tint to it.  UNIQUE  DONOR ITEM."
	item_state = "hecumask_u"
	icon_state = "hecumask_u"

/obj/item/clothing/mask/fluff/limo //CKEY=limodish
	name = "Swat Mask"
	desc = "Swat Gas Mask.  DONOR ITEM"
	icon_state = "swat"
	item_state = "swat"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEEYES|HIDEFACE

/obj/item/clothing/mask/fluff/feweh //CKEY=feweh
	name = "Pink's Gas Mask"
	desc = "A standard issue gas mask.  DONOR ITEM"
	icon_state = "swat"
	item_state = "swat"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEEYES|HIDEFACE

/obj/item/clothing/mask/fluff/fickmacher2 //CKEY=fickmacher (UNIQUE)
	name = "Corporal Hart's Mask"
	desc = "A robotic looking Armored mask.  DONOR ITEM"
	icon_state = "hartmask"
	item_state = "hartmask"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEFACE

/obj/item/clothing/mask/fluff/starscream //CKEY=starscream123 (UNIQUE)
	name = "Kardar Hussein's mask"
	desc = "Slightly worn and torn.  DONOR ITEM"
	icon_state = "merc_mask"
	item_state = "merc_mask"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEFACE

/obj/item/clothing/mask/fluff/lostmixup
	name = "Phantom Cigar"
	desc = "It's a g-g-g-g-g-ghost cigar.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = "cigar_on"
	item_state = "cigar_on"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEFACE

// BOOTS/SHOES COSMETICS  ////////////////////////////////////////////////
/obj/item/clothing/shoes/marine/fluff/vintage //CKEY=vintagepalmer
	name = "Vintage Sandals"
	desc = "Vintage Sandals, suitable for only the highest class of hipster.  DONOR ITEM"
	icon_state = "sandals"
	item_state = "sandals"

/obj/item/clothing/shoes/marine/fluff/feodrich //CKEY=feodrich (UNIQUE)
	name = "Doom Shoes"
	desc = "A uniform, of a famous Earth warrior... Donor Item"
	icon_state = "doom_boots"
	item_state = "doom_boots"

/obj/item/clothing/shoes/marine/fluff/steelpoint //CKEY=steelpoint (UNIQUE)
	name = "M4-X Boot"
	desc = "Standard issue boots issued alongside M4-X armor, features a special coating of acid-resistant layering to allow its operator to move through acid-dretched environments safely. This prototype version lacks that feature.  DONOR ITEM"
	icon_state = "marine"
	item_state = "marine"

//GENERIC GLASSES, GLOVES, AND MISC ////////////////////

/obj/item/clothing/glasses/fluff/wright //CKEY=wrightthewrong
	name = "eyepatch"
	desc = "Yarr, this be a Donor Item, YARR!"
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/glasses/fluff/sadokist //CKEY=sadokist
	name = "Tanya's Optics"
	desc = "Custom Optics, owned by Tanya Edenia"
	icon_state = "thermal"
	item_state = "glasses"

/obj/item/clothing/glasses/fluff/haveatya //CKEY=haveatya
	name = "Special Nightvision Goggles"
	desc = "Disclaimer:  May not provide Night Vision.  DONOR ITEM"
	icon_state = "night"
	item_state = "glasses"

/obj/item/clothing/gloves/black/obey //CKEY=obeystylez (UNIQUE)
	desc = "Black gloves, favored by Special Operations teams.  DONOR ITEM"
	name = "Black Ops Black Gloves"

//BACKPACKS

/obj/item/storage/backpack/marine/fluff/sadokist //CKEY=sadokist
	name = "Tanya's Backpack"
	desc = "A large backpack, used by Tanya Edenia. DONOR ITEM"
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/storage/backpack/marine/fluff/mitii
	name = "Mya's Backpack"
	desc = "A large security backpack, with a radio booster.  Donor Item"
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/storage/backpack/marine/satchel/fluff/sas_juggernaut //CKEY=sasoperative (UNIQUE)
	name = "tactical radiopack"
	desc = "A Radio backpack for use with the Juggernaut armor. DONOR ITEM"
	icon_state = "skinnerpack"
	item_state = "securitypack"
	has_gamemode_skin = FALSE //same sprite for all gamemodes.

/obj/item/clothing/glasses/fluff/alexwarhammer
	name = "Black Jack's Dank Shades"
	desc = "+20 Badass points.  Donor item"
	icon_state = "sun"
	item_state = "sun"

/obj/item/clothing/gloves/marine/fluff/jedijas //CKEY=jedijasun (UNIQUE)
	name = "Fists of Mandalore"
	desc = "If Mandalore was a person, these would be it's fists...  DONOR ITEM"
	icon_state = "marine_white"
	item_state = "marine_wgloves"

/obj/item/storage/belt/marine/fluff/commissar //used by both ckeys 'hycinth' and 'technokat' (UNIQUE)
	name = "Omega Sword Belt"
	desc = "Belt worn by the dreaded Commissars of Omega Team.  UNIQUE DONOR ITEM"
	icon_state = "swordbelt_u"
	item_state = "swordbelt_u"

//CUSTOM ITEMS - NO TEMPLATES - ALL UNIQUE ////////////////////////
/obj/item/tool/lighter/zippo/fluff/ghostdex //CKEY=ghostdex
	name = "purple zippo lighter"
	desc = "A Purple Zippo lighter, engraved with the name John Donable... UNIQUE DONOR ITEM."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "bluezippo"

/obj/item/clothing/mask/cigarette/fluff/ghostdex //CKEY=ghostdex
	name = "XXX's custom Cigar"
	desc = "A custom rolled giant, made specifically for John Donable in the best, hottest, and most abusive of Cuban sweat shops.  UNIQUE DONOR ITEM."
	icon_state = "cigar2_off"
	icon_on = "cigar2_on"
	icon_off = "cigar_2off"
	smoketime = 7200
	chem_volume = 30
	flags_inventory = COVERMOUTH|ALLOWREBREATH

/* WTF this doing here, p2w content, lol. also this failing tests, so yea
/obj/item/weapon/donatorkatana
	name = "Kou"
	desc = "A piece of steel with a hand-engraved name and a fine signature of the craftsman underneath. Kou was custom made as an object of encouragement with a practical application. || DONATOR ITEM"
	icon_state = "donatorkatana"
	flags_atom = FPRINT|CONDUCT
	force = MELEE_FORCE_VERY_STRONG
	throwforce = MELEE_FORCE_WEAK
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	w_class = SIZE_MEDIUM
	flags_equip_slot = SLOT_BACK
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_speed = 9
*/

//GHOST CIGAR CODE
/obj/item/clothing/mask/cigarette/cigar/fluff/ghostdex/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/lighter/zippo/fluff/ghostdex))
		..()
	else
		to_chat(user, SPAN_NOTICE("\The [src] straight out REFUSES to be lit by anything other than a purple zippo."))
