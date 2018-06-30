#lang racket

(require plot)
(require "damp.rkt")
(require "fixed-point.rkt")

(plot-new-window? #t)

(define wantroot 16)
(define (sqrtest x) (abs (- (* x x) wantroot)))
(define (next x) (/ wantroot x))
(define (dampenednext x) (avgdamp next x) )

(define steps 10)
(define precision 0.00001)

(define (sqrtnodamp x) (fixed-point sqrtest next 1 precision x))
(define (sqrtdamp x) (fixed-point sqrtest dampenednext 1 precision x))

(plot (function sqrtnodamp 0 steps #:label (format "y = sqrt(~a)" wantroot)))

(plot (function sqrtdamp 0 steps #:label (format "y = dampened sqrt(~a)" wantroot)))
