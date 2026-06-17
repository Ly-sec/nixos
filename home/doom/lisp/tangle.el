(defvar my/dotfiles-org-path nil
  "When non-nil, use this as the lysec org repo root instead of auto-detection.")

(defun my/dotfiles-org-root ()
  "Return the lysec org checkout directory (with trailing slash)."
  (file-name-as-directory
   (expand-file-name
    (or (and my/dotfiles-org-path (expand-file-name my/dotfiles-org-path))
        (let ((start (or (buffer-file-name) default-directory)))
          (when start
            (locate-dominating-file start "dashboard.org")))
        "/mnt/storage/org/lysec/"))))

(defun my/org--lysec-bootstrap-root ()
  "Resolve lysec org checkout; may prompt when interactive and nothing matches."
  (file-name-as-directory
   (expand-file-name
    (or (and my/dotfiles-org-path (expand-file-name my/dotfiles-org-path))
        (let ((start (or (buffer-file-name) default-directory)))
          (when start
            (locate-dominating-file start "dashboard.org")))
        (and (called-interactively-p 'any)
             (read-directory-name
              "Lysec org repo (folder containing dashboard.org): "
              (expand-file-name "~") nil t))
        (user-error "Set `default-directory' to your lysec checkout, `my/dotfiles-org-path', or run interactively")))))

(defun my/org-tangle-dotfiles-run-init-script (&optional root)
  "Run bin/tangle-init in the lysec checkout (same as shell ./bin/tangle-init).
Optional ROOT is the repo directory (with trailing slash); otherwise it is detected."
  (interactive)
  (let* ((root (file-name-as-directory (or root (my/org--lysec-bootstrap-root))))
         (script (expand-file-name "bin/tangle-init" root)))
    (unless (file-exists-p script)
      (user-error "Missing %s" script))
    (unless (file-executable-p script)
      (user-error "Not executable: %s — chmod +x bin/tangle-init" script))
    (let ((buf (get-buffer-create "*tangle-init*")))
      (with-current-buffer buf
        (read-only-mode -1)
        (erase-buffer)
        (insert (format "Running: %s\n\n" script)))
      (let ((exit (call-process script nil buf nil)))
        (with-current-buffer buf (read-only-mode 1))
        (display-buffer buf)
        (if (zerop exit)
            (message "tangle-init finished — see *tangle-init*")
          (user-error "tangle-init failed with exit code %s" exit))))))

(defun my/org-tangle-dotfiles-bootstrap ()
  "Bootstrap tangling: runs bin/tangle-init when possible, else Org in Emacs.
From *scratch*, set `default-directory' to your lysec checkout (e.g. \\[cd] in Eshell) or run
interactively to be prompted for the repo root."
  (interactive)
  (let* ((root (my/org--lysec-bootstrap-root))
         (script (expand-file-name "bin/tangle-init" root)))
    (if (and (file-exists-p script) (file-executable-p script))
        (my/org-tangle-dotfiles-run-init-script root)
      (let ((org-confirm-babel-evaluate nil)
            (tangle-org (expand-file-name "doom/tangle.org" root)))
        (require 'org)
        (unless (file-readable-p tangle-org)
          (user-error "Missing %s" tangle-org))
        (org-babel-tangle-file tangle-org)
        (load-file (expand-file-name "~/.config/doom/lisp/tangle.el"))
        (my/org-tangle-dotfiles-recursive)
        (message "Bootstrap tangle finished — see *Dotfiles Tangle Log*")))))

(defun my/org-tangle-dotfiles-recursive ()
  "Recursively tangle all Org files under the lysec org repo."
  (interactive)
  (let* ((root (file-name-as-directory (my/dotfiles-org-root)))
         (org-confirm-babel-evaluate nil)
         (tangled-files '())
         (log-buf (get-buffer-create "*Dotfiles Tangle Log*")))
    (with-current-buffer log-buf
      (read-only-mode -1)
      (erase-buffer)
      (insert "Drifting through your dotfiles...\n\n"))
    (dolist (file (directory-files-recursively (expand-file-name root) "\\.org$"))
      (with-current-buffer (find-file-noselect file)
        (unless (derived-mode-p 'org-mode)
          (org-mode))
        ;; Check if file has tangleable blocks
        (let ((has-tangle (org-element-map (org-element-parse-buffer) 'src-block
                            (lambda (block)
                              (org-element-property :parameters block))
                            nil t)))
          (when has-tangle
            (condition-case err
                (progn
                  (org-babel-tangle)
                  (push file tangled-files)
                  (with-current-buffer log-buf
                    (insert (format "✓ Tangled: %s\n"
                                    (file-relative-name file root)))))
              (error
               (with-current-buffer log-buf
                 (insert (format "✗ Error in %s: %s\n"
                                 (file-relative-name file root)
                                 (error-message-string err))))))
            ;; Kill buffer to avoid too many open files
            (kill-buffer)))))
    (with-current-buffer log-buf
      (insert "\n")
      (if tangled-files
          (insert (format "Total files tangled: %d\n" (length tangled-files)))
        (insert "No files with :tangle headers found.\n"))
      (read-only-mode 1))
    (display-buffer log-buf)
    (message "Tangle complete! Check *Dotfiles Tangle Log* buffer.")))

(provide 'tangle)
;;; tangle.el ends here
