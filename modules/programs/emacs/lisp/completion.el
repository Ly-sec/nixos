;;; completion.el -*- lexical-binding: t -*-

(use-package vertico
  :demand t
  :custom (vertico-cycle t)
  :config (vertico-mode 1))
(use-package orderless
  :demand t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))
(use-package marginalia
  :demand t
  :config (marginalia-mode 1))
(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)))
(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode 1)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
  (nerd-icons-completion-marginalia-setup))
(use-package corfu
  :demand t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)
  :config
  (global-corfu-mode 1)
  (require 'corfu-popupinfo)
  (corfu-popupinfo-mode 1))
(use-package cape
  :demand t
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev t))
