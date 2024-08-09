/particles/weather
	icon					= 'icons/effects/particles/particle.dmi'
	width					= 1000 // I think this is supposed to be in pixels, but it doesn't match bounds, so idk - 1000x1000 seems to prevent particle-less edges
	height					= 1000
	count					= 10000
	bound1					= list(-480, -480, -10)
	bound2					= list(480, 480, 10)

	var/new_wind			= 0
	var/last_wind			= 0
	var/timings				= list(0, 0)
	var/wind				= 0 //Left/Right maximum movement increase per tick
	var/max_spawning		= 0 //Max spawner - Recommend you use this over Spawning,so severity can ease it in
	var/min_spawning		= 0 //Weather should start with 0,but when easing,it will never go below this
	var/directional			= FALSE
	var/last_direction		= 1

	spawning				= 0
	lifespan				= 1040 // live for 2m max (fadein + lifespan + fade)
	fade					= 120 // 12s fade out
	fadein					= 40 // 4s fade in
	scale					= generator("vector", list(1, 1), list(2.5, 2.5), NORMAL_RAND)

	//Obnoxiously 3D -- INCREASE Z level to make them further away
	transform				= list(1, 0, 0, 0,
								   0, 1, 0, 0,
								   0, 0, 1, 1/10,//Get twice as Small every 10 Z
								   0, 0, 0, 1)

//Animate particle effect to a severity
/particles/weather/proc/animate_severity(severity_mod)
	var/direction_rand = pick(-1, 1)
	if(last_direction != direction_rand && prob(10))
		last_direction = direction_rand

	new_wind = Clamp(wind * (severity_mod * 0.25) * last_direction, 1, 50)
	START_PROCESSING(SSeffects, src)

/particles/weather/process()
	if(last_wind == new_wind)
		STOP_PROCESSING(SSeffects, src)
		return FALSE
	last_wind = last_wind + Clamp((new_wind - last_wind) * 0.05, 0.1, 10)
	if(new_wind < last_wind + 5 && new_wind > last_wind - 5)
		last_wind = new_wind
	return TRUE

//Rain - goes down
/particles/weather/rain
	icon_state				= "drop"
	color					= "#197385"
	lifespan				= 200
	transform				= null // Rain is directional - so don't make it "3D"

	max_spawning			= 400
	min_spawning			= 100
	wind					= 1
	directional				= TRUE

	gravity					= list(0, -6, 0)
	position				= generator("box", list(-480, 480, 0), list(480, 480, 0), NORMAL_RAND)
	grow					= list(-0.01, -0.01)
	drift					= list(0, 0, 0)
	spin					= 0

/particles/weather/rain/process()
	. = ..()
	if(!.)
		return

	rotation = last_wind
	spin = rotation * -0.1
	gravity[1] = rotation * -0.1
	if(prob(30))
		drift[1] = rotation * 0.02
	else
		drift[1] = rotation * 0.02 / 2
	lifespan = 200 + gravity[2] * 16.5
	fade = 240 + gravity[2] * 20
	fadein = generator("num", 70 + gravity[2] * 3.3, 140 + gravity[2] * 6.6, NORMAL_RAND)
	spawning = Clamp(gravity[2] / 6 * (last_wind / wind / last_direction), min_spawning,  max_spawning)
	return .

/particles/weather/rain/storm
	color					= "#184d7c"

	max_spawning			= 800
	min_spawning			= 200
	wind					= 1.5

//Snow - goes down and swirls
/particles/weather/snow
	icon_state				= list("cross" = 2, "snow_1" = 5, "snow_2" = 2, "snow_3" = 2,)
	color					= "#ffffff"
	position				= generator("box", list(-480, -480, 5), list(480, 480, 0))
	spin					= generator("num", -10, 10)
	gravity					= list(0, -2, 0.1)
	drift					= generator("circle", 0, 3) // Some random movement for variation
	friction				= 0.3  // shed 30% of velocity and drift every 0.1s

	max_spawning			= 200
	min_spawning			= 20
	wind					= 2

/particles/weather/snow/process()
	. = ..()
	if(!.)
		return

	gravity[1] = last_wind
	spawning = Clamp(max_spawning * (last_wind / last_direction * 0.01), min_spawning, max_spawning)
	return .

/particles/weather/snow/storm
	drift					= generator("circle", 0, 3.5) // Some random movement for variation
	friction				= 0.15  // shed 30% of velocity and drift every 0.1s
	scale					= generator("vector", list(2, 2), list(4, 4), NORMAL_RAND)

	max_spawning			= 400
	min_spawning			= 50
	wind					= 4

//Dust - goes sideways and swirls
/particles/weather/dust
	icon_state				= list("dot" = 5, "cross" = 1)
	gradient				= list(0, "#422a1de3", 10, "#853e1be3", "loop")
	color					= 0
	color_change			= generator("num", 0,3)
	spin					= generator("num", -5, 5)
	position				= generator("box", list(-480, -480, 5), list(480, 480, 0))
	gravity					= list(-5, -1, 0.1)
	drift					= generator("circle", 0, 3) // Some random movement for variation
	friction				= 0.3  // shed 30% of velocity and drift every 0.1s

	max_spawning			= 120
	min_spawning			= 20
	wind					= 10

/particles/weather/dust/process()
	. = ..()
	if(!.)
		return

	gravity[1] = last_wind
	spawning = Clamp(max_spawning * (last_wind / last_direction * 0.01), min_spawning, max_spawning)
	return .

//Rads - goes fucking everywhere
/particles/weather/rads
	icon_state				= list("dot" = 5, "cross" = 1)

	gradient				= list(0, "#54d832", 1, "#1f2720", 2, "#aad607", 3, "#5f760d", 4, "#484b3f", "loop")
	color					= 0
	color_change			= generator("num", -5, 5)
	position				= generator("box", list(-480, -480, 5), list(480, 480, 0))
	gravity					= list(-5, -1, 0.1)
	drift					= generator("circle", 0, 5) // Some random movement for variation
	friction				= 0.3  // shed 30% of velocity and drift every 0.1s

	max_spawning			= 120
	min_spawning			= 20
	wind					= 10
