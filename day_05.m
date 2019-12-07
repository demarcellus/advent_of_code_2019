1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%add
function pc_out = intCode1(pc)  
  
  global intcode;
  
  s = sprintf("%05d",intcode(pc + 1));
  
  if s(3) == '1'
    p1 = intcode(pc + 2);
  else
    p1 = intcode(intcode(pc + 2) + 1);
  endif
  
  if s(2) == '1'
    p2 = intcode(pc + 3);
  else
    p2 = intcode(intcode(pc + 3) + 1);
  endif
  
  intcode(intcode(pc + 4) + 1) = p1 + p2;
  
  pc_out = pc + 4;
  
endfunction

%multiply
function pc_out = intCode2(pc)
  
  global intcode;
  
  s = sprintf("%05d",intcode(pc + 1));
  
  if s(3) == '1'
    p1 = intcode(pc + 2);
  else
    p1 = intcode(intcode(pc + 2) + 1);
  endif
  
  if s(2) == '1'
    p2 = intcode(pc + 3);
  else
    p2 = intcode(intcode(pc + 3) + 1);
  endif
  
  intcode(intcode(pc + 4) + 1) = p1 * p2;
  
  pc_out = pc + 4;
  
endfunction

%input
function pc_out = intCode3(pc)
  
  global intcode;
  global var_input;
  
  intcode(intcode(pc + 2) + 1) = var_input;
  
  pc_out = pc + 2;
  
endfunction

%output
function pc_out = intCode4(pc)
  
  global intcode;
  global var_output;
  global halt;

  s = sprintf("%05d",intcode(pc + 1));
  
  if s(3) == '1'
    p1 = intcode(pc + 2);
  else
    p1 = intcode(intcode(pc + 2) + 1);
  endif
  
  tmp = p1;
  
%  if(tmp != 0)
%    halt = 1;  
%  endif
  
  var_output = [var_output, tmp];
  
  pc_out = pc + 2;
  
endfunction

%jump if true
function pc_out = intCode5(pc)
  
  global intcode;

  s = sprintf("%05d",intcode(pc + 1));
  
  if s(3) == '1'
    p1 = intcode(pc + 2);
  else
    p1 = intcode(intcode(pc + 2) + 1);
  endif
  
  if s(2) == '1'
    p2 = intcode(pc + 3);
  else
    p2 = intcode(intcode(pc + 3) + 1);
  endif

  if(p1 != 0)
    pc_out = p2;
  else
    pc_out = pc + 3;
  endif
  
endfunction

%jump if false
function pc_out = intCode6(pc)
  
  global intcode;

  s = sprintf("%05d",intcode(pc + 1));
  
  if s(3) == '1'
    p1 = intcode(pc + 2);
  else
    p1 = intcode(intcode(pc + 2) + 1);
  endif
  
  if s(2) == '1'
    p2 = intcode(pc + 3);
  else
    p2 = intcode(intcode(pc + 3) + 1);
  endif
  
  if(p1 == 0)
    pc_out = p2;
  else
    pc_out = pc + 3;
  endif
  
endfunction

% less then
function pc_out = intCode7(pc)
  
  global intcode;
  
  s = sprintf("%05d",intcode(pc + 1));
  
  if s(3) == '1'
    p1 = intcode(pc + 2);
  else
    p1 = intcode(intcode(pc + 2) + 1);
  endif
  
  if s(2) == '1'
    p2 = intcode(pc + 3);
  else
    p2 = intcode(intcode(pc + 3) + 1);
  endif
  
  if(p1 < p2)
    intcode(intcode(pc + 4) + 1) = 1;
  else
    intcode(intcode(pc + 4) + 1) = 0;
  endif
  
  pc_out = pc + 4;
  
endfunction

%equals
function pc_out = intCode8(pc)
  
  global intcode;
  
  s = sprintf("%05d",intcode(pc + 1));
  
  if s(3) == '1'
    p1 = intcode(pc + 2);
  else
    p1 = intcode(intcode(pc + 2) + 1);
  endif
  
  if s(2) == '1'
    p2 = intcode(pc + 3);
  else
    p2 = intcode(intcode(pc + 3) + 1);
  endif
  
  if(p1 == p2)
    intcode(intcode(pc + 4) + 1) = 1;
  else
    intcode(intcode(pc + 4) + 1) = 0;
  endif
 
  pc_out = pc + 4;
  
endfunction

