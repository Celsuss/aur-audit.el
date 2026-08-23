;;; aur-audit.el --- Audit AUR packages before updating  -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Jens Lorden

;; Author: Jens Lorden <jenslorden@proton.me>
;; Maintainer: Jens Lorden <jenslorden@proton.me>
;; URL: https://github.com/Celsuss/aur-audit.el
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1"))
;; Keywords: tools, unix, aur, security

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;;; Commentary:

;; aur-audit.el helps you review AUR packages *before* you update them.
;; The workflow it aims to support:
;;
;;   1. List the AUR (foreign) packages you have installed.
;;   2. Fetch the current PKGBUILD (and .install / .SRCINFO) from the AUR.
;;   3. Diff it against what you last reviewed, so you only read what CHANGED.
;;   4. Scan for suspicious patterns (curl|sh, obfuscation, new sources, ...).
;;
;; This file is a SCAFFOLD.  The function bodies are intentionally left as
;; exercises — each has a docstring describing its contract and a TODO
;; pointing at the Elisp you'll want to learn.  See README.md for a
;; suggested order to tackle them in.

;;; Code:

;;;; Customization

(defgroup aur-audit nil
  "Audit AUR packages before updating."
  :group 'tools
  :prefix "aur-audit-")

(defcustom aur-audit-rpc-url "https://aur.archlinux.org"
  "Base URL of the AUR instance to query."
  :type 'string
  :group 'aur-audit)

;; TODO Look for sudo
(defcustom aur-audit-suspicious-patterns
  '("curl[^|]*|[^|]*sh"            ; piping a download straight into a shell
    "wget[^|]*|[^|]*sh"
    "base64[[:space:]]+-d"          ; decoding blobs
    "eval[[:space:]]"               ; eval of dynamic content
    "chmod[[:space:]]+[0-7]*7[0-7]*") ; world-writable / suid-ish bits
  "Regexps that flag a PKGBUILD line as worth a human look.
These are heuristics, not a verdict — every match needs your eyes."
  :type '(repeat regexp)
  :group 'aur-audit)

;;;; Discovering installed AUR packages

(defun aur-audit-installed-packages ()
  "Return a list of installed foreign (AUR) packages.

Each element should be something you can act on later — start with a
list of package-name strings, and consider upgrading to a richer
structure (name + installed version) once that feels comfortable.

TODO: shell out to `pacman -Qm' and parse the output.
  - Look at `process-lines' (runs a command, returns its stdout as a
    list of lines).  It signals on non-zero exit, which is often what
    you want.
  - Each line is \"NAME VERSION\"; `split-string' will break it apart."
  (error "aur-audit-installed-packages: not implemented yet"))

;;;; Fetching PKGBUILDs from the AUR

(defun aur-audit-pkgbuild-url (package)
  "Return the raw PKGBUILD URL for PACKAGE on the configured AUR.

TODO: the AUR serves raw files from its cgit frontend, e.g.
  https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=PACKAGE
Build that string from `aur-audit-rpc-url' and PACKAGE.  Look at
`format' and `url-hexify-string' (package names are usually safe, but
hexifying is the correct habit)."
  (error "aur-audit-pkgbuild-url: not implemented yet"))

(defun aur-audit-fetch-pkgbuild (package)
  "Fetch and return the PKGBUILD text for PACKAGE as a string.

TODO: two roads here, pick one to learn:
  - Synchronous & simple: `url-retrieve-synchronously' + strip the
    HTTP headers (everything up to the first blank line).
  - Or shell out to curl via `shell-command-to-string'.
Start synchronous; make it async later once the rest works."
  (error "aur-audit-fetch-pkgbuild: not implemented yet"))

;;;; Scanning

(defun aur-audit-scan-string (text)
  "Scan TEXT (a PKGBUILD) and return a list of findings.

A finding should carry enough to show the user: at least the line
number, the matched line, and which pattern tripped.  A list of plists
or a small `cl-defstruct' both work — try a plist first.

TODO:
  - Iterate lines: `with-temp-buffer', insert TEXT, then walk with
    `forward-line' / `line-number-at-pos', or split on newlines.
  - For each line, test it against every regexp in
    `aur-audit-suspicious-patterns' using `string-match-p'."
  (error "aur-audit-scan-string: not implemented yet"))

;;;; Buffer UI functions
(defun aur-audit-open-buffer ()
  "Opens up a buffer for the audit"
  (let ((buf (get-buffer-create "aur-audit")))
    (switch-to-buffer buf))))

;;;; User-facing command

;;;###autoload
(defun aur-audit ()
  "Entry point: audit installed AUR packages before an update.

TODO: this is where it all comes together.  A good first version can
just pop a buffer and, for each installed package, fetch the PKGBUILD
and list the findings.  Once that works, graduate to a real UI:
  - `tabulated-list-mode' for a package list you can act on, or
  - a dedicated major mode deriving from `special-mode' (read-only,
    q-to-quit for free)."
  (interactive)
  (aur-audit-open-buffer))

(provide 'aur-audit)
;;; aur-audit.el ends here
