#ifndef _vector_h_
#define _vector_h_

#define VECTOR_SIZE 256

typedef struct {
    void **blocks;
    int nblocks;
    int length;
} Vector;


#define vector_destroy(vec) _vector_destroy(vec); vec = NULL

Vector *vector_new();
void _vector_destroy(Vector *vec);
void vector_add(Vector *vec, void *o);
void vector_set(Vector *vec, int index, void *o);
void *vector_get(Vector *vec, int index);


#endif
