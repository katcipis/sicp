#lang racket

(require rackunit
         "numbers.rkt"
         "stream.rkt")
         
         
(test-case
 "ones generates ones forever"
 (let ([ones-stream (ones)])
   (check-equal? (kstream-head ones-stream) 1)
   (check-equal? (kstream-head (kstream-tail ones-stream)) 1)
   (check-equal? (kstream-head (kstream-tail (kstream-tail ones-stream))) 1)))
   
(test-case
 "naturals"
 (let ([nstream (naturals)])
   (check-equal? (kstream-head nstream) 0)
   (check-equal? (kstream-head (kstream-tail nstream)) 1)
   (check-equal? (kstream-head (kstream-tail (kstream-tail nstream))) 2)))