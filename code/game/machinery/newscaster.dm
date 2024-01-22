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
// those are very still used in other files so would need to move remove them in another PR...
/datum/feed_message
	var/author =""
	var/body =""
	var/message_type ="Story"
	//var/parent_channel
	var/backup_body =""
	var/backup_author =""
	var/is_admin_message = 0
	var/icon/img = null
	var/icon/backup_img

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

/datum/feed_message/proc/clear()
	src.author = ""
	src.body = ""
	src.backup_body = ""
	src.backup_author = ""
	src.img = null
	src.backup_img = null

/datum/feed_channel/proc/clear()
	src.channel_name = ""
	src.messages = list()
	src.locked = 0
	src.author = ""
	src.backup_author = ""
	src.censored = 0
	src.is_admin_channel = 0

/datum/feed_network
	var/list/datum/feed_channel/network_channels = list()
	var/datum/feed_message/wanted_issue

GLOBAL_DATUM_INIT(news_network, /datum/feed_network, new()) //The global news-network, which is coincidentally a global list.

GLOBAL_LIST_INIT_TYPED(allCasters, /obj/structure/machinery/newscaster, list()) //Global list that will contain reference to all newscasters in existence.
