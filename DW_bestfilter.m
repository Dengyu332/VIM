plot(no_macro_lfp.time{1},no_macro_lfp.trial{1}(1,:))

hold on;
plot(no_macro_lfp_orig.time{1},no_macro_lfp_orig.trial{1}(1,:))

figure;
plot(no_macro.time{1},no_macro.trial{1}(1,:))

hold on;plot(no_macro_slave.time{1},no_macro_slave.trial{1}(1,:))




figure;
plot(no_macro.time{1},no_macro.trial{1}(1,:))

hold on;plot(no_macro_lfp_orig.time{1},no_macro_lfp_orig.trial{1}(1,:))


figure;
plot(no_macro_orig.time{1},no_macro_orig.trial{1}(1,:))

hold on;plot(no_macro_lfp_orig.time{1},no_macro_lfp_orig.trial{1}(1,:))



figure;
plot(downsample(no_macro_orig.time{1},44),no_macro_rs(:,1))

aa = linspace(min(no_macro_lfp_orig.time{1}),max(no_macro_lfp_orig.time{1}),round(length(no_macro_lfp_orig.time{1})*1000/1375));
hold on;plot(aa,no_macro_lfp_rs(1:end-1,1))





no_macro_rs = resample(no_macro_orig.trial{1}',1000,44000);

no_macro_lfp_rs = resample(no_macro_lfp_orig.trial{1}',1000,1375);

plot(no_macro_lfp.time{1},no_macro_lfp_rs(1:end-1,1)');

hold on;plot(no_macro_orig.time{1},no_macro_orig.trial{1}(1,:))

hold on;plot(no_macro(:,1))

hold on;plot(no_macro_rs(:,1))
hold on;plot(no_macro_lfp_rs(:,1))


