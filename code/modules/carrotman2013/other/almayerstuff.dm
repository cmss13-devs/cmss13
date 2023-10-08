////////////////////////
//////SD effects////////
////////////////////////

/datum/authority/branch/evacuation/proc/spawn_sd_effects()
	set background = 1

	var/effectstage9

	spawn while(NUKE_EXPLOSION_ACTIVE)

		if(dest_status == NUKE_EXPLOSION_ACTIVE && world.time >= dest_start_time + 2600) //3  //Тряска камеры и дымка
			var/datum/effect_system/smoke_spread/bad/S = new /datum/effect_system/smoke_spread/bad()
			S.set_up(4, 0, pick(GLOB.mainship_pipes), null, 400)
			S.start()
			S.set_up(4, 0, pick(GLOB.mainship_pipes), null, 400)
			S.start()


		if(dest_status == NUKE_EXPLOSION_ACTIVE && world.time >= dest_start_time + 3100) //4  //первый взрыв
			for(var/mob/living/carbon/M in GLOB.mob_list)
				shake_camera(M, 25, 1)
			explosion(pick(GLOB.mainship_pipes), 0, 1, 3, 0)


		if(dest_status == NUKE_EXPLOSION_ACTIVE && world.time >= dest_start_time + 3400) //5  //тряска сильнее и взрывы c более сильной
			for(var/mob/living/carbon/M in GLOB.mob_list)
				if(prob(10))
					M.KnockDown(3)
					to_chat(M, "\red Пол под ногами дрожит!")
			if(prob(20))
				explosion(pick(GLOB.mainship_pipes), 1, 5, 4, 0)


		if(dest_status == NUKE_EXPLOSION_ACTIVE && world.time >= dest_start_time + 3600) //6  //взрыв каждые 10-15 секунд
			if(prob(30))
				explosion(pick(GLOB.mainship_pipes), 1, 4, 5, 0)
			sleep(20)
			if(prob(70))
				explosion(pick(GLOB.mainship_pipes), 1, 3, 4, 0)


		if(dest_status == NUKE_EXPLOSION_ACTIVE && world.time >= dest_start_time + 4200) //7  //жесткий взрыв, 5-10 секунд
			for(var/mob/living/carbon/M in GLOB.mob_list)
				shake_camera(M, 100, 2)
				if(prob(30))
					M.KnockDown(3)
					to_chat(M, "\red Пол под ногами дрожит!")
			explosion(pick(GLOB.mainship_pipes), 1, 4, 5, 1)


		if(dest_status == NUKE_EXPLOSION_ACTIVE && world.time >= dest_start_time + 4800) //8  //дым почти везде, мало что видно
			var/datum/effect_system/smoke_spread/bad/S = new /datum/effect_system/smoke_spread/bad()
			S.set_up(8, 0, pick(GLOB.mainship_pipes), null, 400)
			S.start()


		if(dest_status == NUKE_EXPLOSION_ACTIVE && !effectstage9 && world.time >= dest_start_time + 5300) //9  //пара очень жестких взрывов
			explosion(pick(GLOB.mainship_pipes), 6, 6, 6, 2)
			sleep(30)
			explosion(pick(GLOB.mainship_pipes), 6, 6, 6, 2)
			effectstage9 = 1


		if(dest_status == NUKE_EXPLOSION_ACTIVE && world.time >= dest_start_time + 5400) //10  //все в дыму
			var/datum/effect_system/smoke_spread/bad/S = new /datum/effect_system/smoke_spread/bad()
			S.set_up(15, 0, pick(GLOB.mainship_pipes), null, 400)
			S.start()

		else if(dest_status == NUKE_EXPLOSION_INACTIVE)
			return

		sleep(60)
