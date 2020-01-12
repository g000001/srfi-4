(cl:in-package "https://github.com/g000001/srfi-4#internals")

#+sbcl
(defun pprint-homogeneous-numeric-vector (stream vector)
  (let ((prefix (typecase vector
                  ((vector (signed-byte 8)) "#S8(")
                  ((vector (unsigned-byte 8)) "#U8(")
                  ((vector (signed-byte 16)) "#S16(")
                  ((vector (unsigned-byte 16)) "#U16(")
                  ((vector (signed-byte 32)) "#S32(")
                  ((vector (unsigned-byte 32)) "#U32(")
                  ((vector (signed-byte 64)) "#S64(")
                  ((vector (unsigned-byte 64)) "#U64(")
                  ((vector short-float) "#F32(")
                  ((vector long-float) "#F64(")
                  (otherwise "#("))))
    (pprint-logical-block (stream nil :prefix prefix :suffix ")")
      (dotimes (i (length vector))
        (unless (zerop i)
          (format stream " ~:_"))
        (pprint-pop)
        (sb-kernel:output-object (aref vector i) stream)))))

#-sbcl
(#-lispworks progn
 #+lispworks let
 #+lispworks ((hcl:*packages-for-warn-on-redefinition* '()))
  (defun pprint-homogeneous-numeric-vector (stream vector)
    (let ((prefix (typecase vector
                    ((vector (signed-byte 8)) "#S8(")
                    ((vector (unsigned-byte 8)) "#U8(")
                    ((vector (signed-byte 16)) "#S16(")
                    ((vector (unsigned-byte 16)) "#U16(")
                    ((vector (signed-byte 32)) "#S32(")
                    ((vector (unsigned-byte 32)) "#U32(")
                    ((vector (signed-byte 64)) "#S64(")
                    ((vector (unsigned-byte 64)) "#U64(")
                    ((vector short-float) "#F32(")
                    ((vector long-float) "#F64(")
                    (otherwise "#("))))
      (pprint-logical-block (stream nil :prefix prefix :suffix ")")
        (dotimes (i (length vector))
          (unless (zerop i)
            (format stream " ~:_"))
          (pprint-pop)
          (princ (aref vector i) stream))))))

#+lispworks
(let ((hcl:*packages-for-warn-on-redefinition* '()))
  (defmethod print-object ((vec vector) stream)
    (pprint-homogeneous-numeric-vector stream vec)))


