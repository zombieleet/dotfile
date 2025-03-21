(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
 '(package-selected-packages
   '(terraform-mode dap-mode protobuf-mode k8s-mode git-link makefile-executor kubernetes jest-test-mode restclient)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'customize-group 'disabled nil)

(require 'jest-test-mode)
(add-hook 'typescript-mode-hook 'jest-test-mode)
(add-hook 'js-mode-hook 'jest-test-mode)
(add-hook 'typescript-tsx-mode-hook 'jest-test-mode)
