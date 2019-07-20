/*enumerate primes
How to compile
g++ -std=c++11 -o enumerate_prime enumerate_prime.cpp
time ./enumerate_prime
*/
#include<vector>
#include <cmath>
#include<iostream>
#include<fstream>
using namespace std;

int main() {
    vector<int> primes;
    int i = 2;
    while (i < 1e7) {
        bool divisible = false;
        for (auto p = primes.begin(); p != primes.end(); p++) {
            if (i % *p == 0) {
                divisible = true;
                break;
            }
            if (*p > sqrt(i)) {
                break;
            }
        }
        if (!divisible) {
            primes.push_back(i);
        }
        i += 1;
    }

    ofstream outputfile("cppoutput.csv");
    outputfile << "primes" << endl;
    for (auto p = primes.begin(); p != primes.end(); p++) {
        outputfile << *p << endl;
    }
}