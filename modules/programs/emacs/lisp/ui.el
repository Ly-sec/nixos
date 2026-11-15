;;; ui.el -*- lexical-binding: t -*-

(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" lysec-config-directory))
(load-theme 'noctalia t)
(setq-default mode-line-format
              '(" " (:eval (meow-indicator))
                "  " mode-line-buffer-identification "  " mode-line-modified
                "  %l:%c  " mode-name
                (:eval (when (bound-and-true-p eglot--managed-mode) " LSP"))
                "  " vc-mode))
(setq display-time-default-load-average nil)

(require 'disp-table)
(unless standard-display-table
  (setq standard-display-table (make-display-table)))
(set-display-table-slot standard-display-table 'vertical-border
                        (make-glyph-code ?│ 'vertical-border))

(defun lysec-style-panes (&rest _)
  "Keep pane boundaries visible using colors from the active theme."
  (let ((border (face-foreground 'shadow nil t))
        (active-background (face-background 'mode-line nil t))
        (active-foreground (face-foreground 'mode-line nil t))
        (inactive-background (face-background 'corfu-default nil t)))
    (set-face-attribute 'vertical-border nil
                        :foreground border
                        :background (face-background 'default nil t))
    (set-face-attribute 'mode-line-active nil
                        :background active-background
                        :foreground active-foreground :box nil)
    (set-face-attribute 'mode-line-inactive nil
                        :background inactive-background :box nil)
    (set-face-attribute 'mode-line-buffer-id nil
                        :foreground active-foreground :weight 'bold)))

(add-hook 'enable-theme-functions #'lysec-style-panes)
(lysec-style-panes)

(defun lysec-key-menu-style ()
  "Give the key menu a surface and accents from the active theme."
  (face-remap-add-relative 'default
                          :background (face-background 'corfu-default nil t))
  (dolist (pair '((which-key-key-face . font-lock-constant-face)
                  (which-key-group-description-face . font-lock-type-face)
                  (which-key-note-face . font-lock-constant-face)))
    (face-remap-add-relative (car pair)
                            :foreground (face-foreground (cdr pair) nil t)
                            :weight 'bold)))

(defun lysec-keypad-menu (keymap)
  "Display KEYMAP with the name of the current Space menu."
  (let* ((keys (meow--keypad-format-keys))
         (menu (if (string-empty-p keys)
                   lysec-leader-map
                 (meow--keypad-lookup-key (kbd keys))))
         (title (and (keymapp menu) (keymap-prompt menu))))
    (which-key--create-buffer-and-show
     nil (if (string-empty-p keys) lysec-leader-map keymap) nil
     (concat (if (or (string-empty-p keys) meow--keypad-base-keymap)
                 (concat "SPC" (unless (string-empty-p keys) (concat " " keys)))
               keys)
             "  ·  " (or title "Emacs")))))

(use-package which-key
  :demand t
  :custom
  (which-key-idle-delay 0.35)
  (which-key-idle-secondary-delay 0.05)
  (which-key-popup-type 'side-window)
  (which-key-side-window-location 'bottom)
  (which-key-side-window-slot 1)
  (which-key-side-window-max-height 0.4)
  (which-key-allow-imprecise-window-fit nil)
  (which-key-max-display-columns 3)
  (which-key-add-column-padding 2)
  (which-key-max-description-length 28)
  (which-key-separator "  ›  ")
  (which-key-prefix-prefix "")
  (which-key-ellipsis "…")
  (which-key-show-prefix 'mode-line)
  (which-key-sort-uppercase-first nil)
  :hook (which-key-init-buffer . lysec-key-menu-style)
  :config (which-key-mode 1))

(add-to-list 'display-buffer-alist
             '("\\*\\(?:eshell\\|compilation\\|Help\\|Apropos\\|Warnings\\|Flymake diagnostics\\).*"
               (display-buffer-reuse-window display-buffer-in-side-window)
               (side . bottom) (slot . 0) (window-height . 0.3)))

(defun lysec-split-window (side &optional blank)
  "Focus a new pane on SIDE, optionally starting with a BLANK buffer."
  (select-window (split-window nil nil side))
  (when blank (lysec-new-buffer)))

(defun lysec-terminal ()
  "Open a project shell in the lower panel with the current environment."
  (interactive)
  (require 'eshell)
  (let* ((root (or (when-let* ((project (project-current))) (project-root project))
                   default-directory))
         (default-directory root)
         (eshell-buffer-name (format "*eshell:%s*" (abbreviate-file-name root)))
         (buffer (save-window-excursion (eshell))))
    (select-window (display-buffer buffer))))

(defun lysec-elcord-sync (&optional closing-display)
  "Keep Discord presence active while an editor frame remains open.
CLOSING-DISPLAY is a frame or terminal being deleted."
  (unless noninteractive
    (let ((open (cl-some
                 (lambda (frame)
                   (and (frame-live-p frame)
                        (not (frame-initial-p frame))
                        (not (eq frame closing-display))
                        (not (eq (frame-terminal frame) closing-display))))
                 (frame-list))))
      (if open
          (unless (or closing-display (bound-and-true-p elcord-mode))
            (elcord-mode 1))
        (when (bound-and-true-p elcord-mode) (elcord-mode -1))))))

(use-package elcord
  :defer 3
  :custom
  (elcord-editor-icon "emacs_icon")
  (elcord-use-major-mode-as-main-icon nil)
  (elcord-idle-message "Idling")
  (elcord-idle-time 300)
  (elcord-display-elapsed nil)
  :config
  (add-hook 'after-make-frame-functions (lambda (_frame) (lysec-elcord-sync)))
  (add-hook 'delete-frame-functions #'lysec-elcord-sync)
  (add-hook 'delete-terminal-functions #'lysec-elcord-sync)
  (lysec-elcord-sync))
