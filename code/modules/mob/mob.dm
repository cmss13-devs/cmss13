/mob/Destroy()//This makes sure that mobs with clients/keys are not just deleted from the game.
	GLOB.mob_list -= src
	GLOB.dead_mob_list -= src
	GLOB.alive_mob_list -= src
	GLOB.player_list -= src

	if(mind)
		if(mind.current == src)
			mind.current = null
		if(mind.original == src)
			mind.original = null

	QDEL_NULL(hud_used)

	if(open_uis)
		for(var/datum/nanoui/ui in open_uis)
			ui.close()
			qdel(ui)
		open_uis = null

	interactee = null

	last_damage_source = null
	last_damage_mob = null

	ghostize()
	clear_fullscreens()
	return ..()

/mob/Initialize()
	if(!faction_group)
		faction_group = list(faction)

	last_mob_gid++
	gid = last_mob_gid

	GLOB.mob_list += src
	if(stat == DEAD)
		GLOB.dead_mob_list += src
	else
		GLOB.alive_mob_list += src
		life_time_start = world.time
	var/area/current_area = get_area(loc)
	if(current_area)
		current_area.Entered(src)
	if(!isnull(current_area) && current_area.statistic_exempt)
		statistic_exempt = TRUE
	prepare_huds()
	return ..()

/mob/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_IS_OTHER
		PF.flags_can_pass_all = PASS_MOB_THRU_OTHER|PASS_AROUND|PASS_HIGH_OVER_ONLY

/mob/Stat()
	if(!client)
		return FALSE
	if(client.admin_holder && client.inactivity < 1200)
		if(client.admin_holder && client.admin_holder.rights & R_DEBUG && client.prefs.View_MC) //Skip admins, and check for our pref.
			if(statpanel("MC"))
				stat("CPU:", "[world.cpu]")
				stat("Instances:", "[num2text(length(world.contents), 10)]")
				stat("World Time:", "[world.time]")
				GLOB.stat_entry()
				config.stat_entry()
				stat(null)
				if(Master)
					Master.stat_entry()
				else
					stat("Master Controller:", "ERROR")
				if(Failsafe)
					Failsafe.stat_entry()
				else
					stat("Failsafe Controller:", "ERROR")
				if(Master)
					stat(null)
					for(var/datum/controller/subsystem/SS in Master.subsystems)
						SS.stat_entry()

	// Looking at contents of a tile
	if (tile_contents_change)
		tile_contents_change = 0
		statpanel("Tile Contents")
		client.statpanel = "Tile Contents"
		stat(tile_contents)
		client.stat_force_fast_update = 1
		return 0

	if (client.statpanel == "Tile Contents")
		if (tile_contents.len && statpanel("Tile Contents"))
			stat(tile_contents)
			return 0

	if (statpanel("Stats"))
		return 1

	sleep(world.tick_lag * 2)

	return 0

/mob/proc/prepare_huds()
	hud_list = new
	for(var/hud in hud_possible)
		hud_list[hud] = image('icons/mob/hud/hud.dmi', src, "")

/mob/proc/show_message(msg, type, alt, alt_type, message_flags = CHAT_TYPE_OTHER)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)

	if(!client || !client.prefs)	return

	if (type)
		if(type & 1 && (sdisabilities & BLIND || blinded) )//Vision related
			if (!alt)
				return
			else
				msg = alt
				type = alt_type
		if (type & 2 && (sdisabilities & DEAF || ear_deaf))//Hearing related
			if (!alt)
				return
			else
				msg = alt
				type = alt_type
				if (type & 1 && (sdisabilities & BLIND))
					return
	if(message_flags == CHAT_TYPE_OTHER || client.prefs && (message_flags & client.prefs.chat_display_preferences) > 0) // or logic between types
		if(stat == UNCONSCIOUS)
			to_chat(src, "<I>... You can almost hear someone talking ...</I>")
		else
			to_chat(src, msg)


// Show a message to all mobs in sight of this one
// This would be for visible actions by the src mob
// message is the message output to anyone who can see e.g. "[src] does something!"
// self_message (optional) is what the src mob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"

