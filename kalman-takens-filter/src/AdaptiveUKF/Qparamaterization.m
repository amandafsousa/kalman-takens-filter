function Qest = Qparamaterization (CC, HF, HT, Q_reduction)
%Qparamaterization Estimate structured Q from vectorized C = vec (HF * Q * HT).
% Inputs:
%  CC: vectorized target (typically C(:)), size M^2-by-1;
%  HF, HT: linearization matrices, size (M-by-N) and (N-by-M);
%  Q_reduction: 2 = alpha*I, 3 = diagonal, 4 = cyclic, 5 = block (unsupported here).
% Output:
%  Qest: N-by-N estimated process noise covariance with the chosen structure.
% Notes:
%  Solves least squares systems for the parameter vector of Q under a chosen structure, using the identity: vec (HF * Q * HT) = (HT' ⊗ HF) vec(Q);
%  Implementations below avoid explicit Kronecker products by constructing basis matrices and stacking their images under HF * (.) * HT.
% Supported: 2 (alpha*I), 3 (diagonal), 4 (cyclic).
% Unsupported: 5 (block) is not implemented.

    [M, N] = size (HF);

    if (Q_reduction == 2) % Multiple of identity: Q = alpha * I_N
        BB = zeros (1, length (CC));
        temp1 = eye (N);
        temp1 = HF * temp1 * HT;
        BB (1,:) = temp1 (:);
        DD = BB' \ CC;
        Qest = DD * eye (N);
    end

    if (Q_reduction == 3) % Diagonal matrix
        BB = zeros (N, length (CC)); 
        for i = 1:N
            temp1 = zeros (N);
            temp1 (i,i) = 1;
            temp1 = HF * temp1 * HT;
            BB (i,:) = temp1 (:);
        end
        DD = BB' \ CC;
        Qest = zeros (N);
        for i = 1:N
            temp1 = zeros (N);
            temp1 (i,i) = DD (i);
            Qest = Qest + temp1;
        end
    end

    if (Q_reduction == 4) % Cyclic parameterization
        nParams = floor (N / 2) + 1;
        BB = zeros (nParams, length (CC));
        count = 0;
        for i = 1:nParams
            temp1 = zeros (N);
            Inds = 1:N;
            shiftInds = mod ((Inds + (i - 1)) - 1, N) + 1;
            temp1 (sub2ind ([N N], Inds, shiftInds)) = 1;
            temp1 (sub2ind ([N N], shiftInds, Inds)) = 1;
            temp1 = HF * temp1 * HT;
            count = count + 1;
            BB (count,:) = temp1(:);
        end
        DD = BB' \ CC;
        Qest = zeros (N, N);
        count = 0;
        for i = 1:nParams
            temp1 = zeros (N, N);
            Inds = 1:N;
            shiftInds = mod ((Inds + (i - 1)) - 1, N) + 1;
            count = count + 1;
            temp1 (sub2ind ([N N], Inds, shiftInds)) = DD (count);
            temp1 (sub2ind ([N N], shiftInds, Inds)) = DD (count);
            Qest = Qest + temp1;
        end
    end


    % Is not implemented
    if (Q_reduction == 5) % Block parameterization
        bs = ceil (N / M); % Block size
        BB = zeros (M ^ 2, length (CC));
        count = 0;
        for i = 1:M
            for j = i:M
                temp1 = zeros (N);
                temp1 ((i - 1) * bs + (1:bs), (j - 1) * bs + (1:bs)) = 1;
                temp1 ((j -1 ) * bs + (1:bs), (i - 1) * bs + (1:bs)) = 1;
                temp = HF * temp1 * HT;
                count = count + 1;
                BB (count,:) = temp (:);
            end
        end
        DD = BB' \ CC;
        Qest = Qdiag * eye (N);
        count = 0;
        for i = 1:M
            for j = i:M
                temp1 = zeros (N);
                count = count + 1;
                temp1 ((i - 1) * bs + (1:bs), (j - 1) * bs + (1:bs)) = DD (count);
                temp1 ((j - 1) * bs + (1:bs), (i - 1) * bs + (1:bs)) = DD (count);
                Qest = Qest + temp1;
            end
        end
    end
