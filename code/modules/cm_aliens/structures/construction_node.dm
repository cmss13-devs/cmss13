/*
 * Construction Node
 */

/obj/effect/alien/resin/construction
	name = "construction node"
	desc = "A strange wriggling lump. Looks like a marker for something."
	icon = 'icons/mob/xenos/weeds.dmi'
	icon_state = "constructionnode"
	density = FALSE
	anchored = TRUE
	health = 200
	block_range = 1

	var/datum/construction_template/xenomorph/template //What we're building
	var/datum/hive_status/linked_hive //Who gets what we build

/obj/effect/alien/resin/construction/Initialize(mapload, hive_ref)
	. = ..()
	linked_hive = hive_ref
	if (linked_hive?.color)
		color = linked_hive.color

/obj/effect/alien/resin/construction/Destroy()
	if(template && linked_hive && (template.plasma_stored < template.plasma_required))
		linked_hive.remove_construction(src)
	template = null
	linked_hive = null
	return ..()

/obj/effect/alien/resin/construction/update_icon()
	..()
	overlays.Cut()
	if(template)
		var/image/I = template.get_structure_image()
		I.alpha = 122
		I.pixel_x = template.pixel_x
		I.pixel_y = template.pixel_y
		overlays += I

/obj/effect/alien/resin/construction/get_examine_text(mob/user)
	. = ..()
	if((isxeno(user) || isobserver(user)) && linked_hive)
		var/message = "A [template.name] construction is designated here. It requires [template.plasma_required - template.plasma_stored] more plasma."
		. += message

/obj/effect/alien/resin/construction/attack_alien(mob/living/carbon/xenomorph/M)
	if(!linked_hive || (linked_hive && (M.hivenumber != linked_hive.hivenumber)) || (M.a_intent == INTENT_HARM && M.can_destroy_special()))
		return ..()
	if(!template)
		to_chat(M, SPAN_XENOWARNING("There is no template!"))
	else
		template.add_crystal(M) //This proc handles attack delay itself.
	return XENO_NO_DELAY_ACTION

/obj/effect/alien/resin/construction/proc/set_template(datum/construction_template/xenomorph/new_template)
	if(!istype(new_template) || !linked_hive)
		return
	template = new_template
	template.owner = src
	template.build_loc = get_turf(src)
	template.hive_ref = linked_hive
	template.on_template_creation()
	update_icon()