/mob/visible_message(message, self_message, blind_message, max_distance, message_flags = CHAT_TYPE_OTHER)
	var/view_dist = 7
	var/flags = message_flags
	if(max_distance) view_dist = max_distance
	for(var/mob/M in viewers(view_dist, src))
		var/msg = message
		if(self_message && M==src)
			msg = self_message
			if(flags & CHAT_TYPE_TARGETS_ME)
				flags = CHAT_TYPE_BEING_HIT
		M.show_message( msg, 1, blind_message, 2, flags)
		CHECK_TICK
	for(var/obj/vehicle/V in orange(max_distance))
		for(var/mob/M in V.contents)
			var/msg = message
			if(self_message && M==src)
				msg = self_message
				if(flags & CHAT_TYPE_TARGETS_ME)
					flags = CHAT_TYPE_BEING_HIT
			M.show_message( msg, 1, blind_message, 2, flags)
		CHECK_TICK

// Shows three different messages depending on who does it to who and how does it look like to outsiders
// message_mob: "You do something to X!"
// message_affected: "Y does something to you!"
// message_viewer: "X does something to Y!"
/mob/proc/affected_message(mob/affected, message_mob, message_affected, message_viewer)
	src.show_message(message_mob, 1)
	if(src != affected)
		affected.show_message(message_affected, 1)
	for(var/mob/V in viewers(7, src))
		if(V != src && V != affected)
			V.show_message(message_viewer, 1)

// Show a message to all mobs in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(message, blind_message, max_distance, message_flags = CHAT_TYPE_OTHER)
	var/view_dist = 7
	if(max_distance) view_dist = max_distance
	for(var/mob/M in viewers(view_dist, src))
		M.show_message(message, 1, blind_message, 2, message_flags)

/atom/proc/ranged_message(message, blind_message, max_distance, message_flags = CHAT_TYPE_OTHER)
	var/view_dist = 7
	if(max_distance) view_dist = max_distance
	for(var/mob/M in orange(view_dist, src))
		M.show_message(message, 1, blind_message, 2, message_flags)


/mob/proc/findname(msg)
	for(var/mob/M in GLOB.mob_list)
		if (M.real_name == text("[]", msg))
			return M
	return 0

/mob/proc/movement_delay()
	if(!legcuffed)
		. = 2 + CONFIG_GET(number/run_speed)
	else
		. = 7 + CONFIG_GET(number/walk_speed)
	. += speed
	move_delay = .

/mob/proc/Life()
	if(client == null)
		away_timer++
	else
		away_timer = 0
	return

//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_hand()
	if(istype(W))
		equip_to_slot_if_possible(W, slot, 0) // equiphere

/mob/proc/put_in_any_hand_if_possible(obj/item/W as obj, del_on_fail = 0, disable_warning = 1, redraw_mob = 1)
	if(equip_to_slot_if_possible(W, WEAR_L_HAND, 1, del_on_fail, disable_warning, redraw_mob))
		return 1
	else if(equip_to_slot_if_possible(W, WEAR_R_HAND, 1, del_on_fail, disable_warning, redraw_mob))
		return 1
	return 0

//This is a SAFE proc. Use this instead of equip_to_splot()!
//set del_on_fail to have it delete W if it fails to equip
//set disable_warning to disable the 'you are unable to equip that' warning.
//unset redraw_mob to prevent the mob from being redrawn at the end.
/mob/proc/equip_to_slot_if_possible(obj/item/W, slot, ignore_delay = 1, del_on_fail = 0, disable_warning = 0, redraw_mob = 1, permanent = 0)
	if(!istype(W))
		return FALSE

	if(!W.mob_can_equip(src, slot, disable_warning))
		if(del_on_fail)
			qdel(W)
		else if(!disable_warning)
			to_chat(src, SPAN_WARNING("You are unable to equip that.")) //Only print if del_on_fail is false
		return FALSE

	var/start_loc = W.loc

	if(W.time_to_equip && !ignore_delay)
		INVOKE_ASYNC(src, .proc/equip_to_slot_timed, W, slot, redraw_mob, permanent, start_loc)
		return TRUE

	equip_to_slot(W, slot, redraw_mob) //This proc should not ever fail.
	if(permanent)
		W.flags_inventory |= CANTSTRIP
		W.flags_item |= NODROP
	if(W.loc == start_loc && get_active_hand() != W)
		//They moved it from hands to an inv slot or vice versa. This will unzoom and unwield items -without- triggering lights.
		if(W.zoom)
			W.zoom(src)
		if(W.flags_item & TWOHANDED)
			W.unwield(src)
	return TRUE

