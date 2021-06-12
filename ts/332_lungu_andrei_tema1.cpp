//grupa 332 Lungu Andrei
#include <iostream>
#include <algorithm>   
#include <random>       
#include <string>
#include <vector>      

using namespace std;

void monte_carlo(int n) {
    vector <string> doors = { "goat", "car", "goat" };

    vector<float> switch_win_prob;
    vector<float> stick_win_prob;

    int switch_wins = 0, stick_wins = 0;

    for (int i = 0; i < n; i++) {

        //shuffle the doors
        random_shuffle(doors.begin(), doors.end());

        random_device rd;  //Will be used to obtain a seed for the random number engine
        mt19937 gen(rd()); //Standard mersenne_twister_engine seeded with rd()
        uniform_int_distribution<> distrib(0, 2); // 0 1 or 2
        int choice = distrib(gen); // contestant choice: 0 1 or 2

        if (doors[choice] != "car") // the contestant doesn't get the car
            switch_wins++;
        else // the contestant gets the car
            stick_wins++;

        // update the values
        switch_win_prob.push_back((float)switch_wins / (float)(i + 1));
        stick_win_prob.push_back((float)stick_wins / (float)(i + 1));
    }

    cout << "winning probability if u always switch " << switch_win_prob.back() * 100 << endl;
    cout << "winning probability if u always stick to your original choice " << stick_win_prob.back() * 100 << endl;

    // or
    /*cout << endl;
    cout << "winning probability if u always switch " << (float)switch_wins / (float)n * 100;
    cout << "winning probability if u always stick to your original choice " << float(stick_wins) / (float)n * 100;*/
}

int main() {
    monte_carlo(10000);
}