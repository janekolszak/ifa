# The MIT License (MIT)
#
# Copyright (c) 2014 Jan Olszak (j.olszak@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import unittest
from numpy.testing import assert_allclose

from ifa.distribution import Distribution
from ifa.divergence import jsd, indexD, compute_data
import numpy as np


class TestDivergence(unittest.TestCase):

    def test_jsd(self):
        p = Distribution(["A", "B"], [0.5, 0.5])
        q = Distribution(["A", "C"], [0.5, 0.5])

        assert_allclose(jsd(p, 0.5, q, 0.5), [0.5])

    def test_indexD(self):
        p = Distribution(["A", "B"], [0.5, 0.5])
        q = Distribution(["A", "C"], [0.5, 0.5])
        r = Distribution(["D", "C"], [0.5, 0.5])

        assert_allclose(indexD(p, 5, q, 5), [0.5])
        assert_allclose(indexD(p, 5, p, 5), [0])
        assert_allclose(indexD(p, 5, p, 3), [0])
        assert_allclose(indexD(p, 1, p, 3), [0])
        assert_allclose(indexD(p, 5, r, 5), [1])
        assert_allclose(indexD(p, 5, r, 2), [1])
        assert_allclose(indexD(p, 5, r, 9), [1])

    def test_compute_data(se):
        p = Distribution(["A", "B"], [0.3, 0.7])
        q = Distribution(["A", "B", "C"], [0.3, 0.3, 0.4])
        r = Distribution(["D", "C"], [0.5, 0.5])
        l = [p, q, r]
        for w in compute_data(l, [2, 1, 3], 1):
            pass
