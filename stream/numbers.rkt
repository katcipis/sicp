#lang racket

(require "stream.rkt")

(define (ones)
  (kstream 1 ones))
  
(define (naturals)
   (define (natgen i)
     (kstream i (lambda () (natgen (+ i 1)))))
   (natgen 0)) 
  
(provide ones naturals)