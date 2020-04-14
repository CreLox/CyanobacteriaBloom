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
% use small capital L/D as chirality prefixes

puromycin \textit{N}-acetyltransferase
% use italic chemical element symbol in a name
```

