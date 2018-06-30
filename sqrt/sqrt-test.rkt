#lang racket

(require rackunit
         "sqrt.rkt")

(check-equal? (round (sqrt-heron 4)) 2 "Sqrt4")
(check-equal? (round (sqrt-heron 16)) 4 "Sqrt16")
