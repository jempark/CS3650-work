# Concept: Sample Sort

Sample sort is a parallel version of quicksort.

## It works as follows:

### Input:
1. An array of N items
2. An integer P for number of processes to use.

### Result:
1. The input array has been sorted.

### Steps:
1. Sample

a. Randomly select 3*(P-1) items from the array.
b. Sort those items.
c. Take the median of each group of three in the sorted array, producing an array (samples) of (P-1) items.
d. Add 0 at the start and +inf at the end (or the min and max values of the type being sorted) of the samples array so it has (P+1) items numbered (0 to P).

2. Partition

a. Spawn P processes, numbered p in (0 to P-1).
b. Each process builds a local array of items to be sorted by scanning the full input and taking items between samples[p] and samples[p+1].
c. Write the number of items (n) taken to a shared array sizes at slot p.

3. Sort locally

a. Each process uses quicksort to sort the local array.

4. Copy local arrays to input.

a. Each process calculates where to put its result array as follows:

i. start = sum(sizes[0 to p - 1]) # that’s sum(zero items) = 0 for p = 0
ii. end = sum(sizes[0 to p]) # that’s sum(1 item) for p = 0

b. Warning: Data race if you don’t synchronize here.
c. Each process copies its sorted array to input[start..end]

5. Cleanup

a. Terminate the P subprocesses. Array has been sorted “in place”.