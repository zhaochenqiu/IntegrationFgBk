
#include "mex.h"
#include "matrix.h"
#include "matlab_math.h"

void mexFunction(int nlhs,mxArray* plhs[],int nrhs,const mxArray* prhs[])
{
    int ndims;
    const mwSize* dims = NULL;

    int row_img     = 0;
    int column_img  = 0;
    int byte_img    = 0;

    double* img_tmp = NULL;
    double* img_tar = NULL;
    double* map = NULL;
    double* range = NULL;

    int left = 0;
    int right = 0;
    int top = 0;
    int bottom = 0;

    int minvalue = 0;

    int i,j,m,n;

    int posx = 0;
    int posy = 0;

    double value_tmp = 0;
    double value_tar = 0;
    int index = 0;
    int index_mapx = 0;
    int index_mapy = 0;

    dims = mxGetDimensions(prhs[0]);
    row_img     = dims[0];
    column_img  = dims[1];
    img_tmp = (double*)mxGetData(prhs[0]);
    img_tar = (double*)mxGetData(prhs[1]);
    map     = (double*)mxGetData(prhs[2]);
    range   = (double*)mxGetData(prhs[3]);

    for (i = 0;i != row_img;i ++)
    {
        for (j = 0;j != column_img;j ++)
        {
            index = IMG_INDEX((int)(i),(int)(j),0,row_img,column_img,1);
            value_tmp = img_tmp[index];

            index_mapx = IMG_INDEX((int)(i),(int)(j),0,row_img,column_img,2);
            index_mapy = IMG_INDEX((int)(i),(int)(j),1,row_img,column_img,2);

            posx = map[index_mapx] - 1;
            posy = map[index_mapy] - 1;





            if (posx != -2 && posy != -2)
            {
                left    = posx - range[0];
                right   = posx + range[0];
                top     = posy - range[0];
                bottom  = posy + range[0];

                left    = MAX(left,0);
                right   = MIN(right,column_img - 1);
                top     = MAX(top,0);
                bottom  = MIN(bottom,row_img - 1);

                minvalue = 255;

                for (m = left;m != right + 1;m ++)
                {
                     for (n = top;n != bottom + 1;n ++)
                     {
                         index = IMG_INDEX((int)(n),(int)(m),0,row_img,column_img,1);

                         value_tar = img_tar[index];

                         if (ABS(value_tar - value_tmp) < minvalue)
                         {
                              minvalue = ABS(value_tar - value_tmp);
                              map[index_mapx] = m + 1;
                              map[index_mapy] = n + 1;
                         }
                     }
                }

            }
        }
    }
}
