#lang racket

(require racket/trace)

;Examples
; (automaton-1 (dfa-str 'start '(int) delta-arithmetic-2) "34+9")

(provide arithmetic-lexer)

(struct dfa-str (initial-state accept-states transitions))

(define (automaton-1 dfa input-string)
  (let loop
    ; TODO => Return the list of characters found so that I can later use (list->string) function
    
    ([state (dfa-str-initial-state dfa)]       ; Current State
     [chars (string->list input-string)]       ; List of Characters
     [listOfChars null]
     [result null])                             ; List of Tokens with their Representation Found
     ;[listOfChars null])                       ; List of Chars Found
    
    (if (empty? chars)
        (if (member state (dfa-str-accept-states dfa))
            (reverse (cons (list (list->string (reverse listOfChars)) state) result)) #f)
        ; Recursive Loop with the new state and the rest of the list
        (let-values
            ; TODO => Add a 'value' that is the character returning, or just use the (car chars)
            ; IF USING (car chars), add conditional if the token found is whitespace
            ([(token new_state) ((dfa-str-transitions dfa) state (car chars))])
          (loop
           new_state
           (cdr chars)
           (if token (list (car chars)) (cons (car chars) listOfChars))
           ; Update the list of tokens found
           ; TODO => Reverse the list of chars found, make it a string,
           ; make pair with result, return (cons (pair) result)
           
           (if token (cons (list (list->string (reverse listOfChars)) token) result) result)
           
           #|
           ; TODO => Add chars found to list, to reverse and convert to string later
           (if token null (cons (car chars) listOfChars))
           |#
           )))))

;(if (eq? #f token) result (append (result) (list token)))
;(let-values ([(token new_state) ((dfa-str-transitions dfa) state (car chars))]) (loop new_state (cdr chars) (if (eq? #f token) result (append (result) (list token)))))

(define (operator? char)
  (member char '(#\+ #\- #\* #\^)))

(define (parenthesis? char)
  (member char '(#\( #\))))

(define (number-sign? char)
  (member char '(#\+ #\-)))

(define (delta-arithmetic-2 state character)
; This now has VARs in the states
  (case state
    ['start (cond
              [(char-numeric? character) (values #f 'int)]
              [(number-sign? character) (values #f 'n_sign)]
              [(or (char-alphabetic? character) (eq? character #\_)) (values #f 'var)]
              [(eq? character #\() (values #f 'par_open)]
              [(eq? character #\space) (values #f 'space)]
              [else (values #f 'fail)])]
    
    ['n_sign (cond
               [(char-numeric? character) (values #f 'int)]
               [(eq? character #\space) (values 'op 'space)]
               [else (values #f 'fail)])]
    
    ['int (cond
            [(char-numeric? character) (values #f 'int)]
            [(operator? character) (values 'int 'op)]
            [(eq? character #\/) (values 'int 'diagonal)]
            [(eq? character #\=) (values 'int 'eq)]
            [(eq? character #\.) (values #f 'float)] ; Suspiscious, maybe change to "dot" and send err if it's something like 2.
            [(or (eq? character #\e) (eq? character #\E)) (values #f 'e)]
            [(eq? character #\)) (values 'exp 'par_close)]
            [(eq? character #\space) (values 'int 'space)]
            [else (values #f 'fail)])]
    
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
    
    ['var (cond
            [(or (char-alphabetic? character) (eq? character #\_)) (values #f 'var)]
            [(char-numeric? character) (values #f 'var)]
            [(operator? character) (values 'var 'op)]
            [(eq? character #\/) (values 'var 'diagonal)]
            [(eq? character #\=) (values 'var 'eq)]
            [(eq? character #\)) (values 'var 'par_close)]
            [(eq? character #\space) (values 'var 'space)]
            [else (values #f 'fail)])]
    
    ['op (cond
           [(char-numeric? character) (values 'op 'int)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'op 'var)]
           [(eq? character #\() (values 'op 'par_open)]
           [(eq? character #\space) (values 'op 'space)]
           [else (values #f 'fail)])]
    
    ['eq (cond
           [(char-numeric? character) (values 'op 'int)]
           [(number-sign? character) (values 'op 'n_sign)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'op 'var)]
           [(eq? character #\() (values 'op 'par_open)]
           [(eq? character #\space) (values 'op 'space)]
           [else (values #f 'fail)])]
    
    ['diagonal (cond
           [(eq? character #\/) (values #f 'comment)]
           [(char-numeric? character) (values 'op 'int)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'op 'var)]
           [(eq? character #\() (values 'op 'par_open)]
           [(eq? character #\space) (values 'op 'space)]
           [else (values #f 'fail)])]
    
    ['e (cond
           [(eq? character #\-) (values #f 'exp)]
           [(char-numeric? character) (values #f 'exp)]
           [else (values #f 'fail)])]
    
    ['exp (cond
           [(char-numeric? character) (values #f 'exp)]
           [(operator? character) (values 'exp 'op)]
           [(eq? character #\/) (values 'exp 'diagonal)]
           [(eq? character #\=) (values 'exp 'eq)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'exp 'var)]
           [(eq? character #\)) (values 'exp 'par_close)]
           [(eq? character #\space) (values 'exp 'space)]
           [else (values #f 'fail)])]

    ['par_open (cond
           [(char-numeric? character) (values 'par_open 'int)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'par_open 'var)]
           [(eq? character #\space) (values 'par_open 'space)]
           [else (values #f 'fail)])]

    ['par_close (cond
           [(operator? character) (values 'par_close 'op)]
           [(eq? character #\/) (values 'par_close 'diagonal)]
           [(eq? character #\=) (values 'par_close 'eq)]
           [(eq? character #\space) (values 'par_close 'space)]
           [else (values #f 'fail)])]

    ['space (cond
           [(char-numeric? character) (values 'space 'int)]
           [(number-sign? character) (values 'space 'n_sign)]
           [(operator? character) (values 'space 'op)]
           [(eq? character #\/) (values 'space 'diagonal)]
           [(eq? character #\=) (values 'space 'eq)]
           [(or (char-alphabetic? character) (eq? character #\_)) (values 'space 'var)]
           [(eq? character #\() (values 'space 'par_open)]
           [(eq? character #\)) (values 'space 'par_close)]
           [else (values #f 'fail)])]
           
           
           
    
    ['comment (values #f 'comment)]
    ['fail (values #f 'fail)]))

(define (arithmetic-lexer input-string)
  (automaton-1 (dfa-str 'start '(int var exp float par_close comment) delta-arithmetic-2) input-string))
