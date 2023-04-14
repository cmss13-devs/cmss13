/client/proc/adminpanelweapons()
	set name = "Weapons"
	set category = "Admin.Ship"

	var/weapontype = tgui_alert(src, "What weapon?", "Choose wisely!", list("Missile", "Railgun", "Particle cannon"), 20 SECONDS)

	switch(weapontype)
		if("Missile")
			var/exactplace = tgui_alert(src, "Shoot it at random places, or where you're at?", "Choose wisely!", list("Random", "Where I am"), 20 SECONDS)
			if(exactplace == "Random")
				var/salvo = tgui_alert(src, "Make it a salvo or a single fire?", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(salvo == "Yes")
						var/quantity = tgui_input_number(src, "How many?", "Don't go overboard. Please.", 1, 3, 1, 20, 1)
					if(salvo == "No")
						//abagable

			if(exactplace == "Where I am")
				var/prompt = tgui_alert(src, "Are you sure you want to open fire at the USS Almayer??", "Choose wisely!", list("Yes", "No"), 20 SECONDS)
					if(prompt = "Yes")
						weaponhits(1, mob.loc)

		if("Railgun")
			//abagable
		if("Particle cannon")
			//abagable
