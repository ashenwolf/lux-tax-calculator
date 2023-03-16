# Development Log

## March 04, 2023

- Attempted toimplement the logic on the front-end side using Tau Prolog. The straightforward scenario worked fine,
  although there are some limitations: no CLP(R) support, list destructuring not always work inside predicate, etc.

## March 05, 2023

- The code previously writen for Tau Prolog worked flawlessly in SWI.
- Switched from predicates to CLP(R) constraints. The amount of code slightly reduced. However, the original implementation
  of progressive tax calculation does not work in reverse. Probably because of the carryover passed in recursion.
- Switch the algorithm, to the one without carryover (by reversing the order of processing tax slots), and it fixed
  the issue with reverse calculation.
- Refactored the deduction calculation into separate predicates.
- Added support for specifying monthly/yearly calculation, but it required to support 4 predicate signatures with
  different monlthly/yearly combinations. TODO: check if we can do it via conditional syntax (e.g. `cond -> if_true ; if_false`)
