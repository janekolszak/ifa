# The MIT License (MIT)
#
# Copyright (c) 2015 Jan Olszak (j.olszak@gmail.com)
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
from ifa.connections import compute
import numpy as np


class TestConnections(unittest.TestCase):

    def test_compute(self):
        p = Distribution(["A", "B"], [0.3, 0.7])
        q = Distribution(["A", "B", "C"], [0.3, 0.3, 0.4])
        r = Distribution(["D", "C"], [0.5, 0.5])
        l = [p, q, r]
        for w in compute(l, [2, 1, 3], 1, logOnScreen=False):
            pass

        for w in compute(l, [2, 1, 3], 3, logOnScreen=False):
            pass
