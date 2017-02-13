#include "stdio.h"
#include <dlfcn.h>
typedef int (*fp)(int, int);//wskaznik na funkcje tego typu

int main(){
  int a,b;
  printf("podaj liczbe a \n");
  scanf("%d", &a);
  printf("podaj liczbe b \n");
  scanf("%d", &b);
  
  void* libp = dlopen("./libout.so", RTLD_NOW);
  fp p = (int (*)(int, int)) dlsym(libp, "myadd");
  printf("dodaj dla a i b policzone przez kod assemblera : %d \n\n", (*p)(a,b));
  
  
  float x;
  printf("Teraz podaj jakas liczbe zmiennoprzecinkowa dodatnia \n");
  scanf("%f",&x);
  float (*fun2point)(float)  = (float (*)(float)) dlsym(libp, "Q_rsqrtf");
  printf("funcja rsqr dla tej liczby : %f \n",(*fun2point)(x));
  
  
  return 1;
}