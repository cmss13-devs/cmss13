/obj/item/storage/box/donator_kit
	name = "donated box"
	desc = "A cardboard box stamped with a dollar sign and filled with trinkets. Appears to have been donated by a wealthy sponsor."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "donator_kit"
	item_state = "giftbag"
	var/list/donor_gear = list()
	var/donor_key = "GENERIC" //Key the kit is assigned to. If GENERIC, not tied to particular donor.
	var/kit_variant
	max_w_class = SIZE_TINY

/obj/item/storage/box/donator_kit/New()
	if(kit_variant)
		name = "[name] ([kit_variant])"
	..()

/obj/item/storage/box/donator_kit/fill_preset_inventory()
	for(var/donor_item in donor_gear)
		new donor_item(src)

/obj/item/storage/box/donator_kit/open(mob/user)
	if((donor_key != "GENERIC") && (donor_key != user.ckey))
		to_chat(user, SPAN_BOLDWARNING("You cannot open a donator kit you do not own!"))
		return FALSE
	..()

/obj/item/storage/box/donator_kit/verb/destroy_kit()
	set name = "Destroy Kit"
	set category = "Object"
	set src in oview(1)

	var/mob/user = usr

	if((donor_key != "GENERIC") && (donor_key != user.ckey))
		to_chat(user, SPAN_BOLDWARNING("You cannot destroy a donator kit you do not own!"))
		return FALSE

	log_admin("[key_name(user)] deleted a donator kit.")
	qdel(src)

/obj/item/storage/box/donator_kit/generic_omega //Generic set given to various donors
	kit_variant = "Team Omega (G)"
	donor_gear = list(
		/obj/item/clothing/under/marine/fluff/standard_jumpsuit,
		/obj/item/clothing/suit/storage/marine/fluff/standard_armor,
		/obj/item/clothing/head/helmet/marine/fluff/standard_helmet,
	)

//Unless specified in comments as otherwise, subtype of box/donator_kit/ is CKEY of the donator (example: /obj/item/storage/box/donator_kit/sasoperative)
/obj/item/storage/box/donator_kit/adjective
	donor_key = "adjective"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/adjective)

/obj/item/storage/box/donator_kit/alexwarhammer
	donor_key = "alexwarhammer"
	donor_gear = list(/obj/item/clothing/glasses/fluff/alexwarhammer)

/obj/item/storage/box/donator_kit/allan1234
	donor_key = "allan1234"
	donor_gear = list(/obj/item/clothing/under/marine/fluff/allan1234)

/obj/item/storage/box/donator_kit/arachnidnexus
	donor_key = "arachnidnexus"
	donor_gear = list(/obj/item/clothing/under/marine/fluff/arach)

/obj/item/storage/box/donator_kit/bibblesless
	donor_key = "bibblesless"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/bibblesless)

/obj/item/storage/box/donator_kit/biolock
	donor_key = "biolock"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/biolock,
		/obj/item/clothing/suit/storage/marine/light/fluff/biolock,
	)

/obj/item/storage/box/donator_kit/bunny232
	donor_key = "bunny232"
	donor_gear = list(/obj/item/clothing/glasses/fluff/eyepatch)

/obj/item/storage/box/donator_kit/bwoincognito
	donor_key = "bwoincognito"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/bwoincognito,
		/obj/item/clothing/suit/storage/marine/fluff/bwoincognito,
		/obj/item/clothing/under/marine/fluff/bwoincognito,
	)

/obj/item/storage/box/donator_kit/chris1464
	donor_key = "chris1464"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/chris1464,
		/obj/item/clothing/suit/storage/marine/fluff/chris1464,
		/obj/item/clothing/under/marine/fluff/chris1464,
	)

/obj/item/storage/box/donator_kit/commandercookies
	donor_key = "commandercookies"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/commandercookies,
		/obj/item/clothing/suit/storage/marine/fluff/commandercookies,
	)

/obj/item/storage/box/donator_kit/commissar //used by both ckeys 'hycinth' and 'technokat'
	donor_key = "hycinth"
	kit_variant = "Commissar"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/commissar,
		/obj/item/clothing/suit/storage/marine/fluff/commissar,
		/obj/item/clothing/under/marine/fluff/commissar,
		/obj/item/storage/belt/marine/fluff/commissar,
	)

