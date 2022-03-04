#|
Class of March 1st, 2022.
Ignacio Joaquin Moral
|#
#lang racket

; These functions do exist
(provide factorial factorial_tail !)

(require racket/trace)

; Factorial function, simple recursion
(define (factorial n)
  (if (= 0 n) 1
      (* n (factorial (- n 1)))))

; Factorial function, tail recursion. The "backend" of the function. Has an accumulator where multiplication takes place while recursion moves.
(define (fact_tail n a)
    (if (zero? n)
        a
        (fact_tail (sub1 n) (* n a))))

; Factorial function, tail recursion. Only calls the other function, doesn't do anything else
(define (factorial_tail n)
  (fact_tail n 1)
  )

;F it, backend inside frontend.
(define (factorial_tail_2 n)
  (define (fact_tail_2 n a)
    (if (zero? n)
        a
        (fact_tail_2 (sub1 n) (* n a))))
  (fact_tail_2 n 1)
  )

; (trace function), used for debugging. Must delete after using.
(trace factorial)

#|
How Racket Functions Actually workd
(define (add3 n)
 (+ n 3))

(define add3 (lambda (n) (+ n 3)))

(define answerToLifeUniverseEverything (lambda () 42))
|#


; New Syntaxis
; Use of Let to declare limited scope names

(let
  ([a 1] [b 2])  ; Declaration of local variables
  (+ a b)        ; Expression using them
  )

;(* a b)           This function won't work

; Other way to use "tail recursion". Includes a let loop function.
(define (! n)
  (let loop
    ([n n] [a 1])
    (if (zero? n)
        a
        (loop (sub1 n) (* a n)))))