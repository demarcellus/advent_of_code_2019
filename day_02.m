1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function intCode1(a, b, o)  
  
  global intcode;
  
  intcode(o + 1) = intcode(a + 1) + intcode(b + 1);
  
endfunction

function intCode2(a, b, o)  
  
  global intcode;
  
  intcode(o + 1) = intcode(a + 1) * intcode(b + 1);
  
endfunction

function parseIntCode()
  
  global intcode;
  
  pc = 0;
  
  while(intcode(pc + 1) != 99)
  
    if intcode(pc + 1) == 1
      intCode1(intcode(pc + 2), intcode(pc + 3), intcode(pc + 4)); 
      pc += 4;
    elseif intcode(pc + 1) == 2
      intCode2(intcode(pc + 2), intcode(pc + 3), intcode(pc + 4)); 
      pc += 4;
    endif
      
  end
  
endfunction

function testIntCode()
  
  global intcode;
  
  test_input = {[1,9,10,3,2,3,11,0,99,30,40,50],
                 [1,0,0,0,99],
                 [2,3,0,3,99],
                 [2,4,4,5,99,0],
                 [1,1,1,4,99,5,6,0,99]};
  test_output = {[3500,9,10,70,2,3,11,0,99,30,40,50],
                 [2,0,0,0,99],
                 [2,3,0,6,99],
                 [2,4,4,5,99,9801],
                 [30,1,1,4,2,5,6,0,99]};
  
  passed = 0;
  
  for i = 1:5
    
    intcode = test_input{i};
    parseIntCode();
    
    if intcode == test_output{i}
      passed += 1;
    endif
    
  endfor
  
  if(passed == 5)
    printf("intcode test: ok\r\n");
  else
    printf("intcode test: failed\r\n");
  endif
  
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global intcode;

printf("Advent of Code - 2019 - day 02\r\n");
printf("part 1:\r\n");

testIntCode();

input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,6,19,23,2,6,23,27,1,5,27,31,2,31,9,35,1,35,5,39,1,39,5,43,1,43,10,47,2,6,47,51,1,51,5,55,2,55,6,59,1,5,59,63,2,63,6,67,1,5,67,71,1,71,6,75,2,75,10,79,1,79,5,83,2,83,6,87,1,87,5,91,2,9,91,95,1,95,6,99,2,9,99,103,2,9,103,107,1,5,107,111,1,111,5,115,1,115,13,119,1,13,119,123,2,6,123,127,1,5,127,131,1,9,131,135,1,135,9,139,2,139,6,143,1,143,5,147,2,147,6,151,1,5,151,155,2,6,155,159,1,159,2,163,1,9,163,0,99,2,0,14,0];

intcode = input;
intcode(1 + 1) = 12;
intcode(2 + 1) = 2;

parseIntCode();

printf("value @ 0: [%d]\r\n",intcode(0 + 1));

printf("part 2:\r\n");

cont = 1;

for noun = 0:99
  
  for verb = 0:99
    
    printf("testing [%d][%d] (%d%%)\r\n",noun,verb,((noun * 100)+verb)/100);
    fflush(stdout);
    
    intcode = input;
    intcode(1 + 1) = noun;
    intcode(2 + 1) = verb;
    
    parseIntCode();
    
    output = intcode(0 + 1);
    
    if(output == 19690720)
      cont = 0;
      output_noun = noun;
      output_verb = verb;
    endif
    
    if cont == 0
      break;
    endif
        
  endfor
  
  if cont == 0
    break;
  endif
  
endfor

printf("noun: [%d]\r\n",output_noun);
printf("verb: [%d]\r\n",output_verb);

printf("100 x noun + verb: [%d]\r\n",(100*output_noun) + output_verb);