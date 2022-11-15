//**********************************************************************
//						Cyborg Spec Items
//***********************************************************************/
//Might want to move this into several files later but for now it works here
/obj/item/robot/stun
	name = "electrified arm"
	icon = 'icons/obj/structures/props/decals.dmi'
	icon_state = "shock"

	attack(mob/M as mob, mob/living/silicon/robot/user as mob)
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
		msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] to attack [M.name] ([M.ckey])  in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		user.cell.charge -= 30

		playsound(M.loc, 'sound/weapons/Egloves.ogg', 25, 1, 4)
		M.KnockDown(5)
		if (M.stuttering < 5)
			M.stuttering = 5
		M.Stun(5)

		for(var/mob/O in viewers(M, null))
			if (O.client)
				O.show_message(SPAN_DANGER("<B>[user] has prodded [M] with an electrically-charged arm!</B>"), 1, SPAN_DANGER("You hear someone fall"), 2)

/obj/item/robot/overdrive
	name = "overdrive"
	icon = 'icons/obj/structures/props/decals.dmi'
	icon_state = "shock"

//**********************************************************************
//						HUD/SIGHT things
//***********************************************************************/
/obj/item/robot/sight
	icon = 'icons/obj/structures/props/decals.dmi'
	icon_state = "securearea"
	var/sight_mode = null


/obj/item/robot/sight/xray
	name = "\proper x-ray Vision"
	sight_mode = BORGXRAY


/obj/item/robot/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon_state = "thermal"
	icon = 'icons/obj/items/clothing/glasses.dmi'


/obj/item/robot/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "meson"
	icon = 'icons/obj/items/clothing/glasses.dmi'

/obj/item/robot/sight/hud
	name = "hud"
	var/obj/item/clothing/glasses/hud/hud = null


/obj/item/robot/sight/hud/med
	name = "medical hud"
	icon_state = "healthhud"
	icon = 'icons/obj/items/clothing/glasses.dmi'

	New()
		..()
		hud = new /obj/item/clothing/glasses/hud/health(src)
		return


/obj/item/robot/sight/hud/sec
	name = "security hud"
	icon_state = "securityhud"
	icon = 'icons/obj/items/clothing/glasses.dmi'

	New()
		..()
		hud = new /obj/item/clothing/glasses/hud/security(src)
		return
