# Organizing tests
Test cases should be organized in test sets, which are named collections of individual tests. Test results belonging to the same set are grouped together during test execution. Test sets may also be run individually from the debug menu.

To define a test set:
1.  Make a new folder for your test set in `test/`, e.g. `test/mob_death/`
2.  Make a new file for your test set definition, e.g. `test/mob_death/test_set_mob_death.dm`
4.  Define the test set:
```
/datum/test_case/mob_death  
    test_set = "Mob death"
```
**NOTE**: You should not set the `name` variable for the datum defining a test set.

# Writing test cases
Define test cases like this, preferably in their own files, e.g. `test/TESTSETNAME/TESTCASENAME.dm`:
```
/datum/test_case/TESTSETNAME/TESTCASENAME
    name = "description of what the test case is testing"  

// Run the test in here
// A *falsy return* from this is interpreted as the test *passing*
// Remember: not returning anything is a falsy return by default
/datum/test_case/TESTSETNAME/TESTCASENAME/test()
    ...

// This is run before test()
// Set up stuff you need in the test here
// This could be spawning mobs, items, etc.
/datum/test_case/TESTSETNAME/TESTCASENAME/setUp()  
    ...  
```

`test()` should be a short proc that checks if the program behaved correctly, which can be done by using one or more of the following assertions:

```
// Assert that a statement evaluates to true
/datum/test_case/proc/assertTrue(var/statement, var/fail_msg)

// Assert that a statement evaluates to false
/datum/test_case/proc/assertFalse(var/statement, var/fail_msg)  

// Assert that a equals b
/datum/test_case/proc/assertEquals(var/a, var/b, var/fail_msg)  

// Assert that a > b
/datum/test_case/proc/assertGt(var/a, var/b, var/fail_msg)  

// Assert that a >= b
/datum/test_case/proc/assertGtEq(var/a, var/b, var/fail_msg)  

// Assert that a < b
/datum/test_case/proc/assertLt(var/a, var/b, var/fail_msg)  

// Assert that a <= b
/datum/test_case/proc/assertLtEq(var/a, var/b, var/fail_msg)  

// Assert that a is in the list L
/datum/test_case/proc/assertInList(var/a, var/list/L, var/fail_msg)
```
The `fail_msg` variable is *technically* optional, but should *always* be used. If the test fails on any assertion, `fail_msg` is output by the test framework as an explanation for why the test failed.

If you want finer control over when the test should fail, you can use the `fail()` proc to manually fail the test at any time.
```
// Fails the test with the given message
/datum/test_case/proc/fail(var/fail_msg)
```

 If the test case requires setup before it runs, for example building a room, spawning a mob, etc. you can do it in the `setUp()` proc of your test case.

# Running tests
You have a couple of options for running tests.

There are three in-game debug verbs:
- Run All Tests - Runs *all* test sets, which in turn runs *all* test cases
- Run Test Set - Runs a specific test set, meaning all test cases belonging to the chosen test set
- Run Test Case - Runs a specific test case

The test manager is also available through the global variable `test_executor`. Use the verbose argument for detailed logs:
-   To run all test cases, call:
`test_executor.run_all_tests(var/verbose=FALSE)`

-   To run a specific test set, call:
`test_executor.run_test_set(var/test_set, var/verbose=FALSE)`
**NOTE**: You should be passing the name of the test set into this proc, not the datum defining the test set.

-   To run an individual test, call:
`test_executor.run_individual_test(var/datum/test_case/case, var/verbose=FALSE)`
**NOTE**: You should be passing a test case datum here. The test manager will already have one, but it’s perfectly safe and far easier to just create a new one.

You can also run all test cases when the server boots up by passing the `run_tests` world parameter to Dream Daemon when starting the server. If this is done, the server will begin the round as soon as possible, run all test cases, then shut down. You can also pass the `verbose_tests` parameter for more detailed test logs.

# Interpreting test results
The output from the test depends on whether you’re running all tests, a test set or just a single test case. Whether or not the test ran in verbose mode also affects the log output.

When running individual test cases, `run_individual_test()` will only return a value indicating the result of the test. That is, one of `TEST_PASS`, `TEST_FAIL` or `TEST_ERROR`. These are pretty straightforward, but it should be noted that there is a distinction between a test failing and a test erroring.

The test can only fail if an assertion in the test case fails, meaning that a test fail indicates you have syntactically valid code, but it produces the wrong behavior. If the test *errored*, it means a runtime occured while the test case was running, either in the feature code or the test case code itself. If a test fails or errors, it will always log details. In the case of a fail, the log will include basic information about what kind of assertion failed, while errors also log the full details of the runtime that occured.

Output from a single test case looks like this (`verbose` = true):

`Test  case: Undefibbables should not process - pass`

If you are running a test set, the test manager sums the test results and returns them in a list. The amount of any test result type can be retrieved by indexing `TEST_PASS`, `TEST_FAIL` or `TEST_ERROR` respectively. If the test set is run in verbose mode, it will log how many passes, fails and errors there were in the test set.

Output from a test set looks something like this (`verbose` = true):

```
Test case: Undefibbables should not process - pass
Test case Dead mobs process reagents failed with the following message:  
expected 0 >= 1
Test case: Dead mobs process reagents - fail
...

Finished test set: Mob death  
Pass: 4  
Fail: 1  
Error: 1
```

Running all tests will run every test set, sum the results from each test set, then return them in a list. The amount of any test result type can be retrieved by indexing `TEST_PASS`, `TEST_FAIL` or `TEST_ERROR` respectively. If the tests are run in verbose mode, the only additional log output is which test sets are being run.

Output from running all tests looks something like this (`verbose` = true):
```
Running test set: Mob death  
Test case: Undefibbables should not process - pass  
Test case Dead mobs process reagents failed with the following message:  
expected 0 >= 1  
Test case: Dead mobs process reagents - fail  
...
  
Finished test set: Mob death
Pass: 4  
Fail: 1  
Error: 1  
  
Running test set: Something else
...  
  
Finished 23 test(s) in 381.8 seconds  
----------------------------------------  
Pass: 16  
Fail: 6  
Error: 1  
----------------------------------------
```
