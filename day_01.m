1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function testMassToFuel()

  if (massToFuel(12) == 2) && (massToFuel(14) == 2) && (massToFuel(1969) == 654) && (massToFuel(100756) == 33583)
    printf("mass to fuel test: ok\r\n");
  else
    printf("mass to fuel test: failed\r\n");  
  endif
  
endfunction

function testFuelToFuel()

  test_input = [14, 1969, 100756];
  test_output = [2, 966, 50346];

  test_fuel = massToFuel(test_input);
  
  if (loopFuel(test_fuel(1)) == test_output(1)) && (loopFuel(test_fuel(2)) == test_output(2)) && (loopFuel(test_fuel(3)) == test_output(3))
    printf("fuel to fuel test: ok\r\n");
  else
    printf("fuel to fuel test: failed\r\n");
  endif
  
endfunction

function fuel = massToFuel(mass)
  
  fuel = floor(mass ./ 3) - 2;
  
endfunction

function fuel_out = fuelToFuel(fuel_in)
  
  fuel_out = floor(fuel_in ./ 3) - 2;
  fuel_out(fuel_out<0) = 0;
  
endfunction

function fuel_out = loopFuel(fuel_in)
  
  total_more_fuel = 0;
  more_fuel = fuel_in;
  
  while(sum(more_fuel) > 0)
    total_more_fuel += more_fuel;
    more_fuel = fuelToFuel(more_fuel);
  end
  
  fuel_out = total_more_fuel;
  
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printf("Advent of Code - 2019 - day 01\r\n");
printf("part 1:\r\n");

testMassToFuel();

modules_mass = load("day_01_modules.txt");
modules_fuel = massToFuel(modules_mass);
fuel_total = sum(modules_fuel);

printf("total fuel: %d\r\n",fuel_total);

printf("\r\n");
printf("part 2:\r\n");

testFuelToFuel();

modules_mass = load("day_01_modules.txt");
modules_fuel = massToFuel(modules_mass);
modules_more_fuel = loopFuel(modules_fuel);

more_fuel_total = sum(modules_more_fuel);

printf("total more fuel: %d\r\n",more_fuel_total);