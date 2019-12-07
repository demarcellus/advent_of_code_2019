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
  global var_input_index;
  
  intcode(intcode(pc + 2) + 1) = var_input(min(var_input_index,length(var_input)));
  var_input_index++;
  
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
  
  if(tmp != 0)
    halt = 1;  
  endif
  
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


function pc_out = parseIntCode(pc_in)
  
  global intcode;
  global halt;
  global var_input_index;
  
  pc = pc_in;
  halt = 0;
  iterations = 0;
  var_input_index = 1;
  
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
        pc_out = pc;
        break
      otherwise
        printf("ERROR: opcode does not exist yet!\r\n");
        return
    endswitch         
  
    pc_out = pc;
  
    if(halt == 1)
      %printf("PROGRAM OUTPUT HALTED\r\n");
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
    parseIntCode(0);
    
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
  parseIntCode(0);
  if(var_output == 1)
    passed++;
  endif
   
  var_input = 5;
  var_output = [];
  intcode = [3,9,8,9,10,9,4,9,99,-1,8];
  parseIntCode(0);
  if(var_output == 0)
    passed++;
  endif
  
  % POS less than tests
  %printf("\r\nPOS less than test\r\n");
  
  var_input = 8;
  var_output = [];
  intcode = [3,9,7,9,10,9,4,9,99,-1,8];
  parseIntCode(0);
  if(var_output == 0)
    passed++;
  endif
  
  var_input = 5;
  var_output = [];
  intcode = [3,9,7,9,10,9,4,9,99,-1,8];
  parseIntCode(0);
  if(var_output == 1)
    passed++;
  endif
  
  % IMM equals tests
  %printf("\r\nIMM equals test\r\n");
   
  var_input = 8;
  var_output = [];
  intcode = [3,3,1108,-1,8,3,4,3,99];
  parseIntCode(0);
  if(var_output == 1)
    passed++;
  endif
  
  var_input = 5;
  var_output = [];
  intcode = [3,3,1108,-1,8,3,4,3,99];
  parseIntCode(0);
  if(var_output == 0)
    passed++;
  endif
  
  % IMM less than tests
  %printf("\r\nIMM less than test\r\n");
  
  var_input = 8;
  var_output = [];
  intcode = [3,3,1107,-1,8,3,4,3,99];
  parseIntCode(0);
  if(var_output == 0)
    passed++;
  endif
  
  var_input = 5;
  var_output = [];
  intcode = [3,3,1107,-1,8,3,4,3,99];
  parseIntCode(0);
  if(var_output == 1)
    passed++;
  endif 
  
  % POS jump
  %printf("\r\nPOS jump test\r\n");
  
  var_input = 0;
  var_output = [];
  intcode = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9];
  parseIntCode(0);
  if(var_output == 0)
    passed++;
  endif
 
  var_input = 5;
  var_output = [];
  intcode = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9];
  parseIntCode(0);
  if(var_output == 1)
    passed++;
  endif   
  
  % IMM jump
  %printf("\r\nIMM jump test\r\n");
  
  var_input = 0;
  var_output = [];
  intcode = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1];
  parseIntCode(0);
  if(var_output == 0)
    passed++;
  endif
  
  var_input = 5;
  var_output = [];
  intcode = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1];
  parseIntCode(0);
  if(var_output == 1)
    passed++;
  endif   
  
  if(passed == 12)
    printf("intcode test 2: ok\r\n");
  else
    printf("intcode test 2: failed\r\n");
  endif
  
endfunction

function testThrusterPhase()
  
  global intcode;
  global var_input;
  global var_output;
  
  passed = 0;
  
  %% test 1
  test_program = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0];
  phase_setting_sequence = [4,3,2,1,0];
  var_output = 0;

  for i = 1:5
    intcode = test_program;
    var_input = [phase_setting_sequence(i),var_output(1)];
    var_output = [];
    parseIntCode(0);
  endfor
  
  if var_output == 43210
    passed++;
  endif
  
  %% test 2
  test_program = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0];
  phase_setting_sequence = [0,1,2,3,4];
  var_output = 0;

  for i = 1:5
    intcode = test_program;
    var_input = [phase_setting_sequence(i),var_output(1)];
    var_output = [];
    parseIntCode(0);
  endfor
  
  if var_output == 54321
    passed++;
  endif
  
  %% test 3
  test_program = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0];
  phase_setting_sequence = [1,0,4,3,2];
  var_output = 0;

  for i = 1:5
    intcode = test_program;
    var_input = [phase_setting_sequence(i),var_output(1)];
    var_output = [];
    parseIntCode(0);
  endfor
  
  if var_output == 65210
    passed++;
  endif
  
    if(passed == 3)
    printf("thruster phase test: ok\r\n");
  else
    printf("thruster phase test: failed\r\n");
  endif
  
endfunction

