(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)


(require 'package)
(add-to-list 'package-archives' ("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives' ("elpa" . "http://elpa.gnu.org/packages/"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes '(misterioso deeper-blue))
 '(ecb-options-version "2.40")
 '(fci-rule-color "#14151E")
 '(global-ede-mode t)
 '(line-number-mode nil)
 '(package-selected-packages
   '(yasnippet-snippets yasnippet company-lsp flycheck magit-gh-pulls gh ido-vertical-mode afternoon-theme forge git-link git-gutter magit ido-grid-mode zoom tsc lsp-docker lsp-mode company web-mode docker-compose-mode dockerfile-mode js2-mode typescript-mode auto-complete ispell))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   '((20 . "#d54e53")
     (40 . "goldenrod")
     (60 . "#e7c547")
     (80 . "DarkOliveGreen3")
     (100 . "#70c0b1")
     (120 . "DeepSkyBlue1")
     (140 . "#c397d8")
     (160 . "#d54e53")
     (180 . "goldenrod")
     (200 . "#e7c547")
     (220 . "DarkOliveGreen3")
     (240 . "#70c0b1")
     (260 . "DeepSkyBlue1")
     (280 . "#c397d8")
     (300 . "#d54e53")
     (320 . "goldenrod")
     (340 . "#e7c547")
     (360 . "DarkOliveGreen3")))
 '(vc-annotate-very-old-color nil)
 '(zoom-mode t nil (zoom)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
	kept-new-versions 2
	kept-old-versions 2
	version-control t)

(require 'ispell)
(require 'lsp-mode)
(require 'js2-mode)
(require 'web-mode)
(require 'ido)
(require 'typescript-mode)
(require 'company-lsp)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq line-number-mode t)
(setq js2-basic-offset 2)

(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . typescript-mode))

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'js2-mode-hook #'lsp)
(add-hook 'web-mode #'lsp)
(add-hook 'typescript-mode-hook #'lsp)

(global-linum-mode t)
(ido-mode 1)
