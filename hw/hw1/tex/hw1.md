---
title: "AMS 274 - GLM HW 1"
author: Arthur Lui
date: "9 September, 2016"
geometry: margin=1in
fontsize: 12pt

# Uncomment if using natbib:

# bibliography: BIB.bib
# bibliographystyle: plain 

# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html)

header-includes: 
    - \usepackage{bm}
    - \usepackage{bbm}
    - \pagestyle{empty}
    - \newcommand{\norm}[1]{\left\lVert#1\right\rVert}
    - \newcommand{\p}[1]{\left(#1\right)}
    - \newcommand{\bk}[1]{\left[#1\right]}
    - \newcommand{\bc}[1]{ \{#1\} }
    - \newcommand{\abs}[1]{ \left|#1\right| }
    - \newcommand{\mat}{ \begin{pmatrix} }
    - \newcommand{\tam}{ \end{pmatrix} }
---

# 3b

Having applied both the newton-raphson method and scoring method, and
initialized the algorithms at various starting values, I have estimated
$\theta$ to be **0.179**. Figure \ref{loglikes} (left) shows the log-likelihood
functions for $\theta$, which is unimodal. Table \ref{table3b} summarizes
the parameter settings for the algorithms.

Table: Estimates from Newton-Raphson and Scoring Method \label{table3b}

| Method         | Estimate | Steps to Converge | Initial Values | Tolerance |
|:--------------:|:--------:| -----------------:|:--------------:|:---------:| 
| Newton-Raphson | 0.179    |             99880 | 0              | $10^{-4}$ |
| Scoring Method | 0.179    |            352169 | 0              | $10^{-4}$ |

> ![Log-likelihoods for parts 3b (left) and 3c (right).\label{loglikes}](../img/sim.pdf){ height=40% }

# 3c

Again, applying both the newton-raphson and scoring methods, and having 
initialized the algorithms at different starting values, $\theta$ was
estimated to be **5.047**. Table \ref{table3c} summarizes the results
and parameter settings for the algorithms. Note that in two cases,
the scoring method converged faster. In the other case, the newton-raphson
converged to the wrong location (though in fewer steps). It appears that
the scoring method should be preferred for this problem.


Table: Estimates from Newton-Raphson and Scoring Method \label{table3c}

| Method         | Estimate | Steps to Converge | Initial Values | Tolerance |
|:--------------:|:--------:| -----------------:|:--------------:|:---------:| 
| Newton-Raphson | 5.047    |             73242 | -1              | $10^{-4}$ |
| Scoring Method | 5.047    |             24532 | -1              | $10^{-4}$ |
| -------------- | -------- | ----------------- | -------------- | --------- | 
| Newton-Raphson | 7.562    |             22555 | 4.67           | $10^{-4}$ |
| Scoring Method | 5.047    |            178254 | 4.67           | $10^{-4}$ |
| -------------- | -------- | ----------------- | -------------- | --------- | 
| Newton-Raphson | 5.047    |             46526 | 10             | $10^{-4}$ |
| Scoring Method | 5.047    |              1450 | 10             | $10^{-4}$ |


# 4

The scoring method converged in 107 iterations to the estimates (0.995998,
1.32661). The estimates from the `glm` function in `R` were (0.996,1.327).



[//]: # (This is a comment)
