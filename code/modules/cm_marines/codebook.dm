GLOBAL_LIST_EMPTY(codebook_data)

/obj/item/book/codebook/proc/create_codebook(faction = FACTION_MARINE)
	if(!GLOB.codebook_data[faction])
		GLOB.codebook_data[faction] = generate_code()

	dat = GLOB.codebook_data[faction]

/obj/item/book/codebook/proc/generate_code()
	var/number
	var/letter
	var/code_data = "<table><tr><th>Call</th><th>Response<th></tr>"
	for(var/i in 1 to 10)
		letter = pick(GLOB.greek_letters)
		number = rand(100,999)
		code_data += "<tr><td>[letter]-[number]</td>"
		letter = pick(GLOB.greek_letters)
		number = rand(100,999)
		code_data += "<td>[letter]-[number]</td></tr>"
	code_data += "</table>"
	return code_data

/obj/item/book/codebook
	name = "USS Almayer Code Book"
	author = "United States Colonial Marines"
	unique = 1
	dat = ""
	var/faction = FACTION_MARINE

/obj/item/book/codebook/Initialize()
	. = ..()
	title = name
	create_codebook(faction)

/obj/item/book/codebook/clf
	name = "Liberation Front Authenticators"
	faction = FACTION_CLF
	author = "\[Obscured Ink\]"

/obj/item/book/codebook/twe
	name = "Imperial Authentication Codes"
	faction = FACTION_TWE
	author = "Royal Marines"

/obj/item/book/codebook/upp
	name = "Union Authentication Codes"
	faction = FACTION_UPP
	author = "People's Army"

/obj/item/book/codebook/wey_yu
	name = "Corporate Authentication Codes"
	faction = FACTION_WY
	author = "Weyland-Yutani Communications Division"

/obj/item/book/codebook/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/tool/kitchen/knife) || HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		return
	..()
