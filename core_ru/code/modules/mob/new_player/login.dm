/mob/new_player/proc/exit_queue()
	close_spawn_windows()
	sleep(1 SECONDS)
	initialize_lobby_screen()

/mob/new_player/proc/queue_player_panel(refresh = FALSE)
	if(!client)
		return
	var/time_que = world.time - que_data.time_join
	var/output = "<div align='center'>Welcome,"
	output += "<br><b>[client.key]</b>"
	output += "<br><b>Players: [GLOB.clients.len - GLOB.que_clients]</b>"
	output += "<br><b>Start at: [time2text(que_data.time_join, "mm.ss")]</b>"
	output += "<br><b>Time: [time2text(time_que, "mm.ss")]</b>"
	output += "<br><b>Position: [que_data.position]</b>"
	output += "<br><b>Total: [length(SSqueue.queued)]</b>"
	if(GLOB.last_time_qued)
		output += "<br><b>Last time enter: [GLOB.last_time_qued]</b>"
	output += "</div>"
	if(refresh)
		close_browser(src, "que")
	show_browser(src, output, "Queue", "que", "size=240x500;can_close=0;can_minimize=0")
	return