function debugInstruction(pc)
 
  global intcode;
 
  s = sprintf("%05d",intcode(pc + 1));
  opcode_s = s(4:5);
  opcode = str2num(s);
  
  printf("%s:",opcode_s);
  
  switch opcode
    case 1
      length = 4;
    case 2
      length = 4;
    case 3
      length = 2;
    case 4
      length = 2;
    case 5
      length = 3;
    case 6
      length = 3;
    case 7
      length = 4;
    case 8
      length = 4;
    case 99
      printf("\r\n");
      return
    otherwise
      length = 1;
  endswitch 
  
  if(length >= 2)
    
    if s(3) == '1'
      printf("I[%d]",intcode(pc + 2));
    else
      printf("P[@%d][%d]",intcode(pc + 2),intcode(intcode(pc + 2) + 1));
    endif
    
  endif
  
  if(length >= 3)
   
    if s(2) == '1'
      printf("I[%d]",intcode(pc + 3));
    else
      printf("P[@%d][%d]",intcode(pc + 3),intcode(intcode(pc + 3) + 1));
    endif
   
  endif
  
  if(length == 4)
   
    if s(1) == '1'
      printf("I[%d]",intcode(pc + 4));
    else
      printf("P[@%d][%d]",intcode(pc + 4),intcode(intcode(pc + 4) + 1));
    endif
   
  endif
 
  printf("\r\n");  
 
endfunction


function parseIntCode()
  
  global intcode;
  global halt;
  
  pc = 0;
  halt = 0;
  iterations = 0;
  
  while(1)
  
    s = sprintf("%05d",intcode(pc + 1));
    s = s(4:5);
    opcode = str2num(s);
  
    %debugInstruction(pc);
  
    switch opcode
      case 1
        pc = intCode1(pc);
      case 2
        pc = intCode2(pc);
      case 3
        pc = intCode3(pc);
      case 4
        pc = intCode4(pc);
      case 5
        pc = intCode5(pc);
      case 6
        pc = intCode6(pc);
      case 7
        pc = intCode7(pc);
      case 8
        pc = intCode8(pc);
      
      case 99
        break
      otherwise
        printf("ERROR: opcode does not exist yet!\r\n");
        return
    endswitch         
    
    if(halt == 1)
      printf("PROGRAM HALTED\r\n");
      return
    endif
    
    %if(iterations > 10)
    %  printf("ITERATION OVERLOAD\r\n");
    %  return
    %endif
    
    iterations++;
        
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
  
  for i = 1:length(test_input)
  
    intcode = test_input{i};
    parseIntCode();
    
    if intcode == test_output{i}
      passed += 1;
    endif
    
  endfor
  
  if(passed == length(test_input))
    printf("intcode test: ok\r\n");
  else
    printf("intcode test: failed\r\n");
  endif
  
endfunction

function testIntCode2()
  
  global intcode;
  global var_input;
  global var_output;
  
  test_input = { [3,9,8,9,10,9,4,9,99,-1,8],
                 [3,9,7,9,10,9,4,9,99,-1,8],
                 [3,3,1108,-1,8,3,4,3,99],
                 [3,3,1107,-1,8,3,4,3,99]};
  
  passed = 0;
  
  % POS equals tests
  %printf("\r\nPOS equals test\r\n");
  
  var_input = 8;
  var_output = [];
  intcode = [3,9,8,9,10,9,4,9,99,-1,8];
  parseIntCode();
  if(var_output == 1)
    passed++;
  endif
   
  var_input = 5;
  var_output = [];
  intcode = [3,9,8,9,10,9,4,9,99,-1,8];
  parseIntCode();
  if(var_output == 0)
    passed++;
  endif
  
  % POS less than tests
  %printf("\r\nPOS less than test\r\n");
  
  var_input = 8;
  var_output = [];
  intcode = [3,9,7,9,10,9,4,9,99,-1,8];
  parseIntCode();
  if(var_output == 0)
    passed++;
  endif
  
  var_input = 5;
  var_output = [];
  intcode = [3,9,7,9,10,9,4,9,99,-1,8];
  parseIntCode();
  if(var_output == 1)
    passed++;
  endif
  
  % IMM equals tests
  %printf("\r\nIMM equals test\r\n");
   
  var_input = 8;
  var_output = [];
  intcode = [3,3,1108,-1,8,3,4,3,99];
  parseIntCode();
  if(var_output == 1)
    passed++;
  endif
  
  var_input = 5;
  var_output = [];
  intcode = [3,3,1108,-1,8,3,4,3,99];
  parseIntCode();
  if(var_output == 0)
    passed++;
  endif
  
  % IMM less than tests
  %printf("\r\nIMM less than test\r\n");
  
  var_input = 8;
  var_output = [];
  intcode = [3,3,1107,-1,8,3,4,3,99];
  parseIntCode();
  if(var_output == 0)
    passed++;
  endif
  
  var_input = 5;
  var_output = [];
  intcode = [3,3,1107,-1,8,3,4,3,99];
  parseIntCode();
  if(var_output == 1)
    passed++;
  endif 
  
  % POS jump
  %printf("\r\nPOS jump test\r\n");
  
  var_input = 0;
  var_output = [];
  intcode = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9];
  parseIntCode();
  if(var_output == 0)
    passed++;
  endif
 
  var_input = 5;
  var_output = [];
  intcode = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9];
  parseIntCode();
  if(var_output == 1)
    passed++;
  endif   
  
  % IMM jump
  %printf("\r\nIMM jump test\r\n");
  
  var_input = 0;
  var_output = [];
  intcode = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1];
  parseIntCode();
  if(var_output == 0)
    passed++;
  endif
  
  var_input = 5;
  var_output = [];
  intcode = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1];
  parseIntCode();
  if(var_output == 1)
    passed++;
  endif   
  
  if(passed == 12)
    printf("intcode test 2: ok\r\n");
  else
    printf("intcode test 2: failed\r\n");
  endif
  
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

