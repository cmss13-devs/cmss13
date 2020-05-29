/obj/effect/landmark/objective_landmark
	name = "Objective Landmark"


/obj/effect/landmark/objective_landmark/New()
	. = ..()
	var/document_holder_present = FALSE
	for(var/obj/structure/filingcabinet/fc in loc)
		document_holder_present = TRUE
		break

	switch(name)
		if("Objective Landmark Close")
			if(document_holder_present)
				objective_spawn_close_documents += loc
			else
				objective_spawn_close += loc
			qdel(src)
		if("Objective Landmark Medium")
			if(document_holder_present)
				objective_spawn_medium_documents += loc
			else
				objective_spawn_medium += loc
			qdel(src)
		if("Objective Landmark Far")
			if(document_holder_present)
				objective_spawn_far_documents += loc
			else
				objective_spawn_far += loc
			qdel(src)
		if("Objective Landmark Science")
			if(document_holder_present)
				objective_spawn_science_documents += loc
			else
				objective_spawn_science += loc
			qdel(src)

/obj/effect/landmark/objective_landmark/close
	name = "Objective Landmark Close"

/obj/effect/landmark/objective_landmark/medium
	name = "Objective Landmark Medium"

/obj/effect/landmark/objective_landmark/far
	name = "Objective Landmark Far"

/obj/effect/landmark/objective_landmark/science
	name = "Objective Landmark Science"

var/list/objective_spawn_close = list()
var/list/objective_spawn_medium = list()
var/list/objective_spawn_far = list()
var/list/objective_spawn_science = list()

//Locations that contain docuemnt storage, aka filing cabinets
var/list/objective_spawn_close_documents = list()
var/list/objective_spawn_medium_documents = list()
var/list/objective_spawn_far_documents = list()
var/list/objective_spawn_science_documents = list()