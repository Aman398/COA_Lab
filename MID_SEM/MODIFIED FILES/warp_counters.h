//* COA, have taken help from other group(Priyam's) for the header file
#ifndef WARP_STATE_COUNTER
#define WARP_STATE_COUNTER

// Defining custom indexes for the counter array
enum counters { 
    CYCLE, 
    WARP, 
    WAITING_CONTROL_HAZARD, WAITING_SCOREBOARD, WAITING_DIVERGED, 
    WAITING, 
    ISSUE,
    XSP_INT, XSFU, XTENSOR, XDP, XSPEC, 
    XALU, 
    XMEM, 
    MISSED, 
    OTHERS 
};
 
// Counter array size
#define NUM_COUNTERS (OTHERS + 1)

// Declaring the counter array
extern unsigned long long warp_state_counters[NUM_COUNTERS];

#endif