---
title: "Carpe Datum"
subtitle: "Data Science for Life's Big Questions"
author: "Yoav Bergner"
output: 
  bookdown::pdf_book:
    toc: False
    keep_tex: yes
    includes:
      in_header: preamble.tex
#      before_body: doc-prefix.tex
always_allow_html: true
urlcolor: blue
classoption: openany
github-repo: ybergner/carpe-datum
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
site: bookdown::bookdown_site
documentclass: book
---







# Preface {-}


> "[T]he most important questions of life are for the most part only problems of probability. It may even be said, strictly speaking, that almost all our knowledge is only probabilistic."
>
> --- Pierre-Simon Laplace

## Caveat {-}

This book is an incomplete draft of a work in progress being developed as lecture notes for an online course. Content is provisional, contingent, and possibly wrong, but always well intended.

## Guiding principles in this book {-}

### Question-driven {-}

Because the presentation of topics in this book is question-driven rather than method-driven, this coursebook has some idiosyncracies. Some topics that might be considered rather basic may be omitted, while some topics that are typically considered as advanced will get (a simplified) treatment.

### No proofs {-}

As a mathematical subject, statistics is often taught with derivation and proof using definitions, simple assumptions, and the logic of algebra and calculus. Mathematical formulas are the standard language of statistics. This approach to learning is powerful if the math supports rather than gets in the way of understanding. However, for many learners, the math obscures rather than clarifies, and another way--using demonstrations and simulations--might enable understanding, as Johnson & Johnson once said, without tears.

Now, a demonstration is not a proof. That said, repeated experiments can be convincing even in the absence of proof. For example, I can prove to you that if you take any whole number (e.g., 1, 2, 3, 7, 21, 118, 8675309), multiply it by 9, and then sum the individual digits of that resulting product, that the sum itself will be a multiple of 9 

``` 
Example: 
7 * 9 = 63; 6 + 3 = 9.
21 * 9 = 189; 1 + 8 + 9 = 18. 

```

An elegant and simple proof can be constructed (hint: by induction), but if you try it out yourself enough times, you won't *need* the proof to be convinced. Twice, by the way, might not be enough. You could, however, write a computer program to test this equality a thousand times using a thousand random whole numbers. This is sometimes called a computer simulation.

Now problems like this one are often used to teach proof technique rather than to encode cute number-facts in memory. And indeed, for training statisticians, a rigorous mathematical presentation is important. So, for that matter, is computer simulation. For most users of this book, intuition and understanding are the priority, and the ability to derive formulas is not necessary. We will, in due course, bring out some computer simulations.

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/existence_proof_2x} 

}

\caption{Hopefully you are in the right place. Credit   [xkcd.com](https://xkcd.com/1856/)}(\#fig:xkcd-preamble)
\end{figure}
