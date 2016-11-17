---
title: "AMS 274 - GLM HW3"
author: Arthur Lui
date: "15 November, 2016"
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
    - \allowdisplaybreaks
    - \def\prodj{\prod_{j=1}^{m_i}}
    - \renewcommand{\arraystretch}{1.1}
    - \def\mess{\frac{\exp(\eta_i)}{1+\exp(\eta_i)}}
---

# Q1

### 1a Residual Analysis

The following table summarizes the root-mean-squared (RMS) deviance residuals for each model.

--------------------------------------
 Link          RMS deviance residuals
------------- ------------------------
logit           1.1849172

probit          1.1247087

cloglog         0.6563573
--------------------------------------

\begin{figure*}[h]
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/freqpreds.pdf}
    \caption{Predicted responses (probabilities) vs. observed probabilities of death.}
    \label{fig:freqpreds}
  \end{minipage}\hfill
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/freqcurves.pdf}
    \caption{Dose-response (probability) curves for each model.}
    \label{fig:freqcurves}
  \end{minipage}
\end{figure*}

## 1b 
The likelihood for the model under the link function in (1.1). 
$$
\L(\beta,\alpha;x,y) \propto \ds\prodl\bc\mess^{\alpha y_i}\bc{1-\p{\mess}^\alpha}^{m_i-y_i}
$$
$\alpha$ appears to be some tempering parameter. Large $\alpha$ values (much greater than 1)
will cause the $\pi_i$'s to approach zero; while $\alpha$ values between
0 and 1 will increase the value of each $\pi_i$. It seems that there will the
likelihood will very possibly be more multi-modal under this likelihood.

# Q2 

## Effect of Different Priors on $\beta$

To determine the effect of different prior specifications for $\beta$, I use
three different priors

1. prior$_1$: $\beta \sim \N_2\p{(100,100)',\I_2}$
2. prior$_2$: $\beta \sim \N_2\p{(100,100)',100\I_2}$
3. prior$_\text{flat}$: $p(\beta) \propto 1$

to compute the posterior distributions of $\beta$. Table 1 summarizes the posterior
distribution of the coefficients in Model I. As expected, if the prior information
is strong, the estimate for $\beta$ will tend towards the prior mean for $\beta$.
Using a flat prior, we get for the posterior mean for $\beta$ the MLE's for 
$\beta$ in the Frequentist approach.

\begin{table}[h]
\begin{center}\begin{tabular}{c|crrrrc}
\hline\hline
&& mean & sd & CI 2.5\% & CI 97.5\% \\
prior$_1$ &$\beta_{0}$&   20.7188&    0.7579&   19.2806&   22.3003&  *\\
prior$_1$ &$\beta_{1}$&  -11.7119&    0.4362&  -12.6069&  -10.8737&  *\\
\hline
prior$_2$ &$\beta_{0}$&  -32.2786&    2.4665&  -37.3058&  -27.5726&  *\\
prior$_2$ &$\beta_{1}$&   17.9937&    1.3694&   15.4037&   20.7082&  *\\
\hline
prior$_{\text{flat}}$ &$\beta_{0}$&  -40.1326&    3.3167&  -47.9426&  -34.4437&  *\\
prior$_{\text{flat}}$ &$\beta_{1}$&   22.3515&    1.8387&   19.1809&   26.6800&  *\\
\hline\hline
\end{tabular}\end{center}
\caption{Model I (cloglog link) posterior summary for $\beta$ under different prior specifications.}
\end{table}

\begin{table}[h]
\begin{center}\begin{tabular}{crrrrc}
\hline\hline
& mean & sd & CI 2.5\% & CI 97.5\% \\
$\beta_{0}$&  -61.4089&    5.1310&  -72.1061&  -52.4832&  *\\
$\beta_{1}$&   34.6613&    2.8807&   29.6913&   40.7012&  *\\
Acceptance $\beta$&    0.3620\\
\hline\hline
\end{tabular}\end{center}
\caption{Posterior summary for $\beta$ in Model II (logit link)}
\end{table}

\begin{table}[h]
\begin{center}\begin{tabular}{crrrrc}
\hline\hline
& mean & sd & CI 2.5\% & CI 97.5\% \\
$\beta_{0}$& -120.7671&   22.8567& -174.3189&  -88.7541&  *\\
$\beta_{1}$&   66.4101&   12.3813&   49.0810&   95.5481&  *\\
$\alpha$  &    0.2880&    0.0759&    0.1596&    0.4550&\\
Acceptance $\beta$&    0.3090\\
Acceptance $\alpha$&    0.2660\\
\hline\hline
\end{tabular}\end{center}
\caption{Posterior summary for $\beta$ and $\alpha$ in Model II (modified-logit link)}
\end{table}

# Comparing the models

Figure \ref{fig:curve} shows the dose-response curves (with response being the
probability of death) for each model. Empirically, we can determine how good
the models fit the data by examining how closely the curves pass through the
data (observed proportion of beetles that die at each observed dose). It is clear
that while all the curves follow the general trend of the data, the 
red (cloglog link) and blue (modified-logit link) curves fit the data best.
More formal tests are needed to determine whether if a particular model is
superior.

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/curve.pdf}
\caption{Posterior dose-response curve (response being probability of death) under the different models with 95\% credible intervals (shaded).}
\label{fig:curve}
\endmyfig

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/ld.pdf}
\caption{Posterior Lethal Doses (50\%) under different models with 95\% credible intervals (shaded).}
\label{fig:ld}
\endmyfig

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/resid.pdf}
\caption{Posterior root mean squared residuals under the different models (smaller is better). Note that the posterior probability that the root mean squared residuals under Model I (cloglog) is smaller than that of Model II (logit) is 95.6\%. Likewise, the probability that the root mean squared residuals under Model III (modified-logit) is smaller than that of Model II (logit) is 96\%. This indicates that Model II has a relatively poor fit compared to the other two models (in terms of root mean squared residuals). Note also that the probability that the root mean residuals under Model III is smaller than that of Model I is 66.8\%.}
\label{fig:resid}
\endmyfig

Table \ref{quadloss} shows the quadratic loss under each model; smaller losses are preferred. This quantity was computed as
$$
\L(\M_j) = \suml var^{\M_j}(z_i|data) + \frac{K}{K+1}\suml\bk{y_i-\E^{\M_j}\p{z_i|data}}^2
$$
where $\M_j$ represents model $j$, of $J$ models to compare, $y_i$ is the
observed response, $z_i$ are the replicate responses, and $n$ is the total
number of observations. Intuitively, this expression is the sum of a penalty
term for model complexity and a goodness-of-fit term. Consequently, choosing a
$K$ that is small penalizes models that are complex more heavily. Model III
(modified logit link) has the smallest loss, and so is preferred. Note that
here, $K$ was chosen to be 1000.

--------------------------------------
 Model (link)          Quadratic Loss
--------------------- ----------------
I (cloglog)             0.01397

II (logit)              0.02742

III (modified logit)    **0.01203**
--------------------------------------

Table: Quadratic loss under each model. Model III is superior to the other models. \label{quadloss}

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
