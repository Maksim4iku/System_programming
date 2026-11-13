#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    if (argc != 4) {
        fprintf(stderr, "Usage: %s a b c\n", argv[0]);
        return 1;
    }

    long long a = atoll(argv[1]);
    long long b = atoll(argv[2]);
    long long c = atoll(argv[3]);

    if (c == 0) {
        fprintf(stderr, "Error: division by zero\n");
        return 1;
    }

    long long result = ((((a - c) * b) / c) * a);

    printf("%lld\n", result);

    return 0;
}
