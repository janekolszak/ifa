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
from libcpp.vector cimport vector

cdef class Distribution:
    def __cinit__(self, events = None, probabilities = None):
        self.thisptr = new CDistribution()

        if (events is not None) and (probabilities is not None):
            for e, p in zip(events,probabilities):
                self.thisptr.insert(e, p)

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

    def __getitem__(self, event):
        if type(event) is not str:
            raise TypeError("Events should be str")

        try:
            return self.thisptr.get(event)
        except IndexError:
            raise KeyError("No such event")

    def __setitem__(self, event, prob):
        if type(event) is not str:
            raise TypeError("Events should be str")

        self.thisptr.set(event, prob)

    def __delitem__(self, event):
        if type(event) is not str:
            raise TypeError("Events should be str")

        if not self.thisptr.contains(event):
            raise KeyError("No such event")

        self.thisptr.erase(event)

    def __contains__(self, event):
        return self.thisptr.contains(event)

    def __len__(self):
        return self.thisptr.size()

    def __str__(self):
        return "{" + ", ".join(['"'+ str(e) + '"' + ": " + str(p) for e, p in self]) + "}"

    def size(self):
        return self.thisptr.size()

    def isEmpty(self):
        return self.thisptr.isEmpty()

    def insert(self, event, probability):
        self.thisptr.insert(event, probability)

    def normalize(self):
        self.thisptr.normalize()

    def entropy(self):
        return self.thisptr.entropy()

    def contains(self, event):
        return self.thisptr.contains(event)


cpdef common(Distribution p, Distribution q):
    r = Distribution()
    c_declarations.common(p.thisptr, q.thisptr, r.thisptr)
    return r

cpdef direction(Distribution p, Distribution q):
    return c_declarations.direction(p.thisptr, q.thisptr)

cpdef getStore(distributions):
    n = len(distributions)
    # cdef np.ndarray[np.double_t, ndim=1, mode='c'] store
    cdef np.ndarray[CDistribution, ndim=1, mode='c'] c
    c = np.empty((n,), dtype = CDistribution)
    return c
    # store = np.empty((n,), dtype = ctypes.c_void_p)
    # store = np.ascontiguousarray(store, dtype= ctypes.c_void_p)
    # for i, d in enumerate(distributions):
    #     store[i] = (<Distribution?>d).thisptr
    # return store



@cython.boundscheck(False)
def compute_data(vector[Distribution] distributions, vector[double] weights, int chunkSize):
    cdef int n = distributions.size()
    cdef int ret_size = (n - 1) * n / 2

    cdef np.ndarray[int, ndim=1, mode='c'] pIdxs
    cdef np.ndarray[int, ndim=1, mode='c'] qIdxs
    cdef np.ndarray[double, ndim=1, mode='c'] index_ds
    cdef np.ndarray[int, ndim=1, mode='c'] directions

    pIdxs = np.empty((ret_size,), dtype = ctypes.c_int)
    qIdxs = np.empty((ret_size,), dtype = ctypes.c_int)
    index_ds = np.empty((ret_size,), dtype = ctypes.c_double)
    directions = np.empty((ret_size,), dtype = ctypes.c_int)

    cdef int i, j, k
    print "Compute Data"

    for r in range():
        for i in prange(1, n, nogil=True, schedule="dynamic", chunksize=1):
            c_logd(i);
            for j in range(i, n):
                k = n * (i - 1) + j - i * (i - 1) / 2 - i
                pIdxs[k] = i
                qIdxs[k] = j
                index_ds[k] = c_index_d(distributions[i], distributions[j], weights[i], weights[j])
                directions[k] = c_direction(distributions[i], distributions[j])

    return (pIdxs, qIdxs, index_ds, directions)