global intcode;

global var_input;
global var_output;

global halt;

printf("Advent of Code - 2019 - day 05\r\n");
printf("part 1:\r\n");

testIntCode();

input = [3,225,1,225,6,6,1100,1,238,225,104,0,1101,37,61,225,101,34,121,224,1001,224,-49,224,4,224,102,8,223,223,1001,224,6,224,1,224,223,223,1101,67,29,225,1,14,65,224,101,-124,224,224,4,224,1002,223,8,223,101,5,224,224,1,224,223,223,1102,63,20,225,1102,27,15,225,1102,18,79,224,101,-1422,224,224,4,224,102,8,223,223,1001,224,1,224,1,223,224,223,1102,20,44,225,1001,69,5,224,101,-32,224,224,4,224,1002,223,8,223,101,1,224,224,1,223,224,223,1102,15,10,225,1101,6,70,225,102,86,40,224,101,-2494,224,224,4,224,1002,223,8,223,101,6,224,224,1,223,224,223,1102,25,15,225,1101,40,67,224,1001,224,-107,224,4,224,102,8,223,223,101,1,224,224,1,223,224,223,2,126,95,224,101,-1400,224,224,4,224,1002,223,8,223,1001,224,3,224,1,223,224,223,1002,151,84,224,101,-2100,224,224,4,224,102,8,223,223,101,6,224,224,1,224,223,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,108,677,677,224,1002,223,2,223,1006,224,329,101,1,223,223,1107,677,226,224,102,2,223,223,1006,224,344,101,1,223,223,8,677,677,224,1002,223,2,223,1006,224,359,101,1,223,223,1008,677,677,224,1002,223,2,223,1006,224,374,101,1,223,223,7,226,677,224,1002,223,2,223,1006,224,389,1001,223,1,223,1007,677,677,224,1002,223,2,223,1006,224,404,1001,223,1,223,7,677,677,224,1002,223,2,223,1006,224,419,1001,223,1,223,1008,677,226,224,1002,223,2,223,1005,224,434,1001,223,1,223,1107,226,677,224,102,2,223,223,1005,224,449,1001,223,1,223,1008,226,226,224,1002,223,2,223,1006,224,464,1001,223,1,223,1108,677,677,224,102,2,223,223,1006,224,479,101,1,223,223,1108,226,677,224,1002,223,2,223,1006,224,494,1001,223,1,223,107,226,226,224,1002,223,2,223,1006,224,509,1001,223,1,223,8,226,677,224,102,2,223,223,1006,224,524,1001,223,1,223,1007,226,226,224,1002,223,2,223,1006,224,539,1001,223,1,223,107,677,677,224,1002,223,2,223,1006,224,554,1001,223,1,223,1107,226,226,224,102,2,223,223,1005,224,569,101,1,223,223,1108,677,226,224,1002,223,2,223,1006,224,584,1001,223,1,223,1007,677,226,224,1002,223,2,223,1005,224,599,101,1,223,223,107,226,677,224,102,2,223,223,1005,224,614,1001,223,1,223,108,226,226,224,1002,223,2,223,1005,224,629,101,1,223,223,7,677,226,224,102,2,223,223,1005,224,644,101,1,223,223,8,677,226,224,102,2,223,223,1006,224,659,1001,223,1,223,108,677,226,224,102,2,223,223,1005,224,674,1001,223,1,223,4,223,99,226];

%input is the air conditioner unit id
%var_input = 1;

%intcode = input;

%halt = 0;
%parseIntCode();

%var_output

printf("part 2:\r\n");

testIntCode2();

%input is the thermal radiator controller id
var_input = 5;
var_output = [];
intcode = input;

parseIntCode();

var_output