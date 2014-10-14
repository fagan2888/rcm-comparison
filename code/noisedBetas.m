function betas = noisedBetas(betas)
    betas = betas + 0.25*betas.*randn(size(betas));
end
