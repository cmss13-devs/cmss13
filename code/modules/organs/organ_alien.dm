//DIONA ORGANS.
/datum/internal_organ/diona
	removed_type = /obj/item/organ/diona

/datum/internal_organ/diona/process()
	return

/datum/internal_organ/diona/strata
	name = "neural strata"

/datum/internal_organ/diona/bladder
	name = "gas bladder"

/datum/internal_organ/diona/polyp
	name = "polyp segment"

/datum/internal_organ/diona/ligament
	name = "anchoring ligament"

/datum/internal_organ/diona/node
	name = "receptor node"
	removed_type = /obj/item/organ/diona/node

/datum/internal_organ/diona/nutrients
	name = "nutrient vessel"
	removed_type = /obj/item/organ/diona/nutrients

/obj/item/organ/diona
	name = "diona nymph"
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"

/*
/obj/item/organ/diona/removed(var/mob/living/target,var/mob/living/user)

	var/mob/living/carbon/human/H = target
	if(!istype(target))
		qdel(src)

	if(!H.internal_organs.len)
		H.death()

	//This is a terrible hack and I should be ashamed.
	var/datum/seed/diona = seed_types["diona"]
	if(!diona)
		qdel(src)

//	var/mob/living/carbon/alien/diona/D = new(get_turf(src))
//	diona.request_player(D)

	qdel(src)
*/

// These are different to the standard diona organs as they have a purpose in other
// species (absorbing radiation and light respectively)
/obj/item/organ/diona/nutrients
	name = "nutrient vessel"
	icon_state = "claw"
	organ_data_type = /datum/internal_organ/diona/nutrients


/obj/item/organ/diona/node
	name = "receptor node"
	icon_state = "claw"
	organ_data_type = /datum/internal_organ/diona/node

//XENOMORPH ORGANS
/datum/internal_organ/xenos/eggsac
	name = "egg sac"
	removed_type = /obj/item/organ/xenos/eggsac

/datum/internal_organ/xenos/plasmavessel
	name = "plasma vessel"
	removed_type = /obj/item/organ/xenos/plasmavessel
	var/stored_plasma = 0
	var/max_plasma = 500

/datum/internal_organ/xenos/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500

/datum/internal_organ/xenos/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/datum/internal_organ/xenos/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/datum/internal_organ/xenos/acidgland
	name = "acid gland"
	removed_type = /obj/item/organ/xenos/acidgland

/datum/internal_organ/xenos/hivenode
	name = "hive node"
	removed_type = /obj/item/organ/xenos/hivenode

/datum/internal_organ/xenos/resinspinner
	name = "resin spinner"
	removed_type = /obj/item/organ/xenos/resinspinner

/obj/item/organ/xenos
	name = "xeno organ"
	icon = 'icons/effects/blood.dmi'
	desc = "It smells like an accident in a chemical factory."

/obj/item/organ/xenos/eggsac
	name = "egg sac"
	icon_state = "xgibmid1"
	organ_data_type = /datum/internal_organ/xenos/eggsac

/obj/item/organ/xenos/plasmavessel
	name = "plasma vessel"
	icon_state = "xgibdown1"
	organ_data_type = /datum/internal_organ/xenos/plasmavessel

/obj/item/organ/xenos/acidgland
	name = "acid gland"
	icon_state = "xgibtorso"
	organ_data_type = /datum/internal_organ/xenos/acidgland

/obj/item/organ/xenos/hivenode
	name = "hive node"
	icon_state = "xgibmid2"
	organ_data_type = /datum/internal_organ/xenos/hivenode

/obj/item/organ/xenos/resinspinner
	name = "hive node"
	icon_state = "xgibmid2"
	organ_data_type = /datum/internal_organ/xenos/resinspinner

//VOX ORGANS.
/datum/internal_organ/stack
	name = "cortical stack"
	removed_type = /obj/item/organ/stack
	robotic = ORGAN_ROBOT
	vital = 1
	var/backup_time = 0
	var/datum/mind/backup

/datum/internal_organ/stack/process()
	/*
	if(owner && owner.stat != 2 && !is_broken())
		backup_time = world.time
		if(owner.mind) backup = owner.mind
	*/

/datum/internal_organ/stack/vox
	removed_type = /obj/item/organ/stack/vox

/datum/internal_organ/stack/vox/stack

/obj/item/organ/stack
	name = "cortical stack"
	icon_state = "brain-prosthetic"
	robotic = ORGAN_ROBOT
	organ_data_type = /datum/internal_organ/stack

/obj/item/organ/stack/vox
	name = "vox cortical stack"
	organ_data_type = /datum/internal_organ/stack/vox
