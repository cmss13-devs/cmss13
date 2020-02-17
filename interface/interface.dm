//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if( config.wikiurl )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		to_chat(src, SPAN_DANGER("The wiki URL is not set in the server configuration."))
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if( config.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		to_chat(src, SPAN_DANGER("The forum URL is not set in the server configuration."))
	return

/client/verb/rules()
	set name = "rules"
	set desc = "Read our rules."
	set hidden = 1
	if( config.rulesurl )
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.rulesurl)
	else
		to_chat(src, SPAN_DANGER("The rules URL is not set in the server configuration."))
	return

/client/verb/discord()
	set name = "Discord"
	set desc = "Join our Discord! Meet and talk with other players in the server."
	set hidden = 1

	src << link("https://discordapp.com/invite/TByu8b5")
	return

/client/verb/submitbug()
	set name = "Submit Bug"
	set desc = "Submit a bug."
	set hidden = 1

	if(alert("Please search for the bug first to make sure you aren't posting a duplicate.",,"Ok","Cancel")=="Cancel")
		return
	src << link("https://gitlab.com/cmdevs/ColonialMarines/issues")
	return

/client/verb/set_fps()
	set name = "Set FPS"
	set desc = "Set client FPS. 20 is the default"
	set category = "Preferences"
	var/fps = input(usr,"New FPS Value. 0 is server-sync. Higher values cause more desync. Values over 30 not recommended.","Set FPS") as num
	if(world.byond_version >= 511 && byond_version >= 511 && fps >= MIN_FPS && fps <= MAX_FPS)
		vars["fps"] = fps
		prefs.fps = fps
		prefs.save_preferences()
	return

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tshift+e = sidearm equip
\tr = throw
\tt = say
\tx = swap-hand
\tz = activate held object (or y)
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tNum1 = swap target between right leg and right foot
\tNum2 = target groin
\tNum3 swap target between left leg and left foot
\tNum4 swap target between right arm and right hand
\tNum5 target chest
\tNum6 swap target between left arm and left hand
\tNum8 swap target between head, eyes, and mouth
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	src << hotkey_mode
	src << other
	if(admin_holder)
		src << admin

///Max length of a keypress command before it's considered to be a forged packet/bogus command
#define MAX_KEYPRESS_COMMANDLENGTH 16
///Max amount of keypress messages per second over two seconds before client is autokicked
#define MAX_KEYPRESS_AUTOKICK 50
///Length of held key rolling buffer
#define HELD_KEY_BUFFER_LENGTH 15

/client/var/client_keysend_amount = 0
/client/var/next_keysend_reset = 0
/client/var/next_keysend_trip_reset = 0
/client/var/keysend_tripped = FALSE

// Clients aren't datums so we have to define these procs indpendently.
// These verbs are called for all key press and release events
/client/verb/keyDown(_key as text)
	set instant = TRUE
	set hidden = TRUE

	client_keysend_amount += 1
		
	var/cache = client_keysend_amount

	if(keysend_tripped && next_keysend_trip_reset <= world.time)
		keysend_tripped = FALSE

	if(next_keysend_reset <= world.time)
		client_keysend_amount = 0
		next_keysend_reset = world.time + (1 SECONDS)

	//The "tripped" system is to confirm that flooding is still happening after one spike
	//not entirely sure how byond commands interact in relation to lag
	//don't want to kick people if a lag spike results in a huge flood of commands being sent
	if(cache >= MAX_KEYPRESS_AUTOKICK)
		if(!keysend_tripped)
			keysend_tripped = TRUE		
			next_keysend_trip_reset = world.time + (2 SECONDS)
		else
			message_admins("Client [ckey] was just autokicked for flooding keysends; likely abuse but potentially lagspike.")
			QDEL_IN(src, 1)
			return

	///Check if the key is short enough to even be a real key
	if(LAZYLEN(_key) > MAX_KEYPRESS_COMMANDLENGTH)
		message_admins("Client [ckey] just attempted to send an invalid keypress. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		QDEL_IN(src, 1)
		return

/client/verb/keyUp(_key as text)
	set instant = TRUE
	set hidden = TRUE