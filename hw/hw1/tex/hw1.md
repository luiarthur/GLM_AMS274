---
title: "AMS 274 - GLM HW 1"
author: Arthur Lui
date: "11 October, 2016"
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
---

#1

Exponential Dispersion Family density:
$$f(y|\theta,\phi) = \exp\p{\frac{y\theta - b(\theta)}{a(\phi)} + c(y,\phi)}$$

Exponential Family:
$$f(y|\theta) = c(\theta) h(y) \exp\p{\sum_{j=1}^D t_j(y)w_j(\theta)}$$

## 1a
The laplace distribution is not a member of the (two-parameter) exponential
family because there is only one $t_j(y)w_j(\theta)$ term in the exponent.
Consequently, it is not a member of the EDF either.
However, if $\mu$ were known, then it would belong to the exponential family, but not the EDF.

## 1b
The uniform distribution is not in the exponential family as the parameters
appear in the support of the random variable. Consequently, it not a member of 
the EDF either.

## 1c
The logistic distribution cannot be written in the exponential family form 
since it is a ratio of two exponents that cannot be simplified further. 
Therefore, it is neither in the exponential family nor the EDF.

## 1d
The Cauchy distribution is not in the exponential family as $y$ and the
parameters cannot be factored in the proper manner in the exponent.

## 1e
The pareto distribution is not in the exponential family (if the $\alpha$
parameter is not fixed) since the parameter appears in the support of 
$y$. Therefore, it is not in the EDF either.
However, in the case that the $\alpha$ parameter is known, the pareto is in the exponential family. Yet it would not be in the EDF because the $y$ does not appear in the exponent.

## 1f
$$
\begin{split}
f(y|\alpha,\beta) &= \p{B(\alpha,\beta)}^{-1} y^{\alpha-1} (1-y)^{\beta-1},
                    ~~~ y \in (0,1), \alpha,\beta > 0 \\
                  &= \exp\bc{(\alpha-1)\log(y) + (\beta-1)\log(1-y) - \log(B(\alpha,\beta))},
\end{split}
$$
which has the form of the exponential family. Therefore, the beta distribution is
in the exponential family. But it does not have the form of the EDF since $y$ does not appear in the exponent, so it does
not belong in the EDF.

## 1g
$$
\begin{split}
f(y|\alpha,p) &= \frac{\Gamma(y+\alpha)}{\Gamma(\alpha)y!} p^\alpha (1-p)^y, ~~~ y\in\mathbb{N}, \alpha>0, p\in(0,1)\\
&= \exp\bc{y\log(1-p) - (-\alpha\log(p)) + \log\p{\frac{\Gamma(y+\alpha)}{\Gamma(\alpha)y!}}}
\end{split}
$$
This parameterization of the Negative-Binomial distribution is only in the
exponential family and EDF if $\alpha$ is held fixed. Since $y$ and $\alpha$ 
cannot be factored, this particular parameterization of the NB is neither in 
the exponential family nor the EDF.

#2

## 2ai
$$
\begin{split}
f(y_i|\mu_i,\sigma) &= (2\pi\sigma^2)^{-1/2} \exp\p{-\frac{(y_i-\mu_i)^2}{2\sigma^2}} \\
\\
\mathcal{L}(\mu,\sigma|y) &\propto (\sigma^2)^{-n/2} \exp\p{-\suml\frac{(y_i-\mu_i)^2}{2\sigma^2}} \\
\\
l(\mu,\sigma|y) &= \log(\mathcal{L}) = -\frac{n}{2}\log(\sigma^2) - \suml \frac{(y_i-\mu_i)^2}{2\sigma^2}\\
                &= -\frac{n}{2}\log(\sigma^2) - \suml \frac{(y_i-x_i^T\beta)^2}{2\sigma^2}\\
                &= -\suml \frac{(y_i-x_i^T\beta)^2}{2\sigma^2} + C, \text{ where $C$ is a constant w.r.t to $\beta$}\\
\end{split}
$$
So $l$ (and hence the likelihood) is maximized w.r.t. $\beta$ as $\ds\suml
(y_i-x_i^T\beta)^2$ is minimized. That is the MLE for $\beta$ is obtained by
minimizing $S_2(\beta)$.


## 2aii
$$
\begin{split}
\mathcal{L}(\mu_i,\sigma|y) &\propto \sigma^{-n} \exp\p{-\suml \frac{\abs{y_i-\mu_i}}{\sigma}}
\\
l(\beta,\sigma|y) &= \log(\mathcal{L}) = -n\log(\sigma) - \suml\frac{\abs{y_i-x_i^T\beta}}{\sigma} + C, \text{ where $C$ is a constant w.r.t. $\beta,\sigma$} \\
&=  -\suml\frac{\abs{y_i-x_i^T\beta}}{\sigma} + C^*, \text{ where $C^*$ is a constant w.r.t. $\beta$} \\
\end{split}
$$
So $l$ (and hence the likelihood) is maximized w.r.t. $\beta$ as $\ds\suml
\abs{y_i-x_i^T\beta}$ is minimized. That is the MLE for $\beta$ is obtained by
minimizing $S_1(\beta)$.


## 2aiii
$$
\begin{split}
\mathcal{L}(\mu,\sigma|y) &\propto \sigma^{-n} \prodl \mathbbm{1}\p{\mu_i-\sigma\le y_i\le\mu_i+\sigma}\\
&= \sigma^{-n} \prodl \mathbbm{1}\p{-\sigma\le y_i-\mu_i\le+\sigma}\\
&= \sigma^{-n} \prodl \mathbbm{1}\p{\abs{y_i-\mu_i} \le \sigma}\\
\mathcal{L}(\beta,\sigma|y) &= \sigma^{-n} \prodl \mathbbm{1}\p{\abs{y_i-x_i^T\beta} \le \sigma}\\
&= \sigma^{-n} \mathbbm{1}\p{\underset{i}{max}\abs{y_i-x_i^T\beta} \le \sigma}\\
\end{split}
$$

