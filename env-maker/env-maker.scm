#!/usr/bin/guile \
-e main -s
!#

(use-modules (ice-9 getopt-long))
(use-modules (scsh syntax))

(define option-spec '((version (single-char #\v) (value #f))
			   (help (single-char #\h) (value #f))
			   (os (single-char #\o) (value #t))
			   (iso (single-char #\i) (value #t))
			   (test-group (single-char #\t) (value #t))
			   (node-num (single-char #\n) (value #t))))

(define (help-message)
  (display "\
Usage: env-maker.scm [options]
   -v, --version\tDisplay version
   -h, --help\t\tDisplay this help
   -o, --os\t\tChoose Ubuntu or CentOS
   -i, --iso\t\tPath to fuel master iso
   -t, --test-group\tName of testgroup which will be launched
   -n, --node-num\tNumber of node for creation
"))

(define (version-message) (display "0.1\n"))

(define (set-os)
  "choose Ubuntu or CentOS"
  (let ((os  (run/string  (ls /lala) (= 2 1))))
    os))

(define (main args)
  "prepare command line args"
  (let* ((options (getopt-long args option-spec))
	 (help-wanted (option-ref options 'help #f))
	 (version-wanted (option-ref options 'version #f))
	 (os (option-ref options 'os #f))
	 (iso (option-ref options 'iso #f))
	 (test-group (option-ref options 'test-group #f))
	 (node-num (option-ref options 'node-num #f)))
    (when help-wanted (help-message))
    (when version-wanted (version-message))
    (when (not os) (set! os (set-os)))
    (display os) (newline)
    (when test-group
      (display test-group) (newline))
    (when node-num
      (display node-num) (newline))
    (when os
      (display os) (newline))))

