////////////////////////////////////////////////////////////////////////////////
/// Droppers.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_container/dropper
	name = "Dropper"
	desc = "A dropper. Transfers 5 units."
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,2,3,4,5)
	w_class = SIZE_TINY
	volume = 5
	matter = list("plastic" = 150)
	var/filled = 0

	afterattack(obj/target, mob/user , flag)
		if(!target.reagents || !flag) return

		if(filled)

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("[target] is full."))
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target,/obj/item/reagent_container/food) && !istype(target, /obj/item/clothing/mask/cigarette)) //You can inject humans and food but you cant remove the shit.
				to_chat(user, SPAN_DANGER("You cannot directly fill this object."))
				return

			var/trans = 0

			if(ismob(target))

				var/time = 20 //2/3rds the time of a syringe
				for(var/mob/O in viewers(world_view_size, user))
					O.show_message(SPAN_DANGER("<B>[user] is trying to squirt something into [target]'s eyes!</B>"), 1)

				if(!do_after(user, time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)) return

				if(istype(target , /mob/living/carbon/human))
					var/mob/living/carbon/human/victim = target

					var/obj/item/safe_thing = null
					if( victim.wear_mask )
						if ( victim.wear_mask.flags_inventory & COVEREYES )
							safe_thing = victim.wear_mask
					if( victim.head )
						if ( victim.head.flags_inventory & COVEREYES )
							safe_thing = victim.head
					if(victim.glasses)
						if ( !safe_thing )
							safe_thing = victim.glasses

					if(safe_thing)
						if(!safe_thing.reagents)
							safe_thing.create_reagents(100)
						trans = src.reagents.trans_to(safe_thing, amount_per_transfer_from_this)

						for(var/mob/O in viewers(world_view_size, user))
							O.show_message(SPAN_DANGER("<B>[user] tries to squirt something into [target]'s eyes, but fails!</B>"), 1)
						spawn(5)
							src.reagents.reaction(safe_thing, TOUCH)

						to_chat(user, SPAN_NOTICE(" You transfer [trans] units of the solution."))
						if (src.reagents.total_volume<=0)
							filled = 0
							icon_state = "dropper[filled]"
						return

				for(var/mob/O in viewers(world_view_size, user))
					O.show_message(SPAN_DANGER("<B>[user] squirts something into [target]'s eyes!</B>"), 1)
				src.reagents.reaction(target, TOUCH)

				var/mob/living/M = target

				var/list/injected = list()
				for(var/datum/reagent/R in src.reagents.reagent_list)
					injected += R.name
				var/contained = english_list(injected)
				M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been squirted with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to squirt [M.name] ([M.key]). Reagents: [contained]</font>")
				msg_admin_attack("[user.name] ([user.ckey]) squirted [M.name] ([M.key]) with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(user.a_intent)]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

			trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, SPAN_NOTICE(" You transfer [trans] units of the solution."))
			if (src.reagents.total_volume<=0)
				filled = 0
				icon_state = "dropper[filled]"

		else

			if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
				to_chat(user, SPAN_DANGER("You cannot directly remove reagents from [target]."))
				return

			if(!target.reagents.total_volume)
				to_chat(user, SPAN_DANGER("[target] is empty."))
				return

			var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)

			to_chat(user, SPAN_NOTICE(" You fill the dropper with [trans] units of the solution."))

			filled = 1
			icon_state = "dropper[filled]"

		return

////////////////////////////////////////////////////////////////////////////////
/// Droppers. END
////////////////////////////////////////////////////////////////////////////////
