(setq org-directory "/mnt/storage/org/")

(after! org
  (setq org-hide-emphasis-markers t
        org-ellipsis " ▼ "
        org-pretty-entities t
        org-startup-indented t
        org-startup-folded 'content
        org-startup-with-inline-images t
        org-image-actual-width '(300)))

(use-package! org-superstar
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("●" "○" "◆" "◇" "▶")))

(use-package! org-appear
  :hook (org-mode . org-appear-mode))

(use-package! org-modern
  :hook (org-mode . org-modern-mode))

(use-package! valign
  :hook (org-mode . valign-mode))

(provide 'org-mode)
