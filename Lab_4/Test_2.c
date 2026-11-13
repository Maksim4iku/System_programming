#include <stdio.h>
#include <stdlib.h>

int main(int argc)
{
    long long n = 0;
    long long sum = 0;
    scanf("%lld", &n);

    for (long long i = 1; i <= n; i++) {
        long long term = i * i;
        if (i % 2 == 0)
            sum -= term;
        else
            sum += term;
    }

    printf("%lld\n", sum);
    return 0;
}
