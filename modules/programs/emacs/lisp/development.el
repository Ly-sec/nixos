;;; development.el -*- lexical-binding: t -*-

(require 'envrc)
(require 'eglot)

(use-package nix-mode :mode "\\.nix\\'")
(use-package nim-mode :mode "\\.nim\\(?:s\\|ble\\)?\\'")
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode) ("\\.markdown\\'" . markdown-mode))
  :custom
  (markdown-command '("cmark-gfm" "--unsafe" "--extension" "table"
                       "--extension" "strikethrough" "--extension" "autolink"
                       "--extension" "tasklist")))

(defvar-local lysec-markdown-preview-source nil)

(defun lysec-markdown-render-code (dom)
  "Render DOM as code with terminal-visible styling."
  (shr-fontize-dom dom 'org-code))

(defun lysec-markdown-render-code-block (dom)
  "Render DOM as a code block, preserving whitespace."
  (let ((start (point)))
    (shr-tag-pre dom)
    (shr-add-font start (point) 'org-block)))

(defun lysec-markdown-preview ()
  "Render Markdown in a reading pane, or refresh its existing preview."
  (interactive)
  (require 'eww)
  (let* ((source (or lysec-markdown-preview-source (current-buffer)))
         (html (generate-new-buffer " *Markdown HTML*"))
         preview)
    (unwind-protect
        (with-current-buffer source
          (unless (derived-mode-p 'markdown-mode)
            (user-error "Open a Markdown buffer first"))
          (let* ((name (buffer-name))
                 (directory default-directory)
                 (url (url-encode-url (concat "file://" (or buffer-file-name directory)))))
            (save-excursion
              (save-restriction
                (widen)
                (let ((mark-active nil))
                  (markdown-standalone (buffer-name html) name))))
            (setq preview (get-buffer-create (format "*Markdown: %s*" name)))
            (with-current-buffer preview
              (eww-mode)
              (setq-local lysec-markdown-preview-source source
                          default-directory directory
                          shr-use-fonts nil
                          shr-use-colors nil
                          shr-inhibit-images t
                          shr-table-horizontal-line ?─
                          shr-table-vertical-line ?│
                          shr-table-corner ?┼
                          shr-external-rendering-functions
                          '((code . lysec-markdown-render-code)
                            (pre . lysec-markdown-render-code-block))
                          eww-data (list :url url))
              (dotimes (index 6)
                (face-remap-add-relative
                 (intern (format "shr-h%d" (1+ index)))
                 :inherit (intern (format "org-level-%d" (1+ index)))
                 :height 1.0 :weight 'bold :slant 'normal))
              (let ((map (copy-keymap eww-mode-map)))
                (define-key map (kbd "g") #'lysec-markdown-preview)
                (use-local-map map)))
            (pop-to-buffer preview
                           '((display-buffer-reuse-window display-buffer-in-side-window)
                             (side . right) (slot . 0) (window-width . 0.5)))
            (with-current-buffer html
              (goto-char (point-min))
              (eww-display-html 'utf-8 url nil nil preview))
            (with-current-buffer preview (set-buffer-modified-p nil))))
      (kill-buffer html))
    (set-buffer preview)))

(setq c-basic-offset 4
      nim-indent-offset 2
      eglot-autoshutdown t
      eglot-events-buffer-config '(:size 0 :format full)
      eglot-connect-timeout 30)
(add-to-list 'eglot-server-programs '(nix-mode . ("nixd")))
(add-to-list 'eglot-server-programs '(nim-mode . ("nimlsp")))
(add-to-list 'eglot-server-programs
             '((c-mode c++-mode c-ts-mode c++-ts-mode)
               . ("clangd" "--background-index" "--clang-tidy")))

(defun lysec-start-language-server ()
  "Load the project environment before connecting its language server."
  (when (and buffer-file-name
             (not (file-remote-p buffer-file-name))
             (derived-mode-p 'nix-mode 'nim-mode 'c-mode 'c++-mode
                             'c-ts-mode 'c++-ts-mode))
    (envrc-mode 1)
    (setq-local exec-path (append exec-path (list lysec-tools-directory)))
    (eglot-ensure)))

; Major-mode hooks run before envrc's find-file hook has set the environment.
(add-hook 'find-file-hook #'lysec-start-language-server t)
(add-hook 'after-revert-hook #'lysec-start-language-server)
(add-hook 'eglot-managed-mode-hook
          (lambda () (setq-local completion-category-defaults nil)))

(use-package apheleia
  :demand t
  :config
  (setf (alist-get 'alejandra apheleia-formatters) '("alejandra" "--quiet"))
  (setf (alist-get 'nimpretty apheleia-formatters)
        '("nimpretty" "--stdin" "--indent:2"))
  (setf (alist-get 'prettier-markdown apheleia-formatters)
        '("prettier" "--parser" "markdown" "--stdin-filepath" filepath))
  (dolist (entry '((nix-mode . alejandra)
                   (nim-mode . nimpretty)
                   (c-mode . clang-format)
                   (c++-mode . clang-format)
                   (c-ts-mode . clang-format)
                   (c++-ts-mode . clang-format)
                   (markdown-mode . prettier-markdown)
                   (sh-mode . shfmt)))
    (setf (alist-get (car entry) apheleia-mode-alist) (cdr entry)))
  (setq apheleia-inhibit-functions
        (cons (lambda ()
                (or (derived-mode-p 'json-mode 'js-json-mode 'json-ts-mode)
                    (and buffer-file-name
                         (string-match-p "\\.json\\'" buffer-file-name))))
              apheleia-inhibit-functions))
  (apheleia-global-mode 1))

(defun lysec-project-environment-setup ()
  "Create and allow a direnv file using the project's default flake shell."
  (interactive)
  (let* ((project (project-current t))
         (default-directory (project-root project))
         (file (expand-file-name ".envrc")))
    (unless (file-exists-p "flake.nix")
      (user-error "This project has no flake.nix"))
    (if (file-exists-p file)
        (find-file file)
      (with-temp-file file (insert "use flake\n")))
    (envrc-allow)
    (envrc-reload)))
