#include "stdio.h"

const int stala = 24;


int main(){
  
  int a,b,result;
  printf("podaj liczbe staloprzecinkowa : \n");
  scanf("%d",&a);
    /* policz najwiekszy wspolny dzielnik za pomoca algorytmu euklidesa */
    __asm__ __volatile__ ("movl %1, %%eax;"
                          "movl %2, %%ebx;"
                          "CONTD: cmpl $0, %%ebx;"
                          "je DONE;"
                          "xorl %%edx, %%edx;"
                          "idivl %%ebx;"
                          "movl %%ebx, %%eax;"
                          "movl %%edx, %%ebx;"
                          "jmp CONTD;"
                          "DONE: movl %%eax, %0;" : "=g" (result) : "g" (a), "g" (stala)
    );

  printf("\n najwiekszy wspolny dzielnik liczb %d i %d to %d \n",a, stala,result);  
  return 1;
}