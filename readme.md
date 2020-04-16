# Tips on writing biology manuscripts in LaTeX

1. Compress figure PDFs ([in Preview on Mac](https://support.apple.com/guide/preview/compress-a-pdf-prvw1509/mac)) to speed up compilation.

2. Create a supplementary information section where the numbering of all tables and figures has an "S" prefix:
```
\setcounter{table}{0}
\renewcommand{\thetable}{S\arabic{table}}
\setcounter{figure}{0}
\renewcommand{\thefigure}{S\arabic{figure}}
```

3. Use the [textgreek](https://ctan.org/pkg/textgreek) package for upright greek letters in text.

4. Follow specific font setting rules in chemistry:
```
\textsc{l}-glutamine
% use small capital L and D as chirality prefixes

puromycin \textit{N}-acetyltransferase
% use italic chemical element symbols in names
```

5. [BibLaTeX](https://ctan.org/pkg/biblatex) option setting: `\usepackage[backend=biber,sortcites,sorting=none,uniquename=false]{biblatex}`. The `sortcites` option enables sorting of numbers associated with multiple citations within a single citing bracket. The `sorting=none` option assigns number to citations based on the order in which they appear in the text. The `uniquename=false` option guarantees that authors are referred to their last names only (when a citation is referred not by a number but rather a name-year pair in the text), even if multiple authors in the list of all citations share the same last name.
