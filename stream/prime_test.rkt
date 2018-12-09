#lang racket

(require rackunit
         "stream.rkt"
         "prime.rkt")

(test-case
  "prime number calculator, the slowest and crappiest =D, represented as a stream"
  (let ([primes (primes-stream)])
    (check-equal? (kstream-nth primes 0) 2)
    (check-equal? (kstream-nth primes 1) 3)
    (check-equal? (kstream-nth primes 2) 5)
    (check-equal? (kstream-nth primes 3) 7)
    (check-equal? (kstream-nth primes 4) 11)))