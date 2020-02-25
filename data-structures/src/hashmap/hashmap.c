// Some of the code that is written was based on in-class code from Jan 31st  
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include <bsd/string.h>
#include <string.h>

#include "hashmap.h"

int
hash(char* key)
{
    int hashVal = 0;
    for (int i = 0; key[i]; ++i) {
	hashVal = hashVal * 67 + key[i];
    }
    return hashVal;
}

hashmap_pair*
make_pair(const char* key, const int val)
{
    hashmap_pair* pp = malloc(sizeof(hashmap_pair));
    strlcpy(pp->key, key, sizeof(key));
    pp->val = val;
    pp->used = true;
    pp->tomb = false;

    return pp;
}

void 
free_pair(hashmap_pair* pp)
{
    if(pp) {
      free(pp);
    }
} 

hashmap_pair* 
make_empty_pair()
{
    hashmap_pair* pp = malloc(sizeof(hashmap_pair));
    pp->key[0] = ' ';
    pp->key[1] = ' ';
    pp->key[2] = ' ';
    pp->key[3] = ' ';
    pp->val = 0;
    pp->used = false;
    pp->tomb = false;

    return pp;
}

hashmap_pair**
empty_map(int nn)
{
    hashmap_pair** hh = calloc(nn, sizeof(hashmap_pair*));
    
    for (int i = 0; i < nn; i++) {
	hh[i] = make_empty_pair();
    }
    
    return hh; 
}

hashmap*
make_hashmap_presize(int nn)
{
    hashmap* hh = calloc(1, sizeof(hashmap));
    hh->size = 0;
    hh->cap = nn;
    hh->data = empty_map(nn);

    return hh;
}

hashmap*
make_hashmap()
{
    return make_hashmap_presize(4);
}

void
free_hashmap(hashmap* hh)
{
    for (int i = 0; i < hh->cap; i++) {
	if (hh->data[i]) {
	    free_pair(hh->data[i]);
	}
    }

    free(hh->data);
    free(hh);
}

int
hashmap_has(hashmap* hh, char* kk)
{
    return hashmap_get(hh, kk) != -1;
}

int
hashmap_get(hashmap* hh, char* kk)
{
    int hashValue = hash(kk) % hh->cap;

    while (strcmp(hh->data[hashValue]->key, kk) != 0){
        if (hh && hh->data && !hh->data[hashValue]->used) {
            return -1;
        }

        hashValue += 1;
	if (hashValue >= hh->cap) {
	    hashValue = 0;
	}
    }

    return hh->data[hashValue]->val;
}

void
hashmap_grow(hashmap* hh)
{
    hh->cap *= 2;
    hashmap_pair** temp = hh->data;
    hh->data = empty_map(hh->cap);  

    for (int i = 0; i < hh->cap / 2; i++) {
	 if (temp[i]->used && !temp[i]->tomb) {
	     int hashValue = hash(temp[i]->key) % hh->cap;
             while (hh->data[hashValue]->used) {
                hashValue += 1;
	        if (hashValue >= hh->cap) {
 		    hashValue = 0;
	        }
	     }
	     free(hh->data[hashValue]);
	     hh->data[hashValue] = temp[i];
	 }
	 else {
	    free(temp[i]);
	 }
    }
    free(temp);
}
    
void
hashmap_put(hashmap* hh, char* kk, int vv)
{
    int hashValue = hash(kk) % hh->cap;
   
    while (strcmp(hh->data[hashValue]->key, kk) != 0) {
        if(hh && hh->data && !hh->data[hashValue]->used) {
            hashValue = -1;
	    break;
        }
        hashValue += 1;
	if (hashValue >= hh->cap) {
	    hashValue = 0;
	}
    }
    if (hashValue == -1) {
	hh->size += 1;
	if (hh->size > hh->cap * 0.5) {
	    hashmap_grow(hh);
	}
  
    int newHash = hash(kk) % hh->cap;
    while (hh->data[newHash]->used) {
	newHash += 1;
	if (newHash >= hh->cap) {
	    newHash = 0;
	}
    }

    free(hh->data[newHash]);
    hh->data[newHash] = make_pair(kk, vv);
    } else {
	hh->data[hashValue]->val = vv;
    }
}

void
hashmap_del(hashmap* hh, char* kk)
{
    long i = hash(kk) & (hh->cap - 1);
    while (i < hh->cap) {
        hashmap_pair* x = hh->data[i];
	if (strcmp(x->key, kk) == 0) {
	    x->tomb = true; 
	}
	i++;
    } 
}

hashmap_pair
hashmap_get_pair(hashmap* hh, int ii)
{
    return *hh->data[ii];
}

void 
print_pair(hashmap_pair* pp) {
    printf("key: %s\n", pp->key);
    printf("val: %d\n", pp->val);
    printf("used: %b\n", pp->used);
    printf("tomb: %b\n", pp->tomb);
}

void
hashmap_dump(hashmap* hh)
{
    printf("== hashmap dump ==\n");
    
    for (int i = 0; i < hh->cap; i++) {
	if (hh->data[i]) {
            print_pair(hh->data[i]);
	}
    }
}

