---
title: "AMS 274 - GLM HW 2"
author: Arthur Lui
date: "27 October, 2016"
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
    - \newcommand{\E}{ \text{E} }
    - \newcommand{\Poisson}{\text{Poisson}}
---

\allowdisplaybreaks

## 1a)

For $y_i \sim \Poisson(\mu_i)$, the probability density is $f(y_i|\mu_i) = \ds\frac{e^{-\mu_i}\mu_i^{y_i}}{y_i!}$. Also, the Exponential Dispersion Family
(EDF) has pdf $p(y_i|\theta_i,\phi) = \exp\bc{\ds\frac{y_i\theta_i - b(\theta_i)}{\phi/w_i} + c(y_i,\phi)}$. And the deviance statistic is defined as 
$$
D = 2\suml w_i \bc{y_i\p{\tilde{\theta_i}-\hat{\theta_i}} - b(\tilde{\theta_i}) + b(\hat{\theta_i})}.\\
$$

First, note that the Poisson distribution is a member of the EDF with 
$$
\begin{split}
\theta_i &= \log(\mu_i)\\
b(\theta_i) &= \exp(\theta_i) = -\mu_i\\
w_i = \phi &= 1
\end{split}
$$
So, 

\begin{align*}
D &= 2\suml \bc{y_i\p{\tilde{\theta_i}-\hat{\theta_i}} - b(\tilde{\theta_i}) + b(\hat{\theta_i})} \\
  &= 2\suml \bc{y_i\bc{\log(\tilde{\mu_i})-\log(\hat{\mu_i})} + \tilde{\mu_i} - \hat{\mu_i}} \\
  &= 2\suml \bc{y_i\log\p{\frac{\tilde{\mu_i}}{\hat{\mu_i}}} + \tilde{\mu_i} - \hat{\mu_i}} \\
  &= 2\suml \bc{y_i\log\p{\frac{y_i}{\hat{\mu_i}}} + y_i - \hat{\mu_i}} \\
  &= 2\suml \bc{y_i\log\p{\frac{y_i}{\hat{\mu_i}}}} + 2\suml\bc{y_i - \hat{\mu_i}}\\
\end{align*}

where $\hat{\mu_i} = g^{-1}(x_i^T\hat\beta)$, and $\hat\beta$ is the MLE of $\beta$ under the reduced model. 

## 1b)
In the special case where $g(\cdot) = \log(\cdot)$, we have $\hat{\mu_i} = g^{-1}(x_i^T\hat\beta) = \exp(x_i^T\hat\beta)$, and the deviance is
\begin{align*}
D &= 2\suml \bc{y_i\log\p{\frac{y_i}{\hat{\mu_i}}}} + 2\suml\bc{y_i - \hat{\mu_i}}\\
  &= 2\suml \bc{y_i\log\p{\frac{y_i}{\hat{\mu_i}}}} + 2\suml\bc{y_i - \exp(x_i^T\hat\beta)}\\
  &= 2\suml \bc{y_i\log\p{\frac{y_i}{\hat{\mu_i}}}} + 2n\bar{y} - 2\suml\exp(x_i^T\hat\beta)\\
  &= 2\suml y_i\log\p{\frac{y_i}{\hat{\mu_i}}} \\
\end{align*}

## 2a)
\begin{align*}
f(y_i|\mu_i,\nu) &= \ds\frac{(\nu/\mu_i)^\nu y_i^{\nu-1}}{\Gamma(\nu)}\exp(-\nu y_i/\mu_i)\\
&= \exp\bc{-\frac{\nu y_i}{\mu_i} + (\nu-1)\log y_i + \nu\log\frac{\nu}{\mu_i}-\log\Gamma(\nu)}\\
&= \exp\bc{\ds\frac{y_i \mu_i^{-1} - \log\ds\frac{\mu_i}{\nu}}{-\nu^{-1}} + (\nu-1)\log(y_i) - \log\Gamma(\nu)}
\end{align*}
which is a member of the EDF with
\begin{align*}
\theta_i &= \mu_i^{-1} \\
b(\theta_i) &= \log\frac{\mu_i}{\nu} = -\log(\nu\theta_i)\\
w_i &= -1 \\
\phi &= \nu^{-1} \\
\end{align*}

\newpage

## 2b)
The scaled deviance is
\begin{align*}
D^* &= \frac{2}{\phi}\suml w_i\bc{y_i\p{\tilde{\theta_i}-\hat{\theta_i}} - b(\tilde{\theta_i}) + b(\hat{\theta_i})} \\
    &= -\frac{2}{\phi}\suml \bc{y_i\p{\tilde{\mu_i}^{-1}-\hat{\mu_i}^{-1}} - \log\frac{\tilde{\mu_i}}{\nu} + \log\frac{\hat{\mu_i}}{\nu}} \\
    &= -\frac{2}{\phi}\suml \bc{y_i\p{\tilde{\mu_i}^{-1}-\hat{\mu_i}^{-1}} + \log\frac{\hat{\mu_i}}{\tilde{\mu_i}} }\\
    &= -\frac{2}{\phi}\suml \bc{y_i\p{{y_i}^{-1}-\hat{\mu_i}^{-1}} + \log(y_i\hat\mu_i) }\\
    &= -\frac{2}{\phi}\suml 1-\frac{y_i}{\hat{\mu_i}} + \log(y_i\hat\mu_i)\\
    &= \frac{1}{\phi} D
\end{align*}
where $D = 2\ds\suml\bc{\frac{y_i}{\hat{\mu_i}} - \log(y_i\hat\mu_i) -1}$ is the deviance, and $\hat{\mu_i} = g^{-1}(x_i^T\hat\beta)$.

