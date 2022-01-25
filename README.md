# Tutorials for `SCPToolbox.jl`

- To run the tutorial file out-of-the-box click [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/dmalyuta/SCPToolbox_tutorial/HEAD).
- To set up the repository locally follow these steps:
  - Install Python 3.10 and matplotlib 3.5.1.  
  - Clone the `dev/binder` branch of `SCPToolbox.jl` from [here](https://github.com/dmalyuta/scp_traj_opt/tree/dev/binder) in `~/tmp`.
  ```
  $ cd ~/tmp
  $ git clone https://github.com/dmalyuta/scp_traj_opt.git
  $ cd scp_traj_opt 
  $ git checkout dev/binder
  ```
  - Clone this tutorial repository in `~/tmp` and activate the package environment in Julia Pkg REPL:
  ```
  $ cd ../
  $ git clone https://github.com/dmalyuta/SCPToolbox_tutorial
  $ cd SCPToolbox_tutorial/src
  julia> ]
  (@v1.7) pkg> activate ..
  (tutorial) pkg> dev ../../scp_traj_opt/
  (tutorial) pkg> precompile
  (tutorial) pkg> activate
  (@v1.7) pkg> add IJulia
  (@v1.7) pkg> build IJulia
  julia> using IJulia
  julia> jupyterlab(dit=pwd())
  ```
