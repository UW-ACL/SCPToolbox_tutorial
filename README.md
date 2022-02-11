# Tutorials for `SCPToolbox.jl` by [ACL](https://depts.washington.edu/uwacl/)

## To run the tutorial notebooks out-of-the-box:

  - (Binder) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/UW-ACL/SCPToolbox_tutorial/master?labpath=tutorial%2Fsrc%2Fp1_clp.ipynb)
  - (GESIS Binder) [![Binder](https://notebooks.gesis.org/binder/badge_logo.svg)](https://notebooks.gesis.org/binder/v2/gh/UW-ACL/SCPToolbox_tutorial/master?labpath=tutorial%2Fsrc%2Fp1_clp.ipynb)

## To set up a complete local installation (including `SCPToolbox.jl`) follow these steps:

  - Install `Julia v1.7.1`, `Python 3.10`, `matplotlib 3.5.1`, and `ffmpeg`.  
  - Clone the `master` branch of `SCPToolbox.jl` from [here](https://github.com/UW-ACL/SCPToolbox.jl/tree/master) into `~/tmp`.
  ```
  $ cd ~/tmp
  $ git clone https://github.com/UW-ACL/SCPToolbox.jl.git
  $ cd SCPToolbox.jl
  $ git checkout master
  ```
  - Clone this tutorial repository into `~/tmp` and install TeX-related packages for plotting scripts in `SCPToolbox.jl`:
  ```
  $ cd ../
  $ git clone https://github.com/UW-ACL/SCPToolbox_tutorial.git
  $ cd SCPToolbox_tutorial
  $ xargs sudo apt-get install <apt.txt
  ```
  - Activate the `tutorial.jl` package environment in Julia `Pkg` REPL, add `SCPToolbox.jl` as a dependency and precompile:
  ```
  $ cd src
  julia> ]
  (@v1.7) pkg> activate ..
  (tutorial) pkg> dev ../../SCPToolbox.jl/
  (tutorial) pkg> precompile
  ```
  - Re-activate the base Julia environment and install/build the `IJulia` package to obtain JupyterLab:
  ```
  (tutorial) pkg> activate
  (@v1.7) pkg> add IJulia
  (@v1.7) pkg> build IJulia
  ```
  - Launch JupyterLab from Julia REPL. (Conda and JupyterLab installation (self-contained in Julia) will be automatically prompted if they don't exist already.)
  ```
  julia> jupyterlab(dir=pwd())
  ```
  
## To generate slides from a Jupyter notebook:

### Slide creation rubric

| Slide             | Menu option  | Command       |
| ----------------- | ------------ | ------------- |
| New               | `Slide Type` | `Slide`       |
| Persistent        | `Slide Type` | `Fragment`    |
| Hide input only   | `Add Tag`    | `hide-input`  |
| Hide output only  | `Add Tag`    | `hide-output` |
| Hide entire cell  | `Slide Type` | `Skip`        |

### Example command

```
jupyter nbconvert --output-dir='slides' p1_clp.ipynb --to slides --no-prompt --TagRemovePreprocessor.remove_input_tags={\"hide-input\"} --TagRemovePreprocessor.remove_all_outputs_tags={\"hide-output\"} --post serve
```
## To land on the Moon:

 - [Notebook](https://nbviewer.org/github/UW-ACL/SCPToolbox_tutorial/blob/535fa41cf2fb65506225d77fb9f6e74de9257045/src/p4_rocket_solutions.ipynb)
