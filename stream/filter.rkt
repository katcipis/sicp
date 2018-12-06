#lang racket

(require "stream.rkt")

(define (kfilter s predicate)
  (let ([next (kfilter-next s predicate)])
    (kstream 
      (kstream-head next)
      (lambda () (kfilter (kstream-tail next) predicate))) 
   ))

(define (kfilter-next s predicate)
  (if (predicate (kstream-head s))
    s
    (kfilter-next (kstream-tail s) predicate)))

(provide kfilter)