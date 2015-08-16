(in-package :srfi-4-internal)

(defun uvector-reader (stream char arg)
  (declare (ignore char arg))
  (apply (case (read stream t nil t)
           (8 #'srfi-4:u8vector)
           (16 #'srfi-4:u16vector)
           (32 #'srfi-4:u32vector)
           (64 #'srfi-4:u64vector))
         (read stream t nil t)))

(defun svector-reader (stream char arg)
  (let ((c (peek-char t stream nil t)))
    (etypecase c
      ((eql #\( )
       (#+sbcl sb-impl::sharp-s
        #+lispworks system::sharp-s
        stream char arg))
      ((satisfies digit-char-p)
         (apply (ecase (read stream t nil t)
                  (8 #'srfi-4:s8vector)
                  (16 #'srfi-4:s16vector)
                  (32 #'srfi-4:s32vector)
                  (64 #'srfi-4:s64vector))
                (read stream t nil t))))))


(defun fvector-reader (stream char arg)
  (declare (ignore char arg))
  (apply (case (read stream t nil t)
           (32 #'srfi-4:f32vector)
           (64 #'srfi-4:f64vector))
         (read stream t nil t)))
