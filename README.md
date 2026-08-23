# aur-audit.el

AUR package auditor for Emacs. Review PKGBUILDs of your installed AUR
packages *before* you update them.

> Status: scaffold. The structure is here; the logic is yours to write.

## What it's meant to do

1. List installed AUR/foreign packages (`pacman -Qm`).
2. Fetch the current `PKGBUILD` from the AUR.
3. Diff it against what you last reviewed — read only what *changed*.
4. Flag suspicious patterns for a human to look at.

## Trying it out

```sh
# Load it in a throwaway Emacs and poke at functions:
emacs -Q -L . -l aur-audit.el

# Run the tests (they fail until you implement things — that's the point):
emacs -batch -L . -l aur-audit.el -l aur-audit-test.el \
      -f ert-run-tests-batch-and-exit
```

Inside Emacs, `M-x eval-buffer` then call a function with `M-x` or
evaluate a form with `C-x C-e`. `C-h f aur-audit-scan-string RET` shows
the docstring; `M-.` jumps to a definition.

## Suggested order to build it

Work bottom-up — pure functions first, I/O and UI last. Each has a
docstring in `aur-audit.el` describing its contract and a `TODO` naming
the Elisp to reach for.

1. `aur-audit-scan-string` — pure, no I/O, already has a failing test.
   Best place to start: make the two tests in `aur-audit-test.el` pass.
2. `aur-audit-pkgbuild-url` — pure string building.
3. `aur-audit-installed-packages` — first shell-out. Factor the *parsing*
   apart from the *shelling out* so you can unit-test the parser.
4. `aur-audit-fetch-pkgbuild` — network I/O; start synchronous.
5. `aur-audit` — the command that wires it together and shows a buffer.

## Elisp you'll meet along the way

- **`C-h` is your friend:** `C-h f` (function), `C-h v` (variable),
  `C-h k` (what does this key do). The docstrings are the manual.
- Shelling out: `process-lines`, `shell-command-to-string`.
- Strings: `split-string`, `string-match-p`, `format`.
- Buffers: `with-temp-buffer`, `insert`, `line-number-at-pos`.
- UI when you're ready: `special-mode`, `tabulated-list-mode`.
- The Emacs Lisp manual: `C-h i` → *Elisp*. The *Introduction to
  Programming in Emacs Lisp* (`C-h i` → *Emacs Lisp Intro*) is the
  gentler on-ramp.

## Conventions this scaffold follows (worth knowing)

- `-*- lexical-binding: t; -*-` on line 1 — always, in modern Elisp.
- Every symbol is namespaced with the `aur-audit-` prefix. Emacs has one
  global namespace; the prefix *is* your module boundary.
- Header comments (`Author`, `Version`, `Package-Requires`, …) are the
  package metadata `package.el` reads. `Commentary`/`Code` section
  markers and the closing `;;; file ends here` line are conventional and
  some linters enforce them.
- `;;;###autoload` marks the command that should be callable before the
  package is fully loaded.
