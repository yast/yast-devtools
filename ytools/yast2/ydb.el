;;; ydb.el --- GUD-based YaST2 debugger

;; Author: Martin Vidner <mvidner@suse.cz>
;; $Id$

(require 'gud)

(defun gud-ydb-massage-args (file args) args)

(defun gud-ydb-find-file (f)
  (find-file-noselect f 'nowarn))

(defvar gud-ydb-marker-regexp
  ; position: /home/mvidner/snippets/quoting.ycp 0
  "^position: \\([^ ]*\\) \\([0-9]*\\).*\n")

; this is just copied gud-gdb-marker-filter
(defun gud-ydb-marker-filter (string)
  (setq gud-marker-acc (concat gud-marker-acc string))
  (let ((output ""))

    ;; Process all the complete markers in this chunk.
    (while (string-match gud-ydb-marker-regexp gud-marker-acc)
      (setq

       ;; Extract the frame position from the marker.
       gud-last-frame
       (cons (substring gud-marker-acc (match-beginning 1) (match-end 1))
	     (string-to-int (substring gud-marker-acc
				       (match-beginning 2)
				       (match-end 2))))

       ;; Append any text before the marker to the output we're going
       ;; to return - we don't include the marker in this text.
       output (concat output
		      (substring gud-marker-acc 0 (match-beginning 0)))

       ;; Set the accumulator to the remaining text.
       gud-marker-acc (substring gud-marker-acc (match-end 0))))

    ;; Does the remaining text look like it might end with the
    ;; beginning of another marker?  If it does, then keep it in
    ;; gud-marker-acc until we receive the rest of it.  Since we
    ;; know the full marker regexp above failed, it's pretty simple to
    ;; test for marker starts.
    (if (string-match "^p.*\\'" gud-marker-acc)
	(progn
	  ;; Everything before the potential marker start can be output.
	  (setq output (concat output (substring gud-marker-acc
						 0 (match-beginning 0))))

	  ;; Everything after, we save, to combine with later input.
	  (setq gud-marker-acc
		(substring gud-marker-acc (match-beginning 0))))

      (setq output (concat output gud-marker-acc)
	    gud-marker-acc ""))

    output))

;;;###autoload
(defun ydb (command-line)
  "Run ydb on program FILE in buffer *gud-FILE*.
The directory containing FILE becomes the initial working directory
and source-file directory for your debugger."
  (interactive (list (gud-query-cmdline 'ydb)))

  (gud-common-init command-line 'gud-ydb-massage-args
		   'gud-ydb-marker-filter 'gud-ydb-find-file)
  (set (make-local-variable 'gud-minor-mode) 'ydb)

  (gud-def gud-break  "break %d%f %l"  "\C-b" "Set breakpoint at current line.")
;  (gud-def gud-tbreak "tbreak %f:%l" "\C-t" "Set temporary breakpoint at current line.")
  (gud-def gud-remove "clear %d%f %l"  "\C-d" "Remove breakpoint at current line")
  (gud-def gud-step   "step"      "\C-s" "Step one source line with display.")
  (gud-def gud-stepi  "single"     "\C-i" "Step one instruction with display.")
  (gud-def gud-next   "next"      "\C-n" "Step one line (skip functions).")
  (gud-def gud-cont   "continue"         "\C-r" "Continue with display.")
  (gud-def gud-finish "up"       "\C-f" "Finish executing current function.")
;  (gud-def gud-up     "up %p"        "<" "Up N stack frames (numeric arg).")
;  (gud-def gud-down   "down %p"      ">" "Down N stack frames (numeric arg).")
  (gud-def gud-print  "print %e"     "\C-p" "Evaluate C expression at point.")

;  (local-set-key "\C-i" 'gud-gdb-complete-command)
;  (local-set-key [menu-bar debug tbreak] '("Temporary Breakpoint" . gud-tbreak))
  (local-set-key [menu-bar debug finish] '("Finish Function" . gud-finish))
;  (local-set-key [menu-bar debug up] '("Up Stack" . gud-up))
;  (local-set-key [menu-bar debug down] '("Down Stack" . gud-down))

  ; argh, the debugger has no prompt??
  (setq comint-prompt-regexp "\n")
  (setq paragraph-start comint-prompt-regexp)

  (run-hooks 'ydb-mode-hook)
)
