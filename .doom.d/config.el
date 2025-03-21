;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq-default tab-width 2)

(setq-default tab-stop-list
              '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60))
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Victory"
      user-mail-address "osikwemhev@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq-default js-indent-level 2)
(setq-default typescript-indent-level 2)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(defun copy-current-buffer-file-name ()
  (interactive)
  (shell-command (concat "echo " (buffer-file-name) " | pbcopy")))

;; Go mode configuration
(use-package! go-mode
  :defer t)

;; Flycheck
(use-package! flycheck
  :ensure t)

;; LSP configuration for Go
(use-package! lsp-mode
  :hook ((go-mode . lsp-deferred)
         (js2-mode . lsp-deferred))
  :commands (lsp lsp-deferred))

;; JS2 Mode for JavaScript
(use-package! js2-mode
  :defer t)

;; Node.js REPL
(use-package! nodejs-repl
  :ensure t)

;; Company for autocompletion
(use-package! company
  :ensure t)

;; LSP Treemacs integration
(use-package! lsp-treemacs
  :after (lsp-mode treemacs)
  :ensure t)


;; DAP mode configuration
(use-package! dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode)

  ;; Go debugging configuration
  (require 'dap-dlv-go)

  ;; Node.js debugging configuration
  (require 'dap-node)
  (dap-node-setup)

  ;; Add environment variables for TypeScript tests
  (setq dap-node-default-debug-program "node")

  ;; Direct function for debugging TypeScript tests
  (defun dap-debug-typescript-test ()
    "Debug current TypeScript test file with proper configuration."
    (interactive)
    (let* ((project-dir (projectile-project-root))
           (file-name (buffer-file-name))
           (rel-file (file-relative-name file-name project-dir)))
      (dap-debug
       (list :type "node"
             :request "launch"
             :name "Debug TypeScript Test"
             :runtimeExecutable "node"
             :runtimeArgs (vector "--inspect-brk"
                                  (concat project-dir "node_modules/.bin/jest")
                                  "--runInBand"
                                  "--no-cache"
                                  rel-file)
             :cwd project-dir
             :env (list (cons "TS_NODE_PROJECT" (concat project-dir "tsconfig.test.base.json"))
                        (cons "NODE_ENV" "test")
                        (cons "JEST_TEST_TYPE" "unit"))
             :sourceMaps t
             :console "integratedTerminal"
             :internalConsoleOptions "neverOpen"
             :skipFiles (vector "<node_internals>/**")))))

  ;; Enhance all Node.js launch configurations for TypeScript
  (advice-add 'dap-register-debug-template :around
              (lambda (orig-fun name conf)
                "Enhance TypeScript test configurations in launch.json"
                ;; Check if this is a Node.js configuration that might involve TypeScript
                (when (and (plist-get conf :type)
                           (string= (plist-get conf :type) "node")
                           (or (and (plist-get conf :program)
                                    (string-match-p "jest\\|ts-node" (plist-get conf :program)))
                               (and (plist-get conf :runtimeArgs)
                                    (seq-some (lambda (arg)
                                                (string-match-p "jest\\|ts-node\\|typescript" arg))
                                              (plist-get conf :runtimeArgs)))))
                  ;; This is likely a TypeScript-related configuration, enhance it
                  (setq conf (plist-put conf :sourceMaps t))

                  ;; Add TypeScript environment variables if not already present
                  (let ((env (plist-get conf :env)))
                    (unless (assoc "TS_NODE_PROJECT" env)
                      (setq env (cons (cons "TS_NODE_PROJECT" "${workspaceFolder}/tsconfig.test.base.json") env)))
                    (unless (assoc "NODE_ENV" env)
                      (setq env (cons (cons "NODE_ENV" "test") env)))
                    (unless (assoc "JEST_TEST_TYPE" env)
                      (setq env (cons (cons "JEST_TEST_TYPE" "unit") env)))
                    (plist-put conf :env env)))

                ;; Call the original function with possibly enhanced configuration
                (funcall orig-fun name conf)))

  ;; Add keybinding for the direct debug function
  (map! :leader
        (:prefix "d"
         :desc "Debug TypeScript test" "t" #'dap-debug-typescript-test))

  ;; Function to load the .vscode/launch.json file and set up DAP configurations
  (defun dap-load-vscode-launch-json ()
    "Load the launch.json file from .vscode directory and setup dap-mode."
    (interactive)
    (let* ((project-dir (or (projectile-project-root) default-directory))
           (launch-file (concat project-dir ".vscode/launch.json")))
      (if (file-exists-p launch-file)
          (progn
            (message "Loading %s" launch-file)
            (with-temp-buffer
              (insert-file-contents launch-file)
              ;; Remove comments if they exist (VSCode supports JSON with comments)
              (goto-char (point-min))
              (while (re-search-forward "\\(//.*\\)" nil t)
                (replace-match ""))
              ;; Also handle multi-line comments
              (goto-char (point-min))
              (while (re-search-forward "/\\*\\(.\\|\n\\)*?\\*/" nil t)
                (replace-match ""))
              ;; Remove trailing commas which are invalid in standard JSON
              (goto-char (point-min))
              (while (re-search-forward ",[ \t\n]*[]}]" nil t)
                (replace-match "\\1"))
              ;; Now parse the cleaned JSON
              (goto-char (point-min))
              (condition-case err
                  (let ((json-object-type 'hash-table)
                        (json-array-type 'list)
                        (json-key-type 'string)
                        (json-false nil)
                        (json-null nil))
                    (let ((launch-config (json-read)))
                      (when-let ((configurations (gethash "configurations" launch-config)))
                        (dolist (config configurations)
                          (let ((config-type (gethash "type" config)))
                            (cond
                             ((string= config-type "go")
                              ;; Convert VSCode Go config to DAP Go config
                              (dap-register-debug-template
                               (gethash "name" config)
                               (list :type "go"
                                     :request (gethash "request" config)
                                     :name (gethash "name" config)
                                     :mode (or (gethash "mode" config) "auto")
                                     :program (gethash "program" config)
                                     :args (or (gethash "args" config) nil)
                                     :env (or (gethash "env" config) nil)
                                     :cwd (or (gethash "cwd" config) "${workspaceFolder}"))))

                             ((string= config-type "node")
                              ;; Convert VSCode Node config to DAP Node config
                              (dap-register-debug-template
                               (gethash "name" config)
                               (list :type "node"
                                     :request (gethash "request" config)
                                     :name (gethash "name" config)
                                     :program (gethash "program" config)
                                     :args (or (gethash "args" config) nil)
                                     :env (or (gethash "env" config) nil)
                                     :cwd (or (gethash "cwd" config) "${workspaceFolder}")
                                     :sourceMaps (or (gethash "sourceMaps" config) t)
                                     :protocol (or (gethash "protocol" config) "inspector")
                                     :restart (or (gethash "restart" config) nil)
                                     :port (or (gethash "port" config) 9229))))))))))
                (error
                 (message "Error parsing launch.json: %s" (error-message-string err))
                 nil)))
            (message "Launch configurations loaded from %s" launch-file))
        (message "No .vscode/launch.json found in project"))))


  ;; Add hooks for Go and JS modes to load launch.json
  (add-hook 'go-mode-hook #'dap-load-vscode-launch-json)
  (add-hook 'js2-mode-hook #'dap-load-vscode-launch-json)

  ;; Enable Dap UI features
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)

  ;; Corrected extended keybindings for DAP mode
  (map! :leader
        (:prefix "d" ; debug
         ;; Core debugging commands
         :desc "Start debugging" "d" #'dap-debug
         :desc "Debug last configuration" "l" #'dap-debug-last
         :desc "Debug TypeScript test" "T" #'dap-debug-typescript-test
         :desc "Continue" "c" #'dap-continue
         :desc "Next" "n" #'dap-next
         :desc "Step in" "i" #'dap-step-in
         :desc "Step out" "o" #'dap-step-out
         :desc "Restart frame" "r" #'dap-restart-frame
         :desc "Disconnect" "q" #'dap-disconnect

         ;; Simple breakpoint toggle remains at top level
         :desc "Toggle breakpoint" "b" #'dap-breakpoint-toggle

         ;; Breakpoint management under "B" prefix
         (:prefix ("B" . "breakpoints")
          :desc "Add breakpoint" "a" #'dap-breakpoint-add
          :desc "Delete breakpoint" "d" #'dap-breakpoint-delete
          :desc "Delete all breakpoints" "D" #'dap-breakpoint-delete-all
          :desc "Toggle condition" "c" #'dap-breakpoint-condition
          :desc "Toggle hit condition" "h" #'dap-breakpoint-hit-condition
          :desc "Toggle log message" "l" #'dap-breakpoint-log-message)

         ;; Information and state inspection
         (:prefix ("I" . "information")
          :desc "Show locals" "l" #'dap-ui-locals
          :desc "Show breakpoints" "b" #'dap-ui-breakpoints
          :desc "Show expressions" "e" #'dap-ui-expressions
          :desc "Show sessions" "s" #'dap-ui-sessions
          :desc "Show all windows" "a" #'dap-ui-show-many-windows
          :desc "List templates" "t" #'dap-debug-last-configuration
          :desc "Eval at point" "p" #'dap-eval-thing-at-point
          :desc "Eval in repl" "r" #'dap-ui-repl)

         ;; Stack frame navigation
         (:prefix ("F" . "frames")
          :desc "Next frame" "n" #'dap-next-frame
          :desc "Previous frame" "p" #'dap-previous-frame
          :desc "Switch frame" "s" #'dap-switch-stack-frame
          :desc "Up frame" "u" #'dap-up-stack-frame
          :desc "Down frame" "d" #'dap-down-stack-frame)

         ;; Expression evaluation
         (:prefix ("E" . "evaluate")
          :desc "Eval" "e" #'dap-eval
          :desc "Eval region" "r" #'dap-eval-region
          :desc "Eval thing at point" "t" #'dap-eval-thing-at-point
          :desc "Add expression" "a" #'dap-ui-expressions-add)))

  ;; Add hook to ensure UI elements are available
  (add-hook 'dap-stopped-hook
            (lambda (arg)
              (call-interactively #'dap-hydra)))

  ;; Custom function to start debugging with configuration selection
  (defun my/dap-debug-select ()
    "Start debugging with configuration selection."
    (interactive)
    (call-interactively #'dap-debug))

  (map! :leader
        (:prefix "d"
         :desc "Debug (select config)" "s" #'my/dap-debug-select))

  :hook ((go-mode . dap-mode)
         (js2-mode . dap-mode)))

;; Enable DAP mode by default in programming modes
(add-hook 'prog-mode-hook #'dap-mode)

;; If you want the UI controls to also be enabled by default
(add-hook 'prog-mode-hook #'dap-ui-mode)

;; Ellama configuration
(use-package ellama
  :ensure t
  :bind ("C-c e" . ellama-transient-main-menu)
  ;; send last message in chat buffer with C-c C-c
  :hook (org-ctrl-c-ctrl-c-final . ellama-chat-send-last-message)
  :init
  ;; setup key bindings
  ;; (setopt ellama-keymap-prefix "C-c e")
  ;; language you want ellama to translate to
  (setopt ellama-language "English")
  ;; could be llm-openai for example
  (require 'llm-ollama)
  (setopt ellama-provider
          (make-llm-ollama
           ;; this model should be pulled to use it
           ;; value should be the same as you print in terminal during pull
           :chat-model "qwen2.5-coder:14b-instruct-q5_K_M"
           :embedding-model "nomic-embed-text"
           :default-chat-non-standard-params '(("num_ctx" . 8192))))
  (setopt ellama-summarization-provider
          (make-llm-ollama
           :chat-model "qwen2.5:14b-instruct-q5_K_M"
           :embedding-model "nomic-embed-text"
           :default-chat-non-standard-params '(("num_ctx" . 32768))))
  (setopt ellama-coding-provider
          (make-llm-ollama
           :chat-model "qwen2.5-coder:14b-instruct-q5_K_M"
           :embedding-model "nomic-embed-text"
           :default-chat-non-standard-params '(("num_ctx" . 32768))))
  ;; Naming new sessions with llm
  (setopt ellama-naming-provider
          (make-llm-ollama
           :chat-model "llama3:8b-instruct-q5_K_M"
           :embedding-model "nomic-embed-text"
           :default-chat-non-standard-params '(("stop" . ("\n")))))
  (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
  ;; Translation llm provider
  (setopt ellama-translation-provider
          (make-llm-ollama
           :chat-model "qwen2.5-coder:14b-instruct-q5_K_M"
           :embedding-model "nomic-embed-text"
           :default-chat-non-standard-params
           '(("num_ctx" . 32768))))
  (setopt ellama-extraction-provider (make-llm-ollama
                                      :chat-model "qwen2.5-coder:7b-instruct-q8_0"
                                      :embedding-model "nomic-embed-text"
                                      :default-chat-non-standard-params
                                      '(("num_ctx" . 32768))))
  ;; customize display buffer behaviour
  ;; see ~(info "(elisp) Buffer Display Action Functions")~
  (setopt ellama-chat-display-action-function #'display-buffer-full-frame)
  (setopt ellama-instant-display-action-function #'display-buffer-at-bottom)
  :config
  ;; show ellama context in header line in all buffers
  (ellama-context-header-line-global-mode +1)
  ;; handle scrolling events
  (advice-add 'pixel-scroll-precision :before #'ellama-disable-scroll)
  (advice-add 'end-of-buffer :after #'ellama-enable-scroll))
