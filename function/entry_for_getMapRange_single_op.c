#include "mex.h"
#include "matrix.h"
#include "matlab_math.h"

void mexFunction(int nlhs,mxArray* plhs[],int nrhs,const mxArray* prhs[])
{
    double* para        = NULL;
    double* posx_list   = NULL;
    double* posy_list   = NULL;
    double* re_map      = NULL;

    int i,j;

    int row_img = 0;
    int column_img = 0;

    int posx = 0;
    int posy = 0;

    int index_posx = 0;
    int index_posy = 0;

    para        = (double*)mxGetData(prhs[0]);
    posx_list   = (double*)mxGetData(prhs[1]);
    posy_list   = (double*)mxGetData(prhs[2]);
    re_map      = (double*)mxGetData(prhs[3]);

    i           = para[0] - 1;
    row_img     = para[1];
    column_img  = para[2];



    for (j = 0;j != column_img;j ++)
    {

        posx = posx_list[j];
        posy = posy_list[j];





        if (posx > 0 && posx < column_img + 1 && posy > 0 && posy < row_img + 1)
        {


            index_posx = IMG_INDEX((int)(i),(int)(j),0,row_img,column_img,2);
            index_posy = IMG_INDEX((int)(i),(int)(j),1,row_img,column_img,2);

            re_map[index_posx] = posx;
            re_map[index_posy] = posy;
        }

    }
}
