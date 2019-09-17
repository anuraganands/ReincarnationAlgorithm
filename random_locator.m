function r = random_locator(max)
    min = 1;
    r = min + (max - min)* rand(1);
    r = ceil(r);
end
