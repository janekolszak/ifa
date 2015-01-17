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
from libcpp.vector cimport vector
from libcpp cimport bool

from c_declarations cimport indexD as c_indexD
from c_declarations cimport direction as c_direction
from c_declarations cimport logger as c_logger
from c_declarations cimport transformIdx as c_transformIdx
from c_declarations cimport Distribution as CDistribution
from distribution cimport Distribution

from cython.parallel import prange

@cython.boundscheck(False)
cdef _compute_chunk(vector[CDistribution*] &distributionPtrs,
                    vector[double] &weights,
                    int i_min,
                    int i_max,
                    int n,
                    bool logOnScreen):
    cdef int ret_size = c_transformIdx(n, i_max-1, n-1) - c_transformIdx(n, i_min, i_min) + 1

    cdef np.ndarray[int, ndim=1, mode='c'] pIdxs
    cdef np.ndarray[int, ndim=1, mode='c'] qIdxs
    cdef np.ndarray[double, ndim=1, mode='c'] index_ds
    cdef np.ndarray[int, ndim=1, mode='c'] directions

    pIdxs = np.empty((ret_size,), dtype = ctypes.c_int)
    qIdxs = np.empty((ret_size,), dtype = ctypes.c_int)
    index_ds = np.empty((ret_size,), dtype = ctypes.c_double)
    directions = np.empty((ret_size,), dtype = ctypes.c_int)
    cdef int i, j, k

    for i in prange(i_min, i_max, nogil=True, schedule="dynamic", chunksize=1):
        if logOnScreen:
            c_logger(i)
        for j in range(i, n):
            k = c_transformIdx(n, i, j) - c_transformIdx(n, i_min, i_min)

            pIdxs[k] = i
            qIdxs[k] = j
            index_ds[k] = c_indexD(distributionPtrs[i],
                                   weights[i],
                                   distributionPtrs[j],
                                   weights[j])

            directions[k] = c_direction(distributionPtrs[i],
                                        distributionPtrs[j])

    return (pIdxs, qIdxs, index_ds, directions)


@cython.boundscheck(False)
def compute(distributions, vector[double] weights, int chunkSize, logOnScreen = True):
    cdef int n = len(distributions)
    cdef int ret_size = (n - 1) * n / 2

    cdef vector[CDistribution*] distributionPtrs
    for d in distributions:
        distributionPtrs.push_back((<Distribution?>d).thisptr)

    if logOnScreen:
        print "Compute Data"

    for i_min in range(0, n, chunkSize):
        i_max = min(i_min + chunkSize, n)
        if logOnScreen:
            print "Computing from", i_min/float(n) * 100, "% to", i_max/float(n) * 100, "%"
        yield _compute_chunk(distributionPtrs, weights, i_min, i_max, n, logOnScreen)

