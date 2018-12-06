#lang racket

(require rackunit
         "stream.rkt"
         "numbers.rkt"
         "filter.rkt")

(test-case
  "filter creates a stream of values where the predicate returns true for each value"
  (define (is-even? v) (= (remainder v 2) 0))
  (define (is-odd? v) (not (is-even? v)))
  (let ([evens (kfilter naturals is-even?)] [odds (kfilter naturals is-odd?)])
    (check-equal? (kstream-nth evens 0) 0)
    (check-equal? (kstream-nth evens 1) 2)
    (check-equal? (kstream-nth evens 2) 4)
    (check-equal? (kstream-nth odds 0) 1)
    (check-equal? (kstream-nth odds 1) 3)
    (check-equal? (kstream-nth odds 2) 5)
    )
)