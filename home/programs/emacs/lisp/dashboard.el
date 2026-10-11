;;; dashboard.el -*- lexical-binding: t -*-

(require 'button)

(defface lysec-dashboard-title '((t (:inherit font-lock-function-name-face :weight bold)))
  "Dashboard title.")
(defface lysec-dashboard-stars '((t (:inherit font-lock-type-face))) "Dashboard star map.")
(defface lysec-dashboard-accent '((t (:inherit font-lock-constant-face)))
  "Dashboard action keys.")
(defface lysec-dashboard-button '((t (:inherit default))) "Dashboard actions.")

(defun lysec-new-file ()
  "Choose a path for a new file."
  (interactive)
  (find-file (read-file-name "New file: " default-directory nil nil)))

(defvar lysec-dashboard-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map special-mode-map)
    (dolist (entry '(("n" . lysec-new-file)
                     ("r" . consult-recent-file)
                     ("p" . lysec-project-open)
                     ("o" . lysec-org-open)
                     ("j" . lysec-org-journal)
                     ("a" . org-agenda)
                     ("g" . magit-status)
                     ("TAB" . forward-button)
                     ("<backtab>" . backward-button)))
      (define-key map (kbd (car entry)) (cdr entry)))
    map))

(define-derived-mode lysec-dashboard-mode special-mode "Observatory"
  "A keyboard-driven starting point for projects and notes."
  (setq-local cursor-type nil
              truncate-lines t
              mode-line-format nil))

(defun lysec-dashboard-line (text &optional face)
  "Insert centered TEXT with FACE in the dashboard."
  (let ((padding (max 2 (/ (- (window-body-width) (string-width text)) 2))))
    (insert (make-string padding ?\s)
            (propertize text 'face (or face 'default)) "\n")))

(defun lysec-dashboard-action (key label command)
  "Insert a dashboard action with KEY, LABEL, and COMMAND."
  (let* ((text (format "[%s]  %-21s" key label))
         (padding (max 2 (/ (- (window-body-width) (string-width text)) 2))))
    (insert (make-string padding ?\s))
    (insert (propertize (format "[%s]  " key) 'face 'lysec-dashboard-accent))
    (insert-text-button label 'face 'lysec-dashboard-button 'follow-link t
                        'help-echo (format "Press %s or RET" key)
                        'action (lambda (_) (call-interactively command)))
    (insert "\n")))

(defun lysec-dashboard-render ()
  "Render the observatory at the current window width."
  (let ((inhibit-read-only t))
    (erase-buffer)
    (insert "\n\n")
    (dolist (line '("·                 ✦            ·"
                    "       .         / \\          "
                    "  ✧             /   \\     .   "
                    "          ·    /  ◇  \\        "
                    "              /_______\\       "
                    "    ·           / | \\       ✧ "
                    "          .    /  |  \\        "))
      (lysec-dashboard-line line 'lysec-dashboard-stars))
    (insert "\n")
    (lysec-dashboard-line "O B S E R V A T O R Y" 'lysec-dashboard-title)
    (lysec-dashboard-line "a quiet place to make things" 'font-lock-comment-face)
    (insert "\n")
    (dolist (entry '(("p" "Projects" lysec-project-open)
                     ("n" "New file" lysec-new-file)
                     ("r" "Recent files" consult-recent-file)
                     ("o" "Notes" lysec-org-open)
                     ("j" "Today's journal" lysec-org-journal)
                     ("a" "Agenda" org-agenda)
                     ("g" "Git status" magit-status)))
      (apply #'lysec-dashboard-action entry))
    (insert "\n")
    (lysec-dashboard-line (format-time-string "%A, %d %B") 'font-lock-comment-face)
    (lysec-dashboard-line "SPC: explore commands    TAB / RET: choose" 'font-lock-comment-face)
    (goto-char (point-min))))

(defun lysec-dashboard-buffer ()
  "Return the refreshed dashboard buffer."
  (let ((buffer (get-buffer-create "*Observatory*")))
    (with-current-buffer buffer
      (lysec-dashboard-mode)
      (lysec-dashboard-render))
    buffer))

(defun lysec-dashboard-open ()
  "Open the dashboard in the current window."
  (interactive)
  (switch-to-buffer (lysec-dashboard-buffer))
  (lysec-dashboard-render))

(defun lysec-dashboard-resize (frame)
  "Redraw dashboard windows on FRAME after resizing."
  (dolist (window (window-list frame 'no-minibuffer))
    (with-selected-window window
      (when (derived-mode-p 'lysec-dashboard-mode)
        (lysec-dashboard-render)))))

(setq initial-buffer-choice #'lysec-dashboard-buffer)
(add-hook 'window-size-change-functions #'lysec-dashboard-resize)
