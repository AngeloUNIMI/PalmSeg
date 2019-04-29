function binar = thresholdPalm(C, param)

[thres_single, em_single] = graythresh(C);
%Otsu's: find threshold that minimizes within-class variance
%Effectiveness: measure indicating the 'separability' of the classes
%if em_single >= th_em(1)
if em_single >= param.segm.th_em
    %otsu's threshold
    binar = imbinarize(C, thres_single + param.segm.thSegmRed);   
    %se la effectiveness è bassa proviamo a usare 2 soglie e combinare il
    %risultato
else %if em >= th_em
    [thres_multi, em_multi] = multithresh(C, 2);
    if em_multi > param.segm.th_em
        seg_I = imquantize(C, thres_multi + param.segm.thSegmRed);
        binar = (seg_I == 2) + (seg_I == 3);
        [~, num] = bwlabel(binar, 8);
        if num > param.segm.numCCbinar %troppo casino
            binar = imbinarize(C, thres_single);
        end %if num
    else %if em_multi
        binar = imbinarize(C, thres_single);
    end %if em_multi
    
    %     %if effectiveness multi is better than second thres (es. 0.90)
    %     if em_multi >= th_em(2)
    %         seg_I = imquantize(C,thres_multi);
    %         binar = (seg_I == 2) + (seg_I == 3);
    %     else %if em_multi >= th_em(2)
    %         %otherwise rever to single thresh
    %         binar = imbinarize(C, thres_single);
    %     end %if em_multi >= th_em(2)
    
end %if em >= th_em

%fix sum effects
binar(binar~=0) = 1;
binar = logical(binar);


%     figure, imshow(binar), pause