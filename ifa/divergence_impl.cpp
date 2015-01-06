/*
The MIT License (MIT)

Copyright (c) 2014 Jan Olszak (j.olszak@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#include "divergence_impl.hpp"
#include <cmath>

namespace ifa {

double jsd(const std::vector<Distribution> &distributions,
           const std::vector<double> &weights)
{
    auto sumDist = distributions[0];
    for (auto it = sumDist.dist.begin();
            it != sumDist.dist.end();
            ++it) {

        it->second *=  weights[0];
    }


    for (unsigned i = 1; i < distributions.size(); ++i) {
        for (auto it = distributions[i].dist.begin();
                it != distributions[i].dist.end();
                ++it) {

            sumDist.dist[it->first] += it->second * weights[i];
        }
    }

    double entropySum = 0;
    for (unsigned i = 0; i < distributions.size(); ++i) {
        entropySum += distributions[i].entropy() * weights[i];
    }

    return sumDist.entropy() - entropySum;
}

double jsd(const Distribution *p,
           const double p_weight,
           const Distribution *q,
           const double q_weight)
{
    Distribution sumDist = *p;
    for (auto it = sumDist.dist.begin();
            it != sumDist.dist.end();
            ++it) {

        it->second *=  p_weight;
    }

    for (auto it = q->dist.begin(); it != q->dist.end(); ++it) {
        sumDist.dist[it->first] += it->second * q_weight;
    }

    double entropySum = p->entropy() * p_weight + q->entropy() * q_weight;

    return sumDist.entropy() - entropySum;
}

double indexD(const Distribution *p,
              const double p_weight,
              const Distribution *q,
              const double q_weight)
{
    double wp = p_weight / (p_weight + q_weight);
    double wq = q_weight / (p_weight + q_weight);
    double d = jsd(p, wp, q, wq);
    return d / (-wp * std::log2(wp) - wq * std::log2(wq));
}

} // namespace ifa
