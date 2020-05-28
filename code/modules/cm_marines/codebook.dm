
/obj/item/book/codebook
	name = "Almayer Code Book"
	unique = 1
	dat = ""

/obj/item/book/codebook/New()
	var/number
	var/letter
	dat = "<table><tr><th>Call</th><th>Response<th></tr>"
	for(var/i in 1 to 10)
		letter = pick(greek_letters)
		number = rand(100,999)
		dat += "<tr><td>[letter]-[number]</td>"
		letter = pick(greek_letters)
		number = rand(100,999)
		dat += "<td>[letter]-[number]</td></tr>"

	dat += "</table>"


/obj/item/book/codebook/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/tool/kitchen/knife) || istype(W, /obj/item/tool/wirecutters))
		return
	..()
