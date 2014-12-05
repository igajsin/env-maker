#!/usr/bin/guile \
-e main -s
!#

(use-modules (scsh syntax))
(use-modules (scsh scsh))

(define (main args)
  (let ((cmd (cdr args))
	(r (run/string (pipe (ps ) (grep b)))))
    (display r) (newline)))
