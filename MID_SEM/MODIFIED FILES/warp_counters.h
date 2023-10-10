//* COA, have taken help from other group(Priyam's) for the header file
#ifndef WARP_STATE_COUNTER
#define WARP_STATE_COUNTER

// Defining custom indexes for the counter array
enum counters { CYCLE, TOTAL_WARPS, WARP, WAITING, ISSUE, XALU, XMEM, MISSED, OTHERS };
 
// Counter array size
#define NUM_COUNTERS (OTHERS + 1)

// Declaring the counter array
extern unsigned long long warp_state_counters[NUM_COUNTERS];

#endif