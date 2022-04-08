#lang racket

(define (read-file in-file-path)
  (file->string in-file-path))

(define (lowercase-file in-file-path)
  (display-to-file
   (string-downcase (file->string in-file-path))
   "aladdin.txt"
   #:exists 'truncate))

