#lang racket

(require "stream.rkt")

(define (ones)
  (kstream 1 ones))
  
(define (naturals-from i)
   (kstream i (lambda () (naturals-from (+ i 1)))))

(define (naturals) (naturals-from 0)) 
  
(provide ones naturals naturals-from)