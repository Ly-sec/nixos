;;; early-init.el -*- lexical-binding: t -*-

(setq package-enable-at-startup nil
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      frame-inhibit-implied-resize t)
(menu-bar-mode -1)
