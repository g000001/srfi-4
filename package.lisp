;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :srfi-4
    (:export :enable-homogeneous-numeric-vector
             :disable-homogeneous-numeric-vector)
    (:export . #.(let (ans)
                   (dolist (s '("s" "u" "f"))
                     (dolist (n '(8 16 32 64))
                       (let ((pre (format nil "~A~D" s n)))
                         (dolist (fmt '("~Avector?"
                                        "make-~Avector"
                                        "~Avector"
                                        "~Avector-length"
                                        "~Avector-ref"
                                        "~Avector-set!"
                                        "~Avector->list"
                                        "list->~Avector"))
                           (when (or (string/= 'f s)
                                     (and (string= 'f s)
                                          (or (= 32 n)
                                              (= 64 n))))
                             (push (make-symbol (format nil "~:@(~@?~)" fmt pre))
                                   ans))))))
                   ans)))

(defpackage :srfi-4-internal
  (:use :srfi-4 :cl :fiveam))





