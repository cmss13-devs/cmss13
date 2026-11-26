/obj/item/jungle_mag_binders //Note that it is not necessary for the binding item to be a subtype of this, you only need the item flag
	icon = 'icons/obj/items/weapons/guns/jungle_style_bind.dmi'
	flags_item = JUNGLE_MAG_BINDER

	var/list/jungle_mag_overlay_inactive_mag_offsets
	var/jungle_mag_overlay_is_blend_inset
	var/jungle_mag_overlay_icon
	var/jungle_mag_overlay_icon_state

	var/list/jungle_mag_magazine_blacklist
	var/list/jungle_mag_magazine_whitelist
	var/list/jungle_mag_storage_blacklist
	var/list/jungle_mag_storage_whitelist

/obj/item/jungle_mag_binders/elastic_band
	name = "elastic band"
	icon_state = "blue_band"
	w_class = SIZE_TINY
	desc = "A blue elastic band commonly used by USCM riflemen to wrap their magazines together, allowing them to swap between them in active combat. Voids the magazine's warranty."

	jungle_mag_overlay_inactive_mag_offsets = list(4, -1)
	jungle_mag_overlay_is_blend_inset = TRUE
	jungle_mag_overlay_icon = 'icons/obj/items/weapons/guns/jungle_style_bind.dmi'
	jungle_mag_overlay_icon_state = "zipper_band_b"

/obj/item/jungle_mag_binders/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Use [src] on a magazine to tie it with the band. Use a magazine on the resulting combination to tie them together, then you can load the bundled magazine to your gun!")

/obj/item/ammo_magazine/rifle/pre_bundled/Initialize(mapload, spawn_empty)
	. = ..()
	var/obj/item/jungle_mag_binders/elastic_band/jungle_band = new(get_turf(src))
	var/obj/item/ammo_magazine/rifle/bundled_mag = new(get_turf(src))
	AddComponent(/datum/component/jungle_magazine, null, jungle_band)
	attackby(bundled_mag)
