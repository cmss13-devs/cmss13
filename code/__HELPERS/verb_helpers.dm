// placeholders
/**
  * handles adding verbs and updating the stat panel browser
  *
  * pass the verb type path to this instead of adding it directly to verbs so the statpanel can update
  * Arguments:
  * * target - Who the verb is being added to, client or mob typepath
  * * verb - typepath to a verb, or a list of verbs, supports lists of lists
  */
/proc/add_verb(client/target, verb_or_list_to_add)
	var/list/verbs_list = list()
	if(!islist(verb_or_list_to_add))
		verbs_list += verb_or_list_to_add
	else
		var/list/verb_listref = verb_or_list_to_add
		var/list/elements_to_process = verb_listref.Copy()
		while(length(elements_to_process))
			var/element_or_list = elements_to_process[length(elements_to_process)] //Last element
			elements_to_process.len--
			if(islist(element_or_list))
				elements_to_process += element_or_list //list/a += list/b adds the contents of b into a, not the reference to the list itself
			else
				verbs_list += element_or_list

	target.verbs += verbs_list

/**
  * handles removing verb and sending it to browser to update, use this for removing verbs
  *
  * pass the verb type path to this instead of removing it from verbs so the statpanel can update
  * Arguments:
  * * target - Who the verb is being removed from, client or mob typepath
  * * verb - typepath to a verb, or a list of verbs, supports lists of lists
  */
/proc/remove_verb(client/target, verb_or_list_to_remove)
	var/list/verbs_list = list()
	if(!islist(verb_or_list_to_remove))
		verbs_list += verb_or_list_to_remove
	else
		var/list/verb_listref = verb_or_list_to_remove
		var/list/elements_to_process = verb_listref.Copy()
		while(length(elements_to_process))
			var/element_or_list = elements_to_process[length(elements_to_process)] //Last element
			elements_to_process.len--
			if(islist(element_or_list))
				elements_to_process += element_or_list //list/a += list/b adds the contents of b into a, not the reference to the list itself
			else
				verbs_list += element_or_list

	target.verbs -= verbs_list
