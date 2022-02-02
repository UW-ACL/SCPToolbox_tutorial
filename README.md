# Tutorials for `SCPToolbox.jl`

- To run the tutorial notebooks out-of-the-box click [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/dmalyuta/SCPToolbox_tutorial/HEAD).
- To set up a complete local installation (including `SCPToolbox.jl`) follow these steps:
  - Install Julia 1.7.1, Python 3.10 and matplotlib 3.5.1.  
  - Clone the `dev/binder` branch of `SCPToolbox.jl` from [here](https://github.com/dmalyuta/scp_traj_opt/tree/dev/binder) in `~/tmp`.
  ```
  $ cd ~/tmp
  $ git clone https://github.com/dmalyuta/scp_traj_opt.git
  $ cd scp_traj_opt 
  $ git checkout dev/binder
  ```
  - Clone this tutorial repository in `~/tmp` and install TeX related packages for plotting scripts in `SCPToolbox.jl`:
  ```
  $ cd ../
  $ git clone https://github.com/dmalyuta/SCPToolbox_tutorial
  $ cd SCPToolbox_tutorial
  $ xargs sudo apt-get install <apt.txt
  ```
  - Activate the `tutorial.jl` package environment in Julia `Pkg` REPL, add `SCPToolbox.jl` as dependency and precompile:
  ```
  $ cd src
  julia> ]
  (@v1.7) pkg> activate ..
  (tutorial) pkg> dev ../../scp_traj_opt/
  (tutorial) pkg> precompile
  ```
  - Re-activate the base Julia environment and install/build `IJulia` package to obtain JupyterLab:
  ```
  (tutorial) pkg> activate
  (@v1.7) pkg> add IJulia
  (@v1.7) pkg> build IJulia
  ```
  - Launch JupyterLab from Julia REPL. (Conda and JupyterLab installation (self-contained in Julia) will be automatically prompted if they don't exist already.)
  ```
  julia> jupyterlab(dir=pwd())
  ```
 
