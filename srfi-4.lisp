;;;; srfi-4.lisp

(cl:in-package :srfi-4-internal)

(dolist (s '(s u f))
  (dolist (n '(8 16 32 64))
    (let ((pre (format nil "~A~D" s n)))
      (when (or (string/= 'f s)
                (and (string= 'f s)
                     (or (= 32 n)
                         (= 64 n))))
        (let ((type-spec (case s
                           ((s) `(signed-byte ,n))
                           ((u) `(unsigned-byte ,n))
                           ((f) (if (= 32 n)
                                    'single-float
                                    'double-float)))))
          ;; TAGvector?
          (let ((name (intern (format nil "~AVECTOR?" pre)))
                (type (intern (format nil "~AVEC" pre))))
            (eval `(defun ,name (,type)
                     (typep ,type '(vector ,type-spec)))))
          ;; make-TAGvector
          (let ((name (intern (format nil "MAKE-~AVECTOR" pre))))
            (eval `(defun ,name (size)
                     (make-array size
                                 :initial-element (coerce 0 ',type-spec)
                                 :element-type ',type-spec
                                 :adjustable nil))))
          ;; TAGvector
          (let ((name (intern (format nil "~AVECTOR" pre)))
                (elts (intern (format nil "~AS" pre))))
            (eval `(defun ,name (&rest ,elts)
                     (make-array (length ,elts)
                                 :initial-contents ,elts
                                 :element-type ',type-spec
                                 :adjustable nil))))
          ;; TAGvector-length
          (let ((name (intern (format nil "~AVECTOR-LENGTH" pre)))
                (vec (intern (format nil "~AVEC" pre))))
            (eval `(defun ,name (,vec)
                     (declare ((vector ,type-spec) ,vec))
                     (length ,vec))))
          ;; TAGvector-ref
          (let ((name (intern (format nil "~AVECTOR-REF" pre)))
                (vec (intern (format nil "~AVEC" pre))))
            (eval `(defun ,name (,vec i)
                     (declare ((vector ,type-spec) ,vec)
                              (unsigned-byte i))
                     (aref ,vec i))))
          ;; TAGvector-set!
          (let ((name (intern (format nil "~AVECTOR-SET!" pre)))
                (vec (intern (format nil "~AVEC" pre))))
            (eval `(defun ,name (,vec i value)
                     (declare ((vector ,type-spec) ,vec)
                              (,type-spec value)
                              (unsigned-byte i))
                     (setf (aref ,vec i) value))))
          ;; TAGvector->list
          (let ((name (intern (format nil "~AVECTOR->LIST" pre)))
                (vec (intern (format nil "~AVEC" pre))))
            (eval `(defun ,name (,vec)
                     (declare ((vector ,type-spec) ,vec))
                     (coerce ,vec 'list))))
          ;; list->TAGvector
          (let ((name (intern (format nil "LIST->~AVECTOR" pre))))
            (eval `(defun ,name (list)
                     (declare (list list))
                     (coerce list '(vector ,type-spec))))))))))
