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

Figure \ref{fig:combo} shows the transformed data. The 
`square-root` and `log` functions were applied to the
predictor and response in different combination.
It appears that simply transforming the response
with a log of square-root function produces the 
most linear response. Admittedly, there appears
to be at least two different slopes (clusters)
within the strained group. Perhaps a Dirichlet-process
mixture model would do better to fit the data. 

\beginmyfig
\includegraphics[height=0.5\textwidth]{../img/combo.pdf}
\caption{Transformed data}
\label{fig:combo}
\endmyfig

Seven different models were fit: 

\begin{align*}
\mathcal{M}_1: y_i &= \Poisson\p{\exp\p{\beta_0 + \beta_1 x_{i1} + \beta_2 x_{i2}}} \\
\mathcal{M}_2: y_i &= \Poisson\p{\p{\beta_0 + \beta_1 x_{i1} + \beta_2 x_{i2}}^2}\\
\mathcal{M}_3: y_i &= \Poisson\p{\exp\p{\beta_0 + \beta_1 \sqrt{x_{i1}} + \beta_2 x_{i2}}} \\
\mathcal{M}_4: y_i &= \Poisson\p{\p{\beta_0 + \beta_1 \sqrt{x_{i1}} + \beta_2 x_{i2}}^2}\\
\mathcal{M}_5: y_i &= \Poisson\p{\exp\p{\beta_0 + \beta_1 \log(1+x_{i1}) + \beta_2 x_{i2}}} \\
\mathcal{M}_6: y_i &= \Poisson\p{\p{\beta_0 + \beta_1 \log(1+x_{i1}) + \beta_2 x_{i2}}^2}\\
\mathcal{M}_7: y_i &= \Poisson\p{\exp\p{\beta_0 + \beta_1 x_{i1} + \beta_2 x_{i2} + \beta_3 x_{i2}x_{i3}}} \\
\end{align*}

The last model $(\mathcal{M}_7)$ places a log link on the mean and
adds an interaction term to account for possibly crossing of slopes.

Table \ref{stats} displays the deviance, AIC, BIC, as well as the sum of
squared Pearson-residuals and deviance-residuals. The model that performs the
best under each criteria are printed in bold. It appears that $\mathcal{M}_1$
and $\mathcal{M}_7$ perform the best. However, $\mathcal{M}_1$ is simpler than
$\mathcal{M}_7$ as it doesn't have an interaction term, but performs almost as
well (and better at times) in each criteria.

-------------------------------------------------------------------------
                     M1         M2     M3     M4     M5     M6         M7
--------------- ----------   ------ ------ ------ ------ ------ ---------
Deviance           86.38     144.18 108.85 164.28  97.89 107.63 **84.60**

AIC             **415.95**   473.75 438.43 493.85 427.46 437.20    416.17

BIC             **428.61**   486.41 451.09 506.51 440.12 449.86    433.05

Pearson-resid.      1.14       2.14   1.44   2.17   1.35   1.39  **1.11**

Deviance-resid.     1.23       2.06   1.56   2.35   1.40   1.54  **1.21**
-------------------------------------------------------------------------

Table: Measures of Goodness-of-fit & Model Comparison \label{stats}

Figure \ref{fig:pred} shows the estimated regression functions under
$\mathcal{M}_1$(+) and $\mathcal{M}_7$ (X). The predictions under
the two models are similar. And appear to capture the general trend.
But as expected, the model isn't able to capture the two different
groups within the strained group.
\beginmyfig
\includegraphics[height=0.7\textwidth]{../img/pred.pdf}
\caption{Predictions}
\label{fig:pred}
\endmyfig

