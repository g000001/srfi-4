(in-package "https://github.com/g000001/srfi-4#internals")

(defmacro in-syntax (readtable)
  `(eval-when (:execute :compile-toplevel :load-toplevel)
     (setq *readtable* ,readtable)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defvar *srfi-4-readtable* (copy-readtable nil))
  (let ((*readtable* *srfi-4-readtable*))
    (set-dispatch-macro-character #\# #\u #'uvector-reader)
    (set-dispatch-macro-character #\# #\s #'svector-reader)
    (set-dispatch-macro-character #\# #\f #'fvector-reader)))

(defvar *restore-homogeneous-numeric-vector* nil)
(defvar *original-pprint-vector* nil)

(eval-when (:compile-toplevel :load-toplevel :execute)
  ;;
  (defun %enable-homogeneous-numeric-vector ()
    (setq *readtable* *srfi-4-readtable*)
    (unless *original-pprint-vector*
      (setf *original-pprint-vector*
            (load-time-value
             #+sbcl #'sb-pretty::pprint-array
             #+lispworks #'lw-xp::pretty-vector
             #+ecl #'si::pprint-vector
             #+ccl #'ccl::pprint
             #+abcl #'cl:pprint))
      #+sbcl
      (sb-ext:without-package-locks
        (setf (fdefinition 'sb-pretty::pprint-array)
              #'pprint-homogeneous-numeric-vector))
      #+lispworks
      (let ((hcl:*packages-for-warn-on-redefinition* '()))
        (setf (fdefinition 'lw-xp::pretty-vector)
              #'pprint-homogeneous-numeric-vector)))
    (values))
  ;;
  (defun %disable-homogeneous-numeric-vector ()
    (setq *readtable* (copy-readtable nil))
    (when *original-pprint-vector*
      #+sbcl
      (sb-ext:without-package-locks
        (setf (fdefinition 'sb-pretty::pprint-array)
              *original-pprint-vector*

              *original-pprint-vector*
              nil))
      #+lispworks
      (let ((hcl:*packages-for-warn-on-redefinition* '()))
        (setf (fdefinition 'lw-xp::pretty-vector)
              *original-pprint-vector*
              
              *original-pprint-vector*
              nil)))
    (values)) )

(defmacro enable-homogeneous-numeric-vector ()
  (eval-when (:compile-toplevel :load-toplevel :execute)
    (setf *restore-homogeneous-numeric-vector* 'T)
    (%enable-homogeneous-numeric-vector)))

(defmacro disable-homogeneous-numeric-vector ()
  (eval-when (:compile-toplevel :load-toplevel :execute)
    (setf *restore-homogeneous-numeric-vector* nil)
    (%disable-homogeneous-numeric-vector)))
