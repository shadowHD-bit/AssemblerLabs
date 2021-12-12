//(a+b*c)*(d+e/f)+gh/(k+m)

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <string.h>

int main(int argc, char* argv[]){

//variable defenition
float a,b,c,d,e,f,g,h,k,m;

//variable result
float result;

//more index
int index, i, j;

//variable line
int countLine, indexLine;
char charSimbol;
int lastPID;

//variaable simbols in txt
int nowSimbol, lastSimbol;

//open file
FILE* inputFile = fopen("input.txt", "r");

//create buffer bufstr
char strBuffer[256];
setvbuf(inputFile, strBuffer, _IONBF, 0);


//counting line in txt
countLine = 0;
        for(charSimbol = getc(inputFile); charSimbol != EOF; charSimbol = getc(inputFile)){
                if(charSimbol == '\n')
                        countLine = countLine +1;
        }

printf("\n//--------------------------------------------------------------------------------------//\n");
printf("Equation solution (a+b*c)*(d+e/f)+g*h/(k+m) with parametrs on file input.txt :\n\n");

//read and write variable
pid_t arrChildPID[countLine];
int mainPID = getpid();

//start position in input handle file
fseek(inputFile, 0, SEEK_SET);

//create child pocesses for one str
for(i=0; i<countLine; i++){
        if(getpid() == mainPID){
                arrChildPID[i] = fork();
                if(i == (countLine-1)){
                        lastPID = getpid();
                }
        }
}


if(getpid() != mainPID){
        fscanf(inputFile, "%f %f %f %f %f %f %f %f %f %f", &a, &b, &c, &d, &e, &f, &g, &h, &k, &m);
        result = (a+b*c)*(d+e/f)+((g*h)/(k+m));

        //valid access
        if(f == 0 || (k+m) == 0){
                printf("You write ZERO parametrs in this line! Please, check parametrs f,k,m in file input.txt! (PID:  %d)\n", getpid());
                goto writenZero;
        }

        printf("a = %.1f, b = %.1f, c = %.1f, d = %.1f, e = %.1f, f = %.1f, g = %.1f, h = %.1f, k = %.1f, m = %.1f => result = %.1f (PID: %d)\n", a,b,c,d,e,f,g,h,k,m, result, getpid());

        if(lastPID == getpid()){
                printf("\n//--------------------------------------------------------------------------------------//\n");
        }

}
writenZero:

//continue new procces
for(i = 0; i<countLine; i++){
        while(waitpid(arrChildPID[i], 0, 0)>0);
}

return 0;

}
