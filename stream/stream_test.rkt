#lang racket

(require rackunit
         "stream.rkt")

(test-case
 "stream wont eval tail until asked"
 (let ([called #f])
   (define (next)
     (set! called #t)
     (values "head" "tail"))
     
   (let ([s (kstream 1 next)])
     (check-equal? (kstream-head s) 1)
     (check-equal? called #f)
     (define-values (head tail) (kstream-tail s))
     (check-equal? called #t)
     (check-equal? head "head")
     (check-equal? tail "tail")
     )))
     
(test-case
 "accessing nth element of a stream calls tail nth - 1 times"
 (let ([count 0])
   (define (counter)
     (set! count (+ 1 count))
     (kstream count counter))
     
   (let ([s (kstream "whatever" counter)] [index 5])
     (check-equal? (kstream-nth s index) index)
     (check-equal? count index)
     )))