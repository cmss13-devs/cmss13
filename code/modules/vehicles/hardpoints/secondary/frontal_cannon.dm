/obj/item/hardpoint/gun/frontalcannon
	name = "Bleihagel RE-RE700 Frontal Cannon"
	desc = "The marketing department over at Bleihagel would have you believe that the RE-RE700 is an original design. However, experts who pried the cover off the cannon have discovered an object with a striking similarity to the popular M56 Cupola. It is still unknown why the cannon has two barrels."
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "front_cannon"
	disp_icon = "apc"
	disp_icon_state = "frontalcannon"
	firing_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg')

	slot = HDPT_SECONDARY

	point_cost = 400
	health = 350
	damage_multiplier = 0.125
	cooldown = 5
	accuracy = 0.7
	firing_arc = 90
	range_multiplier = 3

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon
	max_clips = 1

	muzzle_flash_pos = list(
		"1" = list(-13, 46),
		"2" = list(16, -76),
		"4" = list(62, -26),
		"8" = list(-62, -26)
	)
