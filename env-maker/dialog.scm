#!/usr/bin/guile \
-e main -s
!#

(use-modules (scsh syntax))

(define oses )

(define (d cmd res)
  "make menu"
  (let* ((fl (tmpnam))
	 (r (begin (run (,cmd) (> 2 ,fl))
		   (run/string (cat ,fl)))))
    (assoc-ref res r)))

(define (set-os2)
  (d "dialog --cancel-label Quit --menu \"Chose OS:\" 10 30 2 1 Ubuntu 2 CentOS" '(("1" . "Ubuntu") ("2" . "CentOS"))))

(define (set-os)
  (let* ((fl (tmpnam))
	 (os (begin
	       (run (dialog --cancel-label "Quit" --menu "Choose OS:" 10 30 2 1 "Ubuntu" 2 "CentOS")
		    (> 2 ,fl))
	       (run/string (cat ,fl)))))
    (run (rm ,fl))
    (if (string= os "1") "Ubuntu" "CentOS")))

(define (main args)
  (let ((os (set-os2)))
    (display (string-append "os is " os))))
