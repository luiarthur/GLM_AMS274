---
title: "AMS 274 - GLM HW4"
author: Arthur Lui
date: "29 November, 2016"
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

# 1a)

Let $\rho_j = \ds\frac{\pi_j}{\pi_j +...+ \pi_J}$. Also, let $f(y|m,\rho)$ be the probability mass function for the binomial distribution. Finally, let $\bm y_i = (y_{i1},y_{i2},y_{i3})$ Then, 

\begin{align*}
f(y_{i1}|m,\rho_1) \times f(y_{i2}|m-y_{i1},\rho_2) =&
\frac{m!}{y_{i1}!(m-y_{i1})!} ~ \rho_1^{y_{i1}} (1-\rho_1)^{m-y_{i1}}  \times \\
&\frac{(m-y_{i1})!}{y_{i2}!(m-y_{i1}-y_{i2})!} ~ \rho_2^{y_{i2}} (1-\rho_2)^{m-y_{i1}-y_{i2}} \\
\\
=&\frac{m!}{y_{i1}!y_{i2}!y_{i3}!}\pi_1^{y_{i1}}(1-\pi_1)^{m-y_{i1}} \times
\p{\frac{\pi_2}{\pi_2+\pi_3}}^{y_{i2}}\p{\frac{\pi_3}{\pi_2+\pi_3}}^{m-y_{i1}-y_{i2}}\\
=&\frac{m!}{y_{i1}!y_{i2}!y_{i3}!}\pi_1^{y_{i1}}(\pi_2+\pi_3)^{m-y_{i1}} \times
\p{\frac{\pi_2}{\pi_2+\pi_3}}^{y_{i2}}\p{\frac{\pi_3}{\pi_2+\pi_3}}^{m-y_{i1}-y_{i2}} \\
=&\frac{m!}{y_{i1}!y_{i2}!y_{i3}!}\pi_1^{y_{i1}}\pi_2^{y_{i2}}\pi_3^{y_{i3}}(\pi_2+\pi_3)^{m-y_{i1}-y_{i2}-m+y_{i1}+y_{i2}}\\
=&\frac{m!}{y_{i1}!y_{i2}!y_{i3}!}\pi_1^{y_{i1}}\pi_2^{y_{i2}}\pi_3^{y_{i3}}\\
\end{align*}

which is the p.m.f for the multinomial distribution. Therefore, the
continuous-ratio logits model model can be fit by fitting independent 
binomial GLMs.

\newpage

# 1b)
Table \ref{tab:hi} shows the MLE and corresponding standard error for
the parameters in the continuous-ratio logits model. 

----------------------------------------
 Parameter         Estimate         SE
-----------       ---------  --------- -
$\alpha_1$         -3.2480      0.1577

$\alpha_2$         -5.7019      0.3322

$\beta_1$           0.0063      0.0004

$\beta_2$           0.0174      0.0012
----------------------------------------

Table: MLE for Continuous-Ratio Logits model \label{tab:hi}

Figure \ref{fig:freqPred} shows the estimated response curves $\hat\pi_j(x)$, for
$j=1,2,3$. It appears that as the concentration of diethylene glycol dimethyl
ether increases, the proportion of normal mice decreases. Similarly, 
the proportion of malformed and dead mice increased with concentration.

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/freqPred.pdf}
\caption{$\hat\pi_j(x)$ for $j=1,2,3$ which corresponds to the three groups (dead, malformed, normal).}
\label{fig:freqPred}
\endmyfig

\newpage

# 1c)
The prior distributions used for the covariates ($\alpha_j,\beta_j$) was chosen
to be $\N_2(\bm 0_2,100\bm I_2)$ for $j=1,2$. To reflect prior uncertainty 
in the parameters. To simulate from the joint posterior, a metropolis within
Gibbs sampler was implemented. As shown in 1a), the continuation-ratio logits
model can be decomposed into into independent binomial models. So, two
separate MCMC's (with Binomial likelihoods and logit links) were implemented to
obtain the posterior distributions of $(\alpha_1,\beta_1)$ and
$(\alpha_2,\beta_2)$.

The following table summarizes the posterior distribution for
$(\alpha_1,\alpha_2,\beta_1,\beta_2)$:

