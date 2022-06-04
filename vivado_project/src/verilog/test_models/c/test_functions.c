#include "svdpi.h"
#include <stdlib.h>
#include "dpiheader.h"
#include <math.h>

double frand(void)
{
    return (-1 + 2 * ((double)rand()) / RAND_MAX); 
}

double my_sin(double x) 
{
    return sin(x);
}

double my_cos(double x) 
{
    return cos(x);
}