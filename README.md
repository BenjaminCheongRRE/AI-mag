# MATLAB Inductor Optimization with FEM/AMM

**MATLAB** toolbox (using also COMSOL and Python) for **power electronic inductor optimization**. 
The goal of this tool is to combine the **accuracy of the *Finite Element Method** with the **speed** of semi-numerical model by using **Artificial Neural Network (ANN)**.

More precisely, the following **worflow** is implemented:
* Simulating many designs with **FEM thermal and magnetic** simulations (COMSOL)
* Extracting the important figures of merit out of the FEM simulations
* Extracting the same figures of merit with a simplified analytical model (for comparison)
* **Training regression ANNs** to reproduce the figures of merit (MATLAB or Python Keras and TensorFlow)
* Using the ANNs**, **quickly** generate **accurate inductor designs**
* **Multi-objective** data exploration with a **GUI**

The following performance are achieved:
* The **average error* between the FEM simulations and the ANN predictions is below **1%** 
* The **worst-case error* between the FEM simulations and the ANN predictions is below **8%** 
* The tool is able for generate more than **5000 valid designs per second** on a laptop computer
    * [run_ann_example.m](ann_example/run_ann_example.m) - the MATLAB main file
    * [run_ann_server.py](ann_example/run_ann_server.py) - the Python ANN server main file
    * Shell script (Linux) and (batch) script (MS Windows) for starting the Python ANN server

## Getting Started / Example

The following code structure is considered:
* [ressources](ressources) - Different ressources which are not directly used in the toolbox
* [source_ann](source_ann) - ANN library for regression/fitting (standalone code with examples)
* [source_inductor](source_inductor) - Source code for the FEM/ANN inductor design tool
* [source_input](source_input) - Input data and parameters defined by the user
* [source_input](source_input) - Input data and parameters defined by the user
* [init_toolbox.m](init_toolbox.m) - Load the MATLAB toolbox
* [run_0_init.m](run_0_init.m) - Init the simulations with constant data
* [run_1_fem.m](run_1_fem.m) - Run the different FEM simulations
* [run_2_assemble.m](run_2_assemble.m) - Assemble the FEM simulations results, add the analytical solutions
* [run_3_train.m](run_3_train.m) - Train the regressions with ANNs with simulation results
* [run_4_export.m](run_4_export.m) - Export the ANNs in prevision of the evaluation of inductor designs 
* [run_5_compute.m](run_5_compute.m) - Simulate many inductor designs with the help of the ANNs
* [run_6_plot.m](run_6_plot.m) - Plot the results in a GUI
* [run_ann_server.py](run_ann_server.py) - Python ANN server for using Keras and TensorFlow from MATLAB
* Shell script (Linux) and (batch) script (MS Windows) for starting the Python ANN server
* Shell script (Linux) and (batch) script (MS Windows) for starting the COMSOL MATLAB Livelink

The example shows the complete worflow: FEM simulations, ANN training, design generation, and display with GUI:
* The inductor of a DC-DC Buck converter is optimized
* The converter has the following ratings: 2kW, 400V input voltage, 200V output voltage

## Optimized Inductor

Currently the following inductors are optimized:
* E-core inductor with an air-gap (with fringing field)
* Ferrite core (with loss map, DC bias, and IGSE)
* Litz wire winding (no packing model, with proximity losses)
* Forced convection cooling
* Sinus or PWM excitation (with DC bias)
* Coupled thermal/loss models

However, this toolbox is made in order to be **easily extended** with other inductors types or with other magnetic components (e.g., transformers, chokes).

## Compatibility

The toolbox was tested with the following MATLAB setup:
* Tested with MATLAB R2018b
* MATLAB Deep Learning Toolbox ("neural_network_toolbox")
* MATLAB Global Optimization Toolbox ("gads_toolbox")
* MATLAB Optimization Toolbox ("optimization_toolbox")
* MATLAB Signal Processing Toolbox ("signal_toolbox")

The toolbox was tested with the following COMSOL setup (for FEM simulations):
* COMSOL Multiphysics 5.4
* AC/DC Module (for the magnetic simulation)
* Heat Transfer Module (for the thermal simulation)
* CAD Import Module (for 3d geometry manipulation)
* MATLAB Livelink

It should be noted that COMSOL is only required to run the FEM simulations, not for the ANN/regression or the inductor design evaluation.
In other word, COMSOL is required to generate the ANN training set, but not for running the design tool.

The toolbox was tested with the following Python setup (for ANN with Keras and TensorFlow):
* Tested with Python 3.6.8
* Numpy 1.18.1
* TensorFlow 2.1.0

However, the toolbox can work without Python, as long as the Python ANN engine is not used.

The toolbox was tested with the following operating system:
* Linux Ubuntu 18.04.4 LTS
* Microsoft Windows 10

The following software were used to generate ressources but are not required to run the code:
* Adobe Illustrator 2020 - generating the GUI artwork
* Wolfram Mathematica 12 - generating analytical solutions

## Author

**Thomas Guillod, ETH Zurich, Power Electronic Systems Laboratory** - [GitHub Profile](https://github.com/otvam)

## Acknowledgement

* Prof. J.W. Kolar, ETH Zurich, Power Electronic Systems Laboratory
* P. Papamanolis, ETH Zurich, Power Electronic Systems Laboratory
* Keras and TensorFlow communities

## License

* This project is licensed under the **xxx License**, see [LICENSE.md](LICENSE.md).
* This project is copyrighted by: (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod.