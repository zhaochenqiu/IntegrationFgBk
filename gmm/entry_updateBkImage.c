#include "mex.h"
#include "matrix.h"
#include "matlab_math.h"

void mexFunction(int nlhs,mxArray* plhs[],int nrhs,const mxArray* prhs[])
{
    int i,j,q;
    int pos     = 0;
    int value   = 0;

    int update_wei  = 0;
    int row_img     = 0;
    int column_img  = 0;
    int byte_img    = 0;

    int index       = 0;
    int index_tmp   = 0;

    double* para        = NULL;
    double* weight      = NULL;
    double* re_mus      = NULL;
    double* re_sigmas   = NULL;
    double* re_weight   = NULL;
    double* judgemap    = NULL;
    double* image       = NULL;

    para        = (double*)mxGetData(prhs[0]);
    weight      = (double*)mxGetData(prhs[1]);
    re_mus      = (double*)mxGetData(prhs[2]);
    re_sigmas   = (double*)mxGetData(prhs[3]);
    re_weight   = (double*)mxGetData(prhs[4]);
    judgemap    = (double*)mxGetData(prhs[5]);
    image       = (double*)mxGetData(prhs[6]);


    update_wei  = para[0] - 1;
    row_img     = para[1];
    column_img  = para[2];
    byte_img    = para[3];


    for (i = 0;i != row_img;i ++)
    {
        for (j = 0;j != column_img;j ++)
        {
            index = IMG_INDEX((int)(i),(int)(j),0,row_img,column_img,1);


            if (judgemap[index] < 1)
            {
                pos = 0;
                value = 100;

                for (q = 0;q != byte_img;q ++)
                {
                    index = IMG_INDEX((int)(i),(int)(j),(int)(q),row_img,column_img,byte_img);

                    if (value > weight[index])
                    {
                        pos = q;
                        value = weight[index];
                    }
                }

                index = IMG_INDEX((int)(i),(int)(j),(int)(pos),row_img,column_img,byte_img);
                index_tmp = IMG_INDEX((int)(i),(int)(j),0,row_img,column_img,1);

                re_mus[index] = image[index_tmp];
                re_sigmas[index] = 8;
                re_weight[index] = update_wei;
            }
        }
    }

}
