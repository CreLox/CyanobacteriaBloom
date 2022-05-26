# Tips on writing biology manuscripts in LaTeX on Overleaf

1. Compress figure PDFs ([in Preview on Mac](https://support.apple.com/guide/preview/compress-a-pdf-prvw1509/mac)) to speed up compilation. However, this method **severely** reduces the image quality and should never be used in the final edition.

2. Create a supplementary information section where the numbering of all [tables](https://www.latex-tables.com/) and figures has an "S" prefix:
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

6. Utilize the `siunit` package for all quantities. Set up digit grouping by including the line `\sisetup{group-digits=integer,group-separator={,}}` in the preamble. Use absolute units instead of relative units when possible (this applies to experiment notes in general). For example, use 18,200 g instead of 15,000 rpm, and use 40 nM instead of 40 pmole/well.

7. By default, LaTeX enables ligature. I have tested that without specification of encoding, copying from an Overleaf output PDF opened by Acrobat Reader on Windows leads to misinterpretation of "filter" (with the "fi" ligature), resulting in "__lter" after pasting. The solution is adding the following lines to the preamble [as suggested](https://tex.stackexchange.com/questions/64188/what-are-good-ways-to-make-pdflatex-output-copy-and-pasteable):
   ```TeX
   \input{glyphtounicode}
   \pdfgentounicode=1
   ```

8. Use `\frenchspacing`, which has been commonly accepted as of now (see [the Wikipedia entry on sentence spacing](https://en.wikipedia.org/wiki/Sentence_spacing)).

9. To export in PDF/A-1b (see section 2.1.1 of the [manual](https://mirror.las.iastate.edu/tex-archive/macros/latex/contrib/pdfx/pdfx.pdf) of the `pdfx` package), include the following in the preamble. Note that doing this does NOT guarantee that the generated PDF file conforms to the standard. Use the Prefight tool in Adobe Acrobat Pro DC for a compliance check.
   ```TeX
   \begin{filecontents*}{\jobname.xmpdata} % do not change the ``\jogname'' here
      ... % add metadata
   \end{filecontents*}
   \RequirePackage[a-1b]{pdfx}
   ```

# Resources
1. [A UMich thesis LaTeX template (1988-current) hosted on Overleaf](https://www.overleaf.com/latex/templates/university-of-michigan-dissertation-template-unofficial/tpnjzndnrzmf). Contact its.software@umich.edu to acquire an Overleaf Professional License. Note that as the author of an Elsevier article, you retain the right to include it in a thesis or dissertation, provided it is not published commercially. Permission is not required, but please ensure that you reference the journal as the original source.

2. [Zotero with Better BibTeX](https://www.zotero.org/).

3. Title case [standard](https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case).

4. List of LaTeX templates for peer-reviewed journals: [Annual Reviews](https://www.overleaf.com/gallery/tagged/ar)
