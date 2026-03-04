//-------//
//language skill pamphlets :)
//------//

/obj/item/pamphlet/language
	name = "translation pamphlet"
	desc = "A pamphlet used by lazy USCM interpreters to quickly learn new languages on the spot."
	flavour_text = "learning a new language."
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/language/russian
	name = "Printed Copy of Pari"
	desc = "Pari, also known as 'The Bet' in English, is a short story written by Russian playwright Anton Chekhov about a bet between a lawyer and a banker; the banker wagers that the lawyer cannot remain in solitary confinement for 15 years, and promises 2 million rubles in exchange. You must be a refined reader if you know this one; why are you even in the USCM if you know that?"
	flavour_text = "you feel like you can understand the torments of the commune better now."
	trait = /datum/character_trait/language/russian

/obj/item/pamphlet/language/japanese
	name = "Pages of Turedobando Yohei Adobencha Zohuken"
	desc = "These are some torn pages from a famous isekai manga named 'Turedobando Yohei Adobencha Zohuken' or Japanese Mercenary Adventure Sequel about a travelling band of Freelancers sent into a fantasy world. Why do you even know this?"
	flavour_text = "you feel... awfully delusional afterwards."
	trait = /datum/character_trait/language/japanese

/obj/item/pamphlet/language/chinese
	name = "Pages from the Little Red Book"
	desc = "没有共产党就没有新中国! Pages from the handbook to starting a famine that kills over 100 million of your people. Apparently this will help you learn Chinese."
	flavour_text = "you feel incredibly enlightened, and ready to exaggerate the death tolls you will incur in your coming battles."
	trait = /datum/character_trait/language/chinese

/obj/item/pamphlet/language/german
	name = "Translated Lyrics to 99 Luftballons"
	desc = "These hastily scribbled translations of 99 Luftballons, an iconic German hit of the 80s, were meant for the yearly Battalion Karaoke Night. I guess you can get some better use out of this."
	flavour_text = "well... it's not bad, but it's quite the read. At least you can understand Germans better now."
	trait = /datum/character_trait/language/german

/obj/item/pamphlet/language/spanish
	name = "America Latina - A Quick Translation Guide for Southern UA states"
	desc = "This pamphlet was designed for Intelligence Officers operating on Earth to interact with the local populaces of the Latin American states, but only for IOs who managed to sleep through Dialects and Mannerisms Class."
	flavour_text = "you feel quite proud of yourself, a celebration must be in order."
	trait = /datum/character_trait/language/spanish

/obj/item/pamphlet/language/scandinavian
	name = "Treatise of the Scandinavian frontiers"
	desc = "This appears to be a record of the Scandinavian frontiers, a shadowy region that is the subject of much controversy from the conflict between the Union of Progressive People and its separatists."
	flavour_text = "you feel... quite somber... after reading through and pinpointing its finer details."
	trait = /datum/character_trait/language/scandinavian

/obj/item/pamphlet/language/french // for daveyish
	name = "Records of the Napoleonic 22nd Century"
	desc = "This document seems to contain a collection of records detailing the life of the latest descendant of the Bonaparte imperial dynasty, Napoléonise Bonaparte the XIII. A quick skim of the pages seem to detail his descendants life and of his governance of the Neo-Francian Colonies. You can probably learn from his teachings."
	flavour_text = "you feel revitalized with imperialistic prospects."
	trait = /datum/character_trait/language/french


//-------//
//restricted languages for admin stuff, for soomis
//------//

/obj/item/pamphlet/language/yautja
	name = "stained parchment"
	desc = "A yellowed old piece of parchment covered in strange runes from an alien writing system. The letters seem to shift back and forth into place before your eyes."
	flavour_text = "learning a strange language that even you are unsure of speaking it verbally."
	trait = /datum/character_trait/language/sainja

/obj/item/pamphlet/language/xenomorph
	name = "Xenobiologist's file"
	desc = "A xenobiologist's document recording and detailing observations on captive Xenomorph communication via vocalisations and pheromones, as well as notes on attempting to reproduce them by human beings."
	flavour_text = "learning a strange language that even you are unsure of speaking it verbally."
	trait = /datum/character_trait/language/xenomorph

/obj/item/pamphlet/language/monkey
	name = "scribbled drawings"
	desc = "A piece of paper covered in crude depictions of bananas and various types of primates. Probably drawn by a three-year-old child - or an unusually intelligent marine."
	flavour_text = "you feel like monkeying around now."
	trait = /datum/character_trait/language/primitive

/obj/item/pamphlet/language/tactical_sign_language
	name = "UA OPSEC document"
	desc = "A document containing the finer details of UA Operational Security. This particular document seems to detail the usage of Tactical Sign Language (TSL) among UA Special Operation Forces. It is quite bewildering to have found this in the wild."
	desc_lore = "The TSL originated during Tientsin campaign, conjured up by UA contracted cryptographers due to a heightened paranoia concerning enemy espionage. Surprisingly enough, TSL draws a good ammount of inspiration from the American Sign Language system, and a deaf person could decypher atleast 20% of what is being said."
	flavour_text = "you feel 👌."
	trait = /datum/character_trait/language/tactical_sign_language

/obj/item/pamphlet/language/forgotten
	name = "Ab Urbe Condita"
	desc = "A ripped off excerpt of Roman Historian Titus Livius' 'From the Foundation of the City' which was a 142 book-history of Rome where a single book is equivalent to a volume of a novel, of which only 35 where said to be found, this is quite an archaeological find!"
	flavour_text = "you feel well informed of the inner workings of the ancient world."
	trait = /datum/character_trait/language/forgotten
