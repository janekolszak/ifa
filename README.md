Information Flow Analysis
=========================

IFA is a simple library for information flow analysis. 
It's in Pre-alpha stage.

Installation
============
````bash
sudo make install
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
