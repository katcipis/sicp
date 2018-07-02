#lang racket

(require "cons.rkt")

;kstream instead of stream because racket already has a stream
;a stream is basically lazy evaluation done manually

(define (kstream head tail)
  (kons head tail))
  
(define (kstream-head s)
  (kons-head s))
  
(define (kstream-tail s)
  ((kons-tail s)))
  
(define (kstream-nth s i)
  (if (= i 0)
    (kstream-head s)
    (kstream-nth (kstream-tail s) (- i 1))))
  
(provide kstream kstream-head kstream-tail kstream-nth)