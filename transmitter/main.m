clear all; close all;
%https://www.gaussianwaves.com/2008/05/construction-of-hamming-codes-using-matrix/
frame_size = 1000;
switch_graph = 1;

b = generate_frame(frame_size, switch_graph);

#c = encode_hamming(b, 0, 0, 0)


parity_check_matrix = [1 0 1 0 1 0 1;
                        0 1 1 0 0 1 1;
                        0 0 0 1 1 1 1];
     
k_prtyBits = size(parity_check_matrix,1);
N_totBits = size(parity_check_matrix, 2);
n_dataBits = N_totBits - k_prtyBits;


% Reorder columns of parity check matrix H to normal H = (A|Eye)
swap = zeros(k_prtyBits,1);
for ii=1:k_prtyBits
  eye_H = eye(k_prtyBits);
  column = find(ismember(parity_check_matrix.',eye_H(ii,:),'rows'));
  tmp = parity_check_matrix(:,N_totBits-length(eye_H)+(ii));
  parity_check_matrix(:,N_totBits-length(eye_H)+(ii)) = eye_H(:,ii);
  parity_check_matrix(:,column) = tmp;
  swap(ii) = column;
end

% Calculate G = (Eye|A.T)
G = [eye(n_dataBits); parity_check_matrix(:,1:n_dataBits)].';
G
for jj=1:length(swap)
  tmp = G(:,swap(jj));
  G(:,swap(jj)) = G(:,N_totBits-length(eye_H)+(jj));
  G(:,N_totBits-length(eye_H)+(jj)) = tmp;
  G
end



     
%G = [1 0 0 1 1 0 0;	
%     0 1 0 1 0 1 0;
%     1 1 1 0 0 0 0;
%     1 1 0 1 0 0 1];
     
%z=G*H.';

%A = [1 1 0 0;
%     1 1 0 1;
%     0 1 1 1;
%     0 0 1 0;
%     0 0 0 1];