function testThrusterPhaseFeedback()
  
  global intcode;
  global var_input;
  global var_output;
  global halt;
  
  passed = 0;
  
  %% test 1
  stop = 0;
  test_program_box = [];
  test_program = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5];
  phase_setting_sequence = [9,8,7,6,5];
  var_output = 0;

  for i = 1:5
    test_program_box(i,:) = test_program;
    pc_box(i) = 0;   
  endfor
    
  for i = 1:5
    intcode = test_program_box(i,:);
    var_input = [phase_setting_sequence(i),var_output];
    var_output = [];
    pc_box(i) = parseIntCode(pc_box(i));
    test_program_box(i,:) = intcode;    
  endfor
    
  while 1
    
    for i = 1:5
      intcode = test_program_box(i,:);
      var_input = var_output;
      var_output = [];
      pc_box(i) = parseIntCode(pc_box(i));
      test_program_box(i,:) = intcode;   
      
      if halt == 0
        stop = 1;
        break
      endif
        
    endfor
    
    if stop == 1
      break
    endif    
  
  endwhile
  
  if var_input == 139629729
    passed++;
  endif
  
  %% test 2
  stop = 0;
  test_program_box = [];
  test_program = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10];
  phase_setting_sequence = [9,7,8,5,6];
  var_output = 0;

  for i = 1:5
    test_program_box(i,:) = test_program;
    pc_box(i) = 0;   
  endfor
    
  for i = 1:5
    intcode = test_program_box(i,:);
    var_input = [phase_setting_sequence(i),var_output];
    var_output = [];    
    pc_box(i) = parseIntCode(pc_box(i));
    test_program_box(i,:) = intcode;    
  endfor
    
  while 1
    
    for i = 1:5
      intcode = test_program_box(i,:);
      var_input = var_output;
      var_output = [];
      pc_box(i) = parseIntCode(pc_box(i));
      test_program_box(i,:) = intcode; 
      
      if halt == 0
        stop = 1;
        break
      endif
        
    endfor
    
    if stop == 1
      break
    endif    
  
  endwhile
  
  if var_input == 18216
    passed++;
  endif
  
  if(passed == 2)
    printf("thruster phase feedback test: ok\r\n");
  else
    printf("thruster phase feedback test: failed\r\n");
  endif
  
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

global intcode;

global var_input;
global var_input_index;
global var_output;

global halt;

printf("Advent of Code - 2019 - day 07\r\n");
printf("part 1:\r\n");

testIntCode();
testIntCode2();
testThrusterPhase();

amplifier_program = [3,8,1001,8,10,8,105,1,0,0,21,38,59,84,97,110,191,272,353,434,99999,3,9,1002,9,2,9,101,4,9,9,1002,9,2,9,4,9,99,3,9,102,5,9,9,1001,9,3,9,1002,9,5,9,101,5,9,9,4,9,99,3,9,102,5,9,9,101,5,9,9,1002,9,3,9,101,2,9,9,1002,9,4,9,4,9,99,3,9,101,3,9,9,1002,9,3,9,4,9,99,3,9,102,5,9,9,1001,9,3,9,4,9,99,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,99];

max = 0;
phase_sequence_max = [];
phase_sequences = perms([0,1,2,3,4])';

for phase_sequence = phase_sequences

  var_output = 0;
  
  for i = 1:5
    intcode = amplifier_program;
    var_input = [phase_sequence(i),var_output(1)];
    var_output = [];
    parseIntCode(0);
  endfor
  
  if var_output > max
    max = var_output;
    phase_sequence_max = phase_sequence;
  endif
  
endfor

%max = 338603
%phase_sequence_max = [3,0,2,1,4];

printf("max value: [%d], [%d,%d,%d,%d,%d]\r\n",max,phase_sequence_max(1),phase_sequence_max(2),phase_sequence_max(3),phase_sequence_max(4),phase_sequence_max(5));

printf("part 2:\r\n");

testThrusterPhaseFeedback();

max = 0;
phase_sequence_max = [];
phase_sequences = perms([5,6,7,8,9])';

for phase_sequence = phase_sequences
  
  amplifier_program_box = [];
  amplifier_pc_box = [];
  
  var_output = 0;
  stop = 0;
  
  for i = 1:5
    amplifier_program_box(i,:) = amplifier_program;     
    amplifier_pc_box(i) = 0; 
  endfor
  
  for i = 1:5
    intcode = amplifier_program_box(i,:);
    var_input = [phase_sequence(i),var_output];
    var_output = [];    
    amplifier_pc_box(i) = parseIntCode(amplifier_pc_box(i));
    amplifier_program_box(i,:) = intcode;    
  endfor
  
  while 1
    
    for i = 1:5
      intcode = amplifier_program_box(i,:);
      var_input = var_output;
      var_output = [];
      amplifier_pc_box(i) = parseIntCode(amplifier_pc_box(i));
      amplifier_program_box(i,:) = intcode; 
      
      if halt == 0
        stop = 1;
        break
      endif
        
    endfor
    
    if stop == 1
      break
    endif    
  
  endwhile 
  
  if var_input > max
    max = var_input;
    phase_sequence_max = phase_sequence;
  endif
  
endfor

%max = 63103596;
%phase_sequence_max = [8,5,9,7,6];

printf("max value: [%d], [%d,%d,%d,%d,%d]\r\n",max,phase_sequence_max(1),phase_sequence_max(2),phase_sequence_max(3),phase_sequence_max(4),phase_sequence_max(5));