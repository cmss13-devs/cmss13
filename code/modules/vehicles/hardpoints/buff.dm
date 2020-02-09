/obj/item/hardpoint/buff
	name = "buffing hardpoint"
	desc = "ok :)"

/obj/item/hardpoint/buff/on_install(var/obj/vehicle/multitile/V)
	apply_buff(V)

/obj/item/hardpoint/buff/on_uninstall(var/obj/vehicle/multitile/V)
	remove_buff(V)

/obj/item/hardpoint/buff/proc/apply_buff(var/obj/vehicle/multitile/V)
	return

obj/item/hardpoint/buff/proc/remove_buff(var/obj/vehicle/multitile/V)
	return
