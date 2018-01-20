/* fillGM_c.c */

#include "mex.h" 
#include "matrix.h"
#include "../../common_c/matlab_math.h"

// fillGM_c(image,re_image,mask,re_mask,point,rate,threshold,stack1,stack2,imgstack)

void stackpush_pt(double* data,int row,int column,int *pos,int posr,int posc)
{
	int index = 0;
	int temppos = 0;

	temppos = *pos;

	if (temppos == row)
	{
		printf("stack overflow:%i %i\n",temppos,row);

		return;
	}

	index = (int)MATRIX_INDEX(temppos,0,row,column);
	data[index] = posr;

	index = (int)MATRIX_INDEX(temppos,1,row,column);
	data[index] = posc;

	*pos = *pos + 1;

}

void stackpop_pt(double* data,int row,int column,int* pos,int* posr,int* posc)
{
	int index = 0;
	int temppos = 0;
	int tempr = 0;
	int tempc = 0;

	temppos = *pos;

	if (temppos == 0)
	{
		printf("stack empty\n");
		return;
	}
	
	temppos = temppos - 1;

	index = (int)MATRIX_INDEX(temppos,0,row,column);
	tempr = data[index];

	index = (int)MATRIX_INDEX(temppos,1,row,column);
	tempc = data[index];

	*pos = *pos - 1;

	*posr = tempr;
	*posc = tempc;
}


void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
	int i,j,q;
	int stackflag = 0;
	int stackpos1 = 0;
	int stackpos2 = 0;
	int stack_index1 = 0;
	int stack_index2 = 0;
	int temppos = 0;
	bool judge = false;
	int index1 = 0;
	int index2 = 0;
	int value1 = 0;
	int value2 = 0;
	int tempindex = 0;
	int tempvalue = 0;
	int judgevalue = 0;
	double tempdouble = 0;
	int sigma_protect = 0;


	int left	= 10000;
	int top		= 10000;
	int right	= -1;
	int bottom	= -1;
	int imgcount = 0;


	double mus[3];
	double sigmas[3];
	double sum_mus[3];
	double sum_sig[3];


	int ndims;
	const mwSize* dims = NULL;

	int img_row		= 0;
	int img_column	= 0;
	int img_byte	= 0;
	double* img_data = NULL;

	int reimg_row		= 0;
	int reimg_column	= 0;
	int reimg_byte		= 0;
	double* reimg_data	= NULL;

	int mask_row	= 0;
	int mask_column = 0;
	int mask_byte	= 0;
	double* mask_data	= NULL;

	int remask_row		= 0;
	int remask_column	= 0;
	int remask_byte		= 0;
	double* remask_data = NULL;

	int posr = 0;
	int posc = 0;
	double* pos_data = NULL;

	double rate = 0;
	double* rate_data = NULL;

	double threshold = 0;
	double* threshold_data = NULL;

	int stack_row1		= 0;
	int stack_column1	= 0;
	double* stack_data1 = NULL;

	int stack_row2		= 0;
	int stack_column2	= 0;
	double* stack_data2	= NULL;

	int imginfo_row	= 0;
	int imginfo_column	= 0;
	double* imginfo_data	= NULL;

	int posinfo_row = 0;
	int posinfo_column = 0;
	double* posinfo_data	= NULL;

	int showtime = 30;

	if (nrhs != 11)
	{
		printf("Usage: fillGM_c(image,re_image,mask,re_mask,point,rate,threshold,stack1,stack2,imgstack)\n");
		return;
	}
	
	dims = mxGetDimensions(prhs[0]);
	img_row		= dims[0];
	img_column	= dims[1];
	img_byte	= dims[2];
	img_data = (double*)mxGetData(prhs[0]);

	dims = mxGetDimensions(prhs[1]);
	reimg_row		= dims[0];
	reimg_column	= dims[1];
	reimg_byte	= dims[2];
	reimg_data = (double*)mxGetData(prhs[1]);

	dims = mxGetDimensions(prhs[2]);
	mask_row		= dims[0];
	mask_column	= dims[1];
	mask_byte	= dims[2];
	mask_data = (double*)mxGetData(prhs[2]);

	dims = mxGetDimensions(prhs[3]);
	remask_row		= dims[0];
	remask_column	= dims[1];
	remask_byte	= dims[2];
	remask_data = (double*)mxGetData(prhs[3]);

	pos_data = (double*)mxGetData(prhs[4]);
	posr = pos_data[0];
	posc = pos_data[1];

//	rate_data = (double*)mxGetData(prhs[5]);
//	rate = rate_data[0];

