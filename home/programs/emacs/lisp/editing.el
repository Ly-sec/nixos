;;; editing.el -*- lexical-binding: t -*-

(setq-default indent-tabs-mode nil
              tab-width 2
              fill-column 100)
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'prog-mode-hook #'hs-minor-mode)
(electric-pair-mode 1)
(show-paren-mode 1)
(delete-selection-mode 1)

(use-package undo-fu-session
  :demand t
  :custom (undo-fu-session-directory (lysec-state-file "undo/"))
  :config (undo-fu-session-global-mode 1))
(use-package meow
  :demand t
  :custom (meow-use-clipboard t)
  :config
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwertz
        meow-cheatsheet-physical-layout meow-cheatsheet-physical-layout-iso)
  (meow-motion-define-key '("j" . meow-next) '("k" . meow-prev))
  (dotimes (digit 10)
    (meow-normal-define-key
     (cons (number-to-string digit) (intern (format "meow-expand-%s" digit)))))
  (meow-normal-define-key
   '("i" . meow-prev) '("k" . meow-next)
   '("j" . meow-left) '("l" . meow-right)
   '("I" . meow-prev-expand) '("K" . meow-next-expand)
   '("J" . meow-left-expand) '("L" . meow-right-expand)
   '("u" . meow-back-word) '("U" . meow-back-symbol)
   '("o" . meow-next-word) '("O" . meow-next-symbol)
   '("a" . meow-mark-word) '("A" . meow-mark-symbol)
   '("s" . meow-line) '("S" . meow-goto-line)
   '("w" . meow-block) '("q" . meow-join)
   '("g" . meow-grab) '("G" . meow-pop-grab)
   '("m" . meow-swap-grab) '("M" . meow-sync-grab)
   '("p" . meow-cancel-selection) '("P" . meow-pop-selection)
   '("x" . meow-till) '("y" . meow-find)
   '("," . meow-beginning-of-thing) '("." . meow-end-of-thing)
   '(";" . meow-inner-of-thing) '(":" . meow-bounds-of-thing)
   '("d" . meow-kill) '("f" . meow-change) '("t" . meow-delete)
   '("c" . meow-save) '("v" . meow-yank) '("V" . meow-yank-pop)
   '("e" . meow-insert) '("E" . meow-open-above)
   '("r" . meow-append) '("R" . meow-open-below)
   '("h" . undo-only) '("H" . undo-redo)
   '("b" . open-line) '("B" . split-line)
   '("z" . meow-search) '("-" . meow-visit)
   '("ä" . meow-reverse)
   '("ü" . indent-rigidly-left-to-tab-stop)
   '("+" . indent-rigidly-right-to-tab-stop)
   '("<escape>" . meow-cancel-selection))
  (dolist (entry '((dired-mode . motion) (treemacs-mode . motion)
                   (magit-mode . motion) (org-agenda-mode . motion)
                   (lysec-dashboard-mode . motion) (eshell-mode . insert)))
    (add-to-list 'meow-mode-state-list entry))
  (meow-global-mode 1))
(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))
(use-package hl-todo :hook (prog-mode . hl-todo-mode))