So the likelihood is maximized w.r.t. $\beta$ as $\ds\underset{i}{max}
\abs{y_i-x_i^T\beta}$ is minimized. That is the MLE for $\beta$ is
obtained by minimizing $S_\infty(\beta)$.

## 2bi
$$
\begin{split}
l &= -\frac{n}{2} \log(\sigma^2) - \suml\frac{(y_i - x_i^T\beta)^2}{2\sigma^2} \\
l_{\sigma^2} &= -\frac{n}{2\sigma^2} + \frac{S_2(\beta)}{\p{2\sigma^2}^2} := 0 \\
-n\hat{\sigma^2}_{mle} + S_2(\beta) &= 0 \\
\hat{\sigma^2}_{mle} &= \frac{S_2(\beta)}{n} \\
\\
\therefore \hat{\sigma}_{mle} &= \sqrt{\frac{S_2(\beta)}{n}}
\end{split}
$$
The last step can be done as MLE's are invariant to transformations.

## 2bii
$$
\begin{split}
l &= -n\log(\sigma) - \suml{\frac{\abs{y_i-x_i^T\beta}}{\sigma}} \\
  &= -n\log(\sigma) - \frac{S_1(\beta)}{\sigma} \\
l_{\sigma} &= -\frac{n}{\sigma} + \frac{S_1(\beta)}{\sigma^2} := 0\\
-n\hat\sigma_{mle} + S_1(\beta) &= 0 \\
\\
\therefore \hat\sigma_{mle} &= \frac{S_1(\beta)}{n}
\end{split}
$$

## 2biii
$$
\begin{split}
\mathcal{L} &= \sigma^{-n} \mathbbm{1}\p{\underset{i}{max}\abs{y_i-x_i^T\beta} \le \sigma} \\
            &= \sigma^{-n} \mathbbm{1}\p{S_\infty(\beta) \le \sigma}
\\
\therefore \hat\sigma_{mle} &= S_\infty(\beta) \\
\end{split}
$$

# 3
## 3a

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

So, in the Newton-Raphson iterations, the parameters are updated until convergence using:
$$
\theta^{k+1} = \theta^k - \p{\ddf{l}{\theta}}^{-1}\df{l}{\theta} \\
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

So, in the scoring method, the parameters are updated until convergence using:
$$
\begin{split}
\theta^{k+1} &= \theta^k + \df{l}{\theta} \bigg/ J(\theta)\\
             &= \theta^k + \ds\suml\frac{2(y_i-\theta)}{1+(y_i-\theta)^2} \bigg/ \p{n/2}\\
             &= \theta^k + \ds\p{\frac{4}{n}}\ds\suml\frac{y_i-\theta}{1+(y_i-\theta)^2}
\end{split}
$$

## 3b

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

## 3c

Again, applying both the newton-raphson and scoring methods, and having
initialized the algorithms at different starting values, $\theta$ was estimated
to be **5.047**. Table \ref{table3c} summarizes the results and parameter
settings for the algorithms. Note that in all cases, the scoring method
converged much faster. But the scoring method did not converge to the global
max in 2 cases, whereas the Newton-raphson method did not converge to the
global max in 1 case.

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

$$
\begin{split}
f(y_i|\beta) &= \frac{\exp\p{-\exp\p{\beta_1+\beta_2 x_i}}\p{\beta_1+\beta_2 x_i}^{y_i}}{y_i!}\\
L(\beta|y) &= \prodl\frac{\exp\p{-\exp\p{\beta_1+\beta_2 x_i}}\p{\beta_1+\beta_2 x_i}^{y_i}}{y_i!}\\
l(\beta|y) &= \suml -\exp\p{\beta_1+\beta_2 x_i} + y_i \log{\p{\beta_1+\beta_2 x_i}} + C\\
\end{split}
$$

$$
\begin{split}
\pd{l}{\beta_1} &= \suml -\exp\p{\beta_1 + \beta_2 x_i} + y_i \\
\pd{l}{\beta_2} &= \suml \bc{-\exp\p{\beta_1 + \beta_2 x_i} + y_i} x_i \\
\\
\pd{^2l}{\beta_1^2} &= \suml -\exp\p{\beta_1 + \beta_2 x_i}\\
\pd{^2l}{\beta_2^2} &= \suml \bc{-\exp\p{\beta_1 + \beta_2 x_i}} x_i^2\\
\pd{^2l}{\beta_1\beta_2} &= \suml \bc{-\exp\p{\beta_1 + \beta_2 x_i}} x_i\\
\end{split}
$$

$$
J(\beta) = \begin{pmatrix}
-l_{\beta_1\beta_1} & -l_{\beta_1\beta_2} \\
-l_{\beta_2\beta_1} & -l_{\beta_2\beta_2} \\
\end{pmatrix}
$$

So, in the scoring method, the parameters are updated until convergence using:
$$
\begin{split}
\theta^{k+1} &= \theta^k + \p{J(\theta)}^{-1} 
                \begin{bmatrix} l_{\beta_1} \\ l_{\beta_2} \end{bmatrix}\\
\end{split}
$$


The scoring method converged in 107 iterations to the estimates (0.995998,
1.32661). The estimates from the `glm` function in `R` were (0.996,1.327).
The estimates agree.



[//]: # (This is a comment)
