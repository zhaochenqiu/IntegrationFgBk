function [pvalue nvalue] = balanceCues_plus(cuesimg)


% fgcues ->palue
% bkcues ->nvalue



[row_im column_im byte_im] = size(cuesimg);



indexfg = cuesimg > 0;
indexbk = cuesimg < 0;

fgnum = sum(sum(sum(indexfg)));
bknum = sum(sum(sum(indexbk)));

maxnum = max([fgnum bknum]);
maxnum = fgnum;

pvalue = (maxnum/fgnum)*(255);
nvalue = (maxnum/bknum)*(-255);

if fgnum < 10
    pvalue = 255;
end

if bknum < 10
    nvalue = -255;
end
