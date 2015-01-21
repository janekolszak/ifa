Information Flow Analysis
=========================

IFA is a simple library for information flow analysis.
It's in Pre-alpha stage.

Installation
============
````bash
pip install ifa
````
Dependencies:
* cython (only for the installation)
* numpy

Or if you want the developmen version:
````bash
git clone https://github.com/janekolszak/ifa.git;
cd ifa;
sudo make install;
````
Usage
=====
Computing Jensen–Shannon divergence:
````python
from ifa.distribution import Distribution
from ifa.divergence import jsd

from numpy.testing import assert_allclose

p = Distribution(["A", "B"], [0.5, 0.5])
q = Distribution(["A", "C"], [0.5, 0.5])

assert_allclose(jsd(p, 0.5, q, 0.5), [0.5])
````

What's inside:
==============
* Distribution class with some basic operations
* Divergences:
 * Jensen–Shannon divergence
 * Kullback–Leibler divergence
* Functions to compute information flow between destribution
