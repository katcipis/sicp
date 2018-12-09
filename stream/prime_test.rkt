#lang racket

(require rackunit
         "stream.rkt"
         "prime.rkt")

(test-case
  "prime number calculator, the slowest and crappiest =D, represented as a stream"
  (check-equal? (kstream-nth (primes-stream) 0) 2)
  (check-equal? (kstream-nth (primes-stream) 1) 3)
  (check-equal? (kstream-nth (primes-stream) 2) 5)
  (check-equal? (kstream-nth (primes-stream) 3) 7)
  (check-equal? (kstream-nth (primes-stream) 4) 11)
  (check-equal? (kstream-nth (primes-stream) 5) 13)
  (check-equal? (kstream-nth (primes-stream) 6) 17)
  (check-equal? (kstream-nth (primes-stream) 7) 19)
  (check-equal? (kstream-nth (primes-stream) 8) 23))