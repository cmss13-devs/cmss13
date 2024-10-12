GLOBAL_LIST_EMPTY(discord_ranks)
GLOBAL_LIST_EMPTY_TYPED(donators_info, /datum/donator_info)

GLOBAL_LIST_INIT_TYPED(all_gun_decorators, /datum/decorator/weapon_map_decorator, create_decorators())

/proc/create_decorators()
	. = list()
	for(var/decorator_type in subtypesof(/datum/decorator/weapon_map_decorator))
		. += new decorator_type

/datum/entity/player
	var/datum/donator_info/donator_info

/datum/entity/discord_rank
	var/rank_id
	var/rank_name
	var/functions
	var/role_id
	var/list/buns = list()

BSQL_PROTECT_DATUM(/datum/entity/discord_rank)

/datum/entity_meta/discord_rank
	entity_type = /datum/entity/discord_rank
	table_name = "discord_ranks"
	field_types = list(
		"rank_id" = DB_FIELDTYPE_INT,
		"rank_name" = DB_FIELDTYPE_STRING_LARGE,
		"functions" = DB_FIELDTYPE_STRING_MAX,
		"role_id" = DB_FIELDTYPE_STRING_LARGE,
	)

/datum/entity_meta/discord_rank/map(datum/entity/discord_rank/rank, list/values)
	..()
	if(values["functions"])
		rank.buns = json_decode(values["functions"])

/datum/entity_meta/discord_rank/unmap(datum/entity/discord_rank/rank)
	. = ..()
	if(length(rank.buns))
		.["functions"] = json_encode(rank.buns)

/datum/view_record/discord_rank
	var/rank_id
	var/rank_name
	var/functions
	var/role_id
	var/list/buns = list()

/datum/entity_view_meta/discord_rank
	root_record_type = /datum/entity/discord_rank
	destination_entity = /datum/view_record/discord_rank
	fields = list(
		"rank_id",
		"rank_name",
		"functions",
		"role_id",
	)
	order_by = list("rank_id" = DB_ORDER_BY_ASC)

/datum/entity_view_meta/discord_rank/map(datum/view_record/discord_rank/rank, list/values)
	..()
	if(values["functions"])
		rank.buns = json_decode(values["functions"])

/datum/entity/skin
	var/player_id
	var/skin_name
	var/skins_db
	var/list/mapped_skins = list()

BSQL_PROTECT_DATUM(/datum/entity/skin)

/datum/entity_meta/skin
	entity_type = /datum/entity/skin
	table_name = "players_skins"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"skin_name" = DB_FIELDTYPE_STRING_LARGE,
		"skins_db" = DB_FIELDTYPE_STRING_MAX,
	)

/datum/entity_meta/skin/map(datum/entity/skin/skin, list/values)
	..()
	if(values["skins_db"])
		skin.mapped_skins = json_decode(values["skins_db"])

/datum/entity_meta/skin/unmap(datum/entity/skin/skin)
	. = ..()
	if(length(skin.mapped_skins))
		.["skins_db"] = json_encode(skin.mapped_skins)

/datum/donator_info
	var/datum/entity/player/player_datum
	var/list/skins = list()
	var/list/skins_used = list()

/datum/donator_info/New(datum/entity/player/owner_datum)
	player_datum = owner_datum
	load_info()

/datum/donator_info/proc/load_info()
	DB_FILTER(/datum/entity/skin, DB_COMP("player_id", DB_EQUALS, player_datum.id), CALLBACK(src, TYPE_PROC_REF(/datum/donator_info, load_skins)))
	if(patreon_function_available("ooc_color"))
		GLOB.donaters |= player_datum.owning_client
		add_verb(player_datum.owning_client, /client/proc/set_ooc_color_self)

/datum/donator_info/proc/load_skins(list/datum/entity/skin/entity_skins)
	for(var/datum/entity/skin/skin in entity_skins)
		skins[skin.skin_name] = skin

