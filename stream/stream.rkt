#lang racket

(require "cons.rkt")

;kstream instead of stream because racket already has a stream

(define (kstream head tail)
  (kons head tail))
  
(define (kstream-head s)
  (kons-head s))
  
(define (kstream-tail s)
  ((kons-tail s)))
  
(provide kstream kstream-head kstream-tail)