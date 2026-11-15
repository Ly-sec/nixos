;;; init.el -*- lexical-binding: t -*-

(defvar lysec-config-directory
  (file-name-directory (or load-file-name user-init-file))
  "Directory containing the deployed Emacs configuration.")
(load (expand-file-name "paths.el" lysec-config-directory) nil t)

(dolist (module '(core editing completion ui files development notes dashboard keys))
  (load (expand-file-name (format "lisp/%s.el" module) lysec-config-directory) nil t))

; Install environment hooks last so project tools are available first.
(add-hook 'after-init-hook #'envrc-global-mode)
