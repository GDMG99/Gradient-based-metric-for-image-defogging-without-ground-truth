function ratio = metric(histo, bins)
sum_posi = sum(histo(interpole(bins)>0).*bins(interpole(bins)>0));
sum_neg = sum(histo(interpole(bins)<0).*abs(bins(interpole(bins)<0)));
ratio = (sum_posi-sum_neg)/(sum_posi+sum_neg);
end