/** # Beam Datum and Effect
 * **IF YOU ARE LAZY AND DO NOT WANT TO READ, GO TO THE BOTTOM OF THE FILE AND USE THAT PROC!**
 *
 * This is the beam datum! It's a really neat effect for the game in drawing a line from one atom to another.
 * It has two parts:
 * The datum itself which manages redrawing the beam to constantly keep it pointing from the origin to the target.
 * The effect which is what the beams are made out of. They're placed in a line from the origin to target, rotated towards the target and snipped off at the end.
 * These effects are kept in a list and constantly created and destroyed (hence the proc names draw and reset, reset destroying all effects and draw creating more.)
 *
 * You can add more special effects to the beam itself by changing what the drawn beam effects do. For example you can make a vine that pricks people by making the beam_type
 * include a crossed proc that damages the crosser. Examples in venus_human_trap.dm
*/
/datum/beam
	///where the beam goes from
	var/atom/origin = null
	///where the beam goes to
	var/atom/target = null
	///list of beam objects. These have their visuals set by the visuals var which is created on starting
	var/list/elements
	///icon used by the beam.
	var/icon
	///icon state of the main segments of the beam
	var/icon_state = ""
	///The beam will qdel if it's longer than this many tiles.
	var/max_distance = 0
	///the objects placed in the elements list
	var/beam_type = /obj/effect/ebeam
	///This is used as the visual_contents of beams, so you can apply one effect to this and the whole beam will look like that. never gets deleted on redrawing.
	var/obj/effect/ebeam/visuals
	///will the origin object always turn to face the target?
	var/always_turn = FALSE

/datum/beam/New(origin, target, icon='icons/effects/beam.dmi', icon_state="b_beam", time=BEAM_INFINITE_DURATION, max_distance=INFINITY, beam_type = /obj/effect/ebeam)
	src.origin = origin
	src.target = target
	src.max_distance = max_distance
	src.icon = icon
	src.icon_state = icon_state
	src.beam_type = beam_type
	elements = list()
	if(time > BEAM_INFINITE_DURATION)
		QDEL_IN(src, time)

/**
 * Proc called by the atom Beam() proc. Sets up signals, and draws the beam for the first time.
 */
/datum/beam/proc/Start()
	visuals = new beam_type()
	visuals.icon = icon
	visuals.icon_state = icon_state
	Draw()
	RegisterSignal(origin, COMSIG_MOVABLE_MOVED, PROC_REF(redrawing))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(redrawing))

/**
 * Triggered by signals set up when the beam is set up. If it's still sane to create a beam, it removes the old beam, creates a new one. Otherwise it kills the beam.
 *
 * Arguments:
 * mover: either the origin of the beam or the target of the beam that moved.
 * oldloc: from where mover moved.
 * direction: in what direction mover moved from.
 */
/datum/beam/proc/redrawing(atom/movable/mover, atom/oldloc, direction)
	if(origin && target && get_dist(origin,target)<max_distance && origin.z == target.z)
		QDEL_LIST(elements)
		Draw()
	else
		qdel(src)

