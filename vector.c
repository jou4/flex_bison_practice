#include <stdlib.h>
#include "vector.h"

void vector_resize(Vector *vec, int n)
{
    vec->blocks = realloc(vec->blocks, sizeof(void *) * n);
    vec->nblocks = n;
}

Vector *vector_new()
{
    Vector *vec = (Vector *)malloc(sizeof(Vector));
    vec->blocks = NULL;
    vec->nblocks = 0;
    vec->length = 0;
    return vec;
}

void _vector_destroy(Vector *vec)
{
    free(vec);
}

void vector_add(Vector *vec, void *o)
{
    if(vec->nblocks <= vec->length){
        vector_resize(vec, (vec->nblocks == 0) ? VECTOR_SIZE : vec->nblocks * 2);
    }
    vec->blocks[vec->length++] = o;
}

void vector_set(Vector *vec, int index, void *o)
{
    int need_len = index + 1;
    if(vec->nblocks <= need_len){
        vector_resize(vec, need_len);
    }

    vec->blocks[index] = o;

    if(vec->length < need_len){
        vec->length = need_len;
    }
}

void *vector_get(Vector *vec, int index)
{
    return (vec->nblocks > index) ? vec->blocks[index] : NULL;
}
