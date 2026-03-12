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

;; Ensure commonly used local bins are in PATH for Doom/Emacs runtime
(let ((go-bin (expand-file-name "~/go/bin"))
      (user-py-bin (expand-file-name "~/Library/Python/3.14/bin"))
      (user-bin (expand-file-name "~/bin"))
      (user-local-bin (expand-file-name "~/.local/bin")))
  (when (file-directory-p go-bin)
    (add-to-list 'exec-path go-bin)
    (setenv "PATH" (concat go-bin ":" (getenv "PATH"))))
  (when (file-directory-p user-py-bin)
    (add-to-list 'exec-path user-py-bin)
    (setenv "PATH" (concat user-py-bin ":" (getenv "PATH"))))
  (when (file-directory-p user-bin)
    (add-to-list 'exec-path user-bin)
    (setenv "PATH" (concat user-bin ":" (getenv "PATH"))))
  (when (file-directory-p user-local-bin)
    (add-to-list 'exec-path user-local-bin)
    (setenv "PATH" (concat user-local-bin ":" (getenv "PATH")))))

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
;; (use-package! go-mode :defer t) - Handled by Doom (go module)

;; Flycheck
;; (use-package! flycheck :ensure t) - Handled by Doom (syntax module)

;; LSP configuration
;; Handled by Doom (lsp module). Ensure (javascript +lsp) is in init.el if needed for JS.
;; (use-package! lsp-mode ...)

;; JS2 Mode for JavaScript
;; (use-package! js2-mode :defer t) - Handled by Doom (javascript module)

;; Node.js REPL
(use-package! nodejs-repl)

;; Company for autocompletion
;; (use-package! company :ensure t) - Handled by Doom (company module)

;; LSP Treemacs integration
(use-package! lsp-treemacs
  :after (lsp-mode treemacs))


;; DAP mode configuration
;; Note: dap-mode is provided by the :tools debugger module in init.el
(after! dap-mode
  ;; Enable auto-configuration features (dap-auto-configure-mode is deprecated)
  (setq dap-auto-configure-features '(sessions locals controls tooltip))

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
         :desc "Debug (select config)" "s" #'my/dap-debug-select)))


;; Projectile configuration - don't treat $HOME as project root
(after! projectile
  ;; Add .git back - it's needed for proper project detection
  ;; Instead, explicitly ignore home directory
  (add-to-list 'projectile-ignored-projects "~/")
  (add-to-list 'projectile-ignored-projects (expand-file-name "~/")))

;; Easy Hugo configuration
(setq easy-hugo-basedir "/Users/victory.osikwemhe/afro-marxist/"
      easy-hugo-url "http://localhost:1313"
      easy-hugo-root "/")

;; Claude Code IDE configuration
(use-package! claude-code-ide
  :config
  ;; Set Claude Code CLI path
  (setq claude-code-ide-cli-path (expand-file-name "~/.local/bin/claude"))

  ;; Disable debug mode for cleaner output (you can re-enable if needed)
  (setq claude-code-ide-cli-debug nil)

  ;; Add extra CLI flags
  (setq claude-code-ide-cli-extra-flags "--dangerously-skip-permissions")

  ;; Enable MCP server for full Emacs integration
  (setq claude-code-ide-enable-mcp-server t)

  ;; Setup Emacs MCP tools so Claude can use xref, project info, etc.
  (claude-code-ide-emacs-tools-setup)

  ;; Configure display settings for claude-code-ide window
  ;; This makes it appear at the bottom instead of the side
  (set-popup-rule! "^\\*claude-code-ide\\*"
    :side 'bottom
    :size 0.3
    :select nil
    :quit nil
    :ttl nil)

  ;; Auto-start claude-code-ide when Emacs starts
  (add-hook 'emacs-startup-hook
            (lambda ()
              (run-with-timer 1 nil
                              (lambda ()
                                (require 'claude-code-ide)
                                (claude-code-ide-mcp-start)))))

  ;; Custom keybindings under "c" (code) prefix
  (map! :leader
        (:prefix ("c" . "code")
         :desc "Start Claude Code" "C" #'claude-code-ide-mcp-start
         :desc "Stop Claude Code" "Q" #'claude-code-ide-mcp-stop
         :desc "Send region to Claude" "R" #'claude-code-ide-send-region)))

(after! lsp-mode
  (setq lsp-disabled-clients '(semgrep-ls))
  
  ;; CRITICAL: Disable lsp-mode's attempt to call dap-auto-configure-mode
  ;; This function is deprecated and causes errors
  (setq lsp-enable-dap-auto-configure nil)
  
  ;; CRITICAL: Prevent LSP from starting in home directory
  ;; Only start LSP in actual project directories (with go.mod, .git, etc.)
  (setq lsp-auto-guess-root t)
  (setq lsp-file-watch-threshold 5000)
  (setq lsp-enable-file-watchers nil)
  
  ;; IMPORTANT: Keep lsp-use-plists as t (Doom's default) for better performance
  ;; The hash-table errors are actually harmless warnings from gopls logging
  (setq lsp-use-plists t)
  
  ;; Suppress verbose log messages that trigger harmless errors
  (setq lsp-log-io nil)
  (setq lsp-print-io nil)
  
  ;; Increase timeouts to prevent shutdown issues with gopls
  (setq lsp-response-timeout 60)
  (setq lsp-idle-delay 0.5)
  (setq lsp-completion-provider :none) ; Use company-capf instead
  
  ;; Prevent gopls from being killed
  (setq lsp-restart 'auto-restart)
  (setq lsp-keep-workspace-alive t)
  
  ;; Wait for server to be fully initialized
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-signature-auto-activate t)
  (setq lsp-signature-render-documentation t)
  
  ;; Enable all LSP features
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-lens-enable nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable t)
  
  ;; Additional gopls-specific settings
  (lsp-register-custom-settings
   '(("gopls.completeUnimported" t t)
     ("gopls.staticcheck" t t)
     ("gopls.usePlaceholders" t t)
     ("gopls.analyses.unusedparams" t t)
     ("gopls.analyses.shadow" t t)))
  
  ;; Ensure gopls is properly configured
  (after! lsp-go
    (setq lsp-go-use-gofumpt t)
    (setq lsp-go-analyses '((shadow . t)
                            (simplifycompositelit . :json-false)))
    
    ;; Increase gopls memory limit if needed
    (setq lsp-go-env '((GOMEMLIMIT . "4GiB")))
    
    ;; CRITICAL: Use directory-local workspaces to prevent gopls from indexing entire home directory
    (setq lsp-auto-guess-root t)
    (setq lsp-enable-file-watchers nil) ; Disable file watchers to reduce memory usage
    
    ;; Gopls initialization options - removed debug server to reduce overhead
    (setq lsp-go-gopls-server-args nil)))

;; Ensure LSP and syntax highlighting work for all Go files
(after! go-mode
  ;; Make sure lsp-deferred is called for every go file
  (add-hook 'go-mode-hook #'lsp-deferred 90) ; Priority 90 to run after other hooks

  ;; Ensure syntax highlighting is always enabled
  (add-hook 'go-mode-hook (lambda ()
                            (font-lock-mode 1)
                            (font-lock-ensure)) 95))

;; Debug function to check mode state (you can call this with M-x check-go-mode-state)
(defun check-go-mode-state ()
  "Check the state of go-mode, lsp, and syntax highlighting."
  (interactive)
  (message "Major mode: %s | LSP: %s | Font-lock: %s | DAP: %s"
           major-mode
           (if (bound-and-true-p lsp-mode) "enabled" "disabled")
           (if font-lock-mode "enabled" "disabled")
           (if (bound-and-true-p dap-mode) "enabled" "disabled")))

;; Enable auto-revert mode to see file changes in real-time
;; This makes Emacs automatically reload files when they change on disk
(global-auto-revert-mode 1)
(setq auto-revert-interval 0.5)  ; Check every 0.5 seconds for faster updates
(setq auto-revert-verbose nil)   ; Don't show messages when reverting

;; Emacs MCP Server (rhblind/emacs-mcp-server) - allows Claude to interact with Emacs directly
(use-package! mcp-server
  :config
  ;; Optional: Set custom socket name (nil = default: emacs-mcp-server.sock)
  ;; Other options: 'user (user-based), 'session (session-based), or a custom string
  (setq mcp-server-socket-name nil)

  ;; Optional: Enable debug logging
  ;; (setq mcp-server-debug t)

  ;; Start the MCP server automatically on Emacs startup
  (add-hook 'emacs-startup-hook #'mcp-server-start-unix))

(setq ob-mermaid-cli-path "/opt/homebrew/bin/mmdc")
