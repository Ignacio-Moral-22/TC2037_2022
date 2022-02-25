#lang racket

#|
Racket Decision Taking Examples
Ignacio Moral - Gilberto Echeverria's class

25-02-2022
|#

#|Decision Learning with ifs
Syntaxis
(if (condition) (True) (False))|#


(define (get-sign number)
  (if (zero? number) 'Zero
      (if (< 0 number) 'Positive 'Negative)))
#|
  'Name is a symbol
  "Text" is a string
  "Text" can also be used as multi line comment, as long as it
  doesn't affect the flow of the arguments
|#

#|
  Decision learning with cond
Syntaxis
(cond ((opt 1) output) ((opt 2) output) ... (else output))
Can also use Brackets for the Conds, since they function the same as parenthesis
|#

(define (get-sign-cond number)
  (cond
    [(= 0 number) "Zero"]
    [(< 0 number) "Positive"]
    [else "Negative"]))

#|
  Decision learning with case
Syntaxis
(case
 ((opt1 opt2 opt3 opt4) output)
 ((opt5 opt6 opt7 opt8) output))
|#


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Using all we learn to get a "next day" function

(define (leap-year year)
  (if (eq? (modulo year 400) 0)
      #t
      (if (eq? (modulo year 100) 0)
          #f
          (if (eq? (modulo year 4) 0)
              #t
              #f))))

(define (check-next-day day month leap-year)
  (case month
    ((1 3 5 7 8 10 12) (if (eq? day 31) 1 (+ day 1)))
    ((4 6 9 11) (if (eq? day 30) 1 (+ day 1)))
    ((2) (cond
           [(eq? #t leap-year) (if (eq? day 28) 29 (if (eq? day 29) 1 (+ day 1)))]
           [else (if (eq? day 28) 1 (+ day 1))]))))

(define (check-next-month next-day month)
  (if (eq? next-day 1)
      (if (eq? month 12)
          1
          (+ month 1))
      month))

(define (check-next-year next-day next-month year)
  (if (eq? next-day 1)
      (if (eq? next-month 1)
          (+ year 1)
          year)
      year))

(define (next-day-function day month year)
  (define next-day (check-next-day day month (leap-year year)))
  (define next-month (check-next-month next-day month))
  (define next-year (check-next-year next-day next-month year))
  (values next-day next-month next-year))