/datum/donator_info/proc/patreon_function_available(required)
	if(player_datum?.discord_link)
		var/datum/view_record/discord_rank/discord_rank = GLOB.discord_ranks["[player_datum.discord_link.role_rank]"]
		if(discord_rank)
			return discord_rank.buns[required]
	return FALSE

/obj/structure/painting_table
	name = "\improper Painting Table"
	desc = "Can repaint equipment."
	icon = 'core_ru/icons/obj/structures/workbenches.dmi'
	icon_state = "paint_bench"
	unacidable = TRUE
	density = TRUE
	anchored = TRUE
	bound_width = 64
	bound_height = 32

/obj/structure/painting_table/attackby(obj/item/item as obj, mob/user as mob)
	if(user?.client?.player_data?.donator_info && user.client.player_data.donator_info.skins["[item.type]"] && !user.client.player_data.donator_info.skins_used["[item.type]"])
		if(handle_skinning_item(item, user))
			return

	if(handle_decorator_override(item, user))
		return

	. = ..()

/obj/structure/painting_table/proc/handle_decorator_override(obj/item/decoratable, mob/user, selectable_types = list("snow" = "s_", "desert" = "d_", "classic" = "c_", "normal" = ""))
	if(isgun(decoratable))
		var/obj/item/weapon/gun/decorating = decoratable
		if(!decorating.map_specific_decoration || !SSdecorator.decoratable || !SSdecorator.registered_decorators[decorating.type])
			return

		var/list/active_decorators = list()
		for(var/datum/decorator/weapon_map_decorator/map_decorator in GLOB.all_gun_decorators)
			if(map_decorator.camouflage_type == "urban")
				continue
			active_decorators[map_decorator.camouflage_type] = map_decorator

		if(!length(active_decorators))
			return

		var/selected = tgui_input_list(user, "Select skin for your gun, don't select anything to set normal", "Skin Selector", active_decorators)
		if(!selected)
			decorating.icon = initial(decorating.icon)
			decorating.icon_state = initial(decorating.icon_state)
			decorating.item_state = initial(decorating.item_state)
			decorating.item_icons = initial(decorating.item_icons)
			for(var/slot in decorating.attachments)
				var/obj/item/attachable/attachment = decorating.attachments[slot]
				attachment.attach_icon = initial(attachment.attach_icon)
			decorating.update_icon()
			return

		var/datum/decorator/weapon_map_decorator/selected_map_decorator = active_decorators[selected]
		selected_map_decorator.decorate(decorating)
		for(var/slot in decorating.attachments)
			var/obj/item/attachable/attachment = decorating.attachments[slot]
			if(!attachment.select_gamemode_skin(attachment.type))
				continue
			attachment.attach_icon = selectable_types[selected] + initial(attachment.attach_icon)
		decorating.update_icon()

	else if(istype(decoratable, /obj/item/clothing/suit/storage/marine))
		if(decoratable.flags_atom & NO_SNOW_TYPE)
			return

		var/selected = tgui_input_list(user, "Select skin for your armor", "Skin Selector", selectable_types)
		if(!selected)
			return

		decoratable.icon_state = selectable_types[selected] + initial(decoratable.icon_state)
		decoratable.item_state = selectable_types[selected] + initial(decoratable.item_state)

	else if(istype(decoratable, /obj/item/clothing/head/helmet/marine))
		if(decoratable.flags_atom & NO_SNOW_TYPE)
			return

		var/selected = tgui_input_list(user, "Select skin for your helmet", "Skin Selector", selectable_types)
		if(!selected)
			return

		decoratable.icon_state = selectable_types[selected] + initial(decoratable.icon_state)
		decoratable.item_state = selectable_types[selected] + initial(decoratable.item_state)

	return TRUE

