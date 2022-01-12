# Tips on writing biology manuscripts in LaTeX

1. Compress figure PDFs ([in Preview on Mac](https://support.apple.com/guide/preview/compress-a-pdf-prvw1509/mac)) to speed up compilation.

2. Create a supplementary information section where the numbering of all tables and figures has an "S" prefix:
   ```TeX
   \setcounter{table}{0}
   \renewcommand{\thetable}{S\arabic{table}}
   \setcounter{figure}{0}
   \renewcommand{\thefigure}{S\arabic{figure}}
   ```

3. Use the [textgreek](https://ctan.org/pkg/textgreek) package for upright greek letters in text.

4. Follow specific font setting rules in chemistry:
   ```TeX
   \textsc{l}-glutamine
   % use small capital L and D as chirality prefixes
   
   puromycin \textit{N}-acetyltransferase
   % use italic chemical element symbols in names
   ```

5. [BibLaTeX](https://ctan.org/pkg/biblatex) option setting: `\usepackage[backend=biber,sortcites,sorting=none,uniquename=false]{biblatex}`. The `sortcites` option enables sorting of numbers associated with multiple citations within a single citing bracket. The `sorting=none` option assigns number to citations based on the order in which they appear in the text. The `uniquename=false` option guarantees that authors are referred to their last names only (when a citation is referred not by a number but rather a name-year pair in the text), even if multiple authors in the list of all citations share the same last name.

6. Use absolute units instead of relative units when possible (this applies to experiment notes in general). For example, use 18,200 g instead of 15,000 rpm, and use 40 nM instead of 40 pmole/well. Even you may not remember what centrifuge or dish size you used after a while.

7. By default, LaTeX enables ligature. I have tested that without specification of encoding, copying from an Overleaf output PDF opened by Acrobat Reader on Windows leads to misinterpretation of "filter" (with the "fi" ligature), resulting in "__lter" after pasting. The solution is adding the following lines to the preamble [as suggested](https://tex.stackexchange.com/questions/64188/what-are-good-ways-to-make-pdflatex-output-copy-and-pasteable):
   ```TeX
   \input{glyphtounicode}
   \pdfgentounicode=1
   ```

# Resources
1. [An AAEL library workshop](https://ttc.iss.lsa.umich.edu/ttc/sessions/take-command-of-your-dissertation-with-latex/) organized by the University of Michigan Library.
