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

#include "distribution_impl.hpp"
#include <cmath>
#include <stdexcept>
#include <memory>

namespace ifa {

namespace {
inline
int negSign(double x)
{
    return (x > 0) ? -1 : ((x < 0) ? 1 : 0);
}
} // namespace

Distribution::Distribution()
{

}

Distribution::~Distribution()
{

}

void Distribution::normalize()
{
    double sum = 0;
    for (const auto &entry : dist) {
        sum += entry.second;
    }

    for (auto &entry : dist) {
        entry.second /= sum;
    }
}

unsigned int Distribution::size() const
{
    return dist.size();
}

bool Distribution::isEmpty() const
{
    return dist.empty();
}

bool Distribution::contains(const std::string &event) const
{
    return static_cast<bool>(dist.count(event));
}

double Distribution::get(const std::string &event) const
{
    return dist.at(event);
}

void Distribution::set(const std::string &event, const double probability)
{
    dist[event] = probability;
}

void Distribution::erase(const std::string &event)
{
    dist.erase(event);
}

void Distribution::insert(const std::string &event, const double probability)
{
    dist.emplace(event, probability);
}

void Distribution::startIteration()
{
    m_it = dist.begin();
}

std::pair<std::string, double> Distribution::next()
{
    if (m_it == dist.end()) {
        throw std::out_of_range("End of sequence");
    }

    return *(m_it++);
}

double Distribution::entropy() const
{
    double entropy = 0;

    for (const auto &entry : dist) {
        entropy += entry.second * std::log2(entry.second);
    }

    return -1 * entropy;
}


void common(const Distribution *p, const Distribution *q, Distribution *result)
{
    for (const auto &entry : p->dist) {
        if (q->contains(entry.first)) {
            result->set(entry.first, entry.second);
        }
    }

    result->normalize();
}

int direction(const Distribution *p, const Distribution *q)
{
    std::unique_ptr<Distribution> cP (new Distribution());
    common(p, q, cP.get());

    if (cP->isEmpty()) {
        return 0;
    }

    std::unique_ptr<Distribution> cQ(new Distribution());
    common(q, p, cQ.get());

    double tp = cP->entropy() / (cP->size() / p->size());
    double tq = cQ->entropy() / (cQ->size() / q->size());

    return negSign(tp - tq);
}

} // namespace ifa