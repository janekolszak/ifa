#cython: boundscheck=False, wraparound=False, overflowcheck=True, embedsignature=True

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

import cython
import ctypes
import numpy as np
cimport numpy as np

cimport c_declarations
from c_declarations cimport Distribution as CDistribution

from libcpp.string cimport string

# TODO: - Verify method - deletes non-positive elements

cdef class Distribution:
    def __cinit__(self, keys = None, values = None, dictionary = None, normalize = False):
        self.thisptr = new CDistribution()

        if (keys is not None) and (values is not None):
            for k, v in zip(keys, values):
                self.thisptr.insert(k, v)

        elif dictionary is not None:
            for k, v in dictionary.iteritems():
                self.thisptr.insert(k, v)

        if normalize:
            self.thisptr.normalize()

    def __dealloc__(self):
        del self.thisptr

    def __iter__(self):
        self.thisptr.startIteration()
        return self

    def __next__(self):
        try:
            return self.thisptr.next()
        except IndexError:
            raise StopIteration()

    def __getitem__(self, key):
        if type(key) is not str:
            raise TypeError("Keys should be str")

        try:
            return self.thisptr.get(key)
        except IndexError:
            raise KeyError("No such key")

    def __setitem__(self, key, value):
        if type(key) is not str:
            raise TypeError("Keys should be str")

        self.thisptr.set(key, value)

    def __delitem__(self, key):
        if type(key) is not str:
            raise TypeError("Keys should be str")

        if not self.thisptr.contains(key):
            raise KeyError("No such key")

        self.thisptr.erase(key)

    def __contains__(self, key):
        return self.thisptr.contains(key)

    def __add__(self, Distribution p):
        return add(self, p)

    def __sub__(self, Distribution p):
        return subtract(self, p)

    def __iadd__(self, Distribution p):
        for key, value in p:
            self.thisptr.append(key, value)

        return self

    def __isub__(self, Distribution p):
        for key, value in p:
            self.thisptr.remove(key, value)

        return self

    def __len__(self):
        return self.thisptr.size()

    def __str__(self):
        return "{" + ", ".join(['"'+ str(e) + '"' + ": " + str(p) for e, p in self]) + "}"

    def size(self):
        return self.thisptr.size()

    def isEmpty(self):
        return self.thisptr.isEmpty()

    def insert(self, key, value):
        self.thisptr.insert(key, value)

    def normalize(self):
        if self.thisptr.isEmpty():
            return None

        return self.thisptr.normalize()

    def getNormalizingConstant(self):
        if self.thisptr.isEmpty():
            return None

        return self.thisptr.getNormalizingConstant()

    def entropy(self):
        return self.thisptr.entropy()

    def contains(self, key):
        return self.thisptr.contains(key)

    def append(self, key, value):
        self.thisptr.append(key, value)

cpdef add(Distribution p, Distribution q):
    r = Distribution()
    c_declarations.add(p.thisptr, q.thisptr, r.thisptr)
    r.normalize()
    return r

cpdef subtract(Distribution p, Distribution q):
    r = Distribution()
    c_declarations.subtract(p.thisptr, q.thisptr, r.thisptr)
    r.normalize()
    return r

cpdef common(Distribution p, Distribution q):
    r = Distribution()
    c_declarations.common(p.thisptr, q.thisptr, r.thisptr)
    return r

cpdef direction(Distribution p, Distribution q):
    return c_declarations.direction(p.thisptr, q.thisptr)
