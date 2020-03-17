/*
 * Construction Node
 */

/obj/effect/alien/resin/construction
	name = "construction node"
	desc = "A strange wriggling lump. Looks like a marker for something."
	icon = 'icons/mob/xenos/weeds.dmi'
	icon_state = "constructionnode"
	density = 0
	anchored = 1

	health = 200
	var/datum/construction_template/xenomorph/template //What we're building
	var/datum/hive_status/linked_hive //Who gets what we build

/obj/effect/alien/resin/construction/New(loc, var/hive_ref)
	..()
	linked_hive = hive_ref

/obj/effect/alien/resin/construction/Dispose()
	if(template && linked_hive && (template.crystals_stored < template.crystals_required))
		linked_hive.crystal_stored += template.crystals_stored
		linked_hive.remove_construction(src)
	template = null
	linked_hive = null
	. = ..()

/obj/effect/alien/resin/construction/update_icon()
	..()
	overlays.Cut()
	if(template)
		var/image/I = template.get_structure_image()
		I.alpha = 122
		I.pixel_x = -16
		I.pixel_y = -16
		overlays += I

/obj/effect/alien/resin/construction/examine(mob/user)
	..()
	if((isXeno(user) || isobserver(user)) && linked_hive)
		var/message = "A [template.name] construction is designated here. It requires [template.crystals_required - template.crystals_stored] more [MATERIAL_CRYSTAL]."
		to_chat(user, message)

/obj/effect/alien/resin/construction/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!linked_hive || (linked_hive && (M.hivenumber != linked_hive.hivenumber)) || (M.a_intent == HARM_INTENT && M.can_destroy_special()))
		return ..()
	if(!template)
		to_chat(M, SPAN_XENOWARNING("There is no template!"))
		return
	template.add_crystal(M)

/obj/effect/alien/resin/construction/proc/set_template(var/datum/construction_template/xenomorph/new_template)
	if(!istype(new_template) || !linked_hive)
		return
	template = new_template
	template.owner = src
	template.build_loc = get_turf(src)
	template.hive_ref = linked_hive
	update_icon()
