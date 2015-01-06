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

from ifa.distribution import Distribution, common, direction, getStore
import numpy as np


class TestDistributionFunctions(unittest.TestCase):

    def test_common(self):
        p = Distribution(["A", "B", "C"], [0.3, 0.3, 0.4])
        q = Distribution(["A", "B"], [0.3, 0.7])
        r = common(p, q)

        self.assertEqual(len(r), 2)
        self.assertEqual(r["A"], 0.5)
        self.assertEqual(r["B"], 0.5)

        r = common(q, p)

        self.assertEqual(len(r), 2)
        self.assertEqual(r["A"], 0.3)
        self.assertEqual(r["B"], 0.7)

    def test_direction(self):
        p = Distribution(["A", "B", "C"], [0.3, 0.3, 0.4])
        q = Distribution(["A", "B"], [0.3, 0.7])
        self.assertEqual(direction(p, q), -direction(q, p))
        self.assertEqual(direction(p, p), 0)

    def test_getStore(self):
        p = Distribution(["A", "B", "C"], [0.3, 0.3, 0.4])
        q = Distribution(["A", "B"], [0.3, 0.7])
        print getStore([p, q])
