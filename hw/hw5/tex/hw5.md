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

\begin{align*}
f_{Y_i}(y_i |\bm\beta,\lambda) &= \int_0^\infty \frac{e^{-\mu}\mu^{y_i}}{y_i!} \times \frac{1}{\Gamma(\lambda)}\p{\frac{\lambda}{\gamma_i}}^\lambda \mu^{\lambda-1} \exp\p{-\mu\frac{\lambda}{\gamma_i}}d\mu \\
&= \frac{1}{y_i!\Gamma(\lambda)}\p{\frac{\lambda}{\gamma_i}}^\lambda
\int_0^\infty \mu^{y_i+\lambda-1} \exp\bc{-\mu\p{\frac{\lambda}{\gamma_i}+1}} d\mu \\
&= \frac{\Gamma(y_i+\lambda)}{y_i!\Gamma(\lambda)}\p{\frac{\lambda}{\gamma_i}}^\lambda \p{\frac{\lambda}{\gamma_i}+1}^{-y_i-\lambda} \\
&= \frac{\Gamma(y_i+\lambda)}{y_i!\Gamma(\lambda)}\p{\frac{\lambda/\gamma_i}{\lambda/\gamma_i + 1}}^\lambda \p{\frac{1}{\lambda/\gamma_i + 1}}^{y_i}\\
&= \frac{\Gamma(y_i+\lambda)}{y_i!\Gamma(\lambda)}\p{1-\frac{1}{\lambda/\gamma_i + 1}}^\lambda \p{\frac{1}{\lambda/\gamma_i + 1}}^{y_i}\\
\Rightarrow Y_i | \bm\beta, \lambda &\sim \text{NB}\p{\lambda,\frac{1}{\lambda/\gamma_i+1}} \\
\end{align*}

So, $\E\bk{Y_i | \bm\beta, \lambda} = \ds\frac{\lambda}{\lambda/\gamma_i + 1} \big/\frac{\lambda/\gamma_i}{\lambda/\gamma_i+1} = \gamma_i = \exp(x_i^T\beta)$.

$\text{Var}\bk{Y_i|\bm\beta,\lambda} = \ds\E\bk{Y_i | \bm\beta, \lambda} \big/ \frac{\lambda/\gamma_i}{\lambda/\gamma_i+1} = \gamma_i \big/ \frac{\lambda/\gamma_i}{\lambda/\gamma_i+1} = \frac{\gamma_i^2(\lambda+\gamma_i)}{\lambda}$.

## Posterior Predictive Distribution

The posterior predictive distribution for a new (unobserved) response
is 
$$p(y_0 | x_0, \bm y) = \int p(y_0|x_0,\bm\beta,\lambda)~p(\lambda|\bm y) ~p(\bm\beta|\bm y)d\lambda d\bm\beta.$$


## MCMC For Posterior Simulation

The joint posterior of the parameters $(\beta,\mu,\lambda)$ can be simulated
from using a Gibbs sampler:

\begin{align*}
\mu_i | \bm y, \beta, \lambda &\sim \text{Gamma}(\lambda,\lambda/\gamma_i) \\
p(\beta | \bm y, \lambda, \mu)  &\propto p(\beta) p(\mu_i | \gamma_i,\lambda) \\
p(\lambda | \bm y, \mu, \beta)  &\propto p(\lambda) p(\mu_i | \gamma_i,\lambda) \\
\end{align*}

Note that Metropolis updates are needed to sample from the full conditionals
of $\beta$ and $\lambda$.

Figure \ref{fig:betaB} summarizes the posterior distribution of the covariate
parameters in the hierarchical Poisson GLM. The posterior means are similar to
those in the regular Poisson GLM; while the 95% credible intervals are slightly
wider in the hierarchical model.

Figure \ref{fig:lambda} summarizes the posterior distribution for the 
$\lambda$ parameter in the hierarchical Poisson GLM. The posterior
mean was 9.1 with a 95% equal-tailed credible interval of (3.2, 24). 
Note that the prior distribution used for $\lambda$ in the analysis was
$p(\lambda) = 1/(1+\lambda)^2$.

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/lambda.pdf}
\caption{Posterior distribution for $\lambda$ parameter in hierarchical Poisson
GLM}
\label{fig:lambda}
\endmyfig

Figure \ref{fig:predB} summarizes the posterior predictive response mean in
the hierarchical model. 
Note the contrast with the plot for the regular (non-hierarchical) model
in Figure \ref{fig:predA}. The credible region is wider in the hierarchical
model. This allows the hierarchical model to account for overdispersion.


## Sensitivity Analysis for $\lambda$
Figure \ref{fig:sensMean} shows how the posterior mean for $\lambda$ 
changes under different prior distributions for $\lambda$. Specifically,
for the class of priors $\lambda|m,v \sim \text{Gamma}(m,v)$, where $m$ and $v$ are the prior mean and variance of $\lambda$, the posterior means are close
to the prior means in general. Though, the posterior variance
shown in Figure \ref{fig:sensSD} seems to be be lowest when the prior
mean is around 10. 

\begin{figure*}[h]
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/sensitivityMean.pdf}
    \caption{some caption}
    \label{fig:sensMean}
  \end{minipage}\hfill
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{../img/sensitivitySD.pdf}
    \caption{some caption}
    \label{fig:sensSD}
  \end{minipage}
\end{figure*}


# Comparison of Models
Table \ref{quadloss} shows the quadratic loss under each model; smaller losses are preferred. This quantity was computed as
$$
\L(\M_j) = \suml var^{\M_j}(z_i|data) + \frac{K}{K+1}\suml\bk{y_i-\E^{\M_j}\p{z_i|data}}^2
$$
where $\M_j$ represents model $j$, of $J$ models to compare, $y_i$ is the
observed response, $z_i$ are the replicate responses, and $n$ is the total
number of observations. Intuitively, this expression is the sum of a penalty
term for model complexity and a goodness-of-fit term. Consequently, choosing
a $K$ that is small penalizes models that are complex more heavily. The
(non-hierarchical) Poisson GLM has the smaller loss, and so is preferred. Note
that here, $K$ was chosen to be 1000. Also note that here, the hierarchical
model was penalized more heavily for its greater number of parameters, even
though it yields about the same mean posterior prediction. Therefore, the 
hierarchical does not provide a great improvement over the non-hierarchical model.

--------------------------------------------
 Model                       Quadratic Loss
--------------------------- ----------------
Poisson GLM                    666.52
 
Hierarchical Poisson GLM       699.64
--------------------------------------------

Table: Quadratic loss under each model. \label{quadloss}



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
