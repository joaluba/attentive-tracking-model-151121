% clear all; clc

num_stim = input('How many stimuli do you want to make? ');

sr = 8000;

duration_ms = 2000; % mixture duration

rate = 0.6; % How fast should the trajectories change? (Hz)

des_min_dist = 5.5; % minimum distance between trajectories to enforce (ST, 3D)

n = 1;
 while n < num_stim+1
        
        for a = 1:2
            
            [score] = f0f1f2(duration_ms, rate);            
            scores(:,:,a)= score;
            
        end     
        
        [mindist,loc] = min_dist_calc(scores(:,:,1),scores(:,:,2));
        [crossing_ok] = crossing_calc(scores(:,:,1),scores(:,:,2));
        
        if mindist >= des_min_dist ...
                && loc > 250 ...
                && loc < length(score)-250 ...
                && crossing_ok == 1
    
           [p,f] = klatt_from_scores(scores); 
            
            stimuli_out{n,1} = p; % Correct-probe stimulus stored in column 1
            stimuli_out{n,2} = f; % Inorrect-probe stimulus ('foil') stored in column 2
            
            fprintf('Stimulus %d of %d successfully generated ... \n',n, num_stim);
            
             n=n+1;
    
        end

  
 

end
 save('Attentive_tracking_stimuli', 'stimuli_out');
 
 fprintf('\n Set of %d stimuli has been saved! \n\n', num_stim)
 
 ex_play=1;
 while ex_play ==1
     ex_play = input('Play a random stimulus from the set? 1 = Yes, 2 = Exit:  ');
     if ex_play==1
         
         r=randi(num_stim);
         rpf = randi(2);
         ex = stimuli_out{r,rpf};
         sound(ex,sr);
         resp = input('Is the probe from the cued voice? 1 = Yes, 2 = No:  ');
         
         if rpf==resp
             fprintf('Correct! \n');
         else
             fprintf('Incorrect... \n');
         end
         
         
     end
 end
 
 
 
 
 
 
 