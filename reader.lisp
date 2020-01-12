(in-package "https://github.com/g000001/srfi-4#internals")

(defun uvector-reader (stream char arg)
  (declare (ignore char arg))
  (apply (case (read stream t nil t)
           (8 #'u8vector)
           (16 #'u16vector)
           (32 #'u32vector)
           (64 #'u64vector))
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
                  (8 #'s8vector)
                  (16 #'s16vector)
                  (32 #'s32vector)
                  (64 #'s64vector))
                (read stream t nil t))))))


(defun fvector-reader (stream char arg)
  (declare (ignore char arg))
  (apply (case (read stream t nil t)
           (32 #'f32vector)
           (64 #'f64vector))
         (read stream t nil t)))