\begin{center}\begin{tabular}{crrrrc}
\\
& Mean & SD & CI 2.5\% & CI 97.5\% \\
$\alpha_{1}$&   -3.2554&    0.1504&   -3.5515&   -2.9696&  *\\
$\alpha_{2}$&   -5.7636&    0.3437&   -6.5308&   -5.1614&  *\\
$\beta_{1}$&    0.0064&    0.0004&    0.0055&    0.0073&  *\\
$\beta_{2}$&    0.0176&    0.0013&    0.0155&    0.0206&  *\\
\hline\\
Acceptance $(\alpha_1,\beta_1)$&    0.3055\\
Acceptance $(\alpha_2,\beta_2)$&    0.2985\\
\\
\end{tabular}\end{center}

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/bayesPred.pdf}
\caption{$\hat\pi_j(x)$ for $j=1,2,3$ which corresponds to the three groups (dead, malformed, normal).}
\label{fig:bayesPred}
\endmyfig

\newpage

# 2)

The priors chosen for $\alpha_j,\beta_j$ were flat priors. This is to reflect
the prior uncertainty of the value of the parameters.

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/gator1.pdf}
\caption{$\hat\pi_j(x)$ for $j=1,2,3$ which corresponds to the three food choices (invertebrate, other, fish) across both males and females.}
\label{fig:gator1}
\endmyfig
\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/gator2.pdf}
\caption{$\hat\pi_j(x)$ for $j=1,2,3$ which corresponds to the three food (invertebrate, other, fish). Dose-response curve for Males on Left; Females on Right.}
\label{fig:gator2}
\endmyfig

\newpage

# 3a)

\begin{align*}
f(y | \mu,\phi) &= (2\pi\phi y^3)^{-1/2} \exp\bc{-\frac{(y-\mu)^2}{2\phi\mu^2 y}} \\
&= \exp\bc{ -\frac{1}{2} \log(2\pi\phi y^3) + \frac{-y^2 + 2\mu y - \mu^2}{2\phi\mu^2 y}} \\
&= \exp\bc{ \frac{y(-1/2\mu^2) - (-1/\mu)}{\phi} + \bk{-\frac{1}{2}\p{\frac{1}{\phi y} + \log(2\pi\phi y^3)}}} \\
&= \exp\bc{ \frac{y\theta - b(\theta)}{\phi} + c(y,\phi)}
\end{align*}
Therefore, the inverse gaussian distribution is a member of the EDF family, with 

- $\phi = \phi$
- $\theta = -1/2\mu^2$
- $b(\theta) = -\sqrt{-2\theta}$
- $c(y,\phi) = -\frac{1}{2}\p{\frac{1}{\phi y} + \log(2\pi\phi y^3)}$

Consequently,

\begin{align*}
\E\bk{y|\mu,\phi} &= b'(\theta) \\
&= -\frac{1}{2}(-2\theta)^{-1/2} (-2) \\
&= (-2\theta)^{-1/2}\\
&= \mu \\
\text{Var}\bk{y|\mu,\phi} &= \phi~b''(\theta) \\
&= -\frac{\phi}{2}(-2\theta)^{-3/2}(-2) \\
&= \phi(-2\theta)^{-3/2} \\
&= \phi(\mu^{-1/2})^{-3/2} \\
&= \phi \mu^3
\end{align*}

\newpage

# 3b)

The scaled deviance is
\begin{align*}
D^* &= -2\log(\lambda) \\
&= \frac{2}{\phi} \suml w_i\bc{y_i(\tilde\theta_i - \hat\theta_i) - b(\tilde\theta_i) + b(\hat\theta_i)} \\
&= \frac{2}{\phi} \suml \bc{y_i\bk{\p{\frac{-1}{2\tilde\mu_i^2}}-\p{\frac{-1}{2\hat\mu_i^2}}} - \p{\frac{-1}{\tilde\mu_i}} + \p{\frac{-1}{\hat\mu_i}}} \\
&= \frac{2}{\phi} \suml \bc{y_i\bk{\p{\frac{-1}{2y_i^2}}-\p{\frac{-1}{2\gii^2}}} - \p{\frac{-1}{y_i}} + \p{\frac{-1}{\gii}}} \\
&= \frac{2}{\phi} \suml \bc{\frac{-1}{2y_i}+\frac{y_i}{2\gii^2} +\frac{1}{y_i} -\frac{1}{\gii}} \\
&= \frac{2}{\phi} \suml \bc{\frac{1}{2y_i}+\frac{y_i}{2\gii^2} -\frac{1}{\gii}} \\
&= \frac{2}{\phi} \suml \bc{\frac{\gii^2 + y_i^2 - 2y_i\gii}{2y_i\gii^2}} \\
&= \frac{2}{\phi} \suml \bc{\frac{\bk{y_i-\gii}^2}{2y_i\gii^2}} \\
&= \frac{1}{\phi} \suml \frac{\bk{y_i-\gii}^2}{y_i~\gii^2} \\
\end{align*}

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
