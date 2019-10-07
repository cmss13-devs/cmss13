#define LOG_TEST(X) world.log << "TEST: " + X

#define TEST_PASS  1
#define TEST_FAIL  2
#define TEST_ERROR 3

#define TEST_SET_NAME "setdatum"
#define TEST_ASSERTION_FAIL "testcasefail"

// Be very careful editing this. The CI test script will grep for this specific string
#define TEST_HOST_SUCCESS "ALL TESTS SUCCEEDED"