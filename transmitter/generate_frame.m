function b = generate_frame(frame_size, switch_graph)
  b = randi([0 1], frame_size, 1);
  if switch_graph
    hist(b);
  end
  
end