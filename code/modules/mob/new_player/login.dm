/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	if(!mind)
		mind = new /datum/mind(key, ckey)
		mind.active = 1
		mind.current = src
		mind_initialize()

	if(length(newplayer_start))
		loc = pick(newplayer_start)
	else
		loc = locate(1,1,1)
	lastarea = get_area(src.loc)

	sight |= SEE_TURFS

	. = ..()

	new_player_panel()

	spawn(40)
		if(client)
			// handle_privacy_poll() //This is in poll.dm and could be used to run polls for all first-time logins. It won't reappear after they vote.
			client.playtitlemusic()

			// To show them the full lobby art. This fixes itself on a mind transfer so no worries there.
			client.change_view(16)
			// Credit the lobby art author
			if(displayed_lobby_art != -1)
				var/author = "[lobby_art_authors[displayed_lobby_art]]"
				if(author != "Unknown")
					to_chat(src, SPAN_ROUNDBODY("<hr>This round's lobby art is brought to you by [author]<hr>"))
			if(join_motd)
				to_chat(src, "<div class=\"motd\">[join_motd]</div>")