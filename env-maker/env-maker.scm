#!/usr/bin/guile \
-e main -s
!#

(use-modules (ice-9 getopt-long))
(use-modules (scsh syntax))
(use-modules (ice-9 regex))

(define option-spec '((version (single-char #\v) (value #f))
			   (help (single-char #\h) (value #f))
			   (os (single-char #\o) (value #t))
			   (iso (single-char #\i) (value #t))
			   (test-group (single-char #\t) (value #t))
			   (node-num (single-char #\n) (value #t))))

(define oses '(("1" . "Ubuntu") ("2" . "CentOS")))
(define fuel-main "/home/gajsin/src/fuel-main")

(define-syntax-rule (d cmd cmd* ...)
  (let* ((fl (tmpnam))
	 (r (begin (run (cmd cmd* ...) (> 2 ,fl))
		   (run/string (cat ,fl)))))
    r))

(define (set-os os)
  (assoc-ref os (d dialog --cancel-label Quit --menu "Choose OS" 10 30 2 1 Ubuntu 2 CentOS)))

(define (help-message help-wanted)
  (when help-wanted
    (display "\
Usage: env-maker.scm [options]
   -v, --version\tDisplay version
   -h, --help\t\tDisplay this help
   -o, --os\t\tChoose Ubuntu or CentOS
   -i, --iso\t\tPath to fuel master iso
   -t, --test-group\tName of testgroup which will be launched
   -n, --node-num\tNumber of node for creation
")
    (quit)))

(define (version-message v)
  (when v (display "0.1\n")
	(quit)))

(define (check-iso iso)
  (when (or (not iso) (not (file-exists? iso)))
    (d dialog --title "Fuel master iso not found" --msgbox "Please set correct path to fuel master iso" 5 40)
    (quit)))

(define (find-test-group path)
  (let* ((test-path (string-append path "/fuelweb_test/tests"))
	 (fls (run/strings (find ,test-path -type f -name "*.py")))
	 (s1 (map (lambda (fl) (run/string (grep vcenter ,fl)))  fls))
	 (s2 s1))
    (display s2)))

(define (set-test-group path)
  (when (not (file-exists? path))
    (let ((error-message (string-append path " not found")))
      (d dialog --title "Critical error" --msgbox ,error-message 5 40))
    (quit))
  (display (find-test-group path)))


(define (main args)
  "prepare command line args"
  (let* ((options (getopt-long args option-spec))
	 (help-wanted (option-ref options 'help #f))
	 (version-wanted (option-ref options 'version #f))
	 (os (option-ref options 'os #f))
	 (iso (option-ref options 'iso #f))
	 (test-group (option-ref options 'test-group #f))
	 (node-num (option-ref options 'node-num #f)))
    (help-message help-wanted)
    (version-message version-wanted)
    (check-iso iso)
    (when (not os) (set! os (set-os oses)))
    (when (not test-group) (set! test-group (set-test-group fuel-main)))
    (when node-num
      (display node-num) (newline))
    (when os
      (display os) (newline))))

