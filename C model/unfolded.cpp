#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include <direct.h>
#include <iostream>
#define N 8 /// order of the filter
#define NT (N+1) /// number of coeffs
#define NB 12 /// number of bits
#define SHAMT 16 /// shift amount

const int bi[NT]={-13,-28,104,544,830,544,104,-28,-13}; /// b array
const int ai[NT-1]={0, 0}; /// a array

  int d3k[3],d3k1[3],d3k2[3];
int *myfilter(int *x)
{
  static float sx[NT]; /// x shift register
  static int sy[NT-1]; /// y shift register
  static int first_run = 0; /// for cleaning shift registers
  int i; /// index
  int y[3]; /// output sample

  int stmp[27];
  /// clean the buffers
  if (first_run == 0)
  {
    first_run = 1;
    for (i=0; i<NT; i++)
      sx[i] = 0;
    for (i=0; i<NT-1; i++)
      sy[i] = 0;
  d3k[0]=0;
  d3k1[0]=0;
  d3k2[0]=0;  
  d3k[1]=0;
  d3k1[1]=0;
  d3k2[1]=0;  
  d3k[2]=0;
  d3k1[2]=0;
  d3k2[2]=0;  
  }


  
stmp[0]= x[0]*bi[0];	     stmp[1]= d3k2[0]*bi[1]; stmp[2]= d3k1[0]*bi[2];
stmp[3]= d3k[0]*bi[3];     stmp[4]= d3k2[1]*bi[4]; stmp[5]= d3k1[1]*bi[5];
stmp[6]= d3k[1]*bi[6];     stmp[7]= d3k2[2]*bi[7]; stmp[8]= d3k1[2]*bi[8];

stmp[9]= x[1]*bi[0];	stmp[10]= x[0]*bi[1];stmp[11]= d3k2[0]*bi[2];
stmp[12]= d3k1[0]*bi[3] ;   stmp[13]= d3k[0]*bi[4];     stmp[14]= d3k2[1]*bi[5];
stmp[15]= d3k1[1]*bi[6] ;   stmp[16]= d3k[1]*bi[7]    ; stmp[17]= d3k2[2]*bi[8];	

stmp[18]= x[2]*bi[0];	stmp[19]= x[1]*bi[1];stmp[20]= x[0]*bi[2];
stmp[21]= d3k2[0]*bi[3] ;     stmp[22]= d3k1[0]*bi[4]   ;  stmp[23]= d3k[0]*bi[5];
stmp[24]= d3k2[1]*bi[6]  ;    stmp[25]= d3k1[1]*bi[7]  ;   stmp[26]= d3k[1]*bi[8];	
y[0]=0;y[1]=0;y[2]=0;
//stmp[0]=stmp[i]>>16;

  for(int i=0;i<=8;i++){
	y[0]=y[0]+  ((stmp[i]>>SHAMT)<< (SHAMT-NB+1));//shift right is not works, because sign bit is modified
  }  

  for(int i=9;i<=17;i++){
	y[1]=y[1]+  ((stmp[i]>>SHAMT)<< (SHAMT-NB+1));
  }

  for(int i=18;i<=26;i++){
	y[2]=y[2]+  ((stmp[i]>>SHAMT)<< (SHAMT-NB+1));
  }
  /// shift and insert new sample in x shift register
  for (i=2; i>=1; i--)
  {
	d3k[i]=d3k[i-1];	  
	d3k1[i]=d3k1[i-1];
	d3k2[i]=d3k2[i-1];
  }
  d3k[0]=x[0];
  d3k1[0]=x[1];
  d3k2[0]=x[2];
  return &y[0];
}
int main (int argc, char **argv)
{
    char currentDirectory[FILENAME_MAX];
    // 获取当前工作目录
    if (_getcwd(currentDirectory, sizeof(currentDirectory)) != NULL) {
        // 打印当前工作目录
        //printf("当前目录：%s\n", currentDirectory);
		std::cout << "当前目录: " << currentDirectory << std::endl;
    } else {
        perror("获取当前目录失败");
        return 1;
    }

  FILE *fp_in;
  FILE *fp_out;
  int x[3];
  int y[3];

#define debug_0
#ifdef debug_0
	argv[1]="samples.txt";
	argv[2]="resultnew.txt";
#else
  if (argc != 3)
  {
	printf("Use: %s <input_file> <output_file>\n", argv[0]);
	printf("error");
	exit(1);
  }
#endif
  /// open files
  
  /// open files
  fp_in = fopen(argv[1], "r");
  if (fp_in == NULL)
  {
    printf("Error: cannot open %s\n");
    exit(2);
  }
  fp_out = fopen(argv[2], "w");

  /// check shift amount
  if (SHAMT < ((NB)-1))
  {
    printf("Error shift amount must be at least nbit-1\n");
    exit(3);
  }

  /// get samples and apply filter
fscanf(fp_in, "%d", &x[0]);
fscanf(fp_in, "%d", &x[1]);
fscanf(fp_in, "%d", &x[2]);
  do{
	  int *px=x;
	  int *p=myfilter(px);
    y[0] = p[0];
	y[1] = p[1];
	y[2] = p[2];
	
    fprintf(fp_out,"%d\n", y[0]);
    fprintf(fp_out,"%d\n", y[1]);
    fprintf(fp_out,"%d\n", y[2]);	
    fscanf(fp_in, "%d", &x[0]);
    fscanf(fp_in, "%d", &x[1]);
    fscanf(fp_in, "%d", &x[2]);
  } while (!feof(fp_in));

  fclose(fp_in);
  fclose(fp_out);

  return 0;

}
