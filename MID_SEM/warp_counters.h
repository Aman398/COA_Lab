#ifndef WARP_STATE_COUNTER
#define WARP_STATE_COUNTER

// Defining custom indexes for the counter array
enum counters { CYCLE, TOTAL_WARPS, WARP, WAITING, ISSUE, XALU, XMEM, OTHERS };

// Counter array size
#define NUM_COUNTERS (OTHERS + 1)

// Declaring the counter array
extern unsigned long long warp_state_counters[NUM_COUNTERS];

#endif