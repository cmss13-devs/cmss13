/mob/var/skincmds = list()
/obj/proc/SkinCmd(mob/user as mob, data as text)

/proc/SkinCmdRegister(mob/user, name as text, O as obj)
			user.skincmds[name] = O

/mob/verb/skincmd(data as text)
	set hidden = TRUE

	var/ref = copytext(data, 1, findtext(data, ";"))
	if (src.skincmds[ref] != null)
		var/obj/a = src.skincmds[ref]
		a.SkinCmd(src, copytext(data, findtext(data, ";") + 1))
