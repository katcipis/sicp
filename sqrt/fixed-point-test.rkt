#lang racket

(require rackunit
         "fixed-point.rkt")

(define (fake-fixed-point x)
  (lambda (y)
    (if (= x y)
        y
        (+ (* y y) 10)
        )
    )
  )

(define (identity x) x)
(define precision 0.01)

(check-equal? (fixed-point identity identity 1 precision 1) 1 "ConvergeFirstTry")
(check-equal? (fixed-point (fake-fixed-point 10) add1 0 precision 10000) 10 "ConvergeLastTry")
