function labels = weak_classify(X, h)
    labels=sign(h.parity * (X(h.idx, :)-h.theta));
end
