(menu-bar-mode -1)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)


(require 'package)
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'package-archives' ("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives' ("elpa" . "http://elpa.gnu.org/packages/"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   (vector "#eaeaea" "#d54e53" "DarkOliveGreen3" "#e7c547" "DeepSkyBlue1" "#c397d8" "#70c0b1" "#181a26"))
 '(custom-enabled-themes '(deeper-blue))
 '(custom-safe-themes
   '("3cc2385c39257fed66238921602d8104d8fd6266ad88a006d0a4325336f5ee02" "3cd28471e80be3bd2657ca3f03fbb2884ab669662271794360866ab60b6cb6e6" "c48551a5fb7b9fc019bf3f61ebf14cf7c9cdca79bcb2a4219195371c02268f11" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "96998f6f11ef9f551b427b8853d947a7857ea5a578c75aa9c4e7c73fe04d10b4" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693" default))
 '(ecb-options-version "2.40")
 '(fci-rule-color "#14151E")
 '(global-ede-mode t)
 '(js-indent-level 2)
 '(line-number-mode nil)
 '(linum-format " %5i ")
 '(package-selected-packages
   '(react-snippets autopair coffee-mode alert-termux company-emoji emojify slack indium go-playground company-go go-mode ruby-electric ruby-tools powerline sublime-themes yasnippet-snippets yasnippet company-lsp flycheck magit-gh-pulls gh ido-vertical-mode afternoon-theme forge git-link git-gutter magit ido-grid-mode zoom tsc lsp-docker lsp-mode company web-mode docker-compose-mode dockerfile-mode js2-mode typescript-mode auto-complete ispell))
 '(tab-stop-list
   '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60))
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
 '(default ((t (:background nil)))))
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
(require 'company-emoji)
(require 'slack)
(require 'alert)
(setq electric-pair-mode t)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq line-number-mode t)

(setq-default indent-tabs-mode nil)
(setq-default js2-basic-offset 2)
(setq-default typescript-indent-level 2)

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
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . typescript-mode))
(add-to-list 'company-backends 'company-emoji)

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-golangci-lint-setup))

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'js2-mode-hook #'lsp)
(add-hook 'web-mode #'lsp)
(add-hook 'typescript-mode-hook #'lsp)
(add-hook 'after-init-hook #'global-emojify-mode)
(global-linum-mode t)
(ido-mode 1)
(electric-pair-mode 1)
