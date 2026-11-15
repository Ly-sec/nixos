;;; files.el -*- lexical-binding: t -*-

(use-package dirvish
  :demand t
  :custom
  (dirvish-attributes '(nerd-icons file-size collapse subtree-state vc-state))
  (dirvish-cache-dir (lysec-state-file "dirvish/"))
  :config
  (dirvish-override-dired-mode)
  (define-key dired-mode-map (kbd "q") #'dirvish-quit)
  (setq dired-kill-when-opening-new-dired-buffer t))
(use-package treemacs
  :commands (treemacs treemacs-select-window)
  :custom
  (treemacs-width 28)
  (treemacs-persist-file (lysec-state-file "treemacs-persist"))
  (treemacs-last-error-persist-file (lysec-state-file "treemacs-errors"))
  (treemacs-is-never-other-window t)
  :config
  (treemacs-follow-mode 1)
  (treemacs-filewatch-mode 1))
(use-package treemacs-nerd-icons
  :after treemacs
  :config (treemacs-load-theme "nerd-icons"))
(use-package magit :commands (magit-status magit-dispatch))

(defun lysec-enable-line-blame ()
  "Initialize inline Git history in local, tracked text files.
Preserve any existing buffer-local choice of `blamer-mode'."
  (when (and (not (local-variable-p 'blamer-mode))
             buffer-file-name
             (not (file-remote-p buffer-file-name))
             (derived-mode-p 'prog-mode 'text-mode)
             (eq (vc-backend buffer-file-name) 'Git))
    (blamer-mode 1)))

(defun lysec-dirvish-enable-line-blame (_find-fn file)
  "Initialize annotations when Dirvish opens FILE from a preview buffer."
  (when-let* ((buffer (and (not (file-remote-p file)) (get-file-buffer file))))
    (with-current-buffer buffer (lysec-enable-line-blame))))

(use-package blamer
  :commands (blamer-mode blamer-show-commit-info)
  :hook (find-file . lysec-enable-line-blame)
  :init
  (advice-add 'dirvish--find-entry :after #'lysec-dirvish-enable-line-blame)
  :custom
  (blamer-idle-time 0.6)
  (blamer-type 'visual)
  (blamer-min-offset 0)
  (blamer-self-author-name nil)
  (blamer-author-formatter "%s · ")
  (blamer-datetime-formatter "%s · ")
  (blamer-commit-formatter "%s")
  (blamer-entire-formatter "  %s")
  (blamer-show-avatar-p nil)
  :config
  (set-face-attribute 'blamer-face nil
                      :inherit 'mode-line-inactive
                      :foreground 'unspecified :background 'unspecified
                      :slant 'italic :height 1.0))

(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (require 'diff-hl-margin)
  (diff-hl-margin-mode 1))

(defun lysec-file-manager ()
  "Browse the current file's directory or the buffer's working directory."
  (interactive)
  (dirvish (if buffer-file-name
               (file-name-directory buffer-file-name)
             default-directory)))

(defun lysec-new-buffer ()
  "Create an unnamed text buffer in the current directory."
  (interactive)
  (let ((directory default-directory))
    (switch-to-buffer (generate-new-buffer "untitled"))
    (text-mode)
    (setq-local default-directory directory)))

(defun lysec-project-open ()
  "Choose a project and open its file tree beside the editor."
  (interactive)
  (let ((default-directory (project-prompt-project-dir)))
    (project-find-file)
    (save-selected-window (treemacs-select-window))))
