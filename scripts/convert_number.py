#!/bin/env python3
# $> ./convert_number.py 101a
# Перевод чисел в(из) разные системы счисления / без мемоизации и math / общие неполные данные
# Дополнительные ссылки: https://ru.wikipedia.org/wiki/Категория:Теория_чисел
# https://en.wikipedia.org/wiki/Integer#External_links / https://en.wikipedia.org/wiki/Number#External_links

import sys

################# Проверяем введенные данные на валидность

if len(sys.argv) != 2:
    sys.exit('нет данных')

number = sys.argv[1]

for i in number:
    if not i.isdigit() and i.lower() not in ['a', 'b', 'c', 'd', 'e', 'f']:
        sys.exit('неверные данные')

################# Преобразование в разные системы счисления

for name, func in {"Двоичный": bin, "Восьмеричный": oct, "Шестнадцатеричный": hex}.items():
    try:
        print(f"{name}: \033[36m{func(int(number))[2:]}\033[0m")
    except:
        pass

################# Преобразование из разных систем счисления

for name, base in {"Из двоичного": 2, "Из восьмеричного": 8, "Из шестнадцатеричного": 16}.items():
    try:
        print(f"{name}: \033[36m{int(number, base)}\033[0m")
    except:
        pass

################# Если в числе только цифры, то продолжаем, иначе выходим

if number.isdigit():
    number = int(number)
else:
    sys.exit()

################# Предопределенные свойства числа

print('Число \033[2;36mдействительное, целое, положительное, натуральное, рациональное\033[0m')

################# Проверка числа на четность битовым способом

printf = ''
if (number & 1):
    printf = 'Число \033[31mнечетное\033[0m'
else:
    printf = 'Число \033[32mчетное\033[0m'

################# Проверяем, простое ли Простое: делится без остатка только на 1 и на само число

def is_prime(n: int) -> bool:
    if n < 2:
        return False
    if n in (2, 3, 5):
        return True
    if n % 2 == 0 or n % 3 == 0 or n % 5 == 0:
        return False
    i = 7
    step = 4
    while i * i <= n:
        if n % i == 0:
            return False
        i += step
        step = 6 - step
    return True


if number > 1:
    if is_prime(number):
        printf += ', \033[36mпростое\033[0m'
    else:
        printf += ', \033[36mсоставное\033[0m'

################# Проверяем, является ли число Полупростое: произведение двух простых чисел

