# Enumeration of PL Balls

This project is an on-going implementation of some of the algorithms described in "The Number of four dimensional PL spheres with nine vertices" using SageMath. Its main purpose is to make the list of four dimensional PL spheres with nine vertices easily available in a format suitable for use on SageMath and other programming languages to facilitate research around these objects. 

It currenty includes tools for performing bistellar flips and doing a BFS search of simplicial complexes connected by bistellar flip of certain types. 

These tools are used to produce all simplicial complexes that are connected to dC(5, 9) by bistellar flips while excluding 0-moves and 4-moves. By the results in "The Number of four dimensional PL spheres with nine vertices", these are exactly the four dimensional PL spheres with nine vertices. 

## Requirements
- [SageMath](https://www.sagemath.org/) ≥ 9.0
- Python ≥ 3.10 (if running Sage through `sage -python`)

## TO-DOs
- Add more documentation about the datasets and the .sage files in README.md
- Include proper research citations in README.md
- Implement the functions in lexicographic_enumaration.sage, which are an implementation of Algorithm 4.4. 
- Refactor datasets in their own folder.
- Implement a function that checks if two complexes are PL-homeomorphic.
