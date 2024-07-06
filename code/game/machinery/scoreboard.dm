/obj/structure/machinery/scoreboard
	icon = 'icons/obj/structures/machinery/scoreboard.dmi'
	icon_state = "scoreboard"
	name = "basketball scoreboard"
	anchored = TRUE
	density = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	var/id = ""

	var/scoreleft = 0
	var/scoreright = 0

/obj/structure/machinery/scoreboard/Initialize()
	. = ..()
	update_display()

/obj/structure/machinery/scoreboard/proc/update_display()
	LAZYCLEARLIST(overlays)

	var/score_state = "s[( floor(scoreleft/10) > scoreleft/10 ? floor(scoreleft/10)-1 : floor(scoreleft/10) )]a"
	overlays += image('icons/obj/structures/machinery/scoreboard.dmi', icon_state=score_state)
	score_state = "s[scoreleft%10]b"
	overlays += image('icons/obj/structures/machinery/scoreboard.dmi', icon_state=score_state)
	score_state = "s[( floor(scoreright/10) > scoreright/10 ? floor(scoreright/10)-1 : floor(scoreright/10) )]c"
	overlays += image('icons/obj/structures/machinery/scoreboard.dmi', icon_state=score_state)
	score_state = "s[scoreright%10]d"
	overlays += image('icons/obj/structures/machinery/scoreboard.dmi', icon_state=score_state)

/obj/structure/machinery/scoreboard/proc/score(side, points=2)
	switch(side)
		if("left")
			scoreleft += points
			if(scoreleft > 99)
				scoreleft %= 100
		if("right")
			scoreright += points
			if(scoreright > 99)
				scoreright %= 100
	update_display()

/obj/structure/machinery/scoreboard/proc/reset_scores()
	scoreleft = 0
	scoreright = 0
	update_display()

/obj/structure/machinery/scoreboard_button
	name = "scoreboard button"
	desc = "A remote control button to reset a scoreboard."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	var/id = null
	var/active = 0
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4

/obj/structure/machinery/scoreboard_button/attack_hand(mob/user as mob)
	if(inoperable())
		return
	if(active)
		return

	use_power(5)

	active = 1
	icon_state = "launcheract"

	for(var/obj/structure/machinery/scoreboard/X in GLOB.machines)
		if(X.id == id)
			X.reset_scores()

	sleep(50)

	icon_state = "launcherbtt"
	active = 0

	return
