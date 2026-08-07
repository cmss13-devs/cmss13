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
	name = "Elastic Band"
	icon_state = "blue_band"
	w_class = SIZE_TINY
	desc = "A blue elastic band, you have an urge to wrap it around two AK magazines..."

	jungle_mag_overlay_inactive_mag_offsets = list(4, -1)
	jungle_mag_overlay_is_blend_inset = TRUE
	jungle_mag_overlay_icon = 'icons/obj/items/weapons/guns/jungle_style_bind.dmi'
	jungle_mag_overlay_icon_state = "zipper_band_b"
