# AUSRA_Thesis

The repository allocated for our thesis material and compilation. This repository contains the LaTeX source code, figures, and formatting files required to build the final AUSRA Graduation Project Thesis PDF.

---

## 🛠️ Required Software & Packages

To compile the LaTeX source code locally on Ubuntu/Linux, you must install a TeX distribution (like TeX Live) and a few essential dependencies.

### 1. Install TeX Live (Full)
The full version includes all necessary fonts, packages (like `biblatex`, `biber`, `tikz`), and compilation engines (`pdflatex`, `lualatex`, `xelatex`).

```bash
sudo apt update
sudo apt install texlive-full
```
*(Note: `texlive-full` is quite large (~5GB+). If space is an issue, you can install `texlive-base`, `texlive-latex-extra`, `texlive-science`, and `biber` instead, but you might need to manually install missing `.sty` packages later).*

### 2. Suggested Editors
While you can compile via terminal, using a dedicated editor helps with finding syntax errors and auto-compiling:
*   **VS Code**: Install the **LaTeX Workshop** extension.
*   **TeXstudio**: `sudo apt install texstudio`
*   **Overleaf**: You can also upload this entire directory as a `.zip` to Overleaf for cloud-based editing.

---

## 🚀 How to Compile and Generate the PDF

The main document is `main.tex`. It uses `biber` for bibliography management.

### Compiling via Terminal (Standard Method)

To generate the PDF (`main.pdf`), you must run the LaTeX engine, then the bibliography engine, and then the LaTeX engine again to resolve all cross-references.

Run these commands inside the `AUSRA_Thesis` directory:

```bash
# 1. First Pass: Generates .aux files needed for bibliography
pdflatex main.tex

# 2. Bibliography Pass: Processes references
biber main

# 3. Second Pass: Injects references
pdflatex main.tex

# 4. Final Pass: Resolves Table of Contents and page numbers
pdflatex main.tex
```

If successful, a `main.pdf` file will be generated in the directory.

### Compiling via `latexmk` (Recommended)
`latexmk` is a script that automatically runs the necessary sequence of commands (pdflatex, biber, pdflatex) the correct number of times:

```bash
latexmk -pdf main.tex
```

---

## 🐛 Debugging LaTeX Errors

LaTeX errors can be cryptic. If compilation fails (usually signified by an emergency stop `!` in the terminal), here is how to debug:

1.  **Check `main.log`**: The generated `main.log` file contains detailed error messages. Search the log for `! ` or `Error` to find the exact line causing the issue.
2.  **Missing Packages (`File 'xyz.sty' not found`)**: You have a `\usepackage{xyz}` but the package isn't installed. Fix by installing `texlive-full` or locating the package via `apt search texlive`.
3.  **Bibliography Errors**: If citations show up as `[?]`, ensure you successfully ran the `biber main` command. Check `main.blg` for biber-specific syntax errors in your `.bib` files.
4.  **Cleaning Up Bad Builds**: Sometimes auxiliary files get corrupted. If compiling inexplicably fails, delete the generated files and try again:
    ```bash
    # Run this to clean up the directory
    rm -f *.aux *.bbl *.bcf *.blg *.glo *.ist *.lof *.log *.lot *.out *.run.xml *.toc *.acn
    ```
5.  **Image Not Found**: Ensure the paths in `\includegraphics{}` are correct and the images exist in the `figures/` directory. Use the provided `check_image_size.py` script to ensure images aren't too large, which can cause memory issues during compilation.