//	threshold_data = (double*)mxGetData(prhs[6]);
//	threshold = threshold_data[0];

	dims = mxGetDimensions(prhs[7]);
	stack_row1		= dims[0];
	stack_column1	= dims[1];
	stack_data1 = (double*)mxGetData(prhs[7]);

	dims = mxGetDimensions(prhs[8]);
	stack_row2		= dims[0];
	stack_column2	= dims[1];
	stack_data2 = (double*)mxGetData(prhs[8]);

	dims = mxGetDimensions(prhs[9]);
	imginfo_row		= dims[0];
	imginfo_column	= dims[1];
	imginfo_data	= (double*)mxGetData(prhs[9]);


	dims = mxGetDimensions(prhs[10]);
	posinfo_row		= dims[0];
	posinfo_column	= dims[1];
	posinfo_data	= (double*)mxGetData(prhs[10]);

	
	posr = posr - 1;
	posc = posc - 1;

	if (posr < 0 || posc < 0)
	{
		printf("error position \n");
		return;
	}

	stackpush_pt(stack_data1,stack_row1,stack_column1,&stackpos1,posr,posc);

	imgcount = 0;

	for (i = 0;i != 3;i ++)
	{
		mus[i] = 0;
		sigmas[i] = 0;
		sum_mus[i] = 0;
		sum_sig[i] = 0;
	}
	
	for (i = 0;i != img_byte;i ++ )
	{
		index1 = (int)IMG_INDEX(posr,posc,i,img_row,img_column,img_byte);

		value1 = (int)img_data[index1];
		mus[i] = value1;
		sum_mus[i] = sum_mus[i] + value1;
		sum_sig[i] = sum_sig[i] ;
	}

	stackflag = 1;

	while (!judge)
	{
		if (stackflag == 1)
		{
			stackflag = 2;
			while (stackpos1 != 0)
			{
				stackpop_pt(stack_data1,stack_row1,stack_column1,&stackpos1,&posr,&posc);

				tempindex = (int)IMG_INDEX(posr,posc,0,mask_row,mask_column,mask_byte);
				tempvalue = (int)mask_data[tempindex] + (int)remask_data[tempindex];
			
				if (tempvalue == 0)
				{
					judgevalue = 0;

					for (i = 0;i != 3;i ++)
					{
						index1 = (int)IMG_INDEX(posr,posc,i,img_row,img_column,img_byte);
						value1 = (int)img_data[index1];


						if (value1 == mus[i])
						{
							judgevalue ++;
						}
					}

					if (judgevalue == img_byte)
					{
						imgcount ++;

						if (left > posc)
						{
							left = posc;
						}

						if (top > posr)
						{
							top = posr;
						}

						if (right < posc)
						{
							right = posc;
						}

						if (bottom < posr)
						{
							bottom = posr;
						}


						for (i = 0;i != 3;i ++)
						{
							index1 = (int)IMG_INDEX(posr,posc,i,img_row,img_column,img_byte);
							value1 = (int)img_data[index1];

							tempindex = (int)IMG_INDEX(posr,posc,i,reimg_row,reimg_column,reimg_byte);
							reimg_data[tempindex] = value1;

							tempindex = (int)IMG_INDEX(posr,posc,0,remask_row,remask_column,remask_byte);
							remask_data[tempindex] = 255;
						}

						if (posr - 1 >= 0)
						{
							index1 = (int)IMG_INDEX((int)(posr - 1),posc,0,mask_row,mask_column,mask_byte);
							value1 = (int)mask_data[index1] + (int)remask_data[index1];

							if (value1 == 0)
							{
								stackpush_pt(stack_data2,stack_row2,stack_column2,&stackpos2,posr - 1,posc);
							}
						}
					
						if (posc - 1 >= 0)
						{
							index1 = (int)IMG_INDEX(posr,(int)(posc - 1),0,mask_row,mask_column,mask_byte);
							value1 = (int)mask_data[index1] + (int)remask_data[index1];

							if (value1 == 0)
							{
								stackpush_pt(stack_data2,stack_row2,stack_column2,&stackpos2,posr,posc - 1);
							}
						}

						if (posr + 1 < img_row)
						{
							index1 = (int)IMG_INDEX((int)(posr + 1),posc,0,mask_row,mask_column,mask_byte);
							value1 = (int)mask_data[index1] + (int)remask_data[index1];

							if (value1 == 0)
							{
								stackpush_pt(stack_data2,stack_row2,stack_column2,&stackpos2,posr + 1,posc);
							}
						}

						if (posc + 1 < img_column)
						{
							index1 = (int)IMG_INDEX(posr,(int)(posc + 1),0,mask_row,mask_column,mask_byte);
							value1 = (int)mask_data[index1] + (int)remask_data[index1];

							if (value1 == 0)
							{
								stackpush_pt(stack_data2,stack_row2,stack_column2,&stackpos2,posr,posc + 1);
							}
						}
					}
				}
			}
		}
		
		if (stackflag == 2)
		{
			stackflag = 1;
			while (stackpos2 != 0)
			{
				stackpop_pt(stack_data2,stack_row2,stack_column2,&stackpos2,&posr,&posc);

				tempindex = (int)IMG_INDEX(posr,posc,0,mask_row,mask_column,mask_byte);
				tempvalue = (int)mask_data[tempindex] + (int)remask_data[tempindex];
			
				if (tempvalue == 0)
				{
					judgevalue = 0;

					for (i = 0;i != 3;i ++)
					{
						index2 = (int)IMG_INDEX(posr,posc,i,img_row,img_column,img_byte);
						value2 = (int)img_data[index2];

							
						if (mus[i] == value2)
						{
							judgevalue ++;
						}
					}

					if (judgevalue == img_byte)
					{
						imgcount ++;

						if (left > posc)
						{
							left = posc;
						}

						if (top > posr)
						{
							top = posr;
						}

						if (right < posc)
						{
							right = posc;
						}

						if (bottom < posr)
						{
							bottom = posr;
						}



						for (i = 0;i != 3;i ++)
						{
							index2 = (int)IMG_INDEX(posr,posc,i,img_row,img_column,img_byte);
							value2 = (int)img_data[index2];

							tempindex = (int)IMG_INDEX(posr,posc,i,reimg_row,reimg_column,reimg_byte);
							reimg_data[tempindex] = value2;

							tempindex = (int)IMG_INDEX(posr,posc,0,remask_row,remask_column,remask_byte);
							remask_data[tempindex] = 255;
						}

				
						if (posr - 1 >= 0)
						{
							index2 = (int)IMG_INDEX((int)(posr - 1),posc,0,mask_row,mask_column,mask_byte);
							value2 = (int)mask_data[index2] + (int)remask_data[index2];

							if (value2 == 0)
							{
								stackpush_pt(stack_data1,stack_row1,stack_column1,&stackpos1,posr - 1,posc);
							}
						}
					
						if (posc - 1 >= 0)
						{
							index2 = (int)IMG_INDEX(posr,(int)(posc - 1),0,mask_row,mask_column,mask_byte);
							value2 = (int)mask_data[index2] + (int)remask_data[index2];

							if (value2 == 0)
							{
								stackpush_pt(stack_data1,stack_row1,stack_column1,&stackpos1,posr,posc - 1);
							}

						}

						if (posr + 1 < img_row)
						{
							index2 = (int)IMG_INDEX((int)(posr + 1),posc,0,mask_row,mask_column,mask_byte);
							value2 = (int)mask_data[index2] + (int)remask_data[index2];

							if (value2 == 0)
							{
								stackpush_pt(stack_data1,stack_row1,stack_column1,&stackpos1,posr + 1,posc);
							}
						}

						if (posc + 1 < img_column)
						{
							index2 = (int)IMG_INDEX(posr,(int)(posc + 1),0,mask_row,mask_column,mask_byte);
							value2 = (int)mask_data[index2] + (int)remask_data[index2];

							if (value2 == 0)
							{
								stackpush_pt(stack_data1,stack_row1,stack_column1,&stackpos1,posr,posc + 1);
							}
						}
					}
				}
			}
		}

		if (stackpos1 == 0 && stackpos2 == 0)
		{
			judge = true;
		}

		if (stackpos1 == stack_row1)
		{
			printf("error end 1\n");
			judge = true;
		}

		if (stackpos2 == stack_row2)
		{
			printf("error end 2\n");
			judge = true;
		}
	}

	for (i = 0;i != 3;i ++)
	{
		tempindex = (int)MATRIX_INDEX(0,i,imginfo_row,imginfo_column);
		imginfo_data[tempindex] = mus[i];
		//imginfo_data[tempindex] = mus[i];
	}

	
	tempindex = (int)MATRIX_INDEX(0,0,posinfo_row,posinfo_column);
	posinfo_data[tempindex] = left;

	tempindex = (int)MATRIX_INDEX(0,1,posinfo_row,posinfo_column);
	posinfo_data[tempindex] = top;

	tempindex = (int)MATRIX_INDEX(0,2,posinfo_row,posinfo_column);
	posinfo_data[tempindex] = right;

	tempindex = (int)MATRIX_INDEX(0,3,posinfo_row,posinfo_column);
	posinfo_data[tempindex] = bottom;

	tempindex = (int)MATRIX_INDEX(0,4,posinfo_row,posinfo_column);
	posinfo_data[tempindex] = imgcount;
}
