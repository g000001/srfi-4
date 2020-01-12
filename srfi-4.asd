;;;; srfi-4.asd

(cl:in-package :asdf)

(defsystem :srfi-4
  :version "1"
  :description "SRFI 4 for CL: Homogeneous numeric vector datatypes"
  :long-description "SRFI 4 for CL: Homogeneous numeric vector datatypes
https://srfi.schemers.org/srfi-4"
  :author "CHIBA Masaomi"
  :maintainer "CHIBA Masaomi"
  :license "Unlicense"
  :serial t
  :depends-on ()
  :components ((:file "package")
               (:file "srfi-4")
               (:file "printer")
               (:file "reader")
               (:file "util")))

(defmethod perform :after ((o load-op) (c (eql (find-system :srfi-4))))
  (let ((name "https://github.com/g000001/srfi-4")
        (nickname :srfi-4))
    (if (and (find-package nickname)
             (not (eq (find-package nickname)
                      (find-package name))))
        (warn "~A: A package with name ~A already exists." name nickname)
        (rename-package name name `(,nickname)))))

(defsystem :srfi-4.test
  :version "1"
  :description "SRFI 4 for CL: Homogeneous numeric vector datatypes"
  :long-description "SRFI 4 for CL: Homogeneous numeric vector datatypes
https://srfi.schemers.org/srfi-4"
  :author "CHIBA Masaomi"
  :maintainer "CHIBA Masaomi"
  :license "Unlicense"
  :serial t
  :depends-on (:srfi-4 :fiveam)
  :components ((:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-4.test))))
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
        (let ((result (funcall (_ :fiveam :run) (_ "https://github.com/g000001/srfi-4#internals" :srfi-4))))
          (funcall (_ :fiveam :explain!) result)
          (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
