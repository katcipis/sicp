#lang racket

(require rackunit
         "damp.rkt")

(define (square x) (* x x))
(check-equal? (square 2) 4 "SimpleSquare")
(check-equal? (avgdamp square 2) 3 "DampenedSquare")
(check-equal? (avgdamp square 0) 0 "DampenedZeroSquare")
(check-equal? (sin 1) 0.8414709848078965 "Sin")
(check-equal? (avgdamp sin 1) 0.9207354924039483 "DampenedSin")
