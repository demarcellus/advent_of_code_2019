1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function list = readTextFile(filename)
  
  input_file = fopen(filename);
  number_of_lines = fskipl(input_file, Inf);
  frewind(input_file);
  list = cell(number_of_lines, 1);
  for i = 1:number_of_lines
    list{i} = fscanf(input_file, '%s', 1);
  end
  fclose(input_file);
  
endfunction

% find object with no parents
function name = findMaster(input_list)
  
  parents = "";
  children = "";
  
  for i = 1:length(input_list)
    
    item = input_list{i}
    
    a = strsplit(item,")");
    
    par = a{1}
    if index(parents,par) == 0
      parents = strcat(parents,":",par);
    endif
    
    chi = a{2}
    if index(children,chi) == 0
      children = strcat(children,":",chi);
    endif
   
  endfor
  
  parents
  children
  
  name = "test";
    
endfunction


function [parents, children, parent_index, child_indices] = parseUniversalOrbitMap(input_list)
  
  parent_index = zeros(length(input_list),1);
  child_indices = zeros(length(input_list),1);
  
  for i = 1:length(input_list)
    
    item = input_list{i};
    a = strsplit(item,")");
    children{end+1} = a{2};
    parents{end+1} = a{1};
     
  endfor 
     
  for i = 1:length(children)
  
    for j = 1:length(children)
      
      if parents{i} == children{j}
        parent_index(i) = j;  
      endif
            
    endfor

  endfor
  
endfunction

function hops = countOrbits(start_index, parent_index)
  
  hops = 0;
  
  if(start_index != 0)
    hops += countOrbits(parent_index(start_index),parent_index) + 1;     
  endif
  
endfunction

function hops = countOrbitsUntil(start_index, end_index, parent_index)
  
  hops = 0;
  
  if(start_index != end_index)
    hops += countOrbitsUntil(parent_index(start_index),end_index,parent_index) + 1; 
  endif
  
endfunction

function list_out = makeJourney(list_in, start_index, children, parent_index)
  
  if(start_index != 0)
    list_out = strcat(makeYouJourney(list_in,parent_index(start_index),children,parent_index), ":", children{start_index});  
  endif
  
endfunction

function i = findFirstCommonWithJourney(journey,start_index, children, parent_index)
  
  i = start_index;
  
  while i != 0
      
    if index(journey,children{i}) == 0
      i = parent_index(i);      
    else
      break;
    endif
          
  endwhile
  
endfunction

function testExample()

  input_list = readTextFile("day_06_map_example.txt");
  [parents, children, parent_index, child_indices] = parseUniversalOrbitMap(input_list);

  sum = 0;
  for i = 1:length(children)
    sum += countOrbits(i,parent_index);
  endfor
  
  if(sum == 42)
    printf("example test: ok\r\n");
  else
    printf("example test: failed\r\n");
  endif
  
endfunction

function testTransfers()
  
  input_list = readTextFile("day_06_map_example_2.txt");
  [parents, children, parent_index, child_indices] = parseUniversalOrbitMap(input_list);
  
  you_journey = makeJourney(":",12,children,parent_index);
  
  common_index = findFirstCommonWithJourney(you_journey,13,children,parent_index);
  
  %printf("first common object: [%s]\r\n",children{common_index});
  
  you_hops = countOrbitsUntil(12,common_index,parent_index);
  %printf("YOU hops to common object: [%d]\r\n", you_hops);
  
  santa_hops = countOrbitsUntil(13,common_index,parent_index);
  %printf("SANTA hops to common object: [%d]\r\n", santa_hops); 
  
  you_santa_hops = you_hops + santa_hops - 2;
  %printf("YOU to SANTA orbit hops: [%d]\r\n", you_santa_hops); 
  
  if(you_santa_hops == 4)
    printf("transfers test: ok\r\n");
  else
    printf("transfers test: failed\r\n");
  endif
  
endfunction


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printf("Advent of Code - 2019 - day 06\r\n");
printf("part 1:\r\n");

testExample();

input_list = readTextFile("day_06_map_real.txt");
[parents, children, parent_index, child_indices] = parseUniversalOrbitMap(input_list);

sum = 0;
for i = 1:length(children)
  sum += countOrbits(i,parent_index);
endfor

%sum = 110190;

printf("result: [%d]\r\n",sum);

printf("part 2:\r\n");

testTransfers();

santa_index = 140;
you_index = 504;

input_list = readTextFile("day_06_map_real.txt");
[parents, children, parent_index, child_indices] = parseUniversalOrbitMap(input_list);
you_journey = makeJourney(":",you_index,children,parent_index);
common_index = findFirstCommonWithJourney(you_journey,santa_index,children,parent_index);
you_hops = countOrbitsUntil(you_index,common_index,parent_index);
santa_hops = countOrbitsUntil(santa_index,common_index,parent_index);
you_santa_hops = you_hops + santa_hops - 2;

%you_santa_hops = 343

printf("YOU to SANTA orbit hops: [%d]\r\n", you_santa_hops); 