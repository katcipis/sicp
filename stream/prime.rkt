#lang racket

(require "numbers.rkt"
         "stream.rkt"
         "filter.rkt")

(define (primes-stream)
  (let ([pstream (naturals-from 1)])
  (define (lazynext)
    (set! pstream (primes-next (kstream-tail pstream)))
    (kstream (kstream-head pstream) lazynext))
  (lazynext)))

(define (primes-next s)
  (kstream (kstream-head s) (lambda ()
    (kfilter s (not-multiple-of (kstream-head s))))))

(define (not-multiple-of i)
  (lambda (x) (not(= (remainder x i) 0))))

(provide primes-stream)
