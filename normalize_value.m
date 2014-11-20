function result = normalize_value(value, min, max)
    result = (value-min)/(max-min);
    if result>1
        result = 1;
    end
end