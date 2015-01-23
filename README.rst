Information Flow Analysis
=========================

IFA is a simple and fast library for information theory research and information flow analysis. It's a Python module written C++, Cython.


Installation
============
Dependencies:
* numpy

If you have Cython some cpp files will get regenerated during installation
.. code-block:: bash

    pip install ifa

Or if you want the developmen version:
.. code-block:: bash

    git clone https://github.com/janekolszak/ifa.git;
    cd ifa;
    sudo make install;

Usage
=====
Computing Jensen–Shannon divergence:
.. code-block:: python

    from ifa.distribution import Distribution
    from ifa.divergence import jsd

    from numpy.testing import assert_allclose

    p = Distribution(["A", "B"], [0.5, 0.5])
    q = Distribution(["A", "C"], [0.5, 0.5])

    assert_allclose(jsd(p, 0.5, q, 0.5), [0.5])

What's inside:
==============
* Distribution class with some basic operations
* Divergences:
 * Jensen–Shannon divergence
 * Kullback–Leibler divergence
* Functions to compute information flow between distributions
