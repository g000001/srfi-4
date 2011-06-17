(cl:in-package :srfi-4-internal)

(def-suite srfi-4)

(in-suite srfi-4)

(test printer
  (enable-homogeneous-numeric-vector)
  (flet ((ws= (string exp) ;write-to-string=
           (string= string (write-to-string exp))))
    ;; signed
    (is-true (ws= "#S8(0 0 0 0 0 0 0 0)"
                  (make-s8vector 8)))
    (is-true (ws= "#S16(0 0 0 0 0 0 0 0)"
                  (make-s16vector 8)))
    (is-true (ws= "#S32(0 0 0 0 0 0 0 0)"
                  (make-s32vector 8)))
    (is-true (ws= "#S64(0 0 0 0 0 0 0 0)"
                  (make-s64vector 8)))
    ;; unsigned
    (is-true (ws= "#U8(0 0 0 0 0 0 0 0)"
                  (make-u8vector 8)))
    (is-true (ws= "#U16(0 0 0 0 0 0 0 0)"
                  (make-u16vector 8)))
    (is-true (ws= "#U32(0 0 0 0 0 0 0 0)"
                  (make-u32vector 8)))
    (is-true (ws= "#U64(0 0 0 0 0 0 0 0)"
                  (make-u64vector 8)))
    ;; float
    (is-true (ws= "#F32(0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0)"
                  (make-f32vector 8)))
    (is-true (ws= "#F64(0.0d0 0.0d0 0.0d0 0.0d0 0.0d0 0.0d0 0.0d0 0.0d0)"
                  (make-f64vector 8)))
    (disable-homogeneous-numeric-vector)))

(test reader
  (let ((*readtable* (copy-readtable nil)))
    (set-dispatch-macro-character #\# #\u #'uvector-reader)
    (set-dispatch-macro-character #\# #\s #'svector-reader)
    (set-dispatch-macro-character #\# #\f #'fvector-reader)
    (is-true (eval
              (read-from-string
               "
    (in-package :srfi-4-internal)
    #0=(gensym)
    (defstruct #0# x y z)

    (let ((x '(#u8(0)
           #u16(0)
           #u32(0)
           #u64(0)
           #S(#0# :X 1 :Y 2 :Z 3)
           #s8(0)
           #s16(0)
           #s32(0)
           #s64(0)
           #f32(0.0)
           #f64(0.0d0))))
  (equalp x
          (list (u8vector 0)
                (u16vector 0)
                (u32vector 0)
                (u64vector 0)
                (make-foo :x 1 :y 2 :z 3)
                (s8vector 0)
                (s16vector 0)
                (s32vector 0)
                (s64vector 0)
                (f32vector 0.0)
                (f64vector 0.0d0) )))")))))

(test side-effects
  (is-false *original-readtable*)
  (is-false *restore-homogeneous-numeric-vector*)
  ;;
  (enable-homogeneous-numeric-vector)
  (disable-homogeneous-numeric-vector)
  (is-false *original-readtable*)
  (is-false *restore-homogeneous-numeric-vector*))