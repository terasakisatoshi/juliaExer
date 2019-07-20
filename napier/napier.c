#include<stdio.h>
#include<stdlib.h>
#include<time.h>

int trial() {
    int counter = 0;
    double sum = 0;
    while (1) {
        sum += (double)rand() / (double)RAND_MAX;
        counter += 1;
        if ( sum >= 1.0)
            break;
    }
    return counter;
}

int main() {
    srand(time(NULL));
    int n_trial = 100000000;
    int sum = 0;
    for (int i = 0; i < n_trial; i++) {
        sum += trial();
    }
    printf("E(N) = %f\n", (double)sum / (double)n_trial);
    return 0;
}