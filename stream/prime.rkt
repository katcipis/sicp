#lang racket

(require "numbers.rkt"
         "stream.rkt"
         "filter.rkt")

(define (primes-stream)
  (define (lazynext cur)
    (let ([next (primes-next (kstream-tail cur))])
      (kstream (kstream-head next) (lambda () (lazynext next)))))
  (lazynext (naturals-from 1)))

(define (primes-next s)
  (kstream (kstream-head s) (lambda ()
    (kfilter s (not-multiple-of (kstream-head s))))))

(define (not-multiple-of i)
  (lambda (x) (not(= (remainder x i) 0))))

(provide primes-stream)
