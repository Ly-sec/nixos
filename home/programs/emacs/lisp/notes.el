;;; notes.el -*- lexical-binding: t -*-

(defvar lysec-org-directory "/mnt/storage/org/"
  "Root directory for notes, journal entries, and tasks.")

(defun lysec-org-confirm-babel-evaluate (_language _body)
  "Ask before executing source blocks outside the local notes directory."
  (not (and buffer-file-name
            (not (file-remote-p buffer-file-name))
            (file-in-directory-p (file-truename buffer-file-name)
                                 (file-truename lysec-org-directory)))))

(use-package org
  :demand t
  :custom
  (org-directory lysec-org-directory)
  (org-default-notes-file (expand-file-name "inbox.org" org-directory))
  (org-agenda-files (list (expand-file-name "inbox.org" org-directory)
                          (expand-file-name "tasks.org" org-directory)
                          (expand-file-name "journal" org-directory)))
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-ellipsis " ▾")
  (org-startup-indented t)
  (org-startup-folded 'content)
  (org-startup-with-inline-images t)
  (org-image-actual-width '(300))
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@)" "|" "DONE(d!)" "CANCELLED(c@)")))
  (org-confirm-babel-evaluate #'lysec-org-confirm-babel-evaluate)
  :config
  (setq org-id-locations-file (lysec-state-file "org-id-locations")
        org-persist-directory (lysec-state-file "org-persist/")
        org-clock-persist-file (lysec-state-file "org-clock-save.el")
        org-capture-templates
        `(("t" "Task" entry (file+headline ,org-default-notes-file "Tasks")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n")
          ("n" "Quick note" entry (file+headline ,org-default-notes-file "Notes")
           "* %?\n%U\n")
          ("j" "Journal" entry
           (file+olp+datetree ,(expand-file-name "journal/log.org" org-directory))
           "* %U %?\n")))
  (require 'ox-md)
  (org-babel-do-load-languages 'org-babel-load-languages
                              '((emacs-lisp . t) (shell . t))))
(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :custom
  (org-modern-table nil)
  (org-modern-star '("◉" "○" "◆" "◇" "▸"))
  :config (add-hook 'org-agenda-finalize-hook #'org-modern-agenda))
(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :custom (org-appear-autolinks t))
(use-package org-roam
  :commands (org-roam-node-find org-roam-node-insert org-roam-buffer-toggle)
  :init
  (setq org-roam-directory (file-truename lysec-org-directory)
        org-roam-db-location (lysec-state-file "org-roam.db")
        org-roam-capture-templates
        '(("d" "Note" plain "%?"
           :target (file+head "notes/${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)))
  :config (org-roam-db-autosync-mode 1))
(use-package org-roam-dailies
  :after org-roam
  :commands (org-roam-dailies-capture-today org-roam-dailies-goto-today)
  :custom
  (org-roam-dailies-directory "journal/")
  (org-roam-dailies-capture-templates
   '(("d" "Daily journal" entry "* %<%H:%M> %?"
      :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")))))

(defun lysec-org-open ()
  "Browse the notes directory."
  (interactive)
  (dirvish lysec-org-directory))
(defun lysec-org-journal ()
  "Open today's linked journal entry."
  (interactive)
  (require 'org-roam)
  (require 'org-roam-dailies)
  (org-roam-dailies-goto-today))

(defun lysec-open-keybindings ()
  "Open the key reference in a new pane to the right."
  (interactive)
  (let ((file lysec-keybindings-file))
    (unless (file-readable-p file)
      (user-error "Key reference is missing: %s" file))
    (select-window (split-window-right))
    (find-file file)
    (when (bound-and-true-p diff-hl-mode) (diff-hl-mode -1))
    (when (bound-and-true-p blamer-mode) (blamer-mode -1))
    (setq-local display-line-numbers nil
                org-fold-show-context-detail '((link-search . local)
                                               (default . ancestors)))
    (visual-line-mode 1)
    (dolist (face '(org-code org-verbatim))
      (face-remap-set-base
       face :inherit 'font-lock-constant-face
       :background (face-background 'corfu-default nil t)))
    (face-remap-set-base 'org-table 'default)
    (face-remap-set-base 'org-document-title 'org-level-1 :height 1.0)
    (goto-char (point-min))))
