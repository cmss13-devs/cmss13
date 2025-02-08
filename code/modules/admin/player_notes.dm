/proc/notes_add(key, note, mob/usr)
	if (!key || !note)
		return

	//Loading list of notes for this key
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos) infos = list()

	//Overly complex timestamp creation
	var/modifyer = "th"
	switch(time2text(world.timeofday, "DD"))
		if("01","21","31")
			modifyer = "st"
		if("02","22",)
			modifyer = "nd"
		if("03","23")
			modifyer = "rd"
	var/day_string = "[time2text(world.timeofday, "DD")][modifyer]"
	if(copytext(day_string,1,2) == "0")
		day_string = copytext(day_string,2)
	var/full_date = time2text(world.timeofday, "DDD, Month DD of YYYY")
	var/day_loc = findtext(full_date, time2text(world.timeofday, "DD"))

	var/datum/player_info/P = new
	if (usr)
		P.author = usr.key
		if(usr.client && usr.client.admin_holder && (usr.client.admin_holder.rights & R_MOD))
			P.rank = usr.client.admin_holder.rank
		else
			to_chat(usr, "NA01: Something went wrong, tell a coder.")
			return
	else
		P.author = "Adminbot"
		P.rank = "Friendly Robot"
	P.content = note
	P.timestamp = "[copytext(full_date,1,day_loc)][day_string][copytext(full_date,day_loc+2)]"

	infos += P
	info << infos

	message_admins("[key_name_admin(usr)] has edited [key]'s notes: [sanitize(note)]")
	qdel(info)

	//Updating list of keys with notes on them
	var/savefile/note_list = new("data/player_notes.sav")
	var/list/note_keys
	note_list >> note_keys
	if(!note_keys) note_keys = list()
	if(!note_keys.Find(key)) note_keys += key
	note_list << note_keys
	qdel(note_list)


/proc/notes_del(key, index)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(LAZYLEN(infos) < index) return

	var/datum/player_info/item = infos[index]
	infos.Remove(item)
	info << infos

	message_admins("[key_name_admin(usr)] deleted one of [key]'s notes.")

	qdel(info)

/proc/player_notes_show_irc(key as text)
	var/dat = "   Info on [key]%0D%0A"
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		dat = "No information found on the given key."
	else
		for(var/datum/player_info/I in infos)
			dat += "[I.content]%0D%0Aby [I.author] ([I.rank]) on [I.timestamp]%0D%0A%0D%0A"

	return dat
