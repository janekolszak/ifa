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
import numpy as np


class TestDistribution(unittest.TestCase):

    def test_str(self):
        d = Distribution(["A", "B"], [0.3, 0.7])
        self.assertEqual(str(d), '{"A": 0.3, "B": 0.7}')

    def test_iteration(self):
        d = Distribution(["A", "B"], [0.3, 0.7])

        it = iter(d)
        e, p = it.next()
        self.assertEqual(e, "A")
        self.assertEqual(p, 0.3)

        e, p = it.next()
        self.assertEqual(e, "B")
        self.assertEqual(p, 0.7)

        for e, p in d:
            pass

        it = iter(d)
        e, p = it.next()
        self.assertEqual(e, "A")
        self.assertEqual(p, 0.3)

        e, p = it.next()
        self.assertEqual(e, "B")
        self.assertEqual(p, 0.7)

    def test_getsetdel(self):
        d = Distribution()
        with self.assertRaises(KeyError):
            d["A"]

        d["A"] = 0.2
        self.assertEqual(d["A"], 0.2)
        d["A"] = 0.3
        self.assertEqual(d["A"], 0.3)
        del d["A"]

        with self.assertRaises(KeyError):
            d["A"]

        with self.assertRaises(TypeError):
            d[12]

    def test_contains(self):
        d = Distribution(["A", "B"], [0.3, 0.7])
        self.assertTrue(d.contains("A"))
        self.assertFalse(d.contains("C"))

    def test_normalize(self):
        d = Distribution(["A", "B"], [3, 3])
        self.assertEqual(d.normalize(), 6)
        self.assertEqual(d.getNormalizingConstant(), 6)
        self.assertEqual(d["A"], 0.5)

    def test_constructor(self):
        d = Distribution(["A", "B"], [0.3, 0.7])
        self.assertEqual(d["A"], 0.3)
        self.assertEqual(d["B"], 0.7)

        d = Distribution(dictionary={"A": 0.3, "B": 0.7})
        self.assertEqual(d["A"], 0.3)
        self.assertEqual(d["B"], 0.7)

    def test_isEmpty(self):
        d = Distribution(["A", "B"], [0.3, 0.7])
        self.assertFalse(d.isEmpty())

        d = Distribution()
        self.assertTrue(d.isEmpty())

    def test_sub(self):
        # TODO: Include bigger q in this test
        p = Distribution(["A", "B", "C"], [0.4, 0.3, 0.3])
        q = Distribution(["A", "C", "D"], [0.4, 0.2, 0.25])
        r = p - q

        self.assertEqual(r["A"], 0.0)
        assert_allclose(r["B"], [0.75])
        assert_allclose(r["C"], [0.25])

    def test_add(self):
        p = Distribution(["A", "B"], [0.2, 0.25])
        q = Distribution(["A", "C", "D"], [0.05, 0.25, 0.25])
        r = p + q

        self.assertEqual(r["A"], 0.25)
        self.assertEqual(r["B"], 0.25)
        self.assertEqual(r["C"], 0.25)
        self.assertEqual(r["D"], 0.25)

    def test_append(self):
        p = Distribution(["A", "B", "C"], [0.2, 0.25, 0.55])
        p.append("A", 0.3)
        self.assertEqual(p["A"], 0.5)

    def test_iadd(self):
        p = Distribution(["A", "B", "C"], [0.2, 0.25, 0.55])
        q = Distribution(["A"], [0.2])
        p += q
        self.assertEqual(p["A"], 0.4)

    def test_insert(self):
        d = Distribution()
        self.assertEqual(d.size(), 0)
        d.insert("A", 0.5)
        d.insert("B", 0.5)
        self.assertEqual(d.size(), 2)

    def test_entropy(self):
        d = Distribution(["A", "B"], [0.5, 0.5])
        assert_allclose(d.entropy(), [1])