//This is an UNSAFE proc. It handles situations of timed equips.
/mob/proc/equip_to_slot_timed(obj/item/W, slot, redraw_mob = 1, permanent = 0, start_loc)
	if(!do_after(src, W.time_to_equip, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(src, "You stop putting on \the [W]")
	equip_to_slot(W, slot, redraw_mob) //This proc should not ever fail.
	if(permanent)
		W.flags_inventory |= CANTSTRIP
		W.flags_item |= NODROP
	if(W.loc == start_loc && get_active_hand() != W)
		//They moved it from hands to an inv slot or vice versa. This will unzoom and unwield items -without- triggering lights.
		if(W.zoom)
			W.zoom(src)
		if(W.flags_item & TWOHANDED)
			W.unwield(src)

//This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on whether you can or can't eqip need to be done before! Use mob_can_equip() for that task.
//In most cases you will want to use equip_to_slot_if_possible()
/mob/proc/equip_to_slot(obj/item/W as obj, slot)
	return

//This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to equip people when the rounds tarts and when events happen and such.
/mob/proc/equip_to_slot_or_del(obj/item/W, slot, permanent = 0)
	return equip_to_slot_if_possible(W, slot, 1, 1, 1, 0, permanent)



//puts the item "W" into an appropriate slot in a human's inventory
//returns 0 if it cannot, 1 if successful
/mob/proc/equip_to_appropriate_slot(obj/item/W, ignore_delay = 1, var/list/slot_equipment_priority = DEFAULT_SLOT_PRIORITY)
	if(!istype(W)) return 0

	for(var/slot in slot_equipment_priority)
		if(equip_to_slot_if_possible(W, slot, ignore_delay, 0, 1, 1)) //del_on_fail = 0; disable_warning = 0; redraw_mob = 1
			return 1

	return 0

/mob/proc/reset_view(atom/A)
	if(SEND_SIGNAL(src, COMSIG_MOB_RESET_VIEW, A) & COMPONENT_OVERRIDE_VIEW) return TRUE

	if (client)
		if (istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
		else
			if (isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
	return


/mob/proc/show_inv(mob/user)
	user.set_interaction(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	show_browser(user, dat, name, "mob[name]")
	return



/mob/proc/point_to_atom(atom/A, turf/T)
	//Squad Leaders and above have reduced cooldown and get a bigger arrow
	if(!skillcheck(src, SKILL_LEADERSHIP, SKILL_LEAD_TRAINED))
		recently_pointed_to = world.time + 50
		new /obj/effect/overlay/temp/point(T, src)

	else
		recently_pointed_to = world.time + 10
		new /obj/effect/overlay/temp/point/big(T, src)
	visible_message("<b>[src]</b> points to [A]", null, null, 5)
	return 1


/mob/proc/update_flavor_text()
	set src in usr
	if(usr != src)
		to_chat(usr, "No.")
	var/msg = input(usr,"Set the flavor text in your 'examine' verb. Can also be used for OOC notes about your character.","Flavor Text",html_decode(flavor_text)) as message|null

	if(msg != null)
		msg = copytext(msg, 1, MAX_MESSAGE_LEN)
		msg = html_encode(msg)

		flavor_text = msg

/mob/proc/warn_flavor_changed()
	if(flavor_text && flavor_text != "") // don't spam people that don't use it!
		to_chat(src, "<h2 class='alert'>OOC Warning:</h2>")
		to_chat(src, SPAN_ALERT("Your flavor text is likely out of date! <a href='byond://?src=\ref[src];flavor_change=1'>Change</a>"))

/mob/proc/print_flavor_text()
	if (flavor_text && flavor_text != "")
		var/msg = replacetext(flavor_text, "\n", " ")
		if(length(msg) <= 40)
			return SPAN_NOTICE("[msg]")
		else
			return SPAN_NOTICE("[copytext(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a>")



/client/verb/changes()
	set name = "Changelog"
	set category = "OOC"

	var/datum/asset/simple/changelog = get_asset_datum(/datum/asset/simple/changelog)
	changelog.send(src)

	var/changelog_html = file2text('html/changelog.html')

	show_browser(src, changelog_html, null, "changes", "size=675x650")
	if(prefs.lastchangelog != changelog_hash)
		prefs.lastchangelog = changelog_hash
		prefs.save_preferences()
		winset(src, "rpane.changelog", "background-color=none;font-style=;")

/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = href_list["mach_close"]
		unset_interaction()
		close_browser(src, t1)

	if(href_list["flavor_more"])
		show_browser(usr, "<BODY><TT>[replacetext(flavor_text, "\n", "<BR>")]</TT></BODY>", name, name, "size=500x200")
		onclose(usr, "[name]")
	if(href_list["flavor_change"])
		update_flavor_text()
	return


/mob/MouseDrop(mob/M)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(!ishuman(M) && !ismonkey(M)) return
	if(!ishuman(src) && !ismonkey(src)) return
	if(M.lying || M.is_mob_incapacitated())
		return
	if(M.pulling == src && (M.a_intent & INTENT_GRAB) && M.grab_level == GRAB_AGGRESSIVE)
		return

	show_inv(M)

/mob/proc/swap_hand()
	hand = !hand

//attempt to pull/grab something. Returns true upon success.
/mob/proc/start_pulling(atom/movable/AM, lunge, no_msg)
	return

/mob/living/start_pulling(atom/movable/clone/AM, lunge, no_msg)
	if(istype(AM, /atom/movable/clone))
		AM = AM.mstr //If AM is a clone, refer to the real target

	if ( QDELETED(AM) || !usr || src==AM || !isturf(loc) || !isturf(AM.loc) )	//if there's no person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return

	if (AM.anchored || AM.throwing)
		return

	if(throwing || is_mob_incapacitated())
		return

	if(pulling)
		// Are we pulling the same thing twice? Just stop pulling.
		if(pulling == AM)
			var/obj/item/grab/G = get_active_hand()
			if(istype(G))
				G.attack_self(src)
			else
				stop_pulling()

			if(client)
				client.recalculate_move_delay()

			return
		else
			stop_pulling()

	var/mob/M
	if(ismob(AM))
		M = AM
	else if(istype(AM, /obj))
		AM.add_fingerprint(src)

	if(!QDELETED(AM.pulledby) && !QDELETED(M))
		visible_message(SPAN_WARNING("[src] has broken [AM.pulledby]'s grip on [M]!"), null, null, 5)
		AM.pulledby.stop_pulling()

	var/pull_response = AM.pull_response(src)
	if(!pull_response) // If I'm not allowed to pull you I won't. Stop here.
		return FALSE

	pulling = AM
	AM.pulledby = src

	var/obj/item/grab/G = new /obj/item/grab()
	G.grabbed_thing = AM
	if(!put_in_hands(G)) //placing the grab in hand failed, grab is dropped, deleted, and we stop pulling automatically.
		recalculate_move_delay = TRUE
		return

	if(client)
		client.recalculate_move_delay()

	if(!QDELETED(M))
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)

		flick_attack_overlay(M, "grab")

		attack_log += "\[[time_stamp()]\]<font color='green'> Grabbed [key_name(M)]</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Grabbed by [key_name(src)]</font>"
		msg_admin_attack("[key_name(src)] grabbed [key_name(M)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

		if(!no_msg)
			visible_message(SPAN_WARNING("[src] has grabbed [M] passively!"), null, null, 5)

		if(M.mob_size > MOB_SIZE_HUMAN || !(M.status_flags & CANPUSH))
			G.icon_state = "!reinforce"

		//Attempted fix for people flying away through space when cuffed and dragged.
		M.inertia_dir = 0

	if(hud_used && hud_used.pull_icon)
		hud_used.pull_icon.icon_state = "pull1"
	return AM.pull_response(src) //returns true if the response doesn't break the pull. Asked again in case actually being pulled changes the answer.

//how a movable atom reacts to being pulled.
//returns true if the pull isn't severed by the response
/atom/movable/proc/pull_response(mob/puller)
	return TRUE


/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		if(!M.stat)
			to_chat(src, message)


/*
adds a dizziness amount to a mob
use this rather than directly changing var/dizziness
since this ensures that the dizzy_process proc is started
currently only humans get dizzy

value of dizziness ranges from 0 to 1000
below 100 is not dizzy
*/
/mob/proc/make_dizzy(var/amount)
	if(!istype(src, /mob/living/carbon/human)) // for the moment, only humans get dizzy
		return

	dizziness = min(1000, dizziness + amount)	// store what will be new value
													// clamped to max 1000
	if(dizziness > 100 && !is_dizzy)
		INVOKE_ASYNC(src, .proc/dizzy_process)


/*
dizzy process - wiggles the client's pixel offset over time
spawned from make_dizzy(), will terminate automatically when dizziness gets <100
note dizziness decrements automatically in the mob's Life() proc.
*/
/mob/proc/dizzy_process()
	is_dizzy = 1
	while(dizziness > 100)
		if(client)
			var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70
			client.pixel_x = amplitude * sin(0.008 * dizziness * world.time)
			client.pixel_y = amplitude * cos(0.008 * dizziness * world.time)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_dizzy = 0
	if(client)
		client.pixel_x = 0
		client.pixel_y = 0

// jitteriness - copy+paste of dizziness

/mob/proc/make_jittery(var/amount)
	return

/mob/proc/remove_jittery()
	jitteriness = 0
	return

/mob/living/carbon/human/make_jittery(var/amount)
	if(stat == DEAD) return //dead humans can't jitter
	jitteriness = min(1000, jitteriness + amount)	// store what will be new value
													// clamped to max 1000
	if(jitteriness > 100 && !is_jittery)
		INVOKE_ASYNC(src, .proc/jittery_process)


// Typo from the oriignal coder here, below lies the jitteriness process. So make of his code what you will, the previous comment here was just a copypaste of the above.
/mob/proc/jittery_process()
	//var/old_x = pixel_x
	//var/old_y = pixel_y
	is_jittery = 1
	while(jitteriness > 100)
//		var/amplitude = jitteriness*(sin(jitteriness * 0.044 * world.time) + 1) / 70
//		pixel_x = amplitude * sin(0.008 * jitteriness * world.time)
//		pixel_y = amplitude * cos(0.008 * jitteriness * world.time)

		var/amplitude = min(4, jitteriness / 100)
		pixel_x = old_x + rand(-amplitude, amplitude)
		pixel_y = old_y + rand(-amplitude/3, amplitude/3)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_jittery = 0
	pixel_x = old_x
	pixel_y = old_y


//handles up-down floaty effect in space
/mob/proc/make_floating(var/n)

	floatiness = n

	if(floatiness && !is_floating)
		start_floating()
	else if(!floatiness && is_floating)
		stop_floating()

/mob/proc/start_floating()

	is_floating = 1

	var/amplitude = 2 //maximum displacement from original position
	var/period = 36 //time taken for the mob to go up >> down >> original position, in deciseconds. Should be multiple of 4

	var/top = old_y + amplitude
	var/bottom = old_y - amplitude
	var/half_period = period / 2
	var/quarter_period = period / 4

	animate(src, pixel_y = top, time = quarter_period, easing = SINE_EASING|EASE_OUT, loop = -1)		//up
	animate(pixel_y = bottom, time = half_period, easing = SINE_EASING, loop = -1)						//down
	animate(pixel_y = old_y, time = quarter_period, easing = SINE_EASING|EASE_IN, loop = -1)			//back

/mob/proc/stop_floating()
	animate(src, pixel_y = old_y, time = 5, easing = SINE_EASING|EASE_IN) //halt animation
	//reset the pixel offsets to zero
	is_floating = 0

// facing verbs
/mob/proc/canface()
	if(!canmove)						return 0
	if(client.moving)					return 0
	if(stat==2)						return 0
	if(anchored)						return 0
	if(monkeyizing)						return 0
	if(is_mob_restrained())					return 0
	return 1

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
/mob/proc/update_canmove()
	var/laid_down = (stat || knocked_down || knocked_out || !has_legs() || resting || (status_flags & FAKEDEATH) || (pulledby && pulledby.grab_level >= GRAB_AGGRESSIVE))

	if(laid_down)
		lying = TRUE
		flags_atom &= ~DIRLOCK
	else
		lying = FALSE
	if(buckled)
		if(buckled.buckle_lying)
			lying = TRUE
			flags_atom &= ~DIRLOCK
		else
			lying = FALSE

	canmove =  !(stunned || frozen || laid_down)

	if(lying_prev != lying)
		if(lying)
			density = FALSE
			add_temp_pass_flags(PASS_MOB_THRU)
			drop_l_hand()
			drop_r_hand()
		else
			density = TRUE
			SEND_SIGNAL(src, COMSIG_MOB_GETTING_UP)
			remove_temp_pass_flags(PASS_MOB_THRU)
		update_transform()

	if(lying)
		//so mob lying always appear behind standing mobs, but dead ones appear behind living ones
		if(pulledby && pulledby.grab_level == GRAB_CARRY)
			layer = ABOVE_MOB_LAYER
		else if (stat == DEAD)
			layer = LYING_DEAD_MOB_LAYER // Dead mobs should layer under living ones
		else if(layer == initial(layer)) //to avoid things like hiding larvas.
			layer = LYING_LIVING_MOB_LAYER
	else if(layer == LYING_DEAD_MOB_LAYER || layer == LYING_LIVING_MOB_LAYER)
		layer = initial(layer)

	return canmove


/mob/proc/facedir(var/ndir)
	if(!canface())	return 0
	var/newdir = FALSE
	if(dir != ndir)
		flags_atom &= ~DIRLOCK
		dir = ndir
		newdir = TRUE
	if(buckled && !buckled.anchored)
		buckled.dir = ndir
		buckled.handle_rotation()
	var/mob/living/mliv = src
	if(istype(mliv))
		if(newdir)
			mliv.on_movement(0)
	return 1


/mob/proc/set_face_dir(var/newdir)
	if(newdir == dir && flags_atom & DIRLOCK)
		flags_atom &= ~DIRLOCK
	else if ( facedir(newdir) )
		flags_atom |= DIRLOCK


/mob/proc/IsAdvancedToolUser()//This might need a rename but it should replace the can this mob use things check
	return 0


/mob/proc/get_species()
	return ""

/mob/proc/flash_weak_pain()
	overlay_fullscreen("pain", /obj/screen/fullscreen/pain, 1)
	clear_fullscreen("pain")

/mob/proc/get_visible_implants(var/class = 0)
	var/list/visible_implants = list()
	for(var/obj/item/O in embedded)
		if(O.w_class > class)
			visible_implants += O
	return visible_implants

mob/proc/yank_out_object()
	set category = "Object"
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!isliving(usr) || usr.next_move > world.time)
		return
	usr.next_move = world.time + 20

	recalculate_move_delay = TRUE

	if(usr.stat)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.is_mob_restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/self
	if(src == usr)
		self = TRUE // Removing object from yourself.

	var/list/valid_objects = get_visible_implants()
	if(!valid_objects)
		if(self)
			to_chat(src, "You have nothing stuck in your body that is large enough to remove.")
		else
			to_chat(usr, "[src] has nothing stuck in their wounds that is large enough to remove.")
		src.verbs -= /mob/proc/yank_out_object
		return

	var/obj/item/selection = input("What do you want to yank out?", "Embedded objects") in valid_objects
	if(self)
		if(get_active_hand())
			to_chat(src, SPAN_WARNING("You need an empty hand for this!"))
			return FALSE
		to_chat(src, SPAN_WARNING("You attempt to get a good grip on [selection] in your body."))
	else
		if(get_active_hand())
			to_chat(usr, SPAN_WARNING("You need an empty hand for this!"))
			return FALSE
		to_chat(usr, SPAN_WARNING("You attempt to get a good grip on [selection] in [src]'s body."))

	if(!do_after(usr, 80 * usr.get_skill_duration_multiplier(), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return
	if(!selection || !src || !usr || !istype(selection))
		return

	if(self)
		visible_message(SPAN_WARNING("<b>[src] rips [selection] out of their body.</b>"),SPAN_WARNING("<b>You rip [selection] out of your body.</b>"), null, 5)
	else
		visible_message(SPAN_WARNING("<b>[usr] rips [selection] out of [src]'s body.</b>"),SPAN_WARNING("<b>[usr] rips [selection] out of your body.</b>"), null, 5)

	if(valid_objects.len == 1) //Yanking out last object - removing verb.
		src.verbs -= /mob/proc/yank_out_object

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		var/obj/limb/affected
		for(var/obj/limb/E in H.limbs) //Grab the limb holding the implant.
			for(var/obj/item/O in E.implants)
				if(O == selection)
					affected = E
					break

		if(!affected) //Somehow, something fucked up. Somewhere.
			return

		affected.implants -= selection
		H.embedded_items -= selection

		affected.take_damage((selection.w_class * 3), 0, 0, 1, "Embedded object extraction")
		H.pain.apply_pain(selection.w_class * 3)

		if(prob(selection.w_class * 5) && !(affected.status & LIMB_ROBOT))
			var/datum/wound/internal_bleeding/I = new (0)
			affected.add_bleeding(I, TRUE)
			affected.wounds += I
			H.custom_pain("Something tears wetly in your [affected] as [selection] is pulled free!", 1)

	selection.loc = get_turf(src)
	return TRUE

/mob/living/proc/handle_statuses()
	handle_stunned()
	handle_knocked_down()
	handle_knocked_out()
	handle_stuttering()
	handle_silent()
	handle_drugged()
	handle_slurring()
	handle_dazed()
	handle_slowed()
	handle_superslowed()

/mob/living/proc/handle_stunned()
	if(stunned)
		AdjustStunned(-1)
	return stunned

/mob/living/proc/handle_dazed()
	if(dazed)
		AdjustDazed(-1)
	return dazed

/mob/living/proc/handle_slowed()
	if(slowed)
		AdjustSlowed(-1)
	return slowed

/mob/living/proc/handle_superslowed()
	if(superslowed)
		AdjustSuperslowed(-1)
	return superslowed


/mob/living/proc/handle_knocked_down()
	if(knocked_down && client)
		knocked_down = max(knocked_down-1,0)	//before you get mad Rockdtben: I done this so update_canmove isn't called multiple times
		knocked_down_callback_check()
	return knocked_down

/mob/living/proc/handle_knocked_out()
	if(knocked_out && client)
		knocked_out = max(knocked_out-1,0)	//before you get mad Rockdtben: I done this so update_canmove isn't called multiple times
		knocked_out_callback_check()
	return knocked_out

/mob/living/proc/handle_stuttering()
	if(stuttering)
		stuttering = max(stuttering-1, 0)
	return stuttering

/mob/living/proc/handle_silent()
	if(silent)
		silent = max(silent-1, 0)
	return silent

/mob/living/proc/handle_drugged()
	if(druggy)
		druggy = max(druggy-1, 0)
	return druggy

/mob/living/proc/handle_slurring()
	if(slurring)
		slurring = max(slurring-1, 0)
	return slurring

/mob/proc/slip(slip_source_name, stun_level, weaken_level, run_only, override_noslip, slide_steps)
	return FALSE

/mob/proc/TurfAdjacent(var/turf/T)
	return T.AdjacentQuick(src)

/mob/on_stored_atom_del(atom/movable/AM)
	if(istype(AM, /obj/item))
		temp_drop_inv_item(AM, TRUE) //unequip before deletion to clear possible item references on the mob.

/mob/proc/set_skills(skills_path)
	if(skills)
		qdel(skills)
	if(!skills_path)
		skills = null
	else
		skills = new skills_path(src)

/mob/enable_pixel_scaling()
	..()

	for(var/I in hud_list)
		var/image/img = hud_list[I]

		if(istype(img))
			img.appearance_flags |= PIXEL_SCALE

/mob/disable_pixel_scaling()
	..()

	for(var/I in hud_list)
		var/image/img = hud_list[I]

		if(istype(img))
			img.appearance_flags &= ~PIXEL_SCALE
