#include <stdio.h>

int main() {
    long long number = 3363522457;
    long long sum = 0;
    long long temp = number;

    if (temp == 0) {
        sum = 0;
    } else {
        while (temp != 0) {
            sum += temp % 10;
            temp /= 10;
        }
    }

    printf("%lld\n", sum);

    return 0;
}