def is_semiprime(n: int) -> bool:
    if n < 4:
        return False
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return is_prime(i) and is_prime(n // i)
    return False

################# Проверяем, является ли число Прямоугольное: n = k(k+1)

def is_pronic(n: int) -> bool:
    if n < 2:
        return False
    s = int(n ** 0.5)
    return s * (s + 1) == n

################# Проверяем, является ли число Сфеническое: произведение 3 различных простых)

def is_sphenic(n: int) -> bool:
    if n < 30:
        return False
    factors = []
    temp = n
    d = 2
    while d * d <= temp:
        if temp % d == 0:
            factors.append(d)
            temp //= d
            if temp % d == 0:
                return False
        d += 1 if d == 2 else 2
    if temp > 1:
        factors.append(temp)
    return len(factors) == 3 and all(is_prime(f) for f in factors)

################# Проверяем, является ли число Бесквадратное: не делится на квадрат простого числа
################# Проверяем, является ли число Избыточное: сумма делителей > 2n
################# Проверяем, является ли число Недостаточное: сумма делителей < 2n
################# Проверяем, является ли число Полнократное: все простые делители в степени >= 2

def factorize(n: int):
    factors = {}
    d = 2
    while d * d <= n:
        if n % d == 0:
            cnt = 0
            while n % d == 0:
                n //= d
                cnt += 1
            factors[d] = cnt
        d += 1 if d == 2 else 2
    if n > 1:
        factors[n] = 1
    return factors


def sum_of_divisors_from_factors(factors: dict) -> int:
    total = 1
    for p, k in factors.items():
        total *= (p ** (k + 1) - 1) // (p - 1)
    return total


def get_number_from_factors(factors: dict) -> int:
    n = 1
    for p, k in factors.items():
        n *= p ** k
    return n


def is_squarefree(factors: dict) -> bool:
    for k in factors.values():
        if k != 1:
            return False
    return True


def is_abundant(factors: dict) -> bool:
    n = get_number_from_factors(factors)
    return sum_of_divisors_from_factors(factors) > 2 * n


def is_deficient(factors: dict) -> bool:
    n = get_number_from_factors(factors)
    return sum_of_divisors_from_factors(factors) < 2 * n
    

def is_powerful(factors: dict) -> bool:
    return all(k >= 2 for k in factors.values())

################# Проверка на фигурные числа / Треугольное: n = k(k+1)/2 => k = (√(8n+1) - 1)/2 / Квадратное: n = k²

def is_triangular(n: int) -> bool:
    if n < 1:
        return False
    s = int((8 * n + 1) ** 0.5)
    return s * s == 8 * n + 1 and (s - 1) % 2 == 0


def is_square(n: int) -> bool:
    if n < 1:
        return False
    s = int(n ** 0.5)
    return s * s == n

################# Проверка на центрированные неагональные числа: Nc(n) = (3n-2)(3n-1)/2

def is_centered_nonagonal(n: int) -> bool:
    if n < 1:
        return False
    D = 9 + 72 * n
    s = int(D ** 0.5)
    return s * s == D and (9 + s) % 18 == 0

################# Проверка на Самопорождённое число: число, которое не может быть получено как n + сумма цифр n

def digit_sum(n: int) -> int:
    s = 0
    while n > 0:
        s += n % 10
        n //= 10
    return s


def is_self_number(n: int) -> bool:
    if n < 1:
        return False
    for i in range(max(1, n - 9 * len(str(n))), n):
        if i + digit_sum(i) == n:
            return False
    return True

################# Проверка на Неприкосновенное число: число, которое не может быть выражено как сумма всех собственных делителей любого числа

def aliquot_sum(n: int) -> int:
    if n < 2:
        return 0
    total = 1
    i = 2
    while i * i <= n:
        if n % i == 0:
            total += i
            if i != n // i:
                total += n // i
        i += 1
    return total


def is_untouchable(n: int, limit: int = 10000) -> bool:
    if n < 2:
        return False
    for i in range(1, limit + 1):
        if aliquot_sum(i) == n:
            return False
    return True

################# Проверяем, является ли число Совершенным

def is_perfect(n: int):
    count = 0
    for p in range(2, n):
        mersenne = 2**p - 1
        if is_prime(mersenne):
            perfect = mersenne * 2**(p-1)
            if perfect > n:
                break
            count += 1
            if perfect == n:
                binary = bin(perfect)[2:]
                print(f"Число \033[36mсовершенное\033[0m (\033[2;32m{count}\033[0m-е), "
                      f"двоичная запись: \033[2;32m{binary}\033[0m "
                      f"(единиц: {binary.count('1')}, нулей: {binary.count('0')})")
                break

################# Проверяем, является ли число числом Мерсенна (вида 2^k - 1)

def is_mersenne_number(n: int) -> bool:
    if n < 1:
        return False
    return (n + 1) & n == 0

################# Проверяем, является ли число числом Каталана Cₙ₊₁ = Cₙ * 2 * (2n + 1) / (n + 2)

def is_catalan_number(num: int) -> bool:
    if num < 1:
        return False
    if num == 1:
        return True
    catalan = 1
    n = 0
    while catalan < num:
        catalan = catalan * 2 * (2 * n + 1) // (n + 2)
        n += 1
        if catalan == num:
            return True
    return False

################# Проверяем, является ли число числом Ферма Fₙ = 2^(2ⁿ) + 1 (c использованием битовых операций)

def is_fermat_number(num: int) -> bool:
    if num < 3:
        return False
    m = num - 1
    if m & (m - 1) != 0:
        return False
    power = m.bit_length() - 1
    return power & (power - 1) == 0

################# Проверяем, является ли число числом Армстронга

def is_armstrong_number(n: int) -> bool:
    if n < 0:
        return False
    digits = str(n)
    power = len(digits)
    return n == sum(int(d) ** power for d in digits)

################# Проверяем, является ли число числом Фибоначчи

def is_fibonacci_number(n: int) -> bool:
    if n < 0:
        return False
    a, b = 0, 1
    while b < n:
        a, b = b, a + b
    return b == n

################# Проверяем, является ли число числом Смита

def is_smith_number(n: int) -> bool:
    if n < 2:
        return False
    def digit_sum(x: int) -> int:
        return sum(int(d) for d in str(x))
    original_sum = digit_sum(n)
    temp = n
    factor_sum = 0
    d = 2 
    while d * d <= temp:
        while temp % d == 0:
            factor_sum += digit_sum(d)
            temp //= d
        d += 1 if d == 2 else 2
    if temp > 1:
        factor_sum += digit_sum(temp)
    return original_sum == factor_sum and n != temp

################# Проверяем, является ли число числом Пелла: P₀ = 0, P₁ = 1, Pₙ = 2·Pₙ₋₁ + Pₙ₋₂

def is_pell(n: int) -> bool:
    if n < 0:
        return False
    if n == 0 or n == 1:
        return True
    a, b = 0, 1
    while b < n:
        a, b = b, 2 * b + a
    return b == n

################# Проверяем, является ли число числом Блюма: n = p * q, p ≠ q, p ≡ 3 (mod 4), q ≡ 3 (mod 4)

def is_blum_integer(n: int) -> bool:
    if n < 9:
        return False
    factors = []
    temp = n
    d = 2
    while d * d <= temp:
        if temp % d == 0:
            count = 0
            while temp % d == 0:
                temp //= d
                count += 1
            factors.append((d, count))
        d += 1 if d == 2 else 2
    if temp > 1:
        factors.append((temp, 1))
    if len(factors) != 2:
        return False
    if factors[0][1] != 1 or factors[1][1] != 1:
        return False
    p, q = factors[0][0], factors[1][0]
    return p % 4 == 3 and q % 4 == 3 and p != q

################# Проверяем, является ли число числом Люка: L₀=2, L₁=1, Lₙ=Lₙ₋₁+Lₙ₋₂

def is_lucas_number(n: int) -> bool:
    if n < 0:
        return False
    a, b = 2, 1
    while b < n:
        a, b = b, a + b
    return b == n or n == 2

################# Проверяем, является ли число палиндромом

def is_palindrome(n: int) -> bool:
    s = str(n)
    return s == s[::-1]

if is_palindrome(number):
    printf += ', \033[36mпалиндром\033[0m'

################# Ограничение для долгих вычислений и вывод данных

def longest(num: int, n: int):
    return True if len(str(num)) <= n else False
        

def longest_num(num: int, n: int):
    if num > n:
        sys.exit()


if longest(number, 19):
    factors = factorize(number)
    
    is_nums = {
    is_squarefree: 'бесквадратное',
    is_abundant: 'избыточное',
    is_deficient: 'недостаточное',
    is_powerful: 'полнократное'
    }
    
    for k, v in is_nums.items():
        if k(factors):
            printf += f', \033[36m{v}\033[0m'
    
    is_num = {
    is_semiprime: 'полупростое',
    is_pronic: 'прямоугольное',
    is_sphenic: 'сфеническое',
    is_triangular: 'треугольное',
    is_square: 'квадратное',
    is_centered_nonagonal: 'центрированное неагональное',
    is_self_number: 'самопорождённое',
    is_untouchable: 'неприкосновенное',
    is_mersenne_number: 'Мерсенна',
    is_catalan_number: 'Каталана',
    is_fermat_number: 'Ферма',
    is_armstrong_number: 'Армстронга',
    is_fibonacci_number: 'Фибоначчи',
    is_smith_number: 'Смита',
    is_pell: 'Пелла',
    is_blum_integer: 'Блума',
    is_lucas_number: 'Люка'
    }
    
    for k, v in is_num.items():
        if k(number):
            printf += f', \033[36m{v}\033[0m'

    is_perfect(number)

print(printf)

################# Вычисляем квадратный корень числа

print(f'Квадратный корень числа: \033[36m{number ** 0.5:.10f}\033[0m')

################# Вычисляем логарифмы

def ln(x: float, precision: float = 1e-12) -> float:
    if x <= 0:
        sys.exit("x должен быть > 0")
    k = 0
    while x > 2:
        x /= 2
        k += 1
    z = (x - 1) / (x + 1)
    z2 = z * z
    result = 0
    term = z
    n = 1
    while abs(term) > precision:
        result += term
        n += 2
        term = term * z2 * (n - 2) / n
    result *= 2
    return result + k * 0.6931471805599453094172321214581765680755


def log2(x: float, precision: float = 1e-12) -> float:
    if x <= 0:
        sys.exit("x > 0")
    return ln(x, precision) / 0.6931471805599453094172321214581765680755


def log10(x: float, precision: float = 1e-12) -> float:
    if x <= 0:
        sys.exit("x должен быть > 0")
    return ln(x, precision) / 2.3025850929940456840179914546843642076011


print(f'Натуральный логарифм: ln(\033[2;32m{number}\033[0m) = \033[36m{ln(float(number)):.10f}\033[0m')
print(f'Десятичный логарифм:  log₁₀(\033[2;32m{number}\033[0m) = \033[36m{log10(float(number)):.10f}\033[0m')
print(f'Двоичный логарифм:    log₂(\033[2;32m{number}\033[0m) = \033[36m{log2(number):.10f}\033[0m')

################# Вычисляем sin cos tan числа в градусах

PI = 3.141592653589793

def sin_deg(x: float, p: float = 1e-12) -> float:
    x = x % 360
    if x > 180:
        x -= 360
    x = x * PI / 180
    result = 0
    term = x
    n = 1
    while abs(term) > p:
        result += term
        n += 2
        term = -term * x * x / (n * (n - 1))
    return result

def cos_deg(x: float, p: float = 1e-12) -> float:
    x = x % 360
    if x > 180:
        x -= 360
    x = x * PI / 180 
    result = 1
    term = 1
    n = 2
    while abs(term) > p:
        term = -term * x * x / (n * (n - 1))
        result += term
        n += 2
    return result

def tg_deg(x: float, p: float = 1e-12) -> float:
    c = cos_deg(x, p)
    if abs(c) < p:
        sys.exit("tg не определен")
    return sin_deg(x, p) / c

print(f'sin(\033[2;32m{number}°\033[0m) = \033[36m{sin_deg(float(number)):.10f}\033[0m  \033[2;32m|\033[0m  '
      f'cos(\033[2;32m{number}°\033[0m) = \033[36m{cos_deg(float(number)):.10f}\033[0m  \033[2;32m|\033[0m  '
      f'tg(\033[2;32m{number}°\033[0m)  = \033[36m{tg_deg(float(number)):.10f}\033[0m')

################# Вычисляем число фибоначчи от порядкового номера числа матричным способом

longest_num(number, 20_000_000)

sys.set_int_max_str_digits(0)


def pow(x, n, I, mult):
    if n == 0:
        return I
    elif n == 1:
        return x
    else:
        y = pow(x, n // 2, I, mult)
        y = mult(y, y)
        if n % 2:
            y = mult(x, y)
        return y


def identity_matrix(n):
    r = list(range(n))
    return [[1 if i == j else 0 for i in r] for j in r]


def matrix_multiply(A, B):
    BT = list(zip(*B))
    return [[sum(a * b
                 for a, b in zip(row_a, col_b))
            for col_b in BT]
            for row_a in A]


def fib(n: int) -> int:
    F = pow([[1, 1], [1, 0]], n, identity_matrix(2), matrix_multiply)
    return F[0][1]


fibonacci = fib(number)
fib_length = len(str(fibonacci))
if fib_length > 5000:
    print(f'Число фибоначчи от порядкового номера числа: \033[2;3;32m{str(fibonacci)[0:500]} '
          f'\033[31m(... вывод урезан ...) \033[32m{str(fibonacci)[-500:]}\033[0m, цифр в числе: {fib_length}')
else:
    print(f'Число фибоначчи от порядкового номера числа: \033[2;3;32m{fibonacci}\033[0m, цифр в числе: {fib_length}')

################# Вычисляем факториал числа

longest_num(number, 300_000)


def factorial(n: int) -> int:
    if n < 0:
        sys.exit("Факториал определен только для неотрицательных чисел")
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result


fact = factorial(number)
fact_length = len(str(fact))
if fact_length > 5000:
    print(f'Факториал числа: \033[2;3;32m{str(fact)[0:500]} \033[31m(... вывод урезан ...) '
          f'\033[32m{str(fact)[-500:]}\033[0m, цифр в числе: {fact_length}')
else:
    print(f'Факториал числа: \033[2;3;32m{fact}\033[0m, цифр в числе: {fact_length}')

