#lang racket

(require rackunit
         "cons.rkt")
         
(test-case
 "kons builds a pair"
 (let ([c (kons 1 2)])
   (check-equal? (kons-head c) 1)
   (check-equal? (kons-tail c) 2)))