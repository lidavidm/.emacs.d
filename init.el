(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(column-number-mode 1)
(electric-pair-mode 1)
(global-auto-revert-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq exec-path (append exec-path '("/home/lidavidm/.local/bin")))
(setq-default indent-tabs-mode nil)

(add-hook 'before-save-hook #'delete-trailing-whitespace)
(add-hook 'c-mode-hook #'eglot-ensure)

(add-hook 'c++-mode-hook (lambda ()
                           (eglot-ensure)
                           (google-set-c-style)
                           (define-key c++-mode-map [C-down-mouse-1] 'xref-find-definitions)
                           (setq-local indent-region-function 'eglot-format)))

(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'flyspell-prog-mode)

(use-package ace-window
  :init
  (global-set-key (kbd "C-x o") 'ace-window))

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
            '((c-mode c++-mode)
                 . ("clangd"
                    "-j=8"
                    "--all-scopes-completion"
                    "--log=error"
                    "--malloc-trim"
                    "--background-index"
                    "--background-index-priority=low"
                    "--clang-tidy"
                    "--header-insertion=iwyu"
                    "--header-insertion-decorators"
                    "--fallback-style=google"
                    "--pch-storage=memory"))))

(use-package company
  :init
  (global-company-mode))

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-minor-modes nil))

(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))

(use-package evil
  :ensure t
  :init
  (evil-mode 1)
  (setq-default evil-cross-lines t)
  (define-key evil-insert-state-map (kbd "C-d") 'evil-delete-char)
  (define-key evil-insert-state-map (kbd "M-d") 'kill-word)
  (define-key evil-normal-state-map (kbd ";") 'comment-or-uncomment-region-or-line)
  (define-key evil-visual-state-map (kbd ";") 'comment-or-uncomment-region-or-line))

(use-package evil-escape
  :init
  (evil-escape-mode 1)
  (setq-default evil-escape-key-sequence "fd"))

(use-package evil-numbers
  :init
  (evil-define-key 'normal 'global
    "g+" 'evil-numbers/inc-at-pt
    "g=" 'evil-numbers/inc-at-pt
    "g-" 'evil-numbers/dec-at-pt))

(use-package evil-surround
  :init
  (global-evil-surround-mode 1))

(use-package expand-region
  :init
  (define-key evil-visual-state-map (kbd "v") 'er/expand-region)
  (define-key evil-visual-state-map (kbd "V") 'er/contract-region))

(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(use-package nerd-icons
  :custom
  (nerd-icons-font-family "JetBrainsMono Nerd Font"))

(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package selectrum
  :init
  (selectrum-mode 1)
  (selectrum-prescient-mode 1)
  (prescient-persist-mode 1))

(use-package string-inflection)

(use-package undo-tree
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  :init
  (global-undo-tree-mode 1))

(use-package yasnippet
  :init
  (yas-global-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-undo-system 'undo-tree)
 '(fill-column 78)
 '(package-selected-packages
   '(go-mode flycheck-eglot company flycheck google-c-style expand-region evil-escape evil evil-numbers evil-surround string-inflection prescient selectrum selectrum-prescient doom-modeline doom-themes yasnippet ace-window rainbow-delimiters undo-tree)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
