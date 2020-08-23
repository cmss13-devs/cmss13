/obj/effect/overlay
	name = "overlay"
	unacidable = TRUE
	var/i_attached //Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state="b_beam"
	var/tmp/atom/BeamSource
	New()
		..()
		QDEL_IN(src, 10)

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/turf/beach2.dmi'
	icon_state = "palm1"
	density = 1
	layer = FLY_LAYER
	anchored = 1

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/turf/beach2.dmi'
	icon_state = "palm2"
	density = 1
	layer = FLY_LAYER
	anchored = 1

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/turf/floors/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/danger
	name = "Danger"
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "danger"
	layer = ABOVE_FLY_LAYER

/obj/effect/overlay/temp
	anchored = 1
	layer = ABOVE_FLY_LAYER //above mobs
	mouse_opacity = 0 //can't click to examine it
	var/effect_duration = 10 //in deciseconds

	New()
		..()
		flick(icon_state, src)
		start_countdown()

/obj/effect/overlay/temp/proc/start_countdown()
	set waitfor = 0
	sleep(effect_duration)
	qdel(src)

/obj/effect/overlay/temp/point
	name = "arrow"
	desc = "It's an arrow hanging in mid-air. There may be a wizard about."
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "arrow"
	anchored = 1
	effect_duration = 25

/obj/effect/overlay/temp/point/big
	icon_state = "big_arrow"
	effect_duration = 40

//Special laser for coordinates, not for CAS
/obj/effect/overlay/temp/laser_coordinate
	name = "laser"
	anchored = TRUE
	mouse_opacity = 1
	luminosity = 2
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "laser_target_coordinate"
	effect_duration = 600
	var/obj/item/device/binoculars/range/designator/source_binoc

/obj/effect/overlay/temp/laser_coordinate/Dispose()
	if(source_binoc)
		source_binoc.laser_cooldown = world.time + source_binoc.cooldown_duration
		source_binoc.coord = null
		source_binoc = null
	SetLuminosity(0)
	. = ..()

/obj/effect/overlay/temp/laser_target
	name = "laser"
	anchored = TRUE
	mouse_opacity = 1
	luminosity = 2
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "laser_target2"
	effect_duration = 600
	var/target_id
	var/obj/item/device/binoculars/range/designator/source_binoc
	var/datum/cas_signal/signal
	var/mob/living/carbon/human/user

/obj/effect/overlay/temp/laser_target/New(loc, squad_name, _user, tracking_id)
	..()
	user = _user
	if(squad_name)
		name = "[squad_name] laser"
	if(user && user.faction && cas_groups[user.faction])
		signal = new(src)
		signal.name = name
		signal.target_id = tracking_id
		signal.linked_cam = new(loc, name)
		signal.linked_cam.invisibility = 101
		signal.linked_cam.unslashable = TRUE
		signal.linked_cam.unacidable = TRUE
		cas_groups[user.faction].add_signal(signal)
			

/obj/effect/overlay/temp/laser_target/Dispose()
	if(signal)
		cas_groups[user.faction].remove_signal(signal)
		if(signal.linked_cam)
			qdel(signal.linked_cam)
			signal.linked_cam = null
		qdel(signal)
		signal = null
	if(source_binoc)
		source_binoc.laser_cooldown = world.time + source_binoc.cooldown_duration
		source_binoc.laser = null
		source_binoc = null
	
	SetLuminosity(0)
	. = ..()

/obj/effect/overlay/temp/laser_target/ex_act(severity) //immune to explosions
	return

/obj/effect/overlay/temp/laser_target/examine()
	..()
	if(ishuman(usr))
		to_chat(usr, SPAN_DANGER("It's a laser to designate artillery targets, get away from it!"))


//used to show where dropship ordnance will impact.
/obj/effect/overlay/temp/blinking_laser
	name = "blinking laser"
	anchored = TRUE
	luminosity = 2
	effect_duration = 10
	mouse_opacity = 0
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "laser_target3"

/obj/effect/overlay/temp/blinking_laser/Dispose()
	SetLuminosity(0)
	. = ..()

/obj/effect/overlay/temp/emp_sparks
	icon = 'icons/effects/effects.dmi'
	icon_state = "empdisable"
	name = "emp sparks"
	effect_duration = 10

	New(loc)
		dir = pick(cardinal)
		..()

/obj/effect/overlay/temp/emp_pulse
	name = "emp pulse"
	icon = 'icons/effects/effects.dmi'
	icon_state = "emppulse"
	effect_duration = 20




//gib animation

/obj/effect/overlay/temp/gib_animation
	icon = 'icons/mob/mob.dmi'
	effect_duration = 14

/obj/effect/overlay/temp/gib_animation/New(Loc, mob/source_mob, gib_icon)
	pixel_x = source_mob.pixel_x
	pixel_y = source_mob.pixel_y
	icon_state = gib_icon
	..()

/obj/effect/overlay/temp/gib_animation/ex_act(severity)
	return


/obj/effect/overlay/temp/gib_animation/animal
	icon = 'icons/mob/animal.dmi'
	effect_duration = 12


/obj/effect/overlay/temp/gib_animation/xeno
	icon_source = "alien_gib_48x48"
	effect_duration = 10

/obj/effect/overlay/temp/gib_animation/xeno/New(Loc, mob/source_mob, gib_icon, new_icon)
	icon = new_icon
	..()



//dust animation

/obj/effect/overlay/temp/dust_animation
	icon = 'icons/mob/mob.dmi'
	effect_duration = 12

/obj/effect/overlay/temp/dust_animation/New(Loc, mob/source_mob, gib_icon)
	pixel_x = source_mob.pixel_x
	pixel_y = source_mob.pixel_y
	icon_state = gib_icon
	..()

//acid pool splash animation

/obj/effect/overlay/temp/acid_pool_splash
	name = "acid splash"
	icon_source = "alien_effects"
	icon_state = "acidpoolsplash"
	effect_duration = SECONDS_10
