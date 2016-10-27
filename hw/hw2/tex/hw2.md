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
    - \newcommand{\E}{ \text{E} }
    - \newcommand{\V}{ \text{Var} }
    - \def\given{~\bigg|~}
    # Figures in correct place
    - \usepackage{float}
    - \def\beginmyfig{\begin{figure}[H]\center}
    - \def\endmyfig{\end{figure}}
    # 
    - \newcommand{\Poisson}{\text{Poisson}}
    - \allowdisplaybreaks
---

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

## 3a)

```
Call:
glm(formula = faults ~ length, family = "poisson", data = fabric)

Deviance Residuals:
     Min        1Q    Median        3Q       Max
-2.74127  -1.13312  -0.03904   0.66179   3.07446

Coefficients:
             Estimate Std. Error z value Pr(>|z|)
(Intercept) 0.9717506  0.2124693   4.574 4.79e-06 ***
length      0.0019297  0.0003063   6.300 2.97e-10 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for poisson family taken to be 1)

    Null deviance: 103.714  on 31  degrees of freedom
Residual deviance:  61.758  on 30  degrees of freedom
AIC: 189.06

Number of Fisher Scoring iterations: 4
```

## 3b)
```
Call:
glm(formula = faults ~ length, family = "quasipoisson", data = fabric)

Deviance Residuals:
     Min        1Q    Median        3Q       Max
-2.74127  -1.13312  -0.03904   0.66179   3.07446

Coefficients:
             Estimate Std. Error t value Pr(>|t|)
(Intercept) 0.9717506  0.3095033   3.140 0.003781 **
length      0.0019297  0.0004462   4.325 0.000155 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for quasipoisson family taken to be 2.121965)

    Null deviance: 103.714  on 31  degrees of freedom
Residual deviance:  61.758  on 30  degrees of freedom
AIC: NA

Number of Fisher Scoring iterations: 4
```

## 3c)

#### Likelihood:
\begin{align*}
\hat{\eta_0} &= x_0^T\hat{\beta} \\
\\
\E\bk{\hat{\eta_0}} &= \E\bk{x_0^T\hat\beta}\\
&= x_0^T\E\bk{\hat\beta}\\
&= x_0^T\beta \\
\\
\V(\hat{\eta_0}) &= \V(x_0^T\hat\beta) \\
&= \V(x_0^T\hat\beta) \\
&= x_0^T\V(\hat\beta)x_0 \\
&= x_0^TJ^{-1}(\beta)x_0 \\
\\
\end{align*}

Therefore, a point estimate for $\eta_0$ is $\hat{\eta_0}$, and an interval estimate
is $x_0^T\hat\beta \pm z_{.025} \sqrt{x_0^T J^{-1}(\hat\beta)x_0}$.

\begin{align*}
\tilde{\eta_0} &= x_0^T\tilde{\beta} \\
\\
\E\bk{\tilde{\eta_0}} &= x_0^T\beta \\
\\
\V(\hat{\eta_0}) &= \V(x_0^T\hat\beta) \\
&= x_0^T\V(\hat\beta)x_0 \\
&= x_0^TJ^{-1}(\beta,\tilde{\phi})x_0 \\
&= x_0^T\p{J(\beta)/\tilde{\phi}}^{-1}x_0 \\
&= \tilde{\phi}x_0^T J^{-1}(\beta)x_0 \\
\\
\end{align*}

Therefore, a point estimate for $\eta_0$ is $\tilde{\eta_0}$, and an interval estimate
is $x_0^T\tilde\beta \pm z_{.025} \sqrt{\tilde\phi x_0^T J^{-1}(\hat\beta)x_0}$.


---------------------------------------------------------------
 $x_0$   Model           Point Estimate      Interval Estimate
-------  -------------- ---------------- ----------------------
 500     Poisson              1.936624    (1.783437, 2.089811) 

 500     Quasi-poisson        1.936624    (1.713477, 2.159771) 

 995     Poisson              2.891849    (2.662679, 3.121018) 

 995     Quasi-poisson        2.891849    (2.558018, 3.225679) 
---------------------------------------------------------------

## 4)

### Graphical Exploratory Analysis of Data

Figure \ref{fig:dat} plots the data (untransformed) with 
the response (number of organisms) on the y-axis, and 
the covariate (jet fuel concentration) on the x-axis.
The observations are color-coded to distinguish between
strained (blue) and unstrained (orange) observations.

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/dat.pdf}
\caption{Untransformed data}
\label{fig:dat}
\endmyfig

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/combo.pdf}
\caption{Transformed data}
\label{fig:combo}
\endmyfig

