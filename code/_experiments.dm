// This file contains experimental flags that may not be production ready yet,
// but that we want to be able to easily flip as well as run on CI.
// Any flag you see here can be flipped with the `-D` CLI argument.
// For example, if you want to enable EXPERIMENT_MY_COOL_FEATURE, compile with -DEXPERIMENT_MY_COOL_FEATURE

#if defined(UNIT_TESTS)

#endif

#if DM_VERSION >= 516
#error "Remove all 515 experiments"
#endif