/datum/beam/Destroy()
	QDEL_LIST(elements)
	qdel(visuals)
	UnregisterSignal(origin, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	target = null
	origin = null
	return ..()

/**
 * Creates the beam effects and places them in a line from the origin to the target. Sets their rotation to make the beams face the target, too.
 */
/datum/beam/proc/Draw()
	if(always_turn)
		origin.setDir(get_dir(origin, target)) //Causes the source of the beam to rotate to continuosly face the BeamTarget.
	var/Angle = round(Get_Angle(origin,target))
	var/matrix/rot_matrix = matrix()
	var/turf/origin_turf = get_turf(origin)
	rot_matrix.Turn(Angle)

	//Translation vector for origin and target
	var/DX = get_pixel_position_x(target) - get_pixel_position_x(origin)
	var/DY = get_pixel_position_y(target) - get_pixel_position_y(origin)
	var/N = 0
	var/length = round(sqrt((DX)**2+(DY)**2)) //hypotenuse of the triangle formed by target and origin's displacement

	for(N in 0 to length-1 step world.icon_size)//-1 as we want < not <=, but we want the speed of X in Y to Z and step X
		if(QDELETED(src))
			break
		var/obj/effect/ebeam/X = new beam_type(origin_turf)
		X.owner = src
		elements += X

		//Assign our single visual ebeam to each ebeam's vis_contents
		//ends are cropped by a transparent box icon of length-N pixel size laid over the visuals obj
		if(N + world.icon_size > length) //went past the target, we draw a box of space to cut away from the beam sprite so the icon actually ends at the center of the target sprite
			var/icon/II = new(icon, icon_state)//this means we exclude the overshooting object from the visual contents which does mean those visuals don't show up for the final bit of the beam...
			II.DrawBox(null,1,(length-N), world.icon_size, world.icon_size)//in the future if you want to improve this, remove the drawbox and instead use a 513 filter to cut away at the final object's icon
			X.icon = II
		else
			X.vis_contents += visuals
		X.transform = rot_matrix

		//Calculate pixel offsets (If necessary)
		var/Pixel_x
		var/Pixel_y
		if(DX == 0)
			Pixel_x = 0
		else
			Pixel_x = round(sin(Angle) + world.icon_size*sin(Angle)*(N+world.icon_size/2) / world.icon_size)
		if(DY == 0)
			Pixel_y = 0
		else
			Pixel_y = round(cos(Angle) + world.icon_size*cos(Angle)*(N+world.icon_size/2) / world.icon_size)

		//Position the effect so the beam is one continous line
		var/a
		if(abs(Pixel_x)>world.icon_size)
			a = Pixel_x > 0 ? round(Pixel_x/32) : CEILING(Pixel_x/world.icon_size, 1)
			X.x += a
			Pixel_x %= world.icon_size
		if(abs(Pixel_y)>world.icon_size)
			a = Pixel_y > 0 ? round(Pixel_y/32) : CEILING(Pixel_y/world.icon_size, 1)
			X.y += a
			Pixel_y %= world.icon_size

		X.pixel_x = Pixel_x + get_pixel_position_x(origin, relative = TRUE)
		X.pixel_y = Pixel_y + get_pixel_position_y(origin, relative = TRUE)

		CHECK_TICK

/obj/effect/ebeam
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	var/datum/beam/owner

/obj/effect/ebeam/laser
	name = "laser beam"
	desc = "A laser beam!"
	alpha = 200
	var/strength = EYE_PROTECTION_FLAVOR
	var/probability = 20

/obj/effect/ebeam/laser/Crossed(atom/movable/AM)
	. = ..()
	if(! (prob(probability) && ishuman(AM)) )
		return
	var/mob/living/carbon/human/moving_human = AM
	var/laser_protection = moving_human.get_eye_protection()
	var/rand_laser_power = rand(EYE_PROTECTION_FLAVOR, strength)
	if(rand_laser_power > laser_protection)
		//ouch!
		INVOKE_ASYNC(moving_human, /mob/proc/emote, "pain")
		visible_message(SPAN_DANGER("[moving_human] screams out in pain as \the [src] moves across their eyes!"), SPAN_NOTICE("Aurgh!!! \The [src] moves across your unprotected eyes for a split-second!"))
	else
		if(HAS_TRAIT(moving_human, TRAIT_BIMEX))
			visible_message(SPAN_NOTICE("[moving_human]'s BiMex© personal shades shine as \the [src] passes over them."), SPAN_NOTICE("Your BiMex© personal shades as \the [src] passes over them."))
			//drip = bonus balloonchat
			moving_human.balloon_alert_to_viewers("the laser bounces off [moving_human.gender == MALE ? "his" : "her"] BiMex© personal shades!", "the laser bounces off your BiMex© personal shades!")
		else
			visible_message(SPAN_NOTICE("[moving_human]'s headgear protects them from \the [src]."), SPAN_NOTICE("Your headgear protects you from  \the [src]."))

/obj/effect/ebeam/laser/intense
	name = "intense laser beam"
	alpha = 255
	strength = EYE_PROTECTION_FLASH
	probability = 35

/obj/effect/ebeam/laser/weak
	name = "weak laser beam"
	alpha = 150
	strength = EYE_PROTECTION_FLAVOR
	probability = 5

/obj/effect/ebeam/Destroy()
	owner = null
	return ..()

/obj/effect/overlay/beam //Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state="b_beam"
	mouse_opacity = FALSE

	var/tmp/atom/BeamSource

/obj/effect/overlay/beam/Initialize()
	..()
	QDEL_IN(src, 10)

/**
 * This is what you use to start a beam. Example: origin.Beam(target, args). **Store the return of this proc if you don't set maxdist or time, you need it to delete the beam.**
 *
 * Unless you're making a custom beam effect (see the beam_type argument), you won't actually have to mess with any other procs. Make sure you store the return of this Proc, you'll need it
 * to kill the beam.
 * **Arguments:**
 * BeamTarget: Where you're beaming from. Where do you get origin? You didn't read the docs, fuck you.
 * icon_state: What the beam's icon_state is. The datum effect isn't the ebeam object, it doesn't hold any icon and isn't type dependent.
 * icon: What the beam's icon file is. Don't change this, man. All beam icons should be in beam.dmi anyways.
 * maxdistance: how far the beam will go before stopping itself. Used mainly for two things: preventing lag if the beam may go in that direction and setting a range to abilities that use beams.
 * beam_type: The type of your custom beam. This is for adding other wacky stuff for your beam only. Most likely, you won't (and shouldn't) change it.
 */
/atom/proc/beam(atom/BeamTarget, icon_state="b_beam", icon='icons/effects/beam.dmi', time = BEAM_INFINITE_DURATION, maxdistance = INFINITY, beam_type=/obj/effect/ebeam, always_turn = TRUE)
	var/datum/beam/newbeam = new(src, BeamTarget, icon, icon_state, time, maxdistance, beam_type, always_turn)
	INVOKE_ASYNC(newbeam, TYPE_PROC_REF(/datum/beam, Start))
	return newbeam

/proc/zap_beam(atom/source, zap_range, damage, list/blacklistmobs)
	var/list/zap_data = list()
	for(var/mob/living/carbon/xenomorph/beno in oview(zap_range, source))
		zap_data += beno
	for(var/xeno in zap_data)
		var/mob/living/carbon/xenomorph/living = xeno
		if(!living)
			return
		if(living.stat == DEAD)
			continue
		if(living in blacklistmobs)
			continue
		source.beam(living, icon_state="lightning[rand(1,12)]", time = 3, maxdistance = zap_range + 2)
		living.set_effect(2, SLOW)
		log_attack("[living] was zapped by [source]")
