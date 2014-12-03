#!/usr/bin/guile \
-e main -s
!#

(use-modules (scsh syntax))
(use-modules (scsh scsh))
(use-modules (ice-9 receive))

(define oses '(("1" . "Ubuntu") ("2" . "CentOS")))

(define-syntax Rn
  (syntax-rules ()
    ((Rn exp exp* ...)
     (run (exp exp* ...) rd))))

(define-syntax-rule (d cmd cmd* ...)
  (let* ((fl (tmpnam))
	 (r (begin (run (cmd cmd* ...) (> 2 ,fl))
		   (run/string (cat ,fl)))))
    r))

(define (set-os2 os)
  (assoc-ref os (d dialog --cancel-label Quit --menu "Choose OS" 10 30 2 1 Ubuntu 2 CentOS)))

(define (set-os)
  (let* ((fl (tmpnam))
	 (os (begin
	       (run (dialog --cancel-label "Quit" --menu "Choose OS:" 10 30 2 1 "Ubuntu" 2 "CentOS")
		    (> 2 ,fl))
	       (run/string (cat ,fl)))))
    (run (rm ,fl))
    (if (string= os "1") "Ubuntu" "CentOS")))

(define (set-os3 os)
  (receive (status out err)
    (run/collecting (1 2)
		    (dialog --cancel-label Quit --menu "Choose OS" 10 30 2 1 Ubuntu 2 CentOS))
  (assoc-ref os (port->string err))))

(define (main args)
  (let ((os (set-os3 oses)))
    (display (string-append "os is " os "\n"))))




