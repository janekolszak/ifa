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
import numpy as np
cimport numpy as np
from libcpp.vector cimport vector

from c_declarations cimport jsd as c_jsd
from c_declarations cimport indexD as c_indexD
from c_declarations cimport direction as c_direction
from c_declarations cimport logger as c_logger
from c_declarations cimport Distribution as CDistribution
from distribution cimport Distribution
# from ifa.distribution import Distribution, direction

from cython.parallel import prange

# @cython.boundscheck(False)
# cpdef jsd(np.ndarray[np.double_t, ndim=1, mode='c'] probabilities):
#     return c_jsd(<double*> probabilities.data, probabilities.size)

# @cython.boundscheck(False)

# cpdef jsd(distributions, vector[double] weights):
#     cdef vector[CDistribution] dist
#     cdef CDistribution p
#     dist.push_back(p)
#     # for d in distributions:
#     #     dist.push_back(<CDistribution> d.thisptr)

#     return c_jsd(dist, weights)

cpdef jsd(p, double p_weight, q, double q_weight):
    return c_jsd((<Distribution?>p).thisptr, p_weight,
                 (<Distribution?>q).thisptr, q_weight)

cpdef indexD(p, double p_weight, q, double q_weight):
    return c_indexD((<Distribution?>p).thisptr, p_weight,
                    (<Distribution?>q).thisptr, q_weight)


def compute_data(distributions, vector[double] weights, int chunkSize):
    cdef int n = distributions.size()
    cdef int ret_size = (n - 1) * n / 2

    cdef vector[CDistribution*] distributionPtrs
    for d in distributions:
        distributionPtrs.push_back((<Distribution?>d).thisptr)

    # cdef np.ndarray[int, ndim=1, mode='c'] pIdxs
    # cdef np.ndarray[int, ndim=1, mode='c'] qIdxs
    # cdef np.ndarray[double, ndim=1, mode='c'] index_ds
    # cdef np.ndarray[int, ndim=1, mode='c'] directions

    # pIdxs = np.empty((ret_size,), dtype = ctypes.c_int)
    # qIdxs = np.empty((ret_size,), dtype = ctypes.c_int)
    # index_ds = np.empty((ret_size,), dtype = ctypes.c_double)
    # directions = np.empty((ret_size,), dtype = ctypes.c_int)

    print "Compute Data"
    cdef int i, j, r, last
    cdef vector[int] pIdxs
    cdef vector[int] qIdxs
    cdef vector[double] index_ds
    cdef vector[int] directions

    for r in range(0, n, chunkSize):
        pIdxs.clear()
        qIdxs.clear()
        index_ds.clear()
        directions.clear()
        last = np.min(r + chunkSize, n)
        for i in prange(r, last, nogil=True, schedule="dynamic", chunksize=1):
            c_logger(i/n)
            for j in range(i, n):
    # #             k = n * (i - 1) + j - i * (i - 1) / 2 - i
                pIdxs.push_back(i)
                qIdxs.push_back(j)
                index_ds.push_back(c_indexD(distributionPtrs[i],
                                            weights[i],
                                            distributionPtrs[j],
                                            weights[j]))
                directions.push_back(c_direction(distributionPtrs[i],
                                                 distributionPtrs[j]))

        yield (pIdxs, qIdxs, index_ds, directions)