/obj/item/storage/box/donator_kit/commissar/technokat
	donor_key = "technokat"

/obj/item/storage/box/donator_kit/crazyh206
	donor_key = "crazyh206"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/crazyh206)

/obj/item/storage/box/donator_kit/devilzhand
	donor_key = "devilzhand"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/devilzhand,
		/obj/item/clothing/suit/storage/marine/fluff/devilzhand,
	)

/obj/item/storage/box/donator_kit/dingledangle
	donor_key = "dingledangle"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/dingledangle)

/obj/item/storage/box/donator_kit/dinobubba7
	donor_key = "dinobubba7"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/dino,
		/obj/item/clothing/suit/storage/marine/fluff/dino,
	)

/obj/item/storage/box/donator_kit/docdemo
	donor_key = "docdemo"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/goldtrimberet)

/obj/item/storage/box/donator_kit/dudewithatude
	donor_key = "dudewithatude"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/dudewithatude)

/obj/item/storage/box/donator_kit/eastgermanstasi
	donor_key = "eastgermanstasi"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/eastgerman)

/obj/item/storage/box/donator_kit/edgelord
	donor_key = "edgelord"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/edgelord)

/obj/item/storage/box/donator_kit/eonoc
	donor_key = "eonoc"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/eonoc)

/obj/item/storage/box/donator_kit/fairedan
	donor_key = "fairedan"
	donor_gear = list(
		/obj/item/clothing/suit/storage/marine/fluff/fairedan,
		/obj/item/clothing/under/marine/fluff/fairedan,
	)

/obj/item/storage/box/donator_kit/feodrich
	donor_key = "feodrich"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/feodrich,
		/obj/item/clothing/shoes/marine/fluff/feodrich,
		/obj/item/clothing/suit/storage/marine/fluff/feodrich,
		/obj/item/clothing/under/marine/fluff/feodrich,
	)

/obj/item/storage/box/donator_kit/fernkiller
	donor_key = "fernkiller"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/fernkiller)

/obj/item/storage/box/donator_kit/feweh
	donor_key = "feweh"
	donor_gear = list(
		/obj/item/clothing/mask/fluff/feweh,
		/obj/item/clothing/suit/storage/marine/fluff/feweh,
		/obj/item/clothing/under/marine/fluff/feweh,
	)

/obj/item/storage/box/donator_kit/fickmacher_selena //ckey fickmacher has two sets
	donor_key = "fickmacher"
	kit_variant = "Selena"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/fickmacher,
		/obj/item/clothing/suit/storage/marine/fluff/fickmacher,
		/obj/item/clothing/under/marine/fluff/fickmacher,
	)

/obj/item/storage/box/donator_kit/fickmacher_hart
	donor_key = "fickmacher"
	kit_variant = "Hart"
	donor_gear = list(
		/obj/item/clothing/mask/fluff/fickmacher2,
		/obj/item/clothing/suit/storage/marine/fluff/fickmacher2,
		/obj/item/clothing/under/marine/fluff/fickmacher2,
	)

/obj/item/storage/box/donator_kit/fridrich
	donor_key = "fridrich"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/fridrich)

/obj/item/storage/box/donator_kit/ghostdex
	donor_key = "ghostdex"
	donor_gear = list(
		/obj/item/clothing/mask/cigarette/fluff/ghostdex,
		/obj/item/tool/lighter/zippo/fluff/ghostdex,
	)

/obj/item/storage/box/donator_kit/graciegrace0
	donor_key = "graciegrace0"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/medicae_helmet,
		/obj/item/clothing/suit/storage/marine/fluff/medicae_armor,
		/obj/item/clothing/under/marine/fluff/medicae_jumpsuit,
	)

/obj/item/storage/box/donator_kit/gromoi
	donor_key = "gromoi"
	donor_gear = list(
		/obj/item/clothing/suit/storage/marine/fluff/gromi,
		/obj/item/clothing/under/marine/fluff/gromi,
	)

/obj/item/storage/box/donator_kit/haveatya
	donor_key = "haveatya"
	donor_gear = list(
		/obj/item/clothing/glasses/fluff/haveatya,
		/obj/item/clothing/head/helmet/marine/fluff/haveatya,
		/obj/item/clothing/under/marine/fluff/turtleneck, //generic item
	)

