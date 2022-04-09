#|
Actividad 3.2 Programando un DFA

Program that allows identification of equation tokens based on a string
provided by the user.

Run this program with (arithmetic-lexer "your-string-here")

Ignacio Joaquin Moral A01028470
Alfredo JeongHyun Park A01658259
|#

#lang racket

(require racket/trace)

(provide arithmetic-lexer)

; Define structures that will allow us to check different activities in the current state
(struct dfa-str (initial-state accept-states transitions))

(define (automaton-1 dfa input-string)
  (let loop
    
    ([state (dfa-str-initial-state dfa)]       ; Current State
     [chars (string->list input-string)]       ; List of Characters
     [listOfChars null]                        ; List of Chars Found
     [result null])                            ; List of Tokens with their Representation Found

    ; Reach the end of the string
    (if (empty? chars)
        ; If it's a member of the accept states
        (if (member state (dfa-str-accept-states dfa))
            ; Eliminate spaces at the end, else add the last known state
            (if (eq? state 'space) (reverse result)
             (reverse (cons (list (list->string (reverse listOfChars)) state) result))) #f)
        ; Recursive Loop with the new state and the rest of the list
        (let-values
            ([(token new_state) ((dfa-str-transitions dfa) state (car chars))])
          (loop
           new_state
           (cdr chars)

           ;If a token is identified, or the token is a space reset the list of characters added.
           ;Else, if it's not a space, append the current character to the list
           (if token
               (list (car chars))
               (if (eq? token 'space)
                   (list (car chars))
                   (cons (car chars) listOfChars)))

           ; Update the list of tokens found
           ; If it's a space, or there's no token found, just send back previous results.
           ; If it's not a space, create a pair of token and characters, and add to the list
           ; of results.
           
           (if token
               (if (eq? token 'space)
                   result
                   (cons (list (list->string (reverse listOfChars)) token) result))
               result)
           )))))


(define (operator? char)
  (member char '(#\+ #\- #\* #\^)))

(define (parenthesis? char)
  (member char '(#\( #\))))

(define (number-sign? char)
  (member char '(#\+ #\-)))

(define (delta-arithmetic-2 state character)
  (case state
    ['start (cond
              [(char-numeric? character) (values #f 'int)]
              [(number-sign? character) (values #f 'n_sign)]
              [(or (char-alphabetic? character) (eq? character #\_)) (values #f 'var)]
              [(eq? character #\() (values #f 'par_open)]
              [(eq? character #\space) (values #f 'space)]
              [else (values #f 'fail)])]

    ; Numeric sign. If it's followed by a number, it's a sign.
    ; If it's followed by a space is an operator, else it's WRONG
    ['n_sign (cond
               [(char-numeric? character) (values #f 'int)]
               [(eq? character #\space) (values 'op 'space)]
               [else (values #f 'fail)])]

    ; Integers
    ['int (cond
            [(char-numeric? character) (values #f 'int)]
            [(operator? character) (values 'int 'op)]
            [(eq? character #\/) (values 'int 'diagonal)]
            [(eq? character #\=) (values 'int 'eq)]
            [(eq? character #\.) (values #f 'float)]
            [(or (eq? character #\e) (eq? character #\E)) (values #f 'e)]
            [(eq? character #\)) (values 'exp 'par_close)]
            [(eq? character #\space) (values 'int 'space)]
            [else (values #f 'fail)])]

    ; If a point is found in an int, change to float
    ['float (cond
            [(char-numeric? character) (values #f 'float)]
            [(operator? character) (values 'float 'op)]
            [(eq? character #\/) (values 'float 'diagonal)]
            [(eq? character #\=) (values 'float 'eq)]
            [(or (eq? character #\e) (eq? character #\E)) (values #f 'e)]
            [(or (char-alphabetic? character) (eq? character #\_)) (values 'float 'var)]
            [(eq? character #\)) (values 'exp 'par_close)]
            [(eq? character #\space) (values 'float 'space)]
            [else (values #f 'fail)])]

    ; Variables. Start in letter or underscore
    ['var (cond
            [(or (char-alphabetic? character) (eq? character #\_)) (values #f 'var)]
            [(char-numeric? character) (values #f 'var)]
            [(operator? character) (values 'var 'op)]
            [(eq? character #\/) (values 'var 'diagonal)]
            [(eq? character #\=) (values 'var 'eq)]
            [(eq? character #\)) (values 'var 'par_close)]
            [(eq? character #\space) (values 'var 'space)]
            [else (values #f 'fail)])]

    ; Operations
    ['op (cond
           [(char-numeric? character) (values 'op 'int)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'op 'var)]
           [(eq? character #\() (values 'op 'par_open)]
           [(eq? character #\space) (values 'op 'space)]
           [else (values #f 'fail)])]

    ; Equal sign. Only operator that allows numeric ints, like "-3", after it
    ['eq (cond
           [(char-numeric? character) (values 'op 'int)]
           [(number-sign? character) (values 'op 'n_sign)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'op 'var)]
           [(eq? character #\() (values 'op 'par_open)]
           [(eq? character #\space) (values 'op 'space)]
           [else (values #f 'fail)])]

    ; Diagonal. Has two options, could be the start of a comment, or a division operator.
    ['diagonal (cond
           [(eq? character #\/) (values #f 'comment)]
           [(char-numeric? character) (values 'op 'int)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'op 'var)]
           [(eq? character #\() (values 'op 'par_open)]
           [(eq? character #\space) (values 'op 'space)]
           [else (values #f 'fail)])]

    ; Letter e. Is it an exponent? Or a misclick?
    ['e (cond
           [(eq? character #\-) (values #f 'exp)]
           [(char-numeric? character) (values #f 'exp)]
           [else (values #f 'fail)])]

    ; Exponent found
    ['exp (cond
           [(char-numeric? character) (values #f 'exp)]
           [(operator? character) (values 'exp 'op)]
           [(eq? character #\/) (values 'exp 'diagonal)]
           [(eq? character #\=) (values 'exp 'eq)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'exp 'var)]
           [(eq? character #\)) (values 'exp 'par_close)]
           [(eq? character #\space) (values 'exp 'space)]
           [else (values #f 'fail)])]

    ; Opening Parenthesis
    ['par_open (cond
           [(char-numeric? character) (values 'par_open 'int)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'par_open 'var)]
           [(eq? character #\space) (values 'par_open 'space)]
           [else (values #f 'fail)])]

    ; Closing Parenthesis
    ['par_close (cond
           [(operator? character) (values 'par_close 'op)]
           [(eq? character #\/) (values 'par_close 'diagonal)]
           [(eq? character #\=) (values 'par_close 'eq)]
           [(eq? character #\space) (values 'par_close 'space)]
           [else (values #f 'fail)])]

    ; Spaces conditions
    ['space (cond
           [(eq? character #\space) (values #f 'space)]
           [(char-numeric? character) (values 'space 'int)]
           [(number-sign? character) (values 'space 'n_sign)]
           [(operator? character) (values 'space 'op)]
           [(eq? character #\/) (values 'space 'diagonal)]
           [(eq? character #\=) (values 'space 'eq)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'space 'var)]
           [(eq? character #\() (values 'space 'par_open)]
           [(eq? character #\)) (values 'space 'par_close)]
           [else (values #f 'fail)])]

    ; Comments. Once a comment starts, the rest of the string is a comment.
    ['comment (values #f 'comment)]

    ; Fail condition
    ['fail (values #f 'fail)]))

(define (arithmetic-lexer input-string)
  (automaton-1 (dfa-str 'start '(int var exp float par_close comment space) delta-arithmetic-2) input-string))
