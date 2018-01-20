
#include "mex.h"
#include "matrix.h"
#include "matlab_math.h"

void mexFunction(int nlhs,mxArray* plhs[],int nrhs,const mxArray* prhs[])
{
    int i,j,q;
    int m,n;

	int convimg_row		= 0;
	int convimg_column	= 0;
	int convimg_byte	= 0;

    double* img_tmp = NULL;
    double* img_tar = NULL;


    dims = mxGetDimensions(prhs[0]);
	img_row		= dims[0];
	img_column	= dims[1];
	img_byte	= dims[2];
	img_data		= (double*)mxGetData(prhs[1]);


	dims = mxGetDimensions(prhs[1]);
	convimg_row		= dims[0];
	convimg_column	= dims[1];
	convimg_byte	= dims[2];
	convimg_data	= (double*)mxGetData(prhs[0]);


}
