/client/proc/adminpanelweapons()
	set name = "Weapons"
	set category = "Admin.Ship"

	var/weapontype = tgui_alert(src, "What weapon?", "Choose wisely!", list("Missile", "Railgun", "Particle cannon"), 20 SECONDS)
	//switch(weapontype)
		//if("Missile")
		//if("Railgun")
		//if("Particle cannon")
