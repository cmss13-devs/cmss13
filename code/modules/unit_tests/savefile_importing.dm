/**
 * The job of this unit test is to ensure that save files are correctly imported from BYOND to a Tree.
 * It's a rather convoluted process and so this test ensures that something didn't fuck up somewhere.
 */
/datum/unit_test/byond_save_trees
	var/savefile/test_savefile
	var/datum/byond_save_tree/byond_save_tree

	var/list/basic_list
	var/list/assoc_list
	var/var_string

/datum/unit_test/byond_save_trees/proc/setup()
	var/path_byond_file = "data/byond_save_tree_test.sav"
	var/path_tree_file = "data/byond_save_tree_test_tree.sav"
	if(fexists(path_byond_file))
		fdel(path_byond_file)
	if(fexists(path_tree_file))
		fdel(path_tree_file)
	test_savefile = new /savefile(path_byond_file)
	byond_save_tree = new /datum/byond_save_tree(path_tree_file)

	var_string = random_name()
	basic_list = list(rand(), rand(), rand(), "3", "6", "null", "\proper house")
	assoc_list = list("2" = rand(), "4" = "3", "341" = "15134123", "\[22\]\[\]\[\[")

	test_savefile["basic_list"] << basic_list
	test_savefile["assoc_list"] << assoc_list

	test_savefile["null_value"] << null
	test_savefile["empty_list"] << list()

	test_savefile.cd = "/v1/v2"
	test_savefile["var_string"] << var_string

/datum/unit_test/byond_save_trees/Run()
	setup()

	// first, we import the file to a tree
	byond_save_tree.import_byond_savefile(test_savefile)

	// now we seperate out the different values
	var/byond_basic_list = json_encode(basic_list)
	var/tree_basic_list = json_encode(byond_save_tree.get_entry("basic_list"))
	TEST_ASSERT_EQUAL(byond_basic_list, tree_basic_list, "didn't convert basic list correctly")

	var/byond_assoc_list = json_encode(assoc_list)
	var/tree_assoc_list = json_encode(byond_save_tree.get_entry("assoc_list"))
	TEST_ASSERT_EQUAL(byond_assoc_list, tree_assoc_list, "didn't convert associative list correctly")

	var/null_value = byond_save_tree.get_entry("null_value")
	var/default_value = byond_save_tree.get_entry("this_key_doesnt_exist", "defval")
	TEST_ASSERT_NULL(null_value, "read an invalid value for what should be null")
	TEST_ASSERT_EQUAL(default_value, "defval", "didn't grab the default value for a non existant key")

	var/empty_list = byond_save_tree.get_entry("empty_list")
	if(!istype(empty_list, /list))
		TEST_FAIL("empty_list was not a list")
	else
		if(length(empty_list))
			TEST_FAIL("empty_list was not empty")

	var/empty_list_check_default = byond_save_tree.get_entry("empty_list", "123")
	TEST_ASSERT_NOTEQUAL(empty_list_check_default, "123", "grabbed the default value for a key when key exists in tree")

	// Now we check to ensure dir traversal is working as intended
	// we are expecting v1 -> v2 -> var_string
	var/dir_v1 = byond_save_tree.get_entry("v1")
	var/dir_v2 = dir_v1?["v2"]
	var/dir_string = dir_v2?["var_string"]
	TEST_ASSERT_EQUAL(dir_string, var_string, "didn't traverse dirs correctly")

	var/runtime_check_string = random_name()
	byond_save_tree.set_entry("runtime_saving", runtime_check_string)
	byond_save_tree.save()
	var/runtime_read = byond_save_tree.get_entry("runtime_saving")
	TEST_ASSERT_EQUAL(runtime_check_string, runtime_read, "wrote and read the same key but got different values")
	byond_save_tree.wipe()
	runtime_read = byond_save_tree.get_entry("runtime_saving")
	TEST_ASSERT_NULL(runtime_read, "wiped the tree but data remained")
	byond_save_tree.load()
	runtime_read = byond_save_tree.get_entry("runtime_saving")
	TEST_ASSERT_EQUAL(runtime_check_string, runtime_read, "saved and read the same key but got different values, save didn't work as expected")
