/client/proc/create_custom_paper()
	set name = "Create Custom Paper"
	set category = "Admin.Events"

	customise_paper()

/client/proc/customise_paper(obj/item/paper/sheet)
	var/new_sheet = FALSE
	if(!sheet)
		new_sheet = TRUE
		sheet = new /obj/item/paper
	var/new_name = input(usr, "Enter new item name:", "Customising paper", sheet.name) as text|null
	if(!new_name)
		if(new_sheet)
			qdel(sheet)
		return
	var/new_text = input(usr, "Enter new content:", "Customising [new_name]", sheet.info) as message|null
	if(!new_text)
		if(new_sheet)
			qdel(sheet)
		return
	show_browser(usr, "<body class='paper'>[new_text]</body>", "Custom paper preview", "custom_paper_preview", width = 650, height = 700)
	if(alert(usr, "Make this new content?", "Customising [new_name]", "OK", "Cancel") == "Cancel")
		close_browser(usr, "custom_paper_preview")
		if(new_sheet)
			qdel(sheet)
		return
	close_browser(usr, "custom_paper_preview")
	sheet.name = new_name
	sheet.info = new_text
	sheet.updateinfolinks()
	sheet.update_icon()
	if(new_sheet)
		sheet.loc = get_turf(usr)
	message_admins("[key_name_admin(usr)] [new_sheet ? "created" : "edited"] a paper named [new_name].", sheet.loc.x, sheet.loc.y, sheet.loc.z)
