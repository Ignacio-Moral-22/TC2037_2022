#lang racket

(require racket/trace)

;Examples
; (automaton-1 (dfa-str 'q0 '(q2) delta-ab) "ab")
; (automaton-1 (dfa-str 'start '(int) delta-arithmetic-1) "34+9")

(struct dfa-str (initial-state accept-states transitions))

(define (automaton-1 dfa input-string)
  (let loop
    ([state (dfa-str-initial-state dfa)]
     [chars (string->list input-string)])
    (if (empty? chars)
        (member state (dfa-str-accept-states dfa))
        (loop
         ((dfa-str-transitions dfa) state (car chars))
         (cdr chars)))))


(define (delta-ab state character)
  (case state
    ['q0 (case character
           [(#\a) 'q1]
           [(#\b) 'q3])]
    ['q1 (case character
           [(#\a) 'q3]
           [(#\b) 'q2])]

    ; You already won, just stop
    ['q2 'q3]
    ; Fail state
    ['q3 'q3]))


(define (delta-aab state character)
  (case state
    ['q0 (case character
           [(#\a) 'q2]
           [(#\b) 'q1])]
    ['q1 'q1]
    ['q2 (case character
           [(#\a) 'q0]
           [(#\b) 'q3])]
    ['q3 'q3]))

(define (operator? char)
  (member char '(#\+ #\- #\* #\/ #\^ #\=)))

(define (number-sign? char)
  (member char '(#\+ #\-)))

(define (delta-arithmetic-1 state character)
  (case state
    ['start (cond
              [(char-numeric? character) 'int]
              [(number-sign? character) 'n_sign]
              [else 'fail])]
    ['n_sign (cond
               [(char-numeric? character) 'int]
               [else 'fail])]
    ['int (cond
            [(char-numeric? character) 'int]
            [(operator? character) 'op]
            [else 'fail])]
    ['op (cond
           [(char-numeric? character) 'int]
           [(number-sign? character) 'n_sign]
           [else 'fail])]
    ['fail 'fail]))

(define (delta-arithmetic-2 state character)
; This now has VARs in the states
  (case state
    ['start (cond
              [(char-numeric? character) 'int]
              [(number-sign? character) 'n_sign]
              [(or (char-alphabetic? character) (eq? character #\_)) 'var]
              [else 'fail])]
    ['n_sign (cond
               [(char-numeric? character) 'int]
               [else 'fail])]
    ['int (cond
            [(char-numeric? character) 'int]
            [(operator? character) 'op]
            [else 'fail])]
    ['var (cond
            [(or (char-alphabetic? character) (eq? character #\_)) 'var]
            [(char-numeric? character) 'var]
            [(operator? character) 'op]
            [else 'fail])]
    ['op (cond
           [(char-numeric? character) 'int]
           [(number-sign? character) 'n_sign]
           [(or (char-alphabetic? character) (eq? character #\_)) 'var]
           [else 'fail])]
    ['fail 'fail]))



