function c_hat = detect_symbols(d_bar, constellation_order, switch_graph)
  if isempty(d_bar)
     c_hat = []; 
  else
     % Normalization factor
     qnorm = sqrt(2*(2^constellation_order-1)/3);
     % QAM demod -- offset/rescale and round values, DEC to BIN conversion, 
     switch constellation_order
       case 2
         I = round((real(d_bar)*qnorm+1)/2);
         Q = round((imag(d_bar)*qnorm+1)/2);
         I(I>1) = 1;
         Q(Q>1) = 1;
         I(I<0) = 0;
         Q(Q<0) = 0;
         c_hat = [de2bi(round(I), 1, 'left-msb') de2bi(round(Q), 1, 'left-msb')];
       case 4
         G = inv([1 1;
                  0 1]);
         I = round((real(d_bar)*qnorm+3)/2);
         Q = round((imag(d_bar)*qnorm+3)/2);
         I(I>3) = 3;
         Q(Q>3) = 3;
         I(I<0) = 0;
         Q(Q<0) = 0;
         c_hat = [de2bi(round(I), 2, 'left-msb') de2bi(round(Q), 2, 'left-msb')];
         c_hat = [mod(c_hat(:,1:end/2)*G, 2) mod(c_hat(:,end/2+1:end)*G, 2)];
       case 6
         G = inv([1 1 1;
            0 1 1;
            0 0 1]);
         I = round((real(d_bar)*qnorm+7)/2);
         Q = round((imag(d_bar)*qnorm+7)/2);
         I(I>7) = 7;
         Q(Q>7) = 7;
         I(I<0) = 0;
         Q(Q<0) = 0;
         c_hat = [de2bi(round(I), 3, 'left-msb') de2bi(round(Q), 3, 'left-msb')];
         c_hat = [mod(c_hat(:,1:end/2)*G, 2) mod(c_hat(:,end/2+1:end)*G, 2)];
    end
    c_hat = c_hat';
    c_hat = c_hat(:);
    % Ugly graphical output
    if switch_graph
      figure;
      a = 1.2;
      switch constellation_order
          case 2
              line([-a,a],[0,0],'LineStyle','--');
              hold on;
              line([0,0],[-a,a],'LineStyle','--');
          case 4
              x1 = 1/qnorm *2;
              line([-a,a],[0,0],'LineStyle','--');
              hold on;
              line([0,0],[-a,a],'LineStyle','--');
              hold on;
              line([-a,a],[x1,x1],'LineStyle','--');
              hold on;
              line([-a,a],[-x1,-x1],'LineStyle','--');
              hold on;
              line([x1,x1],[-a,a],'LineStyle','--');
              hold on;
              line([-x1,-x1],[-a,a],'LineStyle','--');
          case 6
              x1 = 1/qnorm *2;
              x2 = 1/qnorm *4;
              x3 = 1/qnorm *6;
              line([-a,a],[0,0],'LineStyle','--');
              hold on;
              line([0,0],[-a,a],'LineStyle','--');
              hold on;
              line([-a,a],[x1,x1],'LineStyle','--');
              hold on;
              line([-a,a],[-x1,-x1],'LineStyle','--');
              hold on;
              line([x1,x1],[-a,a],'LineStyle','--');
              hold on;
              line([-x1,-x1],[-a,a],'LineStyle','--');
              hold on;
              line([-a,a],[x2,x2],'LineStyle','--');
              hold on;
              line([-a,a],[-x2,-x2],'LineStyle','--');
              hold on;
              line([x2,x2],[-a,a],'LineStyle','--');
              hold on;
              line([-x2,-x2],[-a,a],'LineStyle','--');
              hold on;
              line([-a,a],[x3,x3],'LineStyle','--');
              hold on;
              line([-a,a],[-x3,-x3],'LineStyle','--');
              hold on;
              line([x3,x3],[-a,a],'LineStyle','--');
              hold on;
              line([-x3,-x3],[-a,a],'LineStyle','--');
      end
      hold on;
      plot(real(d_bar), imag(d_bar), 'o');
      TitleString = sprintf('%d-QAM Demodulation', 2^constellation_order);
      title(TitleString);
      xlim([-1.2,1.2]);
      ylim([-1.2,1.2]);
    end
  end
end

      