/proc/handle_skinning_item(obj/item, mob/user)
	var/datum/entity/skin/skin_selection = user.client.player_data.donator_info.skins["[item.type]"]
	if(!skin_selection)
		return

	var/skin = tgui_input_list(user, "Select skin, you can only one time use it for round (cancel for selecting normal one)", "Skin Selector", skin_selection.mapped_skins)
	if(!skin)
		to_chat(user, SPAN_WARNING("Vending base skin."))
		return

	user.client.player_data.donator_info.skins_used["[item.type]"] = skin_selection
	item.flags_atom |= ATOM_DECORATED
	item.skin(skin)
	return TRUE

//COMPACT VERSION << ALL IN ONE >>
/obj/proc/skin(skin)
	return

//HELMET
/obj/item/clothing/head/helmet/skin(skin)
	icon = 'core_ru/icons/custom/items/clothings.dmi'
	icon_state = "[icon_state]_[skin]"
	item_state = "[item_state]_[skin]"
	item_icons = list(
		WEAR_HEAD = 'core_ru/icons/custom/items/clothing_on_mob.dmi'
	)

//STORAGE
/obj/item/clothing/suit/storage/marine/skin(skin)
	icon = 'core_ru/icons/custom/items/clothings.dmi'
	icon_state = "[icon_state]_[skin]"
	item_state = "[item_state]_[skin]"
	item_state_slots[WEAR_BODY] = icon_state

//UNDER
/obj/item/clothing/under/skin(skin)
	icon = 'core_ru/icons/custom/items/clothings.dmi'
	icon_state += "_[skin]"
	worn_state = icon_state

	item_icons = list(WEAR_BODY = 'core_ru/icons/custom/items/clothing_on_mob.dmi')

	icon_override = 'core_ru/icons/custom/items/clothings.dmi'

	item_state_slots[WEAR_BODY] = worn_state
	update_rollsuit_status()

//GUNS
/obj/item/weapon/gun/skin(skin)
	base_gun_icon = "[base_gun_icon]_[skin]"
	icon = 'core_ru/icons/custom/items/guns.dmi'

	item_icons = list(
		WEAR_L_HAND = 'core_ru/icons/custom/items/items_lefthand_1.dmi',
		WEAR_R_HAND = 'core_ru/icons/custom/items/items_righthand_1.dmi',
		WEAR_BACK = 'core_ru/icons/custom/items/back.dmi',
		WEAR_J_STORE = 'core_ru/icons/custom/items/suit_slot.dmi'
		)

	item_state = "[base_gun_icon]"

	LAZYSET(item_state_slots, WEAR_BACK, item_state)

//	var/icon/I = new /icon('core_ru/icons/custom/items/attach_recoloring.dmi', skin)
//	attachment_recoloring = image(I)
//	attachment_recoloring.alpha = 180
//	attachment_recoloring.blend_mode = BLEND_ADD|BLEND_INSET_OVERLAY|BLEND_SUBTRACT
	update_icon()

/mob/living/carbon/xenomorph
	var/selected_skin
	var/icon_skin
	var/atom/movable/vis_obj/xeno_skin/skin_icon_holder

/proc/handle_skinning_xeno(mob/living/carbon/xenomorph/xeno, mob/user)
	if(user?.client?.player_data?.donator_info)
		if(user.client.player_data.donator_info.skins["[xeno.type]"] && !user.client.player_data.donator_info.skins_used["[xeno.type]"])
			if(xeno.selected_skin)
				return
		else
			xeno.selected_skin = null
			return
	else
		xeno.selected_skin = null
		return

	var/datum/entity/skin/skin_selection = user.client.player_data.donator_info.skins["[xeno.type]"]
	if(!skin_selection)
		return
	var/skin = tgui_input_list(user, "Select skin, you can only one time use it for round (cancel for selecting normal one)", "Skin Selector", skin_selection.mapped_skins)
	if(!skin)
		return
//	user.client.player_data.donator_info.skins_used["[xeno.type]"] = skin_selection // xeno skins for now reusable
	xeno.skin(skin)

/atom/movable/vis_obj/xeno_skin

/mob/living/carbon/xenomorph/proc/handle_special_skin_states()
	return FALSE

