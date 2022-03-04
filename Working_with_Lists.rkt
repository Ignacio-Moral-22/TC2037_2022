#lang racket
#|
  Code for class TC2037
  Date: 04-03-2022 (dd-mm-yyyy)
  Ignacio Joaquin Moral

  Code involves learning about lists
|#

; lists like (list (0 1 2 3 (+ 1 3))) will go '(0 1 2 3 4)
; lists like '(0 1 2 3 (+ 1 3)) will go '(0 1 2 3 (+ 1 3))

; (cons {value} {listName}) will add {value} to the beginning of {listName}, but not update the list
; (car {listName}) returns the first value of the list
; (cdr {listName}) returns the rest of the list, except the first value.
; You can link these, like (cadr {listName}), (car (cdr (car {listName}))), and others

; (append {value} {listName}) always adds at the end of the list
#|
  in (append {value} {listName}), if {value} is not a list, it will look something like '(0 1 2 3 4 5 6 . 6)
  if {value} is a list, it will work like an inverse (cons)
  append generally works to add elements that AREN'T lists, cond will always consider it a list.
|#

(require racket/trace)

; define a list called datos (data in Spanish) for testing purposes. Generates a list from 0 to 100 jumping in sevens. So all numbers divisible by 7 from 0 to 100
(define datos (range 0 100000 7))

; Replicating the (length {listName}) function, with basic recursion
(define (len lst)
  (if (empty? lst) 0
      (+ 1 (len (cdr lst)))))

; Replicating the (length {listName}) function, with tail recursion
(define (tail_len lst)
  (let loop
    ([lst lst] [result 0])
    (if (empty? lst) result
        (loop (cdr lst) (+ 1 result)))))

; Classwork, define a function called (sum) that takes a list of numbers and adds all the elements. The output should be the result
(define (sum lst)
  (let loop
    ([lst lst] [sum_result 0])
    (if (empty? lst) sum_result
        (loop (cdr lst) (+ sum_result (car lst))))))


; Generate a function that takes a list, and returns a list of the elements in said list, raised to the power of two
(define (sqrt-lst lst)
  (let loop
    ([lst lst] [result '()])
    (if (empty? lst)
        result
        (loop (cdr lst) (append result (list (sqrt (car lst))))))))
; Issue with this. Append is O(n), making this function O(n^2), from having a O(n) inside an O(n) [the loop function]

; Solving this issue with (reverse) and (cons)
(define (sqrt-lst-cons lst)
  (let loop
    ([lst lst] [result '()])
    (if (empty? lst)
        (reverse result)
        (loop (cdr lst) (cons (sqrt (car lst)) result)))))

; Compare how much time a certain function takes, but don't print the result
; With (range 0 100000 7), append takes 1875 milliseconds. cons+reverse takes 15 milliseconds
(define (compare funct data)
  (time (funct data))
  'done)

