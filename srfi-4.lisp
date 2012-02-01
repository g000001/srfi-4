;;;; srfi-4.lisp

(cl:in-package :srfi-4-internal)

(defmacro coll (&body body)
  (let ((tem (gensym "TEM-"))
        (ans (gensym "ANS-")))
    `(macrolet ((yield (&body body)
                  `(setq ,',tem (cdr (rplacd ,',tem (list (progn ,@body)))))))
       (let* ((,ans (list nil))
              (,tem ,ans))
         ,@body
         (cdr ,ans)))))

(defmacro defun-inline (name (&rest args) &body body)
  `(progn
     (declaim (inline ,name))
     (defun ,name (,@args) ,@body) ))

(defmacro defsrfi-4 ()
  `(progn
     ,@(coll
         (dolist (s '(s u f))
           (dolist (n '(8 16 32 64))
             (let ((pre (format nil "~A~D" s n)))
               (when (or (string/= 'f s)
                         (and (string= 'f s)
                              (or (= 32 n)
                                  (= 64 n) )))
                 (let ((type-spec (case s
                                    ((s) `(signed-byte ,n))
                                    ((u) `(unsigned-byte ,n))
                                    ((f) (if (= 32 n)
                                             'single-float
                                             'double-float )))))
                   ;; TAGvector?
                   (let ((name (intern (format nil "~AVECTOR?" pre)))
                         (type (intern (format nil "~AVEC" pre))) )
                     (yield `(defun-inline ,name (,type)
                               (typep ,type '(simple-array ,type-spec (*))) )))
                   ;; make-TAGvector
                   (let ((name (intern (format nil "MAKE-~AVECTOR" pre))))
                     (yield `(defun-inline ,name (size &optional (fill 0))
                               (make-array size
                                           :initial-element (coerce fill ',type-spec)
                                           :element-type ',type-spec
                                           :adjustable nil))))
                   ;; TAGvector
                   (let ((name (intern (format nil "~AVECTOR" pre)))
                         (elts (intern (format nil "~AS" pre))) )
                     (yield `(defun-inline ,name (&rest ,elts)
                               (make-array (length ,elts)
                                           :initial-contents ,elts
                                           :element-type ',type-spec
                                           :adjustable nil))))
                   ;; TAGvector-length
                   (let ((name (intern (format nil "~AVECTOR-LENGTH" pre)))
                         (vec (intern (format nil "~AVEC" pre))) )
                     (yield `(defun-inline ,name (,vec)
                               (declare (type (simple-array ,type-spec (*)) ,vec))
                               (length ,vec) )))
                   ;; TAGvector-ref
                   (let ((name (intern (format nil "~AVECTOR-REF" pre)))
                         (vec (intern (format nil "~AVEC" pre))) )
                     (yield `(defun-inline ,name (,vec i)
                               (declare (type (simple-array ,type-spec (*)) ,vec)
                                        (unsigned-byte i) )
                               (aref ,vec i) )))
                   ;; TAGvector-set!
                   (let ((name (intern (format nil "~AVECTOR-SET!" pre)))
                         (vec (intern (format nil "~AVEC" pre))) )
                     (yield `(defun-inline ,name (,vec i value)
                               (declare (type (simple-array ,type-spec (*)) ,vec)
                                        (type ,type-spec value)
                                        (unsigned-byte i) )
                               (setf (aref ,vec i) value) )))
                   ;; TAGvector->list
                   (let ((name (intern (format nil "~AVECTOR->LIST" pre)))
                         (vec (intern (format nil "~AVEC" pre))) )
                     (yield `(defun-inline ,name (,vec)
                               (declare (type (simple-array ,type-spec (*)) ,vec))
                               (coerce ,vec 'list) )))
                   ;; list->TAGvector
                   (let ((name (intern (format nil "LIST->~AVECTOR" pre))))
                     (yield `(defun-inline ,name (list)
                               (declare (list list))
                               (coerce list '(simple-array ,type-spec (*))) )))))))))))

(defsrfi-4)

;;; eof
