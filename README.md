# The Luxembourg Personal Income Tax Calculator

A simple page to play around the numbers and see how different taxation classes affect you,
simulte the raises, or adjustments.

See [Development Log](/DEVLOG.md) for details.

## Prolog libraries in use

- CLP(R)
- TBD

## How to use

Start prolog shell in the working folder
```shell
$ swipl
Welcome to SWI-Prolog (threaded, 64 bits, version 9.0.4)

% Load libraries (for some reason it is not loaded when using consult/1)
?- use_module(library(clpr)).
true.

?- use_module(library(apply)).
true.

% load the calculator logic
?- consult(src/tax).
true.
```

Then you can query like:

```prolog
% Calculate monthly Net wage from Monthly Gross
?- lux_tax(monthly(5000), monthly(Net, _, _, _, _)).
Net = 3467.43426 .

% calculate the needed yearly Gross amount to have specific monthly Net.
% Provide intermediate tax and deductions calculation results
?- lux_tax(yearly(Gross), monthly(5000, D, AD, TI, Tax)).
Gross = 96003.54123393468,
D = 884.0326088624818,
AD = deductions{healthcare:2688.099154550171, healthcare_contrib:240.00885308483672, pension:7680.283298714775, unemployment:1246.8884572750856},
TI = 7099.762493965407,
Tax = 1995.855122525817 .

```

## License

MIT

## Author

Sergii Gulenok <sergii.gulenok@gmail.com>
