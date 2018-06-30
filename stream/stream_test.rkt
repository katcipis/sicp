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
     
;TODO: add kstream-nth to index elements on a stream (start looping recursively)