// Glass shards

/obj/item/shard
	name = "glass shard"
	icon = 'icons/obj/items/shards.dmi'
	icon_state = ""
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 1
	desc = "Could probably be used as ... a throwing weapon?"
	w_class = SIZE_TINY
	force = 5
	throwforce = 8
	item_state = "shard-glass"
	matter = list("glass" = 3750)
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	var/source_sheet_type = /obj/item/stack/sheet/glass
	var/shardsize
	var/count = 1
	garbage = TRUE

/obj/item/shard/attack(mob/living/carbon/M, mob/living/carbon/user)
	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 6)


/obj/item/shard/New()
	shardsize = pick("large", "medium", "small")
	switch(shardsize)
		if("small")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("medium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("large")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)
	icon_state += shardsize
	..()


/obj/item/shard/attackby(obj/item/W, mob/user)
	if ( istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(source_sheet_type) //can be melted into something
			if(WT.remove_fuel(0, user))
				var/obj/item/stack/sheet/NG = new source_sheet_type(user.loc)
				for (var/obj/item/stack/sheet/G in user.loc)
					if(G==NG)
						continue
					if(!istype(G, source_sheet_type))
						continue
					if(G.amount>=G.max_amount)
						continue
					G.attackby(NG, user)
					to_chat(user, "You add the newly-formed glass to the stack. It now contains [NG.amount] sheets.")
				qdel(src)
				return
	return ..()

/obj/item/shard/phoron
	name = "phoron shard"
	desc = "A shard of phoron glass. Considerably tougher then normal glass shards. Apparently not tough enough to be a window."
	force = 8
	throwforce = 15
	icon_state = "phoron"
	source_sheet_type = /obj/item/stack/sheet/glass/phoronglass


// Shrapnel. 
// on_embed is called from projectile.dm, bullet_act(obj/item/projectile/P).
// on_embedded_movement is called from human.dm, handle_embedded_objects().

/obj/item/shard/shrapnel
	name = "shrapnel"
	icon_state = "shrapnel"
	desc = "A bunch of tiny bits of shattered metal."
	matter = list("metal" = 50)
	source_sheet_type = null
	var/damage_on_move = 0.5

/obj/item/shard/shrapnel/proc/on_embed(var/mob/embedded_mob, var/obj/limb/target_organ)
	if(ishuman(embedded_mob) && !isYautja(embedded_mob))
		if(istype(target_organ))
			target_organ.embed(src)

/obj/item/shard/shrapnel/proc/on_embedded_movement(var/mob/living/embedded_mob)
	if(ishuman(embedded_mob) && !isYautja(embedded_mob))
		var/obj/limb/organ = embedded_organ
		if(istype(organ))
			organ.take_damage(damage_on_move * count, 0, 0)
			embedded_mob.pain.apply_pain(damage_on_move * count)


/obj/item/shard/shrapnel/bone_chips
	name = "bone shrapnel chips"
	icon_state = "shrapnel"
	desc = "It looks like it came from a prehistoric animal."
	damage_on_move = 0.4

/obj/item/shard/shrapnel/bone_chips/human
	name = "human bone fragments"
	desc = "Oh god, their bits are everywhere!"

/obj/item/shard/shrapnel/bone_chips/xeno
	name = "alien bone fragments"
	desc = "Sharp, jagged fragments of alien bone. Looks like the previous owner exploded violently..."
