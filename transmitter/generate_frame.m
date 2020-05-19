function b = generate_frame(frame_size, switch_graph)
  # Generate random samples
  b = randi([0 1], frame_size, 1);
  # Graphical output
  if switch_graph
    figure;
    hist(b);
  end
  
end