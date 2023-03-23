/datum/disease/magnitis
	name = "Magnitis"
	max_stages = 4
	spread = "Airborne"
	cure = "Iron"
	cure_id = "iron"
	agent = "Fukkos Miracos"
	affected_species = list("Human")
	curable = 0
	permeability_mod = 0.75
	desc = "This disease disrupts the magnetic field of your body, making it act as if a powerful magnet. Injections of iron help stabilize the field."
	severity = "Medium"

/datum/disease/magnitis/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(2))
				to_chat(affected_mob, SPAN_DANGER("You feel a slight shock course through your body."))
			if(prob(2))
				for(var/obj/conductive in orange(2,affected_mob))
					if(!conductive.anchored && (conductive.flags_atom & CONDUCT))
						step_towards(conductive,affected_mob)
				for(var/mob/living/silicon/silicon in orange(2,affected_mob))
					if(isAI(silicon)) continue
					step_towards(silicon,affected_mob)
						/*
						if(conductive.x > affected_mob.x)
							conductive.x--
						else if(conductive.x < affected_mob.x)
							conductive.x++
						if(conductive.y > affected_mob.y)
							conductive.y--
						else if(conductive.y < affected_mob.y)
							conductive.y++
						*/
		if(3)
			if(prob(2))
				to_chat(affected_mob, SPAN_DANGER("You feel a strong shock course through your body."))
			if(prob(2))
				to_chat(affected_mob, SPAN_DANGER("You feel like clowning around."))
			if(prob(4))
				for(var/obj/conductive in orange(4,affected_mob))
					if(!conductive.anchored && (conductive.flags_atom & CONDUCT))
						var/i
						var/iter = rand(1,2)
						for(i=0,i<iter,i++)
							step_towards(conductive,affected_mob)
				for(var/mob/living/silicon/silicon in orange(4,affected_mob))
					if(isAI(silicon)) continue
					var/i
					var/iter = rand(1,2)
					for(i=0,i<iter,i++)
						step_towards(silicon,affected_mob)
						/*
						if(conductive.x > affected_mob.x)
							conductive.x-=rand(1,min(3,conductive.x-affected_mob.x))
						else if(conductive.x < affected_mob.x)
							conductive.x+=rand(1,min(3,affected_mob.x-conductive.x))
						if(conductive.y > affected_mob.y)
							conductive.y-=rand(1,min(3,conductive.y-affected_mob.y))
						else if(conductive.y < affected_mob.y)
							conductive.y+=rand(1,min(3,affected_mob.y-conductive.y))
						*/
		if(4)
			if(prob(2))
				to_chat(affected_mob, SPAN_DANGER("You feel a powerful shock course through your body."))
			if(prob(2))
				to_chat(affected_mob, SPAN_DANGER("You query upon the nature of miracles."))
			if(prob(8))
				for(var/obj/conductive in orange(6,affected_mob))
					if(!conductive.anchored && (conductive.flags_atom & CONDUCT))
						var/i
						var/iter = rand(1,3)
						for(i=0,i<iter,i++)
							step_towards(conductive,affected_mob)
				for(var/mob/living/silicon/silicon in orange(6,affected_mob))
					if(isAI(silicon)) continue
					var/i
					var/iter = rand(1,3)
					for(i=0,i<iter,i++)
						step_towards(silicon,affected_mob)
						/*
						if(conductive.x > affected_mob.x)
							conductive.x-=rand(1,min(5,conductive.x-affected_mob.x))
						else if(conductive.x < affected_mob.x)
							conductive.x+=rand(1,min(5,affected_mob.x-conductive.x))
						if(conductive.y > affected_mob.y)
							conductive.y-=rand(1,min(5,conductive.y-affected_mob.y))
						else if(conductive.y < affected_mob.y)
							conductive.y+=rand(1,min(5,affected_mob.y-conductive.y))
						*/
	return
