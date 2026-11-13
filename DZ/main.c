#include <stdio.h>
#include <stdlib.h>

int   queue_init(unsigned long capacity);
int   queue_push(long value);
int   queue_pop(long *out);
unsigned long queue_fill_random(unsigned long count, int max_val);
unsigned long queue_get_odds(long *out, unsigned long max);
unsigned long queue_count_ending_1(void);
unsigned long queue_count_primes(void);

static int read_ul(const char *prompt, unsigned long *out)
{
    printf("%s", prompt);
    if (scanf("%lu", out) != 1) {
        fprintf(stderr, "ошибка ввода\n");
        return 0;
    }
    return 1;
}

static int read_l(const char *prompt, long *out)
{
    printf("%s", prompt);
    if (scanf("%ld", out) != 1) {
        fprintf(stderr, "ошибка ввода\n");
        return 0;
    }
    return 1;
}

int main(void)
{
    unsigned long cap, n, i;
    long *odds, val;

    if (!read_ul("Вместимость очереди: ", &cap) || cap == 0) {
        fprintf(stderr, "ошибка вместимости\n");
        return 1;
    }

    if (!queue_init(cap)) {
        fprintf(stderr, "ошибка инициализации очереди\n");
        return 1;
    }
    printf("Очередь инициализована , вместимость = %lu\n", cap);

    if (!read_ul("Как много значений вы хотите вставить? ", &n))
        return 1;
    for (i = 0; i < n; i++) {
        char prompt[64];
        snprintf(prompt, sizeof prompt, "  value[%lu] = ", i);
        if (!read_l(prompt, &val))
            return 1;
        if (!queue_push(val))
            printf("  Очередь заполнена!\n");
    }

    if (!read_ul("Как много случайных значений вы хотите добавить? ", &n))
        return 1;
    unsigned long added = queue_fill_random(n, 1000);
    printf("Добавлено случайных значений из /dev/urandom: %lu\n", added);

    odds = malloc(cap * sizeof(long));
    if (!odds) { perror("malloc"); return 1; }
    unsigned long odds_cnt = queue_get_odds(odds, cap);
    printf("Нечётных чисел (%lu): ", odds_cnt);
    for (i = 0; i < odds_cnt; i++)
        printf("%ld ", odds[i]);
    printf("\n");

    printf("Чисел оканчивающихся на 1: %lu\n", queue_count_ending_1());
    printf("Простые числа: %lu\n", queue_count_primes());

    printf("Удалить первые несколько элементов:\n");
    for (i = 0; i < cap && queue_pop(&val); i++) {
        printf("  popped: %ld\n", val);
        if (i == 9) break;
    }

    free(odds);
    return 0;
}