/obj/item/storage/box/donator_kit/jackmcintyre
	donor_key = "jackmcintyre"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/jackmcintyre,
		/obj/item/clothing/suit/storage/marine/fluff/jackmcintyre,
		/obj/item/clothing/under/marine/fluff/jackmcintyre,
		/obj/item/clothing/under/marine/fluff/jackmcintyre_alt,
	)

/obj/item/storage/box/donator_kit/jdobbin49
	donor_key = "jdobbin49"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/jdobbin49)

/obj/item/storage/box/donator_kit/jedijasun
	donor_key = "jedijasun"
	donor_gear = list(/obj/item/clothing/gloves/marine/fluff/jedijas)

/obj/item/storage/box/donator_kit/johnkilla56
	donor_key = "johnkilla56"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/john56,
		/obj/item/clothing/mask/fluff/john56,
		/obj/item/clothing/suit/storage/marine/fluff/john56,
		/obj/item/clothing/under/marine/fluff/john56,
	)

/obj/item/storage/box/donator_kit/juninho77
	donor_key = "juninho77"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/juniho,
		/obj/item/clothing/suit/storage/marine/fluff/juninho,
		/obj/item/clothing/under/marine/fluff/juninho,
	)

/obj/item/storage/box/donator_kit/kilinger
	donor_key = "kilinger"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/goldshieldberet)

/obj/item/storage/box/donator_kit/kyrac
	donor_key = "kyrac"
	donor_gear = list(
		/obj/item/clothing/under/marine/fluff/turtleneck,
		/obj/item/clothing/glasses/fluff/eyepatch,
	)

/obj/item/storage/box/donator_kit/laser243
	donor_key = "laser243"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/laser243,
		/obj/item/clothing/suit/storage/marine/fluff/laser243,
	)

/obj/item/storage/box/donator_kit/leondark16
	donor_key = "leondark16"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/leondark)

/obj/item/storage/box/donator_kit/lestatanderson
	donor_key = "lestatanderson"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/cia)

/obj/item/storage/box/donator_kit/limodish
	donor_key = "limodish"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/limo,
		/obj/item/clothing/mask/fluff/limo,
		/obj/item/clothing/suit/storage/marine/fluff/limo,
		/obj/item/clothing/under/marine/fluff/turtleneck, //generic item
	)

/obj/item/storage/box/donator_kit/lostmixup
	donor_key = "lostmixup"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/lostmixup,
		/obj/item/clothing/mask/fluff/lostmixup,
		/obj/item/clothing/suit/storage/marine/fluff/lostmixup,
	)

/obj/item/storage/box/donator_kit/markvalentine
	donor_key = "markvalentine"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/valentine,
		/obj/item/clothing/suit/storage/marine/fluff/valentine,
		/obj/item/clothing/under/marine/fluff/valentine,
	)

/obj/item/storage/box/donator_kit/mitii
	donor_key = "mitii"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/mitii,
		/obj/item/clothing/suit/storage/marine/fluff/mitii,
		/obj/item/storage/backpack/marine/fluff/mitii,
	)

/obj/item/storage/box/donator_kit/mrbark45
	donor_key = "mrbark45"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/bark)

/obj/item/storage/box/donator_kit/nickiskool
	donor_key = "nickiskool"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/nickiskool,
		/obj/item/clothing/suit/storage/marine/fluff/nickiskool,
		/obj/item/clothing/under/marine/fluff/nickiskool,
	)

/obj/item/storage/box/donator_kit/ningajai
	donor_key = "ningajai"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/ningajai)

/obj/item/storage/box/donator_kit/obeystylez
	donor_key = "obeystylez"
	donor_gear = list(
		/obj/item/clothing/gloves/black/obey,
		/obj/item/clothing/mask/fluff/balaclava, //generic item
		/obj/item/clothing/suit/storage/marine/fluff/obey,
		/obj/item/clothing/under/marine/fluff/turtleneck, //generic item
	)

/obj/item/storage/box/donator_kit/officialjake
	donor_key = "officialjake"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/officialjake)

