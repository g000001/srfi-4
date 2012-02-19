(in-package :srfi-4-internal)

(defvar *original-readtable* nil)
(defvar *restore-homogeneous-numeric-vector* nil)
(defvar *original-pprint-vector* nil)

(eval-when (:compile-toplevel :load-toplevel :execute)
  ;;
  (defun %enable-homogeneous-numeric-vector ()
    (unless *original-readtable*
      (setf *original-readtable* *readtable*
            *readtable* (copy-readtable))
      (set-dispatch-macro-character #\# #\u #'uvector-reader)
      (set-dispatch-macro-character #\# #\s #'svector-reader)
      (set-dispatch-macro-character #\# #\f #'fvector-reader))
    (unless *original-pprint-vector*
      (setf *original-pprint-vector*
            #+sbcl #'sb-pretty::pprint-vector
            #+lispworks #'system::sharp-left-paren
            #+ecl #'si::pprint-vector
            #+ccl #'ccl::pprint)
      #+sbcl
      (sb-ext:without-package-locks
        (setf (symbol-function 'sb-pretty::pprint-vector)
              #'sb-pretty::pprint-homogeneous-numeric-vector)))
    (values))
  ;;
  (defun %disable-homogeneous-numeric-vector ()
    (when *original-readtable*
      (setf *readtable* *original-readtable*
            *original-readtable* nil))
    (when *original-pprint-vector*
      #+sbcl
      (sb-ext:without-package-locks
        (setf (symbol-function 'sb-pretty::pprint-vector)
              *original-pprint-vector*

              *original-pprint-vector*
              nil)))
    (values)) )

(defmacro enable-homogeneous-numeric-vector ()
  '(eval-when (:compile-toplevel :load-toplevel :execute)
    (setf *restore-homogeneous-numeric-vector* 'T)
    (%enable-homogeneous-numeric-vector)))

(defmacro disable-homogeneous-numeric-vector ()
  '(eval-when (:compile-toplevel :load-toplevel :execute)
    (setf *restore-homogeneous-numeric-vector* nil)
    (%disable-homogeneous-numeric-vector)))
