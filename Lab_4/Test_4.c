#include <stdio.h>
#include <stdlib.h>

int main(int argc)
{
    long long n = 0;
    long long sum = 0;
    scanf("%lld", &n);

    for (long long k = 1; k <= n; k++) {
        long long term = k * (k + 4) * (k + 8);
        if (k % 2 == 0)
            sum += term;
        else
            sum -= term;
    }

    printf("%lld\n", sum);
    return 0;
}