/obj/item/storage/box/donator_kit/oneonethreeeight
	donor_key = "oneonethreeeight"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/oneonethreeeight,
		/obj/item/clothing/suit/storage/marine/fluff/oneonethreeeight,
		/obj/item/clothing/under/marine/fluff/oneonethreeeight,
	)

/obj/item/storage/box/donator_kit/paradox1i7
	donor_key = "paradox1i7"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/paradox,
		/obj/item/clothing/suit/storage/marine/fluff/paradox,
		/obj/item/clothing/under/marine/fluff/paradox,
	)

/obj/item/storage/box/donator_kit/poops_buttly
	donor_key = "poops_buttly"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/kaila,
		/obj/item/clothing/suit/storage/marine/fluff/kaila,
	)

/obj/item/storage/box/donator_kit/radicalscorpion
	donor_key = "radicalscorpion"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/radical,
		/obj/item/clothing/mask/fluff/balaclava, //generic item
		/obj/item/clothing/suit/storage/marine/fluff/radical,
		/obj/item/clothing/under/marine/fluff/radical,
	)

/obj/item/storage/box/donator_kit/robin63
	donor_key = "robin63"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/robin)

/obj/item/storage/box/donator_kit/rogue1131
	donor_key = "rogue1131"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/titus,
		/obj/item/clothing/suit/storage/marine/fluff/titus,
	)

/obj/item/storage/box/donator_kit/sadokist
	donor_key = "sadokist"
	donor_gear = list(
		/obj/item/clothing/glasses/fluff/sadokist,
		/obj/item/clothing/head/helmet/marine/fluff/sadokist,
		/obj/item/clothing/suit/storage/marine/fluff/sadokist,
		/obj/item/storage/backpack/marine/fluff/sadokist,
	)

/obj/item/storage/box/donator_kit/sailordave
	donor_key = "sailordave"
	donor_gear = list(/obj/item/clothing/under/marine/fluff/sailordave)

/obj/item/storage/box/donator_kit/sasoperative_elite //sasoperative has several sets
	donor_key = "sasoperative"
	kit_variant = "Elite"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/sas_elite,
		/obj/item/clothing/mask/fluff/sas_elite,
		/obj/item/clothing/suit/storage/marine/fluff/sas_elite,
		/obj/item/clothing/under/marine/fluff/sas_elite,
	)

/obj/item/storage/box/donator_kit/sasoperative_juggernaut
	donor_key = "sasoperative"
	kit_variant = "Juggernaut"
	donor_gear = list(
		/obj/item/storage/backpack/marine/satchel/fluff/sas_juggernaut,
		/obj/item/clothing/head/helmet/marine/fluff/sas_juggernaut,
		/obj/item/clothing/suit/storage/marine/fluff/sas_juggernaut,
	)

/obj/item/storage/box/donator_kit/sasoperative_legion
	donor_key = "sasoperative"
	kit_variant = "Legion"
	donor_gear = list(
		/obj/item/clothing/suit/storage/marine/light/fluff/sas_legion,
		/obj/item/clothing/head/helmet/marine/fluff/sas_legion,
		/obj/item/storage/backpack/marine/satchel/fluff/sas_legion,
	)

/obj/item/storage/box/donator_kit/seloc_aferah
	donor_key = "seloc_aferah"
	donor_gear = list(/obj/item/clothing/head/helmet/marine/fluff/deejay)

/obj/item/storage/box/donator_kit/starscream123
	donor_key = "starscream123"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/starscream,
		/obj/item/clothing/mask/fluff/starscream,
		/obj/item/clothing/suit/storage/marine/fluff/starscream,
		/obj/item/clothing/under/marine/fluff/starscream,
	)

/obj/item/storage/box/donator_kit/steelpoint
	donor_key = "steelpoint"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/steelpoint,
		/obj/item/clothing/shoes/marine/fluff/steelpoint,
		/obj/item/clothing/suit/storage/marine/fluff/steelpoint,
		/obj/item/clothing/under/marine/fluff/steelpoint,
	)

/obj/item/storage/box/donator_kit/stobarico
	donor_key = "stobarico"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/stobarico)

/obj/item/storage/box/donator_kit/theflagbearer
	donor_key = "theflagbearer"
	donor_gear = list(/obj/item/clothing/under/marine/fluff/leeeverett)

