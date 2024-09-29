/datum/keybinding/yautja
	category = CATEGORY_YAUTJA
	weight = WEIGHT_MOB

/datum/keybinding/yautja/can_use(client/user)
	if(!ishuman(user.mob))
		return FALSE
	return TRUE

// mob \\

/datum/keybinding/yautja/butcher
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "butcher"
	full_name = "Butcher"
	keybind_signal = COMSIG_KB_YAUTJA_BUTCHER

/datum/keybinding/yautja/butcher/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	if(!isyautja(H))
		return
	H.butcher()

/datum/keybinding/yautja/pred_buy
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "pred_buy"
	full_name = "Claim equipment"
	keybind_signal = COMSIG_KB_YAUTJA_PRED_BUY

/datum/keybinding/yautja/mark_panel
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "mark_panel"
	full_name = "Mark panel"
	keybind_signal = COMSIG_KB_YAUTJA_MARK_PANEL

/datum/keybinding/yautja/mark_for_hunt
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "mark_for_hunt"
	full_name = "Toggle mark for hunt"
	keybind_signal = COMSIG_KB_YAUTJA_TOGGLE_MARK_FOR_HUNT

// BRACER SPECIFIC \\

// parent bracer \\

/datum/keybinding/yautja/bracer/can_use(client/user)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user.mob
	if(istype(H.get_held_item(), /obj/item/clothing/gloves/yautja))
		return TRUE
	if(istype(H.gloves, /obj/item/clothing/gloves/yautja))
		return TRUE

/datum/keybinding/yautja/bracer/toggle_notification_sound
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_notification_sound"
	full_name = "Toggle bracer notification sound"
	keybind_signal = COMSIG_KB_YAUTJA_TOGGLE_NOTIFICATION_SOUND

/datum/keybinding/yautja/bracer/toggle_notification_sound/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob

	var/obj/item/clothing/gloves/yautja/gloves = H.gloves
	if(istype(gloves))
		gloves.toggle_notification_sound()
		return TRUE

	var/obj/item/clothing/gloves/yautja/held = H.get_held_item()
	if(istype(held))
		held.toggle_notification_sound()
		return TRUE

/datum/keybinding/yautja/bracer/bracer_message
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "bracer_message"
	full_name = "Bracer message"
	keybind_signal = COMSIG_KB_YAUTJA_TOGGLE_NOTIFICATION_SOUND

/datum/keybinding/yautja/bracer/bracer_message/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob

	var/obj/item/clothing/gloves/yautja/gloves = H.gloves
	if(istype(gloves))
		gloves.toggle_notification_sound()
		return TRUE

	var/obj/item/clothing/gloves/yautja/held = H.get_held_item()
	if(istype(held))
		held.bracer_message()
		return TRUE

// Hunter bracer only \\

/datum/keybinding/yautja/bracer_hunter/can_use(client/user)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user.mob
	if(istype(H.get_held_item(), /obj/item/clothing/gloves/yautja/hunter))
		return TRUE
	if(istype(H.gloves, /obj/item/clothing/gloves/yautja/hunter))
		return TRUE

/datum/keybinding/yautja/bracer_hunter/wristblades
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "wristblades"
	full_name = "Toggle wristblades"
	keybind_signal = COMSIG_KB_YAUTJA_WRISTBLADES

/datum/keybinding/yautja/bracer_hunter/track_gear
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "track_gear"
	full_name = "Track gear"
	keybind_signal = COMSIG_KB_YAUTJA_TRACK_GEAR

/datum/keybinding/yautja/bracer_hunter/track_gear/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob

	var/obj/item/clothing/gloves/yautja/hunter/gloves = H.gloves
	if(istype(gloves))
		gloves.track_gear()
		return TRUE

	var/obj/item/clothing/gloves/yautja/hunter/held = H.get_held_item()
	if(istype(held))
		held.track_gear()
		return TRUE

/datum/keybinding/yautja/bracer_hunter/cloaker
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "cloaker"
	full_name = "Toggle cloak"
	keybind_signal = COMSIG_KB_YAUTJA_CLOAKER

/datum/keybinding/yautja/bracer_hunter/caster
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "caster"
	full_name = "Toggle plasma caster"
	keybind_signal = COMSIG_KB_YAUTJA_CASTER

/datum/keybinding/yautja/bracer_hunter/change_explosion_type
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "change_explosion_type"
	full_name = "Change explosion type"
	keybind_signal = COMSIG_KB_YAUTJA_CHANGE_EXPLOSION_TYPE

/datum/keybinding/yautja/bracer_hunter/change_explosion_type/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob

	var/obj/item/clothing/gloves/yautja/hunter/gloves = H.gloves
	if(istype(gloves))
		gloves.change_explosion_type()
		return TRUE

	var/obj/item/clothing/gloves/yautja/hunter/held = H.get_held_item()
	if(istype(held))
		held.change_explosion_type()
		return TRUE

/datum/keybinding/yautja/bracer_hunter/activate_suicide
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "activate_suicide"
	full_name = "Self-destruct"
	keybind_signal = COMSIG_KB_YAUTJA_ACTIVATE_SUICIDE

/datum/keybinding/yautja/bracer_hunter/injectors
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "injectors"
	full_name = "Create Stabilising Crystal"
	keybind_signal = COMSIG_KB_YAUTJA_INJECTORS

/datum/keybinding/yautja/bracer_hunter/healing_capsule
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "capsule"
	full_name = "Create Healing Capsule"
	keybind_signal = COMSIG_KB_YAUTJA_CAPSULE

