# Sample Sort with Processes 

## ssort, should take two arguments:
1. An integer specifying the number of processes to sort with
2. The file to sort

## The input file is structured as follows:
1. First 8 bytes: long size - number of floats in the file
2. Next 4*size bytes: An array of floats

Use mmap for I/O on the file to be sorted.

Use mmap to share data between processes.

Use sample sort to sort the input file, in place.

In addition, each subprocess should print out some text, showing that it’s actually participating in sample sort:

 {p}: start {start}, count {length of local array}

## Example session:

```
$ ./tools/gen-input 20 data.dat
$ ./ssort 4 data.dat
0: start 0.0000, count 3
1: start 7.5690, count 5
2: start 27.1280, count 11
3: start 95.5110, count 1
$ ./tools/check-sorted data.dat
$
```