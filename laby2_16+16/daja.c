#include <stdio.h>
#include <string.h>

const int MAX_SIZE = 1024 + 2;

char input1[MAX_SIZE];
char input2[MAX_SIZE];

char aligned1[MAX_SIZE];
char aligned2[MAX_SIZE];




char out[MAX_SIZE+1];


char daj_ascii(int hex)
{
  return hex <=9 ? 0x30 + hex : 65 + (hex - 0xa);
}

int daj_num(char ascii){
  if(ascii==0) return 0;
  return ascii < 65 ? ascii-0x30 : ascii - 65 + 0xA;
}


void dodaj16(char* out, char* in1, char* in2, char* al1, char* al2, int len1, int len2){
  
  int len = (len1>len2 ? len1 : len2); //max length
  for (int i=0; i<len; i++){//write to aligned buffer according to the string length - left pad
    if(len1 == len2){
      al1[i] = in1[i];
      al2[i] = in2[i];
    } else if (len1 > len2){
      al1[i] = in1[i];
      al2[i] = (i<len-len2 ? 0 : in2[i-(len1-len2)]);
    }else{
      al2[i] = in2[i];
      al1[i] = (i<len-len1 ? 0 : in1[i-(len2-len1)]);
    }
    out[i]=0;
  }
  out[len]=0;
  out[len+1]=0;
  ///already aligned
  //now add one by one hex value, full int is more than enough to fit any single-hex addition
  int overflow = 0;
  for(int i=len-1; i>=0; i--){// paczki po 4
    int n1 = daj_num(al1[i]);
    int n2 = daj_num(al2[i]);
    int w = n1 + n2 + overflow;
    overflow = (w >> 4);// przeniesienie
    out[i+2] = daj_ascii(w & 0xF);// zapis 4 ostatnich bitow
  }
  if(overflow)
    out[1] = daj_ascii(overflow);

}
//00011110 -> 0001

int main ()
{

  fgets (input1, MAX_SIZE, stdin);
  fgets (input2, MAX_SIZE, stdin);
  //if(input1[strlen(input1)-1]=='\n')input1[strlen(input1)-1] = 0;
  //if(input2[strlen(input2)-1]=='\n')input2[strlen(input2)-1] = 0;

  dodaj16(out, input1, input2, aligned1, aligned2, strlen(input1) - 1, strlen(input2) - 1);
  char* out_poczatek = out;
  while(*out_poczatek==0)// kasowanie poczatkowych zer
    out_poczatek++;
  printf("wynik : %s\n", out_poczatek);
  return 0;
}


