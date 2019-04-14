/obj/structure/prop/dam
	density = 1

/obj/structure/prop/dam/drill
	name = "mining drill"
	desc = "An old mining drill, seemingly used for mining. And possibly drilling."
	icon = 'icons/obj/structures/drill.dmi'
	icon_state = "drill"
	bound_height = 96

/obj/structure/prop/dam/truck
	name = "truck"
	desc = "An old truck, seems to be broken down."
	icon = 'icons/obj/structures/vehicles.dmi'
	icon_state = "truck"
	bound_height = 64
	bound_width = 64
	unacidable = 1

/obj/structure/prop/dam/truck/damaged
	icon_state = "truck_damaged"

/obj/structure/prop/dam/truck/mining
	name = "mining truck"
	desc = "An old mining truck, seems to be broken down."
	icon_state = "truck_mining"

/obj/structure/prop/dam/truck/cargo
	name = "cargo truck"
	desc = "An old cargo truck, seems to be broken down."
	icon_state = "truck_cargo"

/obj/structure/prop/dam/van
	name = "van"
	desc = "An old van, seems to be broken down."
	icon = 'icons/obj/structures/vehicles.dmi'
	icon_state = "van"
	bound_height = 64
	bound_width = 64
	unacidable = 1

/obj/structure/prop/dam/van/damaged
	icon_state = "van_damaged"

/obj/structure/prop/dam/crane
	name = "cargo crane"
	icon = 'icons/obj/structures/vehicles.dmi'
	icon_state = "crane"
	bound_height = 64
	bound_width = 64
	unacidable = 1

/obj/structure/prop/dam/crane/damaged
	icon_state = "crane_damaged"

/obj/structure/prop/dam/crane/cargo
	icon_state = "crane_cargo"

/obj/structure/prop/dam/torii
	name = "torii arch"
	desc = "A traditional japanese archway, made out of wood, and adorned with lanterns."
	icon = 'icons/obj/structures/torii.dmi'
	icon_state = "torii"
	density = 0
	pixel_x = -16
	layer = MOB_LAYER+0.5
	var/lit = 0

/obj/structure/prop/dam/torii/New()
	..()
	Update()

/obj/structure/prop/dam/torii/proc/Update()
	underlays.Cut()
	underlays += "shadow[lit ? "-lit" : ""]"
	icon_state = "torii[lit ? "-lit" : ""]"
	if(lit)
		SetLuminosity(6)
	else
		SetLuminosity(0)
	return

/obj/structure/prop/dam/torii/attack_hand(mob/user as mob)
	..()
	if(lit)
		lit = !lit
		visible_message("[user] extinguishes the lanterns on [src].",
			"You extinguish the fires on [src].")
		Update()
	return

/obj/structure/prop/dam/torii/attackby(obj/item/W, mob/user)
	..()
	var/L
	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn())
			L = 1
	else if(istype(W, /obj/item/tool/lighter/zippo))
		var/obj/item/tool/lighter/zippo/Z = W
		if(Z.heat_source)
			L = 1
	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/FL = W
		if(FL.heat_source)
			L = 1
	else if(istype(W, /obj/item/tool/lighter))
		var/obj/item/tool/lighter/G = W
		if(G.heat_source)
			L = 1
	else if(istype(W, /obj/item/tool/match))
		var/obj/item/tool/match/M = W
		if(M.heat_source)
			L = 1
	else if(istype(W, /obj/item/weapon/energy/sword))
		var/obj/item/weapon/energy/sword/S = W
		if(S.active)
			L = 1
	else if(istype(W, /obj/item/device/assembly/igniter))
		L = 1
	else if(istype(W, /obj/item/attachable/attached_gun/flamer))
		L = 1
	else if(istype(W, /obj/item/weapon/gun/flamer))
		var/obj/item/weapon/gun/flamer/F = W
		if(F.lit)
			L = 1
		else
			to_chat(user, "<span class='warning'>Turn on the pilot light first!</span>")

	else if(istype(W, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/G = W
		if(istype(G.under, /obj/item/attachable/attached_gun/flamer))
			L = 1
	else if(istype(W, /obj/item/tool/surgery/cautery))
		L = 1
	else if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = W
		if(C.item_state == C.icon_on)
			L = 1
	else if(istype(W, /obj/item/tool/candle))
		if(W.heat_source > 200)
			L = 1
	if(L)
		visible_message("[user] quietly goes from lantern to lantern on to torri, lighting the wicks in each one.")
		Update()
	return

/obj/structure/prop/dam/gravestone
	name = "grave marker"
	desc = "A grave marker, in the traditional japanese style."
	icon = 'icons/obj/structures/props.dmi'
	icon_state = "gravestone1"

/obj/structure/prop/dam/gravestone/New()
	..()
	icon_state = "gravestone[rand(1,4)]"

/obj/structure/prop/dam/boulder
	name = "boulder"
	icon_state = "boulder1"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/flora/dam.dmi'
	density = 0
	unacidable = 1
/obj/structure/prop/dam/boulder/boulder1
	icon_state = "boulder1"
/obj/structure/prop/dam/boulder/boulder2
	icon_state = "boulder2"
/obj/structure/prop/dam/boulder/boulder3
	icon_state = "boulder3"


/obj/structure/prop/dam/large_boulder
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/boulder_large.dmi'
	bound_height = 64
	bound_width = 64
	unacidable = 1
/obj/structure/prop/dam/large_boulder/boulder1
	icon_state = "boulder_large1"
/obj/structure/prop/dam/large_boulder/boulder2
	icon_state = "boulder_large2"

/obj/structure/prop/dam/wide_boulder
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/boulder_wide.dmi'
	bound_height = 32
	bound_width = 64
/obj/structure/prop/dam/wide_boulder/boulder1
	icon_state = "boulder1"