---
title: "AMS 274 - GLM HW5"
author: Arthur Lui
date: "06 December, 2016"
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
    - \usepackage{graphicx}
    - \pagestyle{empty}
    - \newcommand{\norm}[1]{\left\lVert#1\right\rVert}
    - \newcommand{\p}[1]{\left(#1\right)}
    - \newcommand{\bk}[1]{\left[#1\right]}
    - \newcommand{\bc}[1]{ \left\{#1\right\} }
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
    - \renewcommand{\G}{ \text{Gamma} }
    - \newcommand{\E}{ \text{E} }
    - \newcommand{\zero}{ \mathbf{0} }
    - \newcommand{\I}{ \mathbf{I} }
    - \renewcommand{\L}{ \mathcal{L} }
    - \newcommand{\M}{ \mathcal{M} }
    - \def\given{~\bigg|~}
    # Figures in correct place
    - \usepackage{float}
    - \def\beginmyfig{\begin{figure}[H]\center}
    - \def\endmyfig{\end{figure}}
    - \newcommand{\iid}{\overset{iid}{\sim}}
    - \newcommand{\ind}{\overset{ind}{\sim}}
    # 
    - \renewcommand{\arraystretch}{1.1}
    - \def\gii{g^{-1}(x_i'\hat\beta)}
---

# Bayesian Poisson GLM 

A Bayesian Poisson GLM was fit to the data provided. Figure \ref{fig:betaA}
summarize the posterior distributions of the covariate parameters under
a flat prior.

\begin{figure*}[h]
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/betaA.pdf}
    \caption{Posterior distribution for covariates under Poisson GLM.}
    \label{fig:betaA}
  \end{minipage}\hfill
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/betaB.pdf}
    \caption{Posterior distribution for covariates under 
    \textbf{hierarchical} Poisson GLM.}
    \label{fig:betaB}
  \end{minipage}
\end{figure*}

Figure \ref{fig:predA} shows the posterior of the response mean as a function
of the covariate. The blue curve is the mean response mean, the blue region
is the 95% equal-tailed credible interval. The grey points are observations.
The model appears to fit the data well.

\begin{figure*}[h]
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/predA.pdf}
    \caption{Posterior distribution of mean response under Poisson GLM}
    \label{fig:predA}
  \end{minipage}\hfill
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/predB.pdf}
    \caption{Posterior distribution of mean response under 
    \textbf{hierarchical} Poisson GLM}
    \label{fig:predB}
  \end{minipage}
\end{figure*}

Figure \ref{fig:residA} shows the posterior predictive residuals under
the Bayesian Poisson GLM. The residuals seems to be evenly distributed above
and below zero. 
\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/residA.pdf}
\caption{Posterior predictive Residuals under Bayesian Poisson GLM}
\label{fig:residA}
\endmyfig


# Bayesian Poisson Hierarchical GLM

Under the Bayesian Poisson Hierarchical GLM, it can be shown that
$Y_i | \bm\beta, \lambda$ follows a negative binomial distribution:

FIXME
First the p.m.f. for $Y_i | \bm\beta, \lambda$ is 


\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/lambda.pdf}
\caption{Posterior distribution for $\lambda$ parameter in hierarchical Poisson
GLM}
\label{fig:lambda}
\endmyfig


## Sensitivity Analysis for $\lambda$
\begin{figure*}
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/sensitivityMean.pdf}
    \caption{some caption}
    \label{fig:myLabel1}
  \end{minipage}\hfill
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/sensitivitySD.pdf}
    \caption{some caption}
    \label{fig:myLabel2}
  \end{minipage}
\end{figure*}






[//]: # (Footnotes:)

[//]: # ( example image embedding
\beginmyfig
\includegraphics[height=0.5\textwidth]{path/to/img/img.pdf}
\caption{some caption}
\label{fig:mylabel}
% reference by: \ref{fig:mylabel}
\endmyfig
)
[//]: # ( example image embedding
> ![some caption.\label{mylabel}](path/to/img/img.pdf){ height=70% }
)

[//]: # ( example two figs side-by-side
\begin{figure*}
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{img1.pdf}
    \caption{some caption}
    \label{fig:myLabel1}
  \end{minipage}\hfill
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{img2.pdf}
    \caption{some caption}
    \label{fig:myLabel2}
  \end{minipage}
\end{figure*}
)
