#lang racket

(define (fixed-point f next x precision maxiter)
  (if (<= maxiter 0)
      x
      (if (<=
            (abs
              (-
                (f x)
                x
                ))
             precision
            )
          x
          (fixed-point f next (next x) precision (- maxiter 1))
      )
  )
)

(provide fixed-point)
