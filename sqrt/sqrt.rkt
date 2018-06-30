#lang racket

(require "damp.rkt" "fixed-point.rkt")


(define (sqrt-base x next guess precision maxiter)
  (fixed-point
    (lambda (guess)
      (+
        guess
        (abs (- (* guess guess) x))
        ))
    next
    guess
    precision
    maxiter
    ))

(define (sqrt-heron x)
  (sqrt-base
    x
    (lambda (guess) (avgdamp
                      (lambda (guess) (/ x guess))
                      guess
                      ))
    1
    0.00001
    1000))

(provide sqrt-heron)