/datum/keybinding/yautja/bracer_hunter/call_disc
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "call_disc"
	full_name = "Call smart-disc"
	keybind_signal = COMSIG_KB_YAUTJA_CALL_DISC

/datum/keybinding/yautja/bracer_hunter/remove_tracked_item
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "remove_tracked_item"
	full_name = "Remove item from tracker"
	keybind_signal = COMSIG_KB_YAUTJA_REMOVE_TRACKED_ITEM

/datum/keybinding/yautja/bracer_hunter/remove_tracked_item/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob

	var/obj/item/clothing/gloves/yautja/hunter/gloves = H.gloves
	if(istype(gloves))
		gloves.remove_tracked_item()
		return TRUE

	var/obj/item/clothing/gloves/yautja/hunter/held = H.get_held_item()
	if(istype(held))
		held.remove_tracked_item()
		return TRUE

/datum/keybinding/yautja/bracer_hunter/add_tracked_item
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "add_tracked_item"
	full_name = "Add item to tracker"
	keybind_signal = COMSIG_KB_YAUTJA_ADD_TRACKED_ITEM

/datum/keybinding/yautja/bracer_hunter/add_tracked_item/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob

	var/obj/item/clothing/gloves/yautja/hunter/gloves = H.gloves
	if(istype(gloves))
		gloves.add_tracked_item()
		return TRUE

	var/obj/item/clothing/gloves/yautja/hunter/held = H.get_held_item()
	if(istype(held))
		held.add_tracked_item()
		return TRUE

/datum/keybinding/yautja/bracer_hunter/call_combi
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "call_combi"
	full_name = "Yank combi-stick"
	keybind_signal = COMSIG_KB_YAUTJA_CALL_COMBI

/datum/keybinding/yautja/bracer_hunter/translate
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "translate"
	full_name = "Translator"
	keybind_signal = COMSIG_KB_YAUTJA_TRANSLATE

/datum/keybinding/yautja/bracer_hunter/bracername
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "bracername"
	full_name = "Toggle bracer name"
	keybind_signal = COMSIG_KB_YAUTJA_BRACERNAME

/datum/keybinding/yautja/bracer_hunter/bracername/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob

	var/obj/item/clothing/gloves/yautja/hunter/gloves = H.gloves
	if(istype(gloves))
		gloves.bracername()
		return TRUE

	var/obj/item/clothing/gloves/yautja/hunter/held = H.get_held_item()
	if(istype(held))
		held.bracername()
		return TRUE

/datum/keybinding/yautja/bracer_hunter/idchip
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "idchip"
	full_name = "Toggle ID chip"
	keybind_signal = COMSIG_KB_YAUTJA_IDCHIP

/datum/keybinding/yautja/bracer_hunter/idchip/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob

	var/obj/item/clothing/gloves/yautja/hunter/gloves = H.gloves
	if(istype(gloves))
		gloves.idchip()
		return TRUE

	var/obj/item/clothing/gloves/yautja/hunter/held = H.get_held_item()
	if(istype(held))
		held.idchip()
		return TRUE

/datum/keybinding/yautja/bracer_hunter/link_bracer
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "link_bracer"
	full_name = "Link thrall bracer"
	keybind_signal = COMSIG_KB_YAUTJA_LINK_BRACER

/datum/keybinding/yautja/bracer_hunter/link_bracer/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob

	var/obj/item/clothing/gloves/yautja/hunter/gloves = H.gloves
	if(istype(gloves))
		gloves.link_bracer()
		return TRUE

	var/obj/item/clothing/gloves/yautja/hunter/held = H.get_held_item()
	if(istype(held))
		held.link_bracer()
		return TRUE

/datum/keybinding/yautja/bracer_hunter/control_falcon_drone
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "control_falcon"
	full_name = "Control falcon drone"
	keybind_signal = COMSIG_KB_YAUTJA_CONTROL_FALCON

// Misc stuff - mask, teleporter \\

// mask

/datum/keybinding/yautja/mask/can_use(client/user)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user.mob
	if(istype(H.wear_mask, /obj/item/clothing/mask/gas/yautja))
		return TRUE

/datum/keybinding/yautja/mask/toggle_zoom
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_zoom"
	full_name = "Toggle mask zoom"
	keybind_signal = COMSIG_KB_YAUTJA_MASK_TOGGLE_ZOOM

/datum/keybinding/yautja/mask/togglesight
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "togglesight"
	full_name = "Toggle mask visors"
	keybind_signal = COMSIG_KB_YAUTJA_MASK_TOGGLESIGHT

// teleporter

/datum/keybinding/yautja/tele_loc/can_use(client/user)
	. = ..()
	var/mob/living/carbon/human/H = user.mob
	if(locate(/obj/item/device/yautja_teleporter) in H.contents)
		return TRUE

/datum/keybinding/yautja/tele_loc
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "tele_loc"
	full_name = "Add teleporter location"
	keybind_signal = COMSIG_KB_YAUTJA_TELE_LOC

/datum/keybinding/yautja/tele_loc/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/device/yautja_teleporter/tele = locate(/obj/item/device/yautja_teleporter) in H.contents
	tele.add_tele_loc()


/datum/keybinding/yautja/fold_combi
	hotkey_keys = list("Space")
	classic_keys = list("Unbound")
	name = "fold_combi"
	full_name = "Collapse Combi-stick"
	keybind_signal = COMSIG_KB_YAUTJA_FOLD_COMBISTICK

/datum/keybinding/yautja/fold_combi/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/yautja/combistick/held_item = human.get_held_item()
	if(istype(held_item))
		held_item.fold_combistick()
	return TRUE
