
#include "mex.h"
#include "matrix.h"
#include "matlab_math.h"

void mexFunction(int nlhs,mxArray* plhs[],int nrhs,const mxArray* prhs[])
{
    const mwSize* dims = NULL;

    int row_img     = 0;
    int column_img  = 0;
    int byte_img    = 0;

    double* img_src = NULL;
    double* img_res = NULL;
    double* map = NULL;

    int i,j,q;

    int index = 0;

    int index_src = 0;
    int index_res = 0;

    int index_mapx = 0;
    int index_mapy = 0;

    int posx = 0;
    int posy = 0;

    int num;

    dims = mxGetDimensions(prhs[0]);
    row_img     = dims[0];
    column_img  = dims[1];

    num = mxGetNumberOfDimensions(prhs[0]);

    if (num < 3)
    {
        byte_img = 1;
    }
    else
    {
        byte_img = dims[2];
    }




    img_src = (double*)mxGetData(prhs[0]);
    img_res = (double*)mxGetData(prhs[1]);
    map     = (double*)mxGetData(prhs[2]);


    for (i = 0;i != row_img;i ++)
    {
        for (j = 0;j != column_img;j ++)
        {
            index_mapx = IMG_INDEX((int)(i),(int)(j),0,row_img,column_img,2);
            index_mapy = IMG_INDEX((int)(i),(int)(j),1,row_img,column_img,2);

            posx = map[index_mapx];
            posy = map[index_mapy];


            if (posx != -1 && posy != -1)
            {
                posx --;
                posy --;



                for (q = 0;q != byte_img;q ++)
                {
                    index_res = IMG_INDEX((int)(i),(int)(j),(int)(q),       row_img,column_img,byte_img);
                    index_src = IMG_INDEX((int)(posy),(int)(posx),(int)(q), row_img,column_img,byte_img);

                    img_res[index_res] = img_src[index_src];
                }

            }


        }
    }
}
