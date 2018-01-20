
#include "mex.h"
#include "matrix.h"
#include "matlab_math.h"

void mexFunction(int nlhs,mxArray* plhs[],int nrhs,const mxArray* prhs[])
{
    int i,j;
    int row_img     = 0;
    int column_img  = 0;
    int numlabels   = 0;

    int label   = 0;
    int fgvalue = 0;
    int bkvalue = 0;

    int index   = 0;

    double* para        = NULL;

    double* labelsimg   = NULL;
    double* fgcues      = NULL;
    double* bkcues      = NULL;

    double* simimg      = NULL;

    double* valuelist   = NULL;
    double* numlist     = NULL;


    para        = (double*)mxGetData(prhs[0]);

    labelsimg   = (double*)mxGetData(prhs[1]);
    fgcues      = (double*)mxGetData(prhs[2]);
    bkcues      = (double*)mxGetData(prhs[3]);

    simimg      = (double*)mxGetData(prhs[4]);

    valuelist   = (double*)mxGetData(prhs[5]);
    numlist     = (double*)mxGetData(prhs[6]);

    row_img     = para[0];
    column_img  = para[1];
    numlabels   = para[2];





    for (i = 0;i != row_img;i ++)
    {
        for (j = 0;j != column_img;j ++)
        {
            index = IMG_INDEX((int)(i),(int)(j),0,row_img,column_img,1);

            label   = labelsimg[index];
            fgvalue = fgcues[index];
            bkvalue = bkcues[index];


            numlist[label]  ++;
            valuelist[label] += fgvalue;
            valuelist[label] += bkvalue;
        }
    }




    for (i = 0;i != numlabels;i ++)
    {
        if (numlist[i] < 1)
        {
            numlist[i] = 1;
        }
        valuelist[i] = valuelist[i]/numlist[i];
    }



    for (i = 0;i != row_img;i ++)
    {
        for (j = 0;j != column_img;j ++)
        {
            index = IMG_INDEX((int)(i),(int)(j),0,row_img,column_img,1);

            label = labelsimg[index];

            simimg[index] = valuelist[label];
        }
    }


}
