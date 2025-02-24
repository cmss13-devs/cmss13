/proc/dir2text_ru(direction, declent = NOMINATIVE)
	var/static/list/dirs_ru
	if(!length(dirs_ru))
		dirs_ru = list(
			"north" = ru_names_toml("north"),
			"south" = ru_names_toml("south"),
			"east" = ru_names_toml("east"),
			"west" = ru_names_toml("west"),
			"northeast" = ru_names_toml("northeast"),
			"southeast" = ru_names_toml("southeast"),
			"northwest" = ru_names_toml("northwest"),
			"southwest" = ru_names_toml("southwest"),
		)
	var/dir_en = dir2text(direction)
	return dirs_ru[dir_en][declent] || dir_en
