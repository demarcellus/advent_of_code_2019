1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function digits = numToDigits(num)
  
  digits_string = sprintf("%06d",num);
  digits = digits_string - '0';  
  digits = uint8(digits);
  
endfunction

function output = digitsAreNotDecreasing(digits)

  output = 1;

  if (digits(2) < digits(1)) || (digits(3) < digits(2)) || (digits(4) < digits(3)) || (digits(5) < digits(4)) || (digits(6) < digits(5))
    output = 0;
  endif 
  
endfunction

function output = digitsContainsPair(digits)
  
  output = 0;
  
  for i = 1:6
    
    same_digits = (digits == digits(i));
    if(sum(same_digits) >= 2)
      output = 1;
      return;
    endif
        
  endfor
   
endfunction

function output = digitsContainsPairNotPartOfLargerGroup(digits)
  
  output = 0;
  
  for i = 1:6
    
    same_digits = digits == digits(i);
    if(sum(same_digits) == 2)
      output = 1;
      return;
    endif
    
  endfor
    
endfunction

function testDigits()
 
  number = 111111;
  digits = numToDigits(number);
  if (digitsAreNotDecreasing(digits) == 1) && (digitsContainsPair(digits) == 1)
    printf("case '%d' ok\r\n", number);
  else
    printf("case '%d' failed\r\n", number);    
  endif
  
  number = 223450;
  digits = numToDigits(number);
  if (digitsAreNotDecreasing(digits) == 0) && (digitsContainsPair(digits) == 1)
    printf("case '%d' ok\r\n", number);
  else
    printf("case '%d' failed\r\n", number);    
  endif
  
  number = 123789;
  digits = numToDigits(number);
  if (digitsAreNotDecreasing(digits) == 1) && (digitsContainsPair(digits) == 0)
    printf("case '%d' ok\r\n", number);
  else
    printf("case '%d' failed\r\n", number);    
  endif
 
endfunction

function testDigitsPart2()
  
  number = 112233;
  digits = numToDigits(number);
  if (digitsAreNotDecreasing(digits) == 1) && (digitsContainsPairNotPartOfLargerGroup(digits) == 1)
    printf("case '%d' ok\r\n", number);
  else
    printf("case '%d' failed\r\n", number);    
  endif
  
  number = 123444;
  digits = numToDigits(number);
  if (digitsAreNotDecreasing(digits) == 1) && (digitsContainsPairNotPartOfLargerGroup(digits) == 0)
    printf("case '%d' ok\r\n", number);
  else
    printf("case '%d' failed\r\n", number);    
  endif
  
  number = 111122;
  digits = numToDigits(number);
  if (digitsAreNotDecreasing(digits) == 1) && (digitsContainsPairNotPartOfLargerGroup(digits) == 1)
    printf("case '%d' ok\r\n", number);
  else
    printf("case '%d' failed\r\n", number);    
  endif
  
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lower = 138307;
upper = 654504;

printf("Advent of Code - 2019 - day 04\r\n");
printf("part 1:\r\n");

testDigits();

count = 0;

for number = lower:upper
  
  digits = numToDigits(number);
  if (digitsAreNotDecreasing(digits) == 1) && (digitsContainsPair(digits) == 1)
    count += 1;
  endif
  
endfor

%count = 1855;

printf("[%d] numbers found\r\n",count);

printf("part 2:\r\n");

testDigitsPart2();

count = 0;

for number = lower:upper
  
  digits = numToDigits(number);
  if (digitsAreNotDecreasing(digits) == 1) && (digitsContainsPairNotPartOfLargerGroup(digits) == 1)
    count += 1;
  endif

endfor

%count = 1253

printf("[%d] numbers found\r\n",count);