/mob/living/carbon/xenomorph/defender/handle_special_skin_states()
	. = ..()
	if(fortify)
		return "fortify_[selected_skin]"
	if(crest_defense)
		return "crest_[selected_skin]"

/mob/living/carbon/xenomorph/queen/handle_special_skin_states()
	. = ..()
	if(ovipositor)
		return "ovipositor_[selected_skin]"

/mob/living/carbon/xenomorph/proc/update_skin()
	if(!skin_icon_holder)
		return

	if(selected_skin)
		if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				skin_icon_holder.icon_state = "[lowertext(caste.caste_type)]_[selected_skin]_rest"
			else
				skin_icon_holder.icon_state = "[lowertext(caste.caste_type)]_[selected_skin]_downed"
		else if(!handle_special_state())
			skin_icon_holder.icon_state = "[lowertext(caste.caste_type)]_[selected_skin]"
		else
			skin_icon_holder.icon_state = handle_special_skin_states()
	else
		skin_icon_holder.icon_state = "none"

/mob/living/carbon/xenomorph/proc/skin(skin)
	selected_skin = skin
	update_skin()
	return

/mob/living/carbon/xenomorph/queen
	icon_skin = 'core_ru/icons/custom/mob/xenos/queen.dmi'

/mob/living/carbon/xenomorph/predalien
	icon_skin = 'core_ru/icons/custom/mob/xenos/predalien.dmi'

/mob/living/carbon/xenomorph/boiler
	icon_skin = 'core_ru/icons/custom/mob/xenos/boiler.dmi'

/mob/living/carbon/xenomorph/praetorian
	icon_skin = 'core_ru/icons/custom/mob/xenos/praetorian.dmi'

/mob/living/carbon/xenomorph/ravager
	icon_skin = 'core_ru/icons/custom/mob/xenos/ravager.dmi'

/mob/living/carbon/xenomorph/crusher
	icon_skin = 'core_ru/icons/custom/mob/xenos/crusher.dmi'

/mob/living/carbon/xenomorph/hivelord
	icon_skin = 'core_ru/icons/custom/mob/xenos/hivelord.dmi'

/mob/living/carbon/xenomorph/warrior
	icon_skin = 'core_ru/icons/custom/mob/xenos/warrior.dmi'

/mob/living/carbon/xenomorph/carrier
	icon_skin = 'core_ru/icons/custom/mob/xenos/carrier.dmi'

/mob/living/carbon/xenomorph/burrower
	icon_skin = 'core_ru/icons/custom/mob/xenos/burrower.dmi'

/mob/living/carbon/xenomorph/spitter
	icon_skin = 'core_ru/icons/custom/mob/xenos/spitter.dmi'

/mob/living/carbon/xenomorph/lurker
	icon_skin = 'core_ru/icons/custom/mob/xenos/lurker.dmi'

/mob/living/carbon/xenomorph/drone
	icon_skin = 'core_ru/icons/custom/mob/xenos/drone.dmi'

/mob/living/carbon/xenomorph/defender
	icon_skin = 'core_ru/icons/custom/mob/xenos/defender.dmi'

/mob/living/carbon/xenomorph/sentinel
	icon_skin = 'core_ru/icons/custom/mob/xenos/sentinel.dmi'

/mob/living/carbon/xenomorph/runner
	icon_skin = 'core_ru/icons/custom/mob/xenos/runner.dmi'

/mob/living/carbon/xenomorph/larva/predalien
	icon_skin = 'core_ru/icons/custom/mob/xenos/predalien_larva.dmi'

/mob/living/carbon/xenomorph/larva
	icon_skin = 'core_ru/icons/custom/mob/xenos/larva.dmi'

/mob/living/carbon/xenomorph/lesser_drone
	icon_skin = 'core_ru/icons/custom/mob/xenos/lesser_drone.dmi'

/mob/living/carbon/xenomorph/facehugger
	icon_skin = 'core_ru/icons/custom/mob/xenos/facehugger.dmi'
