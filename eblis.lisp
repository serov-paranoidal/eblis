(defpackage #:eblis
(:use #:cl)
(export :bf-eval))
(in-package #:eblis)

(defvar *memory* nil "Brainfuck memory-tape, gets redefined during BF-EVAL.")
(defvar *loop-stack* nil "Stack of FILE-POSITIONs of '[' characters to return to them in course of BF-BREAK, gets redefined during BF-EVAL.")
(defvar *pointer* nil "Memory-tape pointer, implemented through the array index, is governed by BF-RIGHT and BF-LEFT.")
(defvar *cell-size* nil "Size (in bits) of one brainfuck cell. Important for the overflow cases in BF-INC and BF-DEC")
(defvar *return-string* nil "The string that will be returned in case the RETURN-RESULT argument to BF-EVAL will be non-NIL")
(defvar *return-result* nil "The variable responsible for returning the result of BF-EVAL like typical functions do (in case it is T) or just side-effectively doing evaluation (if it's NIL)")

(defun bf-eval (bf-source &key (memory nil) (pointer nil) (loop-stack nil) (pb-functions nil) (return-string nil) (memory-size 30000) (cell-size 8) (return-result nil))
  (let ((*memory* (if-exists-return memory
                      :else (make-array memory-size :element-type `(unsigned-byte ,cell-size) :initial-element 0 :adjustable nil)))
        (*pointer* (if-exists-return pointer
                       :else 0))
        (*loop-stack* (if-exists-return loop-stack
                          :else (make-array 0 :element-type 'bignum :adjustable t)))
        (*pb-functions* (if-exists-return pb-functions
                            :else (make-hash-table :test #'eql)))
        (*return-string* (if-exists-return return-string
                             :else ""))
        (*cell-size* cell-size)
        (*return-result* return-result))
    (with-input-from-string (code bf-source)
      (do ((ch (read-char code nil nil) (read-char code nil nil)))
          ((null ch) (return))
        (cond
          ((char= ch #\+) (bf-inc))
          ((char= ch #\-) (bf-dec))
          ((char= ch #\,) (bf-read))
          ((char= ch #\.) (bf-print *return-result*))
          ((char= ch #\>) (bf-right))
          ((char= ch #\<) (bf-left))
          ((char= ch #\[) (bf-loop code))
          ((char= ch #\]) (bf-break code)))))
    (if *return-result* (values) *return-string*)))

(defmacro cell ()
  "Macro to wrap the reference to the memory-cell of brainfuck tape. Looks kinda ugly but I haven't figured better solution out yet."
  '(aref *memory* *pointer*))

(defmacro if-exists-return (existent-thing &optional (else-keyword nil) (not-exists-case nil))
  "Anaphoric macro-wrapper for cases when you need to return the non-NIL thing that was the condition of IF, like:
  (if it-exists it-exists else-do-some-esoteric-nonexistential-stuff)
  Frequently used in BF-EVAL for easy redefinition of shared global variables in case they are (not) given to BF-EVAL.
  Also, the :ELSE keyword is obligatory for the usage of this macro, because for me it seems to greatly increase readability."
  (declare (ignore else-keyword))
  `(if ,existent-thing ,existent-thing ,not-exists-case))

(defun bf-inc ()
  (if (/= (cell) (1- (expt 2 *cell-size*)))
      (incf (cell))
      (setf (cell) 0)))

(defun bf-dec ()
  (if (/= (cell) 0)
      (decf (cell))
      (setf (cell) (1- (expt 2 *cell-size*)))))

(defun bf-right ()
  (incf *pointer*))

(defun bf-left ()
  (decf *pointer*))

(defun bf-read ()
  (setf (cell) (char-code (read-char))))

(defun bf-print (return-result)
  (if return-result
      (concatenate 'string *return-string* (list (code-char (cell))))
      (format (not return-result) "~A" (code-char (cell)))))

(defun bf-loop (stream)
  (if (not (zerop (cell)))
      (vector-push-extend (file-position stream) *loop-stack* 1)))

(defun bf-break (stream)
  (if (zerop (cell))
      (vector-pop *loop-stack*)
      (file-position stream (svref *loop-stack* 0))))
