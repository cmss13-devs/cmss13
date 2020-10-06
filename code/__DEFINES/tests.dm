#define LOG_TEST(X) world.log << "TEST: " + X

#define TEST_PASS  1
#define TEST_FAIL  2
#define TEST_ERROR 3

#define TEST_SET_NAME "setdatum"
#define TEST_ASSERTION_FAIL "testcasefail"

// Be very careful editing this. The CI test script will grep for this specific string
#define TEST_HOST_SUCCESS "ALL TESTS SUCCEEDED"

// Bitflags for making certain datums exempt from certain tests
#define MAP_TEST_EXEMPTION_SPACE 1
#define MAP_TEST_EXEMPTION_APC   2
