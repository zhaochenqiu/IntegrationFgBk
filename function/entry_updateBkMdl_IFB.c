#include "mex.h"
#include "matrix.h"
#include "matlab_math.h"

void mexFunction(int nlhs,mxArray* plhs[],int nrhs,const mxArray* prhs[])
{

    int i,j,q;
    int row_t       = 0;
    int column_t    = 0;
    int byte_t      = 0;
    int pos         = 0;
    int value       = 0;

    int index       = 0;
    int index_img   = 0;

    double* para        = NULL;
    double* mus         = NULL;
    double* weights     = NULL;
    double* grayimg_cur = NULL;
    double* indexmap    = NULL;

    para        = (double*)mxGetData(prhs[0]);
    mus         = (double*)mxGetData(prhs[1]);
    weights     = (double*)mxGetData(prhs[2]);
    grayimg_cur = (double*)mxGetData(prhs[3]);
    indexmap    = (double*)mxGetData(prhs[4]);

    row_t       = para[0];
    column_t    = para[1];
    byte_t      = para[2];

    for (i = 0;i != row_t;i ++)
    {
        for (j = 0;j != column_t;j ++)
        {
            index_img = IMG_INDEX((int)(i),(int)(j),0,row_t,column_t,1);
            if (indexmap[index_img] > 0)
            {
                pos = 0;
                value = -1;

                for (q = 0;q != byte_t;q ++)
                {
                    index = IMG_INDEX((int)(i),(int)(j),(int)q,row_t,column_t,byte_t);
                    if (value < weights[index])
                    {
                        value = weights[index];
                        pos = q;
                    }
                }

                index = IMG_INDEX((int)(i),(int)(j),(int)pos,row_t,column_t,byte_t);

                mus[index] = grayimg_cur[index_img];
            }
        }
    }
}
