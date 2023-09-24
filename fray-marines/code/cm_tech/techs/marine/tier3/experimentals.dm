/datum/tech/droppod/item/combat_implants
	name = "Combat Experimentals"
	desc = "Морпехи получают доступ к передовым эксперементальным технологиям для улучшения производительности на поле боя."
	icon_state = "implants"

	droppod_name = "Experimentals"

	flags = TREE_FLAG_MARINE

	required_points = 25
	tier = /datum/tier/three/additional

	droppod_input_message = "Choose an experimental to retrieve from the droppod."
	options_to_give = 2

/datum/tech/droppod/item/combat_stimulants/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()
	if(!H || !D)
		return

	.["Speed Stimulant"] = /obj/item/reagent_container/hypospray/autoinjector/stimulant/speed_stimulant
	.["Brain Stimulant"] = /obj/item/reagent_container/hypospray/autoinjector/stimulant/brain_stimulant
	.["Experimental Hoverpack"] = /obj/item/hoverpack
	if(H.job == JOB_SQUAD_MEDIC)
		.["Advanced Defibrillator"] = /obj/item/device/defibrillator/compact_adv
	if(H.job == JOB_SQUAD_ENGI)
		.["Breaching Hammer"] = /obj/item/weapon/twohanded/breacher
