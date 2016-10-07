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
    - \usepackage{xifthen}
    - \pagestyle{empty}
    - \newcommand{\norm}[1]{\left\lVert#1\right\rVert}
    - \newcommand{\p}[1]{\left(#1\right)}
    - \newcommand{\bk}[1]{\left[#1\right]}
    - \newcommand{\bc}[1]{ \{#1\} }
    - \newcommand{\abs}[1]{ \left|#1\right| }
    - \newcommand{\mat}{ \begin{pmatrix} }
    - \newcommand{\tam}{ \end{pmatrix} }
    - \newcommand{\suml}{ \sum_{i=1}^n }
    - \newcommand{\prodl}{ \prod_{i=1}^n }
    - \newcommand{\ds}{ \displaystyle }
    - \newcommand{\df}[2]{ \frac{d#1}{d#2} }
    - \newcommand{\ddf}[2]{ \frac{d^2#1}{d{#2}^2} }
    - \newcommand{\pd}[2]{ \frac{\partial#1}{\partial#2} }
    - \newcommand{\pdd}[2]{ \frac{\partial^2#1}{\partial{#2}^2} }
    - \newcommand{\N}{ \mathcal{N} }
    - \newcommand{\E}{ \text{E} }
---

# 3a

$$
\newcommand{\cauchyi}{\bk{\pi\bc{1+(y_i-\theta)^2}}^{-1}}
\begin{array}{rcl}
f(y_i|\theta) &=& \cauchyi, ~~~y_i,\theta\in\mathbb{R};~ i=1,...,n \\
\\
\mathcal{L}(\theta|y) &=& \ds\prodl \cauchyi \\
\\
l(\theta|y) &=& \log \mathcal{L}(\theta|y) = \log\ds\prodl\cauchyi\\\
            &=& -\suml\log \bk{\pi\bc{1+(y_i-\theta)^2}}\\
            &=& -\suml\log \bk{\bc{1+(y_i-\theta)^2}} - n\log\pi\\
\end{array}
$$

For the Newton-Raphson method:
$$
\begin{array}{rcl}
\ds\df{l}{\theta} &=& \ds\suml\frac{2(y_i-\theta)}{1+(y_i-\theta)^2}\\
\\
\ds\ddf{l}{\theta} &=& \ds\suml\frac{2\bc{(y_i-\theta)^2-1}}{\bk{1+(y_i-\theta)^2}^2}\\
\end{array}
$$

For the Scoring method:
$$
\begin{split}
J(\theta) &= -\E_Y\bk{\ds\ddf{l}{\theta}}\\
          &= -\E_Y\bk{ \ds\suml\frac{2\bc{(Y_i-\theta)^2-1}}{\bk{1+(Y_i-\theta)^2}^2} }\\
          &= 2n\E_Y\bk{ \ds\frac{\bc{1-(Y-\theta)^2}}{\bk{1+(Y-\theta)^2}^2} }\\
\end{split}
$$

$$
\begin{split}
          &= 2n\ds\int_{-\infty}^\infty \bk{\pi\bc{1+(y-\theta)^2}}^{-1}
               \ds\frac{1-(y-\theta)^2}{\bk{1+(y-\theta)^2}^2} dy\\
          &= \ds\frac{2n}{\pi}\ds\int_{-\infty}^\infty 
             \ds\frac{1-(y-\theta)^2}{\bk{1+(y-\theta)^2}^3} dy\\
          &= \ds\frac{2n}{\pi}\ds\int_{-\infty}^\infty 
             \ds\frac{1-(y-\theta)^2}{\bk{1+(y-\theta)^2}^3} d(y-\theta)\\
          &= \ds\frac{2n}{\pi}\ds\int_{-\infty}^\infty 
             \ds\frac{1-x^2}{\bk{1+x^2}^3} dx\\
          &= \ds\frac{4n}{\pi}\ds\int_{0}^\infty 
             \ds\frac{1-x^2}{\bk{1+x^2}^3} dx ~~~(\because \text{the function is even})\\
          &= \ds\frac{4n}{\pi}\frac{\pi}{8} \\
          &= \ds\frac{n}{2} \\
          \\
          \therefore J(\theta) &= \ds\frac{n}{2}\\
\end{split}
$$

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
| Scoring Method | 0.179    |                 8 | 0              | $10^{-4}$ |

> ![Log-likelihoods for parts 3b (left) and 3c (right).\label{loglikes}](../img/sim.pdf){ height=40% }

# 3c

Again, applying both the newton-raphson and scoring methods, and having 
initialized the algorithms at different starting values, $\theta$ was
estimated to be **5.047**. Table \ref{table3c} summarizes the results
and parameter settings for the algorithms. Note that in all cases, the scoring
method converged much faster. But the scoring method yielded estimates
that did not correspond to the global max in 2 cases, whereas the Newton-raphson
method yielded estimates that were not at the global max in 1 case.

Table: Estimates from Newton-Raphson and Scoring Method \label{table3c}

| Method         | Estimate | Steps to Converge | Initial Values | Tolerance |
|:--------------:|:--------:| -----------------:|:--------------:|:---------:| 
| Newton-Raphson | 5.047    |             73242 | -1              | $10^{-4}$ |
| Scoring Method | 0.362    |                 7 | -1              | $10^{-4}$ |
| -------------- | -------- | ----------------- | -------------- | --------- | 
| Newton-Raphson | 7.562    |             22555 | 4.67           | $10^{-4}$ |
| Scoring Method | 5.047    |                 6 | 4.67           | $10^{-4}$ |
| -------------- | -------- | ----------------- | -------------- | --------- | 
| Newton-Raphson | 5.047    |             46526 | 10             | $10^{-4}$ |
| Scoring Method | 8.546    |                 7 | 10             | $10^{-4}$ |


# 4

The scoring method converged in 107 iterations to the estimates (0.995998,
1.32661). The estimates from the `glm` function in `R` were (0.996,1.327).



[//]: # (This is a comment)