/obj/item/storage/box/donator_kit/theultimatechimera
	donor_key = "theultimatechimera"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/chimera,
		/obj/item/clothing/suit/storage/marine/fluff/chimera,
	)

/obj/item/storage/box/donator_kit/tophatpenguin_wooki //ckey tophatpenguin has two sets
	donor_key = "tophatpenguin"
	kit_variant = "Wooki"
	donor_gear = list(
		/obj/item/clothing/suit/storage/marine/fluff/penguin,
		/obj/item/clothing/under/marine/fluff/wooki,
		/obj/item/clothing/head/helmet/marine/fluff/penguin,
	)

/obj/item/storage/box/donator_kit/tophatpenguin_santa
	donor_key = "tophatpenguin"
	kit_variant = "Santa"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/santahat,
		/obj/item/clothing/suit/storage/marine/fluff/santa,
	)

/obj/item/storage/box/donator_kit/totalanarchy
	donor_key = "totalanarchy"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/totalanarchy,
		/obj/item/clothing/mask/fluff/totalanarchy,
		/obj/item/clothing/suit/storage/marine/fluff/totalanarchy,
		/obj/item/clothing/under/marine/fluff/totalanarchy,
	)

/obj/item/storage/box/donator_kit/tranquill
	donor_key = "tranquill"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/tranquill)

/obj/item/storage/box/donator_kit/trblackdragon
	donor_key = "trblackdragon"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/trblackdragon,
		/obj/item/clothing/suit/storage/marine/fluff/trblackdragon,
	)

/obj/item/storage/box/donator_kit/tristan63
	donor_key = "tristan63"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/tristan,
		/obj/item/clothing/suit/storage/marine/fluff/tristan,
		/obj/item/clothing/under/marine/fluff/tristan,
	)

/obj/item/storage/box/donator_kit/tyran68
	donor_key = "tyran68"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/tyran)

/obj/item/storage/box/donator_kit/shotgunbill
	donor_key = "shotgunbill"
	donor_gear = list(/obj/item/clothing/head/collectable/petehat)

/obj/item/storage/box/donator_kit/vintagepalmer
	donor_key = "vintagepalmer"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/vintage,
		/obj/item/clothing/shoes/marine/fluff/vintage,
		/obj/item/clothing/suit/storage/marine/fluff/vintage,
		/obj/item/clothing/under/marine/fluff/vintage,
	)

/obj/item/storage/box/donator_kit/whiteblood17
	donor_key = "whiteblood17"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/whiteblood17,
		/obj/item/clothing/under/marine/fluff/whiteblood17,
	)

/obj/item/storage/box/donator_kit/wrightthewrong
	donor_key = "wrightthewrong"
	donor_gear = list(
		/obj/item/clothing/glasses/fluff/wright,
		/obj/item/clothing/suit/storage/marine/fluff/wright,
		/obj/item/clothing/under/marine/fluff/turtleneck, //generic item
	)

/obj/item/storage/box/donator_kit/zegara
	donor_key = "zegara"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/zegara)

/obj/item/storage/box/donator_kit/zynax
	donor_key = "zynax"
	donor_gear = list(
		/obj/item/clothing/mask/fluff/balaclava, //generic item
		/obj/item/clothing/suit/storage/marine/fluff/Zynax,
		/obj/item/clothing/under/marine/fluff/turtleneck, //generic item
		/obj/item/clothing/under/marine/fluff/Zynax,
	)

/obj/item/storage/box/donator_kit/mileswolfe
	donor_key = "mileswolfe"
	donor_gear = list(/obj/item/clothing/under/marine/fluff/mileswolfe)

/obj/item/storage/box/donator_kit/killaninja12
	donor_key = "killaninja12"
	donor_gear = list(
		/obj/item/clothing/head/helmet/marine/fluff/killaninja12,
		/obj/item/clothing/suit/storage/marine/fluff/killaninja12,
	)

/obj/item/storage/box/donator_kit/noize
	donor_key = "noize"
	donor_gear = list(/obj/item/clothing/suit/storage/marine/fluff/forwardslashn)

/obj/item/storage/box/donator_kit/deanthelis
	donor_key = "deanthelis"
	donor_gear = list(/obj/item/clothing/head/beret/marine/techofficer)
