#lang racket

(define (avgdamp f x) (/ (+ (f x) x) 2))

(provide avgdamp)
