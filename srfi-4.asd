;;;; srfi-4.asd

(cl:in-package :asdf)

(defsystem :srfi-4
  :serial t
  :components ((:file "package")
               (:file "srfi-4")
               (:file "printer")
               (:file "reader")
               (:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-4))))
  (load-system :srfi-4)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :srfi-4-internal :srfi-4))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

