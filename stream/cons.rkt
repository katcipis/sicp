#lang racket

;kons instead of cons because racket already have a cons
;but I really want my own cons...for fun and profit =D

(define (kons a b)
  (lambda (i)
    (if (= i 1)
        a
        b)))
        
(define (kons-head k)
  (k 1))
  
(define (kons-tail k)
  (k 2))
  
(provide kons kons-head kons-tail)