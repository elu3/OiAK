#include "stdio.h"

void funkcja1(int ile){
  int i,j;
  for(i=0; i<ile; i++)
  {
  for(j=0; j<i+1; j++)
    printf("*");
  printf("\n");
  }
}