/obj/structure/machinery/newscaster
	name = "newscaster"
	desc = "A standard Weyland-Yutani-licensed newsfeed handler for use in commercial space stations. All the news you absolutely have no use for, in one place!"
	icon = 'icons/obj/structures/machinery/terminals.dmi'
	icon_state = "newscaster_normal"
	anchored = TRUE

/obj/structure/machinery/newscaster/security_unit
	name = "Security Newscaster"

/obj/item/newspaper
	name = "newspaper"
	desc = "An issue of The Griffon, the newspaper circulating aboard Weyland-Yutani Space Stations."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "newspaper"
	w_class = SIZE_TINY //Let's make it fit in trashbags!
	attack_verb = list("bapped")

// apparently i need to put back those here... if we don't want code to die.
/datum/feed_channel
	var/channel_name=""
	var/list/datum/feed_message/messages = list()
	//var/message_count = 0
	var/locked=0
	var/author=""
	var/backup_author=""
	var/censored=0
	var/is_admin_channel=0
	//var/page = null //For newspapers
