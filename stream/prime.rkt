#lang racket

(require "numbers.rkt"
         "stream.rkt"
         "filter.rkt")

(define (primes-stream)
  (let ([first (primes-next 2 (naturals-from 3))])
  (kstream 2 (lambda ()
    (let ([next (kstream-tail first)])
       (kstream (kstream-head next) (lambda ()
         (primes-next (kstream-head next) next))))))))

(define (primes-next i s)
  (kstream i (lambda ()
    (kfilter s (not-multiple-of i)))))

(define (not-multiple-of v)
  (lambda (x) (not(= (remainder x v) 0))))

(provide primes-stream)
